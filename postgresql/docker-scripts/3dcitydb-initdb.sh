#!/usr/bin/env bash
# 3DCityDB setup --------------------------------------------------------------

# Print commands and their arguments as they are executed
set -e;

# psql should stop on error
psql=( psql -v ON_ERROR_STOP=1 )

# SRID ------------------------------------------------------------------------
regex_numeric='^[0-9]+$'
if [ -z ${SRID+x} ]; then
  # No SRID set -> give instructions on how to create a DB and do nothing
  echo
  echo "SRID is not set. No 3DCityDB instance will be created in database '$POSTGRES_DB'."
  exit
else
  # SRID given, check if valid
  if [[ ! $SRID =~ $regex_numeric ]] || [ $SRID -le 0 ]; then
        echo
        echo 'Illegal input! Enter a positive integer for the SRID.'
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
    echo "!!! WARNING: SRS_NAME is set. HEIGHT_EPSG will be ignored."
  fi
fi

# CHANGELOG -------------------------------------------------------------------
if [ -z ${CHANGELOG+x} ]; then
  CHANGELOG="no"
else
  CHANGELOG="$CHANGELOG"
fi

# Add PostGIS raster extension ------------------------------------------------
# Get major version from POSTGIS_VERSION, POSTGIS_MAJOR may return string
postgis_major=$( echo $POSTGIS_VERSION | cut -f1 -d '.' )
if [ $postgis_major -gt 2 ]; then
  echo
  echo "Create PostGIS raster extensions in database '$POSTGRES_DB' ..."

  "${psql[@]}" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS postgis_raster;"

  echo "Create PostGIS raster extensions in database '$POSTGRES_DB' ...done!"
fi

# Add PostGIS SFCGAL extension ------------------------------------------------
if [ ! -z ${POSTGIS_SFCGAL+x} ] && [ ${POSTGIS_SFCGAL} = true ] || [ "${POSTGIS_SFCGAL}" = "yes" ] ; then

  echo "Create PostGIS SFCGAL extensions in database '$POSTGRES_DB' ..."

  "${psql[@]}" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS postgis_sfcgal;"

  echo "Create PostGIS SFCGAL extensions in database '$POSTGRES_DB' ...done!"
  SFCGAL=true
else
  SFCGAL=false
fi

# Setup 3DCityDB schema -------------------------------------------------------
echo
echo "Setting up 3DCityDB database schema in database '$POSTGRES_DB' ..."

"${psql[@]}" -d "$POSTGRES_DB" -f "create-db.sql" \
  -v srid="$SRID" -v srs_name="$SRS_NAME" -v changelog="$CHANGELOG" > /dev/null

echo "Setting up 3DCityDB database schema in database '$POSTGRES_DB' ...done!"

# Echo info -------------------------------------------------------------------
cat <<EOF

# 3DCityDB Docker PostGIS ######################################################
#
# PostgreSQL/PostGIS -----------------------------------------------------------
#   PostgreSQL version  $PG_MAJOR - $PG_VERSION
#   PostGIS version     $POSTGIS_VERSION
#
# 3DCityDB ---------------------------------------------------------------------
#   https://github.com/3dcitydb/3dcitydb
#
#   3DCityDB version      $CITYDBVERSION
#   DBNAME                $POSTGRES_DB
#   SRID                  $SRID
#   SRSNAME               $SRS_NAME
#   HEIGHT_EPSG           $HEIGHT_EPSG
#   SFCGAL enabled        $SFCGAL
#   CHANGELOG enabled     $CHANGELOG
#
# Maintainer -------------------------------------------------------------------
#   Bruno Willenborg
#   Chair of Geoinformatics
#   Department of Aerospace and Geodesy
#   Technical University of Munich (TUM)
#   b.willenborg(at)tum.de
#
################################################################################

EOF
