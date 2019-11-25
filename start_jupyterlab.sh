#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check for first time run.
if [ ! -d "$SCRIPT_DIR/bin" ] || [ ! -f "$SCRIPT_DIR/bin/activate" ]; then
  python3 -m venv $SCRIPT_DIR
  cp jupyterlab.desktop.in jupyterlab.desktop
  sed -i "s|PATH|$SCRIPT_DIR|g" jupyterlab.desktop
  ln -sf jupyterlab.desktop $HOME/.local/share/applications
  ln -sf $(which octave) octave-cli-wrapper
  DO_UPDATE=true
fi

source $SCRIPT_DIR/bin/activate

if [ "$1" = "update" ] || [ "$DO_UPDATE" = "true" ]; then
  pip install --upgrade pip jupyterlab octave_kernel sympy
fi

export OCTAVE_EXECUTABLE=$SCRIPT_DIR/octave-cli-wrapper

jupyter lab --notebook-dir="$HOME"
