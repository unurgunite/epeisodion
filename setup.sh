#!/usr/bin/env sh
#|-----------------------------------------------------------------------------------------------------------------|
#| Program Name: setup.sh
#|-----------------------------------------------------------------------------------------------------------------|
#| Description: This script does the initial setup for the `remove_podcasts.sh` script for its further use
#|-----------------------------------------------------------------------------------------------------------------|
#| Description: This script does the initial setup for the `remove_podcasts.sh` script for its further use
#|        1) This script moves `remove_podcasts.sh` to `/usr/local/bin` folder by default
#|		      a) Moves to custom folder if it was provided
#|         	b) Fix $PATH if custom folder is provided
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

Default_Path='/usr/local/bin'
Spotify_Script='remove_podcasts.sh'
New_Default_Name=$(echo "$Spotify_Script" | cut -f 1 -d '.')
License_File='./LICENSE.txt'
GitHub_Repo='https://github.com/unurgunite/epeisodion'

#-------------------- Define `help` function -----------------------------------------------------#
help() {
  echo "$0 - the initial setup for the \`remove_podcasts.sh\` script for its further use"
  echo "Usage: sh $0 [-p path] [-n name] [-h help] [-l license]"
  echo '  -p path         Provide custom path'
  echo '  -n name         Specify custom name for script to store'
  echo '  -a auto setup   Automatically edit your PATH variable and shell rc files'
  echo '  -h help         Display help'
  echo '  -l license      Display license'
  return 0
}

#-------------------- Check for SPOTIFY SCRIPT ----------------------------------------------------#
script_exists() {
  if [ ! -s ${Spotify_Script} ]; then
    echo "ERROR: Could not find script: ${Spotify_Script}"
    echo 'Exiting with Status Code of 10'
    exit 10
  else
    return 0
  fi
}

#-------------------- Move SPOTIFY SCRIPT ---------------------------------------------------------#
move_script() {
  if script_exists; then
    if [ $# -eq 0 ]; then
      echo 'No arguments provided. Using standard options...'
      echo "$Spotify_Script $Default_Path/$New_Default_Name"
      cp $Spotify_Script "$Default_Path/$New_Default_Name"
      if [ -f "$Default_Path/$New_Default_Name" ]; then
        echo "File has been successfully moved to the $Default_Path folder. Now you can type just $New_Default_Name."
      else
        echo "Can't move file... Exiting with status code 20"
        return 20
      fi
    else
      cp $Spotify_Script "$1"
      if [ -f "$Spotify_Script/$1" ]; then
        echo 'export PATH=$PATH:$1'
      else
        echo "Can't move file... Exiting with status code 20"
        return 20
      fi
    fi
  fi
  return 0
}

#-------------------- Show LICENSE.txt file -------------------------------------------------------#
show_license() {
  if [ ! -s ${License_File} ]; then
    echo "No license files were found! Please, update your local repo from $GitHub_Repo."
    return 10
  else
    cat "$License_File"
  fi
  return 0
}

#-------------------- Get parameters --------------------------------------------------------------#
if [ $# -eq 0 ]; then
  move_script
fi

optstring=":hp:n:l"
while getopts ${optstring} opt; do
  case ${opt} in
  h)
    help
    ;;
  p)
    Mv_Path=$OPTARG
    move_script "$Mv_Path"
    ;;
  n)
    Filename=$OPTARG
    move_script "$Filename"
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
