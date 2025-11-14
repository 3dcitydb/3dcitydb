\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SCHEMA_NAME :schema_name

\echo
\echo 'Creating 3DCityDB schema "':SCHEMA_NAME'" ...'

-- create schema
CREATE SCHEMA :"SCHEMA_NAME";

-- set search_path for this session
SELECT current_setting('search_path') AS current_path
\gset
SET search_path TO :"SCHEMA_NAME", :current_path;

-- check if the PostGIS extension is available
SELECT postgis_lib_version() AS postgis_version
\gset

-- get srid and srs_name from citydb schema
\echo
\echo 'Using spatial reference system from the "citydb" schema ...'
SELECT srid, srs_name from citydb.database_srs
\gset
\set SRID :srid
\set SRS_NAME :srs_name

-- create tables, sequences, constraints, indexes
\echo
\echo 'Setting up database schema ...'
\ir schema/schema.sql
\ir schema/spatial-objects.sql

-- populate metadata tables
\ir schema/namespace-instances.sql
\ir schema/objectclass-instances.sql
\ir schema/datatype-instances.sql

-- populate codelist tables
\ir schema/codelist-instances.sql
\ir schema/codelist-entry-instances.sql

\echo
\echo '3DCityDB schema "':SCHEMA_NAME'" successfully created.'