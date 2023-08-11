{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pyte
, pexpect
, ptyprocess
, jedi
, git
, lineedit
, prompt-toolkit
, pygments
, rchitect
, six
, R
, rPackages
}:

buildPythonPackage rec {
  pname = "radian";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zA7R9UIB0hOWev10Y4oySIKeIxTOo0V6Q3Fxe+FeHSU=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
    substituteInPlace setup.py --replace '0.3.39,<0.4.0' '0.3.39'
  '';

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  propagatedBuildInputs = [
    lineedit
    prompt-toolkit
    pygments
    rchitect
    six
  ] ++ (with rPackages; [
    reticulate
    askpass
  ]);

  nativeCheckInputs = [
    pytestCheckHook
    pyte
    pexpect
    ptyprocess
    jedi
    git
  ];

  preCheck = ''
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "A 21 century R console";
    homepage = "https://github.com/randy3k/radian";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
