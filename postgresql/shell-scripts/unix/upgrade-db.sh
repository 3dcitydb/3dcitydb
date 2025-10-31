#!/bin/bash
# Shell script to upgrade an instance of the 3D City Database
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
echo '################################################################################'
echo
echo 'This script will upgrade the 3DCityDB instance to the latest version. Note that'
echo 'this operation cannot be undone.'
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

# Run upgrade-db.sql to upgrade the 3D City Database instance -----------------
echo
echo "Connecting to \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
"$PGBIN" -d "$CITYDB" -f "$CURRENT_DIR/../../sql-scripts/upgrade-db.sql"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo