{ stdenv
, fetchurl
, flex
}:

let
  se_release = "20160223";
  se_url = "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases";
in
stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.5";

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "2bdeec56d0a08b082b93b40703b4b3329cc5562152f7254d8f6ef6b56afe850a";
  };

  nativeBuildInputs = [
    flex
  ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
  '';

  passthru = {
    inherit se_release se_url;
  };

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = stdenv.lib.licenses.gpl2;
  };
}