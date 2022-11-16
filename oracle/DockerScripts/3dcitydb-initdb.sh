#!/usr/bin/env bash
# 3DCityDB setup --------------------------------------------------------------

# Print commands and their arguments as they are executed
set -e;

# ORACLE_PWD ------------------------------------------------------------------
if [ -z ${ORACLE_PWD+x} ]; then
  echo
  echo "Password (ORACLE_PWD) must be set for Oracle Database users."
  exit
fi

# ORACLE_PDB ------------------------------------------------------------------
if [ -z ${ORACLE_PDB+x} ]; then
  ORACLE_PDB="ORCLPDB1"
else
  ORACLE_PDB="$ORACLE_PDB"
fi

# SRID ------------------------------------------------------------------------
regex_numeric='^[0-9]+$'
if [ -z ${SRID+x} ]; then
  # No SRID set -> give instructions on how to create a DB and do nothing
  echo
  echo "SRID is not set. No 3DCityDB instance will be created."
  exit
else
  # SRID given, check if valid
  if [[ ! $SRID =~ $regex_numeric ]] || [ $SRID -le 0 ]; then
        echo
        echo 'Illegal input! Enter a positive integer for the SRID.'
  fi
fi

# GMLSRSNAME  -----------------------------------------------------------------
if [ -z ${GMLSRSNAME+x} ]; then
  # GMLSRSNAME unset, set default GMLSRSNAME using HEIGHT_EPSG if set
  # HEIGHT EPSG ---------------------------------------------------------------
  if [ -z ${HEIGHT_EPSG+x} ]; then
    # No HEIGHT_EPSG given
    GMLSRSNAME="urn:ogc:def:crs:EPSG::$SRID"
  else
    if [ $HEIGHT_EPSG -gt 0 ]; then
      GMLSRSNAME="urn:ogc:def:crs,crs:EPSG::$SRID,crs:EPSG::$HEIGHT_EPSG"
    else
      GMLSRSNAME="urn:ogc:def:crs:EPSG::$SRID"
    fi
  fi
else
  if [ ! -z ${HEIGHT_EPSG+x} ]; then
    # GMLSRSNAME is set, HEIGHT_EPSG is ignored
    echo
    echo "!!! WARNING: GMLSRSNAME is set. HEIGHT_EPSG will be ignored."
  fi
fi

# VERSIONING ------------------------------------------------------------------
if [ -z ${VERSIONING+x} ]; then
  VERSIONING="no"
else
  VERSIONING="$VERSIONING"
fi

# DBUSER
if [ -z ${DBUSER+x} ]; then
  DBUSER="citydb"
else
  DBUSER="$DBUSER"
fi

# Create user -----------------------------------------------------------------
echo
echo "Creating user $DBUSER ..."
echo "CREATE USER $DBUSER identified by $ORACLE_PWD;
      GRANT CONNECT, RESOURCE to $DBUSER;
      GRANT CREATE TABLE to $DBUSER;
      GRANT CREATE SEQUENCE to $DBUSER;
      GRANT CREATE TRIGGER to $DBUSER;
      GRANT UNLIMITED TABLESPACE to $DBUSER;" | sqlplus sys/"$ORACLE_PWD"@"$ORACLE_PDB" as sysdba
echo "Creating user $DBUSER ... done!"
echo

# Enable GeoRaster (required since Oracle 19c)
echo "EXECUTE SDO_GEOR_ADMIN.ENABLEGEORASTER;" | sqlplus "$DBUSER"/"$ORACLE_PWD"@localhost:1521/"$ORACLE_PDB"

# Setup 3DCityDB schema -------------------------------------------------------
echo "Setting up 3DCityDB schema in $DBUSER ..."
sqlplus -S -L "$DBUSER"/"$ORACLE_PWD"@localhost:1521/"$ORACLE_PDB" @CREATE_DB.sql "${SRID}" "${GMLSRSNAME}" "${VERSIONING}"
echo "Setting up 3DCityDB schema in $DBUSER ...done!"
echo
echo "# Setting up 3DCityDB ... done! ################################################"

# Echo info -------------------------------------------------------------------
cat <<EOF


# 3DCityDB Docker Oracle ######################################################
#
# Oracle Version --------------------------------------------------------------
#   Latest Oracle Database Enterprise Edition from Oracle Container Registry
#   https://container-registry.oracle.com/
#
# 3DCityDB --------------------------------------------------------------------
#   3DCityDB version  $CITYDBVERSION
#   DBUSER            $DBUSER
#   SRID              $SRID
#   SRSNAME           $GMLSRSNAME
#   HEIGHT_EPSG       $HEIGHT_EPSG
#
# Maintainer ------------------------------------------------------------------
#   Bruno Willenborg
#   Chair of Geoinformatics
#   Department of Aerospace and Geodesy
#   Technical University of Munich (TUM)
#   b.willenborg(at)tum.de
#
################################################################################

EOF
