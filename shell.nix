# Usage:
#
#     $ nix-shell --pure --argstr version 2022.1.10 --argstr tag 20.09
#

{
  tag ? "22.05",
  version ? "2022.7.17"
}:
let
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${tag}.tar.gz") {};
  pypkgs = pkgs.python3Packages;

  nbqa = pypkgs.buildPythonPackage rec {
    pname = "nbqa";
    version = "1.3.1";

    src = pypkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-66fz00k8ZCmww/ladkBnsrAHdF9ykDcphVCmFle/7F4=";
    };

    propagatedBuildInputs = with pypkgs; [ ipython tomli tokenize-rt ];

  };

  dgl = pypkgs.buildPythonPackage rec {
     pname = "dgl";
     version = "0.9.0";
     format = "wheel";

     src = pypkgs.fetchPypi rec {
       inherit pname version format;
       sha256 = "sha256-k+BPwi8/H8NP7Fp/AliuUaXcxoTxGoM6gGNyFLxW9Jg=";
       dist = "cp39";
       python = "cp39";
       abi = "cp39";
       platform = "manylinux1_x86_64";
     };

     propagatedBuildInputs = with pypkgs; [
       tqdm
       numpy
       networkx
       psutil
       scipy
       requests
     ];

     doCheck = false;
  };

  matminer = pypkgs.buildPythonPackage rec {
    pname = "matminer";
    version = "0.6.5";

     src = pypkgs.fetchPypi {
       inherit pname version;
       sha256 = "sha256-RRGJZdaNzyMxAMig+aU5Txu6ELfW4oKJcjuut3HeaqE=";
     };

     nativeBuildInputs = with pypkgs; [
       monty
       sympy
       requests
       future
       plotly
       numpy
       scikit-learn
       pymongo
       jsonschema
       pint
       pymatgen
     ];

     propagatedBuildInputs = nativeBuildInputs;

     postPatch = ''
       rm requirements-optional.txt
       touch requirements-optional.txt
     '';

     doCheck = false;
  };

  jarvisversion = version;
  jarvistools =  pypkgs.buildPythonPackage rec {
     pname = "jarvis-tools";
     version = jarvisversion;

     src = pypkgs.fetchPypi {
       inherit pname version;
       sha256 = "sha256-WmF3IBvM6Bje1TEIXWOjNV5Bw2bpkWJ3+ZI5k55lOCU=";
     };

     propagatedBuildInputs = with pypkgs; [
       joblib
       flask
       numpy
       phonopy
       scipy
       matplotlib
       spglib
       requests
       toolz
       pytest
       bokeh
       networkx
       xmltodict
       tqdm
       pandas
       pytorch
       dgl
     ];

     doCheck = false;
  };

  nixes_src = builtins.fetchTarball "https://github.com/wd15/nixes/archive/9a757526887dfd56c6665290b902f93c422fd6b1.zip";
  jupyter_extra = pypkgs.callPackage "${nixes_src}/jupyter/default.nix" {
    jupyterlab=(if pkgs.stdenv.isDarwin then pypkgs.jupyter else pypkgs.jupyterlab);
  };

in
  pkgs.mkShell rec {
    pname = "jarvis-notebooks";
    nativeBuildInputs = with pypkgs; [
      jupyter
      jupyter_extra
      jarvistools
      nbqa
      pip
      matminer
      plotly
      nbval
      pytest
      black
      pylint
    ];
    shellHook = ''

      SOURCE_DATE_EPOCH=$(date +%s)
      export PYTHONUSERBASE=$PWD/.local
      export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
      export PYTHONPATH=$PYTHONPATH:$USER_SITE
      export PATH=$PATH:$PYTHONUSERBASE/bin

    '';
  }
