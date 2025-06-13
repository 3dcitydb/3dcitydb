\t on

\echo 'List of 3DCityDB schemas (* means that the changelog extension has already been created):'
WITH schema_names as (
  SELECT n.nspname AS schema_name
  FROM pg_catalog.pg_class c
  JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'feature_changelog'
	  AND c.relkind = 'r'
)
SELECT
  CASE
    WHEN n.nspname IN (SELECT schema_name FROM schema_names) THEN
      CONCAT(n.nspname, ' (*)')
    ELSE
      n.nspname
    END AS schema_name
  FROM pg_catalog.pg_namespace n
	JOIN pg_catalog.pg_class c on n.oid = c.relnamespace
    WHERE c.relname = 'feature'
	  AND c.relkind = 'r'
	ORDER BY schema_name;

\t off