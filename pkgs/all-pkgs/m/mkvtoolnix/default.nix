{ stdenv
, fetchurl
, gettext
, ruby

, boost
, expat
, file
, flac
, libebml
, libmatroska
, libogg
, libvorbis
, pugixml
, qt5
, xdg-utils
, zlib
}:

let
  inherit (stdenv.lib)
    enFlag
    optionals
    wtFlag;
in

stdenv.mkDerivation rec {
  name = "mkvtoolnix-${version}";
  version = "9.3.1";

  src = fetchurl {
    url = "https://mkvtoolnix.download/sources/${name}.tar.xz";
    sha256 = "f3695761bf0a5fdcd6144cfb0a624094c10c9d66d43a340ebb917b7c6a8b39a2";
  };

  nativeBuildInputs = [
    gettext
    ruby
  ];

  buildInputs = [
    boost
    expat
    file
    flac
    libebml
    libmatroska
    libogg
    libvorbis
    pugixml
    qt5
    xdg-utils
    zlib
  ];

  postPatch = ''
    patchShebangs ./rake.d/
    patchShebangs ./Rakefile
  '';

  configureFlags = [
    "--disable-debug"
    "--disable-profiling"
    "--enable-optimization"
    "--disable-precompiled-headers"
    (enFlag "qt" (qt5 != null) null)
    "--disable-static-qt"
    "--enable-magic"
    (wtFlag "flac" (flac != null) null)
    "--without-curl"
    (wtFlag "boost" (boost != null) null)
    (wtFlag "boost-libdir" (boost != null) "${boost.lib}/lib")
    "--with-gettext"
    "--without-tools"
  ];

  buildPhase = ''
    ./drake -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    ./drake install -j $NIX_BUILD_CORES
  '';

  passthru = {
    srcVerification = fetchurl {
      inherit (src)
        outputHash
        outputHashAlgo
        urls;
      failEarly = true;
      pgpsigUrls = map (n: "${n}.sig") src.urls;
      pgpKeyFingerprint = "D919 9745 B054 5F2E 8197  062B 0F92 290A 445B 9007";
    };
  };

  meta = with stdenv.lib; {
    description = "Cross-platform tools for Matroska";
    homepage = http://www.bunkus.org/videotools/mkvtoolnix/;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}