{ stdenv
, autoreconfHook
, fetchTritonPatch
, fetchurl
, lib

, libvdpau
, libva
, libx11
, opengl-dummy
, xproto
}:

let
  inherit (lib)
    boolEn;
in
stdenv.mkDerivation rec {
  name = "libva-vdpau-driver-0.7.4";

  src = fetchurl rec {
    url = "https://www.freedesktop.org/software/vaapi/releases/"
      + "libva-vdpau-driver/${name}.tar.bz2";
    sha1Url = "${url}.sha1sum";
    sha256 = "155c1982f0ac3f5435ba20b221bcaa11be212c37db548cd1f2a030ffa17e9bb9";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libvdpau
    libva
    libx11
    opengl-dummy
    xproto
  ];

  patches = [
    (fetchTritonPatch {
      rev = "e2f8724d2135b523b46b009573e25787ac927ad2";
      file = "libva-vdpau-driver/libva-vdpau-driver-0.7.4-VAEncH264VUIBufferType.patch";
      sha256 = "1ae32b8e5cca1717be4a63f09e8c6bd84a3e9b712b933816cdb32bb315dbda98";
    })
    (fetchTritonPatch {
      rev = "e2f8724d2135b523b46b009573e25787ac927ad2";
      file = "libva-vdpau-driver/libva-vdpau-driver-0.7.4-glext-missing-definition.patch";
      sha256 = "776bfe4c101cdde396d8783029b288c6cd825d0cdbc782ca3d94a5f9ffb4558c";
    })
    (fetchTritonPatch {
      rev = "e2f8724d2135b523b46b009573e25787ac927ad2";
      file = "libva-vdpau-driver/libva-vdpau-driver-0.7.4-libvdpau-0.8.patch";
      sha256 = "e23385cc09b61e507b477158162ad7c780203bd26ffad78dc659103b564769fd";
    })
    (fetchTritonPatch {
      rev = "e2f8724d2135b523b46b009573e25787ac927ad2";
      file = "libva-vdpau-driver/libva-vdpau-driver-0.7.4-nouveau.patch";
      sha256 = "75897391fdcec4cc28f176ed62184fe0042c4abb8f3c80d19d975050ffaa6072";
    })
  ];

  postPatch = /* Fix use of deprecated autoconf macro */ ''
    sed -i configure.ac \
      -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:'
  '' + /* Fix driver install path */ ''
    sed -i configure.ac \
      -e "s:\`\$PKG_CONFIG libva --variable driverdir\`:$out/lib/dri:"
  '';

  configureFlags = [
    "--${boolEn opengl-dummy.glx}-glx"
    "--disable-debug"
    "--enable-tracer"
  ];

  meta = with lib; {
    description = "VDPAU Backend for Video Acceleration (VA) API";
    homepage = https://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
