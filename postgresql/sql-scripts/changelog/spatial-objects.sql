SET tmp.schema_name to :"SCHEMA_NAME";
SET tmp.srid to :"SRID";

DO $$
DECLARE
  schema_name TEXT := current_setting('tmp.schema_name');
  srid INTEGER := current_setting('tmp.srid')::int;
BEGIN
  PERFORM UpdateGeometrySRID(schema_name, 'feature_changelog', 'envelope', srid);
END
$$;

CREATE INDEX feature_changelog_envelope_spx ON :SCHEMA_NAME.feature_changelog USING GiST ( envelope );