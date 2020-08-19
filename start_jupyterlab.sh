#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

OCTAVE_VERSION=5.2.0
OCTAVE_IMG=$SCRIPT_DIR/gnu_octave_${OCTAVE_VERSION}.sif

# Check for Singularity to be installed.
if [ ! -x "$(command -v singularity)" ]; then
    echo -e "\n Singularity is not installed, please read\n"
    echo -e "\t https://sylabs.io/singularity/ \n\n how to install it.\n"
    exit
fi

# Check for Node.js to be installed.
if [ ! -x "$(command -v node)" ]; then
    echo -e "\n Node.js is not installed, please install it.\n"
    exit
fi

# Check for existing python environment.
if [ ! -d "$SCRIPT_DIR/bin" ] || [ ! -f "$SCRIPT_DIR/bin/activate" ]; then
  python3 -m venv $SCRIPT_DIR
  DO_UPDATE=true
fi

source $SCRIPT_DIR/bin/activate

# Update python environment, if necessary or requested.
if [ "$1" = "update" ] || [ "$DO_UPDATE" = "true" ]; then
  pip install --upgrade pip jupyterlab octave_kernel \
                        jupytext jupyter-book \
                        numpy sympy==1.5.1 matplotlib keras tensorflow
  jupyter lab build
fi

# Create Desktop launcher.
if [ ! -f "$SCRIPT_DIR/jupyterlab.desktop" ]; then
  cp jupyterlab.desktop.in jupyterlab.desktop
  sed -i "s|PATH|$SCRIPT_DIR|g" jupyterlab.desktop
  ln -sf $SCRIPT_DIR/jupyterlab.desktop $HOME/.local/share/applications
fi

# Obtain GNU Octave singularity image.
if [ ! -f "$OCTAVE_IMG" ]; then
  singularity pull library://siko1056/default/gnu_octave:${OCTAVE_VERSION}
fi

# Create custom link to launch Octave.
export OCTAVE_EXECUTABLE=$SCRIPT_DIR/octave-cli-jupyter
if [ ! -f "$OCTAVE_EXECUTABLE" ]; then
  echo -e "#!/bin/bash\n" >> $OCTAVE_EXECUTABLE
  echo "singularity exec $OCTAVE_IMG octave -q \"\$@\"" >> $OCTAVE_EXECUTABLE
  chmod u+x $OCTAVE_EXECUTABLE
fi

jupyter lab --notebook-dir="$HOME"
