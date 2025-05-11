/*****************************************************************
* change_column_srid
*
* @param table_name Name of table
* @param column_name Name of spatial column
* @param dim Dimension of geometry
* @param target_srid The SRID of the coordinate system to be further used in the database
* @param transform Set to 1 if existing data shall be transformed, 0 if not
* @param geom_type The geometry type of the given spatial column
* @param schema_name Name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_column_srid(
  table_name TEXT,
  column_name TEXT,
  dim INTEGER,
  target_srid INTEGER,
  transform INTEGER DEFAULT 0,
  geom_type TEXT DEFAULT 'GEOMETRY',
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  idx_name TEXT;
  opclass_param TEXT;
  geometry_type TEXT;
BEGIN
  -- check if a spatial index is defined for the column
  SELECT 
    pgc_i.relname,
    pgoc.opcname
  INTO
    idx_name,
    opclass_param
  FROM pg_class pgc_t
  JOIN pg_index pgi ON pgi.indrelid = pgc_t.oid  
  JOIN pg_class pgc_i ON pgc_i.oid = pgi.indexrelid
  JOIN pg_opclass pgoc ON pgoc.oid = pgi.indclass[0]
  JOIN pg_am pgam ON pgam.oid = pgc_i.relam
  JOIN pg_attribute pga ON pga.attrelid = pgc_i.oid
  JOIN pg_namespace pgns ON pgns.oid = pgc_i.relnamespace
  WHERE lower(pgns.nspname) = lower($7)
    AND lower(pgc_t.relname) = lower($1)
    AND lower(pga.attname) = lower($2)
    AND pgam.amname = 'gist';

  IF idx_name IS NOT NULL THEN
    -- drop spatial index if exists
    EXECUTE format('DROP INDEX %I.%I', $7, idx_name);
  END IF;

  IF transform <> 0 THEN
    -- construct correct geometry type
    IF dim = 3 AND substr($6, length($6), 1) <> 'M' THEN
      geometry_type := $6 || 'Z';
    ELSIF dim = 4 THEN
      geometry_type := $6 || 'ZM';
    ELSE
      geometry_type := $6;
    END IF;

    -- coordinates of existent geometries will be transformed
    EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE geometry(%I,%L) USING ST_Transform(%I,%L::int)',
                     $7, $1, $2, geometry_type, $4, $2, $4);
  ELSE
    -- only metadata of geometry columns is updated, coordinates keep unchanged
    PERFORM UpdateGeometrySRID($7, $1, $2, $4);
  END IF;

  IF idx_name IS NOT NULL THEN
    -- recreate spatial index again
    EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I %I)', idx_name, $7, $1, $2, opclass_param);
  END IF;
END;
$$
LANGUAGE plpgsql STRICT;

/*******************************************************************
* change_schema_srid
*
* @param target_srid TheSRID of the coordinate system to be further used in the database
* @param target_srs_name The SRS_NAME of the coordinate system to be further used in the database
* @param transform Set to 1 if existing data shall be transformed, 0 if not
* @param schema_name Name of schema
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_schema_srid(
  target_srid INTEGER,
  target_srs_name TEXT,
  transform INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  db_srid INTEGER;
BEGIN
  -- update entry in database_srs table first
  EXECUTE format('SELECT srid FROM %I.database_srs', $4) INTO db_srid;
  EXECUTE format('TRUNCATE TABLE %I.database_srs', $4);
  EXECUTE format('INSERT INTO %I.database_srs (srid, srs_name) VALUES (%L, %L)', $4, $1, $2);

  -- change srid of spatial columns in given schema
  PERFORM citydb_pkg.change_column_srid(f_table_name, f_geometry_column, coord_dimension, $1, $3, type, f_table_schema)
    FROM geometry_columns
    WHERE lower(f_table_schema) = lower($4)
      AND srid = db_srid;
END;
$$
LANGUAGE plpgsql STRICT;

/******************************************************************
* is_coord_ref_sys_3d
*
* @param srid The SRID of the coordinate system to be checked
* @param schema_name Name of schema
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_coord_ref_sys_3d(srid INTEGER) RETURNS INTEGER AS
$$
SELECT COALESCE((
  SELECT 1 FROM spatial_ref_sys WHERE auth_srid = $1 AND lower(srtext) SIMILAR TO '%\Wup\W%'
  ), 0);
$$
LANGUAGE sql STABLE;

/******************************************************************
* is_db_coord_ref_sys_3d
*
* @param schema_name Name of schema
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_db_coord_ref_sys_3d(schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER AS
$$
DECLARE
  is_3d INTEGER := 0;
BEGIN  
  EXECUTE format(
    'SELECT citydb_pkg.is_coord_ref_sys_3d(srid) FROM %I.database_srs', schema_name
  )
  INTO is_3d;

  RETURN is_3d;
END;
$$
LANGUAGE plpgsql STABLE;

/*******************************************************************
* check_srid
*
* @param srid The SRID to be checked
* @return The boolean result encoded as INTEGER: 0 = false, 1 = true
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.check_srid(srid INTEGER) RETURNS INTEGER AS
$$
SELECT COALESCE((
  SELECT 1 FROM spatial_ref_sys WHERE srid = $1
  ), 0);
$$
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
  srid INTEGER
  ) RETURNS GEOMETRY AS
$$
BEGIN
  RETURN ST_Transform($1, $2);
END;
$$
LANGUAGE plpgsql STABLE STRICT;