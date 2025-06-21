\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SCHEMA_NAME :schema_name

\echo 'Creating 3DCityDB schema "':SCHEMA_NAME'" ...'

-- create schema
CREATE SCHEMA :"SCHEMA_NAME";

-- set search_path for this session
SELECT current_setting('search_path') AS current_path
\gset
SET search_path TO :"SCHEMA_NAME", :current_path;

-- check if the PostGIS extension and the citydb_pkg schema are available
SELECT postgis_version();
SELECT version as citydb_version from citydb_pkg.citydb_version();

-- create tables, sequences, constraints, indexes
\echo
\echo 'Setting up database schema ...'
\ir schema/schema.sql

-- populate metadata tables
\ir schema/namespace-instances.sql
\ir schema/objectclass-instances.sql
\ir schema/datatype-instances.sql

-- populate codelist tables
\ir schema/codelist-instances.sql
\ir schema/codelist-entry-instances.sql

\echo
\echo 'Created 3DCityDB schema "':SCHEMA_NAME'".'

\echo 'Setting spatial reference system for schema "':SCHEMA_NAME'" (will be the same as for the "citydb" schema) ...'
SELECT citydb_pkg.change_schema_srid(database_srs.srid, database_srs.srs_name, :'SCHEMA_NAME', 0)
  FROM citydb.database_srs
  LIMIT 1;
\echo 'Done'