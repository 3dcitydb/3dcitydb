#!/bin/bash
# Shell script to create an instance of the 3D City Database
# on PostgreSQL/PostGIS

# read database connection details
source CONNECTION_DETAILS.sh

# add psql to PATH
export PATH="$PGBIN:$PATH"

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
echo '###############################################################################'
echo
echo 'This script will guide you through the process of setting up a read-only user'
echo 'for a specific 3DCityDB schema. Please follow the instructions of the script.'
echo 'Enter the required parameters when prompted and press ENTER to confirm.'
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
echo '###############################################################################'

# cd to path of the SQL scripts
cd ../../SQLScripts/UTIL/RO_USER

# Prompt for USERNAME ---------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Please enter a username for the read-only user.'
  read -p "(USERNAME must not be empty): " USERNAME

  if [[ -z "$USERNAME" ]]; then
    echo
    echo 'Illegal input! USERNAME must not be empty.'
  else
    break;
  fi
done

# Prompt for PASSWORD ---------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Please enter a password for the read-only user.'
  read -p "(PASSWORD must not be empty): " PASSWORD

  if [[ -z "$PASSWORD" ]]; then
    echo
    echo 'Illegal input! PASSWORD must not be empty.'
  else
    break;
  fi
done

# List the existing 3DCityDB schemas ------------------------------------------
echo
echo "Reading existing 3DCityDB schemas from the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "../SCHEMAS/QUERY_SCHEMA.sql"

if [[ $? -ne 0 ]] ; then
  echo 'Failed to read 3DCityDB schemas from database.'
  read -rsn1 -p 'Press ENTER to quit.'
  exit 1
fi

# Prompt for schema name ------------------------------------------------------
SCHEMA_NAME=citydb
echo "Please enter the name of the 3DCityDB schema \"$USERNAME\" shall have access to."
read -p "(default SCHEMA_NAME=$SCHEMA_NAME): " var
SCHEMA_NAME=${var:-$SCHEMA_NAME}

# Run CREATE_RO_USER.sql to create a read-only user for a specific schema -----
echo
echo "Connecting to the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "CREATE_RO_USER.sql" -v username="$USERNAME" -v password="$PASSWORD" -v schema_name="$SCHEMA_NAME"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
