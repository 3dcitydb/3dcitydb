#!/bin/sh
# Shell script to migrate an instance of the 3D City Database from v2.x to v3.0
# on PostgreSQL/PostGIS

# Provide your database details here
export PGPORT=5432
export PGHOST=your_host_address
export PGUSER=your_username
export CITYDB=your_database
export PGBIN=path_to_psql

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run MIGRATE_DB.sql to migrate the 3D City Database instance from v2.x to v3.0
"$PGBIN/psql" -d "$CITYDB" -f "MIGRATE_DB.sql"