{ stdenv
, fetchurl
, flex
, gettext
, lib
, libtool

, libexif
, libgd
, libjpeg-turbo_1-4
#, libltdl
, libusb
, libxml2
#, lockdev
}:

let
  inherit (lib)
    boolWt;

  version = "2.5.14";
in
stdenv.mkDerivation rec {
  name = "libgphoto2-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/libgphoto/${version}/${name}.tar.bz2";
    hashOutput = false;
    sha256 = "d3ce70686fb87d6791b9adcbb6e5693bfbe1cfef9661c23c75eb8a699ec4e274";
  };

  nativeBuildInputs = [
    flex
    gettext
    libtool
  ];

  buildInputs = [
    libexif
    libgd
    libjpeg-turbo_1-4
    libusb
    libxml2
    #lockdev
  ];

  configureFlags = [
    "--disable-gp2ddb"
    "--enable-nls"
    "--enable-rpath"
    "--enable-largefile"
    "--disable-internal-docs"
    "--disable-docs"
    "--${boolWt (libjpeg-turbo_1-4 != null)}-jpeg"
    "--with-camlibs=all"
  ];

  passthru = {
    srcVerification = fetchurl rec {
      inherit (src)
        outputHash
        outputHashAlgo
        urls;
      pgpsigUrls = map (n: "${n}.asc") src.urls;
      # Marcus Meissner
      pgpKeyFingerprint = "7C4A FD61 D8AA E757 0796  A517 2209 D690 2F96 9C95";
      failEarly = true;
    };
  };

  meta = with lib; {
    description = "A library for accessing digital cameras";
    homepage = http://www.gphoto.org/proj/libgphoto2/;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
