{ stdenv, fetchurl, openvpn, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, procps, module_init_tools, dbus_glib
, gtk3, libgnome_keyring, networkmanagerapplet }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-openvpn";
  version = networkmanager.version;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/1.0/${pname}-${version}.tar.xz";
    sha256 = "132xwkgyfnpma7m6b06jhrd1g9xk5dlpx8alnsf03ls3z92bd0n9";
  };

  buildInputs = [ openvpn networkmanager libsecret dbus_glib ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libgnome_keyring
                                        networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
    "--disable-static"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/sbin/sysctl"
     substituteInPlace "src/nm-openvpn-service.c" \
       --replace "/sbin/openvpn" "${openvpn}/sbin/openvpn" \
       --replace "/sbin/modprobe" "${module_init_tools}/sbin/modprobe"
     substituteInPlace "properties/auth-helpers.c" \
       --replace "/sbin/openvpn" "${openvpn}/sbin/openvpn"
  '';

  postConfigure = ''
     substituteInPlace "./auth-dialog/Makefile" \
       --replace "-Wstrict-prototypes" "" \
       --replace "-Werror" ""
     substituteInPlace "properties/Makefile" \
       --replace "-Wstrict-prototypes" "" \
       --replace "-Werror" ""
  '';

  meta = {
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
