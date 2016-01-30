{ stdenv
, fetchurl
, gettext
, intltool
, python

, glib
, glib_networking
, gobject-introspection
, libxml2
, sqlite
}:

with {
  inherit (stdenv.lib)
    enFlag;
};

stdenv.mkDerivation rec {
  name = "libsoup-${version}";
  versionMajor = "2.52";
  versionMinor = "2";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${versionMajor}/${name}.tar.xz";
    sha256 = "1p4k40y2gikr6m8p3hm0vswdzj2pj133dckipd2jk5bxbj5n4mfv";
  };

  postPatch = ''
    patchShebangs ./libsoup/
  '';

  # glib_networking is a runtime dependency, not a compile-time dependency
  configureFlags = [
    "--enable-glibtest"
    "--disable-installed-tests"
    "--disable-always-build-tests"
    "--enable-nls"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    (enFlag "introspection" (gobject-introspection != null) null)
    "--disable-vala"
    "--disable-tls-check"
    "--disable-code-coverage"
    "--enable-more-warnings"
    "--with-gnome"
  ];

  nativeBuildInputs = [
    gettext
    intltool
    python
  ];

  buildInputs = [
    glib
    glib_networking
    gobject-introspection
    libxml2
    sqlite
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  passthru = {
    propagatedUserEnvPackages = [
      glib_networking
    ];
  };

  meta = {
    inherit (glib.meta)
      maintainers
      platforms;
  };
}
