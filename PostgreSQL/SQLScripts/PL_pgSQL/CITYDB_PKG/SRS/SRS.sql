-- SRS.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
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
-- 1.0.0     2014-10-10   new script for 3DCityDB V3             FKun
--                                                               CNag
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   change_column_srid(t_name TEXT, c_name TEXT, dim INTEGER, schema_srid INTEGER, s_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   change_schema_srid(schema_srid INTEGER, schema_gml_srs_name TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
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
DECLARE
  is_3d INTEGER := 0;
BEGIN
  EXECUTE 'SELECT 1 FROM spatial_ref_sys WHERE auth_srid=$1 AND srtext LIKE ''%UP]%''' 
             INTO is_3d USING schema_srid;

  RETURN is_3d;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* is_db_coord_ref_sys_3d
*
* @RETURN NUMERIC the boolean result encoded as NUMERIC: 0 = false, 1 = true                
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.is_db_coord_ref_sys_3d() RETURNS INTEGER AS $$
DECLARE
  schema_srid INTEGER;
BEGIN
  EXECUTE 'SELECT srid from DATABASE_SRS' INTO schema_srid;
  RETURN citydb_pkg.is_coord_ref_sys_3d(schema_srid);
END;
$$
LANGUAGE plpgsql;


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
  EXECUTE 'SELECT srid FROM spatial_ref_sys WHERE srid = $1' INTO schema_srid USING srsno;

  IF schema_srid IS NULL THEN
    RAISE EXCEPTION 'Table spatial_ref_sys does not contain the SRID %. Insert commands for missing SRIDs can be found at spatialreference.org', srsno;
    RETURN 'SRID not ok';
  END IF;

  RETURN 'SRID ok';
END;
$$
LANGUAGE plpgsql;


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
LANGUAGE plpgsql;


/*****************************************************************
* change_column_srid
*
* @param t_name name of table
* @param c_name name of spatial column
* @param dim dimension of geometry
* @param schema_srid the SRID of the coordinate system to be further used in the database
* @param s_name name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_column_srid(
  t_name TEXT, 
  c_name TEXT,
  dim INTEGER,
  schema_srid INTEGER,
  s_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  idx_name TEXT;
BEGIN
  -- check if a spatial index is defined for the column
  EXECUTE 'SELECT pgc_i.relname AS idx_name 
             FROM pg_class pgc_t, pg_class pgc_i, pg_index pgi, 
                  pg_am pgam, pg_attribute pga, pg_namespace pgns
             WHERE pgc_t.oid = pgi.indrelid
               AND pgc_i.oid = pgi.indexrelid
               AND pgam.oid = pgc_i.relam
               AND pga.attrelid = pgc_i.oid
               AND pgns.oid = pgc_i.relnamespace
               AND pgns.nspname = $1
               AND pgc_t.relname = $2
               AND pga.attname = $3
               AND pgam.amname = ''gist'''
               INTO idx_name USING s_name, t_name, c_name;

  IF idx_name IS NOT NULL THEN 
    -- drop spatial index if exists
    EXECUTE format('DROP INDEX %I.%I', s_name, idx_name);

    -- update geometry SRID
    PERFORM UpdateGeometrySRID(s_name, t_name, c_name, schema_srid);

    -- recreate spatial index again
    IF dim < 3 THEN
      EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I)', idx_name, s_name, t_name, c_name);
    ELSE
      EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I gist_geometry_ops_nd )', idx_name, s_name, t_name, c_name);
    END IF;
  ELSE
    -- no spatial index defined for table, only update metadata and geometry SRID
    PERFORM UpdateGeometrySRID(s_name, t_name, c_name, schema_srid);
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
* @param schema name       name of schema
*******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.change_schema_srid(
  schema_srid INTEGER, 
  schema_gml_srs_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS $$
DECLARE
  is_set_srs_info INTEGER;
BEGIN
  EXECUTE 'SELECT 1 FROM pg_tables WHERE schemaname = $1 AND tablename = ''database_srs'''
             INTO is_set_srs_info USING schema_name;

  IF is_set_srs_info IS NOT NULL THEN
    -- update entry in DATABASE_SRS table first
    EXECUTE format('UPDATE %I.database_srs SET srid = %L, gml_srs_name = %L',
                      schema_name, schema_srid, schema_gml_srs_name);
  END IF;

  -- change srid of each spatially enabled table
  EXECUTE 'SELECT citydb_pkg.change_column_srid(f_table_name, f_geometry_column, coord_dimension, $1, f_table_schema) 
             FROM geometry_columns WHERE f_table_schema = $2
              AND f_geometry_column != ''implicit_geometry''
              AND f_geometry_column != ''relative_other_geom''
              AND f_geometry_column != ''texture_coordinates''' USING schema_srid, schema_name;
END;
$$ 
LANGUAGE plpgsql;