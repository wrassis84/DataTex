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
<<<<<<< HEAD
RED="\033[31;1m"     #|
GREEN="\033[32;1m"   #|
YELLOW="\033[33;1m"  #| Colors for output:
PURPLE="\033[35;1m"  #|
CIAN="\033[36;1m"    #|
ESC="\033[m"         #| ESCAPE character
=======
# COLORS FOR OUTPUT:
# {style}       {foreground}    {background}
# 1-bold        30-black        40-black
# 2-blurred     31-red          41-red
# 4-underlined  32-green        42-green
# 5-flashing    33-yellow       43-yellow
# 7-reverse     34-blue         44-blue
# 8-hidden      35-purple       45-purple
#               36-cian         46-cian
#               37-l-grey/white 47-l-grey/white
# echo '\033[{style};{foreground};{background}m <msg> \033[m'
>>>>>>> datatex
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

<<<<<<< HEAD
# FIXME: The command below don't work :(
source "$LIB_FILE" || {
  echo "${RED}WARN: Library not loaded!"
=======
source "$LIB_FILE" || {
            #[{bold};{flashing};{red}m
  echo '\033[1;5;31m WARN: Library $LIB_FILE not loaded! \033[m'
  read REPLY
  clear
>>>>>>> datatex
  return 1
}

case "$1" in
  list )
        Select_func ;;
   add )
        #echo -n "Type the new ID: "
        #read id
        #[ `expr "$id" + 0 2>&-` ] && [ $id -gt 0 ] || {
        #  echo -e '\033[1;33m WARN: ID must be an positive integer! \033[m'
        #}
        # search if id exists
        #[ grep -q "^$id$SEP" "$DB_FILE" ] && {
        # echo -e '\033[1;33m INFO: ID $id already exists on database! \033[m'
        # return
        #}
        # if id not exists, go ahead
        echo -n "Enter the new ID: "
        read id
          [ `expr "$id" + 0 2>&-` ] && [ $id -gt 0 ] || {
            echo -e '\033[1;33mWARN: ID must be an positive integer! \033[m'
          }
          [ grep "^$id$SEP" "$DB_FILE" ] || {
            echo -e '\033[1;33mINFO: ID $id already exists on database! \033[m'
          }
        echo -n "Enter complete name: "
        read name
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
             echo -e '\033[1;33mINFO: ID $id not exists on Database! \033[m'
           fi
             echo
  ;;

       * )
<<<<<<< HEAD
       echo
       echo "${YELLOW}WARN: Invalid option: '$1'!"
       echo
=======
       echo -e '\033[1;33mWARN: Invalid option: $1! \033[m'
>>>>>>> datatex
       return 1
  ;;
esac
