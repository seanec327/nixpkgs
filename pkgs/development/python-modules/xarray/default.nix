{ lib
, buildPythonPackage
, fetchPypi
, flaky
, numpy
, packaging
, pandas
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "2024.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XB2xnv3eYdt/rtrY/JRPTilpj7b71XjTUmaLY1mL0dg=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
  ];

  nativeCheckInputs = [
    flaky
    pytestCheckHook
  ];

  pytestFlagsArray =[
    # ModuleNotFoundError: No module named 'xarray.datatree_'
    "--ignore xarray/tests/datatree"
  ];

  pythonImportsCheck = [
    "xarray"
  ];

  meta = with lib; {
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = licenses.asl20;
    maintainers = with maintainers; [ fridh ];
  };
}
