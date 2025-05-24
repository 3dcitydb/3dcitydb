-- upgrade citydb_pkg schema
\echo 'Upgrading schema ''citydb_pkg'' ...'

DO $$
DECLARE proname text;
BEGIN
FOR proname IN SELECT oid::regprocedure AS proc_name
               FROM pg_proc
               WHERE pronamespace = 'citydb_pkg'::regnamespace
  LOOP
    EXECUTE format('DROP ROUTINE citydb_pkg.%s', proname);
  END LOOP;
END
$$;

\ir ../citydb-pkg/util.sql
\ir ../citydb-pkg/srs.sql
\ir ../citydb-pkg/envelope.sql
\ir ../citydb-pkg/delete.sql

\echo
\echo '3DCityDB instance successfully upgraded.'