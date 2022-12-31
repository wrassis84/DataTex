################################################################################
#
#!/usr/bin/env bash
#
################################################################################
### ABOUT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# Repository      : https://github.com/wrassis84/shell-script
# Author          : William Ramos de Assis Rezende
# Maintainer      : William Ramos de Assis Rezende
#
# "DataTex.sh"    : Library of functions for managing textual databases.
#
# Usage           : Run 'source DataTex.sh' to include it in your programs.
#
################################################################################
### TESTING ENVIRONMENT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# zsh 5.8.1
#
################################################################################
### VARIABLE DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
DB_FILE="Data.txt"
TMP_FILE="Temp.$$"  #  temp file
SEP=:               #  default field separator
RED="\033[31;1m"    #|
GREEN="\033[32;1m"  #|
YELLOW="\033[33;1m" #| Colors for output: 
PURPLE="\033[35;1m" #|
CIAN="\033[36;1m"   #|
ESC="\033[m"        #  ESCAPE character
#
################################################################################
### TESTS/VALIDATIONS ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Does the database file exist?
[ ! -e "$DB_FILE" ] \
  && echo    "${RED}ERROR: Missing database file '$DB_FILE'!"${ESC}  \
  && echo -n "[ENTER] to continue:" && read REPLY && clear           \
  && exit 1
# Does the database file have read permission?
[ ! -r "$DB_FILE" ] \
  && echo    "${RED}ERROR: No read permission on '$DB_FILE'!"${ESC}  \
  && echo -n "[ENTER] to continue:" && read REPLY && clear           \
  && exit 1
# Does the database file have write permission?
[ ! -w "$DB_FILE" ] \
  && echo    "${RED}ERROR: No write permission on '$DB_FILE'!"${ESC} \
  && echo -n "[ENTER] to continue:" && read REPLY && clear           \
  && exit 1
#
################################################################################
### FUNCTION DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# This function remove a record of database, before checking if it exists
DeleteRec_func () {
  SearchRec_func "$1" || return     # don't go ahead if the record doesn't exist
  grep -i -v "^$1$SEP" "$DB_FILE" > "$TMP_FILE" # removes the record
  mv "$TMP_FILE" "$DB_FILE"                     # rewrite the database
  echo "${YELLOW}INFO: Login '$login' succesfully removed of Database!"
}

# This function insert a record into database, before checking if it exists
InsertRec_func () {
  local login=$(echo "$1" | cut -d $SEP -f 1)   # get record's first field
  
  if SearchRec_func "$login"; then
    echo "${YELLOW}INFO: Login '$login' already exists on database!"
    return 1
  else
    echo "$*" >> "$DB_FILE" && \  # write the record on database
    echo "${GREEN}INFO: Login '$login' succesfully recorded on database!"
  fi
  return 0
}

# This function search a record in database
SearchRec_func () {
  grep -i -q "^$1$SEP" "$DB_FILE"
}

# This function show the database's field names
ShowFields () {
  head -n 1 "$DB_FILE" | tr $SEP \\n
}

# This function show a specific record
GetRec_func () {
  local record=$(grep -i "^$1$SEP" "$DB_FILE")
  local index=0
  [ "$record" ] || return
  ShowFields | while read field; do
    index=$((index+1))
    echo -n "$field: "
    echo "$record" | cut -d $SEP -f $index
  done
}

# This function get a specific field of a record
# Usage: GetField_func 2 luigisilva
GetField_func () {
  local key=${2:-.*}
  grep -i "^$key$SEP" "$DB_FILE" | cut -d $SEP -f $1
}
#
### FUNCTION DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
################################################################################
