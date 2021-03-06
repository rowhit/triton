{ stdenv
, fetchurl
, which

, kmod
, zlib
}:

let
  name = "pciutils-3.5.5"; # with database from 2016-01

  tarballUrls = [
    "mirror://kernel/software/utils/pciutils/${name}.tar"
  ];
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    urls = map (n: "${n}.xz") tarballUrls;
    hashOutput = true;
    sha256 = "1d62f8fa192f90e61c35a6fc15ff3cb9a7a792f782407acc42ef67817c5939f5";
  };

  nativeBuildInputs = [
    which
  ];

  buildInputs = [
    kmod
    zlib
  ];

  preBuild = ''
    makeFlagsArray+=(
      "SHARED=yes"
      "PREFIX=$out"
    )
  '';

  installTargets = [
    "install"
    "install-lib"
  ];

  # Get rid of update-pciids as it won't work.
  postInstall = ''
    rm $out/sbin/update-pciids $out/man/man8/update-pciids.8
  '';

  passthru = {
    srcVerification = fetchurl {
      failEarly = true;
      pgpsigUrls = map (n: "${n}.sign") tarballUrls;
      pgpDecompress = true;
      pgpKeyFingerprint = "5558 F939 9CD7 8368 5055  3C6E C28E 7847 ED70 F82D";
      inherit (src) urls outputHash outputHashAlgo;
    };
  };

  meta = with stdenv.lib; {
    homepage = http://mj.ucw.cz/pciutils.html;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}

