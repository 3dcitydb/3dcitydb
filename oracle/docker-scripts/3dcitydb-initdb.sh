#!/usr/bin/env bash
# 3DCityDB setup --------------------------------------------------------------

# Exit on error
set -e

# Set 3DCityDB version --------------------------------------------------------
if [ -z $CITYDB_VERSION ]; then
  # CITYDB_VERSION unset, read version from the version.txt file
  CITYDB_VERSION=$(< version.txt)
fi

# ORACLE_PWD ------------------------------------------------------------------
if [ -z $ORACLE_PWD ]; then
  echo
  echo "ORACLE_PWD is not set. No 3DCityDB instance will be created."
  exit 1
fi

# SRID ------------------------------------------------------------------------
regex_numeric='^[0-9]+$'
if [ -z ${SRID+x} ]; then
  # No SRID set -> give instructions on how to create a DB and do nothing
  echo
  echo "SRID is not set. No 3DCityDB instance will be created."
  exit 1
else
  # SRID given, check if valid
  if [[ ! $SRID =~ $regex_numeric ]] || [ $SRID -le 0 ]; then
        echo
        echo 'Illegal input. Enter a positive integer for the SRID.'
  fi
fi

# SRS_NAME --------------------------------------------------------------------
if [ -z ${SRS_NAME+x} ]; then
  # SRS_NAME unset, set default SRS_NAME using HEIGHT_EPSG if set
  # HEIGHT EPSG ---------------------------------------------------------------
  if [ -z ${HEIGHT_EPSG+x} ]; then
    # No HEIGHT_EPSG given
    SRS_NAME="urn:ogc:def:crs:EPSG::$SRID"
  else
    if [ $HEIGHT_EPSG -gt 0 ]; then
      SRS_NAME="urn:ogc:def:crs,crs:EPSG::$SRID,crs:EPSG::$HEIGHT_EPSG"
    else
      SRS_NAME="urn:ogc:def:crs:EPSG::$SRID"
    fi
  fi
else
  if [ ! -z ${HEIGHT_EPSG+x} ]; then
    # SRS_NAME is set, HEIGHT_EPSG is ignored
    echo
    echo "WARNING: SRS_NAME is set. HEIGHT_EPSG will be ignored."
  fi
fi

# CHANGELOG -------------------------------------------------------------------
if [ -z ${CHANGELOG+x} ]; then
  CHANGELOG="no"
fi

# ORACLE_PDB ------------------------------------------------------------------
if [ -z ${ORACLE_PDB+x} ]; then
  ORACLE_PDB="FREEPDB1"
fi

# DB_USER ---------------------------------------------------------------------
if [ -z ${DB_USER+x} ]; then
  DB_USER="citydb"
fi

# Read Oracle version ---------------------------------------------------------
ORACLE_VERSION=$(sqlplus -S -L system/"$ORACLE_PWD"@"$ORACLE_PDB" <<-EOF
  SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
  SELECT banner FROM v\$version;
EOF
)

# Create user -----------------------------------------------------------------
echo
echo "Creating user '$DB_USER' ..."
sqlplus -S -L system/"$ORACLE_PWD"@"$ORACLE_PDB" <<-EOF > /dev/null
  CREATE USER IF NOT EXISTS $DB_USER identified by $ORACLE_PWD;
  ALTER USER $DB_USER QUOTA UNLIMITED ON USERS;
  GRANT CONNECT, RESOURCE to $DB_USER;
  GRANT CREATE SESSION TO $DB_USER;
  GRANT DB_DEVELOPER_ROLE TO $DB_USER;
EOF
echo "Creating user '$DB_USER' done."

# Setup 3DCityDB schema -------------------------------------------------------
echo
echo "Setting up 3DCityDB database schema for user '$DB_USER' ..."
sqlplus -S -L "$DB_USER"/"$ORACLE_PWD"@"$ORACLE_PDB" @create-db.sql \
  "${SRID}" "${SRS_NAME}" "${CHANGELOG}" > /dev/null
echo "Setting up 3DCityDB database schema for user '$DB_USER' done."

# Echo info -------------------------------------------------------------------
cat <<EOF


###############################################################################
#  _______   ___ _ _        ___  ___
# |__ /   \ / __(_) |_ _  _|   \| _ )
#  |_ \ |) | (__| |  _| || | |) | _ \\
# |___/___/ \___|_|\__|\_, |___/|___/
#                      |__/
#
# 3DCityDB Docker Oracle
#
# Oracle ----------------------------------------------------------------------
#   Oracle version      $ORACLE_VERSION
#
# 3DCityDB --------------------------------------------------------------------
#   3DCityDB version    $CITYDB_VERSION
#   ORACLE_PDB          $ORACLE_PDB
#   DB_USER             $DB_USER
#   SRID                $SRID
#   SRS_NAME            $SRS_NAME
#   HEIGHT_EPSG         $HEIGHT_EPSG
#   CHANGELOG enabled   $CHANGELOG
#
#   https://github.com/3dcitydb
#
# Maintainer ------------------------------------------------------------------
#   Karin Patenge
#   Oracle Global Services Deutschland GmbH
#   karin.patenge(at)oracle.com
#
################################################################################

EOF
