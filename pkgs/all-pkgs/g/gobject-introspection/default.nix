{ stdenv
, bison
, fetchTritonPatch
, fetchurl
, flex

, bzip2
, glib
, libffi
, python

, cairo
}:

let
  inherit (stdenv.lib)
    optionals
    optionalString
    wtFlag;
in

stdenv.mkDerivation rec {
  name = "gobject-introspection-${versionMajor}.${versionMinor}";
  versionMajor = "1.48";
  versionMinor = "0";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${versionMajor}/${name}.tar.xz";
    sha256 = "fa275aaccdbfc91ec0bc9a6fd0562051acdba731e7d584b64a277fec60e75877";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    bzip2
    glib
    libffi
    python
  ] ++ optionals doCheck [
    cairo
  ];

  setupHook = ./setup-hook.sh;

  patches = [
    (fetchTritonPatch {
      rev = "d3fc5e59bd2b4b465c2652aae5e7428b24eb5669";
      file = "gobject-introspection/gobject-introspection-1.x-absolute_shlib_path.patch";
      sha256 = "72be007720645946a4db10e4d845a78ef0d74867db915f414c1ec485f8a2494e";
    })
  ];

  postPatch =
  /* patchShebangs does not catch @PYTHON@ */ ''
    sed -i tools/g-ir-tool-template.in \
      -e 's|#!/usr/bin/env @PYTHON@|#!${python.interpreter}|'
  '' +
  optionalString doCheck (''
      patchShebangs ./tests/gi-tester
    '' + /* Fix tests broken by absolute_shlib_path.patch */ ''
      sed -i tests/scanner/{GetType,GtkFrob,Regress,SLetter,Typedefs,Utility}-1.0-expected.gir \
        -e 's|shared-library="|shared-library="/unused/|'
    ''
  );

  configureFlags = [
    "--disable-maintainer-mode"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--disable-doctool"
    "--enable-Bsymbolic"
    (wtFlag "cairo" doCheck null)
  ];

  postInstall = "rm -frv $out/share/gtk-doc";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage = http://live.gnome.org/GObjectIntrospection;
    license = with licenses; [
      lgpl2Plus
      gpl2Plus
    ];
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}