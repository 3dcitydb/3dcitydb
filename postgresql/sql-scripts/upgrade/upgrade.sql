-- check upgrade to 5.1.0
SELECT CASE
  WHEN :current_major = 5 AND :current_minor < 1 THEN 'upgrade-5.1.0.sql'
  ELSE '../util/do-nothing.sql'
END AS do_action
\gset
\ir :do_action

-- check upgrade to 5.1.1
SELECT CASE
  WHEN :current_major = 5 AND :current_minor <= 1 AND :current_revision < 1 THEN 'upgrade-5.1.1.sql'
  ELSE '../util/do-nothing.sql'
END AS do_action
\gset
\ir :do_action

\echo 'Upgrading schema "citydb_pkg" ...'

DO $$
DECLARE
  proname text;
BEGIN
  FOR proname IN
    SELECT oid::regprocedure
    FROM pg_proc
    WHERE pronamespace = 'citydb_pkg'::regnamespace
  LOOP
    EXECUTE format('DROP ROUTINE %s', proname);
  END LOOP;
END
$$;

\ir ../citydb-pkg/util.sql
\ir ../citydb-pkg/srs.sql
\ir ../citydb-pkg/envelope.sql
\ir ../citydb-pkg/delete.sql
\ir ../citydb-pkg/schema-mapping.sql

\echo
\echo '3DCityDB instance successfully upgraded.'