#!/bin/bash
# Shell script to create an new new 3DCityDB schema
# on PostgreSQL/PostGIS

# read database connection details
source CONNECTION_DETAILS.sh

# add PGBIN to PATH
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
echo '#####################################################################################'
echo
echo 'This script will guide you through the process of setting up an additional 3DCityDB'
echo 'schema for an existing database. Please follow the instructions of the script.'
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
echo '#####################################################################################'

# cd to path of the SQL scripts
cd ../../SQLScripts/UTIL/SCHEMAS

# List the existing 3DCityDB schemas ------------------------------------------
echo
echo "Reading 3DCityDB schemas from \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "LIST_SCHEMAS.sql"

if [[ $? -ne 0 ]] ; then
  echo 'Failed to read 3DCityDB schemas from database.'
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

# Prompt for schema name ------------------------------------------------------
SCHEMA_NAME=citydb2
echo 'Please enter the name of the 3DCityDB schema you want to create.'
read -p "(default SCHEMA_NAME=$SCHEMA_NAME): " var
SCHEMA_NAME=${var:-$SCHEMA_NAME}

# Create temporary SQL scripts ------------------------------------------------
echo
echo -n "Preparing SQL scripts for setting up \"$SCHEMA_NAME\" ... "
TOKEN=citydb
DELETE_FILE=../../SCHEMA/DELETE/DELETE.sql
TMP_DELETE_FILE=TMP_${SCHEMA_NAME}_DELETE.sql
ENVELOPE_FILE=../../SCHEMA/ENVELOPE/ENVELOPE.sql
TMP_ENVELOPE_FILE=TMP_${SCHEMA_NAME}_ENVELOPE.sql

sed 's/'$TOKEN'/'$SCHEMA_NAME'/g' $DELETE_FILE > $TMP_DELETE_FILE
sed 's/'$TOKEN'/'$SCHEMA_NAME'/g' $ENVELOPE_FILE > $TMP_ENVELOPE_FILE
echo 'Done.'

# Run CREATE_SCHEMA.sql to create a new 3DCityDB schema -----------------------
echo
echo "Connecting to \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "CREATE_SCHEMA.sql" -v schema_name="$SCHEMA_NAME" -v tmp_delete_file="$TMP_DELETE_FILE" -v tmp_envelope_file="$TMP_ENVELOPE_FILE"

# Remove temporary SQL scripts ------------------------------------------------
rm -f $TMP_DELETE_FILE
rm -f $TMP_ENVELOPE_FILE

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
