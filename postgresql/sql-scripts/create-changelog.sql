SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SCHEMA_NAME :schema_name

\echo
\echo 'Setting up changelog extension ...'

SELECT srid from :SCHEMA_NAME.database_srs
\gset
\set SRID :srid

\ir changelog/changelog-table.sql
\ir changelog/feature-trigger.sql
\ir changelog/spatial-objects.sql

\echo
\echo 'Changelog extension successfully created.'