SET tmp.schema_name to :"SCHEMA_NAME";
SET tmp.srid to :"SRID";

DO $$
DECLARE
  schema_name TEXT := current_setting('tmp.schema_name');
  srid INTEGER := current_setting('tmp.srid')::int;
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT f_table_name as table_name,
      f_geometry_column as column_name
    FROM geometry_columns
    WHERE f_table_schema = schema_name
  LOOP
    IF rec.table_name <> 'geometry_data' OR rec.column_name <> 'implicit_geometry' THEN
      PERFORM UpdateGeometrySRID(schema_name, rec.table_name::text, rec.column_name::text, srid);
    END IF;
  END LOOP;
END
$$;

CREATE INDEX feature_envelope_spx ON feature USING GiST ( envelope );

CREATE INDEX geometry_data_spx ON geometry_data USING GiST ( geometry );

DELETE FROM database_srs;

INSERT INTO database_srs (srid, srs_name) VALUES (:SRID, :'SRS_NAME');