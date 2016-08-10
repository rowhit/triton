{ stdenv
, fetchTritonPatch
, fetchurl
}:

stdenv.mkDerivation rec {
  name = "jansson-2.7";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "1mvq9p85khsl818i4vbszyfab0fd45mdrwrxjkzw05mk1xcyc1br";
  };

  patches = [
    (fetchTritonPatch {
      rev = "5bb60ada3e49df19daba41242380880a0ff718c5";
      file = "jansson/CVE-2016-4425.patch";
      sha256 = "99207e08752ee7627b33a0dda608b8e342794f51314838839102f8f331224a9b";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = licenses.mit;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}