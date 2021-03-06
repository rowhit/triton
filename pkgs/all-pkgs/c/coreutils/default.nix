{ stdenv
, fetchurl
, perl

, acl
, gmp
, selinuxSupport? false
  , libselinux
  , libsepol
}:

let
  inherit (stdenv.lib)
    optionals;

  tarballUrls = version: [
    "mirror://gnu/coreutils/coreutils-${version}.tar.xz"
  ];

  version = "8.28";
in
stdenv.mkDerivation rec {
  name = "coreutils-${version}";

  src = fetchurl {
    urls = tarballUrls version;
    hashOutput = false;
    sha256 = "1117b1a16039ddd84d51a9923948307cfa28c2cea03d1a2438742253df0a0c65";
  };

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    acl
    gmp
  ] ++ optionals selinuxSupport [
    libselinux
    libsepol
  ];

  passthru = {
    srcVerification = fetchurl rec {
      failEarly = true;
      urls = tarballUrls "8.28";
      pgpsigUrls = map (n: "${n}.sig") urls;
      pgpKeyFingerprint = "6C37 DC12 121A 5006 BC1D  B804 DF6F D971 3060 37D9";
      inherit (src) outputHashAlgo;
      outputHash = "1117b1a16039ddd84d51a9923948307cfa28c2cea03d1a2438742253df0a0c65";
    };
  };

  meta = with stdenv.lib; {
    description = "Basic file, shell & text manipulation utilities of the GNU operating system";
    homepage = http://www.gnu.org/software/coreutils/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      i686-linux
      ++ x86_64-linux;
    priority = -9;  # This should have a higher priority than everything
  };
}
