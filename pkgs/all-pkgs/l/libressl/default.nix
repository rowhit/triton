{ stdenv
, fetchurl
}:

let
  baseUrl = "mirror://openbsd/LibreSSL";
in

stdenv.mkDerivation rec {
  name = "libressl-2.5.5";

  src = fetchurl {
    url = "${baseUrl}/${name}.tar.gz";
    hashOutput = false;  # Upstream provides it directly
    sha256 = "e57f5e3d5842a81fe9351b6e817fcaf0a749ca4ef35a91465edba9e071dce7c4";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  preInstall = ''
    installFlagsArray+=(
      "sysconfdir=$out/etc"
      "localstatedir=$TMPDIR"
    )
  '';

  passthru = {
    srcVerification = fetchurl rec {
      failEarly = true;
      pgpsigUrl = map (n: "${n}.asc") src.urls;
      #sha256Url = "${baseUrl}/SHA256";
      #pgpsigSha256Url = "${sha256Url}.asc";
      pgpKeyFile = ./signing.key;
      inherit (src) urls outputHash outputHashAlgo;
    };
  };

  meta = with stdenv.lib; {
    license = licenses.bsd3;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
