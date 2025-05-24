\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SCHEMA_NAME :schema_name

\echo 'Dropping 3DCityDB schema "':SCHEMA_NAME'" ...'

-- drop schemas
DROP SCHEMA :SCHEMA_NAME CASCADE;

\echo
\echo '3DCityDB schema "':SCHEMA_NAME'" successfully removed.'