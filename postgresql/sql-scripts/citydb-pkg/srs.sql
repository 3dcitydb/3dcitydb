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
  idx_param TEXT;
  geometry_type TEXT;
BEGIN
  schema_name := citydb_pkg.get_current_schema();

  -- check if a spatial index is defined for the column
  SELECT 
    pgc_i.relname,
    pgoc.opcname
  INTO
    idx_name,
    idx_param
  FROM pg_class pgc_t
  JOIN pg_index pgi ON pgi.indrelid = pgc_t.oid  
  JOIN pg_class pgc_i ON pgc_i.oid = pgi.indexrelid
  JOIN pg_opclass pgoc ON pgoc.oid = pgi.indclass[0]
  JOIN pg_am pgam ON pgam.oid = pgc_i.relam
  JOIN pg_attribute pga ON pga.attrelid = pgc_i.oid
  JOIN pg_namespace pgns ON pgns.oid = pgc_i.relnamespace
  WHERE pgns.nspname = schema_name
    AND pgc_t.relname = $1
    AND pga.attname = $2
    AND pgam.amname = 'gist';

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
    EXECUTE format(
      'CREATE INDEX %I ON %I.%I USING GIST (%I %I)',
      idx_name, schema_name, $1, $2, idx_param
    );
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
SELECT COALESCE((
  SELECT 1 FROM spatial_ref_sys WHERE srid = $1
), 0);
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
BEGIN
  RETURN ST_Transform($1, $2);
END;
$body$
LANGUAGE plpgsql STABLE STRICT;