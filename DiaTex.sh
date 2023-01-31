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

source "$LIB_FILE" || {
            #[{bold};{flashing};{red}m
  echo '\033[1;5;31m WARN: Library $LIB_FILE not loaded! \033[m'
  read REPLY
  clear
  exit 1
}

while :
do
option=$( dialog --stdout                          \
          --menu "DiaTex Systems"                  \
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

  name=$(dialog --stdout --inputbox "Enter Complete Name:" 0 0)            && {
    name=$(echo "$name" | sed -E 's/^.*$/\L&/ ; s/\w+/\u&/g')
  }

  login=$(dialog --stdout --inputbox "Enter Login [first.last name]:" 0 0) && {
    login=$(echo $login | tr [A-Z] [a-z])
  }

  age=$(dialog --stdout --inputbox "Enter Age [0-99]:" 0 0)

  gender=$(dialog --stdout --inputbox "Enter Gender [M|F|NB]:" 0 0)        && {
    gender=$(echo $gender | tr [a-z] [A-Z])
  }
  job=$(dialog --stdout --inputbox "Enter Job Title:" 0 0)                 && {
    job=$(echo $job | tr [A-Z] [a-z])
  }
  dept=$(dialog --stdout --inputbox "Enter Department" 0 0)                && {
    dept=$(echo $dept | tr [A-Z] [a-z])
  }
  
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
    msg="ID '$id' succesfully removed of database!"
    dialog --msgbox "$msg" 6 40
    exit 1
  }
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
esac
done
#
### MAIN CODE ##################################################################