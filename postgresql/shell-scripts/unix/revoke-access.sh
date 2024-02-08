#!/bin/bash
# Shell script to revoke access privileges from a 3DCityDB schema
# on PostgreSQL/PostGIS

# Get the current directory path of this script file
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
if [ $# -ne 0 ]; then
  source "$1"
else
  if [ -f connection-details.sh ]; then
	  source connection-details.sh
  else
	  source "$CURRENT_DIR/connection-details.sh"
  fi
fi

# Add PGBIN to PATH
export PATH="$PGBIN:$PATH"

# Welcome message
echo ' _______   ___ _ _        ___  ___ '
echo '|__ /   \ / __(_) |_ _  _|   \| _ )'
echo ' |_ \ |) | (__| |  _| || | |) | _ \'
echo '|___/___/ \___|_|\__|\_, |___/|___/'
echo '                     |__/          '
echo
echo '3D City Database - The Open Source CityGML Database'
echo
echo '#######################################################################################'
echo
echo 'This script will revoke access privileges on a 3DCityDB schema from a user. Note that'
echo 'this operation cannot be undone. Please follow the instructions of the script.'
echo 'Enter the required parameters when prompted and press ENTER to confirm.'
echo 'Just press ENTER to use the default values.'
echo
echo 'Note: This script requires superuser privileges.'
echo
echo 'Documentation and help:'
echo '   3DCityDB website:    https://www.3dcitydb.org'
echo '   3DCityDB on GitHub:  https://github.com/3dcitydb'
echo
echo 'Having problems or need support?'
echo '   Please file an issue here:'
echo '   https://github.com/3dcitydb/3dcitydb/issues'
echo
echo '#######################################################################################'

# Prompt for GRANTEE ----------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Please enter the username of the read-only user.'
  read -p "(GRANTEE must not be empty): " GRANTEE

  if [[ -z "$GRANTEE" ]]; then
    echo
    echo 'Illegal input! GRANTEE must not be empty.'
  else
    break;
  fi
done

# List the 3DCityDB schemas granted to GRANTEE --------------------------------
echo
echo "Reading 3DCityDB schemas granted to \"$GRANTEE\" from \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "$CURRENT_DIR/../../sql-scripts/util/list-schemas-with-access-grant.sql" -v username="$GRANTEE"

if [[ $? -ne 0 ]] ; then
  echo 'Failed to read 3DCityDB schemas from database.'
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

# Prompt for SCHEMA_NAME ------------------------------------------------------
SCHEMA_NAME=citydb
echo "Please enter the name of the 3DCityDB schema that shall be revoked from \"$GRANTEE\"."
read -p "(default SCHEMA_NAME=$SCHEMA_NAME): " var
SCHEMA_NAME=${var:-$SCHEMA_NAME}

# Run revoke-access.sql to revoke read-only access on a specific schema -------
echo
echo "Connecting to \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "$CURRENT_DIR/../../sql-scripts/revoke-access.sql" -v username="$GRANTEE" -v schema_name="$SCHEMA_NAME"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
