#!/bin/bash
set -e


  echo ""
  echo "Generated files:"
  ls wheelhouse/
  echo ""

  if [[ "$GITHUB_REPOSITORY" == "mars-project/mars" ]]; then
    PYPI_REPO="https://upload.pypi.org/legacy/"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  else
    PYPI_REPO="https://test.pypi.org/legacy/"
    echo "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  fi

  echo "[distutils]"             > ~/.pypirc
  echo "index-servers ="        >> ~/.pypirc
  echo "    pypi"               >> ~/.pypirc
  echo "[pypi]"                 >> ~/.pypirc
  echo "repository=$PYPI_REPO"  >> ~/.pypirc
  echo "username=pyodps"        >> ~/.pypirc
  echo "password=$PYPI_PWD"     >> ~/.pypirc

  python -m pip install twine
  python -m twine upload -r pypi --skip-existing wheelhouse/*
fi
