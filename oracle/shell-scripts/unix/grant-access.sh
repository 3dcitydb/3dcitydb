#!/bin/bash
# Shell script to grant access privileges to a 3DCityDB schema
# on Oracle Database 23ai or higher

# Get the current directory path of this script file
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd "$CURRENT_DIR/../../sql-scripts"

# Read database connection details
if [ $# -ne 0 ]; then
  source "$1"
else
  if [ -f connection-details.sh ]; then
	  source connection-details.sh
  else
	  source "$CURRENT_DIR/connection-details.sh"
  fi
fi

# Set database client
if [ -z "$ORACLE_CLIENT" ]; then
  ORACLE_CLIENT="sqlplus"
elif [ -d "$ORACLE_CLIENT" ]; then
  ORACLE_CLIENT="$ORACLE_CLIENT/sqlplus"
fi

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
echo 'Note: This script requires schema owner or DBA privileges.'
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

# Prompt for GRANTEE ----------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Please enter the username of the grantee.'
  read -p "(GRANTEE must already exist in database): " GRANTEE

  if [[ -z "$GRANTEE" ]]; then
    echo
    echo 'Illegal input! GRANTEE must not be empty.'
  else
    break;
  fi
done

# Prompt for SCHEMA_NAME ------------------------------------------------------
SCHEMA_NAME=$DB_USER
echo
echo "Please enter the name of the 3DCityDB schema \"$GRANTEE\" shall have access to."
read -p "(default SCHEMA_NAME=$SCHEMA_NAME): " var
SCHEMA_NAME=${var:-$SCHEMA_NAME}

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

# Run grant-access.sql to grant access privileges on a specific schema --------
echo
echo "Connecting to \"$DB_USER@$DB_HOST:$DB_PORT/$ORACLE_PDB\" ..."
"$ORACLE_CLIENT" -L "${DB_USER}@${DB_HOST}:${DB_PORT}/${ORACLE_PDB}" @grant-access.sql "$GRANTEE" "$SCHEMA_NAME" "$ACCESS_MODE"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
