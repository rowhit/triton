{ stdenv
, fetchurl
, gettext
, intltool
, itstool
, lib
, makeWrapper

, adwaita-icon-theme
, atk
, dconf
, exempi
, gdk-pixbuf
, glib
, gnome-desktop
, gobject-introspection
, gsettings-desktop-schemas
, gtk
, lcms2
, libexif
, libjpeg
, libpeas
, librsvg
, libx11
, libxml2
, pango
, shared-mime-info
, zlib

, channel
}:

assert !gtk.x11_backend -> libx11 == null;

let
  inherit (lib)
    boolEn
    boolWt
    optionals;

  source = (import ./sources.nix { })."${channel}";
in
stdenv.mkDerivation rec {
  name = "eog-${source.version}";

  src = fetchurl {
    url = "mirror://gnome/sources/eog/${channel}/${name}.tar.xz";
    hashOutput = false;
    inherit (source) sha256;
  };

  nativeBuildInputs = [
    gettext
    intltool
    itstool
    makeWrapper
  ];

  buildInputs = [
    adwaita-icon-theme
    atk
    dconf
    exempi
    gdk-pixbuf
    glib
    gnome-desktop
    gobject-introspection
    gsettings-desktop-schemas
    gtk
    lcms2
    libexif
    libjpeg
    libpeas
    librsvg
    libx11
    libxml2
    pango
    shared-mime-info
    zlib
  ];

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-compile-warnings"
    "--disable-iso-c"
    "--disable-debug"
    "--disable-gtk-doc"
    "--disable-gtk-doc-html"
    "--disable-gtk-doc-pdf"
    "--enable-nls"
    "--${boolEn (gobject-introspection != null)}-introspection"
    "--enable-schemas-compile"
    "--disable-installed-tests"
    "--${boolWt (libexif != null)}-libexif"
    "--${boolWt (libx11 != null && lcms2 != null)}-cms"
    "--${boolWt (exempi != null)}-xmp"
    "--${boolWt (libjpeg != null)}-libjpeg"
    "--${boolWt (librsvg != null)}-librsvg"
    "--${boolWt (gtk.x11_backend && libx11 != null)}-x"
  ];

  preFixup = ''
    wrapProgram $out/bin/eog \
      --set 'GDK_PIXBUF_MODULE_FILE' "$GDK_PIXBUF_MODULE_FILE" \
      --set 'GSETTINGS_BACKEND' 'dconf' \
      --prefix 'GIO_EXTRA_MODULES' : "$GIO_EXTRA_MODULES" \
      --prefix 'GI_TYPELIB_PATH' : "$GI_TYPELIB_PATH" \
      --prefix 'XDG_DATA_DIRS' : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix 'XDG_DATA_DIRS' : "$out/share" \
      --prefix 'XDG_DATA_DIRS' : "$XDG_ICON_DIRS" \
      --prefix 'XDG_DATA_DIRS' : "${shared-mime-info}/share"
  '';

  passthru = {
    srcVerification = fetchurl {
      inherit (src)
        outputHash
        outputHashAlgo
        urls;
      sha256Url = "https://download.gnome.org/sources/eog/${channel}/"
        + "${name}.sha256sum";
      failEarly = true;
    };
  };

  meta = with lib; {
    description = "The Eye of GNOME image viewer";
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
