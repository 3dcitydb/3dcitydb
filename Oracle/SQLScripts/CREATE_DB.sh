#!/bin/sh
# Shell script to create an instance of the 3D City Database
# on Oracle Spatial/Locator

# Provide your database details here ------------------------------------------
export PORT=1521
export HOST=your_host_address
export USERNAME=your_username
# for testing only, to be removed!
export PASSWORD=your_password
export SID=your_SID_or_database_name
export SQLPLUSBIN=path_to_sqlplus
export SRSNO=
export GMLSRSNAME=
# Database versioning (yes/no)
export VERSIONING=no 
# DB Version (S/L) for Oracle Spatial or Oracle Locator
export DBVERSION=S
# -----------------------------------------------------------------------------

# add sqlplus to PATH
export PATH=$PATH:$SQLPLUSBIN

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run CREATE_DB.sql to create the 3D City Database instance

# Opt1: This works for me
sqlplus -S "${USERNAME}/${PASSWORD}@${HOST}:${PORT}/${SID}" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"

# Opt2: -Preferable, as password and username are prompted by sqlplus, not working for me
#sqlplus "${HOST}:${PORT}/${SID}" @CREATE_DB.sql "${SRSNO}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"

echo 'Press ENTER to quit!'
read
