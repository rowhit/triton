{ stdenv
, fetchurl
}:

let
  sources = {
    "${stdenv.lib.head stdenv.lib.platforms.x86_64-linux}" = {
      sha256 = "d0704d10237c66c3efafa6f7e5570c59a1d3fe5c6d99487540f90ebb37cd84c4";
      platform = "x86_64-unknown-linux-gnu";
    };
  };

  version = "1.9.0";
  
  inherit (sources."${stdenv.targetSystem}")
    platform
    sha256;
in
stdenv.mkDerivation {
  name = "rustc-bootstrap-${version}";
  
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-${platform}.tar.gz";
    inherit sha256;
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r rustc/* "$out"
    FILES=($(find $out/{bin,lib} -type f))
    for file in "''${FILES[@]}"; do
      echo "Patching $file" >&2
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath "$out/lib:${stdenv.cc.cc}/lib" "$file" || true
    done
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [
      wkennington
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}