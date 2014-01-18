-- IDX.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
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
-- Creates package "geodb_idx" containing utility methods for creating/droping
-- spatial/normal indexes on versioned/unversioned tables.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2008-09-10   release version                             CNag
--

/*****************************************************************
* TYPE INDEX_OBJ
* 
* global type to store information relevant to indexes
******************************************************************/
CREATE OR REPLACE TYPE INDEX_OBJ AS OBJECT
  (index_name 				VARCHAR2(100),
   table_name 				VARCHAR2(100),
   attribute_name 		VARCHAR2(100),
   type       				NUMBER(1),
   srid               NUMBER,
   is_3d 							NUMBER(1, 0),
     STATIC function construct_spatial_3d
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0)
     RETURN INDEX_OBJ,
     STATIC function construct_spatial_2d
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0)
     RETURN INDEX_OBJ,
     STATIC function construct_normal
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0)
     RETURN INDEX_OBJ
  );
/

/*****************************************************************
* TYPE BODY INDEX_OBJ
* 
* constructors for INDEX_OBJ instances
******************************************************************/
CREATE OR REPLACE TYPE BODY INDEX_OBJ IS
  STATIC FUNCTION construct_spatial_3d
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0)
  RETURN INDEX_OBJ IS
  BEGIN
    return INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), 1, srid, 1);
  END;
  STATIC FUNCTION construct_spatial_2d
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0)
  RETURN INDEX_OBJ IS
  BEGIN
    return INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), 1, srid, 0);
  END;
  STATIC FUNCTION construct_normal
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, srid NUMBER := 0)
  RETURN INDEX_OBJ IS
  BEGIN
    return INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), 0, srid, 0);
  END;
END;
/

/*****************************************************************
* PACKAGE geodb_idx
* 
* utility methods for index handling
******************************************************************/
CREATE OR REPLACE PACKAGE geodb_idx
AS
  TYPE index_table IS TABLE OF INDEX_OBJ;
  FUNCTION index_status(idx INDEX_OBJ) RETURN VARCHAR2;
  FUNCTION index_status(table_name VARCHAR2, column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION status_spatial_indexes RETURN STRARRAY;
  FUNCTION status_normal_indexes RETURN STRARRAY;
  FUNCTION create_index(idx INDEX_OBJ, is_versioned BOOLEAN, params VARCHAR2 := '') RETURN VARCHAR2;
  FUNCTION drop_index(idx INDEX_OBJ, is_versioned BOOLEAN) RETURN VARCHAR2;
  FUNCTION create_spatial_indexes RETURN STRARRAY;
  FUNCTION drop_spatial_indexes RETURN STRARRAY;
  FUNCTION create_normal_indexes RETURN STRARRAY;
  FUNCTION drop_normal_indexes RETURN STRARRAY;
  FUNCTION get_index(table_name VARCHAR2, column_name VARCHAR2) RETURN INDEX_OBJ;
END geodb_idx;
/

CREATE OR REPLACE PACKAGE BODY geodb_idx
AS 
  NORMAL CONSTANT NUMBER(1) := 0;
  SPATIAL CONSTANT NUMBER(1) := 1;
  
  INDICES CONSTANT index_table := index_table( 
    INDEX_OBJ.construct_spatial_3d('CITYOBJECT_SPX', 'CITYOBJECT', 'ENVELOPE'),
    INDEX_OBJ.construct_spatial_3d('SURFACE_GEOM_SPX', 'SURFACE_GEOMETRY', 'GEOMETRY'),
    INDEX_OBJ.construct_normal('CITYOBJECT_INX', 'CITYOBJECT', 'GMLID'),
    INDEX_OBJ.construct_normal('SURFACE_GEOMETRY_INX', 'SURFACE_GEOMETRY', 'GMLID'),
    INDEX_OBJ.construct_normal('APPEARANCE_INX', 'APPEARANCE', 'GMLID'),
    INDEX_OBJ.construct_normal('SURFACE_DATA_INX', 'SURFACE_DATA', 'GMLID')
  );
    
  /*****************************************************************
  * index_status
  * 
  * @param idx index to retrieve status from
  * @return VARCHAR2 string represntation of status, may include
  *                  'DROPPED', 'VALID', 'FAILED', 'INVALID'
  ******************************************************************/
  FUNCTION index_status(idx INDEX_OBJ) RETURN VARCHAR2
  IS
    status VARCHAR2(20);
  BEGIN
    IF idx.type = SPATIAL THEN
      execute immediate 'SELECT UPPER(DOMIDX_OPSTATUS) FROM USER_INDEXES WHERE INDEX_NAME=:1' into status using idx.index_name;
    ELSE
      execute immediate 'SELECT UPPER(STATUS) FROM USER_INDEXES WHERE INDEX_NAME=:1' into status using idx.index_name;
    END IF;
     
    RETURN status;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'DROPPED';
    WHEN others THEN
      RETURN 'INVALID';
  END;

  /*****************************************************************
  * index_status
  * 
  * @param table_name table_name of index to retrieve status from
  * @param column_name column_name of index to retrieve status from
  * @return VARCHAR2 string represntation of status, may include
  *                  'DROPPED', 'VALID', 'FAILED', 'INVALID'
  ******************************************************************/
  FUNCTION index_status(table_name VARCHAR2, column_name VARCHAR2) RETURN VARCHAR2
  IS
    internal_table_name VARCHAR2(100);
    index_type VARCHAR2(35);
    index_name VARCHAR2(35);
    status VARCHAR2(20);
  BEGIN
    internal_table_name := table_name;
    
    IF geodb_util.versioning_table(table_name) = 'ON' THEN
      internal_table_name := table_name || '_LT';
    END IF;     
  
    execute immediate 'SELECT UPPER(INDEX_TYPE), INDEX_NAME FROM USER_INDEXES WHERE INDEX_NAME=
    	(SELECT UPPER(INDEX_NAME) FROM USER_IND_COLUMNS WHERE TABLE_NAME=UPPER(:1) and COLUMN_NAME=UPPER(:2))' 
    	into index_type, index_name using internal_table_name, column_name;  
    
    IF index_type = 'DOMAIN' THEN
      execute immediate 'SELECT UPPER(DOMIDX_OPSTATUS) FROM USER_INDEXES WHERE INDEX_NAME=:1' into status using index_name;
    ELSE
      execute immediate 'SELECT UPPER(STATUS) FROM USER_INDEXES WHERE INDEX_NAME=:1' into status using index_name;
    END IF;
    
    RETURN status;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'DROPPED';
    WHEN others THEN
      RETURN 'INVALID';
  END;
  
  /*****************************************************************
  * create_spatial_metadata
  * 
  * @param idx index to create metadata for
  ******************************************************************/
  PROCEDURE create_spatial_metadata(idx INDEX_OBJ, is_versioned BOOLEAN)
  IS
    table_name VARCHAR2(100);
    srid DATABASE_SRS.SRID%TYPE;
  BEGIN
    table_name := idx.table_name;
    
    IF is_versioned THEN
      table_name := table_name || '_LT';
    END IF;    
  
    execute immediate 'DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME=:1 AND COLUMN_NAME=:2' using table_name, idx.attribute_name;
    
    if idx.srid = 0 then
      execute immediate 'select SRID from DATABASE_SRS' into srid;
    else
      srid := idx.srid;
    end if;
    
    IF idx.is_3d = 0 THEN
      execute immediate 'INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
                          VALUES (:1, :2,
                            MDSYS.SDO_DIM_ARRAY 
                            (
                              MDSYS.SDO_DIM_ELEMENT(''X'', 0.000, 10000000.000, 0.0005), 
                              MDSYS.SDO_DIM_ELEMENT(''Y'', 0.000, 10000000.000, 0.0005)), :3
                            )' using table_name, idx.attribute_name, srid;
    ELSE
      execute immediate 'INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
                          VALUES (:1, :2, 
                            MDSYS.SDO_DIM_ARRAY 
                            (
                              MDSYS.SDO_DIM_ELEMENT(''X'', 0.000, 10000000.000, 0.0005), 
                              MDSYS.SDO_DIM_ELEMENT(''Y'', 0.000, 10000000.000, 0.0005),
                              MDSYS.SDO_DIM_ELEMENT(''Z'', -1000, 10000, 0.0005)), :3
                            )' using table_name, idx.attribute_name, srid;
    END IF;    
  END;

  /*****************************************************************
  * create_index
  * 
  * @param idx index to create
  * @param is_versioned TRUE if database table is version-enabled
  * @return VARCHAR2 sql error code, 0 for no errors
  ******************************************************************/
  FUNCTION create_index(idx INDEX_OBJ, is_versioned BOOLEAN, params VARCHAR2 := '') RETURN VARCHAR2
  IS
    create_ddl VARCHAR2(1000);
    table_name VARCHAR2(100);
    sql_err_code VARCHAR2(20);
  BEGIN    
    IF index_status(idx) <> 'VALID' THEN
      sql_err_code := drop_index(idx, is_versioned);
            
      BEGIN
        table_name := idx.table_name;
      
        IF is_versioned THEN
          dbms_wm.BEGINDDL(idx.table_name);
          table_name := table_name || '_LTS';
        END IF;

        create_ddl := 'CREATE INDEX ' || idx.index_name || ' ON ' || table_name || '(' || idx.attribute_name || ')';

        IF idx.type = SPATIAL THEN
          create_spatial_metadata(idx, is_versioned);
          create_ddl := create_ddl || ' INDEXTYPE is MDSYS.SPATIAL_INDEX';
        END IF;

        IF params <> '' THEN
          create_ddl := create_ddl || ' ' || params;
        END IF;

        execute immediate create_ddl;
        
        IF is_versioned THEN
          dbms_wm.COMMITDDL(idx.table_name);
        END IF;
        
      EXCEPTION
        WHEN others THEN
          dbms_output.put_line(SQLERRM);
          
          IF is_versioned THEN
            dbms_wm.ROLLBACKDDL(idx.table_name);
          END IF;
          
          RETURN SQLCODE;
      END;
    END IF;
    
    RETURN '0';
  END;
  
  /*****************************************************************
  * drop_index
  * 
  * @param idx index to drop
  * @param is_versioned TRUE if database table is version-enabled
  * @return VARCHAR2 sql error code, 0 for no errors
  ******************************************************************/
  FUNCTION drop_index(idx INDEX_OBJ, is_versioned BOOLEAN) RETURN VARCHAR2
  IS
    index_name VARCHAR2(100);
  BEGIN
    IF index_status(idx) <> 'DROPPED' THEN
      BEGIN
        index_name := idx.index_name;
        
        IF is_versioned THEN
          dbms_wm.BEGINDDL(idx.table_name);
          index_name := index_name || '_LTS';
        END IF;
        
        execute immediate 'DROP INDEX ' || index_name;
        
        IF is_versioned THEN
          dbms_wm.COMMITDDL(idx.table_name);
        END IF;
      EXCEPTION
        WHEN others THEN
          dbms_output.put_line(SQLERRM);
          
          IF is_versioned THEN
            dbms_wm.ROLLBACKDDL(idx.table_name);
          END IF;
          
          RETURN SQLCODE;
      END;
    END IF;
    
    RETURN '0';
  END;

  /*****************************************************************
  * create_indexes
  * private convience method for invoking create_index on indexes 
  * of same index type
  * 
  * @param type type of index, e.g. SPATIAL or NORMAL
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_indexes(type SMALLINT) RETURN STRARRAY
  IS
    log STRARRAY;
    sql_error_code VARCHAR2(20);
  BEGIN    
    log := STRARRAY();
                
    FOR i IN INDICES.FIRST .. INDICES.LAST LOOP
      IF INDICES(i).type = type THEN
        sql_error_code := create_index(INDICES(i), geodb_util.versioning_table(INDICES(i).table_name) = 'ON');
        log.extend;
        log(log.count) := index_status(INDICES(i)) || ':' || INDICES(i).index_name || ':' || INDICES(i).table_name || ':' || INDICES(i).attribute_name || ':' || sql_error_code;
      END IF;
    END LOOP;     
    
    RETURN log;
  END;
  
  /*****************************************************************
  * drop_indexes
  * private convience method for invoking drop_index on indexes 
  * of same index type
  * 
  * @param type type of index, e.g. SPATIAL or NORMAL
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_indexes(type SMALLINT) RETURN STRARRAY
  IS
    log STRARRAY;
    sql_error_code VARCHAR2(20);
  BEGIN    
    log := STRARRAY();
    
    FOR i in INDICES.FIRST .. INDICES.LAST LOOP
      IF INDICES(i).type = type THEN
        sql_error_code := drop_index(INDICES(i), geodb_util.versioning_table(INDICES(i).table_name) = 'ON');
        log.extend;
        log(log.count) := index_status(INDICES(i)) || ':' || INDICES(i).index_name || ':' || INDICES(i).table_name || ':' || INDICES(i).attribute_name || ':' || sql_error_code;
      END IF;
    END LOOP; 
    
    RETURN log;
  END;
  
  /*****************************************************************
  * status_spatial_indexes
  * 
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION status_spatial_indexes RETURN STRARRAY
  IS
    log STRARRAY;
    status VARCHAR2(20);
  BEGIN
    log := STRARRAY();
  
    FOR i in INDICES.FIRST .. INDICES.LAST LOOP
      IF INDICES(i).type = SPATIAL THEN
        status := index_status(INDICES(i));
        log.extend;
        log(log.count) := status || ':' || INDICES(i).index_name || ':' || INDICES(i).table_name || ':' || INDICES(i).attribute_name;
      END IF;
    END LOOP;      

    RETURN log;
  END;
  
  /*****************************************************************
  * status_normal_indexes
  * 
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION status_normal_indexes RETURN STRARRAY
  IS
    log STRARRAY;
    status VARCHAR2(20);
  BEGIN
    log := STRARRAY();
  
    FOR i in INDICES.FIRST .. INDICES.LAST LOOP
      IF INDICES(i).type = NORMAL THEN
        status := index_status(INDICES(i));
        log.extend;
        log(log.count) := status || ':' || INDICES(i).index_name || ':' || INDICES(i).table_name || ':' || INDICES(i).attribute_name;
      END IF;
    END LOOP;      

    RETURN log;
  END;

  /*****************************************************************
  * create_spatial_indexes
  * convience method for invoking create_index on all spatial 
  * indexes 
  * 
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_spatial_indexes RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    return create_indexes(SPATIAL);
  END;

  /*****************************************************************
  * drop_spatial_indexes
  * convience method for invoking drop_index on all spatial 
  * indexes 
  * 
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_spatial_indexes RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    return drop_indexes(SPATIAL);
  END;
  
  /*****************************************************************
  * create_normal_indexes
  * convience method for invoking create_index on all normal 
  * indexes 
  * 
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_normal_indexes RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    return create_indexes(NORMAL);
  END;

  /*****************************************************************
  * drop_normal_indexes
  * convience method for invoking drop_index on all normal 
  * indexes 
  * 
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_normal_indexes RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    return drop_indexes(NORMAL);
  END;    


  /*****************************************************************
  * get_index
  * convience method for getting an index object 
  * given the table and column it indexes
  * 
  * @param table_name
  * @param attribute_name
  * @return INDEX_OBJ
  ******************************************************************/
  FUNCTION get_index(table_name VARCHAR2, column_name VARCHAR2) RETURN INDEX_OBJ
  IS
    idx INDEX_OBJ;
  BEGIN    
    
    FOR i in INDICES.FIRST .. INDICES.LAST LOOP
      IF INDICES(i).attribute_name = UPPER(column_name) AND INDICES(i).table_name = UPPER(table_name) THEN
        idx := INDICES(i);
        EXIT;
      END IF;
    END LOOP; 
    
    RETURN idx;
  END;
END geodb_idx;
/