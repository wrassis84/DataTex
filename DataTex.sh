################################################################################
#
#!/usr/bin/env bash
#
################################################################################
### ABOUT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# Repository   : https://github.com/wrassis84/DataTex
# Author       : William Ramos de Assis Rezende
# Maintainer   : William Ramos de Assis Rezende
#
# DataTex.sh   : List, Add and Remove users from DataTex systems.
# Requirements : LibTex.sh
# Usage        : DataTex.sh [ list | add | remove ]
#
################################################################################
### TESTING ENVIRONMENT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# zsh 5.8.1
#
################################################################################
### VARIABLE DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
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
################################################################################
### MAIN CODE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
[ "$1" ] || {   # if $1 is null, shows help message
  echo
  echo "   Usage: ./DataTex.sh [ list | add | remove ]"
  echo
  echo "        list   - List all system users"
  echo "        add    - Add a new user to the system"
  echo "        remove - Remove an user from the system"
  echo
  return 1
}

# FIXME: The command below don't work :(
source "$LIB_FILE" || {
  echo "${RED}WARN: Library not loaded!"
  return 1
}

case "$1" in
  list )
        Select_func ;;
   add )
        echo -n "Type the new id: "
        read id
        [ "$id" ] || {
         echo "${YELLOW}WARN: The id must be an integer. Try again!"
         return
        }
        # search if id exists
        Search_func && {
         echo "${YELLOW}INFO: The id '$id' already exists on database!"
         return
        }
        # if id not exists, go ahead
        echo -n "Enter the new id: "
        read id
        echo -n "Enter complete name: "
        read name
        echo -n "Enter login [first name.last name]: "
        read login
        echo -n "Enter age [0-99]: "
        read age
        echo -n "Enter gender [male|female]: "
        read gender
        echo -n "Enter job title: "
        read job
        echo -n "Enter department: "
        read department
        echo
        Insert_func "$id:$name:$login:$age:$gender:$job:$department"
        echo
  ;;
  remove )
        local all_users=$(cat "$DB_FILE" | column -t -s $SEP)
        echo "DataTex users list:"
        echo "$all_users"
        echo
        echo
        echo -n "Which ID do you want to remove? "
        read id
        echo

           if Search_func "$id" ; then
             Remove_func "$id"
           else
             echo "${YELLOW}INFO: The id '$id' not exists on Database!"
           fi
             echo
  ;;
       * )
       echo
       echo "${YELLOW}WARN: Invalid option: '$1'!"
       echo
       return 1
  ;;
esac
