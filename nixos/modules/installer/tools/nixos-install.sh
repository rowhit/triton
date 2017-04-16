#! @shell@

# - make Nix store etc.
# - copy closure of Nix to target device
# - register validity
# - with a chroot to the target device:
#   * nix-env -p /nix/var/nix/profiles/system -i <nix-expr for the configuration>
#   * install the boot loader



# Ensure a consistent umask.
umask 0022

# Create FHS for Triton relative to mountpoint ($1).
create_triton_fhs() {
  local -A -r directories=(
    ['bin']='0755'  # /bin/sh
    ['dev']='0755'
    ['etc']='0755'
    ['etc/ssl']='0755'
    ['etc/ssl/certs']='0755'
    ['home']='0755'
    ['nix']=0755
    ['nix/store']='1775'
    ['nix/var']='0755'
    ['nix/var/log']='0755'
    ['nix/var/log/nix']='0755'
    ['nix/var/log/nix/drvs']='0755'
    ['nix/var/nix']='0755'
    ['nix/var/nix/db']='0755'
    ['nix/var/nix/gcroots']='0755'
    ['nix/var/nix/manifests']='0755'
    ['nix/var/nix/profiles']='0755'
    ['nix/var/nix/profiles/per-user']='1777'
    ['nix/var/nix/profiles/per-user/root']='0755'
    ['nix/var/nix/temproots']='0755'
    ['nix/var/userpool']='0755'
    ['proc']='0755'
    ['root']='0700'
    ['root/.nix-defexpr']='0700'
    ['run']='0755'
    ['sys']='0755'
    ['tmp']='01777'
    ['tmp/root']='0755'
    ['usr']='0755'
    ['usr/bin']='0755'  # /usr/bin/env
    ['var']='0755'
    ['var/setuid-wrappers']='0755'
  )
  local directory
  local -r mount_point="${1}"

  # Create directory structure relative to $mount_point.
  for directory in "${!directories[@]}"; do
    if [ -d "${mount_point}/${directory}" ]; then
      chown --verbose "${directories["${directory}"]}" \
        "${mount_point}/${directory}" || {
          echo "ERROR: failed to set permissions for directory: ${mount_point}/${directory}" >&2
          return 1
        }
    else
      # Do NOT specify --parents to make sure the directory structure is
      # unrolled correctly.  Instead specify the parent directories in
      # the array above so that the structure is created with the correct
      # permissions.
      mkdir \
        --verbose \
        --mode="${directories["${directory}"]}" \
        "${mount_point}/${directory}" || {
          echo "ERROR: failed to create directory: ${mount_point}/${directory}" >&2
          return 1
        }
    fi
  done
}

# Re-exec ourselves in a private mount namespace so that our bind
# mounts get cleaned up automatically.
if [ "$(id -u)" = 0 ]; then
  if [ -z "$NIXOS_INSTALL_REEXEC" ]; then
    export NIXOS_INSTALL_REEXEC=1
    exec unshare --mount --uts -- "$0" "$@"
  else
    mount --verbose --make-rprivate /
  fi
fi

# Parse the command line for the -I flag
extraBuildFlags=()
chrootCommand=(/run/current-system/sw/bin/bash)
buildUsersGroup="nixbld"

while [ "$#" -gt 0 ]; do
  i="$1"; shift 1
  case "$i" in
    --max-jobs|-j|--cores|-I)
      j="$1"; shift 1
      extraBuildFlags+=("$i" "$j")
      ;;
    --option)
      j="$1"; shift 1
      k="$1"; shift 1
      extraBuildFlags+=("$i" "$j" "$k")
      ;;
    --root)
      mountPoint="$1"; shift 1
      ;;
    --closure)
      closure="$1"; shift 1
      buildUsersGroup=""
      ;;
    --no-channel-copy)
      noChannelCopy=1
      ;;
    --no-root-passwd)
      noRootPasswd=1
      ;;
    --no-bootloader)
      noBootLoader=1
      ;;
    --show-trace)
      extraBuildFlags+=("$i")
      ;;
    --chroot)
      runChroot=1
      if [[ "$@" != "" ]]; then
        chrootCommand=("$@")
      fi
      break
      ;;
    --help)
      exec man nixos-install
      exit 1
      ;;
    *)
      echo "$0: unknown option \`$i'"
      exit 1
      ;;
  esac
done

set -e
shopt -s nullglob

if test -z "$mountPoint"; then
  mountPoint=/mnt
fi

if ! test -e "$mountPoint"; then
  echo "mount point $mountPoint doesn't exist"
  exit 1
fi


create_triton_fhs


# Mount some stuff in the target root directory.
mount --verbose --rbind /dev $mountPoint/dev
mount --verbose --rbind /proc $mountPoint/proc
mount --verbose --rbind /sys $mountPoint/sys
mount --verbose --rbind / $mountPoint/tmp/root
mount --verbose --types tmpfs --options "mode=0755" none $mountPoint/run
mount --verbose --types tmpfs --options "mode=0755" none $mountPoint/var/setuid-wrappers
rm --verbose --recursive --force $mountPoint/var/run
ln --verbose --symbolic /run $mountPoint/var/run
for f in /etc/resolv.conf /etc/hosts; do rm --verbose --force $mountPoint/$f; [ -f "$f" ] && cp --dereference --force $f $mountPoint/etc/; done
for f in /etc/passwd /etc/group; do touch $mountPoint/$f; [ -f "$f" ] && mount --rbind --options ro $f $mountPoint/$f; done
for f in /etc/ssl/certs/ca-certificates.crt; do rm --verbose --force $mountPoint/$f; [ -f "$f" ] && cp --dereference --force $f $mountPoint/$f; done

if [ -n "$runChroot" ]; then
  if ! [ -L $mountPoint/nix/var/nix/profiles/system ]; then
    echo "$0: installation not finished; cannot chroot into installation directory"
    exit 1
  fi
  ln --verbose --symbolic /nix/var/nix/profiles/system $mountPoint/run/current-system
  exec chroot $mountPoint "${chrootCommand[@]}"
fi


# Get the path of the NixOS configuration file.
if test -z "$NIXOS_CONFIG"; then
  NIXOS_CONFIG=/etc/nixos/configuration.nix
fi

if [ ! -e "$mountPoint/$NIXOS_CONFIG" ] && [ -z "$closure" ]; then
  echo "configuration file $mountPoint/$NIXOS_CONFIG doesn't exist"
  exit 1
fi


chown @root_uid@:@nixbld_gid@ $mountPoint/nix/store


# There is no daemon in the chroot.
unset NIX_REMOTE


# We don't have locale-archive in the chroot, so clear $LANG.
export LANG=
export LC_ALL=
export LC_TIME=


# Builds will use users that are members of this group
extraBuildFlags+=(--option "build-users-group" "$buildUsersGroup")


# Inherit binary caches from the host
binary_caches="$(@perl@/bin/perl -I @nix@/lib/perl5/site_perl/*/* -e 'use Nix::Config; Nix::Config::readConfig; print $Nix::Config::config{"binary-caches"};')"
extraBuildFlags+=(--option "binary-caches" "$binary_caches")


# Copy Nix to the Nix store on the target device, unless it's already there.
if ! NIX_DB_DIR=$mountPoint/nix/var/nix/db nix-store --check-validity @nix@ 2> /dev/null; then
  echo "copying Nix to $mountPoint...."
  for i in $(@perl@/bin/perl @pathsFromGraph@ @nixClosure@); do
    echo "  $i"
    chattr -R -i $mountPoint/$i 2> /dev/null || true # clear immutable bit
    @rsync@/bin/rsync --verbose --archive $i $mountPoint/nix/store/
  done

  # Register the paths in the Nix closure as valid.  This is necessary
  # to prevent them from being deleted the first time we install
  # something.  (I.e., Nix will see that, e.g., the glibc path is not
  # valid, delete it to get it out of the way, but as a result nothing
  # will work anymore.)
  chroot $mountPoint @nix@/bin/nix-store --register-validity < @nixClosure@
fi


# !!! assuming that @shell@ is in the closure
ln --verbose --symbolic --force @shell@ $mountPoint/bin/sh


# Build hooks likely won't function correctly in the minimal chroot; just disable them.
unset NIX_BUILD_HOOK

# Make the build below copy paths from the CD if possible.  Note that
# /tmp/root in the chroot is the root of the CD.
export NIX_OTHER_STORES=/tmp/root/nix:$NIX_OTHER_STORES

p=@nix@/libexec/nix/substituters
export NIX_SUBSTITUTERS=$p/copy-from-other-stores.pl:$p/download-from-binary-cache.pl


# Make manifests available in the chroot.
rm --verbose --force $mountPoint/nix/var/nix/manifests/*
for i in /nix/var/nix/manifests/*.nixmanifest; do
  chroot $mountPoint @nix@/bin/nix-store -r "$(readlink --canonicalize "$i")" > /dev/null
  cp --verbose --preserve="links,mode,ownership,timestamps" --no-dereference "$i" $mountPoint/nix/var/nix/manifests/
done


if [ -z "$closure" ]; then
  # Get the absolute path to the NixOS/Nixpkgs sources.
  nixpkgs="$(readlink --canonicalize $(nix-instantiate --find-file nixpkgs))"

  nixEnvAction="-f <nixpkgs/nixos> --set -A system"
else
  nixpkgs=""
  nixEnvAction="--set $closure"
fi

# Build the specified Nix expression in the target store and install
# it into the system configuration profile.
echo "building the system configuration..."
NIX_PATH="nixpkgs=/tmp/root/$nixpkgs:nixos-config=$NIXOS_CONFIG" NIXOS_CONFIG= \
  chroot $mountPoint @nix@/bin/nix-env \
  "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/system $nixEnvAction


# Copy the NixOS/Nixpkgs sources to the target as the initial contents
# of the NixOS channel.
srcs=$(nix-env "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/per-user/root/channels -q nixos --no-name --out-path 2>/dev/null || echo -n "")
if [ -z "$noChannelCopy" ] && [ -n "$srcs" ]; then
  echo "copying NixOS/Nixpkgs sources..."
  chroot $mountPoint @nix@/bin/nix-env \
      "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/per-user/root/channels -i "$srcs" --quiet
fi
ln --verbose --symbolic --force --no-dereference /nix/var/nix/profiles/per-user/root/channels $mountPoint/root/.nix-defexpr/channels


# Get rid of the /etc bind mounts.
for f in /etc/passwd /etc/group; do [ -f "$f" ] && umount --verbose $mountPoint/$f; done


# Grub needs an mtab.
ln --symbolic --force --no-dereference /proc/mounts $mountPoint/etc/mtab


# Mark the target as a NixOS installation, otherwise
# switch-to-configuration will chicken out.
touch $mountPoint/etc/NIXOS


# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
echo "finalising the installation..."
if [ -z "$noBootLoader" ]; then
  NIXOS_INSTALL_BOOTLOADER=1 chroot $mountPoint \
    /nix/var/nix/profiles/system/bin/switch-to-configuration boot
fi

# Run the activation script.
chroot $mountPoint /nix/var/nix/profiles/system/activate


# Ask the user to set a root password.
if [ -z "$noRootPasswd" ] && [ -x $mountPoint/var/setuid-wrappers/passwd ] && [ -t 0 ]; then
  echo "setting root password..."
  chroot $mountPoint /var/setuid-wrappers/passwd
fi


echo "installation finished!"
