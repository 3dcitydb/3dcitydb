SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

-- drop 3DCityDB schemas
\echo
\echo 'Dropping 3DCityDB schemas ...'
DROP SCHEMA IF EXISTS citydb_pkg CASCADE;

DO $$
DECLARE schema_name text;
BEGIN
  FOR schema_name IN
    SELECT nspname FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'database_srs' AND c.relkind = 'r'
  LOOP
    EXECUTE format('DROP SCHEMA %I CASCADE', schema_name);
  END LOOP;
END
$$;

-- update search_path
ALTER DATABASE :"DBNAME" RESET search_path;

\echo
\echo '3DCityDB instance successfully removed.'