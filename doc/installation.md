Dependencies
------------
You need to install a couple of dependencies:

### Additional packages
#### Ubuntu and Debian/GNU Linux

```shell
sudo apt install texlive-full enscript libpdf-api2-perl \
imagemagick libstring-interpolate-perl
sudo cpan install chordpro
```

### Python venv
It is recommended to use a python virtual environment to not clutter your system python installation with unnecessary libraries.

In Ubuntu and Debian/GNU Linux you can install it via the system package manager:

```shell
sudo apt install python3-venv
```

Another method, which works on Ubuntu, Debian/GNU Linux as well as most other posix friendly environments is to use pip:

```shell
pip install virtualenv
```

Once this module is installed you can setup a virtual environment by runnng this in the root folder of this program:

```shell
python -m venv .venv
```

After that, you can activate the environment using

```shell
source .venv/bin/activate
```

and deactivate it by simply exiting out of the shell or running

```sheel
deactivate
```

Once you're inside the virtual environment, use pip to install the remaining required libraries:

```shell
pip install -r requirements.txt
```

And to keep them up to date you might want to run this from time to time:

```shell
pip install -r requirements.txt --upgrade
```
