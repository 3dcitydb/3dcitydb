SET client_min_messages TO NOTICE;

SET tmp.current_major TO :current_major;
SET tmp.current_minor TO :current_minor;
SET tmp.current_revision TO :current_revision;

-- upgrade 3DCityDB schemas
\echo 'Upgrading 3DCityDB schemas ...'
\echo

DO $$
DECLARE
  schema_name text;
  current_major integer := current_setting('tmp.current_major')::integer;
  current_minor integer := current_setting('tmp.current_minor')::integer;
  current_revision integer := current_setting('tmp.current_revision')::integer;
BEGIN
  FOR schema_name IN SELECT nspname AS schema_name FROM pg_catalog.pg_class c
                     JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                     WHERE c.relname = 'feature' AND c.relkind = 'r'
  LOOP
    IF current_major = 5 AND current_minor = 0 THEN
      RAISE NOTICE E'Re-creating foreign key ''property_val_feature_fk'' with ON DELETE SET NULL in schema ''%'' ...\n', schema_name;
      ALTER TABLE property DROP CONSTRAINT property_val_feature_fk;
      ALTER TABLE property ADD CONSTRAINT property_val_feature_fk FOREIGN KEY ( val_feature_id ) REFERENCES feature( id ) ON DELETE SET NULL;
    END IF;
  END LOOP;
END
$$;

-- upgrade citydb_pkg schema
\echo 'Upgrading schema ''citydb_pkg'' ...'

DO $$
DECLARE
  proname text;
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