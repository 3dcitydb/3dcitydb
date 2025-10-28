/*****************************************************************
* change_column_srid
*
* @param table_name Name of table
* @param column_name Name of spatial column
* @param dim Dimension of geometry
* @param target_srid The SRID of the coordinate system to be used for the spatial column
* @param transform Set to 1 if existing data shall be transformed, 0 if not
* @param geom_type The geometry type of the given spatial column
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_column_srid(
  table_name TEXT,
  column_name TEXT,
  dim INTEGER,
  target_srid INTEGER,
  transform INTEGER DEFAULT 0,
  geom_type TEXT DEFAULT 'GEOMETRY') RETURNS SETOF VOID AS
$body$
DECLARE
  schema_name TEXT;
  idx_name TEXT;
  idx_def TEXT;
  geometry_type TEXT;
BEGIN
  schema_name := citydb_pkg.get_current_schema();

  -- check if a spatial index is defined for the column
  SELECT
    i.relname,
    pg_get_indexdef(i.oid)
  INTO
    idx_name,
    idx_def
  FROM pg_index idx
  JOIN pg_class t ON t.oid = idx.indrelid
  JOIN pg_namespace n ON n.oid = t.relnamespace
  JOIN pg_class i ON i.oid = idx.indexrelid
  JOIN pg_am am ON am.oid = i.relam
  JOIN pg_attribute a ON a.attrelid = t.oid AND a.attname = $2
  WHERE n.nspname = schema_name
    AND t.relname = $1
    AND idx.indnatts = 1
    AND a.attnum = ANY(idx.indkey)
    AND am.amname = 'gist'
    AND idx.indisvalid
  LIMIT 1;

  IF idx_name IS NOT NULL THEN
    EXECUTE format('DROP INDEX %I.%I', schema_name, idx_name);
  END IF;

  IF transform <> 0 THEN
    -- construct correct geometry type
    IF dim = 3 AND right($6, 1) <> 'M' THEN
      geometry_type := $6 || 'Z';
    ELSIF dim = 4 THEN
      geometry_type := $6 || 'ZM';
    ELSE
      geometry_type := $6;
    END IF;

    -- coordinates of existent geometries will be transformed
    EXECUTE format(
      'ALTER TABLE %I.%I ALTER COLUMN %I TYPE geometry(%I,%L) USING ST_Transform(%I,%L::int)',
      schema_name, $1, $2, geometry_type, $4, $2, $4
    );
  ELSE
    -- only update metadata
    PERFORM UpdateGeometrySRID(schema_name, $1, $2, $4);
  END IF;

  IF idx_name IS NOT NULL THEN
    -- recreate spatial index
    EXECUTE idx_def;
  END IF;
END;
$body$
LANGUAGE plpgsql;

/*****************************************************************
* change_column_srid
*
* @param table_name Name of table
* @param column_name Name of spatial column
* @param dim Dimension of geometry
* @param target_srid The SRID of the coordinate system to be used for the spatial column
* @param schema_name Name of schema
* @param transform Set to 1 if existing data shall be transformed, 0 if not
* @param geom_type The geometry type of the given spatial column
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_column_srid(
  table_name TEXT,
  column_name TEXT,
  dim INTEGER,
  target_srid INTEGER,
  schema_name TEXT,
  transform INTEGER DEFAULT 0,
  geom_type TEXT DEFAULT 'GEOMETRY') RETURNS SETOF VOID AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);
  PERFORM citydb_pkg.change_column_srid(table_name, column_name, dim, target_srid, transform, geom_type);
END;
$body$
LANGUAGE plpgsql;

/*******************************************************************
* change_schema_srid
*
* @param target_srid The SRID of the coordinate system to be further used in the database
* @param target_srs_name The SRS_NAME of the coordinate system to be further used in the database
* @param transform Set to 1 if existing data shall be transformed, 0 if not
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_schema_srid(
  target_srid INTEGER,
  target_srs_name TEXT,
  transform INTEGER DEFAULT 0) RETURNS SETOF VOID AS
$body$
BEGIN
  -- update entry in database_srs table
  DELETE FROM database_srs;
  INSERT INTO database_srs (srid, srs_name) VALUES ($1, $2);

  -- change SRID of spatial columns
  PERFORM citydb_pkg.change_column_srid(f_table_name, f_geometry_column, coord_dimension, $1, $3, type)
  FROM geometry_columns
  WHERE f_table_schema = citydb_pkg.get_current_schema()
    AND f_geometry_column <> 'implicit_geometry';
END;
$body$
LANGUAGE plpgsql;

/*******************************************************************
* change_schema_srid
*
* @param target_srid The SRID of the coordinate system to be further used in the database
* @param target_srs_name The SRS_NAME of the coordinate system to be further used in the database
* @param schema_name Name of schema
* @param transform Set to 1 if existing data shall be transformed, 0 if not
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_schema_srid(
  target_srid INTEGER,
  target_srs_name TEXT,
  schema_name TEXT,
  transform INTEGER DEFAULT 0) RETURNS SETOF VOID AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);
  PERFORM citydb_pkg.change_schema_srid(target_srid, target_srs_name, transform);
END;
$body$
LANGUAGE plpgsql;

/******************************************************************
* get_coord_ref_sys_info
*
* @param srid The SRID to retrieve the CRS information for
* @return RECORD with columns
*    coord_ref_sys_name, coord_ref_sys_kind, wktext
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_coord_ref_sys_info(
  srid INTEGER,
  OUT coord_ref_sys_name TEXT,
  OUT coord_ref_sys_kind TEXT,
  OUT wktext TEXT) RETURNS RECORD AS
$body$
SELECT
  split_part(s.srtext, '"', 2) as coord_ref_sys_name,
  split_part(s.srtext, '[', 1) as coord_ref_sys_kind,
  s.srtext as wktext
FROM
  spatial_ref_sys s
WHERE
  s.srid = $1;
$body$
LANGUAGE sql STRICT;

/******************************************************************
* is_coord_ref_sys_3d
*
* @param srid The SRID of the coordinate system to be checked
* @param schema_name Name of schema
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_coord_ref_sys_3d(srid INTEGER) RETURNS INTEGER AS
$body$
SELECT COALESCE((
  SELECT 1 FROM spatial_ref_sys WHERE srid = $1 AND lower(srtext) SIMILAR TO '%\Wup\W%'
), 0);
$body$
LANGUAGE sql STABLE;

/******************************************************************
* is_db_coord_ref_sys_3d
*
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_db_coord_ref_sys_3d() RETURNS INTEGER AS
$body$
SELECT citydb_pkg.is_coord_ref_sys_3d(srid) FROM database_srs;
$body$
LANGUAGE sql STABLE;

/******************************************************************
* is_db_coord_ref_sys_3d
*
* @param schema_name Name of schema
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_db_coord_ref_sys_3d(schema_name TEXT) RETURNS INTEGER AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);
  RETURN citydb_pkg.is_db_coord_ref_sys_3d();
END;
$body$
LANGUAGE plpgsql STABLE;

/*******************************************************************
* check_srid
*
* @param srid The SRID to be checked
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.check_srid(srid INTEGER) RETURNS INTEGER AS
$body$
SELECT CASE WHEN EXISTS (
  SELECT 1 FROM spatial_ref_sys WHERE srid = $1
) THEN 1 ELSE 0 END;
$body$
LANGUAGE sql STABLE;

/******************************************************************
* transform_or_null
*
* @param geom The geometry to transform to another coordinate system
* @param srid The SRID of the coordinate system to be used for the transformation.
* @return The transformed geometry representation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.transform_or_null(
  geom GEOMETRY,
  srid INTEGER) RETURNS GEOMETRY AS
$body$
SELECT ST_Transform($1, $2);
$body$
LANGUAGE sql STABLE STRICT;