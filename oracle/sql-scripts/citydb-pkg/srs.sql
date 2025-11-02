/*****************************************************************
 * CONTENT: PL/SQL Package CITYDB_SRS
 *
 * Methods to handle the spatial reference system
 *****************************************************************/

CREATE OR REPLACE TYPE crs_info AS OBJECT (
  coord_ref_sys_name VARCHAR2(255),
  coord_ref_sys_kind VARCHAR2(255),
  wktext VARCHAR2(4000)
);
/

CREATE OR REPLACE TYPE crs_info_tab IS TABLE OF crs_info;
/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_srs
AS
  FUNCTION get_coord_ref_sys_info (p_srid IN INTEGER) RETURN crs_info_tab;
  FUNCTION is_coord_ref_sys_3d (p_srid IN INTEGER) RETURN INTEGER;
  FUNCTION is_db_coord_ref_sys_3d RETURN INTEGER;
  FUNCTION is_db_coord_ref_sys_3d (p_schema_name IN VARCHAR2) RETURN INTEGER;
  FUNCTION check_srid (p_srid IN INTEGER DEFAULT 0) RETURN INTEGER;
  FUNCTION transform_or_null (p_geom IN SDO_GEOMETRY, p_srid IN INTEGER) RETURN SDO_GEOMETRY;
  PROCEDURE change_schema_srid (p_target_srid IN INTEGER, p_target_srs_name IN VARCHAR2, p_transform IN INTEGER DEFAULT 0);
END citydb_srs;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_srs
AS
  
  /*****************************************************************
  * Function GET_COORD_REF_SYS_INFO
  *
  * Parameters:
  *   - p_srid => The SRID to retrieve the CRS information for
  *
  * Return value:
  *   - crs_info_tab => CRS information as table with columns
  *       coord_ref_sys_name, coord_ref_sys_kind, wktext
  ******************************************************************/
  FUNCTION get_coord_ref_sys_info (
    p_srid IN INTEGER
  )
  RETURN crs_info_tab
  IS
    v_crs_info crs_info := crs_info(NULL, NULL, NULL);
  BEGIN
    BEGIN
      SELECT coord_ref_sys_name,
        coord_ref_sys_kind
      INTO
        v_crs_info.coord_ref_sys_name,
        v_crs_info.coord_ref_sys_kind
      FROM sdo_coord_ref_sys
      WHERE srid = p_srid;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN crs_info_tab();
    END;

    BEGIN
      SELECT COALESCE(wktext3d, wktext)
      INTO v_crs_info.wktext
      FROM cs_srs
      WHERE srid = p_srid;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_crs_info.wktext := NULL;
    END;

    RETURN crs_info_tab(v_crs_info);
  END get_coord_ref_sys_info;

  /*****************************************************************
  * Function IS_COORD_REF_SYS_3D
  *
  * Parameters:
  *   - p_srid => The SRID of the coordinate system to be checked
  *
  * Return value:
  *   - INTEGER => The boolean result encoded as INTEGER: 0 = false, 1 = true
  ******************************************************************/
  FUNCTION is_coord_ref_sys_3d (
    p_srid IN INTEGER
  )
  RETURN INTEGER
  IS
    v_is_3d INTEGER;
  BEGIN
    SELECT CASE
      WHEN
        EXISTS (SELECT 1 FROM sdo_crs_compound WHERE srid = p_srid) OR
        EXISTS (SELECT 1 FROM sdo_crs_geographic3d WHERE srid = p_srid)
      THEN 1 ELSE 0 END
    INTO v_is_3d
    FROM dual;

    RETURN v_is_3d;
  END is_coord_ref_sys_3d;

  /*****************************************************************
  * Function IS_DB_COORD_REF_SYS_3D
  *
  * Return value:
  *   - INTEGER => The boolean result encoded as INTEGER: 0 = false, 1 = true
  ******************************************************************/
  FUNCTION is_db_coord_ref_sys_3d
  RETURN INTEGER
  IS
    v_srid INTEGER;
  BEGIN
    SELECT srid INTO v_srid FROM database_srs;
    RETURN is_coord_ref_sys_3d(v_srid);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  END is_db_coord_ref_sys_3d;

  /*****************************************************************
  * Function IS_DB_COORD_REF_SYS_3D
  *
  * Parameters:
  *   - p_schema_name => Name of the target schema
  *
  * Return value:
  *   - INTEGER => The boolean result encoded as INTEGER: 0 = false, 1 = true
  ******************************************************************/
  FUNCTION is_db_coord_ref_sys_3d (
    p_schema_name IN VARCHAR2
  )
  RETURN INTEGER
  IS
    v_schema_name VARCHAR2(128);
    v_srid INTEGER;
  BEGIN
    v_schema_name := DBMS_ASSERT.simple_sql_name(p_schema_name);
    EXECUTE IMMEDIATE 'SELECT ' || v_schema_name || '.citydb_srs.is_db_coord_ref_sys_3d FROM dual' INTO v_srid;
    RETURN v_srid;
  END is_db_coord_ref_sys_3d;

  /*******************************************************************
  * Function CHECK_SRID
  *
  * Parameters:
  *   - p_srid => The SRID to be checked
  *
  * Return value:
  *   - BOOLEAN => The boolean result encoded as INTEGER: 0 = false, 1 = true
  *******************************************************************/
  FUNCTION check_srid (
    p_srid IN INTEGER DEFAULT 0
  )
  RETURN INTEGER
  IS
    v_srid INTEGER;
  BEGIN
    SELECT CASE
      WHEN EXISTS (SELECT 1 FROM mdsys.cs_srs WHERE srid = p_srid)
      THEN 1 ELSE 0 END
    INTO v_srid
    FROM dual;

    RETURN v_srid;
  END check_srid;

  /*****************************************************************
  * Function TRANSFORM_OR_NULL
  *
  * Parameters:
  *   - p_geom => The geometry to transform to another coordinate system
  *   - p_srid => The SRID of the coordinate system to be used for the transformation
  *
  * Return value:
  *   - SDO_GEOMETRY => The transformed geometry representation
  ******************************************************************/
  FUNCTION transform_or_null (
    p_geom IN SDO_GEOMETRY,
    p_srid IN INTEGER
  )
  RETURN SDO_GEOMETRY
  IS
  BEGIN
    IF p_geom IS NOT NULL THEN
      RETURN SDO_CS.TRANSFORM(p_geom, p_srid);
    ELSE
      RETURN NULL;
    END IF;
  END transform_or_null;

  /*****************************************************************
  * Procedure CHANGE_COLUMN_SRID
  *
  * Parameters:
  *   - p_table_name => Name of the table
  *   - p_column_name => Name of the geometry column
  *   - p_target_srid => SRID to use for the geometry column
  *   - p_transform => 1 if existing data shall be transformed, 0 if not
  ******************************************************************/  
  PROCEDURE change_column_srid (
    p_table_name IN VARCHAR2,
    p_column_name IN VARCHAR2,
    p_target_srid IN INTEGER,
    p_transform IN INTEGER DEFAULT 0
  )
  IS
    v_table_name VARCHAR2(128);
    v_column_name VARCHAR2(128);
    v_current_srid INTEGER;
  BEGIN
    v_table_name := DBMS_ASSERT.SIMPLE_SQL_NAME(upper(p_table_name));
    v_column_name := DBMS_ASSERT.SIMPLE_SQL_NAME(upper(p_column_name));
    
    SELECT COALESCE((
      SELECT srid
      FROM user_sdo_geom_metadata
      WHERE table_name = v_table_name
        AND column_name = v_column_name
    ), p_target_srid)
    INTO v_current_srid
    FROM dual;
        
    IF p_target_srid = v_current_srid THEN
      RETURN;
    END IF;
    
    -- update column metadata
    UPDATE user_sdo_geom_metadata
    SET srid = p_target_srid
    WHERE table_name = v_table_name
      AND column_name = v_column_name;
    
    -- transform coordinates
    IF p_transform <> 0 THEN
      EXECUTE IMMEDIATE 'UPDATE ' || v_table_name || ' SET ' || v_column_name || ' = sdo_cs.transform( ' || v_column_name || ', :1) WHERE ' || v_column_name || ' IS NOT NULL'
      USING p_target_srid;
    END IF;
    
    -- drop and recreate spatial indexes involving the column
    FOR rec IN (
      SELECT ui.index_name,
        DBMS_METADATA.GET_DDL('INDEX', ui.index_name) AS index_definition
      FROM user_indexes ui
      JOIN user_ind_columns uic
        ON ui.index_name = uic.index_name AND ui.table_name = uic.table_name
      WHERE ui.table_name = v_table_name
        AND uic.column_name = v_column_name
        AND ui.index_type = 'DOMAIN'
        AND ui.ityp_name like 'SPATIAL_INDEX%'
      GROUP BY ui.index_name
    )
    LOOP
      IF rec.index_definition IS NOT NULL THEN
        dbms_output.put_line('Dropping and recreating index "' || rec.index_name || '".');
        EXECUTE IMMEDIATE 'DROP INDEX IF EXISTS ' || rec.index_name || ' FORCE';
        EXECUTE IMMEDIATE rec.index_definition;
      END IF;
    END LOOP;
  END change_column_srid;

  /*****************************************************************
  * Procedure CHANGE_SCHEMA_SRID
  *
  * Parameters:
  *   - p_target_srid => The SRID of the coordinate system to be used for the schema
  *   - p_target_srs_name => The SRS_NAME of the coordinate system to be used for the schema
  *   - p_transform => 1 if existing data shall be transformed, 0 if not
  ******************************************************************/  
  PROCEDURE change_schema_srid (
    p_target_srid IN INTEGER,
    p_target_srs_name IN VARCHAR2,
    p_transform IN INTEGER DEFAULT 0
  )
  IS
  BEGIN
    -- update entry in database_srs table
    EXECUTE IMMEDIATE 'DELETE FROM database_srs';
    EXECUTE IMMEDIATE 'INSERT INTO database_srs (srid, srs_name) VALUES (:1, :2)' USING p_target_srid, p_target_srs_name;
    
    -- change SRID of spatial columns
    FOR rec IN (
      SELECT table_name,
        column_name
      FROM user_tab_columns
      WHERE data_type = 'SDO_GEOMETRY'
    )
    LOOP
      change_column_srid(rec.table_name, rec.column_name, p_target_srid, p_transform);   
    END LOOP;
  END change_schema_srid;

END citydb_srs;
/