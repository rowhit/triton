{ stdenv
, fetchurl
, gnum4
, lib
, python

, libdrm
, libva
, mesa_noglu
, wayland
, xorg
}:

let
  version = "1.8.0";
in
stdenv.mkDerivation rec {
  name = "intel-vaapi-driver-1.8.0";

  src = fetchurl rec {
    urls = [
      ("https://github.com/01org/intel-vaapi-driver/releases/download/"
        + "${version}/${name}.tar.bz2")
      ("https://www.freedesktop.org/software/vaapi/releases/"
        + "libva-intel-driver/${name}.tar.bz2")
    ];
    hashOutput = false;
    sha256 = "4fcbb282957cf4f33b6c43a0f476d8df21f7721e586a8546c71242551986b3a6";
  };

  nativeBuildInputs = [
    gnum4
    python
  ];

  buildInputs = [
    libdrm
    libva
    mesa_noglu
    wayland
    xorg.intelgputools
    xorg.libX11
    xorg.xproto
  ];

  patchPhase = ''
    patchShebangs ./src/shaders/gpp.py
  '';

  preConfigure = ''
    sed -i configure \
      -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri,"
  '';

  configureFlags = [
    "--enable-drm"
    "--enable-x11"
    "--enable-wayland"
    "--enable-hybrid-codec"
    "--disable-tests"
  ];

  passthru = {
    srcVerification = fetchurl {
      inherit (src)
        outputHash
        outputHashAlgo
        urls;
      sha1Url = map (n: "${n}.sha1sum") src.urls;
    };
    failEarly = true;
  };

  meta = with lib; {
    description = "VA-API user mode driver for Intel GEN Graphics family";
    homepage = https://github.com/01org/intel-vaapi-driver;
    license = licenses.mit;
    maintainers = with maintainers; [
      codyopel
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}