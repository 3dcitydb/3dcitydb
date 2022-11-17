#!/bin/bash
# Shell script to migrate an instance of the 3D City Database
# on Oracle

# read database connection details 
source ../CONNECTION_DETAILS.sh

# add sqlplus to PATH
export PATH="$SQLPLUSBIN:$PATH"

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Welcome message
echo ' _______   ___ _ _        ___  ___ '
echo '|__ /   \ / __(_) |_ _  _|   \| _ )'
echo ' |_ \ |) | (__| |  _| || | |) | _ \'
echo '|___/___/ \___|_|\__|\_, |___/|___/'
echo '                     |__/          '
echo
echo '3D City Database - The Open Source CityGML Database'
echo
echo '######################################################################################'
echo
echo 'Welcome to the 3DCityDB Migrate Script. This script will guide you through the'
echo 'process of migrating an existing 3DCityDB instance of version 2 or 3 to version 4.'
echo 'Please follow the instructions echo of the script. Enter the required parameter when'
echo 'prompted and press ENTER to confirm. Just press ENTER to use the default values.'
echo
echo 'Documentation and help:'
echo '   3DCityDB website:    https://www.3dcitydb.org'
echo '   3DCityDB on GitHub:  https://github.com/3dcitydb'
echo
echo 'Having problems or need support?'
echo '   Please file an issue here:'
echo '   https://github.com/3dcitydb/3dcitydb/issues'
echo
echo '######################################################################################'

# Prompt for VERS -------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter the number of currently used major version.'
  read -p "(number must be an integer 2 or 3): " VERS
  VERS=${VERS:-0}

  if [[ ! $VERS =~ $re ]] || [ $VERS -le 0 ]; then
    echo
    echo 'Illegal input! Enter a positive integer for the version.'
  else
    break;
  fi
done

# Prompt for V2USER and TEXOP -------------------------------------------------
while [ 1 ]; do
  if [ $VERS -le 2 ]; then
    cd ../../../SQLScripts/MIGRATION/V2_to_V4

    echo
    echo 'Enter the user name of 3DCityDB v2.1 instance.'
    read -p "(V2USER must already exist in database): " V2USER
  
    if [[ -z "$V2USER" ]]; then
      echo
      echo 'Illegal input! V2USER must not be empty.'
    else
      break;
    fi
    
    echo
    echo 'No texture URI is used for multiple texture files (yes/no)?'
    read -p "(default TEXOP=no): " TEXOP
  else
    cd ../../../SQLScripts/MIGRATION/V3_to_V4
  fi
  TEXOP=${TEXOP:-no}
  
  if [ "$TEXOP" = "yes" ] || [ "$TEXOP" = "no" ] ; then
    break;
  else
    echo
    echo "Illegal input! Enter yes or no."
  fi
done

# Run MIGRATE_DB.sql to create the 3D City Database instance ------------------
echo
echo "Connecting to the database \"$USERNAME@$HOST:$PORT/$SID\" ..."
echo -n "Enter password: "
sqlplus -S -L "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @MIGRATE_DB.sql "${TEXOP}" "${V2USER}"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
