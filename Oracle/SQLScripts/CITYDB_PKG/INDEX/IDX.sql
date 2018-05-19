-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2018
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
* TYPE INDEX_OBJ
* 
* global type to store information relevant to indexes
******************************************************************/
CREATE OR REPLACE TYPE INDEX_OBJ AS OBJECT
  (index_name VARCHAR2(30),
   table_name VARCHAR2(30),
   attribute_name VARCHAR2(30),
   parameters VARCHAR2(256),
   type NUMBER(1),
   srid NUMBER,
   is_3d NUMBER(1, 0),
     STATIC function construct_spatial_3d
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, parameters VARCHAR2 := NULL, srid NUMBER := 0)
     RETURN INDEX_OBJ,
     STATIC function construct_spatial_2d
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, parameters VARCHAR2 := NULL, srid NUMBER := 0)
     RETURN INDEX_OBJ,
     STATIC function construct_normal
     (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, parameters VARCHAR2 := NULL, srid NUMBER := 0)
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
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, parameters VARCHAR2 := NULL, srid NUMBER := 0)
  RETURN INDEX_OBJ IS
  BEGIN
    RETURN INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), parameters, 1, srid, 1);
  END;
  STATIC FUNCTION construct_spatial_2d
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, parameters VARCHAR2 := NULL, srid NUMBER := 0)
  RETURN INDEX_OBJ IS
  BEGIN
    RETURN INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), parameters, 1, srid, 0);
  END;
  STATIC FUNCTION construct_normal
  (index_name VARCHAR2, table_name VARCHAR2, attribute_name VARCHAR2, parameters VARCHAR2 := NULL, srid NUMBER := 0)
  RETURN INDEX_OBJ IS
  BEGIN
    RETURN INDEX_OBJ(upper(index_name), upper(table_name), upper(attribute_name), parameters, 0, srid, 0);
  END;
END;
/

/******************************************************************
* INDEX_TABLE that holds INDEX_OBJ instances
* 
******************************************************************/
CREATE TABLE INDEX_TABLE (
  ID NUMBER PRIMARY KEY,
  obj INDEX_OBJ
);

CREATE SEQUENCE INDEX_TABLE_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1;

/******************************************************************
* Populate INDEX_TABLE with INDEX_OBJ instances
* 
******************************************************************/
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('CITYOBJECT_ENVELOPE_SPX', 'CITYOBJECT', 'ENVELOPE', 'PARALLEL'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('SURFACE_GEOM_SPX', 'SURFACE_GEOMETRY', 'GEOMETRY', 'PARALLEL'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('SURFACE_GEOM_SOLID_SPX', 'SURFACE_GEOMETRY', 'SOLID_GEOMETRY', 'PARAMETERS (''sdo_indx_dims=3'') PARALLEL'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('CITYOBJECT_INX', 'CITYOBJECT', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('CITYOBJECT_LINEAGE_INX', 'CITYOBJECT', 'LINEAGE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('SURFACE_GEOM_INX', 'SURFACE_GEOMETRY', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('APPEARANCE_INX', 'APPEARANCE', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('APPEARANCE_THEME_INX', 'APPEARANCE', 'THEME'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('SURFACE_DATA_INX', 'SURFACE_DATA', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('ADDRESS_INX', 'ADDRESS', 'GMLID, GMLID_CODESPACE'));
COMMIT;

/*****************************************************************
* PACKAGE citydb_idx
* 
* utility methods for index handling
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_idx AUTHID CURRENT_USER
AS
  FUNCTION index_status(idx INDEX_OBJ, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION index_status(idx_table_name VARCHAR2, idx_column_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION status_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION status_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION create_index(idx INDEX_OBJ, is_versioned BOOLEAN, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION drop_index(idx INDEX_OBJ, is_versioned BOOLEAN, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION create_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION drop_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION create_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION drop_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION get_index(idx_table_name VARCHAR2, idx_column_name VARCHAR2) RETURN INDEX_OBJ;
END citydb_idx;
/

CREATE OR REPLACE PACKAGE BODY citydb_idx
AS 
  NORMAL CONSTANT NUMBER(1) := 0;
  SPATIAL CONSTANT NUMBER(1) := 1;

  /*****************************************************************
  * index_status
  * 
  * @param idx index to retrieve status from
  * @param schema_name target schema to retrieve status from
  * @return VARCHAR2 string representation of status, may include
  *                  'DROPPED', 'VALID', 'FAILED', 'INVALID'
  ******************************************************************/
  FUNCTION index_status(
    idx INDEX_OBJ,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2
  IS
    status VARCHAR2(20);
  BEGIN
    IF idx.type = SPATIAL THEN
      SELECT
        upper(domidx_opstatus)
      INTO
        status
      FROM
        all_indexes
      WHERE
        owner = upper(schema_name)
        AND index_name = idx.index_name;
    ELSE
      SELECT
        upper(status)
      INTO
        status
      FROM
        all_indexes
      WHERE
        owner = upper(schema_name)
        AND index_name = idx.index_name;
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
  * @param idx_table_name table_name of index to retrieve status from
  * @param idx_column_name column_name of index to retrieve status from
  * @param schema_name schema_name of index to retrieve status from
  * @return VARCHAR2 string representation of status, may include
  *                  'DROPPED', 'VALID', 'FAILED', 'INVALID'
  ******************************************************************/
  FUNCTION index_status(
    idx_table_name VARCHAR2, 
    idx_column_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2
  IS
    internal_table_name VARCHAR2(100);
    idx_type VARCHAR2(35);
    idx_name VARCHAR2(35);
    status VARCHAR2(20);
  BEGIN
    internal_table_name := upper(idx_table_name);

    IF citydb_util.versioning_table(idx_table_name, schema_name) = 'ON' THEN
      internal_table_name := internal_table_name || '_LT';
    END IF;

    SELECT
      upper(index_type),
      index_name
    INTO
      idx_type,
      idx_name
    FROM
      all_indexes
    WHERE
      owner = upper(schema_name)
      AND index_name = (
        SELECT
          upper(index_name)
        FROM
          all_ind_columns
        WHERE index_owner = upper(schema_name)
          AND table_name = internal_table_name
          AND column_name = upper(idx_column_name)
      );

    IF idx_type = 'DOMAIN' THEN
      SELECT
        upper(domidx_opstatus)
      INTO
        status
      FROM
        all_indexes
      WHERE
        owner = upper(schema_name)
        AND index_name = idx_name;
    ELSE
      SELECT
        upper(status)
      INTO
        status
      FROM
        all_indexes
      WHERE
        owner = upper(schema_name)
        AND index_name = idx_name;
    END IF;

    RETURN status;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'DROPPED';
    WHEN others THEN
      RETURN 'INVALID';
  END;

  /*****************************************************************
  * create_index
  * 
  * @param idx index to create
  * @param is_versioned TRUE if database table is version-enabled
  * @param schema_name target schema where to create the index
  * @return VARCHAR2 sql error code, 0 for no errors
  ******************************************************************/
  FUNCTION create_index(
    idx INDEX_OBJ,
    is_versioned BOOLEAN, 
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2
  IS
    create_ddl VARCHAR2(1000);
    table_name VARCHAR2(100);
    sql_err_code VARCHAR2(20);
  BEGIN    
    IF index_status(idx, schema_name) <> 'VALID' THEN
      sql_err_code := drop_index(idx, is_versioned);

      BEGIN
        table_name := idx.table_name;

        IF is_versioned THEN
          dbms_wm.BEGINDDL(idx.table_name);
          table_name := table_name || '_LTS';
        END IF;

        create_ddl :=
          'CREATE INDEX '
          || upper(schema_name) || '.' || idx.index_name
          || ' ON ' || upper(schema_name) || '.' || table_name
          || ' (' || idx.attribute_name || ')';

        IF idx.type = SPATIAL THEN
          create_ddl := create_ddl || ' INDEXTYPE is MDSYS.SPATIAL_INDEX';
        END IF;

        IF idx.parameters is not null THEN
          create_ddl := create_ddl || ' ' || idx.parameters;
        END IF;

        EXECUTE IMMEDIATE create_ddl;

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
  * @param schema_name target schema where to drop the index
  * @return VARCHAR2 sql error code, 0 for no errors
  ******************************************************************/
  FUNCTION drop_index(
    idx INDEX_OBJ, 
    is_versioned BOOLEAN,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2
  IS
    index_name VARCHAR2(100);
  BEGIN
    IF index_status(idx, schema_name) <> 'DROPPED' THEN
      BEGIN
        index_name := idx.index_name;

        IF is_versioned THEN
          dbms_wm.BEGINDDL(idx.table_name);
          index_name := index_name || '_LTS';
        END IF;

        EXECUTE IMMEDIATE 'DROP INDEX ' || upper(schema_name) || '.' || index_name;

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
  * private convenience method for invoking create_index on indexes 
  * of same index type
  * 
  * @param idx_type type of index, e.g. SPATIAL or NORMAL
  * @param schema_name target schema for indexes to be created
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_indexes(
    idx_type SMALLINT, 
    schema_name VARCHAR2 := USER
    ) RETURN STRARRAY
  IS
    idx_log STRARRAY;
    sql_error_code VARCHAR2(20);
  BEGIN
    idx_log := STRARRAY();

    FOR rec IN
      (SELECT * FROM index_table WHERE (obj).type = idx_type)
    LOOP
      sql_error_code := create_index(rec.obj, citydb_util.versioning_table(rec.obj.table_name, schema_name) = 'ON', schema_name);
      idx_log.extend;
      idx_log(idx_log.count) := index_status(rec.obj, schema_name)
        || ':' || rec.obj.index_name
        || ':' || upper(schema_name)
        || ':' || rec.obj.table_name
        || ':' || rec.obj.attribute_name
        || ':' || sql_error_code;
    END LOOP;

    RETURN idx_log;
  END;
  
  /*****************************************************************
  * drop_indexes
  * private convenience method for invoking drop_index on indexes 
  * of same index type
  * 
  * @param idx_type type of index, e.g. SPATIAL or NORMAL
  * @param schema_name target schema for indexes to be dropped
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_indexes(idx_type SMALLINT, schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    idx_log STRARRAY;
    sql_error_code VARCHAR2(20);
  BEGIN
    idx_log := STRARRAY();

    FOR rec IN
      (SELECT * FROM index_table WHERE (obj).type = idx_type)
    LOOP
      sql_error_code := drop_index(rec.obj, citydb_util.versioning_table(rec.obj.table_name, schema_name) = 'ON', schema_name);
      idx_log.extend;
      idx_log(idx_log.count) := index_status(rec.obj, schema_name)
        || ':' || rec.obj.index_name
        || ':' || upper(schema_name)
        || ':' || rec.obj.table_name
        || ':' || rec.obj.attribute_name
        || ':' || sql_error_code;
    END LOOP;

    RETURN idx_log;
  END;

  /*****************************************************************
  * status_spatial_indexes
  * 
  * @param schema_name target schema of indexes to retrieve status from
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION status_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    idx_log STRARRAY;
    status VARCHAR2(20);
  BEGIN
    idx_log := STRARRAY();

    FOR rec IN
      (SELECT * FROM index_table WHERE (obj).type = SPATIAL)
    LOOP
      status := index_status(rec.obj, schema_name);
      idx_log.extend;
      idx_log(idx_log.count) := status
        || ':' || rec.obj.index_name
        || ':' || upper(schema_name)
        || ':' || rec.obj.table_name
        || ':' || rec.obj.attribute_name;
    END LOOP;

    RETURN idx_log;
  END;

  /*****************************************************************
  * status_normal_indexes
  * 
  * @param schema_name target schema of indexes to retrieve status from
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION status_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    idx_log STRARRAY;
    status VARCHAR2(20);
  BEGIN
    idx_log := STRARRAY();

    FOR rec IN
      (SELECT * FROM index_table WHERE (obj).type = NORMAL)
    LOOP
      status := index_status(rec.obj, schema_name);
      idx_log.extend;
      idx_log(idx_log.count) := status
        || ':' || rec.obj.index_name
        || ':' || upper(schema_name)
        || ':' || rec.obj.table_name
        || ':' || rec.obj.attribute_name;
    END LOOP;

    RETURN idx_log;
  END;

  /*****************************************************************
  * create_spatial_indexes
  * convenience method for invoking create_index on all spatial indexes 
  * 
  * @param schema_name target schema for indexes to be created
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN create_indexes(SPATIAL, schema_name);
  END;

  /*****************************************************************
  * drop_spatial_indexes
  * convenience method for invoking drop_index on all spatial indexes 
  * 
  * @param schema_name target schema for indexes to be dropped
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_spatial_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN drop_indexes(SPATIAL, schema_name);
  END;

  /*****************************************************************
  * create_normal_indexes
  * convenience method for invoking create_index on all normal indexes 
  * 
  * @param schema_name target schema for indexes to be created
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION create_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN create_indexes(NORMAL, schema_name);
  END;

  /*****************************************************************
  * drop_normal_indexes
  * convenience method for invoking drop_index on all normal indexes 
  * 
  * @param schema_name target schema for indexes to be dropped
  * @return STRARRAY array of log message strings
  ******************************************************************/
  FUNCTION drop_normal_indexes(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
  BEGIN
    dbms_output.enable;
    RETURN drop_indexes(NORMAL, schema_name);
  END;

  /*****************************************************************
  * get_index
  * convenience method for getting an index object 
  * given the schema.table and column it indexes
  * 
  * @param idx_table_name
  * @param idx_column_name
  * @return INDEX_OBJ
  ******************************************************************/
  FUNCTION get_index(
    idx_table_name VARCHAR2, 
    idx_column_name VARCHAR2
    ) RETURN INDEX_OBJ
  IS
    idx INDEX_OBJ;
  BEGIN
    SELECT
      obj
    INTO
      idx
    FROM
      index_table
    WHERE
      (obj).table_name = upper(idx_table_name)
      AND (obj).attribute_name = upper(idx_column_name);

    RETURN idx;
  END;
END citydb_idx;
/