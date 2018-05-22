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

# Interactive mode or usage with arguments? -----------------------------------
if [ $# -eq 0 ]; then
  # INTERACTIVE MODE ----------------------------------------------------------
  # Prompt for DBVERSION ------------------------------------------------------
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

  # Prompt for VERSIONING -----------------------------------------------------
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

  # Prompt for SRSNO ----------------------------------------------------------
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

  # Prompt for GMLSRSNAME -----------------------------------------------------
  echo
  echo 'Please enter the corresponding SRSName to be used in GML exports. Press ENTER to use default.'
  read -p '(default GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): ' GMLSRSNAME
  GMLSRSNAME=${GMLSRSNAME:-urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783}

  # Run CREATE_DB.sql to create the 3D City Database instance -----------------
  sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"
  
elif [ $# -ne 9 ]; then
  # Correct number of args supplied? ------------------------------------------
  >&2 echo 'ERROR: Invalid number of arguments.'
  >&2 echo
  <&2 echo "Usage: $(basename "$0") HOST PORT SID USERNAME PASSWORD DBVERSION VERSIONING SRSNO GMLSRSNAME"
  <&2 echo 'No args can be ommitted and the order is mandatory.'
  <&2 echo
  <&2 echo 'HOST          Database host'
  <&2 echo 'PORT          Database port'
  <&2 echo 'SID           Database sid'
  <&2 echo 'USERNAME      Database username'
  <&2 echo 'PASSWORD      Database password'
  <&2 echo 'DBVERSION     Database license type, Oracle (S)patial or Oracle (L)ocator (S/L)'
  <&2 echo 'VERSIONING    Enable database versioning (yes/no)'
  <&2 echo 'SRSNO         Spatial reference system number (SRID)'
  <&2 echo 'GMLSRSNAME    SRSName to be used in GML exports'
  <&2 echo
  
else 
  # Parse args ----------------------------------------------------------------
  # $1 = HOST
  # $2 = PORT
  # $3 = SID
  # $4 = USERNAME
  # $5 = PASSWORD
  # $6 = DBVERSION
  # $7 = VERSIONING
  # $8 = SRSNO
  # $9 = GMLSRSNAME

  HOST=$1
  PORT=$2
  SID=$3
  USERNAME=$4
  PASSWORD=$5
  DBVERSION=$6
  VERSIONING=$7
  SRSNO=$8
  GMLSRSNAME=$9
  
  # Run CREATE_DB.sql to create the 3D City Database instance -----------------
  sqlplus "${USERNAME}/\"${PASSWORD}\"@\"${HOST}:${PORT}/${SID}\"" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"
fi
