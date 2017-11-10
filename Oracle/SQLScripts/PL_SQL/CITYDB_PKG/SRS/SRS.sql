-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
--     
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

/*****************************************************************
* PACKAGE citydb_util
* 
* utility methods for spatial reference system in the database
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_srs
AS
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid NUMBER)
    RETURN MDSYS.SDO_GEOMETRY;
  FUNCTION is_coord_ref_sys_3d(schema_srid NUMBER)
    RETURN NUMBER;
  FUNCTION check_srid(srsno INTEGER DEFAULT 0)
    RETURN VARCHAR;
  FUNCTION is_db_coord_ref_sys_3d
    RETURN NUMBER;
  PROCEDURE change_schema_srid(schema_srid NUMBER, schema_gml_srs_name VARCHAR2, transform NUMBER := 0);
  FUNCTION get_dim(t_name VARCHAR, c_name VARCHAR)
    RETURN NUMBER;
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
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid NUMBER)
    RETURN MDSYS.SDO_GEOMETRY
  IS
  BEGIN
    IF geom IS NOT NULL THEN
      RETURN sdo_cs.transform(geom, srid);
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
  FUNCTION is_coord_ref_sys_3d(schema_srid NUMBER)
    RETURN NUMBER
  IS
    is_3d NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO is_3d FROM sdo_crs_compound WHERE srid = schema_srid;

    IF is_3d = 0 THEN
      SELECT COUNT(*) INTO is_3d FROM sdo_crs_geographic3d WHERE SRID = schema_srid;
    END IF;

    RETURN is_3d;
  END;

  /*******************************************************************
  * check_srid
  *
  * @param srsno     the chosen SRID to be further used in the database
  *
  * @RETURN VARCHAR  status of srid check
  *******************************************************************/
  FUNCTION check_srid(srsno INTEGER DEFAULT 0)
    RETURN VARCHAR
  IS
    schema_srid INTEGER;
    unknown_srs_ex EXCEPTION;
  BEGIN
    SELECT COUNT(srid) INTO schema_srid FROM mdsys.cs_srs WHERE srid = srsno;

    IF schema_srid = 0 THEN
      RAISE unknown_srs_ex;
    END IF;

    RETURN 'SRID ok';

    EXCEPTION
      WHEN unknown_srs_ex THEN
        dbms_output.put_line('Table MDSYS.CS_SRS does not contain the SRID ' || srsno);
        RETURN 'SRID not ok';
  END;

  /*****************************************************************
  * is_db_coord_ref_sys_3d
  *
  * @return NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_db_coord_ref_sys_3d
    RETURN NUMBER
  IS
    schema_srid NUMBER;
  BEGIN
    SELECT srid INTO schema_srid FROM database_srs;
    RETURN is_coord_ref_sys_3d(schema_srid);
  END;

  /*****************************************************************
  * get_dim
  *
  * @param t_name name of the table
  * @param c_name name of the column
  * @RETURN NUMBER number of dimension
  ******************************************************************/
  FUNCTION get_dim(t_name VARCHAR, c_name VARCHAR)
    RETURN NUMBER
  IS
    is_3d NUMBER(1, 0);
  BEGIN
    SELECT 3 INTO is_3d FROM user_sdo_geom_metadata m, TABLE(m.diminfo) dim
      WHERE table_name = t_name AND column_name = c_name AND dim.sdo_dimname = 'Z';

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
    t_name      VARCHAR2,
    c_name      VARCHAR2,
    dim         NUMBER,
    schema_srid NUMBER,
    transform   NUMBER := 0
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
      internal_t_name := substr(t_name, 1, length(t_name) - 3);
    ELSE
      internal_t_name := t_name;
    END IF;

    is_valid := citydb_idx.index_status(t_name, c_name) = 'VALID';

    -- update metadata as the index was switched off before transaction
    UPDATE user_sdo_geom_metadata SET srid = schema_srid WHERE table_name = t_name AND column_name = c_name;
    COMMIT;

    -- get name of spatial index
    BEGIN
      SELECT index_name INTO idx_name FROM user_ind_columns
        WHERE table_name = upper(t_name) AND column_name = upper(c_name);

      -- create INDEX_OBJ
      IF dim = 3 THEN
        idx := INDEX_OBJ.construct_spatial_3d(idx_name, internal_t_name, c_name);
      ELSE
        idx := INDEX_OBJ.construct_spatial_2d(idx_name, internal_t_name, c_name);
      END IF;

      -- drop spatial index
      sql_err_code := citydb_idx.drop_index(idx, is_versioned);

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          is_valid := FALSE;
          -- cleanup
          DELETE FROM user_sdo_geom_metadata WHERE table_name = t_name AND column_name = c_name;
    END;

    IF transform <> 0 THEN
      -- coordinates of existent geometries will be transformed
      EXECUTE IMMEDIATE
        'UPDATE ' || t_name || ' SET ' || c_name || ' = sdo_cs.transform( ' || c_name || ', :1) WHERE ' || c_name || ' IS NOT NULL'
        USING schema_srid;
    ELSE
      -- only srid paramter of geometries is updated
      EXECUTE IMMEDIATE 'UPDATE ' || t_name || ' t SET t.' || c_name || '.SDO_SRID = :1 WHERE t.' || c_name || ' IS NOT NULL'
        USING schema_srid;
    END IF;

    IF is_valid THEN
      -- create spatial index (incl. new spatial metadata)
      sql_err_code := citydb_idx.create_index(idx, is_versioned);
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
    schema_srid         NUMBER,
    schema_gml_srs_name VARCHAR2,
    transform           NUMBER := 0
  )
  IS
    unknown_srs_ex EXCEPTION;
  BEGIN
    IF citydb_srs.check_srid(schema_srid) <> 'SRID ok' THEN
      dbms_output.put_line('Your chosen SRID was not found in the MDSYS.CS_SRS table! Chosen SRID was ' || schema_srid);
    ELSE
      -- update entry in DATABASE_SRS table first
      UPDATE database_srs SET srid = schema_srid, gml_srs_name = schema_gml_srs_name;
      COMMIT;

      -- change srid of each spatially enabled table
      FOR rec IN (SELECT table_name AS t, column_name AS c, get_dim(table_name, column_name) AS dim FROM user_sdo_geom_metadata) 
	  LOOP
        change_column_srid(rec.t, rec.c, rec.dim, schema_srid, transform);
      END LOOP;
      dbms_output.put_line('Schema SRID sucessfully changed to ' || schema_srid);
    END IF;
  END;

END citydb_srs;
/