SET client_min_messages TO NOTICE;

SET tmp.current_major TO :current_major;
SET tmp.current_minor TO :current_minor;
SET tmp.current_revision TO :current_revision;

DO $$
DECLARE
schema_name text;
  current_major integer := current_setting('tmp.current_major')::integer;
  current_minor integer := current_setting('tmp.current_minor')::integer;
  current_revision integer := current_setting('tmp.current_revision')::integer;
BEGIN
  FOR schema_name IN
    SELECT nspname FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'feature' AND c.relkind = 'r'
  LOOP
    EXECUTE format('set search_path to %I, citydb_pkg, public', schema_name);

    IF current_major = 5 AND current_minor = 0 THEN
      RAISE NOTICE E'Re-creating foreign key ''property_val_feature_fk'' with ON DELETE SET NULL in schema ''%'' ...\n', schema_name;
      ALTER TABLE property DROP CONSTRAINT property_val_feature_fk;
      ALTER TABLE property ADD CONSTRAINT property_val_feature_fk FOREIGN KEY ( val_feature_id ) REFERENCES feature( id ) ON DELETE SET NULL;
    END IF;
  END LOOP;
END
$$;