-- SRS.sql
--
-- Authors:     Felix Kunde <felix-kunde@gmx.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates methods ragarding the spatial reference system of the 3DCityDB instance. 
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                          | Author
-- 1.1.0     2015-01-16   removed some dynamic SQL code          FKun
-- 1.0.0     2014-10-22   new script for 3DCityDB V3             FKun
--                                                               CNag
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   change_column_srid(t_name TEXT, c_name TEXT, dim INTEGER, schema_srid INTEGER, transform INTEGER DEFAULT 0, geom_type TEXT DEFAULT 'GEOMETRY', s_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   change_schema_srid(schema_srid INTEGER, schema_gml_srs_name TEXT, transform INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   check_srid(srsno INTEGER DEFAULT 0) RETURNS TEXT
*   is_coord_ref_sys_3d(schema_srid INTEGER) RETURNS INTEGER
*   is_db_coord_ref_sys_3d() RETURNS INTEGER
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
* @RETURN NUMERIC the boolean result encoded as NUMERIC: 0 = false, 1 = true                
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_coord_ref_sys_3d(schema_srid INTEGER) RETURNS INTEGER AS 
$$
  SELECT 1 FROM spatial_ref_sys WHERE auth_srid = schema_srid AND srtext LIKE '%UP]%';
$$
LANGUAGE sql STABLE;


/******************************************************************
* is_db_coord_ref_sys_3d
*
* @RETURN NUMERIC the boolean result encoded as NUMERIC: 0 = false, 1 = true                
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_db_coord_ref_sys_3d() RETURNS INTEGER AS
$$
  -- update search_path
  PERFORM set_config('search_path', schema_name, true);
  
  SELECT citydb_pkg.is_coord_ref_sys_3d(srid) FROM database_srs;
$$
LANGUAGE sql STABLE;


/*******************************************************************
* check_srid
*
* @param srsno     the chosen SRID to be further used in the database
*
* @RETURN TEXT  status of srid check
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.check_srid(srsno INTEGER DEFAULT 0) RETURNS TEXT AS
$$
DECLARE
  schema_srid INTEGER;
BEGIN
  SELECT srid INTO schema_srid FROM spatial_ref_sys WHERE srid = srsno;

  IF schema_srid IS NULL THEN
    RAISE EXCEPTION 'Table spatial_ref_sys does not contain the SRID %. Insert commands for missing SRIDs can be found at spatialreference.org', srsno;
    RETURN 'SRID not ok';
  END IF;

  RETURN 'SRID ok';
END;
$$
LANGUAGE plpgsql STABLE;


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
    RETURN ST_Transform(geom, srid);
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE plpgsql STABLE;


/*****************************************************************
* change_column_srid
*
* @param t_name name of table
* @param c_name name of spatial column
* @param dim dimension of geometry
* @param schema_srid the SRID of the coordinate system to be further used in the database
* @param transform 1 if existing data shall be transformed, 0 if not
* @param s_name name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_column_srid(
  t_name TEXT, 
  c_name TEXT,
  dim INTEGER,
  schema_srid INTEGER,
  transform INTEGER DEFAULT 0,
  geom_type TEXT DEFAULT 'GEOMETRY',
  s_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  idx_name TEXT;
  geometry_type TEXT;
BEGIN
  -- check if a spatial index is defined for the column
  SELECT pgc_i.relname INTO idx_name AS idx_name 
    FROM pg_class pgc_t, pg_class pgc_i, pg_index pgi, 
         pg_am pgam, pg_attribute pga, pg_namespace pgns
      WHERE pgc_t.oid = pgi.indrelid
        AND pgc_i.oid = pgi.indexrelid
        AND pgam.oid = pgc_i.relam
        AND pga.attrelid = pgc_i.oid
        AND pgns.oid = pgc_i.relnamespace
        AND pgns.nspname = s_name
        AND pgc_t.relname = t_name
        AND pga.attname = c_name
        AND pgam.amname = 'gist';

  IF idx_name IS NOT NULL THEN 
    -- drop spatial index if exists
    EXECUTE format('DROP INDEX %I.%I', s_name, idx_name);
  END IF;

  IF transform <> 0 THEN
    -- construct correct geometry type
    IF dim < 3 THEN
      geometry_type := geom_type;
    ELSE
      geometry_type := geom_type || 'Z';
    END IF;

    -- coordinates of existent geometries will be transformed
    EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE geometry(%I,%L) USING ST_Transform(%I,%L)',
                      s_name, t_name, c_name, geometry_type, schema_srid, c_name, schema_srid);
  ELSE
    -- only metadata of geometry columns is updated, coordinates keep unchanged
    PERFORM UpdateGeometrySRID(s_name, t_name, c_name, schema_srid);
  END IF;

  IF idx_name IS NOT NULL THEN 
    -- recreate spatial index again
    IF dim < 3 THEN
      EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I)', idx_name, s_name, t_name, c_name);
    ELSE
      EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I gist_geometry_ops_nd )', idx_name, s_name, t_name, c_name);
    END IF;
  END IF;
END;
$$ 
LANGUAGE plpgsql;


/*******************************************************************
* change_schema_srid
*
* @param schema_srid       the SRID of the coordinate system to be 
*                          further used in the database
* @param db_gml_srs_name   the GML_SRS_NAME of the coordinate system 
*                          to be further used in the database
* @param transform         1 if existing data shall be transformed, 0 if not
* @param schema name       name of schema
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_schema_srid(
  schema_srid INTEGER, 
  schema_gml_srs_name TEXT,
  transform INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS $$
DECLARE
  is_set_srs_info INTEGER;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);
  
  SELECT 1 INTO is_set_srs_info FROM pg_tables 
    WHERE schemaname = schema_name AND tablename = 'database_srs';

  IF is_set_srs_info IS NOT NULL THEN
    -- update entry in DATABASE_SRS table first
    UPDATE database_srs SET srid = schema_srid, gml_srs_name = schema_gml_srs_name;
  END IF;

  -- change srid of each spatially enabled table
  PERFORM citydb_pkg.change_column_srid(f_table_name, f_geometry_column, coord_dimension, schema_srid, transform, type, f_table_schema) 
    FROM geometry_columns 
      WHERE f_table_schema = schema_name
        AND f_geometry_column != 'implicit_geometry'
        AND f_geometry_column != 'relative_other_geom'
        AND f_geometry_column != 'texture_coordinates';
END;
$$ 
LANGUAGE plpgsql;