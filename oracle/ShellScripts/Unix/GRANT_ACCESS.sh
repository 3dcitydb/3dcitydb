#!/bin/bash
# Shell script to grant access privileges to a 3DCityDB schema
# on Oracle

# read database connection details
source CONNECTION_DETAILS.sh

# add SQLPLUSBIN to PATH
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
echo '####################################################################################'
echo
echo 'This script will guide you through the process of granting access privileges on a'
echo '3DCityDB schema to an existing user. Please follow the instructions of the script.'
echo 'Enter the required parameters when prompted and press ENTER to confirm.'
echo 'Just press ENTER to use the default values.'
echo
echo 'Note: This script requires SYSDBA privileges.'
echo
echo 'Documentation and help:'
echo '   3DCityDB website:    https://www.3dcitydb.org'
echo '   3DCityDB on GitHub:  https://github.com/3dcitydb'
echo
echo 'Having problems or need support?'
echo '   Please file an issue here:'
echo '   https://github.com/3dcitydb/3dcitydb/issues'
echo
echo '####################################################################################'

# cd to path of the SQL scripts
cd ../../SQLScripts/UTIL/GRANT_ACCESS

# Prompt for GRANTEE ----------------------------------------------------------
while [ 1 ]; do
  echo
  echo "Please enter the username of the grantee who shall have access to \"$USERNAME\"."
  read -p "(GRANTEE must already exist in database): " GRANTEE

  if [[ -z "$GRANTEE" ]]; then
    echo
    echo 'Illegal input! GRANTEE must not be empty.'
  else
    break;
  fi
done

# Prompt for ACCESS_MODE ------------------------------------------------------
while [ 1 ]; do
  echo
  echo "What level of access should be granted to \"$GRANTEE\" (read-only=RO/read-write=RW)?"
  read -p "(default ACCESS_MODE=RO): " ACCESS_MODE
  ACCESS_MODE=${ACCESS_MODE:-RO}

  # to upper case
  ACCESS_MODE=$(echo "$ACCESS_MODE" | awk '{print toupper($0)}')

  if [ "$ACCESS_MODE" = "RO" ] || [ "$ACCESS_MODE" = "RW" ]; then
    break;
  else
    echo
    echo 'Illegal input! Enter RO or RW.'
  fi
done

# Run GRANT_ACCESS.sql to grant access privileges on a specific schema --------
echo
echo "Connecting to \"$SYSDBA_USERNAME@$HOST:$PORT/$SID\" ..."
echo -n "Enter password: "
sqlplus -S -L "${SYSDBA_USERNAME}@\"${HOST}:${PORT}/${SID}\"" AS SYSDBA @GRANT_ACCESS.sql "${GRANTEE}" "${USERNAME}" "${ACCESS_MODE}"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
