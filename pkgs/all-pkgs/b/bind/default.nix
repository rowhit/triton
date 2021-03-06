{ stdenv
, fetchurl
, libtool
, dhcp
, docbook-xsl-ns

, db
, fstrm
, idnkit
, json-c
, kerberos
, libcap
, libseccomp
, libxml2
, lmdb
, mariadb-connector-c
, ncurses
, openldap
, openssl_1-0-2
, postgresql
, protobuf-c
, pythonPackages
, readline
, zlib

, suffix ? ""
}:

let
  toolsOnly = suffix == "tools";

  inherit (stdenv.lib)
    optionals
    optionalString;

  version = "9.11.1-P3";
in
stdenv.mkDerivation rec {
  name = "bind${optionalString (suffix != "") "-${suffix}"}-${version}";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/bind9/${version}/bind-${version}.tar.gz";
    hashOutput = false;
    sha256 = "52426e75432e46996dc90f24fca027805a341c38fbbb022b60dc9acd2677ccf4";
  };

  nativeBuildInputs = [
    docbook-xsl-ns
    libtool
  ];

  buildInputs = [
    idnkit
    json-c
    kerberos
    libcap
    libseccomp
    libxml2
    lmdb
    ncurses
    openssl_1-0-2
    pythonPackages.python
    pythonPackages.ply
    readline
    zlib
  ] ++ optionals (!toolsOnly) [
    db
    fstrm
    openldap
    mariadb-connector-c
    postgresql
    protobuf-c
  ];

  # Fix broken zlib detection
  postPatch = ''
    sed -i 's,''${with_zlib}/zlib.h,''${with_zlib}/include/zlib.h,g' configure
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-seccomp"
    "--with-python=${pythonPackages.python.interpreter}"
    "--enable-kqueue"
    "--enable-epoll"
    "--enable-devpoll"
    "--enable-threads"
    "--without-geoip"  # TODO(wkennington): GeoDNS support
    "--with-gssapi=${kerberos}"
    "--with-libtool"
    "--disable-native-pkcs11"
    "--with-openssl=${openssl_1-0-2}"
    "--with-pkcs11"
    "--with-ecdsa"
    "--without-gost"  # Insecure cipher
    "--with-aes"
    "--with-cc-alg=sha256"
    "--enable-openssl-hash"
    "--with-lmdb=${lmdb}"
    "--with-libxml2=${libxml2}"
    "--with-libjson=${json-c}"
    "--with-zlib=${zlib}"
    "--enable-largefile"
    "--without-purify"
    "--without-gperftools-profiler"
    "--disable-backtrace"
    "--disable-symtable"
    "--enable-ipv6"
    "--without-kame"
    "--with-readline"
    "--disable-isc-spnego"
    "--enable-chroot"
    "--enable-linux-caps"
    "--enable-atomic"
    "--disable-fixed-rrset"
    "--enable-rpz-nsip"
    "--enable-rpz-nsdname"
    "--enable-filter-aaaa"
    "--with-docbook-xsl=${docbook-xsl-ns}/share/xsl/docbook"
    "--with-idn=${idnkit}"
    "--without-atf"
    "--with-tuning=large"
    "--enable-querytrace"
    "--with-dlopen"
    "--without-make-clean"
    "--enable-full-report"
  ] ++ optionals (!toolsOnly) [
    "--with-dlz-postgres=${postgresql}"
    "--with-dlz-mysql=${mariadb-connector-c}"
    "--with-dlz-bdb=${db}"
    "--with-dlz-filesystem"
    "--with-dlz-ldap=${openldap}"
    "--without-dlz-odbc"
    "--with-dlz-stub"
    "--with-protobuf-c=${protobuf-c}"
    "--with-libfstrm=${fstrm}"
    "--enable-dnstap"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ] ++ optionals toolsOnly [
    "DESTDIR=\${TMPDIR}"
  ];

  postInstall = optionalString toolsOnly ''
    mkdir -p $out/{bin,etc,lib,share/man/man1}
    install -m 0755 $TMPDIR/$out/bin/{dig,host,nslookup,nsupdate} $out/bin
    install -m 0644 $TMPDIR/$out/etc/bind.keys $out/etc
    install -m 0644 $TMPDIR/$out/lib/*.so.* $out/lib
    install -m 0644 $TMPDIR/$out/share/man/man1/{dig,host,nslookup,nsupdate}.1 $out/share/man/man1
  '';

  parallelInstall = false;

  passthru = {
    srcVerification = fetchurl {
      failEarly = true;
      pgpsigUrls = map (n: "${n}.sha512.asc") src.urls;
      pgpKeyFile = dhcp.srcVerification.pgpKeyFile;
      pgpKeyFingerprints = [
        "BE0E 9748 B718 253A 28BB  89FF F1B1 1BF0 5CF0 2E57"
      ];
      inherit (src) urls outputHashAlgo outputHash;
    };
  };

  meta = with stdenv.lib; {
    homepage = "http://www.isc.org/software/bind";
    description = "Domain name server";
    license = licenses.isc;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      i686-linux
      ++ x86_64-linux;
  };
}
