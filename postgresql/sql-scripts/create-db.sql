\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SRID :srid
\set SRS_NAME :srs_name
\set CHANGELOG :changelog

-- check if the PostGIS extension is available
SELECT postgis_lib_version() AS postgis_version;
\gset

-- check if the provided SRID is supported
\echo
\echo 'Checking spatial reference system ...'
SET tmp.srid to :"srid";
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM spatial_ref_sys WHERE srid = current_setting('tmp.srid')::int) THEN
    RAISE EXCEPTION 'The SRID % is not supported. To add it manually, see CRS definitions at https://spatialreference.org/.', current_setting('tmp.srid');
  END IF;
END
$$;

-- create schema
CREATE SCHEMA citydb;

-- set search_path for this session
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO citydb, :current_path;

-- create tables, sequences, constraints, indexes
\echo
\echo 'Setting up database schema of 3DCityDB instance ...'
\ir schema/schema.sql

-- populate metadata tables
\ir schema/namespace-instances.sql
\ir schema/objectclass-instances.sql
\ir schema/datatype-instances.sql

-- populate codelist tables
\ir schema/codelist-instances.sql
\ir schema/codelist-entry-instances.sql

-- create citydb_pkg schema
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
CREATE SCHEMA citydb_pkg;

\ir citydb-pkg/util.sql
\ir citydb-pkg/srs.sql
\ir citydb-pkg/envelope.sql
\ir citydb-pkg/delete.sql

-- update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb, citydb_pkg, :current_path;

-- create changelog extension
\echo
SELECT 'citydb' AS schema_name;
\gset

SELECT CASE
  WHEN upper(:'CHANGELOG') = 'YES' THEN 'create-changelog.sql'
  ELSE 'util/do-nothing.sql'
END AS create_changelog_extension;
\gset
\ir :create_changelog_extension;

\echo 'Setting spatial reference system of 3DCityDB instance ...'
SELECT citydb_pkg.change_schema_srid(:SRID,:'SRS_NAME');

\echo '3DCityDB instance successfully created.'