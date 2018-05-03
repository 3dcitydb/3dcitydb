#!/bin/sh
# Shell script to drop an instance of the 3D City Database
# on Oracle Spatial/Locator

# Provide your database details here ------------------------------------------
export SQLPLUSBIN=path_to_sqlplus
export HOST=your_host_address
export PORT=1521
export SID=your_SID_or_database_name
export USERNAME=your_username
#-------------------------------------------------------------------------------

# add sqlplus to PATH
PATH=$SQLPLUSBIN:$PATH

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Prompt for DBVERSION --------------------------------------------------------
test=0
while [ "$test" = "0" ]; do
  echo
  echo 'Which database license are you using? (Oracle Spatial(S)/Oracle Locator(L)): Press ENTER to use default.'
  read -p "(default DBVERSION=Oracle Spatial(S)): " DBVERSION
  DBVERSION=${DBVERSION:-S}
 
 # to upper case
  DBVERSION=$(echo "$DBVERSION" | awk '{print toupper($0)}')
  
  if [ "$DBVERSION" = "S" ] || [ "$DBVERSION" = "L" ] ; then
    test=1
  else 
    echo "Illegal input! Enter S or L."
  fi
done

# Run DROP_DB.sql to drop the 3D City Database instance -----------------------
sqlplus "${USERNAME}@\"${HOST}:${PORT}/${SID}\"" @DROP_DB.sql "${DBVERSION}"

echo
echo 'Press ENTER to quit.'
read
