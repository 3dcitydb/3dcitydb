#!/usr/bin/env bash
# 3DCityDB setup --------------------------------------------------------------

# Print commands and their arguments as they are executed
set -e;

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
  # HEIGT EPSG ----------------------------------------------------------------
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

# DBVERSION -------------------------------------------------------------------
if [ -z ${DBVERSION+x} ]; then
  DBVERSION="s"
else
  DBVERSION="$DBVERSION"
fi

# DBUSER
if [ -z ${DBUSER+x} ]; then
  DBUSER="citydb"
else
  DBUSER="$DBUSER"
fi

# DBPASSWORD
if [ -z ${DBPASSWORD+x} ]; then
  DBPASSWORD="$DBUSER"
else
  DBPASSWORD="$DBPASSWORD"
fi

# Create user -----------------------------------------------------------------
echo
echo "Creating user $DBUSER ..."
echo "CREATE USER $DBUSER identified by $DBPASSWORD;
      GRANT CONNECT, RESOURCE to $DBUSER;
      GRANT CREATE TABLE to $DBUSER;
      GRANT CREATE SEQUENCE to $DBUSER;
      GRANT UNLIMITED TABLESPACE to $DBUSER;" | sqlplus sys/oracle@localhost:1521/xe.oracle.docker as sysdba
echo "Creating user $DBUSER ... done!"
echo

# Setup 3DCityDB schema -------------------------------------------------------
echo "Setting up 3DCityDB schema in $DBUSER ..."
sqlplus -S -L "$DBUSER"/"$DBPASSWORD"@localhost:1521/xe.oracle.docker @CREATE_DB.sql "${SRID}" "${GMLSRSNAME}" "${VERSIONING}" "${DBVERSION}"
echo "Setting up 3DCityDB schema in $DBUSER ...done!"
echo
echo "# Setting up 3DCityDB ... done! ################################################"

# Echo info -------------------------------------------------------------------
cat <<EOF


# 3DCityDB Docker Oracle ######################################################
#
# Oracle Version --------------------------------------------------------------
#   12c Standard Edition Release 12.1.0.2.0 - 64bit Production
#
# 3DCityDB --------------------------------------------------------------------
#   3DCityDB version  !!! TBD !!!
#     version info    !!! TBD !!!
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
