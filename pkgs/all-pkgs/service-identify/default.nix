{ stdenv
, buildPythonPackage
, fetchPyPi

, pythonPackages
}:

buildPythonPackage rec {
  name = "service-identify-${version}";
  version = "16.0.0";

  src = fetchPyPi {
    package = "service_identity";
    inherit version;
    sha256 = "0630e222f59f91f3db498be46b1d879ff220955d7bbad719a5cb9ad14e3c3036";
  };

  buildInputs = [
    pythonPackages.attrs
    pythonPackages.idna
    pythonPackages.pyasn1
    pythonPackages.pyasn1-modules
    pythonPackages.pyopenssl
  ];

  meta = with stdenv.lib; {
    description = "Service identity verification for pyOpenSSL";
    homepage = https://github.com/pyca/service_identity;
    license = licenses.bsd3;
    maintainers = with maintainers; [
      codyopel
    ];
    platforms = with platforms;
      x86_64-linux;
  };
}
