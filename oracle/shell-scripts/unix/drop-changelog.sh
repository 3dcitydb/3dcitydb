#!/bin/bash
# Shell script to drop the changelog extension of the 3DCityDB
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
echo 'This script will guide you through the process of dropping the changelog extension'
echo 'for an existing 3DCityDB instance. Please follow the instructions of the script.'
echo 'Enter the required parameters when prompted and press ENTER to confirm'
echo 'Just press ENTER to use the default values.'
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

# Run drop-db-extension.sql to drop the 3DCityDB changelog extension ----------
echo
echo "Connecting to \"$DB_USER@$DB_HOST:$DB_PORT/$ORACLE_PDB\" ..."
"$ORACLE_CLIENT" -L "${DB_USER}@${DB_HOST}:${DB_PORT}/${ORACLE_PDB}" @drop-changelog.sql

echo
read -rsn1 -p 'Press ENTER to quit.'
echo