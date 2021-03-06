{ stdenv
, fetchurl
, fetchFromGitHub
, lib
, python2Packages
}:

# TODO: build release tarballs, repo vendors pdfs

let
  version = "2017-09-10";
in
stdenv.mkDerivation rec {
  name = "opengl-headers-${version}";

  src = fetchurl {
    url = "http://opengl-headers.tar.xz";  # dummy url
    multihash = "QmY1EgsrwD8RjC1S6AWavDUjKWZ1pAafovQb97FaFedM1G";
    sha256 = "f79976ac9731f02b515c2eef164443acdaf34cc6ad9e60a6165e50ac82bac5fe";
  };

  configurePhase = ":";

  buildPhase = ":";

  installPhase = ''
    for api in GL{,ES{,2,3},SC{,2}}; do
      pushd $api
        while read header; do
          install -D -m644 -v $header $out/include/$(basename "$api")/$header
        done < <(find . -name "*.h" -printf '%P\n')
      popd
    done
  '';

  passthru = {
    generateDistTarball = stdenv.mkDerivation rec {
      name = "opengl-headers-${version}";

      src = fetchFromGitHub {
        version = 3;
        owner = "KhronosGroup";
        repo = "OpenGL-Registry";
        rev = "93e0595941ea275b95ba115e1f400283c652004d";
        sha256 = "40b8204a8c97e95913c31d11dc58527780e866424c5dd577f9a8ee2209612209";
      };

      nativeBuildInputs = [
        python2Packages.lxml
        python2Packages.python
      ];

      postPatch = ''
        sed -i xml/genglvnd.py \
          -e 's,drafts/,,'
      '';

      configurePhase = ":";

      buildPhase = ''
        # Some headers such as glx.h are not pre-generated, regenerate all
        # to be sure none are missing.
        pushd xml
          python genheaders.py
        popd
        pushd api
          for header in glcorearb.h glext.h gl.h; do
            python ../xml/genglvnd.py -registry ../xml/gl.xml GL/$header.h
          done
        popd

        tar -Jcvf opengl-headers-${version}.tar.xz api/
      '';

      installPhase = ''
        install -D -m644 -v 'opengl-headers-${version}.tar.xz' \
          "$out/opengl-headers-${version}.tar.xz"
      '';
    };
  };

  meta = with lib; {
    description = "OpenGL, OpenGL ES, and OpenGL ES-SC API headers.";
    homepage = https://github.com/KhronosGroup/OpenGL-Registry;
    license = licenses.mit;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
