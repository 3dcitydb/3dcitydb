#!/bin/sh
# Shell script to drop an instance of the 3D City Database
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
  # Run DROP_DB.sql to drop the 3D City Database instance -----------------------
  psql -d "$CITYDB" -f "DROP_DB.sql"

  elif [ $# -ne 5 ]; then
  # Correct number of args supplied? ------------------------------------------
  >&2 echo 'ERROR: Invalid number of arguments.'
  >&2 echo
  <&2 echo "Usage: $(basename "$0") HOST PORT CITYDB USERNAME PASSWORD"
  <&2 echo 'No args can be ommitted and the order is mandatory.'
  <&2 echo
  <&2 echo 'HOST          Database host'
  <&2 echo 'PORT          Database port'
  <&2 echo 'CITYDB        Database name'
  <&2 echo 'USERNAME      Database username'
  <&2 echo 'PASSWORD      Database password'
  <&2 echo
  
else 
  # Parse args ----------------------------------------------------------------
  # $1 = HOST
  # $2 = PORT
  # $3 = CITYDB
  # $4 = USERNAME
  # $5 = PASSWORD

  HOST=$1
  PORT=$2
  CITYDB=$3
  USERNAME=$4
  PASSWORD=$5
  
  # Run CREATE_DB.sql to create the 3D City Database instance -----------------
  export PGHOST=$HOST
  export PGPORT=$PORT
  export PGUSER=$USERNAME
  export PGPASSWORD=$PASSWORD
  
  psql -d "$CITYDB" -f "DROP_DB.sql"
fi
