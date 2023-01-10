################################################################################
#
#!/usr/bin/env bash
#
################################################################################
### ABOUT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# Repository      : https://github.com/wrassis84/DataTex
# Author          : William Ramos de Assis Rezende
# Maintainer      : William Ramos de Assis Rezende
#
# "DataTex.sh"    : List, Add and Remove users from DataTex systems.
# Requirements    : LibTex.sh
# Usage           : DataTex.sh [ list | add | remove ]
#
################################################################################
### TESTING ENVIRONMENT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# zsh 5.8.1
#
################################################################################
### VARIABLE DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
LAST_ID=$(tac "$DB_FILE" | head -1 | cut -d $SEP -f 1)
LIB_FILE="DataTex.sh"
DB_FILE="Data.txt"
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
################################################################################
### TESTS/VALIDATIONS ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Does the database file exist?
[ ! -e "$DB_FILE" ] \
  && echo    "${RED}ERROR: Missing database file '$DB_FILE'!"${ESC}  \
  && echo -n "[ENTER] to continue:" && read REPLY && clear           \
  && return
# Does the database file have read permission?
[ ! -r "$DB_FILE" ] \
  && echo    "${RED}ERROR: No read permission on '$DB_FILE'!"${ESC}  \
  && echo -n "[ENTER] to continue:" && read REPLY && clear           \
  && return
# Does the database file have write permission?
[ ! -w "$DB_FILE" ] \
  && echo    "${RED}ERROR: No write permission on '$DB_FILE'!"${ESC} \
  && echo -n "[ENTER] to continue:" && read REPLY && clear           \
  && return
#
################################################################################
### FUNCTION DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# This function remove a record of database, before checking if it exists
Remove_func () {
  Search_func "$1" || return     # don't go ahead if the record doesn't exist
  grep -i -v "^$1$SEP" "$DB_FILE" > "$TMP_FILE" # remove the record
  mv "$TMP_FILE" "$DB_FILE"                     # rewrite the database
  echo "${YELLOW}INFO: The id '$1' succesfully removed of Database!"
  Update_func # this function updates last id in use
}

# This function insert a record into database, before checking if it exists
Insert_func () {
  local id=$(echo "$1" | cut -d $SEP -f 1)   # get record's first field
  if Search_func "$id"; then # if true
    clear
    echo "${YELLOW}INFO: The id '$id' already exists on database!"
    return 1
  else
    echo "$*" >> "$DB_FILE" 2>&-  # write the record on database
    clear
    echo "${GREEN}INFO: The id '$id' succesfully recorded on database!"
  fi
  return 0
  Update_func # this function updates last id in use
}

# This function search a record in database. Only for internal use
Search_func () {
  grep -q "^$1$SEP" "$DB_FILE"
}

# This function show the database's field names and last id in use
Fields_func () {
  local fields=$(head -n 1 "$DB_FILE" | column -t -s "$SEP")
  echo "$fields"
  Update_func # this function updates last id in use
  echo "$LAST_ID - last id in use"
}

# This function shows records that match searched pattern
Select_func () {
  local record=$(grep -i "$1" "$DB_FILE")
  local header=$(head -n 1 "$DB_FILE")
  Update_func # this function updates last id in use
  [ "$record" ] || return
  # if $1 is null, gets all records
  [ -z $1 ] && echo "$record" > "$TMP_FILE"     \
            && cat "$TMP_FILE" | column -t -s : \
            && rm -f "$TMP_FILE" && return
  # if $1 is not null, gets one or more records if matchs searched pattern
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
        echo "${GREEN}INFO: Backup performed successfully! "            ;;
    -r) tar -xvf $bkp_file > /dev/null                       && # restores bkp
        echo "${GREEN}INFO: Restore performed successfully!"            ;;
     *) echo "${YELLOW}WARN: Use -b to backup or -r to restore"; return ;;
  esac
}
#
### FUNCTION DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
################################################################################
