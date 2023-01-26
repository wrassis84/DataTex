### ENVIRONMENT ################################################################
#
#!/usr/bin/env bash
#
### ABOUT ######################################################################
#
# Repository : https://github.com/wrassis84/DataTex
# Author     : William Ramos de Assis Rezende
# Maintainer : William Ramos de Assis Rezende
#
# LibTex.sh  : Library of functions for managing textual databases.
#
# Usage      : Run 'source DataTex.sh' to include it in your programs.
#
### TESTING ENVIRONMENT ########################################################
#
# zsh 5.8.1
#
### VARIABLE DECLARATION #######################################################
#
LAST_ID=$(tac "$DB_FILE" | head -1 | cut -d "$SEP" -f 1)
LIB_FILE="LibTex.sh"
DB_FILE="DataDB.txt"
TMP_FILE="Temp.$$"  #  temp file
SEP=:               #  default field separator
RED="\033[31;1m"    #|
GREEN="\033[32;1m"  #|
YELLOW="\033[33;1m" #| Colors for output:
PURPLE="\033[35;1m" #|
CIAN="\033[36;1m"   #|
ESC="\033[m"        #  ESCAPE character

HELP_MSG="
  ${YELLOW}Help Menu for $(basename $0) Functions:

  Select_func - Selects one (or more) record(s) from database.
  Usage:
        Select_func [PARAM] or Select_func to show all records.

  Search_func - Searches a record in database. Only for internall use!

  Update_func - Updates with last id on database. Only for internall use!

  Insert_func - Inserts a record into database, before checking if it exists.
  Usage:
        Insert_func complete name:login:age:gender:job title:department

  Remove_func - Removes a record of database, before checking if it exists.
  Usage:
        Remove_func [id]

  Fields_func - Shows the database's field names.
  Usage:
        Fields_func

  Help_func   - Shows this help.
  Usage:
        Help_func

  Backup_func - Backup the database.
  Usage:
        Backup_func -b - Backup the database.
        Backup_func -r - Restore the database's backup.${ESC}

"
#
### TESTS/VALIDATIONS ##########################################################
# Does the database file exist?
[ ! -e "$DB_FILE" ] \
  && echo -e  '\033[1;31mERROR: Missing database file '$DB_FILE'! \033[m'    \
  && echo -en '\033[1;31m[ENTER] to continue: \033[m' && read REPLY && clear \
  && exit 1
# Does the database file have read permission?
[ ! -r "$DB_FILE" ] \
  && echo -e  '\033[1;31mERROR: No read permission on '$DB_FILE'! \033[m'    \
  && echo -en '\033[1;31m[ENTER] to continue: \033[m' && read REPLY && clear \
  && exit 1
# Does the database file have write permission?
[ ! -w "$DB_FILE" ] \
  && echo -e  '\033[1;31mERROR: No write permission on '$DB_FILE'! \033[m'   \
  && echo -en '\033[1;31m[ENTER] to continue: \033[m' && read REPLY && clear \
  && exit 1
#
### FUNCTION DECLARATION #######################################################
#
# This function search a record in database. Only for internal use
Search_func () {
  Update_func
  grep -q "^$1$SEP" "$DB_FILE"
}

# This function remove a record of database, before checking if it exists
Remove_func () {
  Search_func "$1" || return     # don't go ahead if the record doesn't exist
  grep -i -v "^$1$SEP" "$DB_FILE" > "$TMP_FILE" # remove the record
  mv "$TMP_FILE" "$DB_FILE"                     # rewrite the database
  echo -e  '\033[1;5;33mINFO: ID '$1' succesfully removed of database!\033[m'
  echo -en '\033[1;5;33m[ENTER] to continue...\033[m' && read
  exit 1
  Update_func # this function updates last id in use
}

# This function insert a record into database, before checking if it exists
Insert_func () {
  local id=$(echo "$1" | cut -d "$SEP" -f 1)   # get record's first field
  if Search_func "$id"; then # if true
    clear
    echo -e '\033[1;5;33mINFO: ID '$id' already exists on database! \033[m'
    return 1
  else
    echo "$*" >> "$DB_FILE" 2>&-  # write the record on database
    clear
    echo -e '\033[1;5;32mINFO: ID '$id' succesfully recorded on database!\033[m'
  fi
  return 0
  Update_func # this function updates last id in use
}

# This function show the database's field names and last id in use
Fields_func () {
  local fields=$(head -n 1 "$DB_FILE" | column -t -s "$SEP")
  echo "$fields"
  Update_func # this function updates last id in use
  echo "$LAST_ID - last id in use"
}

# This function updates and show last id on database
LastId_func (){
  local last_id=$(tac "$DB_FILE" | head -1 | cut -d "$SEP" -f 1)
  local next_id=$(echo $(($last_id + 1)))
  echo "$last_id"
}

# This function updates and show last id on database
NextId_func (){
  local last_id=$(tac "$DB_FILE" | head -1 | cut -d "$SEP" -f 1)
  local next_id=$(echo $(($last_id + 1)))
  echo "$next_id"
}

# This function shows records that match searched pattern
Select_func () {
  local record=$(grep -i "$1" "$DB_FILE")
  local header=$(head -n 1 "$DB_FILE")
  Update_func # this function updates last id in use
  [ "$record" ] || return  # if nothing be found, return
  # if $1 is null, bring all records
  [ -z $1 ] && echo "$record" > "$TMP_FILE"     \
            && cat "$TMP_FILE" | column -t -s : \
            && rm -f "$TMP_FILE" && return
  # if $1 is not null, bring one or more records that matchs searched pattern
  [ -n $1 ] && echo "$header" > "$TMP_FILE"     \
            && echo "$record" >> "$TMP_FILE"    \
            && cat "$TMP_FILE" | column -t -s : \
            && rm -f "$TMP_FILE" && return
}

# This function shows the DataTex help
Help_func () {
  clear
  echo -n "$HELP_MSG" && echo -n "  [ENTER] to continue:" \
                      && read REPLY                       \
                      && clear
}

# This function updates the last id in use
Update_func () {
  source $LIB_FILE
}

# This function backup the database
Backup_func () {
  local bkp_date=$(date +'%d-%m-%Y')
  local src_file="$DB_FILE"
  local bkp_file="$DB_FILE-$bkp_date.tar.gz"
  case "$1" in
    -b) tar --gzip -cvvvf $bkp_file $src_file > /dev/null    && # bkp database
        echo -e '\033[1;32mINFO: Backup performed successfully!  \033[m'
    ;;
    -r) tar -xvf $bkp_file > /dev/null                       && # restores bkp
        echo -e '\033[1;32mINFO: Restore performed successfully! \033[m'
    ;;
     *) echo -e '\033[1;33mWARN: Use -b to backup or -r to restore \033[m'
        return
    ;;
  esac
}
#
### FUNCTION DECLARATION #######################################################