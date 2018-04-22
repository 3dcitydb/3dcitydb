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
* PACKAGE citydb_const
* 
* methods to handle database constraints
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_const
AS
  PROCEDURE set_fkey_delete_rule(fkey_name VARCHAR2, table_name VARCHAR2, column_name VARCHAR2, ref_table VARCHAR2, ref_column VARCHAR2, on_delete_param CHAR := 'a', schema_name VARCHAR2 := USER);
  PROCEDURE set_schema_fkeys_delete_rule(on_delete_param CHAR := 'a', schema_name VARCHAR2 := USER);
  PROCEDURE set_enabled_fkey(fkey_name VARCHAR2, table_name VARCHAR2, enable BOOLEAN := TRUE, schema_name VARCHAR2 := USER);
  PROCEDURE set_enabled_geom_fkeys(enable BOOLEAN := TRUE, schema_name VARCHAR2 := USER);
  PROCEDURE set_enabled_schema_fkeys(enable BOOLEAN := TRUE, schema_name VARCHAR2 := USER);
  PROCEDURE set_column_sdo_metadata(geom_column_name VARCHAR2, geom_dim NUMBER, schema_srid NUMBER, geom_table_name VARCHAR2, schema_name VARCHAR2 := USER);
  PROCEDURE set_schema_sdo_metadata(schema_name VARCHAR2 := USER);
END citydb_const;
/

CREATE OR REPLACE PACKAGE BODY citydb_const
AS

  /******************************************************************
  * set_fkey_delete_rule
  *
  * Removes a constraint to add it again with given ON DELETE parameter
  *
  * @param fkey_name name of the foreign key that is updated 
  * @param table_name defines the table to which the constraint belongs to
  * @param column_name defines the column the constraint is relying on
  * @param ref_table name of referenced table
  * @param ref_column name of referencing column of referenced table
  * @param delete_param whether NO ACTION, RESTIRCT, CASCADE or SET NULL
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE set_fkey_delete_rule(
    fkey_name VARCHAR2,
    table_name VARCHAR2,
    column_name VARCHAR2,
    ref_table VARCHAR2,
    ref_column VARCHAR2,
    on_delete_param CHAR := 'a',
    schema_name VARCHAR2 := USER
    )
  IS
    delete_param VARCHAR2(20);
  BEGIN
    IF citydb_util.versioning_table(table_name, schema_name) = 'ON' OR citydb_util.versioning_table(ref_table, schema_name) = 'ON' THEN
      dbms_output.put_line('Can not perform operation with version enabled tables.');
      RETURN;
    END IF;

    CASE on_delete_param
      WHEN 'c' THEN delete_param := ' ON DELETE CASCADE';
      WHEN 'n' THEN delete_param := ' ON DELETE SET NULL';
      ELSE delete_param := '';
    END CASE;

    EXECUTE IMMEDIATE 
      'ALTER TABLE '
      || upper(schema_name) || '.' || upper(table_name)
      || ' DROP CONSTRAINT ' || upper(fkey_name);
    EXECUTE IMMEDIATE
      'ALTER TABLE '
      || upper(schema_name) || '.' || upper(table_name)
      || ' ADD CONSTRAINT ' || upper(fkey_name)
      || ' FOREIGN KEY (' || upper(column_name) || ')'
      || ' REFERENCES ' || upper(schema_name) || '.' || upper(ref_table) || '(' || upper(ref_column) || ')'
      || delete_param;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('Error on constraint ' || fkey_name || ': ' || SQLERRM);
  END;

  /******************************************************************
  * set_schema_fkeys_delete_rule
  *
  * calls set_fkey_delete_rule for updating all the constraints
  * in the specified schema where options for on_delete_param are:
  * a = NO ACTION
  * c = CASCADE
  * n = SET NULL
  *
  * @param on_delete_param default is 'a' = NO ACTION
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE set_schema_fkeys_delete_rule(
    on_delete_param CHAR := 'a',
    schema_name VARCHAR2 := USER
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT
        acc1.constraint_name AS fkey,
        acc1.table_name AS t,
        acc1.column_name AS c, 
        ac2.table_name AS ref_t,
        acc2.column_name AS ref_c,
        acc1.owner AS schema
      FROM
        all_cons_columns acc1
      JOIN
        all_constraints ac1
        ON acc1.constraint_name = ac1.constraint_name
       AND acc1.owner = ac1.owner 
       AND acc1.table_name = ac1.table_name
      JOIN
        all_constraints ac2
        ON acc1.constraint_name = ac2.constraint_name
       AND acc1.owner = ac2.owner 
       AND acc1.table_name = ac2.table_name
      JOIN
        all_cons_columns acc2
        ON ac2.owner = acc2.owner 
       AND ac2.constraint_name = acc2.constraint_name 
       AND acc2.position = acc1.position     
      WHERE
        acc1.owner = upper(schema_name)
        AND ac1.constraint_type = 'R'
    ) LOOP
      set_fkey_delete_rule(rec.fkey, rec.t, rec.c, rec.ref_t, rec.ref_c, on_delete_param, schema_name);
    END LOOP;
  END;


  /******************************************************************
  * set_enabled_fkey
  *
  * Enables or disables a certain foreign key for a given table
  *
  * @param fkey_name name of the foreign key that is updated
  * @param enable boolean flag to toggle constraint
  * @param table_name defines the table to which the constraint belongs to
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE set_enabled_fkey(
    fkey_name VARCHAR2,
    table_name VARCHAR2,
    enable BOOLEAN := TRUE,
    schema_name VARCHAR2 := USER
    )
  IS
  BEGIN
    EXECUTE IMMEDIATE 
      'ALTER TABLE '
      || upper(schema_name) || '.' || upper(table_name)
      || CASE WHEN enable THEN ' ENABLE' ELSE ' DISABLE' END
      ||' CONSTRAINT ' || upper(fkey_name);
  END;

  /******************************************************************
  * set_enabled_geom_fkeys
  *
  * enables/disables references to SURFACE_GEOMETRY table
  *
  * @param enable boolean flag to toggle constraint
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE set_enabled_geom_fkeys(
    enable BOOLEAN := TRUE,
    schema_name VARCHAR2 := USER
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT
        constraint_name AS fkey,
        table_name AS t
      FROM
        all_constraints
      WHERE
        owner = upper(USER)
        AND constraint_type = 'R'
        AND r_constraint_name = 'SURFACE_GEOMETRY_PK'
    ) LOOP
      set_enabled_fkey(rec.fkey, rec.t, enable, schema_name);
    END LOOP;
  END;

  /******************************************************************
  * set_enabled_geom_fkeys
  *
  * enables/disables all foreign keys in a given schema
  *
  * @param enable boolean flag to toggle constraint
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE set_enabled_schema_fkeys(
    enable BOOLEAN := TRUE,
    schema_name VARCHAR2 := USER
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT
        constraint_name AS fkey,
        table_name AS t
      FROM
        all_constraints
      WHERE
        owner = upper(USER)
        AND constraint_type = 'R'
    ) LOOP
      set_enabled_fkey(rec.fkey, rec.t, enable, schema_name);
    END LOOP;
  END;

  /*****************************************************************
  * set_column_sdo_metadata
  * 
  * @param geom_column_name name of spatial column to create entry in user_sdo_geom_metadata
  * @param geom_dim number of dimensions used for spatial column
  * @param schema_srid reference system used for spatial column
  * @param geom_table_name name of table with spatial column(s)
  * @param schema_name name of schema
  ******************************************************************/
  PROCEDURE set_column_sdo_metadata(
    geom_column_name VARCHAR2,
    geom_dim NUMBER,
    schema_srid NUMBER,
    geom_table_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    tab_name VARCHAR2(30);
  BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION set NLS_TERRITORY=''AMERICA''';
    EXECUTE IMMEDIATE 'ALTER SESSION set NLS_LANGUAGE=''AMERICAN''';

    -- check if table is versioned
    IF citydb_util.versioning_table(geom_table_name, schema_name) = 'ON' THEN
      tab_name := upper(geom_table_name) || '_LT';
    ELSE
      tab_name := upper(geom_table_name);
    END IF;

    -- first delete entry from USER_SDO_GEOM_METADATA
    BEGIN
      DELETE FROM user_sdo_geom_metadata WHERE table_name = tab_name AND column_name = upper(geom_column_name);
    END;

    -- insert new entry depending on dimension
    IF geom_dim = 2 THEN
      INSERT INTO user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
      VALUES (
        tab_name,
        upper(geom_column_name),
        MDSYS.SDO_DIM_ARRAY(
          MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
          MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005)
        ),
         schema_srid
        );
    ELSE
      INSERT INTO user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
      VALUES (
        tab_name,
        upper(geom_column_name),
        MDSYS.SDO_DIM_ARRAY(
          MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
          MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),
          MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)
        ),
         schema_srid
        );
    END IF;
  END;

  /*****************************************************************
  * set_schema_sdo_metadata
  *
  * sets spatial metadata for all spatial columns in given schema
  *
  * @param schema_name name of schema
  ******************************************************************/
  PROCEDURE set_schema_sdo_metadata(
    schema_name VARCHAR2 := USER
  )
  IS
    schema_srid DATABASE_SRS.SRID%TYPE;
  BEGIN
    -- get schema srid from DATABASE_SRS
    EXECUTE IMMEDIATE
      'SELECT srid FROM '|| schema_name ||'.database_srs'
       INTO schema_srid;

    -- fetch all spatial columns in given schema
    FOR rec IN (
      SELECT
        column_name AS c,
        table_name AS t
      FROM
        all_tab_columns
      WHERE
        owner = upper(schema_name)
        AND data_type = 'SDO_GEOMETRY'
    )
    LOOP
      -- handle edge cases
      IF rec.t = 'TEXTUREPARAM' AND rec.c = 'TEXTURE_COORDINATES' THEN
        set_column_sdo_metadata(rec.c, 2, 0, rec.t, schema_name);
      ELSIF rec.t = 'IMPLICIT_GEOMETRY' OR rec.c = 'IMPLICIT_GEOMETRY' THEN
        set_column_sdo_metadata(rec.c, 3, 0, rec.t, schema_name);
      ELSIF rec.t = 'RELIEF_COMPONENT' AND rec.c = 'EXTENT' 
         OR rec.t = 'SURFACE_DATA' AND rec.c = 'GT_REFERENCE_POINT' THEN
        set_column_sdo_metadata(rec.c, 2, schema_srid, rec.t, schema_name);
      ELSE
        -- use 3rd dim and schema srid by default
        set_column_sdo_metadata(rec.c, 3, schema_srid, rec.t, schema_name);
      END IF;
    END LOOP;
    dbms_output.put_line('Spatial metadata sucessfully set for ' || schema_name);
  END;

END citydb_const;
/