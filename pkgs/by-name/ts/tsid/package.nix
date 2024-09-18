{
  cmake,
  doxygen,
  eiquadprog,
  fetchFromGitHub,
  lib,
  osqp-eigen,
  pkg-config,
  pinocchio,
  proxsuite,
  stdenv,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsid";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "tsid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-id6OCOX01o41Z5kqzwvjYa5uoQZtzhRaFBuOBhbLcTA=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_OSQP" true)
    (lib.cmakeBool "BUILD_WITH_PROXQP" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
  ];

  outputs = [
    "doc"
    "out"
  ];

  nativeBuildInputs = [
    doxygen
    cmake
    pkg-config
  ] ++ lib.optional pythonSupport python3Packages.python;

  propagatedBuildInputs =
    [
      eiquadprog
      osqp-eigen
      proxsuite
    ]
    ++ lib.optional (!pythonSupport) pinocchio ++ lib.optional pythonSupport python3Packages.pinocchio;

  doCheck = true;
  # pythonImportsCheck, but in stdenv.mkDerivation
  postInstall = lib.optionalString pythonSupport ''
    PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
    python -c "import tsid"
  '';

  meta = {
    description = "Efficient Task Space Inverse Dynamics (TSID) based on Pinocchio";
    homepage = "https://github.com/stack-of-tasks/tsid";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
