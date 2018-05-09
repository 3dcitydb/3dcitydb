#!/bin/bash
# Shell script to create an instance of the 3D City Database
# on Oracle Spatial/Locator

# Provide your database details here ------------------------------------------
export SQLPLUSBIN=path_to_sqlplus
export HOST=your_host_address
export PORT=1521
export SID=your_SID_or_database_name
export USERNAME=your_username
#------------------------------------------------------------------------------

# add sqlplus to PATH
export PATH="$SQLPLUSBIN:$PATH"

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
  echo 'Please enter a valid SRID (e.g. Berlin: 81989002).'
  read -p "(default SRID=81989002): " SRSNO
  SRSNO=${SRSNO:-81989002}

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

# Prompt for VERSIONING -------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Shall versioning be enabled (yes/no)?'
  read -p "(default VERSIONING=no): " VERSIONING
  VERSIONING=${VERSIONING:-no}

  # to lower case
  VERSIONING=$(echo "$VERSIONING" | awk '{print tolower($0)}')

  if [  "$VERSIONING" = "yes" ] || [ "$VERSIONING" = "no" ] ; then
    break;
  else
    echo
    echo "Illegal input! Enter yes or no."
  fi
done

# Prompt for DBVERSION --------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Which database license are you using (Spatial=S/Locator=L)?'
  read -p "(default DBVERSION=S): " DBVERSION
  DBVERSION=${DBVERSION:-S}

 # to upper case
  DBVERSION=$(echo "$DBVERSION" | awk '{print toupper($0)}')

  if [ "$DBVERSION" = "S" ] || [ "$DBVERSION" = "L" ] ; then
    break;
  else
    echo
    echo "Illegal input! Enter S or L."
  fi
done

# Run CREATE_DB.sql to create the 3D City Database instance -------------------
echo
echo "Connecting to the database \"$USERNAME@$HOST:$PORT/$SID\"..."
sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
