#!/bin/sh
# Shell script to create an instance of the 3D City Database
# on PostgreSQL/PostGIS

# Provide your database details here
export PGPORT=5432
export PGHOST=your_host_address
export PGUSER=your_username
export CITYDB=your_database
export PGBIN=path_to_psql

# Prompt for SRSNO
regex='^[0-9]+$'
while [ 1 ]; do
  echo
  echo 'Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin).'
  echo 'Press ENTER to use default.'
  read -p "(default=3068): " SRSNO
  SRSNO=${SRSNO:-3068}
   
  if [[ ! $SRSNO =~ $regex ]]; then
    echo 'SRSNO must be numeric. Please retry.'
  else 
    break;
  fi
done

# Prompt for GMLSRSNAME
echo
echo 'Please enter the corresponding SRSName to be used in GML exports (e.g., urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783).'
echo 'Press ENTER to use default.'
read -p '(default=urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783): ' GMLSRSNAME
GMLSRSNAME=${GMLSRSNAME:-urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783}

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run CREATE_DB.sql to create the 3D City Database instance
"$PGBIN/psql" -d "$CITYDB" -f "CREATE_DB.sql" -v srsno="$SRSNO" -v gmlsrsname="$GMLSRSNAME"
