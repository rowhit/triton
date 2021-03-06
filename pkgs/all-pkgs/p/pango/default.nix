{ stdenv
, fetchurl
, help2man
, lib
, meson
, ninja

, cairo
, fontconfig
, freetype
, glib
, gobject-introspection
, harfbuzz_lib
, libx11
, libxft
, libxrender
}:

let
  inherit (lib)
    optionals
    optionalString;

  channel = "1.40";
  version = "${channel}.13";
in
stdenv.mkDerivation rec {
  name = "pango-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${channel}/${name}.tar.xz";
    hashOutput = false;
    sha256 = "f84e98db1078772ff4935b40a1629ff82ef0dfdd08d2cbcc0130c8c437857196";
  };

  nativeBuildInputs = [
    help2man
    meson
    ninja
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    glib
    gobject-introspection
    harfbuzz_lib
    libx11
    libxft
    libxrender
  ];

  mesonFlags = [
    "-Denable_docs=false"  # gtk-doc
  ];

  # preCheck = /* Fontconfig fails to load default config in test */
  #     optionalString doCheck ''
  #   export FONTCONFIG_FILE="${fontconfig}/etc/fonts/fonts.conf"
  # '';

  doCheck = false;  # FIXME: files missing from release
  buildDirCheck = false; # FIXME

  passthru = {
    srcVerification = fetchurl {
      inherit (src)
        outputHash
        outputHashAlgo
        urls;
      sha256Url = "https://download.gnome.org/sources/pango/${channel}/"
        + "${name}.sha256sum";
      failEarly = true;
    };
  };

  meta = with lib; {
    description = "A library for laying out and rendering of text";
    homepage = http://www.pango.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
