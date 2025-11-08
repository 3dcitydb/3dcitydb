/*****************************************************************
 * CONTENT: PL/SQL Package CITYDB_UTIL
 *
 * Utility methods for working with the 3DCityDB
 *****************************************************************/

CREATE OR REPLACE TYPE version AS OBJECT (
  version VARCHAR2(100),
  major_version NUMBER(10),
  minor_version NUMBER(10),
  minor_revision NUMBER(10)
);
/

CREATE OR REPLACE TYPE version_tab IS TABLE OF version;
/

CREATE OR REPLACE TYPE db_info AS OBJECT (
  srid NUMBER(38),
  srs_name VARCHAR2(1000),
  coord_ref_sys_name VARCHAR2(255),
  coord_ref_sys_kind VARCHAR2(255),
  wktext VARCHAR2(4000)
);
/

CREATE OR REPLACE TYPE db_info_tab IS TABLE OF db_info;
/

CREATE OR REPLACE TYPE number_tab IS TABLE OF NUMBER;
/
 
-- Package declaration
CREATE OR REPLACE PACKAGE citydb_util
AS
  FUNCTION citydb_version RETURN version_tab;
  FUNCTION db_metadata RETURN db_info_tab;
  FUNCTION db_metadata (p_schema_name IN VARCHAR2) RETURN db_info_tab;
  FUNCTION get_seq_values (p_seq_name IN VARCHAR2, p_seq_count IN NUMBER) RETURN number_tab;
  FUNCTION get_seq_values (p_seq_name IN VARCHAR2, p_seq_count IN NUMBER, p_schema_name IN VARCHAR2) RETURN number_tab;
END citydb_util;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_util
AS

  /*****************************************************************
  * Function CITYDB_VERSION
  *
  * Return value:
  *   - version_tab => 3DCityDB version as table with columns
  *       version, major_version, minor_version, minor_revision
  ******************************************************************/
  FUNCTION citydb_version
  RETURN version_tab
  IS
  BEGIN
    RETURN version_tab(version(
      '@versionString@',
      @majorVersion@,
      @minorVersion@,
      @minorRevision@
    ));
  END citydb_version;

  /*****************************************************************
  * Function DB_METADATA
  *
  * Return value:
  *   - db_info_tab => 3DCityDB metadata information as table with columns
  *       srid, srs_name
  *       coord_ref_sys_name, coord_ref_sys_kind, wktext
  ******************************************************************/
  FUNCTION db_metadata
  RETURN db_info_tab
  IS
    v_metadata db_info_tab;
  BEGIN
    SELECT
      db_info(
        d.srid,
        d.srs_name,
        crs.coord_ref_sys_name,
        crs.coord_ref_sys_kind,
        crs.wktext
      )
    BULK COLLECT INTO v_metadata
    FROM
      database_srs d,
      TABLE(citydb_srs.get_coord_ref_sys_info(d.srid)) crs
    FETCH FIRST 1 ROWS ONLY;
    
    RETURN v_metadata;
  END db_metadata;

  /*****************************************************************
  * Function DB_METADATA
  *
  * Parameters:
  *   - p_schema_name => Name of the target schema
  *
  * Return value:
  *   - db_info_tab => 3DCityDB metadata information as table with columns
  *       srid, srs_name
  *       coord_ref_sys_name, coord_ref_sys_kind, wktext
  ******************************************************************/
  FUNCTION db_metadata (
    p_schema_name IN VARCHAR2
  )
  RETURN db_info_tab
  IS
    v_schema_name VARCHAR2(128);
    v_metadata db_info_tab;
  BEGIN
    v_schema_name := DBMS_ASSERT.simple_sql_name(p_schema_name);
 
    EXECUTE IMMEDIATE
      'SELECT db_info(srid, srs_name, coord_ref_sys_name, coord_ref_sys_kind, wktext) ' ||
      'FROM TABLE(' || v_schema_name || '.citydb_util.db_metadata)'
    BULK COLLECT INTO v_metadata;
    
    RETURN v_metadata;
  END db_metadata;

  /*****************************************************************
  * Function GET_SEQ_VALUES
  *
  * Parameters:
  *   - p_seq_name => Name of the sequence possibly including a schema prefix
  *   - p_seq_count => Number of values to be queried from the sequence
  *
  * Return value:
  *   - number_tab => List of sequence values from given sequence
  ******************************************************************/
  FUNCTION get_seq_values (
    p_seq_name IN VARCHAR2,
    p_seq_count IN NUMBER
  )
  RETURN number_tab
  IS
    v_seq_name VARCHAR2(128);
    v_values number_tab;
  BEGIN
    IF p_seq_count IS NULL OR p_seq_count < 1 THEN
      RETURN number_tab();
    END IF;
  
    v_seq_name := DBMS_ASSERT.qualified_sql_name(upper(p_seq_name));
    
    EXECUTE IMMEDIATE
      'SELECT ' || v_seq_name || '.NEXTVAL ' ||
      'FROM dual ' ||
      'CONNECT BY LEVEL <= :1'
    BULK COLLECT INTO v_values
    USING p_seq_count;
    
    RETURN v_values;
  END get_seq_values;

  /*****************************************************************
  * Function GET_SEQ_VALUES
  *
  * Parameters:
  *   - p_seq_name => Name of the sequence possibly including a schema prefix
  *   - p_seq_count => Number of values to be queried from the sequence
  *   - p_schema_name => Name of the target schema
  *
  * Return value:
  *   - number_tab => List of sequence values from given sequence
  ******************************************************************/
  FUNCTION get_seq_values (
    p_seq_name IN VARCHAR2,
    p_seq_count IN NUMBER,
    p_schema_name IN VARCHAR2
  )
  RETURN number_tab
  IS
    v_schema_name VARCHAR2(128);
    v_values number_tab;
  BEGIN
    v_schema_name := DBMS_ASSERT.simple_sql_name(p_schema_name);

    EXECUTE IMMEDIATE
      'SELECT * FROM TABLE(' || v_schema_name || '.citydb_util.get_seq_values(:1, :2))'
    BULK COLLECT INTO v_values
    USING p_seq_name, p_seq_count;

    RETURN v_values;
  END get_seq_values;

END citydb_util;
/