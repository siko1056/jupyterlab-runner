# Integrate [JupyterLab](https://jupyter.org/) into the Linux desktop.

This project is not an official Jupyter project.

By running the BASH script on common Linux systems

    ./start_jupyterlab.sh

JupyterLab is installed into a Python 3
[virtual environment](https://docs.python.org/3/tutorial/venv.html)
alongside with the [octave_kernel](https://github.com/Calysto/octave_kernel).

The final setup can be easily launched from the distribution's start menu.

[GNU Octave](https://www.octave.org) will be installed using a
[Singularity image](https://cloud.sylabs.io/library/siko1056/default/gnu_octave).
Thus [Singularity](https://sylabs.io/singularity/) must be installed on the
system.


## Launcher icon

> Copyright (C) 2017 Project Jupyter Contributors

`jupyter.ico` is licensed under the terms of the
[BSD License](https://commons.wikimedia.org/wiki/File:Jupyter_logo.svg)
