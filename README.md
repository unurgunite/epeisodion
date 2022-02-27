# Epeisodion

## Overview

> Epeisodion (in ancient Greek drama)  — an interlude or section alternating with the stasimon, especially in tragedy,
> varying in number from three to six and containing the main action of the drama.

This repo will help you remove annoying podcasts (episodes) from the Spotify that do not bring any benefit to society,
relying on imposed concepts such as tolerance for the public and freedom of speech.

## Documentation content

1. [Usage][1]
    1. [Wait! Why temporally?][1.1]
    2. [Possible options][1.2]
        1. [Setup script][1.2.1]
        2. [Spotify script][1.2.2]
2. [Todo][2]
3. [Requirements][3]
4. [Contribution][4]

## Usage

The usage is pretty simple due to the simple construction of the script, which are built on top of the POSIX standards
and UNIX ideologies. Just type this in your terminal:

```sh
git clone https://github.com/unurgunite/epeisodion.git && \
cd epeisodion && \
sh setup.sh
```

Perfect! Now just type `remove_podcasts` and podcasts will be temporally turned off

### Wait! Why temporally?

This behaviour is expected due to the possibility of Spotify app to update itself in runtime. It means that irritating
podcast tab will appear again, when you won't expect it. To change this behaviour you could turn on custom DNS-server on
top of your local network and setup it to block requests with podcasts

### Possible options

#### Setup script

The setup script is stored under the `setup.sh` filename and has several options to do in UNIX-98 style:

```shell
Usage: sh setup.sh [-p path] [-n name] [-h help] [-l license]
    -p path         Provide custom path
    -n name         Specify custom name for script to store
    -a auto setup   Automatically edit your PATH variable and shell rc files
    -h help         Display help
    -l license      Display license
```

#### Spotify script

As the [setup script](https://github.com/unurgunite/epeisodion#setup-script), the spotify script is stored under
the `remove_podcasts.sh` filename and has several options to do in UNIX-98 style:

```shell
Usage: sh $0 [-h help] [-l license]
  -h help       Display help
  -l license    Display license
```

## Requirements

Scripts from this repo can be launched from any UNIX and UNIX-like OS (except mobile phone os in case of theirs system
and file system hierarchy) or its emulators (cygwin, for e.g.), but it could not be launched on systems which are not
supported by Spotify. Check [this link](https://support.spotify.com/us/article/supported-devices-for-spotify/) for more
info.

## TODO

* Add support for Windows
    * Check if Spotify was built from source or was downloaded from Windows Store
    * msys and cygwin support
* Add support for Linux
    * Give support for different package managers
* Update README according to this TODO list

## Contribution

Contribute to the project development always welcome! You will need to fork this project then create new branch and push
changes to the repository. Bug reports and pull requests are welcome on GitHub
at [https://github.com/unurgunite/epeisodion](https://github.com/unurgunite/epeisodion).

[1]:https://github.com/unurgunite/epeisodion#usage

[1.1]:https://github.com/unurgunite/epeisodion#wait-why-temporally

[1.2]:https://github.com/unurgunite/epeisodion#possible-options

[1.2.1]:https://github.com/unurgunite/epeisodion#setup-script

[2]:https://github.com/unurgunite/epeisodion#todo

[3]:https://github.com/unurgunite/epeisodion#requirements

[4]:https://github.com/unurgunite/epeisodion#contribution
