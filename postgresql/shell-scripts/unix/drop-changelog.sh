#!/bin/bash
# Shell script to drop the changelog extension of the 3DCityDB
# on PostgreSQL/PostGIS

# Get the current directory path of this script file
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"

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
if [ -z "$PGBIN" ]; then
  PGBIN="psql"
elif [ -d "$PGBIN" ]; then
  PGBIN="$PGBIN/psql"
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

# List the existing 3DCityDB schemas with changelog ---------------------------
echo
echo "Reading 3DCityDB schemas from \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
"$PGBIN" -d "$CITYDB" -f "$CURRENT_DIR/../../sql-scripts/util/list-schemas-with-changelog.sql"

if [[ $? -ne 0 ]] ; then
  echo 'Failed to read schemas from database.'
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

# Prompt for schema name ------------------------------------------------------
SCHEMA_NAME=citydb
echo 'Please enter the name of the 3DCityDB schema from which the changelog extension will be removed.'
read -p "(default SCHEMA_NAME=$SCHEMA_NAME): " var
SCHEMA_NAME=${var:-$SCHEMA_NAME}

# Run drop-db-extension.sql to drop the 3DCityDB changelog extension ----------
echo
echo "Connecting to the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
"$PGBIN" -d "$CITYDB" -f "$CURRENT_DIR/../../sql-scripts/drop-changelog.sql" -v schema_name="$SCHEMA_NAME"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo