{ stdenv
, fetchurl
, perl

, c-ares
, gss
, libidn
, nghttp2_lib
, libssh2
, openldap
, openssl
, rtmpdump
, zlib

# Extra arguments
, suffix ? ""
}:

let
  inherit (stdenv.lib)
    optionalString
    optionals;

  isFull = suffix == "full";
  nameSuffix = optionalString (suffix != "") "-${suffix}";

  tarballUrls = version: [
    "https://curl.haxx.se/download/curl-${version}.tar.bz2"
  ];

  version = "7.50.1";
in
stdenv.mkDerivation rec {
  name = "curl${nameSuffix}-${version}";

  src = fetchurl {
    urls = tarballUrls version;
    allowHashOutput = false;
    sha256 = "3c12c5f54ccaa1d40abc65d672107dcc75d3e1fcb38c267484334280096e5156";
  };

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    c-ares
    nghttp2_lib
    openssl
    zlib
  ] ++ optionals isFull [
    gss
    libidn
    libssh2
    openldap
    rtmpdump
  ];

  configureFlags = [
    "--enable-http"
    "--enable-ftp"
    "--enable-file"
    "--${if isFull then "enable" else "disable"}-ldap"
    "--${if isFull then "enable" else "disable"}-ldaps"
    "--enable-rtsp"
    "--enable-proxy"
    "--enable-dict"
    "--enable-telnet"
    "--enable-tftp"
    "--enable-pop3"
    "--enable-imap"
    "--enable-smb"
    "--enable-smtp"
    "--enable-gopher"
    "--enable-manual"
    "--enable-libcurl_option"
    "--${if stdenv.cc.cc.isGNU then "enable" else "disable"}-libgcc"
    "--with-zlib"
    "--enable-ipv4"
    "--with-gssapi"
    "--without-winssl"
    "--without-darwinssl"
    "--with-ssl"
    "--without-gnutls"
    "--without-polarssl"
    "--without-mbedtls"
    "--without-cyassl"
    "--without-nss"
    "--without-axtls"
    "--without-libpsl"
    "--without-libmetalink"
    # "--without-zsh-functions-dir"
    "--${if isFull then "with" else "without"}-libssh2"
    "--${if isFull then "with" else "without"}-librtmp"
    "--disable-versioned-symbols"
    "--without-winidn"
    "--${if isFull then "with" else "without"}-libidn"
    "--with-nghttp2"
    "--disable-sspi"
    "--enable-crypto-auth"
    "--enable-tls-srp"
    "--enable-unix-sockets"
    "--enable-cookies"
    "--enable-ares"
    "--enable-rt"
    "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
    "--with-ca-fallback"
  ];

  passthru = {
    srcVerification = fetchurl rec {
      failEarly = true;
      urls = tarballUrls "7.50.1";
      pgpsigUrls = map (n: "${n}.asc") urls;
      pgpKeyFingerprint = "27ED EAF2 2F3A BCEB 50DB  9A12 5CC9 08FD B71E 12C2";
      inherit (src) outputHashAlgo;
      outputHash = "3c12c5f54ccaa1d40abc65d672107dcc75d3e1fcb38c267484334280096e5156";
    };
  };

  meta = with stdenv.lib; {
    description = "A command line tool for transferring files with URL syntax";
    homepage = http://curl.haxx.se/;
    license = licenses.mit;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      i686-linux
      ++ x86_64-linux;
  };
}