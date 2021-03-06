{ stdenv
, autogen
, autoreconfHook
, fetchurl
, perl

, cryptodev_headers
, gmp
, libidn2
, libtasn1
, libunistring
, lzo
, nettle
, p11-kit
, trousers
, unbound
, zlib
}:

let
  tarballUrls = major: minor: [
    "mirror://gnupg/gnutls/v${major}/gnutls-${major}.${minor}.tar.xz"
  ];

  major = "3.6";
  minor = "1";
  version = "${major}.${minor}";
in
stdenv.mkDerivation rec {
  name = "gnutls-${version}";

  src = fetchurl {
    urls = tarballUrls major minor;
    hashOutput = false;
    sha256 = "20b10d2c9994bc032824314714d0e84c0f19bdb3d715d8ed55beb7364a8ebaed";
  };

  # This fixes some broken parallel dependencies
  postPatch = ''
    sed -i 's,^BUILT_SOURCES =,\0 systemkey-args.h,g' src/Makefile.am
  '';

  configureFlags = [
    "--disable-ssl3-support"
    "--disable-ssl2-support"
    "--enable-cryptodev"
    "--disable-tests"
    "--disable-valgrind-tests"
    "--disable-full-test-suite"
    "--with-default-trust-store-file=/etc/ssl/certs/ca-certificates.crt"
    "--with-trousers-lib=${trousers}/lib"
    "--disable-dependency-tracking"
    "--enable-manpages"
    "--enable-fast-install"
  ];

  nativeBuildInputs = [
    autogen
    autoreconfHook
    perl
  ];

  buildInputs = [
    cryptodev_headers
    gmp
    libidn2
    libtasn1
    libunistring
    lzo
    nettle
    p11-kit
    trousers
    unbound
    zlib
  ];

  passthru = {
    # Gnupg depends on this so we have to decouple this fetch from the rest of the build.
    srcVerification = fetchurl rec {
      failEarly = true;
      urls = tarballUrls "3.6" "1";
      pgpsigUrls = map (n: "${n}.sig") urls;
      pgpKeyFingerprint = "1F42 4189 05D8 206A A754  CCDC 29EE 58B9 9686 5171";
      inherit (src) outputHashAlgo;
      outputHash = "20b10d2c9994bc032824314714d0e84c0f19bdb3d715d8ed55beb7364a8ebaed";
    };
  };

  meta = with stdenv.lib; {
    description = "The GNU Transport Layer Security Library";
    homepage = http://www.gnu.org/software/gnutls/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
