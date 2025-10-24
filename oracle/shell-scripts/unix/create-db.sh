#!/bin/bash
# Shell script to create an instance of the 3D City Database
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
echo '######################################################################################'
echo
echo 'Welcome to the 3DCityDB Setup Script. This script will guide you through the process'
echo 'of setting up a 3DCityDB instance. Please follow the instructions of the script.'
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
echo '######################################################################################'

# Prompt for SRID -------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter a valid SRID (e.g., EPSG code of the CRS to be used).'
  read -p "(SRID must be an integer greater than zero): " SRID
  SRID=${SRID:-0}

  if [[ ! $SRID =~ $re ]] || [ $SRID -le 0 ]; then
    echo
    echo 'Illegal input! Enter a positive integer for the SRID.'
  else
    break;
  fi
done

# Prompt for HEIGHT_EPSG ------------------------------------------------------
while [ 1 ]; do
  echo
  echo "Please enter the EPSG code of the height system (use 0 if unknown or '$SRID' is already 3D)."
  read -p "(default HEIGHT_EPSG=0): " HEIGHT_EPSG
  HEIGHT_EPSG=${HEIGHT_EPSG:-0}

  if [[ ! $HEIGHT_EPSG =~ $re ]]; then
    echo
    echo 'Illegal input! Enter 0 or a positive integer for the HEIGHT_EPSG.'
  else
    break;
  fi
done

# Prompt for SRS_NAME ---------------------------------------------------------
if [ $HEIGHT_EPSG -gt 0 ]; then
  SRS_NAME=urn:ogc:def:crs,crs:EPSG::$SRID,crs:EPSG::$HEIGHT_EPSG
else
  SRS_NAME=urn:ogc:def:crs:EPSG::$SRID
fi

echo
echo 'Please enter the corresponding SRS name to be used in exports.'
read -p "(default SRS_NAME=$SRS_NAME): " var
SRS_NAME=${var:-$SRS_NAME}

# Prompt for CHANGELOG ---------------------------------------------------------
while [ 1 ]; do
  echo
  echo "Shall the changelog extension be created (yes/no)?"
  read -p "(default CHANGELOG=no): " CHANGELOG
  CHANGELOG=${CHANGELOG:-no}

  # to lower case
  CHANGELOG=$(echo "$CHANGELOG" | awk '{print tolower($0)}')

  if [ "$CHANGELOG" = "yes" ] || [ "$CHANGELOG" = "no" ] ; then
    break;
  else
    echo
    echo "Illegal input! Enter yes or no."
  fi
done

# Run create-db.sql to create the 3D City Database instance -------------------
echo
echo "Connecting to \"$DB_USER@$DB_HOST:$DB_PORT/$DB_SERVICE\" ..."
echo -n "Enter password: "
sqlplus -S -L "${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_SERVICE}" @create-db.sql "$SRID" "$SRS_NAME" "$CHANGELOG"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo