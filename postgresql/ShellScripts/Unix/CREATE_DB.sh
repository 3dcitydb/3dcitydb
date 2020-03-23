#!/bin/bash
# Shell script to create an instance of the 3D City Database
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

# cd to path of the SQL scripts
cd ../../SQLScripts

# Prompt for SRSNO ------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter a valid SRID (e.g., EPSG code of the CRS to be used).'
  read -p "(SRID must be an integer greater than zero): " SRSNO
  SRSNO=${SRSNO:-0}

  if [[ ! $SRSNO =~ $re ]] || [ $SRSNO -le 0 ]; then
    echo
    echo 'Illegal input! Enter a positive integer for the SRID.'
  else
    break;
  fi
done

# Prompt for HEIGHT_EPSG ------------------------------------------------------
while [ 1 ]; do
  echo
  echo "Please enter the EPSG code of the height system (use 0 if unknown or '$SRSNO' is already 3D)."
  read -p "(default HEIGHT_EPSG=0): " HEIGHT_EPSG
  HEIGHT_EPSG=${HEIGHT_EPSG:-0}

  if [[ ! $HEIGHT_EPSG =~ $re ]]; then
    echo
    echo 'Illegal input! Enter 0 or a positive integer for the HEIGHT_EPSG.'
  else
    break;
  fi
done

# Prompt for GMLSRSNAME -------------------------------------------------------
if [ $HEIGHT_EPSG -gt 0 ]; then
  GMLSRSNAME=urn:ogc:def:crs,crs:EPSG::$SRSNO,crs:EPSG::$HEIGHT_EPSG
else
  GMLSRSNAME=urn:ogc:def:crs:EPSG::$SRSNO
fi

echo
echo 'Please enter the corresponding gml:srsName to be used in GML exports.'
read -p "(default GMLSRSNAME=$GMLSRSNAME): " var
GMLSRSNAME=${var:-$GMLSRSNAME}

# Run CREATE_DB.sql to create the 3D City Database instance -------------------
echo
echo "Connecting to \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "CREATE_DB.sql" -v srsno="$SRSNO" -v gmlsrsname="$GMLSRSNAME"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
