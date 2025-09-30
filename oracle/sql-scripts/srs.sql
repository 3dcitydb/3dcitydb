-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: September 2025
-- Status: Draft finished
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

/*****************************************************************
 * CONTENT: PL/SQL Package CITYDB_SRS
 *
 * Methods to handle the spatial reference system
 *****************************************************************/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_srs
AS

  FUNCTION transform_or_null (p_geom IN SDO_GEOMETRY, p_srid IN INTEGER) RETURN SDO_GEOMETRY;
  FUNCTION check_srid (p_srid IN INTEGER DEFAULT 0) RETURN INTEGER;
  FUNCTION is_coord_ref_sys_3d (p_schema_srid IN INTEGER) RETURN INTEGER;
  FUNCTION is_db_coord_ref_sys_3d RETURN INTEGER;
  FUNCTION get_dim (p_table_name VARCHAR2, p_column_name VARCHAR2) RETURN INTEGER;

  PROCEDURE change_column_srid (p_table_name IN VARCHAR2, p_column_name IN VARCHAR2, p_dim IN INTEGER, p_target_srid IN INTEGER, p_transform IN INTEGER DEFAULT 0);
  PROCEDURE change_schema_srid (p_schema_srid IN INTEGER, p_schema_gml_srs_name IN VARCHAR2, p_transform IN INTEGER DEFAULT 0);
  FUNCTION get_coord_ref_sys_info (p_srid IN INTEGEGER, p_coord_ref_sys_name OUT VARCHAR2, p_coord_ref_sys_kind VARCHAR2, p_wktext OUT VARCHAR2);

END citydb_srs;
-- End of package declaration
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_srs
AS

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
      RETURN sdo_cs.transform(p_geom, p_srid);
    ELSE
      RETURN NULL;
    END IF;
  END transform_or_null;
  -- End of function

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
    l_srid INTEGER;
    unknown_srs_ex EXCEPTION;

  BEGIN
    SELECT
      COUNT(srid) INTO l_srid
    FROM
      mdsys.cs_srs
    WHERE
      srid = p_srid;

    IF l_srid = 0 THEN
      RAISE unknown_srs_ex;
    ELSE
      RETURN 1;
    END IF;

    EXCEPTION
      WHEN unknown_srs_ex THEN
        dbms_output.put_line('Table MDSYS.CS_SRS does not contain the SRID ' || srid || '.');
        RETURN 0;

  END check_srid;
  -- End of function

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
    p_schema_srid IN INTEGER
  )
    RETURN INTEGER
  IS
    v_is_3d INTEGER := 0;
  BEGIN
    SELECT COALESCE (
      (SELECT 1 FROM sdo_crs_compound WHERE srid = p_schema_srid),
      (SELECT 1 FROM sdo_crs_geographic3d WHERE srid = p_schema_srid),
      0
    ) INTO v_is_3d
    FROM dual;

    RETURN v_is_3d;
  END is_coord_ref_sys_3d;
  -- End of function

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
    v_schema VARCHAR2(128);
  BEGIN
    v_schema := SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA');
    EXECUTE IMMEDIATE
      'SELECT srid FROM ' || DBMS_ASSERT.SCHEMA_NAME(v_schema) || '.database_srs'
      INTO v_srid;
    RETURN is_coord_ref_sys_3d(v_srid);

  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 0;
  END is_db_coord_ref_sys_3d;
  -- End of function

  /*****************************************************************
  * Function GET_DIM
  *
  * Parameters:
  *   - p_schema_name => ??? check if needed
  *   - p_table_name  => Name of the table
  *   - p_column_name => Name of the geometry column
  *
  * Return value:
  *   - INTEGER => The number of dimensions
  ******************************************************************/
  FUNCTION get_dim (
    p_table_name IN VARCHAR2,
    p_column_name IN VARCHAR2
    ) RETURN INTEGER
  IS
    v_is_3d INTEGER := 0;
  BEGIN
    SELECT
      3
    INTO
      v_is_3d
    FROM
      user_sdo_geom_metadata m,
      TABLE(m.diminfo) dim
    WHERE
      m.table_name = upper(p_table_name)
      AND m.column_name = upper(p_column_name)
      AND dim.sdo_dimname = 'Z';

    RETURN v_is_3d;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 2;
  END get_dim;
  -- End of function

  /*****************************************************************
  * Procedure CHANGE_COLUMN_SRID
  *
  * Parameters:
  *   - p_table_name  => Name of the table
  *   - p_column_name => Name of the geometry column
  *   - p_dim         => Dimension of spatial index
  *   - p_target_srid => The SRID of the coordinate system to be further used in the database
  *   - p_transform   => 1 if existing data shall be transformed, 0 if not
  *   - p_geom_type   => The geometry type of the given spatial column
  ******************************************************************/

  /* ToDo: More parameters needed for DIMINFO and TOLERANCE */

  PROCEDURE change_column_srid (
    p_table_name  IN VARCHAR2,
    p_column_name IN VARCHAR2,
    p_dim         IN INTEGER,
    p_target_srid IN INTEGER,
    p_transform   IN INTEGER DEFAULT 0
    -- p_geom_type     IN VARCHAR2 DEFAULT 'GEOMETRY'
  )
  IS
    v_schema_name   VARCHAR2(128);
    v_table_name    VARCHAR2(128);
    v_column_name   VARCHAR2(128);
    v_sidx_name     VARCHAR2(128);
    v_sidx_dim      VARCHAR2(128);
    -- v_geom_type     VARCHAR2(128);
    v_is_versioned  BOOLEAN;
    v_is_valid      VARCHAR2(128);
  BEGIN
    v_schema_name := SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA');

    IF table_name LIKE '%\_LT' ESCAPE '\' THEN
      v_is_versioned := true;
      v_table_name := substr(table_name, 1, length(table_name) - 3);
    ELSE
      v_table_name := table_name;
    END IF;

    v_column_name := column_name;
    v_sidx_dim := dim;

    -- Check the existence of a spatial index defined for a table and column
    SELECT sdo_index_name INTO v_sidx_name
    FROM user_sdo_index_metadata
    WHERE sdo_index_owner = v_schema_name AND sdo_table_name = v_table_name AND sdo_column_name = v_column_name;

    -- Drop the existing spatial index
    EXECUTE IMMEDIATE 'DROP INDEX IF EXISTS ' || v_sidx_name || ' FORCE';

    -- Delete existing USER_SDO_GEOM_METADATA for the old SRID
    EXECUTE IMMEDIATE 'DELETE FROM user_sdo_geom_metadata WHERE table_name = ' || v_table_name || ' AND column_name = ' || v_column_name;

    -- Insert SDO metadata for the new SRID. Values needed: TABLE_NAME, COLUMN_NAME, DIMINFO (X, Y, Z), SRID
    /* ToDo: Do a correct INSERT of SDO metadata */
    EXECUTE IMMEDIATE 'INSERT INTO user_sdo_geom_metadata ...';

    -- Recreate the spatial index for the new SRID
    EXECUTE IMMEDIATE 'CREATE INDEX IF NOT EXISTS ' || v_sidx_name || ' ON ' || v_table_name || ' ( ' || v_column_name || ') INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2 PARAMETERS ( '' sdo_indx_dims = ' || v_sidx_dim || ''') ';


    IF transform <> 0 THEN
      -- coordinates of existent geometries will be transformed inline
      EXECUTE IMMEDIATE
        'UPDATE ' || v_table_name || ' SET ' || v_column_name || ' = sdo_cs.transform( ' || v_column_name || ', :1) WHERE ' || v_column_name || ' IS NOT NULL'
        USING target_srid;
    END IF;
    COMMIT;

  END change_column_srid;
  -- End of function

  /*****************************************************************
  * Procedure CHANGE_SCHEMA_SRID
  *
  * Parameters:
  *   - p_schema_srid         => The SRID of the coordinate system to be further used in the database
  *   - p_schema_gml_srs_name => The GML_SRS_NAME of the coordinate system to be further used in the database
  *   - p_transform           => Set to 1 if existing data shall be transformed, 0 if not
  ******************************************************************/
  PROCEDURE change_schema_srid (
    p_schema_srid IN INTEGER,
    p_schema_gml_srs_name IN VARCHAR2,
    p_transform IN INTEGER DEFAULT 0
  )
  IS
  BEGIN
    -- check if user selected srid is valid
    -- will raise an exception if not
    IF citydb_srs.check_srid(schema_srid) = 0 THEN
      dbms_output.put_line('The chosen SRID ' || schema_srid || ' was not found in the MDSYS.CS_SRS table.');
      RETURN;
    END IF;

    -- update entry in DATABASE_SRS table first
    EXECUTE IMMEDIATE 'TRUNCATE TABLE database_srs DROP STORAGE';
    EXECUTE IMMEDIATE 'INSERT INTO database_srs (srid, gml_srs_name) VALUES (:1, :2)' USING schema_srid, schema_gml_srs_name;

    -- change srid of spatial columns in given schema
    FOR rec IN (
      SELECT
        table_name AS t,
        column_name AS c,
        citydb_srs.get_dim(table_name, column_name) AS dim
      FROM
        user_sdo_geom_metadata
      WHERE
        /* Q: Why is this column excluded? */
        column_name <> 'IMPLICIT_GEOMETRY'
      ORDER BY
        table_name,
        column_name
      )
    LOOP
      change_column_srid(rec.t, rec.c, rec.dim, schema_srid, transform);
    END LOOP;

    dbms_output.put_line('Schema SRID successfully changed to ' || schema_srid || '.');
  END change_schema_srid;
  -- End of function

END citydb_srs;
-- End of package body
/