#!/bin/sh
# Shell script to create an instance of the 3D City Database
# on PostgreSQL/PostGIS

# Provide your database details here ------------------------------------------
export PGBIN=path_to_psql
export PGHOST=your_host_address
export PGPORT=5432
export CITYDB=your_database
export PGUSER=your_username
#------------------------------------------------------------------------------

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

# Prompt for SRSNO ------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin).'
  read -p "(default SRID=3068): " SRSNO
  SRSNO=${SRSNO:-3068}

  if [[ ! $SRSNO =~ $re ]]; then
    echo
    echo 'SRID must be numeric. Please retry.'
  else
    break;
  fi
done

# Prompt for GMLSRSNAME -------------------------------------------------------
echo
echo 'Please enter the corresponding gml:srsName to be used in GML exports.'
read -p '(default GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): ' GMLSRSNAME
GMLSRSNAME=${GMLSRSNAME:-urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783}

# Run CREATE_DB.sql to create the 3D City Database instance -------------------
echo
echo "Connecting to the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\"..."
psql -d "$CITYDB" -f "CREATE_DB.sql" -v srsno="$SRSNO" -v gmlsrsname="$GMLSRSNAME"

echo
read -rp 'Press ENTER to quit.' _
