#!/bin/bash
# Shell script to drop an instance of the 3D City Database
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

# Add SQLPLUS_PATH to PATH
export PATH="$SQLPLUS_PATH:$PATH"

# Welcome message
echo ' _______   ___ _ _        ___  ___ '
echo '|__ /   \ / __(_) |_ _  _|   \| _ )'
echo ' |_ \ |) | (__| |  _| || | |) | _ \'
echo '|___/___/ \___|_|\__|\_, |___/|___/'
echo '                     |__/          '
echo
echo '3D City Database - The Open Source CityGML Database'
echo
echo '################################################################################'
echo
echo 'This script will drop the 3DCityDB instance including all data. Note that this'
echo 'operation cannot be undone.'
echo
echo 'Documentation and help:'
echo '   3DCityDB website:    https://www.3dcitydb.org'
echo '   3DCityDB on GitHub:  https://github.com/3dcitydb'
echo
echo 'Having problems or need support?'
echo '   Please file an issue here:'
echo '   https://github.com/3dcitydb/3dcitydb/issues'
echo
echo '################################################################################'

# Run drop-db.sql to drop the 3D City Database instance -----------------------
echo
echo "Connecting to \"$DB_USER@$DB_HOST:$DB_PORT/$DB_SERVICE\" ..."
echo -n "Enter password: "
sqlplus -S -L "${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_SERVICE}" @drop-db.sql

echo
read -rsn1 -p 'Press ENTER to quit.'
echo