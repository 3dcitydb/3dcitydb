#!/bin/bash
# Shell script to drop an instance of the 3D City Database
# on Oracle

# Get the current directory path of this script file
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
if [ $# -ne 0 ]; then
  source "$1"
else
  if [ -f connection-details.sh ]; then
	  source connection-details.sh
  else
	  source "$CURRENT_DIR/connection-details.sh"
  fi
fi

# add SQLPLUSBIN to PATH
export PATH="$SQLPLUSBIN:$PATH"

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
echo 'This script will drop the 3DCityDB instance including all data. Note that this'
echo 'operation cannot be undone.'
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

# Run drop-db.sql to drop the 3D City Database instance -----------------------
echo

echo "Connecting to \"$DBUSER@$DBHOST:$DBPORT/$ORACLE_PDB\" ..."
echo -n "Enter password: "
sqlplus -S -L "${DBUSER}@\"${DBHOST}:${DBPORT}/${ORACLE_PDB}\"" @DROP_DB.sql
echo
read -rsn1 -p 'Press ENTER to quit.'
echo

# 3DCityDB drop-db.sh #########################################################
#
# Maintainer ------------------------------------------------------------------
#   Karin Patenge
#   Oracle Global Services Deutschland GmbH
#   karin.patenge(at)oracle.com
#
# Reviewers -------------------------------------------------------------------
#
#
###############################################################################