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

# Prompt for SRSNO ------------------------------------------------------------
re='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin). Press ENTER to use default.'
  read -p "(default SRID=3068): " SRSNO
  SRSNO=${SRSNO:-3068}
   
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
echo
echo "Connecting to the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\"..."
psql -d "$CITYDB" -f "CREATE_DB.sql" -v srsno="$SRSNO" -v gmlsrsname="$GMLSRSNAME"

echo
echo 'Press ENTER to quit.'
read
