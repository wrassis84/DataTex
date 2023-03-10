### ENVIRONMENT ################################################################
#
#!/usr/bin/env bash
#
### ABOUT ######################################################################
#
# Repository      : https://github.com/wrassis84/DataTex
# Author          : William Ramos de Assis Rezende
# Maintainer      : William Ramos de Assis Rezende
# DataTex.sh      : List, Add and Remove users from DataTex systems.
# Requirements    : LibTex.sh
# Usage           : DataTex.sh [ list | add | remove ]
# Contributions   : Fábio Berbert de Paula in: shorturl.at/qtwyB
#
### TESTING ENVIRONMENT ########################################################
#
# zsh 5.8.1
#
### VARIABLE DECLARATION #######################################################
#
DB_FILE="DataDB.txt" #| Database file
LIB_FILE="LibTex.sh" #| Library file
RED="\033[31;1m"     #|
GREEN="\033[32;1m"   #|
YELLOW="\033[33;1m"  #| Colors for output:
PURPLE="\033[35;1m"  #|
CIAN="\033[36;1m"    #|
ESC="\033[m"         #| ESCAPE character
#
### MAIN CODE ##################################################################
[ "$1" ] || {
  echo
  echo "   Usage: ./DataTex.sh [ list | add | remove ]"
  echo
  echo "        list   - List all system users"
  echo "        add    - Add a new user to the system"
  echo "        remove - Remove an user from the system"
  echo
  exit 0
}

source "$LIB_FILE" || {
            #[{bold};{flashing};{red}m
  echo '\033[1;5;31m WARN: Library $LIB_FILE not loaded! \033[m'
  read REPLY
  clear
  exit 1
}

case "$1" in

  list)
    Select_func
  ;;

  add)
  id=$(NextId_func)
  echo -n "Enter complete name: "
  read name && name=$(echo "$name" | sed -E 's/^.*$/\L&/ ; s/\w+/\u&/g')
  echo -n "Enter login [first name.last name]: "
  read login && login=$(echo $login | tr [A-Z] [a-z])
  echo -n "Enter age [0-99]: "
  read age
  echo -n "Enter gender [M|F]: "
  read gender && gender=$(echo $gender | tr [a-z] [A-Z])
  echo -n "Enter job title: "
  read job && job=$(echo $job | tr [A-Z] [a-z])
  echo -n "Enter department: "
  read dept && dept=$(echo $dept | tr [A-Z] [a-z])
  echo
  Insert_func "$id:$name:$login:$age:$gender:$job:$dept"
  echo
  ;;
  
  remove)
  all_users=$(cat "$DB_FILE" | column -t -s "$SEP")
  echo "DataTex users list:"
  echo "$all_users"
  echo
  echo -en '\033[1;4;33mWhich ID do you want to remove? \033[m '
  read id
  echo

  if Search_func "$id" ; then
    Remove_func "$id"
  else
    echo -e '\033[1;33mINFO: ID '$id' not exists on Database! \033[m'
  fi
  echo
  ;;

  backup)
    Backup_func -b
  ;;

  restore)
    Backup_func -r
  ;;

  *)
  echo -e '\033[1;33mWARN: Invalid option: $1! \033[m'
  return 1
  ;;
esac
### MAIN CODE ##################################################################