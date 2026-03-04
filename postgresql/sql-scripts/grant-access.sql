\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set USERNAME :username
\set SCHEMA_NAME :schema_name
\set ACCESS_MODE :access_mode

SELECT CASE
  WHEN upper(:'ACCESS_MODE') = 'RW' THEN 'read-write'
  WHEN upper(:'ACCESS_MODE') = 'RU' THEN 'read-update'
  ELSE 'read-only'
END AS privileges_type
\gset

\echo
\echo 'Granting ':privileges_type' privileges on schema "':SCHEMA_NAME'" to user "':USERNAME'" ...'

SET tmp.dbname TO :"DBNAME";
SET tmp.username TO :"USERNAME";
SET tmp.schema_name TO :"SCHEMA_NAME";
SET tmp.access_mode TO :"ACCESS_MODE";

DO $$
DECLARE privileges_type text;
        aux_privileges_type text;
BEGIN
  IF upper(current_setting('tmp.access_mode')) = 'RW' THEN
    privileges_type := 'ALL';
    aux_privileges_type := 'ALL';
  ELSIF upper(current_setting('tmp.access_mode')) = 'RU' THEN
    privileges_type := 'SELECT, INSERT, UPDATE';
    aux_privileges_type := 'SELECT';
  ELSE
    privileges_type := 'SELECT';
    aux_privileges_type := 'SELECT';
  END IF;

  EXECUTE format('GRANT CONNECT, TEMP ON DATABASE %I TO %I', current_setting('tmp.dbname'), current_setting('tmp.username'));
  EXECUTE format('GRANT USAGE, CREATE ON SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  EXECUTE format('GRANT '||privileges_type||' ON ALL TABLES IN SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  EXECUTE format('GRANT USAGE ON SCHEMA citydb_pkg TO %I', current_setting('tmp.username'));
  EXECUTE format('GRANT '||aux_privileges_type||' ON ALL TABLES IN SCHEMA citydb_pkg TO %I', current_setting('tmp.username'));
  EXECUTE format('GRANT USAGE ON SCHEMA public TO %I', current_setting('tmp.username'));
  EXECUTE format('GRANT '||aux_privileges_type||' ON ALL TABLES IN SCHEMA public TO %I', current_setting('tmp.username'));

  IF upper(current_setting('tmp.access_mode')) = 'RW' THEN
    EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  ELSIF upper(current_setting('tmp.access_mode')) = 'RU' THEN
    EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  END IF;
END
$$;

\echo
\echo 'Successfully granted ':privileges_type' privileges.'