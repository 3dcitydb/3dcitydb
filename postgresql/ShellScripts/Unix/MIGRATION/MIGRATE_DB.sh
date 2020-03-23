#!/bin/bash
# Shell script to migrate an instance of the 3D City Database
# on PostgreSQL/PostGIS

# read database connection details 
source ../CONNECTION_DETAILS.sh

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
echo '######################################################################################'
echo
echo 'Welcome to the 3DCityDB Migrate Script. This script will guide you through the'
echo 'process of migrating an existing 3DCityDB instance of version 2 or 3 to version 4.'
echo 'Please follow the instructions echo of the script. Enter the required parameter when'
echo 'prompted and press ENTER to confirm. Just press ENTER to use the default values.'
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

# Prompt for VERS -------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter the number of currently used major version.'
  read -p "(number must be an integer 2 or 3): " VERS
  VERS=${VERS:-0}

  if [[ ! $VERS =~ $re ]] || [ $VERS -le 0 ]; then
    echo
    echo 'Illegal input! Enter a positive integer for the version.'
  else
    break;
  fi
done

# Prompt for TEXOP ------------------------------------------------------------
while [ 1 ]; do
  if [ $VERS -le 2 ]; then
    cd ../../../SQLScripts/MIGRATION/V2_to_V4
    echo
    echo 'No texture URI is used for multiple texture files (yes/no):?'
    read -p "(default TEXOP=no): " TEXOP
  else
    cd ../../../SQLScripts/MIGRATION/V3_to_V4
  fi
  TEXOP=${TEXOP:-no}
  
  if [ "$TEXOP" = "yes" ] || [ "$TEXOP" = "no" ] ; then
    break;
  else
    echo
    echo "Illegal input! Enter yes or no."
  fi
done

# Run MIGRATE_DB.sql to create the 3D City Database instance -------------------
echo
echo "Connecting to the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "MIGRATE_DB.sql" -texop="$TEXOP"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
