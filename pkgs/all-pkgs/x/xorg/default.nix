# THIS IS A GENERATED FILE.  DO NOT EDIT!
args @ { fetchurl, fetchzip, fetchpatch, stdenv, pkgconfig, intltool, freetype, fontconfig
, libxslt, expat, libpng, zlib, perl, opengl-dummy, spice-protocol, spice
, dbus, util-linux_lib, openssl, gperf, gnum4, libevdev, tradcpp, libinput, mcpp, makeWrapper, autoreconfHook
, autoconf, automake, libtool, xmlto, asciidoc, flex, bison, python, mtdev, cairo, glib
, libepoxy, wayland, libbsd, systemd_lib, gettext, pciutils, python3, kmod, procps-ng

, bigreqsproto
, compositeproto
, damageproto
, dmxproto
, dri2proto
, dri3proto
, fixesproto
, fontcacheproto
, fontsproto
, glproto
, inputproto
, kbproto
, libdmx
, libfontenc
, libice
, libpthread-stubs
, libsm
, libx11
, libxau
, libxcb
, libxcomposite
, libxcursor
, libxdamage
, libxdmcp
, libxext
, libxfixes
, libxfont
, libxfont2
, libxft
, libxi
, libxinerama
, libxkbfile
, libxrandr
, libxrender
, libxres
, libxscrnsaver
, libxt
, libxtst
, libxv
, presentproto
, printproto
, randrproto
, recordproto
, renderproto
, resourceproto
, scrnsaverproto
, trapproto
, util-macros
, videoproto
, windowswmproto
, xcb-proto
, xcmiscproto
, xextproto
, xf86bigfontproto
, xf86dgaproto
, xf86driproto
, xf86miscproto
, xf86vidmodeproto
, xineramaproto
, xorg-server
, xproto
, xrefresh
, xtrans
, xwininfo

, ... }: with args;

let

  mkDerivation = name: attrs:
    let newAttrs = (overrides."${name}" or (x: x)) attrs;
        stdenv = newAttrs.stdenv or args.stdenv;
    in stdenv.mkDerivation (removeAttrs newAttrs [ "stdenv" ] // {
      builder = ./builder.sh;
      postPatch = (attrs.postPatch or "") + ''
        patchShebangs .
      '';
      meta.platforms = with stdenv.lib.platforms;
        x86_64-linux;
	});

  overrides = import ./overrides.nix {inherit args xorg;};

  xorg = rec {

    inherit
      bigreqsproto
      compositeproto
      damageproto
      dmxproto
      dri2proto
      dri3proto
      fixesproto
      fontcacheproto
      fontsproto
      glproto
      inputproto
      kbproto
      libdmx
      libfontenc
      libxcb
      libxkbfile
      presentproto
      printproto
      randrproto
      recordproto
      renderproto
      resourceproto
      scrnsaverproto
      trapproto
      videoproto
      windowswmproto
      xcmiscproto
      xextproto
      xf86bigfontproto
      xf86dgaproto
      xf86driproto
      xf86miscproto
      xf86vidmodeproto
      xineramaproto
      xproto
      xrefresh
      xtrans
      xwininfo;

    libICE = libice;
    libpthreadstubs = libpthread-stubs;
    libSM = libsm;
    libX11 = libx11;
    libXau = libxau;
    libXcomposite = libxcomposite;
    libXcursor = libxcursor;
    libXdamage = libxdamage;
    libXdmcp = libxdmcp;
    libXext = libxext;
    libXfixes = libxfixes;
    libXfont = libxfont;
    libXfont2 = libxfont2;
    libXft = libxft;
    libXi = libxi;
    libXinerama = libxinerama;
    libXrandr = libxrandr;
    libXrender = libxrender;
    libXres = libxres;
    libXScrnSaver = libxscrnsaver;
    libXt = libxt;
    libXtst = libxtst;
    libXv = libxv;
    utilmacros = util-macros;
    xcbproto = xcb-proto;
    xorgserver = xorg-server;

################################################################################

  bdftopcf = (mkDerivation "bdftopcf" {
    name = "bdftopcf-1.0.5";
    src = fetchurl {
      url = mirror://xorg/individual/app/bdftopcf-1.0.5.tar.bz2;
      sha256 = "09i03sk878cmx2i40lkpsysn7zqcvlczb30j7x3lryb11jz4gx1q";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libXfont ];

  }) // {inherit libXfont ;};

  encodings = (mkDerivation "encodings" {
    name = "encodings-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/font/encodings-1.0.4.tar.bz2;
      sha256 = "0ffmaw80vmfwdgvdkp6495xgsqszb6s0iira5j0j6pd4i0lk3mnf";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  evieext = (mkDerivation "evieext" {
    name = "evieext-1.1.1";
    src = fetchurl {
      url = mirror://xorg/individual/proto/evieext-1.1.1.tar.bz2;
      sha256 = "1zik4xcvm6hppd13irn9520ip8rblcw682x9fxjzb6bd8ca43xqw";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  fontadobe100dpi = (mkDerivation "fontadobe100dpi" {
    name = "font-adobe-100dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-adobe-100dpi-1.0.3.tar.bz2;
      sha256 = "0m60f5bd0caambrk8ksknb5dks7wzsg7g7xaf0j21jxmx8rq9h5j";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontadobe75dpi = (mkDerivation "fontadobe75dpi" {
    name = "font-adobe-75dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-adobe-75dpi-1.0.3.tar.bz2;
      sha256 = "02advcv9lyxpvrjv8bjh1b797lzg6jvhipclz49z8r8y98g4l0n6";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontadobeutopia100dpi = (mkDerivation "fontadobeutopia100dpi" {
    name = "font-adobe-utopia-100dpi-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-adobe-utopia-100dpi-1.0.4.tar.bz2;
      sha256 = "19dd9znam1ah72jmdh7i6ny2ss2r6m21z9v0l43xvikw48zmwvyi";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontadobeutopia75dpi = (mkDerivation "fontadobeutopia75dpi" {
    name = "font-adobe-utopia-75dpi-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-adobe-utopia-75dpi-1.0.4.tar.bz2;
      sha256 = "152wigpph5wvl4k9m3l4mchxxisgsnzlx033mn5iqrpkc6f72cl7";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontadobeutopiatype1 = (mkDerivation "fontadobeutopiatype1" {
    name = "font-adobe-utopia-type1-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-adobe-utopia-type1-1.0.4.tar.bz2;
      sha256 = "0xw0pdnzj5jljsbbhakc6q9ha2qnca1jr81zk7w70yl9bw83b54p";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontalias = (mkDerivation "fontalias" {
    name = "font-alias-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-alias-1.0.3.tar.bz2;
      sha256 = "16ic8wfwwr3jicaml7b5a0sk6plcgc1kg84w02881yhwmqm3nicb";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  fontarabicmisc = (mkDerivation "fontarabicmisc" {
    name = "font-arabic-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-arabic-misc-1.0.3.tar.bz2;
      sha256 = "1x246dfnxnmflzf0qzy62k8jdpkb6jkgspcjgbk8jcq9lw99npah";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbh100dpi = (mkDerivation "fontbh100dpi" {
    name = "font-bh-100dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bh-100dpi-1.0.3.tar.bz2;
      sha256 = "10cl4gm38dw68jzln99ijix730y7cbx8np096gmpjjwff1i73h13";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbh75dpi = (mkDerivation "fontbh75dpi" {
    name = "font-bh-75dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bh-75dpi-1.0.3.tar.bz2;
      sha256 = "073jmhf0sr2j1l8da97pzsqj805f7mf9r2gy92j4diljmi8sm1il";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbhlucidatypewriter100dpi = (mkDerivation "fontbhlucidatypewriter100dpi" {
    name = "font-bh-lucidatypewriter-100dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2;
      sha256 = "1fqzckxdzjv4802iad2fdrkpaxl4w0hhs9lxlkyraq2kq9ik7a32";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbhlucidatypewriter75dpi = (mkDerivation "fontbhlucidatypewriter75dpi" {
    name = "font-bh-lucidatypewriter-75dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2;
      sha256 = "0cfbxdp5m12cm7jsh3my0lym9328cgm7fa9faz2hqj05wbxnmhaa";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbhttf = (mkDerivation "fontbhttf" {
    name = "font-bh-ttf-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bh-ttf-1.0.3.tar.bz2;
      sha256 = "0pyjmc0ha288d4i4j0si4dh3ncf3jiwwjljvddrb0k8v4xiyljqv";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbhtype1 = (mkDerivation "fontbhtype1" {
    name = "font-bh-type1-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bh-type1-1.0.3.tar.bz2;
      sha256 = "1hb3iav089albp4sdgnlh50k47cdjif9p4axm0kkjvs8jyi5a53n";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbitstream100dpi = (mkDerivation "fontbitstream100dpi" {
    name = "font-bitstream-100dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bitstream-100dpi-1.0.3.tar.bz2;
      sha256 = "1kmn9jbck3vghz6rj3bhc3h0w6gh0qiaqm90cjkqsz1x9r2dgq7b";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbitstream75dpi = (mkDerivation "fontbitstream75dpi" {
    name = "font-bitstream-75dpi-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bitstream-75dpi-1.0.3.tar.bz2;
      sha256 = "13plbifkvfvdfym6gjbgy9wx2xbdxi9hfrl1k22xayy02135wgxs";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbitstreamspeedo = (mkDerivation "fontbitstreamspeedo" {
    name = "font-bitstream-speedo-1.0.2";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bitstream-speedo-1.0.2.tar.bz2;
      sha256 = "0qv7sxrvfgzjplj0czq8vzf425w6iapl8n5mhb08hywl8q0gw207";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontbitstreamtype1 = (mkDerivation "fontbitstreamtype1" {
    name = "font-bitstream-type1-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-bitstream-type1-1.0.3.tar.bz2;
      sha256 = "1256z0jhcf5gbh1d03593qdwnag708rxqa032izmfb5dmmlhbsn6";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontcronyxcyrillic = (mkDerivation "fontcronyxcyrillic" {
    name = "font-cronyx-cyrillic-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-cronyx-cyrillic-1.0.3.tar.bz2;
      sha256 = "0ai1v4n61k8j9x2a1knvfbl2xjxk3xxmqaq3p9vpqrspc69k31kf";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontcursormisc = (mkDerivation "fontcursormisc" {
    name = "font-cursor-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-cursor-misc-1.0.3.tar.bz2;
      sha256 = "0dd6vfiagjc4zmvlskrbjz85jfqhf060cpys8j0y1qpcbsrkwdhp";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontdaewoomisc = (mkDerivation "fontdaewoomisc" {
    name = "font-daewoo-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-daewoo-misc-1.0.3.tar.bz2;
      sha256 = "1s2bbhizzgbbbn5wqs3vw53n619cclxksljvm759h9p1prqdwrdw";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontdecmisc = (mkDerivation "fontdecmisc" {
    name = "font-dec-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-dec-misc-1.0.3.tar.bz2;
      sha256 = "0yzza0l4zwyy7accr1s8ab7fjqkpwggqydbm2vc19scdby5xz7g1";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontibmtype1 = (mkDerivation "fontibmtype1" {
    name = "font-ibm-type1-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-ibm-type1-1.0.3.tar.bz2;
      sha256 = "1pyjll4adch3z5cg663s6vhi02k8m6488f0mrasg81ssvg9jinzx";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontisasmisc = (mkDerivation "fontisasmisc" {
    name = "font-isas-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-isas-misc-1.0.3.tar.bz2;
      sha256 = "0rx8q02rkx673a7skkpnvfkg28i8gmqzgf25s9yi0lar915sn92q";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontjismisc = (mkDerivation "fontjismisc" {
    name = "font-jis-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-jis-misc-1.0.3.tar.bz2;
      sha256 = "0rdc3xdz12pnv951538q6wilx8mrdndpkphpbblszsv7nc8cw61b";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontmicromisc = (mkDerivation "fontmicromisc" {
    name = "font-micro-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-micro-misc-1.0.3.tar.bz2;
      sha256 = "1dldxlh54zq1yzfnrh83j5vm0k4ijprrs5yl18gm3n9j1z0q2cws";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontmisccyrillic = (mkDerivation "fontmisccyrillic" {
    name = "font-misc-cyrillic-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-misc-cyrillic-1.0.3.tar.bz2;
      sha256 = "0q2ybxs8wvylvw95j6x9i800rismsmx4b587alwbfqiw6biy63z4";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontmiscethiopic = (mkDerivation "fontmiscethiopic" {
    name = "font-misc-ethiopic-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-misc-ethiopic-1.0.3.tar.bz2;
      sha256 = "19cq7iq0pfad0nc2v28n681fdq3fcw1l1hzaq0wpkgpx7bc1zjsk";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontmiscmeltho = (mkDerivation "fontmiscmeltho" {
    name = "font-misc-meltho-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-misc-meltho-1.0.3.tar.bz2;
      sha256 = "148793fqwzrc3bmh2vlw5fdiwjc2n7vs25cic35gfp452czk489p";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontmiscmisc = (mkDerivation "fontmiscmisc" {
    name = "font-misc-misc-1.1.2";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-misc-misc-1.1.2.tar.bz2;
      sha256 = "150pq6n8n984fah34n3k133kggn9v0c5k07igv29sxp1wi07krxq";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontmuttmisc = (mkDerivation "fontmuttmisc" {
    name = "font-mutt-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-mutt-misc-1.0.3.tar.bz2;
      sha256 = "13qghgr1zzpv64m0p42195k1kc77pksiv059fdvijz1n6kdplpxx";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontschumachermisc = (mkDerivation "fontschumachermisc" {
    name = "font-schumacher-misc-1.1.2";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-schumacher-misc-1.1.2.tar.bz2;
      sha256 = "0nkym3n48b4v36y4s927bbkjnsmicajarnf6vlp7wxp0as304i74";
    };
    nativeBuildInputs = [ bdftopcf fontutil mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontscreencyrillic = (mkDerivation "fontscreencyrillic" {
    name = "font-screen-cyrillic-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-screen-cyrillic-1.0.4.tar.bz2;
      sha256 = "0yayf1qlv7irf58nngddz2f1q04qkpr5jwp4aja2j5gyvzl32hl2";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontsonymisc = (mkDerivation "fontsonymisc" {
    name = "font-sony-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-sony-misc-1.0.3.tar.bz2;
      sha256 = "1xfgcx4gsgik5mkgkca31fj3w72jw9iw76qyrajrsz1lp8ka6hr0";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontsunmisc = (mkDerivation "fontsunmisc" {
    name = "font-sun-misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-sun-misc-1.0.3.tar.bz2;
      sha256 = "1q6jcqrffg9q5f5raivzwx9ffvf7r11g6g0b125na1bhpz5ly7s8";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fonttosfnt = (mkDerivation "fonttosfnt" {
    name = "fonttosfnt-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/app/fonttosfnt-1.0.4.tar.bz2;
      sha256 = "157mf1j790pnsx2lhybkpcpmprpx83fjbixxp3lwgydkk6samsiz";
    };
    nativeBuildInputs = [ ];
    buildInputs = [ libfontenc freetype xproto ];

  }) // {inherit libfontenc freetype xproto ;};

  fontutil = (mkDerivation "fontutil" {
    name = "font-util-1.3.1";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-util-1.3.1.tar.bz2;
      sha256 = "08drjb6cf84pf5ysghjpb4i7xkd2p86k3wl2a0jxs1jif6qbszma";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  fontwinitzkicyrillic = (mkDerivation "fontwinitzkicyrillic" {
    name = "font-winitzki-cyrillic-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-winitzki-cyrillic-1.0.3.tar.bz2;
      sha256 = "181n1bgq8vxfxqicmy1jpm1hnr6gwn1kdhl6hr4frjigs1ikpldb";
    };
    nativeBuildInputs = [ bdftopcf mkfontdir utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  fontxfree86type1 = (mkDerivation "fontxfree86type1" {
    name = "font-xfree86-type1-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/font/font-xfree86-type1-1.0.4.tar.bz2;
      sha256 = "0jp3zc0qfdaqfkgzrb44vi9vi0a8ygb35wp082yz7rvvxhmg9sya";
    };
    nativeBuildInputs = [ mkfontdir mkfontscale utilmacros ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];

  }) // {inherit ;};

  glamoregl = (mkDerivation "glamoregl" {
    name = "glamor-egl-0.6.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/glamor-egl-0.6.0.tar.bz2;
      sha256 = "1jg5clihklb9drh1jd7nhhdsszla6nv7xmbvm8yvakh5wrb1nlv6";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ dri2proto opengl-dummy libdrm xorgserver ];

  }) // {inherit dri2proto opengl-dummy libdrm xorgserver ;};

  iceauth = (mkDerivation "iceauth" {
    name = "iceauth-1.0.7";
    src = fetchurl {
      url = mirror://xorg/individual/app/iceauth-1.0.7.tar.bz2;
      sha256 = "02izdyzhwpgiyjd8brzilwvwnfr72ncjb6mzz3y1icwrxqnsy5hj";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libICE xproto ];

  }) // {inherit libICE xproto ;};

  ico = (mkDerivation "ico" {
    name = "ico-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/app/ico-1.0.4.tar.bz2;
      sha256 = "141mqphg9sfz7x1gfiqpkjkqkiqq1b5zxw67l0ls2p7rk1q7cci9";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 xproto ];

  }) // {inherit libX11 xproto ;};

  imake = (mkDerivation "imake" {
    name = "imake-1.0.7";
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.7.tar.bz2;
      sha256 = "0zpk8p044jh14bis838shbf4100bjg7mccd7bq54glpsq552q339";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ xproto ];

  }) // {inherit xproto ;};

  intelgputools = (mkDerivation "intelgputools" {
    name = "intel-gpu-tools-1.20";
    src = fetchurl {
      url = mirror://xorg/individual/app/intel-gpu-tools-1.20.tar.bz2;
      sha256 = "2fffe7a66789f56f301e6b60a3afe21556f34acbad8b7b29c8f3dd41f0b148e8";
    };
    nativeBuildInputs = [ bison flex python python3 utilmacros ];
    buildInputs = [ cairo dri2proto glib kmod libdrm procps-ng systemd_lib libunwind libpciaccess libX11 libXext libXrandr libXv ];

  }) // {inherit cairo dri2proto glib kmod libdrm procps-ng systemd_lib libunwind libpciaccess libX11 libXext libXrandr libXv ;};

  libFS = (mkDerivation "libFS" {
    name = "libFS-1.0.7";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libFS-1.0.7.tar.bz2;
      sha256 = "1wy4km3qwwajbyl8y9pka0zwizn7d9pfiyjgzba02x3a083lr79f";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontsproto xproto xtrans ];

  }) // {inherit fontsproto xproto xtrans ;};

  libXTrap = (mkDerivation "libXTrap" {
    name = "libXTrap-1.0.1";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXTrap-1.0.1.tar.bz2;
      sha256 = "0bi5wxj6avim61yidh9fd3j4n8czxias5m8vss9vhxjnk1aksdwg";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ trapproto libX11 libXext xextproto libXt ];

  }) // {inherit trapproto libX11 libXext xextproto libXt ;};

  libXaw = (mkDerivation "libXaw" {
    name = "libXaw-1.0.13";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXaw-1.0.13.tar.bz2;
      sha256 = "1kdhxplwrn43d9jp3v54llp05kwx210lrsdvqb6944jp29rhdy4f";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext xextproto libXmu libXpm xproto libXt ];

  }) // {inherit libX11 libXext xextproto libXmu libXpm xproto libXt ;};

  libXaw3d = (mkDerivation "libXaw3d" {
    name = "libXaw3d-1.6.2";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXaw3d-1.6.2.tar.bz2;
      sha256 = "0awplv1nf53ywv01yxphga3v6dcniwqnxgnb0cn4khb121l12kxp";
    };
    nativeBuildInputs = [ bison flex utilmacros ];
    buildInputs = [ libX11 libXext libXmu libXpm xproto libXt ];

  }) // {inherit libX11 libXext libXmu libXpm xproto libXt ;};

  libXevie = (mkDerivation "libXevie" {
    name = "libXevie-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXevie-1.0.3.tar.bz2;
      sha256 = "0wzx8ic38rj2v53ax4jz1rk39idy3r3m1apc7idmk3z54chkh2y0";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ evieext libX11 libXext xextproto xproto ];

  }) // {inherit evieext libX11 libXext xextproto xproto ;};

  libXfontcache = (mkDerivation "libXfontcache" {
    name = "libXfontcache-1.0.5";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfontcache-1.0.5.tar.bz2;
      sha256 = "1knbzagrisr68r7l7cv6iriw3rhkblzkh524dc7gllczahcr4qqd";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontcacheproto libX11 libXext xextproto ];

  }) // {inherit fontcacheproto libX11 libXext xextproto ;};

  libXmu = (mkDerivation "libXmu" {
    name = "libXmu-1.1.2";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXmu-1.1.2.tar.bz2;
      sha256 = "02wx6jw7i0q5qwx87yf94fsn3h0xpz1k7dz1nkwfwm1j71ydqvkm";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext xextproto xproto libXt ];

  }) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXp = (mkDerivation "libXp" {
    name = "libXp-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXp-1.0.3.tar.bz2;
      sha256 = "0mwc2jwmq03b1m9ihax5c6gw2ln8rc70zz4fsj3kb7440nchqdkz";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ printproto libX11 libXau libXext xextproto ];

  }) // {inherit printproto libX11 libXau libXext xextproto ;};

  libXpm = (mkDerivation "libXpm" {
    name = "libXpm-3.5.12";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXpm-3.5.12.tar.bz2;
      sha256 = "fd6a6de3da48de8d1bb738ab6be4ad67f7cb0986c39bd3f7d51dd24f7854bdec";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext xextproto xproto libXt ];

  }) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXprintAppUtil = (mkDerivation "libXprintAppUtil" {
    name = "libXprintAppUtil-1.0.1";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXprintAppUtil-1.0.1.tar.bz2;
      sha256 = "198ad7pmkp31vcs0iwd8z3vw08p69hlyjmzgk7sdny9k01368q14";
    };
    nativeBuildInputs = [ ];
    buildInputs = [ printproto libX11 libXau libXp libXprintUtil xproto ];

  }) // {inherit printproto libX11 libXau libXp libXprintUtil xproto ;};

  libXprintUtil = (mkDerivation "libXprintUtil" {
    name = "libXprintUtil-1.0.1";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXprintUtil-1.0.1.tar.bz2;
      sha256 = "0v3fh9fqgravl8xl509swwd9a2v7iw38szhlpraiyq5r402axdkj";
    };
    nativeBuildInputs = [ ];
    buildInputs = [ printproto libX11 libXau libXp libXt ];

  }) // {inherit printproto libX11 libXau libXp libXt ;};

  libXvMC = (mkDerivation "libXvMC" {
    name = "libXvMC-1.0.10";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXvMC-1.0.10.tar.bz2;
      sha256 = "0bpffxr5dal90a8miv2w0rif61byqxq2f5angj4z1bnznmws00g5";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ videoproto libX11 libXext xextproto xproto libXv ];

  }) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};

  libXxf86dga = (mkDerivation "libXxf86dga" {
    name = "libXxf86dga-1.1.4";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86dga-1.1.4.tar.bz2;
      sha256 = "0zn7aqj8x0951d8zb2h2andldvwkzbsc4cs7q023g6nzq6vd9v4f";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext xextproto xf86dgaproto xproto ];

  }) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};

  libXxf86misc = (mkDerivation "libXxf86misc" {
    name = "libXxf86misc-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86misc-1.0.3.tar.bz2;
      sha256 = "0nvbq9y6k6m9hxdvg3crycqsnnxf1859wrisqcs37z9fhq044gsn";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext xextproto xf86miscproto xproto ];

  }) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};

  libXxf86vm = (mkDerivation "libXxf86vm" {
    name = "libXxf86vm-1.1.4";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86vm-1.1.4.tar.bz2;
      sha256 = "0mydhlyn72i7brjwypsqrpkls3nm6vxw0li8b2nw0caz7kwjgvmg";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext xextproto xf86vidmodeproto xproto ];

  }) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};

  libpciaccess = (mkDerivation "libpciaccess" {
    name = "libpciaccess-0.14";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.14.tar.bz2;
      sha256 = "3df543e12afd41fea8eac817e48cbfde5aed8817b81670a4e9e493bb2f5bf2a4";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ zlib ];

  }) // {inherit zlib ;};

  libxshmfence = (mkDerivation "libxshmfence" {
    name = "libxshmfence-1.2";
    src = fetchurl {
      url = mirror://xorg/individual/lib/libxshmfence-1.2.tar.bz2;
      sha256 = "032b0nlkdrpbimdld4gqvhqx53rzn8fawvf1ybhzn7lcswgjs6yj";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ xproto ];

  }) // {inherit xproto ;};

  lndir = (mkDerivation "lndir" {
    name = "lndir-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/util/lndir-1.0.3.tar.bz2;
      sha256 = "0pdngiy8zdhsiqx2am75yfcl36l7kd7d7nl0rss8shcdvsqgmx29";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ xproto ];

  }) // {inherit xproto ;};

  luit = (mkDerivation "luit" {
    name = "luit-1.1.1";
    src = fetchurl {
      url = mirror://xorg/individual/app/luit-1.1.1.tar.bz2;
      sha256 = "0dn694mk56x6hdk6y9ylx4f128h5jcin278gnw2gb807rf3ygc1h";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libfontenc ];

  }) // {inherit libfontenc ;};

  makedepend = (mkDerivation "makedepend" {
    name = "makedepend-1.0.5";
    src = fetchurl {
      url = mirror://xorg/individual/util/makedepend-1.0.5.tar.bz2;
      sha256 = "09alw99r6y2bbd1dc786n3jfgv4j520apblyn7cw6jkjydshba7p";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ xproto ];

  }) // {inherit xproto ;};

  mkfontdir = (mkDerivation "mkfontdir" {
    name = "mkfontdir-1.0.7";
    src = fetchurl {
      url = mirror://xorg/individual/app/mkfontdir-1.0.7.tar.bz2;
      sha256 = "0c3563kw9fg15dpgx4dwvl12qz6sdqdns1pxa574hc7i5m42mman";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  mkfontscale = (mkDerivation "mkfontscale" {
    name = "mkfontscale-1.1.2";
    src = fetchurl {
      url = mirror://xorg/individual/app/mkfontscale-1.1.2.tar.bz2;
      sha256 = "081z8lwh9c1gyrx3ad12whnpv3jpfbqsc366mswpfm48mwl54vcc";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libfontenc freetype xproto zlib ];

  }) // {inherit libfontenc freetype xproto zlib ;};

  pixman = (mkDerivation "pixman" {
    name = "pixman-0.34.0";
    src = fetchurl {
      url = mirror://xorg/individual/lib/pixman-0.34.0.tar.bz2;
      sha256 = "184lazwdpv67zrlxxswpxrdap85wminh1gmq1i5lcz6iycw39fir";
    };
    nativeBuildInputs = [ ];
    buildInputs = [ libpng ];

  }) // {inherit libpng ;};

  setxkbmap = (mkDerivation "setxkbmap" {
    name = "setxkbmap-1.3.1";
    src = fetchurl {
      url = mirror://xorg/individual/app/setxkbmap-1.3.1.tar.bz2;
      sha256 = "1qfk097vjysqb72pq89h0la3462kbb2dh1d11qzs2fr67ybb7pd9";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libxkbfile ];

  }) // {inherit libX11 libxkbfile ;};

  xauth = (mkDerivation "xauth" {
    name = "xauth-1.0.10";
    src = fetchurl {
      url = mirror://xorg/individual/app/xauth-1.0.10.tar.bz2;
      sha256 = "5afe42ce3cdf4f60520d1658d2b17face45c74050f39af45dccdc95e73fafc4d";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXau libXext libXmu xproto ];

  }) // {inherit libX11 libXau libXext libXmu xproto ;};

  xbacklight = (mkDerivation "xbacklight" {
    name = "xbacklight-1.2.1";
    src = fetchurl {
      url = mirror://xorg/individual/app/xbacklight-1.2.1.tar.bz2;
      sha256 = "0arnd1j8vzhzmw72mqhjjcb2qwcbs9qphsy3ps593ajyld8wzxhp";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libxcb xcbutil ];

  }) // {inherit libxcb xcbutil ;};

  xbitmaps = (mkDerivation "xbitmaps" {
    name = "xbitmaps-1.1.1";
    src = fetchurl {
      url = mirror://xorg/individual/data/xbitmaps-1.1.1.tar.bz2;
      sha256 = "178ym90kwidia6nas4qr5n5yqh698vv8r02js0r4vg3b6lsb0w9n";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  xcbutil = (mkDerivation "xcbutil" {
    name = "xcb-util-0.4.0";
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-0.4.0.tar.bz2;
      sha256 = "1sahmrgbpyki4bb72hxym0zvxwnycmswsxiisgqlln9vrdlr9r26";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libxcb ];

  }) // {inherit libxcb ;};

  xcbutilimage = (mkDerivation "xcbutilimage" {
    name = "xcb-util-image-0.4.0";
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-image-0.4.0.tar.bz2;
      sha256 = "1z1gxacg7q4cw6jrd26gvi5y04npsyavblcdad1xccc8swvnmf9d";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libxcb xcbutil xproto ];

  }) // {inherit libxcb xcbutil xproto ;};

  xcbutilkeysyms = (mkDerivation "xcbutilkeysyms" {
    name = "xcb-util-keysyms-0.4.0";
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-keysyms-0.4.0.tar.bz2;
      sha256 = "1nbd45pzc1wm6v5drr5338j4nicbgxa5hcakvsvm5pnyy47lky0f";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libxcb xproto ];

  }) // {inherit libxcb xproto ;};

  xcbutilrenderutil = (mkDerivation "xcbutilrenderutil" {
    name = "xcb-util-renderutil-0.3.9";
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-renderutil-0.3.9.tar.bz2;
      sha256 = "0nza1csdvvxbmk8vgv8vpmq7q8h05xrw3cfx9lwxd1hjzd47xsf6";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libxcb ];

  }) // {inherit libxcb ;};

  xcbutilwm = (mkDerivation "xcbutilwm" {
    name = "xcb-util-wm-0.4.1";
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-wm-0.4.1.tar.bz2;
      sha256 = "0gra7hfyxajic4mjd63cpqvd20si53j1q3rbdlkqkahfciwq3gr8";
    };
    nativeBuildInputs = [ gnum4 utilmacros ];
    buildInputs = [ libxcb ];

  }) // {inherit libxcb ;};

  xcompmgr = (mkDerivation "xcompmgr" {
    name = "xcompmgr-1.1.7";
    src = fetchurl {
      url = mirror://xorg/individual/app/xcompmgr-1.1.7.tar.bz2;
      sha256 = "14k89mz13jxgp4h2pz0yq0fbkw1lsfcb3acv8vkknc9i4ld9n168";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libXcomposite libXdamage libXext libXfixes libXrender ];

  }) // {inherit libXcomposite libXdamage libXext libXfixes libXrender ;};

  xcursorgen = (mkDerivation "xcursorgen" {
    name = "xcursorgen-1.0.6";
    src = fetchurl {
      url = mirror://xorg/individual/app/xcursorgen-1.0.6.tar.bz2;
      sha256 = "0v7nncj3kaa8c0524j7ricdf4rvld5i7c3m6fj55l5zbah7r3j1i";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libpng libX11 libXcursor ];

  }) // {inherit libpng libX11 libXcursor ;};

  xcursorthemes = (mkDerivation "xcursorthemes" {
    name = "xcursor-themes-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/data/xcursor-themes-1.0.4.tar.bz2;
      sha256 = "11mv661nj1p22sqkv87ryj2lcx4m68a04b0rs6iqh3fzp42jrzg3";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libXcursor ];

  }) // {inherit libXcursor ;};

  xf86dga = (mkDerivation "xf86dga" {
    name = "xf86dga-1.0.3";
    src = fetchurl {
      url = mirror://xorg/individual/app/xf86dga-1.0.3.tar.bz2;
      sha256 = "0lm2wrsgzc1g97phm428bkn42zm0np77prdp6dpxnplx0h8p9n5l";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXxf86dga ];

  }) // {inherit libX11 libXxf86dga ;};

  xf86inputevdev = (mkDerivation "xf86inputevdev" {
    name = "xf86-input-evdev-2.10.5";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.10.5.tar.bz2;
      sha256 = "9edaa6205baf6d2922cc4db3d8e54a7e7773b5f733b0ae90f6be7725f983b70d";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto libevdev systemd_lib mtdev xorgserver xproto ];

  }) // {inherit inputproto libevdev systemd_lib mtdev xorgserver xproto ;};

  xf86inputjoystick = (mkDerivation "xf86inputjoystick" {
    name = "xf86-input-joystick-1.6.3";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-joystick-1.6.3.tar.bz2;
      sha256 = "9e7669ecf0f23b8e5dc39d5397cf28296f692aa4c0e4255f5e02816612c18eab";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto kbproto xorgserver xproto ];

  }) // {inherit inputproto kbproto xorgserver xproto ;};

  xf86inputkeyboard = (mkDerivation "xf86inputkeyboard" {
    name = "xf86-input-keyboard-1.9.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-keyboard-1.9.0.tar.bz2;
      sha256 = "f7c900f21752683402992b288d5a2826de7a6c0c0abac2aadd7e8a409e170388";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto xorgserver xproto ];

  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputlibinput = (mkDerivation "xf86inputlibinput" {
    name = "xf86-input-libinput-0.26.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-libinput-0.26.0.tar.bz2;
      sha256 = "abca558fc2226f295691f1cf3412d4c0edeaa439f677ca25b5c9fab310d2387b";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto libinput xorgserver xproto ];

  }) // {inherit inputproto libinput xorgserver xproto ;};

  xf86inputmouse = (mkDerivation "xf86inputmouse" {
    name = "xf86-input-mouse-1.9.2";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-mouse-1.9.2.tar.bz2;
      sha256 = "f425d5b05c6ab412a27e0a1106bb83f9e2662b307210abbe48270892387f4b2f";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto xorgserver xproto ];

  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputsynaptics = (mkDerivation "xf86inputsynaptics" {
    name = "xf86-input-synaptics-1.9.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-synaptics-1.9.0.tar.bz2;
      sha256 = "afba3289d7a40217a19d90db98ce181772f9ca6d77e1898727b0afcf02073b5a";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto libevdev randrproto recordproto libX11 libXi xorgserver xproto libXtst ];

  }) // {inherit inputproto libevdev randrproto recordproto libX11 libXi xorgserver xproto libXtst ;};

  xf86inputvmmouse = (mkDerivation "xf86inputvmmouse" {
    name = "xf86-input-vmmouse-13.1.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2;
      sha256 = "06ckn4hlkpig5vnivl0zj8a7ykcgvrsj8b3iccl1pgn1gaamix8a";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto systemd_lib randrproto xorgserver xproto ];

  }) // {inherit inputproto systemd_lib randrproto xorgserver xproto ;};

  xf86videoamd = (mkDerivation "xf86videoamd" {
    name = "xf86-video-amd-2.7.7.7";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-amd-2.7.7.7.tar.bz2;
      sha256 = "1pp9d3vpyj7iz5iz2wzvb2awmpiw1xdf2lff64nkkilbi01pqqrz";
    };
    nativeBuildInputs = [ ];
    buildInputs = [ fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];

  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videoamdgpu = (mkDerivation "xf86videoamdgpu" {
    name = "xf86-video-amdgpu-1.3.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-amdgpu-1.3.0.tar.bz2;
      sha256 = "c1630f228938be949273f72b29ae70822dde064ad79c3ccb14d55f427e3f4e70";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontsproto opengl-dummy glamoregl libdrm systemd_lib randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto damageproto fixesproto ];

  }) // {inherit fontsproto opengl-dummy glamoregl libdrm systemd_lib randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videoati = (mkDerivation "xf86videoati" {
    name = "xf86-video-ati-7.9.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ati-7.9.0.tar.bz2;
      sha256 = "3cad872e6330afb1707da11e4e959e6887ebe5bcd81854b4d2e496c52c059875";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontsproto glamoregl libdrm systemd_lib libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto damageproto fixesproto ];

  }) // {inherit fontsproto glamoregl libdrm systemd_lib libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videointel = (mkDerivation "xf86videointel" {
    name = "xf86-video-intel-2.99.917";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.99.917.tar.bz2;
      sha256 = "1jb7jspmzidfixbc0gghyjmnmpqv85i7pi13l4h2hn2ml3p83dq0";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ cairo dri2proto dri3proto fontsproto intelgputools libdrm libpng systemd_lib libpciaccess pixman presentproto randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes xorgserver xproto libXrandr libXrender libxshmfence libXtst libXvMC ];

  }) // {inherit cairo dri2proto dri3proto fontsproto intelgputools libdrm libpng systemd_lib libpciaccess pixman presentproto randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes xorgserver xproto libXrandr libXrender libxshmfence libXtst libXvMC ;};

  xf86videomodesetting = (mkDerivation "xf86videomodesetting" {
    name = "xf86-video-modesetting-0.9.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-modesetting-0.9.0.tar.bz2;
      sha256 = "0p6pjn5bnd2wr3lmas4b12zcq12d9ilvssga93fzlg90fdahikwh";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontsproto libdrm systemd_lib libpciaccess randrproto libX11 xextproto xorgserver xproto ];

  }) // {inherit fontsproto libdrm systemd_lib libpciaccess randrproto libX11 xextproto xorgserver xproto ;};

  xf86videonouveau = (mkDerivation "xf86videonouveau" {
    name = "xf86-video-nouveau-1.0.15";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nouveau-1.0.15.tar.bz2;
      sha256 = "aede10fd395610a328697adca3434fb14e9afbd79911d6c8545cfa2c0e541d4c";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ dri2proto fontsproto libdrm systemd_lib libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];

  }) // {inherit dri2proto fontsproto libdrm systemd_lib libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videonv = (mkDerivation "xf86videonv" {
    name = "xf86-video-nv-2.1.20";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nv-2.1.20.tar.bz2;
      sha256 = "1gqh1khc4zalip5hh2nksgs7i3piqq18nncgmsx9qvzi05azd5c3";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];

  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videov4l = (mkDerivation "xf86videov4l" {
    name = "xf86-video-v4l-0.2.0";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    nativeBuildInputs = [ ];
    buildInputs = [ randrproto videoproto xorgserver xproto ];

  }) // {inherit randrproto videoproto xorgserver xproto ;};

  xf86videovmware = (mkDerivation "xf86videovmware" {
    name = "xf86-video-vmware-13.2.1";
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vmware-13.2.1.tar.bz2;
      sha256 = "e2f7f7101fba7f53b268e7a25908babbf155b3984fb5268b3d244eb6c11bf62b";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ];

  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ;};

  xfs = (mkDerivation "xfs" {
    name = "xfs-1.1.4";
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.1.4.tar.bz2;
      sha256 = "1ylz4r7adf567rnlbb52yi9x3qi4pyv954kkhm7ld4f0fkk7a2x4";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libXfont xproto xtrans ];

  }) // {inherit libXfont xproto xtrans ;};

  xhost = (mkDerivation "xhost" {
    name = "xhost-1.0.7";
    src = fetchurl {
      url = mirror://xorg/individual/app/xhost-1.0.7.tar.bz2;
      sha256 = "16n26xw6l01zq31d4qvsaz50misvizhn7iihzdn5f7s72pp1krlk";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXau libXmu xproto ];

  }) // {inherit libX11 libXau libXmu xproto ;};

  xinput = (mkDerivation "xinput" {
    name = "xinput-1.6.2";
    src = fetchurl {
      url = mirror://xorg/individual/app/xinput-1.6.2.tar.bz2;
      sha256 = "1i75mviz9dyqyf7qigzmxq8vn31i86aybm662fzjz5c086dx551n";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ inputproto libX11 libXext libXi libXinerama libXrandr ];

  }) // {inherit inputproto libX11 libXext libXi libXinerama libXrandr ;};

  xkbcomp = (mkDerivation "xkbcomp" {
    name = "xkbcomp-1.4.0";
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbcomp-1.4.0.tar.bz2;
      sha256 = "bc69c8748c03c5ad9afdc8dff9db11994dd871b614c65f8940516da6bf61ce6b";
    };
    nativeBuildInputs = [ bison utilmacros ];
    buildInputs = [ libX11 libxkbfile xproto ];

  }) // {inherit libX11 libxkbfile xproto ;};

  xkeyboardconfig = (mkDerivation "xkeyboardconfig" {
    name = "xkeyboard-config-2.22";
    src = fetchurl {
      url = mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.22.tar.bz2;
      sha256 = "deaec9989fbc443358b43864437b7b6d39caff07890a4a8055105ce9fcaa59bd";
    };
    nativeBuildInputs = [ intltool utilmacros ];
    buildInputs = [ libX11 xproto ];

  }) // {inherit libX11 xproto ;};

  xlsclients = (mkDerivation "xlsclients" {
    name = "xlsclients-1.1.3";
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsclients-1.1.3.tar.bz2;
      sha256 = "0g9x7rrggs741x9xwvv1k9qayma980d88nhdqw7j3pn3qvy6d5jx";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libxcb ];

  }) // {inherit libxcb ;};

  xman = (mkDerivation "xman" {
    name = "xman-1.1.4";
    src = fetchurl {
      url = mirror://xorg/individual/app/xman-1.1.4.tar.bz2;
      sha256 = "0afzhiygy1mdxyr22lhys5bn94qdw3qf8vhbxclwai9p7wp9vymk";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libXaw xproto libXt ];

  }) // {inherit libXaw xproto libXt ;};

  xmessage = (mkDerivation "xmessage" {
    name = "xmessage-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/app/xmessage-1.0.4.tar.bz2;
      sha256 = "0s5bjlpxnmh8sxx6nfg9m0nr32r1sr3irr71wsnv76s33i34ppxw";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libXaw libXt ];

  }) // {inherit libXaw libXt ;};

  xmodmap = (mkDerivation "xmodmap" {
    name = "xmodmap-1.0.9";
    src = fetchurl {
      url = mirror://xorg/individual/app/xmodmap-1.0.9.tar.bz2;
      sha256 = "0y649an3jqfq9klkp9y5gj20xb78fw6g193f5mnzpl0hbz6fbc5p";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 xproto ];

  }) // {inherit libX11 xproto ;};

  xorgcffiles = (mkDerivation "xorgcffiles" {
    name = "xorg-cf-files-1.0.6";
    src = fetchurl {
      url = mirror://xorg/individual/util/xorg-cf-files-1.0.6.tar.bz2;
      sha256 = "0kckng0zs1viz0nr84rdl6dswgip7ndn4pnh5nfwnviwpsfmmksd";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ ];

  }) // {inherit ;};

  xpr = (mkDerivation "xpr" {
    name = "xpr-1.0.4";
    src = fetchurl {
      url = mirror://xorg/individual/app/xpr-1.0.4.tar.bz2;
      sha256 = "1dbcv26w2yand2qy7b3h5rbvw1mdmdd57jw88v53sgdr3vrqvngy";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXmu xproto ];

  }) // {inherit libX11 libXmu xproto ;};

  xprop = (mkDerivation "xprop" {
    name = "xprop-1.2.2";
    src = fetchurl {
      url = mirror://xorg/individual/app/xprop-1.2.2.tar.bz2;
      sha256 = "1ilvhqfjcg6f1hqahjkp8qaay9rhvmv2blvj3w9asraq0aqqivlv";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 xproto ];

  }) // {inherit libX11 xproto ;};

  xpyb = (mkDerivation "xpyb" {
    name = "xpyb-1.3.1";
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xpyb-1.3.1.tar.bz2;
      sha256 = "0rkkk2n9g2n2cslvdnb732zwmiijlgn7i9il6w296f5q0mxqfk7x";
    };
    nativeBuildInputs = [ python ];
    buildInputs = [ libxcb xcbproto ];

  }) // {inherit libxcb xcbproto ;};

  xrandr = (mkDerivation "xrandr" {
    name = "xrandr-1.5.0";
    src = fetchurl {
      url = mirror://xorg/individual/app/xrandr-1.5.0.tar.bz2;
      sha256 = "1kaih7rmzxr1vp5a5zzjhm5x7dn9mckya088sqqw026pskhx9ky1";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 xproto libXrandr libXrender ];

  }) // {inherit libX11 xproto libXrandr libXrender ;};

  xrdb = (mkDerivation "xrdb" {
    name = "xrdb-1.1.0";
    src = fetchurl {
      url = mirror://xorg/individual/app/xrdb-1.1.0.tar.bz2;
      sha256 = "0nsnr90wazcdd50nc5dqswy0bmq6qcj14nnrhyi7rln9pxmpp0kk";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXmu xproto ];

  }) // {inherit libX11 libXmu xproto ;};

  xset = (mkDerivation "xset" {
    name = "xset-1.2.3";
    src = fetchurl {
      url = mirror://xorg/individual/app/xset-1.2.3.tar.bz2;
      sha256 = "0qw0iic27bz3yz2wynf1gxs70hhkcf9c4jrv7zhlg1mq57xz90j3";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXext libXfontcache libXmu xproto libXxf86misc ];

  }) // {inherit libX11 libXext libXfontcache libXmu xproto libXxf86misc ;};

  xsetroot = (mkDerivation "xsetroot" {
    name = "xsetroot-1.1.1";
    src = fetchurl {
      url = mirror://xorg/individual/app/xsetroot-1.1.1.tar.bz2;
      sha256 = "1nf3ii31m1knimbidaaym8p61fq3blv8rrdr2775yhcclym5s8ds";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 xbitmaps libXcursor libXmu xproto ];

  }) // {inherit libX11 xbitmaps libXcursor libXmu xproto ;};

  xts = (mkDerivation "xts" {
    name = "xts-0.99.1";
    src = fetchurl {
      url = mirror://xorg/individual/test/xts-0.99.1.tar.bz2;
      sha256 = "08sanl2nhbbscid767i5zwk0nv2q3ds89w96ils8qfigd57kacc5";
    };
    nativeBuildInputs = [ utilmacros ];
    buildInputs = [ libX11 libXau libXaw libXext libXi libXmu libXt xtrans libXtst ];

  }) // {inherit libX11 libXau libXaw libXext libXi libXmu libXt xtrans libXtst ;};

}; in xorg
