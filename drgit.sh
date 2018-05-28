#!/usr/bin/env bash

set -e
set -o pipefail

#Constants
readonly PURPLE='\033[0;35m'
readonly BOLD=`tput bold`
readonly NS='\033[0m' # No Style
readonly BLUE='\e[34m'
readonly WHITE='\e[97m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'

#Validates if git is installed
_git_exist (){
  if command -v git >/dev/null 2>&1; then
    return 1
  else
    return 0
  fi
}

# Set the username and email from the global configuration of Git
_set_credentials (){
  _git_exist
  if [[ $? != 1 ]]; then
    echo "Git is not installed! :("
    echo "Find help in https://git-scm.com/"
    exit 0
  else
    _USERNAME=$(git config --global user.name)
    _EMAIL=$(git config --global user.email)
  fi
}

set +e
_set_credentials
set -e

# Display the current user information
_show_current_user (){
	printf "${PURPLE}${BOLD}Username:${NS}${BOLD} ${_USERNAME} ${NS}\n"
  printf "${PURPLE}${BOLD}Email:${NS}${BOLD} ${_EMAIL} ${NS}\n\n"
}

_show_header() {
  printf "==========${YELLOW}##${NS}==========\n"
  printf "======${BLUE}| ${NS}${WHITE}${BOLD}POLICE${NS}${BLUE} |${NS}======\n"
  printf "======${BLUE}|[${NS}${WHITE}##${BLUE}][${NS}${WHITE}##${BLUE}]|${NS}======\n"
  printf "======${BLUE}|[${NS}${WHITE}▯▯${BLUE}]|__||${NS}======\n"
  printf "===${BOLD}DR${NS}=${BLUE}${BOLD}||__||__||${NS}=${BOLD}GIT${NS}==\n"
  printf "======${BLUE}${BOLD}||__||__||${NS}======\n"
  printf "======${BLUE}${BOLD}||__||__||${NS}======\n"
  printf "=====${BLUE}${BOLD}||||||||||||${NS}=====\n"
  printf "\n      DOCTOR GIT\n"
  printf "          by\n"
  printf "    Jose Pablo Arce\n"
  printf "    Github: Pablo251\n\n"
}

_show_header
_show_current_user

use_git_editor (){
  clear
  set +e
  _GIT_EDITOR=$(git config --global core.editor)
  if [[ ! -z "$_GIT_EDITOR" ]]; then
    eval "${_GIT_EDITOR} ~/.gitconfig"
    printf "Edition done...\n\n"
  else
    printf "No editor set...\n\n"
  fi
  set -e
}

use_other_editor (){
  clear
  echo "Type your editor:"
  read -p "$ " _OTHER_EDITOR
  clear
  set +e
  eval "${_OTHER_EDITOR} ~/.gitconfig"
  if [[ $? = "127" ]]; then
    printf "\n${RED}Error! editor does not exist${NS}\n\n"
  fi
  set -e
}

#1 Selection
set_username () {
  clear
  printf "Enter your username\n"
  read -p "$ " _NAME
  clear
  eval "git config --global user.name \"${_NAME}\""
}
#2 Selection
set_email (){
  clear
  printf "Enter your email\n"
  read -p "$ " _NEW_EMAIL
  clear
  eval "git config --global user.email ${_NEW_EMAIL}"
}
#3 Selection
get_configuration (){
  clear
  printf "\n${BOLD}Git global configuration:${NS}\n\n"
  git config --list
  printf "\n\n"
}
#4 Selection
set_configuration (){
  clear
  printf "\n${BOLD}Select your text editor:${NS}\n\n"
  _EDITOR_OPTIONS=("Use nano" "Use your git editor" "Enter your editor" "Cancel")
  select opt in "${_EDITOR_OPTIONS[@]}"; do
    case $REPLY in
      1) eval "nano ~/.gitconfig"
      clear; break ;;
      2) use_git_editor;break ;;
      3) use_other_editor; break;;
      4) clear; break;;
      *) echo "Type the option numer..." ;;
    esac
  done
}

all_done=0
while (( !all_done )); do
  options=("Set an Username" "Set an Email" "See the git global configuration" "Manually configuration edition" "Exit")

  echo "Choose an option:"
  select opt in "${options[@]}"; do
    case $REPLY in
      1) set_username; break ;;
      2) set_email; break ;;
      3) get_configuration; break ;;
      4) set_configuration; break ;;
      5) exit; break ;;
      *) echo "Type the option numer..." ;;
    esac
  done

  printf "Current user information:\n\n"
  #Validates the current data
  set +e
  _set_credentials
  set -e
  # Display the current user information
  _show_current_user

done
