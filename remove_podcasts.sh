#!/usr/bin/env bash
#|-----------------------------------------------------------------------------------------------------------------|
#| Program Name: remove_podcasts.sh
#|-----------------------------------------------------------------------------------------------------------------|
#| Description: This script removes podcasts from Spotify app. This script uses POSIX standards and works in Lunix
#|                as well as in OS X
#|-----------------------------------------------------------------------------------------------------------------|
#| Description: This script removes podcasts from Spotify app. This script uses POSIX standards and works in Lunix
#|               as well as in OS X
#|        1) This script checks the OS type and SHELL type
#|        2) Modify Spotify client
#|        2) Gives `remove_podcasts.sh` name without file extension
#|
#| Note:
#|        a) This script takes params in UNIX-style where and how to setup script
#|
#|-----------------------------------------------------------------------------------------------------------------|
#| Author: unurgunite
#| Date: 2022/27/02
#|-----------------------------------------------------------------------------------------------------------------|
#| License: MIT
#|-----------------------------------------------------------------------------------------------------------------|

Kernel=$(uname -r)
Support_Link="https://support.spotify.com/us/article/supported-devices-for-spotify/"

#-------------------- Define `help` function -----------------------------------------------------#
help() {
  echo "$0 - script to remove podcasts from Spotify app."
  printf "Supported OS types:\012OS X\012"
  echo "Usage: sh $0 [-h help] [-l license]"
  echo '  -h help       Display help'
  echo '  -l license    Display license'
  return 0
}

#-------------------- Define `show_license` function ----------------------------------------------#
show_license() {
  cat <<LICENSE
  MIT License
  
  Copyright (c) 2022 unurgunite
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
LICENSE
}

#-------------------- Define `linux_util` function ---------------------------------------------------#

linux_util() {
  return 0
}

#-------------------- Define `osx_util` function -----------------------------------------------------#
osx_util() {
  killall Spotify
  cd /Applications/Spotify.app/Contents/Resources/Apps/ || return 1
  cp xpui.spa xpui.spa.bak
  # shellcheck disable=SC2016
  # shellcheck disable=SC2094
  unzip -p xpui.spa xpui.js | sed 's/,show,/,/' | sed 's/,episode"/"/' | sed 's/,episode${i}"/"/' >xpui.js
  zip xpui.spa xpui.js
  open -a Spotify
  return 0
}

optstring=":hl"
while getopts ${optstring} opt; do
  case ${opt} in
  h)
    help
    ;;
  l)
    show_license
    ;;
  *)
    echo "Unknown parameter -- ${OPTARG}"
    echo ""
    help
    ;;
  esac
done

if [ $# -eq 0 ]; then
  case "$OSTYPE" in
  darwin*)
    if [ 1 -eq "$(echo "${Kernel%%.*} < 10.11" | bc)" ]; then
      echo "Your OS is not supported by Spotify. Check $Support_Link."
      return 1
    fi
    osx_util
    ;;
  linux*)
    # TODO: Add support for linux binaries
    linux_util
    ;;
  msys*)
    # TODO: Add support for windows binaries
    ;;
  cygwin*)
    # TODO: Add support for windows binaries
    ;;
  *)
    echo "Unsupported by Spotify $OSTYPE. Check $Support_Link."
    ;;
  esac
fi
