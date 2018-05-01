#!/bin/sh
# Shell script to drop an instance of the 3D City Database
# on Oracle Spatial/Locator

# Provide your database details here ------------------------------------------
export PORT=1521
export HOST=your_host_address
export USERNAME=your_username
export SID=your_SID_or_database_name
export SQLPLUSBIN=path_to_sqlplus
# DB Version (S/L) for Oracle Spatial or Oracle Locator
export DBVERSION=S
#-------------------------------------------------------------------------------

# add sqlplus to PATH
export PATH=$PATH:$SQLPLUSBIN

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run DROP_DB.sql to drop the 3D City Database instance
sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @DROP_DB.sql "${DBVERSION}"
