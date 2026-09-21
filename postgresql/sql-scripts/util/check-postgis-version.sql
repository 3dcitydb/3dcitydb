-- check the PostGIS version
DO $$
DECLARE
  required_major_version CONSTANT int := @majorVersion@;
  required_minor_version CONSTANT int := @minorVersion@;
  required_revision CONSTANT int := @minorRevision@;

  version text;
  major_version int;
  minor_version int;
  minor_revision int;
BEGIN
  BEGIN
    version := postgis_lib_version();
  EXCEPTION
    WHEN OTHERS THEN
      RAISE EXCEPTION 'The PostGIS extension is not installed in the database.';
  END;

  major_version := split_part(version, '.', 1)::int;
  minor_version := split_part(version, '.', 2)::int;
  minor_revision := split_part(version, '.', 3)::int;

  IF major_version < required_major_version
     OR (major_version = required_major_version
         AND minor_version < required_minor_version)
     OR (major_version = required_major_version
         AND minor_version = required_minor_version
         AND minor_revision < required_revision) THEN
    RAISE EXCEPTION 'PostGIS version % is not supported. Version %.%.% or newer is required.',
      version, required_major_version, required_minor_version, required_revision;
  END IF;
END
$$;