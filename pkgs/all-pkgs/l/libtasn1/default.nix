{ stdenv
, fetchTritonPatch
, fetchurl
, perl
, texinfo
}:

let
  tarballUrls = version: [
    "mirror://gnu/libtasn1/libtasn1-${version}.tar.gz"
  ];

  version = "4.12";
in
stdenv.mkDerivation rec {
  name = "libtasn1-${version}";

  src = fetchurl {
    urls = tarballUrls version;
    hashOutput = false;
    sha256 = "6753da2e621257f33f5b051cc114d417e5206a0818fe0b1ecfd6153f70934753";
  };

  nativeBuildInputs = [
    perl
    texinfo
  ];

  patches = [
    (fetchTritonPatch {
      rev = "2252cbbaccd389577ff53aac055012b1817ea230";
      file = "l/libtasn1/libtasn1-4.12-CVE-2017-10790.patch";
      sha256 = "f1dc9ff3f7e660633a2cc3e60f4198aafc46f479662176cf160ca7fb5503bcec";
    })
  ];

  passthru = {
    srcVerification = fetchurl rec {
      failEarly = true;
      urls = tarballUrls "4.12";
      pgpsigUrls = map (n: "${n}.sig") urls;
      pgpKeyFingerprint = "1F42 4189 05D8 206A A754  CCDC 29EE 58B9 9686 5171";
      outputHash = "6753da2e621257f33f5b051cc114d417e5206a0818fe0b1ecfd6153f70934753";
      inherit (src) outputHashAlgo;
    };
  };

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/libtasn1/;
    description = "An ASN.1 library";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
