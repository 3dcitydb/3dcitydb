#!/bin/sh
# Shell script to drop an instance of the 3D City Database
# on Oracle Spatial/Locator

# Provide your database details here ------------------------------------------
export SQLPLUSBIN=path_to_sqlplus
export HOST=your_host_address
export PORT=1521
export SID=your_SID_or_database_name
export USERNAME=your_username
#-------------------------------------------------------------------------------

# add sqlplus to PATH
PATH=$SQLPLUSBIN:$PATH
# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Interactive mode or usage with arguments? -----------------------------------
if [ $# -eq 0 ]; then
  # INTERACTIVE MODE ----------------------------------------------------------
  # Prompt for DBVERSION ------------------------------------------------------
  while [ 1 ]; do
    echo
    echo 'Which database license are you using? (Oracle Spatial(S)/Oracle Locator(L)): Press ENTER to use default.'
    read -p "(default DBVERSION=Oracle Spatial(S)): " DBVERSION
    DBVERSION=${DBVERSION:-S}
  
  # to upper case
    DBVERSION=$(echo "$DBVERSION" | awk '{print toupper($0)}')
    
    if [ "$DBVERSION" = "S" ] || [ "$DBVERSION" = "L" ] ; then
      break;
    else 
      echo "Illegal input! Enter S or L."
    fi
  done
  
  # Run DROP_DB.sql to drop the 3D City Database instance ---------------------
  sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @DROP_DB.sql "${DBVERSION}"

elif [ $# -ne 6 ]; then
  # Correct number of args supplied? ------------------------------------------
  >&2 echo 'ERROR: Invalid number of arguments.'
  >&2 echo
  <&2 echo "Usage: $(basename "$0") HOST PORT SID USERNAME PASSWORD DBVERSION"
  <&2 echo 'No args can be ommitted and the order is mandatory.'
  <&2 echo
  <&2 echo 'HOST          Database host'
  <&2 echo 'PORT          Database port'
  <&2 echo 'SID           Database sid'
  <&2 echo 'USERNAME      Database username'
  <&2 echo 'PASSWORD      Database password'
  <&2 echo 'DBVERSION     Database license type, Oracle (S)patial or Oracle (L)ocator (S/L)'
  <&2 echo
else 
  # Parse args ----------------------------------------------------------------
  # $1 = HOST
  # $2 = PORT
  # $3 = SID
  # $4 = USERNAME
  # $5 = PASSWORD
  # $6 = DBVERSION

  HOST=$1
  PORT=$2
  SID=$3
  USERNAME=$4
  PASSWORD=$5
  DBVERSION=$6
  
  # Run CREATE_DB.sql to create the 3D City Database instance -----------------
  sqlplus "${USERNAME}/\"${PASSWORD}\"@\"${HOST}:${PORT}/${SID}\"" @DROP_DB.sql "${DBVERSION}"
fi
