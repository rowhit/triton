{ stdenv
, cmake
, extra-cmake-modules
, fetchurl
, ninja
, pythonPackages

, pam
, qt5
, systemd_lib
, systemd-dummy
, xorg
}:

let
  version = "0.16.0";
in
stdenv.mkDerivation {
  name = "sddm-${version}";

  src = fetchurl {
    url = "https://github.com/sddm/sddm/releases/download/v${version}/sddm-${version}.tar.xz";
    hashOutput = false;  # https://github.com/sddm/sddm/releases
    sha256 = "e9138a23e7f0846f7dcb925964d301f1a597fae2047b373d7dbe4cd5340f8e3b";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ninja
    pythonPackages.docutils
  ];

  buildInputs = [
    pam
    qt5
    systemd_lib
    systemd-dummy
    xorg.libxcb
  ];

  postPatch = ''
    # Fix systemd journal dependency
    grep -q 'libsystemd-journal' CMakeLists.txt
    sed -i 's,libsystemd-journal,libsystemd,' CMakeLists.txt

    # Fix broken man page
    grep -q '\*\*@SYSTEM_CONFIG_DIR@\*$' data/man/sddm.conf.rst.in
    sed -i '/SYSTEM_CONFIG_DIR/s,@\*$,@**,' data/man/sddm.conf.rst.in
  '';

  preConfigure = ''
    touch "$TMPDIR/login.defs"
    cmakeFlagsArray+=(
      "-DQT_IMPORTS_DIR=$out/lib/qt5/qml"
      "-DSYSTEMD_SYSTEM_UNIT_DIR=$out/lib/systemd/system"
      "-DCMAKE_INSTALL_SYSCONFDIR=$out/etc"
      "-DCMAKE_INSTALL_LOCALSTATEDIR=$TMPDIR"
      "-DLOGIN_DEFS_PATH=$TMPDIR/login.defs"
    )
  '';

  cmakeFlags = [
    "-DBUILD_MAN_PAGES=ON"
    "-DUID_MIN=1000"
    "-DUID_MAX=2147483647"
  ];

  postConfigure = ''
    sed \
      -e '/#define RUNTIME_DIR/s,".*","/run/sddm",' \
      -e '/#define STATE_DIR/s,".*","/var/lib/sddm",' \
      -e '/#define CONFIG_FILE/s,".*","/etc/sddm.conf",' \
      -e '/#define CONFIG_DIR/s,".*","/etc/sddm.conf.d",' \
      -e '/#define SYSTEM_CONFIG_DIR/s,".*","/run/current-system/sw/lib/sddm/sddm.conf.d",' \
      -e '/#define LOG_FILE/s,".*","/var/log/sddm.log",' \
      -i ./src/common/Constants.h
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
