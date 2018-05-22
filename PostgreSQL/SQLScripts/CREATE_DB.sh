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
PATH=$PGBIN:$PATH
# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Interactive mode or usage with arguments? -----------------------------------
if [ $# -eq 0 ]; then
  # INTERACTIVE MODE ----------------------------------------------------------
  # Prompt for SRSNO ----------------------------------------------------------
  re='^[0-9]+$'
  while [ 1 ]; do
    echo
    echo 'Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin): Press ENTER to use default.'
    read -p "(default SRID=3068): " SRSNO
    SRSNO=${SRSNO:-3068}
    
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
  psql -d "$CITYDB" -f "CREATE_DB.sql" -v srsno="$SRSNO" -v gmlsrsname="$GMLSRSNAME"
  
elif [ $# -ne 7 ]; then
  # Correct number of args supplied? ------------------------------------------
  >&2 echo 'ERROR: Invalid number of arguments.'
  >&2 echo
  <&2 echo "Usage: $(basename "$0") HOST PORT CITYDB USERNAME PASSWORD SRSNO GMLSRSNAME"
  <&2 echo 'No args can be ommitted and the order is mandatory.'
  <&2 echo
  <&2 echo 'HOST          Database host'
  <&2 echo 'PORT          Database port'
  <&2 echo 'CITYDB        Database name'
  <&2 echo 'USERNAME      Database username'
  <&2 echo 'PASSWORD      Database password'
  <&2 echo 'SRSNO         Spatial reference system number (SRID)'
  <&2 echo 'GMLSRSNAME    SRSName to be used in GML exports'
  <&2 echo
  
else 
  # Parse args ----------------------------------------------------------------
  # $1 = HOST
  # $2 = PORT
  # $3 = CITYDB
  # $4 = USERNAME
  # $5 = PASSWORD
  # $6 = SRSNO
  # $7 = GMLSRSNAME

  HOST=$1
  PORT=$2
  CITYDB=$3
  USERNAME=$4
  PASSWORD=$5
  export SRSNO=$6
  export GMLSRSNAME=$7
  
  # Run CREATE_DB.sql to create the 3D City Database instance -----------------
  export PGHOST=$HOST
  export PGPORT=$PORT
  export PGUSER=$USERNAME
  export PGPASSWORD=$PASSWORD
  
  psql -d "$CITYDB" -f "CREATE_DB.sql" -v srsno="$SRSNO" -v gmlsrsname="$GMLSRSNAME"
fi
  