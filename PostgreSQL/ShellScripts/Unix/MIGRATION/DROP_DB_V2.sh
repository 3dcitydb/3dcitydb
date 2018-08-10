#!/bin/bash
# Shell script to drop an deprecated v2 instance of the 3D City Database
# on PostgreSQL/PostGIS

# read database connection details 
source ../CONNECTION_DETAILS.sh

# add psql to PATH
export PATH=$PGBIN:$PATH

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
echo '################################################################################'
echo
echo 'This script will drop the 3DCityDB v2 instance which is left after migrating'
echo 'to v4. Note that this operation cannot be undone, so be sure that all the data'
echo 'has been copied into the citydb schema correctly.'
echo
echo 'Documentation and help:'
echo '   3DCityDB website:    https://www.3dcitydb.org'
echo '   3DCityDB on GitHub:  https://github.com/3dcitydb'
echo
echo 'Having problems or need support?'
echo '   Please file an issue here:'
echo '   https://github.com/3dcitydb/3dcitydb/issues'
echo
echo '################################################################################'

# cd to path of the SQL scripts
cd ../../../SQLScripts/MIGRATION/V2_to_V4

# Run DROP_DB_V2.sql to drop the 3D City Database v2 instance -----------------------
echo
echo "Connecting to the database \"$PGUSER@$PGHOST:$PGPORT/$CITYDB\" ..."
psql -d "$CITYDB" -f "DROP_DB_V2.sql"

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
