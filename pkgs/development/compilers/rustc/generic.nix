{ stdenv, fetchurl, fetchgit, fetchzip, file, python2, tzdata, procps
, llvmPackages, jemalloc, ncurses, zlib

, shortVersion, isRelease
, forceBundledLLVM ? false
, srcSha, srcRev ? ""
, snapshotHashLinux686, snapshotHashLinux64
, snapshotHashDarwin686, snapshotHashDarwin64
, snapshotDate, snapshotRev
, configureFlags ? []

, patches
}:

assert !stdenv.isFreeBSD;

/* Rust's build process has a few quirks :

- The Rust compiler is written is Rust, so it requires a bootstrap
  compiler, which is downloaded during the build. To make the build
  pure, we download it ourself before and put it where it is
  expected. Once the language is stable (1.0) , we might want to
  switch it to use nix's packaged rust compiler. This might not be possible
  as the compiler is highly coupled to the bootstrap.

NOTE : some derivation depend on rust. When updating this, please make
sure those derivations still compile. (racer, for example).

*/

assert (if isRelease then srcRev == "" else srcRev != "");

let version = if isRelease then
        "${shortVersion}"
      else
        "${shortVersion}-g${builtins.substring 0 7 srcRev}";

    name = "rustc-${version}";

    llvmShared = llvmPackages.llvm.override { enableSharedLibraries = true; };

    platform = if stdenv.system == "i686-linux"
      then "linux-i386"
      else if stdenv.system == "x86_64-linux"
      then "linux-x86_64"
      else if stdenv.system == "i686-darwin"
      then "macos-i386"
      else if stdenv.system == "x86_64-darwin"
      then "macos-x86_64"
      else abort "no snapshot to bootstrap for this platform (missing platform url suffix)";

    target = if stdenv.system == "i686-linux"
      then "i686-unknown-linux-gnu"
      else if stdenv.system == "x86_64-linux"
      then "x86_64-unknown-linux-gnu"
      else if stdenv.system == "i686-darwin"
      then "i686-apple-darwin"
      else if stdenv.system == "x86_64-darwin"
      then "x86_64-apple-darwin"
      else abort "no snapshot to bootstrap for this platform (missing target triple)";

    meta = with stdenv.lib; {
      homepage = http://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ madjar cstrahan wizeman globin havvy wkennington ];
      license = [ licenses.mit licenses.asl20 ];
      platforms = platforms.linux;
    };

    snapshotHash = if stdenv.system == "i686-linux"
      then snapshotHashLinux686
      else if stdenv.system == "x86_64-linux"
      then snapshotHashLinux64
      else if stdenv.system == "i686-darwin"
      then snapshotHashDarwin686
      else if stdenv.system == "x86_64-darwin"
      then snapshotHashDarwin64
      else abort "no snapshot for platform ${stdenv.system}";
    snapshotName = "rust-stage0-${snapshotDate}-${snapshotRev}-${platform}-${snapshotHash}.tar.bz2";
in

with stdenv.lib; stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  __impureHostDeps = [ "/usr/lib/libedit.3.dylib" ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-rpath ${llvmShared}/lib";

  src = if isRelease then
      fetchzip {
        url = "http://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
        sha256 = srcSha;
      }
    else
      fetchgit {
        url = https://github.com/rust-lang/rust;
        rev = srcRev;
        sha256 = srcSha;
      };

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  snapshot = stdenv.mkDerivation {
    name = "rust-stage0";
    src = fetchurl {
      url = "http://static.rust-lang.org/stage0-snapshots/${snapshotName}";
      sha1 = snapshotHash;
    };
    dontStrip = true;
    installPhase = ''
      mkdir -p "$out"
      cp -r bin "$out/bin"
    '' + optionalString stdenv.isLinux ''
      patchelf --interpreter "${stdenv.libc}/lib/${stdenv.cc.dynamicLinker}" \
               --set-rpath "${stdenv.cc.cc}/lib/:${stdenv.cc.cc}/lib64/" \
               "$out/bin/rustc"
    '';
  };

  configureFlags = configureFlags
                ++ [ "--enable-local-rust" "--local-rust-root=$snapshot" "--enable-rpath" ]
                # ++ [ "--jemalloc-root=${jemalloc}/lib"
                ++ [ "--default-linker=${stdenv.cc}/bin/cc" "--default-ar=${stdenv.cc.binutils}/bin/ar" ]
                ++ optional (stdenv.cc.cc ? isClang) "--enable-clang"
                ++ optional (!forceBundledLLVM) "--llvm-root=${llvmShared}";

  inherit patches;

  postPatch = ''
    substituteInPlace src/rust-installer/gen-install-script.sh \
      --replace /bin/echo "$(type -P echo)"
    substituteInPlace src/rust-installer/gen-installer.sh \
      --replace /bin/echo "$(type -P echo)"

    # Workaround for NixOS/nixpkgs#8676
    substituteInPlace mk/rustllvm.mk \
      --replace "\$\$(subst  /,//," "\$\$(subst /,/,"

    # Fix dynamic linking against llvm
    ${optionalString (!forceBundledLLVM) ''sed -i 's/, kind = \\"static\\"//g' src/etc/mklldeps.py''}

    # Fix not filtering out -L lines from llvm-config
    sed -i '\#if len(lib) == 1#a\        continue\n    if lib[0:2] == "-L":' src/etc/mklldeps.py
    cat src/etc/mklldeps.py

    # Fix the configure script to not require curl as we won't use it
    sed -i configure \
      -e '/probe_need CFG_CURLORWGET/d'

    # Fix the use of jemalloc prefixes which our jemalloc doesn't have
    # TODO: reenable if we can figure out how to get our jemalloc to work
    #[ -f src/liballoc_jemalloc/lib.rs ] && sed -i 's,je_,,g' src/liballoc_jemalloc/lib.rs
    #[ -f src/liballoc/heap.rs ] && sed -i 's,je_,,g' src/liballoc/heap.rs # Remove for 1.4.0+

    # Useful debugging parameter
    #export VERBOSE=1
  '';

  preConfigure = ''
    # Needed flags as the upstream configure script has a broken prefix substitution
    configureFlagsArray+=("--datadir=$out/share")
    configureFlagsArray+=("--infodir=$out/share/info")
  '';

  # ps is needed for one of the test cases
  nativeBuildInputs = [ file python2 procps ];
  buildInputs = [ ncurses zlib ] ++ optional (!forceBundledLLVM) llvmShared;

  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  preCheck = "export TZDIR=${tzdata}/share/zoneinfo";

  doCheck = true;

  # Often fails with:
  #   /tmp/nix-build-rustc-1.6.0.drv-0/rustc-1.6.0-src.tar.gz/mk/tests.mk:1087: recipe for target 'x86_64-unknown-linux-gnu/test/run-make/compiler-lookup-paths-2-T-x86_64-unknown-linux-gnu-H-x86_64-unknown-linux-gnu.ok' failed
  #   make: *** [x86_64-unknown-linux-gnu/test/run-make/compiler-lookup-paths-2-T-x86_64-unknown-linux-gnu-H-x86_64-unknown-linux-gnu.ok] Error 2
  parallelCheck = false;
}
