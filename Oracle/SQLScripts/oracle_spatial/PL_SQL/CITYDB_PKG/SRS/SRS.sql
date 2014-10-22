-- SRS.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2014  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates package "citydb_srs" containing methods ragarding the spatial reference
-- system of the 3DCityDB instance.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2014-10-10   new script for 3DCityDB V3                  FKun
--                                                                    CNag
--

/*****************************************************************
* PACKAGE citydb_util
* 
* utility methods for spatial reference system in the database
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_srs
AS
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid NUMBER) RETURN MDSYS.SDO_GEOMETRY;
  FUNCTION is_coord_ref_sys_3d(srid NUMBER) RETURN NUMBER;
  FUNCTION is_db_coord_ref_sys_3d RETURN NUMBER;
  PROCEDURE change_schema_srid(schema_srid NUMBER, schema_gml_srs_name VARCHAR2, transform NUMBER := 0);
  FUNCTION get_dim(t_name VARCHAR, c_name VARCHAR) RETURN NUMBER;
  PROCEDURE change_column_srid(t_name VARCHAR2, c_name VARCHAR2, dim NUMBER, schema_srid NUMBER, transform NUMBER := 0);
END citydb_srs;
/

CREATE OR REPLACE PACKAGE BODY citydb_srs
AS  
  /*****************************************************************
  * transform_or_null
  *
  * @param geom the geometry whose representation is to be transformed using another coordinate system 
  * @param srid the SRID of the coordinate system to be used for the transformation.
  * @return MDSYS.SDO_GEOMETRY the transformed geometry representation                
  ******************************************************************/
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid number) RETURN MDSYS.SDO_GEOMETRY
  IS
  BEGIN
    IF geom is not NULL THEN
      RETURN SDO_CS.TRANSFORM(geom, srid);
    ELSE
      RETURN NULL;
    END IF;
  END;  
  
  /*****************************************************************
  * is_coord_ref_sys_3d
  *
  * @param srid the SRID of the coordinate system to be checked
  * @return NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_coord_ref_sys_3d(srid NUMBER) RETURN NUMBER
  IS
    is_3d number := 0;
  BEGIN
    execute immediate 'SELECT COUNT(*) from SDO_CRS_COMPOUND where SRID=:1' into is_3d using srid;
    if is_3d = 0 then
      execute immediate 'SELECT COUNT(*) from SDO_CRS_GEOGRAPHIC3D where SRID=:1' into is_3d using srid;
    end if;
    
    return is_3d;
  END;
  
  /*****************************************************************
  * is_db_coord_ref_sys_3d
  *
  * @return NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_db_coord_ref_sys_3d RETURN NUMBER
  IS
    srid number;
  BEGIN
    execute immediate 'SELECT srid from DATABASE_SRS' into srid;
    return is_coord_ref_sys_3d(srid);
  END;

  /*****************************************************************
  * get_dim
  *
  * @param t_name name of the table
  * @param c_name name of the column
  * @RETURN NUMBER number of dimension
  ******************************************************************/
  FUNCTION get_dim(t_name VARCHAR, c_name VARCHAR) RETURN NUMBER
  IS
    is_3d NUMBER(1,0);
  BEGIN
    EXECUTE IMMEDIATE 'SELECT 3 FROM user_sdo_geom_metadata m, TABLE(m.diminfo) dim
                         WHERE table_name = :1 AND column_name = :2 AND dim.sdo_dimname = ''Z'''
                         INTO is_3d USING t_name, c_name;

    RETURN is_3d;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 2;
  END;
  
  /*****************************************************************
  * change_column_srid
  *
  * @param t_name name of the table
  * @param c_name name of the column
  * @param dim dimension of spatial index
  * @param schema_srid the SRID of the coordinate system to be further used in the database
  * @param transform 1 if existing data shall be transformed, 0 if not
  ******************************************************************/
  PROCEDURE change_column_srid( 
    t_name VARCHAR2, 
    c_name VARCHAR2,
    dim NUMBER,
    schema_srid NUMBER,
	transform NUMBER := 0
    )
  IS
    internal_t_name VARCHAR2(30);
    is_versioned BOOLEAN := FALSE;
    is_valid BOOLEAN;
    idx_name VARCHAR2(30);
    idx INDEX_OBJ;
    sql_err_code VARCHAR2(20);
  BEGIN
    IF t_name LIKE '%\_LT' ESCAPE '\' THEN
      is_versioned := TRUE;
      internal_t_name := substr(t_name, 1, length(t_name)-3);
    ELSE
      internal_t_name := t_name;
    END IF;

    is_valid := geodb_idx.index_status(t_name, c_name) = 'VALID';

    -- update metadata as the index was switched off before transaction
    EXECUTE IMMEDIATE 'UPDATE USER_SDO_GEOM_METADATA SET srid = :1 WHERE table_name = :2 AND column_name = :3'
                         USING schema_srid, t_name, c_name;
    COMMIT;
    
    -- get name of spatial index
    BEGIN
      EXECUTE IMMEDIATE 'SELECT index_name FROM user_ind_columns 
                           WHERE table_name = upper(:1) AND column_name = upper(:2)'
                           INTO idx_name USING t_name, c_name;

      -- create INDEX_OBJ
      IF dim = 3 THEN
        idx := INDEX_OBJ.construct_spatial_3d(idx_name, internal_t_name, c_name);
      ELSE
        idx := INDEX_OBJ.construct_spatial_2d(idx_name, internal_t_name, c_name);
      END IF;

      -- drop spatial index
      sql_err_code := geodb_idx.drop_index(idx, is_versioned);

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          is_valid := FALSE;
          -- cleanup
          EXECUTE IMMEDIATE 'DELETE FROM USER_SDO_GEOM_METADATA WHERE table_name = :1 AND column_name = :2'
                               USING t_name, c_name;
    END;

    IF transform <> 0 THEN
      -- coordinates of existent geometries will be transformed
      EXECUTE IMMEDIATE 'UPDATE ' || t_name || ' SET ' || c_name || ' = SDO_CS.TRANSFORM( ' || c_name || ', :1)' USING schema_srid;
    ELSE
      -- only srid paramter of geometries is updated
      EXECUTE IMMEDIATE 'UPDATE ' || t_name || ' t SET t.' || c_name || '.SDO_SRID = :1 WHERE t.' || c_name || ' IS NOT NULL' USING schema_srid;
    END IF;

    IF is_valid THEN
      -- create spatial index (incl. new spatial metadata)
      sql_err_code := geodb_idx.create_index(idx, is_versioned);
    END IF;
  END;

  /*****************************************************************
  * change_schema_srid
  *
  * @param schema_srid the SRID of the coordinate system to be further used in the database
  * @param schema_gml_srs_name the GML_SRS_NAME of the coordinate system to be further used in the database
  * @param transform 1 if existing data shall be transformed, 0 if not
  ******************************************************************/
  PROCEDURE change_schema_srid(
    schema_srid NUMBER, 
	schema_gml_srs_name VARCHAR2,
	transform NUMBER := 0
    )
  IS
  BEGIN
    -- update entry in DATABASE_SRS table first
    UPDATE DATABASE_SRS SET SRID = schema_srid, GML_SRS_NAME = schema_gml_srs_name;
    COMMIT;

    -- change srid of each spatially enabled table
    FOR rec IN (SELECT table_name AS t, column_name AS c, get_dim(table_name, column_name) AS dim
                  FROM user_sdo_geom_metadata) LOOP
      change_column_srid(rec.t, rec.c, rec.dim, schema_srid, transform);
    END LOOP;
  END;
  
END citydb_srs;
/