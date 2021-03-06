{ stdenv
, fetchurl

, libsndfile
}:

stdenv.mkDerivation rec {
  name = "sbc-1.3";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/bluetooth/${name}.tar.xz";
    sha256 = "02ckd2z51z0h85qgv7x8vv8ybp5czm9if1z78411j53gaz7j4476";
  };

  buildInputs = [
    libsndfile
  ];

  meta = with stdenv.lib; {
    description = "SubBand Codec Library";
    homepage = http://www.bluez.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
