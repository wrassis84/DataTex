### ENVIRONMENT ################################################################
#
#!/usr/bin/env bash
#
### ABOUT ######################################################################
#
# Repository      : https://github.com/wrassis84/DataTex
# Author          : William Ramos de Assis Rezende
# Maintainer      : William Ramos de Assis Rezende
# DiaTex.sh       : List, Add and Remove users from DataTex systems.
# Requirements    : LibTex.sh, dialog
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
#
### MAIN CODE ##################################################################
#
# [ "$1" ] || {
#   echo
#   echo "   Usage: ./DataTex.sh [ list | add | remove | backup | restore ]"
#   echo
#   echo "        list    - List all system users"
#   echo "        add     - Add a new user to the system"
#   echo "        remove  - Remove an user from the system"
#   echo "        backup  - Backup the database"
#   echo "        restore - Restore database backup"
#   echo
#   exit 0
# }

source "$LIB_FILE" || {
            #[{bold};{flashing};{red}m
  echo '\033[1;5;31m WARN: Library $LIB_FILE not loaded! \033[m'
  read REPLY
  clear
  exit 1
}

option=$( dialog --stdout                          \
          --menu "DiaTex Systems"     \
          0 0 0                                    \
          list    "List all system users"          \
          add     "Add a new user to the system"   \
          remove  "Remove an user from the system" \
          backup  "Backup the database"            \
          restore "Restore database backup"        )

case "$option" in

  list)
    tmp=$(mktemp -t tmp_XXXX)
    cat "$DB_FILE" | column -t -s "$SEP" > "$tmp"
    dialog --title "DiaTex System Users" --textbox "$tmp" 0 0
    rm $tmp
  ;;

  add)
  id=$(NextId_func)
  login=$(dialog --stdout --inputbox "Enter login:" 0 0)
  [ "$login" ] || exit 1
  
  Search_func "$login" && {
    msg="The login '$login' already exists on database!"
    dialog --msgbox "$msg" 6 40
    exit 1
  }

  name=$(dialog --stdout --inputbox "Complete Name:" 0 0)
  login=$(dialog --stdout --inputbox "Login [first name.last name]:" 0 0)
  age=$(dialog --stdout --inputbox "Age [0-99]:" 0 0)
  gender=$(dialog --stdout --inputbox "Gender [M|F|NB]:" 0 0)
  job=$(dialog --stdout --inputbox "Job Title:" 0 0)
  dept=$(dialog --stdout --inputbox "Department" 0 0)
  Insert_func "$id:$name:$login:$age:$gender:$job:$dept"
  msg="User '$name' succesfully recorded on database!"
  dialog --title "INFO" --msgbox "$msg" 6 40
  ;;
  
  remove)
  tmp=$(mktemp -t tmp_XXXX)
  cat "$DB_FILE" | column -t -s "$SEP" > "$tmp"
  dialog --title "Which ID do you want to remove?" --textbox "$tmp" 0 0
  rm $tmp

  id=$(dialog --stdout --inputbox "Enter the ID you want to remove:" 0 0)
  SearchID_func "$id" || {
    msg="ID '$id' not exists on database!"
    dialog --msgbox "$msg" 6 40
    exit 1
  }
  
  RemoveID_func "$id" && {
    msg="ID '$1' succesfully removed of database!"
    dialog --msgbox "$msg" 6 40
    exit 1
  }
  # msg="The choosen ID was: '$id'!"
  # dialog --msgbox "$msg" 6 40
  # exit 1 
   
  # all_users=$(cat "$DB_FILE" | column -t -s "$SEP")
  # echo "DiaTex System Users"
  # echo "$all_users"
  # echo
  # echo -en '\033[1;4;33mWhich ID do you want to remove? \033[m '
  # read id
  # echo

  # if Search_func "$id" ; then
  #   Remove_func "$id"
  # else
  #   echo -e '\033[1;33mINFO: ID '$id' not exists on Database! \033[m'
  # fi
  # echo
  ;;

  backup)
    Backup_func -b
    msg="Backup performed successfully!"
    dialog --title "INFO" --msgbox "$msg" 6 40
  ;;

  restore)
    # FIXME: restore function runs even without backup file
    Backup_func -r
    msg="Restore performed successfully!"
    dialog --title "INFO" --msgbox "$msg" 6 40
  ;;

  # *)
  # echo -e '\033[1;33mWARN: Invalid option: $1! \033[m'
  # exit 1
  # ;;
esac
#
### MAIN CODE ##################################################################