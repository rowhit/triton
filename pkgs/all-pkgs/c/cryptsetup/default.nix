{ stdenv
, fetchurl

, lvm2
, openssl
, popt
, python
, util-linux_lib
}:

let
  major = "1.7";
  patch = "5";

  version = "${major}.${patch}";

  baseUrl = "mirror://kernel/linux/utils/cryptsetup/v${major}";
in
stdenv.mkDerivation rec {
  name = "cryptsetup-${version}";

  src = fetchurl {
    url = "${baseUrl}/${name}.tar.xz";
    hashOutput = false;
    sha256 = "2b30cd1d0dd606a53ac77b406e1d37798d4b0762fa89de6ea546201906a251bd";
  };

  buildInputs = [
    lvm2
    openssl
    popt
    python
    util-linux_lib
  ];

  configureFlags = [
    "--enable-cryptsetup-reencrypt"
    "--with-crypto_backend=openssl"
    "--enable-python"
  ];

  passthru = {
    srcVerification = fetchurl {
      failEarly = true;
      pgpsigUrl = "${baseUrl}/${name}.tar.sign";
      pgpDecompress = true;
      pgpKeyFingerprint = "2A29 1824 3FDE 4664 8D06  86F9 D9B0 577B D93E 98FC";
      inherit (src) urls outputHash outputHashAlgo;
    };
  };

  meta = with stdenv.lib; {
    description = "LUKS for dm-crypt";
    homepage = http://code.google.com/p/cryptsetup/;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
