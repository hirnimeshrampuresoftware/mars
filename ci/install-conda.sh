#!/bin/bash
PYTHON=$(cut -d '-' -f 1 <<< "$PYTHON")
UNAME="$(uname | awk '{print tolower($0)}')"
FILE_EXT="sh"
if [[ "$UNAME" == "darwin" ]]; then
  set -e
  ulimit -n 1024
  CONDA_OS="MacOSX"
elif [[ $UNAME == "linux" ]]; then
  sudo apt-get install -y liblz4-dev
  CONDA_OS="Linux"
elif [[ $UNAME == "mingw"* ]] || [[ $UNAME == "msys"* ]]; then
  CONDA_OS="Windows"
  FILE_EXT="exe"
fi

CONDA_FILE="Miniconda3-latest-${CONDA_OS}-x86_64.${FILE_EXT}"

TEST_PACKAGES="virtualenv"

if [[ "$FILE_EXT" == "sh" ]]; then
  if [ `uname -m` == "aarch64" ]; then
    curl -L -o "miniconda.sh" https://github.com/conda-forge/miniforge/releases/download/4.11.0-0/Mambaforge-4.11.0-0-Linux-aarch64.sh
  else
    curl -L -o "miniconda.${FILE_EXT}" https://repo.continuum.io/miniconda/$CONDA_FILE
  fi
  bash miniconda.sh -b -p $HOME/miniconda && rm -f miniconda.* 
  CONDA_BIN_PATH=$HOME/miniconda/bin
  TEST_PACKAGES="$TEST_PACKAGES nomkl libopenblas"
  export PATH="$HOME/miniconda/envs/test/bin:$HOME/miniconda/bin:$PATH"
else
  CONDA=$(echo "/$CONDA" | sed -e 's/\\/\//g' -e 's/://')
  echo "Using installed conda at $CONDA"
  CONDA_BIN_PATH=$CONDA/Scripts
fi
$CONDA_BIN_PATH/conda create --quiet --yes -n test python=$PYTHON $TEST_PACKAGES

if [[ "$CONDA_OS" == "Windows" ]]; then
  source "$CONDA/Scripts/activate" test
fi

#check python version
export PYTHON=$(python -c "import sys; print('.'.join(str(v) for v in sys.version_info[:3]))")
echo "Installed Python version: $PYTHON"
