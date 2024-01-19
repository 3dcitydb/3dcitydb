/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   change_column_srid(table_name TEXT, column_name TEXT, dim INTEGER, schema_srid INTEGER,
*     transform INTEGER DEFAULT 0, geom_type TEXT DEFAULT 'GEOMETRY', schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   change_schema_srid(schema_srid INTEGER, schema_srs_name TEXT,
*     transform INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   check_srid(srsno INTEGER DEFAULT 0) RETURNS TEXT
*   is_coord_ref_sys_3d(schema_srid INTEGER) RETURNS INTEGER
*   is_db_coord_ref_sys_3d(schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   transform_or_null(geom GEOMETRY, srid INTEGER) RETURNS GEOMETRY
******************************************************************/

/******************************************************************
* is_coord_ref_sys_3d
*
* no 3D-Coord.-Reference-System defined in the spatial_ref_sys-table 
* of PostGIS 2.0 by default. Refer to spatialreference.org for 
* INSERT-statements of 3D-SRIDs. They can be identified by the AXIS 
* UP in the srtext
*
* @param schema_srid the SRID of the coordinate system to be checked
* @RETURN INTEGER the boolean result encoded as INTEGER: 0 = false, 1 = true                
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_coord_ref_sys_3d(schema_srid INTEGER) RETURNS INTEGER AS
$$
SELECT COALESCE((
  SELECT 1 FROM spatial_ref_sys WHERE auth_srid = $1 AND srtext LIKE '%UP]%'
  ), 0);
$$
LANGUAGE sql STABLE STRICT;


/******************************************************************
* is_db_coord_ref_sys_3d
*
* @RETURN INTEGER the boolean result encoded as INTEGER: 0 = false, 1 = true                
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
LANGUAGE plpgsql STABLE STRICT;


/*******************************************************************
* check_srid
*
* @param srsno  the chosen SRID to be further used in the database
*
* @RETURN TEXT  status of srid check
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.check_srid(srsno INTEGER DEFAULT 0)
  RETURNS TEXT AS
$$
DECLARE
  schema_srid INTEGER;
BEGIN
  SELECT srid INTO schema_srid FROM spatial_ref_sys WHERE srid = $1;

  IF schema_srid IS NULL THEN
    RAISE EXCEPTION 'Table spatial_ref_sys does not contain the SRID %. Insert commands for missing SRIDs can be found at spatialreference.org', srsno;
    RETURN 'SRID not ok';
  END IF;

  RETURN 'SRID ok';
END;
$$
LANGUAGE plpgsql STABLE STRICT;


/******************************************************************
* transform_or_null
*
* @param geom the geometry whose representation is to be transformed using another coordinate system 
* @param srid the SRID of the coordinate system to be used for the transformation.
* @RETURN GEOMETRY the transformed geometry representation                
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.transform_or_null(
  geom GEOMETRY,
  srid INTEGER
  ) RETURNS GEOMETRY AS
$$
BEGIN
  IF geom IS NOT NULL THEN
    RETURN ST_Transform($1, $2);
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE plpgsql STABLE;


/*****************************************************************
* change_column_srid
*
* @param table_name name of table
* @param column_name name of spatial column
* @param dim dimension of geometry
* @param schema_srid the SRID of the coordinate system to be further used in the database
* @param transform 1 if existing data shall be transformed, 0 if not
* @param geom_type the geometry type of the given spatial column
* @param schema_name name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_column_srid(
  table_name TEXT,
  column_name TEXT,
  dim INTEGER,
  schema_srid INTEGER,
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
  WHERE pgns.nspname = lower($7)
    AND pgc_t.relname = lower($1)
    AND pga.attname = lower($2)
    AND pgam.amname = 'gist';

  IF idx_name IS NOT NULL THEN
    -- drop spatial index if exists
    EXECUTE format('DROP INDEX %I.%I', $7, idx_name);
  END IF;

  IF transform <> 0 THEN
    -- construct correct geometry type
    IF dim = 3 AND substr($6,length($6),length($6)) <> 'M' THEN
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
* @param schema_srid       the SRID of the coordinate system to be 
*                          further used in the database
* @param schema_srs_name   the SRS_NAME of the coordinate system
*                          to be further used in the database
* @param transform         1 if existing data shall be transformed, 0 if not
* @param schema_name       name of schema
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_schema_srid(
  schema_srid INTEGER,
  schema_srs_name TEXT,
  transform INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS $$
BEGIN
  -- check if user selected srid is valid
  -- will raise an exception if not
  PERFORM citydb_pkg.check_srid($1);

  -- update entry in database_srs table first
  EXECUTE format('TRUNCATE TABLE %I.database_srs', $4);
  EXECUTE format('INSERT INTO %I.database_srs (srid, srs_name) VALUES (%L, %L)', $4, $1, $2);

  -- change srid of spatial columns in given schema
  PERFORM citydb_pkg.change_column_srid(f_table_name, f_geometry_column, coord_dimension, $1, $3, type, f_table_schema)
    FROM geometry_columns
    WHERE f_table_schema = lower($4)
      AND f_geometry_column <> 'implicit_geometry';
END;
$$
LANGUAGE plpgsql STRICT;