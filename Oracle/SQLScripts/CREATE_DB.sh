#!/bin/sh
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
PATH=$SQLPLUSBIN:$PATH

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Prompt for DBVERSION --------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Which database license are you using? (Oracle Spatial(S)/Oracle Locator(L)): Press ENTER to use default.'
  read -p "(default DBVERSION=Oracle Spatial(S)): " DBVERSION
  DBVERSION=${DBVERSION:-S}
 
 # to upper case
  DBVERSION=$(echo "$DBVERSION" | awk '{print toupper($0)}')
  
  if [ "$DBVERSION" = "S" ] || [ "$DBVERSION" = "L" ] ; then
    break;
  else 
    echo "Illegal input! Enter S or L."  
  fi
done

# Prompt for VERSIONING -------------------------------------------------------
while [ 1 ]; do
  echo
  echo 'Shall versioning be enabled? (yes/no): Press ENTER to use default.'
  read -p "(default VERSIONING=no): " VERSIONING
  VERSIONING=${VERSIONING:-no}
  
  # to lower case
  VERSIONING=$(echo "$VERSIONING" | awk '{print tolower($0)}')
  
  if [  "$VERSIONING" = "yes" ] || [ "$VERSIONING" = "no" ] ; then
    break;
  else 
    echo "Illegal input! Enter yes or no."  
  fi
done

# Prompt for SRSNO ------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter a valid SRID (e.g. Berlin: 81989002): Press ENTER to use default.'
  read -p "(default SRID=81989002): " SRSNO
  SRSNO=${SRSNO:-81989002}
  
  if [[ ! $SRSNO =~ $re ]]; then
    echo 'SRID must be numeric. Please retry.'
  else 
    break;
  fi
done

# Prompt for GMLSRSNAME -------------------------------------------------------
echo
echo 'Please enter the corresponding SRSName to be used in GML exports. Press ENTER to use default.'
read -p '(default GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): ' GMLSRSNAME
GMLSRSNAME=${GMLSRSNAME:-urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783}

# Run CREATE_DB.sql to create the 3D City Database instance -------------------
sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"

echo
echo 'Press ENTER to quit.'
read
