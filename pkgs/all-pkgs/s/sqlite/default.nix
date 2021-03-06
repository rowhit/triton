{ stdenv
, fetchurl

, readline
, ncurses
}:

let
  inherit (stdenv.lib)
    fixedWidthString
    head
    splitString
    tail;

  version = "3.21.0";
  releaseYear = "2017";
  versionList = splitString "." version;
  version' = "${head versionList}${fixedWidthString 2 "0" (head (tail versionList))}"
    + "${fixedWidthString 2 "0" (head (tail (tail versionList)))}00";
in
stdenv.mkDerivation rec {
  name = "sqlite-${version}";

  src = fetchurl {
    url = "https://sqlite.org/${releaseYear}/sqlite-autoconf-${version'}.tar.gz";
    multihash = "QmYWEZQ7cGWJH8MMatmyi9Cqn5EYspWZ6LULtHeGReQLhZ";
    hashOutput = false;
    sha256 = "d7dd516775005ad87a57f428b6f86afd206cb341722927f104d3f0cf65fbbbe3";
  };

  buildInputs = [
    readline
    ncurses
  ];

  configureFlags = [
    "--enable-fts5"
    "--enable-json1"
    "--enable-session"
  ];

  NIX_CFLAGS_COMPILE = [
    "-DSQLITE_ENABLE_COLUMN_METADATA"
    "-DSQLITE_ENABLE_DBSTAT_VTAB"
    "-DSQLITE_ENABLE_JSON1"
    "-DSQLITE_ENABLE_FTS3"
    "-DSQLITE_ENABLE_FTS3_PARENTHESIS"
    "-DSQLITE_ENABLE_FTS4"
    "-DSQLITE_ENABLE_FTS5"
    "-DSQLITE_ENABLE_RTREE"
    "-DSQLITE_ENABLE_STMT_SCANSTATUS"
    "-DSQLITE_ENABLE_UNLOCK_NOTIFY"
    "-DSQLITE_SOUNDEX"
    "-DSQLITE_SECURE_DELETE"
  ];

  # Test for features which may not be available at compile time
  preBuild = ''
    # Use pread(), pread64(), pwrite(), pwrite64() functions for better performance if they are available.
    if cc -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread_pwrite_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread(0, NULL, 0, 0);\n  pwrite(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD"
    fi
    if cc -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread64_pwrite64_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD64"
    elif cc -D_LARGEFILE64_SOURCE -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread64_pwrite64_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD64 -D_LARGEFILE64_SOURCE"
    fi
  '';

  passthru = {
    srcVerification = fetchurl {
      failEarly = true;
      sha1Confirm = "f56fe3407d8297fc0a68a058f4c9e6b77e83575c";
      inherit (src) urls outputHash outputHashAlgo;
    };
  };

  meta = with stdenv.lib; {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
