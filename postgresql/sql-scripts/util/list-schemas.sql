\t on

\echo 'List of existing 3DCityDB schemas:'
SELECT n.nspname AS schema_name 
  FROM pg_catalog.pg_class c 
  JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'database_srs'
	  AND c.relkind = 'r';

\t off