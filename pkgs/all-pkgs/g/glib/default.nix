{ stdenv
, autoreconfHook
, fetchTritonPatch
, fetchurl
, gettext
, perl
, python

, attr
, elfutils
, libffi
, libselinux
, pcre
, util-linux_lib
, zlib
}:

let
  inherit (stdenv.lib)
    boolEn
    optionals
    optionalString;

  # Some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>.
  # This is intended to be run in postInstall of any package
  # which has $out/include/ containing just some disjunct directories.
  flattenInclude = ''
    for dir in "$out"/include/* ; do
      cp -r "$dir"/* "$out/include/"
      rm -r "$dir"
      ln -s . "$dir"
    done
    ln -sr -t "$out/include/" "$out"/lib/*/include/* 2>/dev/null || true
  '';

  channel = "2.54";
  version = "${channel}.2";
in

assert stdenv.cc.isGNU;

stdenv.mkDerivation rec {
  name = "glib-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${channel}/${name}.tar.xz";
    hashOutput = false;
    sha256 = "bb89e5c5aad33169a8c7f28b45671c7899c12f74caf707737f784d7102758e6c";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    perl
    python
  ];

  buildInputs = [
    attr
    elfutils
    libffi
    libselinux
    pcre
    stdenv.libc
    util-linux_lib
    zlib
  ];

  setupHook = ./setup-hook.sh;
  selfApplySetupHook = true;

  postPatch = /* Don't build tests, also prevents extra deps */ ''
    sed -i {.,gio,glib}/Makefile.{am,in} \
      -e 's/ tests//'
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    # FIXME: Figure out why disabling debug causes segfaults in applications
    #        using glib.  It seems like glib asserts may be triggering
    #        segfaults, but more debugging is needed.
    #"--disable-debug"
    "--disable-gc-friendly"
    "--enable-mem-pools"
    "--enable-rebuilds"
    "--disable-installed-tests"
    "--disable-always-build-tests"
    "--enable-largefile"
    "--disable-included-printf"
    "--${boolEn (libselinux != null)}-selinux"
    "--disable-fam"
    "--${boolEn (attr != null)}-xattr"  # glibc or attr
    "--${boolEn (elfutils != null)}-libelf"
    "--${boolEn (util-linux_lib != null)}-libmount"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-man"
    "--disable-dtrace"
    "--disable-systemtap"
    "--disable-coverage"
    "--enable-Bsymbolic"
    "--enable-znodelete"
    "--enable-compile-warnings"
    # The internal pcre is not patched to support gcc5, among other
    # fixes specific to Triton
    "--with-pcre=system"
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  passthru = {
    gioModuleDir = "lib/gio-modules/${name}/gio/modules";
    inherit flattenInclude;

    srcVerification = fetchurl {
      inherit (src)
        outputHash
        outputHashAlgo
        urls;
      sha256Url = "https://download.gnome.org/sources/glib/${channel}/"
        + "${name}.sha256sum";
      failEarly = true;
    };
  };

  meta = with stdenv.lib; {
    description = "C library of programming buildings blocks";
    homepage = http://www.gtk.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
