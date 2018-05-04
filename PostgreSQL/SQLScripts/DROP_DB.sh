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

# Run DROP_DB.sql to drop the 3D City Database instance -----------------------
psql -d "$CITYDB" -f "DROP_DB.sql"

echo
echo 'Press ENTER to quit.'
read
