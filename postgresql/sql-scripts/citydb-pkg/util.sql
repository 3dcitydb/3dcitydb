/*****************************************************************
* citydb_version
*
* @return RECORD with columns
*   version - version of 3DCityDB as string
*   major_version - major version number of 3DCityDB instance
*   minor_version - minor version number of 3DCityDB instance
*   minor_revision - minor revision number of 3DCityDB instance
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.citydb_version( 
  OUT version TEXT, 
  OUT major_version INTEGER, 
  OUT minor_version INTEGER, 
  OUT minor_revision INTEGER) RETURNS RECORD AS
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
* @return RECORD with columns
*    srid, srs_name,
*    coord_ref_sys_name, coord_ref_sys_kind, wktext
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata(
  OUT srid INTEGER,
  OUT srs_name TEXT,
  OUT coord_ref_sys_name TEXT, 
  OUT coord_ref_sys_kind TEXT,
  OUT wktext TEXT) RETURNS RECORD AS
$body$
BEGIN
  SELECT
    d.srid, d.srs_name, crs.coord_ref_sys_name, crs.coord_ref_sys_kind, crs.wktext
  INTO
    srid, srs_name, coord_ref_sys_name, coord_ref_sys_kind, wktext
  FROM
    database_srs d,
    citydb_pkg.get_coord_ref_sys_info(d.srid) crs;
END;
$body$
LANGUAGE plpgsql STABLE;

/******************************************************************
* db_metadata
*
* @param schema_name Name of database schema
* @return RECORD with columns
*    srid, srs_name,
*    coord_ref_sys_name, coord_ref_sys_kind, wktext
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata(
  schema_name TEXT,
  OUT srid INTEGER,
  OUT srs_name TEXT,
  OUT coord_ref_sys_name TEXT,
  OUT coord_ref_sys_kind TEXT,
  OUT wktext TEXT) RETURNS RECORD AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);

  SELECT
    m.srid, m.srs_name, m.coord_ref_sys_name, m.coord_ref_sys_kind, m.wktext
  INTO
    srid, srs_name, coord_ref_sys_name, coord_ref_sys_kind, wktext
  FROM
    citydb_pkg.db_metadata() m;
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
* @param seq_name Name of the sequence including a schema prefix
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
* get_child_objectclass_ids
*
* @param class_id Identifier for object class
* @param skip_abstract Set to 1 if abstract classes shall be skipped, 0 if not
* @return The IDs of all transitive subclasses of the given object class
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_child_objectclass_ids(
  class_id INTEGER,
  skip_abstract INTEGER DEFAULT 0) RETURNS SETOF INTEGER AS
$body$
DECLARE
  where_clause TEXT := '';
BEGIN
  IF skip_abstract <> 0 THEN
    where_clause = 'WHERE h.is_abstract <> 1';
  END IF;
  
  RETURN QUERY EXECUTE format('
    WITH RECURSIVE class_hierarchy AS (
      SELECT
        o.id,
        o.is_abstract
      FROM
        objectclass o
      WHERE
        o.id = %L
      UNION ALL
      SELECT
        p.id,
        p.is_abstract
      FROM
        objectclass p
        INNER JOIN class_hierarchy h ON h.id = p.superclass_id
    )
    SELECT
      h.id
    FROM
      class_hierarchy h ' || where_clause,
	class_id);
END;
$body$
LANGUAGE plpgsql STABLE STRICT;

/*****************************************************************
* get_child_objectclass_ids
*
* @param class_id Identifier for object class
* @param schema_name Name of schema
* @param skip_abstract Set to 1 if abstract classes shall be skipped, 0 if not
* @return The IDs of all transitive subclasses of the given object class
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_child_objectclass_ids(
  class_id INTEGER,
  schema_name TEXT,
  skip_abstract INTEGER DEFAULT 0) RETURNS SETOF INTEGER AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);
  RETURN QUERY
    SELECT citydb_pkg.get_child_objectclass_ids(class_id, skip_abstract);
END;
$body$
LANGUAGE plpgsql STABLE STRICT;

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
LANGUAGE plpgsql STABLE STRICT;

/*****************************************************************
* schema_exists
*
* @param schema_name Name of 3DCityDB schema to verify
* @return The boolean result encoded as INTEGER: 1 = schema exists; 0 otherwise
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.schema_exists(schema_name TEXT) RETURNS INTEGER AS
$body$
SELECT COALESCE((
  SELECT 1
  FROM information_schema.schemata s
  JOIN information_schema.tables t ON t.table_schema = s.schema_name
  WHERE s.schema_name = $1
    AND t.table_name = 'database_srs'
  LIMIT 1
), 0)
$body$
LANGUAGE sql STABLE;