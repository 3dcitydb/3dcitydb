#!/bin/sh
# Shell script to create an instance of the 3D City Database
# on Oracle Spatial/Locator

# Provide your database details here ------------------------------------------
export PORT=1521
export HOST=your_host_address
export USERNAME=your_username
export SID=your_SID_or_database_name
export SQLPLUSBIN=path_to_sqlplus
export SRSNO=
export GMLSRSNAME=
# Database versioning (yes/no)
export VERSIONING=no 
# DB Version (S/L) for Oracle Spatial or Oracle Locator
export DBVERSION=S
#------------------------------------------------------------------------------

# add sqlplus to PATH
export PATH=$PATH:$SQLPLUSBIN

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run CREATE_DB.sql to create the 3D City Database instance
sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"
