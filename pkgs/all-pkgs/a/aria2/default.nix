{ stdenv
, fetchurl

, c-ares
, expat
, jemalloc
, libssh2
, libuv
, openssl
, sqlite
, zlib
}:

let
  version = "1.33.0";
in
stdenv.mkDerivation rec {
  name = "aria2-${version}";

  src = fetchurl {
    url = "https://github.com/tatsuhiro-t/aria2/releases/download/"
      + "release-${version}/${name}.tar.xz";
    sha256 = "996e3fc2fd07ce2dd517e20a1f79b8b3dbaa5c7e27953b5fc19dae38f3874b8c";
  };

  buildInputs = [
    c-ares
    expat
    jemalloc
    libssh2
    libuv
    openssl
    sqlite
    zlib
  ];

  configureFlags = [
    "--enable-libaria2"
    "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
    "--with-libuv"
    "--with-jemalloc"
  ];

  meta = with stdenv.lib; {
    description = "A multi-protocol/source, command-line download utility";
    homepage = https://github.com/tatsuhiro-t/aria2;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
