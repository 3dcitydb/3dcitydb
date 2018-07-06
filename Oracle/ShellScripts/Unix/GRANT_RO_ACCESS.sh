#!/bin/bash
# Shell script to grant read-only access to a 3DCityDB schema
# on Oracle Spatial/Locator

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
echo '######################################################################################'
echo
echo 'This script will guide you through the process of granting read-only access on a'
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
echo '######################################################################################'

# cd to path of the SQL scripts
cd ../../SQLScripts/UTIL/RO_ACCESS

# Prompt for RO_USERNAME ------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Please enter the username of the read-only user.'
  read -p "(RO_USERNAME must already exist in database): " RO_USERNAME

  if [[ -z "$RO_USERNAME" ]]; then
    echo
    echo 'Illegal input! RO_USERNAME must not be empty.'
  else
    break;
  fi
done

# Run GRANT_RO_ACCESS.sql to grant read-only access on a specific schema ------
echo
echo "Connecting to \"$SYSDBA_USERNAME@$HOST:$PORT/$SID\" ..."
echo -n "Enter password: "
sqlplus -S -L "${SYSDBA_USERNAME}@\"${HOST}:${PORT}/${SID}\"" AS SYSDBA @GRANT_RO_ACCESS.sql "${RO_USERNAME}" "${USERNAME}"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
