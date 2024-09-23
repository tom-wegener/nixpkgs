{ lib, stdenv, cmake, fetchzip, pkg-config, jansson, snappy, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "avro-c";
  version = "1.12.0";

  src = fetchzip {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "sha256-oHh+VDX1GhlNKNK5R/9X5LfjGtpAHDZZSlxgPA99ezU=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ jansson snappy xz zlib ];

  meta = with lib; {
    description = "C library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.all;
  };
}
