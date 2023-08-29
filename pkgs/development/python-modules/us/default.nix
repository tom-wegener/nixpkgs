{ lib
, buildPythonPackage
, fetchPypi
, jellyfish
}:

buildPythonPackage rec {
  pname = "us";
  version = "3.1.1";

  propagatedBuildInputs = [ jellyfish ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-40eWPo0kocp0N69EP6aFkXdoR7UMhlDY7w61NILnBcI=";
  };

  # Upstream requires jellyfish==0.5.6 but we have 0.6.1
  postPatch = ''
    substituteInPlace setup.py --replace "jellyfish==" "jellyfish>="
  '';

  doCheck = false; # pypi version doesn't include tests

  meta = {
    description = "A package for easily working with US and state metadata";
    longDescription = ''
    all US states and territories, postal abbreviations, Associated Press style
    abbreviations, FIPS codes, capitals, years of statehood, time zones, phonetic
    state name lookup, is contiguous or continental, URLs to shapefiles for state,
    census, congressional districts, counties, and census tracts
    '';
    homepage = "https://github.com/unitedstates/python-us/";
    license = lib.licenses.bsd3;
  };
}
