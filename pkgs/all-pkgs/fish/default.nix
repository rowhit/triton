{ stdenv
, fetchurl
, gettext

, ncurses
, pcre2
}:

let
  version = "2.3.0";
in
stdenv.mkDerivation rec {
  name = "fish-${version}";

  src = fetchurl {
    url = "http://fishshell.com/files/${version}/${name}.tar.gz";
    sha256 = "1ralmp7lavdl0plc09ppm232aqsn0crxx6m3hgaa06ibam3sqawi";
  };

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    ncurses
    pcre2
  ];

  configureFlags = [
    "--without-included-pcre2"
  ];

  meta = with stdenv.lib; {
    description = "Smart and user-friendly command line shell";
    homepage = "http://fishshell.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
