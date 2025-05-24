\set USERNAME :username
\set USERNAME_QUOTED '\'':username'\''
\t on

\echo 'List of 3DCityDB schemas with usage privilege for "':USERNAME'":'
WITH schema_names AS (
  SELECT n.nspname AS schema_name
    FROM pg_catalog.pg_namespace n
	JOIN pg_catalog.pg_class c on n.oid = c.relnamespace
      WHERE c.relname = 'database_srs'
	    AND c.relkind = 'r'
) SELECT schema_name
    FROM schema_names
	  WHERE pg_catalog.has_schema_privilege(:USERNAME_QUOTED, schema_name, 'USAGE');
	  
\t off