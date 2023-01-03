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
LAST_ID=$(tac "$DB_FILE" | head -1 | cut -d $SEP -f 1)
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
  Select_func - Selects one (or more) record(s) from database.
  Usage:
        Select_func [PARAM] or Select_func to show all records.

  Search_func - Searches a record in database. Only for internall use!

  Insert_func - Inserts a record into database, before checking if it exists.
  Usage:
        Insert_func complete name:login:age:gender:job title:department

  Remove_func - Removes a record of database, before checking if it exists.
  Usage:
        Remove_func [LOGIN]

  Fields_func - Shows the database's field names.
  Usage:
        Fields_func

  Help_func   - Shows this help.
  Usage:
        Help_func

"
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
Remove_func () {
  SearchRec_func "$1" || return     # don't go ahead if the record doesn't exist
  grep -i -v "^$1$SEP" "$DB_FILE" > "$TMP_FILE" # remove the record
  mv "$TMP_FILE" "$DB_FILE"                     # rewrite the database
  echo "${YELLOW}INFO: Login '$id' succesfully removed of Database!"
}

# This function insert a record into database, before checking if it exists
Insert_func () {
  local id=$(echo "$1" | cut -d $SEP -f 1)   # get record's first field
  
  if Search_func "$id"; then
    echo "${YELLOW}INFO: The id '$id' already exists on database!"
    return 1
  else
    echo "$*" >> "$DB_FILE" && \  # write the record on database
    echo "${GREEN}INFO: The id '$id' succesfully recorded on database!"
  fi
  return 0
}

# This function search a record in database
Search_func () {
  grep -i -q "^$1$SEP" "$DB_FILE"
}

# This function show the database's field names
Fields_func () {
  local fields=$(head -n 1 "$DB_FILE" | column -t -s "$SEP")
  echo "$fields"
  echo "$LAST_ID -> last id in use"
}

# This function show a specific record
Select_func () {
  local record=$(grep -i "$1" "$DB_FILE")
  local header=$(head -n 1 "$DB_FILE")
  [ "$record" ] || return
  echo "$header" >  "$TMP_FILE" && echo "$record" >> "$TMP_FILE"
  cat "$TMP_FILE" | column -t -s : && rm -f "$TMP_FILE"
}

# This function shows the DataTex help
Help_func () {
  echo -n "$HELP_MSG" && echo -n "  [ENTER] to continue:" && read REPLY \
                      && clear
}
#
### FUNCTION DECLARATION :::::::::::::::::::::::::::::::::::::::::::::::::::::::
################################################################################
