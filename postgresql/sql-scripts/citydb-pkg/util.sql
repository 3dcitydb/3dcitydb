/*****************************************************************
* citydb_version
*
* @return TABLE with columns
*   version - version of 3DCityDB as string
*   major_version - major version number of 3DCityDB instance
*   minor_version - minor version number of 3DCityDB instance
*   minor_revision - minor revision number of 3DCityDB instance
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.citydb_version()
  RETURNS TABLE(
    version TEXT,
    major_version INTEGER,
    minor_version INTEGER,
    minor_revision INTEGER) AS
$body$
SELECT 
  '@versionString@'::text AS version,
  @majorVersion@::int AS major_version,
  @minorVersion@::int AS minor_version,
  @minorRevision@::int AS minor_revision;
$body$
LANGUAGE sql IMMUTABLE;

/******************************************************************
* db_metadata
*
* @return TABLE with columns
*   srid, srs_name,
*   coord_ref_sys_name, coord_ref_sys_kind, wktext
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata()
  RETURNS TABLE(
    srid INTEGER,
    srs_name TEXT,
    coord_ref_sys_name TEXT,
    coord_ref_sys_kind TEXT,
    wktext TEXT) AS
$body$
BEGIN
  RETURN QUERY
    SELECT
      d.srid, d.srs_name, crs.coord_ref_sys_name, crs.coord_ref_sys_kind, crs.wktext
    FROM
      database_srs d
    JOIN LATERAL
      citydb_pkg.get_coord_ref_sys_info(d.srid) crs ON true
    LIMIT 1;
END;
$body$
LANGUAGE plpgsql STABLE;

/******************************************************************
* db_metadata
*
* @param schema_name Name of database schema
* @return TABLE with columns
*   srid, srs_name,
*   coord_ref_sys_name, coord_ref_sys_kind, wktext
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata(schema_name TEXT)
  RETURNS TABLE(
    srid INTEGER,
    srs_name TEXT,
    coord_ref_sys_name TEXT,
    coord_ref_sys_kind TEXT,
    wktext TEXT) AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);
  RETURN QUERY SELECT * FROM citydb_pkg.db_metadata();
END;
$body$
LANGUAGE plpgsql STABLE;

/*****************************************************************
* db_properties
*
* @return A table listing database properties relevant for the 3DCityDB
*   - id: Unique identifier
*   - name: Name of the property
*   - value: Value of the property
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_properties()
  RETURNS TABLE(id TEXT, name TEXT, value TEXT) AS
$body$
DECLARE
  postgis_version TEXT;
  sfcgal_version TEXT;
BEGIN
  BEGIN
    SELECT postgis_lib_version() INTO postgis_version;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  BEGIN
    SELECT postgis_sfcgal_version() INTO sfcgal_version;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  RETURN QUERY SELECT 'postgis', 'PostGIS', postgis_version;
  RETURN QUERY SELECT 'postgis_sfcgal', 'SFCGAL', sfcgal_version;
END;
$body$
LANGUAGE plpgsql STABLE;

/*****************************************************************
* get_seq_values
*
* @param seq_name Name of the sequence possibly including a schema prefix
* @param count Number of values to be queried from the sequence
* @return List of sequence values from given sequence
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_seq_values(
  seq_name TEXT,
  seq_count BIGINT) RETURNS SETOF BIGINT AS
$body$
SELECT nextval($1)::bigint FROM generate_series(1, $2);
$body$
LANGUAGE sql STRICT;

/*****************************************************************
* get_seq_values
*
* @param seq_name Name of the sequence
* @param count Number of values to be queried from the sequence
* @param schema_name Name of database schema
* @return List of sequence values from given sequence
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_seq_values(
  seq_name TEXT,
  seq_count BIGINT,
  schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
SELECT nextval(format('%I.%I', $3, $1)::regclass)::bigint FROM generate_series(1, $2);
$body$
LANGUAGE sql STRICT;

/*****************************************************************
* get_current_schema
*
* @return The current 3DCityDB schema based on the search_path
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_current_schema() RETURNS text AS
$body$
DECLARE
  table_oid oid;
  schema_name text;
BEGIN
  table_oid := to_regclass('database_srs');

  IF table_oid IS NULL THEN
    RAISE EXCEPTION 'No 3DCityDB schema found in the current search_path %.', current_setting('search_path');
  END IF;

  SELECT n.nspname INTO schema_name
  FROM pg_class c
  JOIN pg_namespace n ON c.relnamespace = n.oid
  WHERE c.oid = table_oid;

  RETURN schema_name;
END;
$body$
LANGUAGE plpgsql STABLE;

/*****************************************************************
* set_current_schema
*
* @param schema_name Name of schema to set as the current 3DCityDB schema
* @param local Scope of the change: true = transaction-local (default), false = session-wide
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.set_current_schema(
  schema_name TEXT,
  local BOOLEAN DEFAULT true) RETURNS SETOF VOID AS
$body$
BEGIN
  PERFORM set_config('search_path', format('%I, citydb_pkg, public', schema_name), local);
END;
$body$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* schema_exists
*
* @param schema_name Name of 3DCityDB schema to verify
* @return The boolean result encoded as INTEGER: 1 = schema exists; 0 otherwise
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.schema_exists(schema_name TEXT) RETURNS INTEGER AS
$body$
SELECT CASE WHEN EXISTS (
  SELECT 1
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = $1
    AND c.relname = 'database_srs'
    AND c.relkind = 'r'
  LIMIT 1
) THEN 1 ELSE 0 END;
$body$
LANGUAGE sql STABLE;

/******************************************************************
* normalize_polyhedral
*
* @param geom The geometry to process
* @return A geometry collection of polygons if input is a polyhedral surfaces,
*   otherwise the original geometry
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.normalize_polyhedral(geom GEOMETRY) RETURNS GEOMETRY AS
$body$
SELECT CASE
  WHEN ST_GeometryType($1) = 'ST_PolyhedralSurface' THEN ST_ForceCollection($1)
  ELSE $1
END;
$body$
LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE;