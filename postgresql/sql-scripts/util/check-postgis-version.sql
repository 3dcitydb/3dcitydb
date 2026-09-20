-- check the PostGIS version
DO $$
DECLARE
  version text;
  major_version int;
  minor_version int;
BEGIN
  BEGIN
    version := postgis_lib_version();
  EXCEPTION
    WHEN OTHERS THEN
      RAISE EXCEPTION 'The PostGIS extension is not installed in the database.';
  END;

  major_version := split_part(version, '.', 1)::int;
  minor_version := split_part(version, '.', 2)::int;

  IF major_version < 3
     OR (major_version = 3 AND minor_version < 3) THEN
    RAISE EXCEPTION 'PostGIS version % is not supported. Version 3.3 or newer is required.', version;
  END IF;
END
$$;