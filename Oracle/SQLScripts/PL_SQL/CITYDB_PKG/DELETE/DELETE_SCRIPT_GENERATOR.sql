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
* PACKAGE citydb_delete_gen
* 
* methods to create delete scripts automatically
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_delete_gen AUTHID CURRENT_USER
AS
  FUNCTION check_for_cleanup(tab_name VARCHAR2, schema_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE create_array_delete_function(tab_name VARCHAR2, schema_name VARCHAR2 := USER);
  PROCEDURE create_delete_function(tab_name VARCHAR2, schema_name VARCHAR2 := USER);
END citydb_delete_gen;
/

CREATE OR REPLACE PACKAGE BODY citydb_delete_gen
AS
  FUNCTION get_short_name(tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION query_selfref_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  FUNCTION gen_delete_selfref_by_ids_call(tab_name VARCHAR2, self_fk_column_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE create_selfref_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, self_block OUT VARCHAR2);
  FUNCTION gen_delete_selfref_by_id_call(tab_name VARCHAR2, self_fk_column_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE create_selfref_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, self_block OUT VARCHAR2);
  FUNCTION query_ref_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  FUNCTION gen_delete_ref_by_ids_stmt(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_ref_by_ids_call(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_ids_stmt(m_tab_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_ids_call(m_tab_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_ids_stmt(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_ids_call(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE create_ref_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  FUNCTION gen_delete_ref_by_id_stmt(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_ref_by_id_call(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_id_stmt(m_tab_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_id_call(m_tab_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_id_stmt(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_id_call(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE create_ref_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  FUNCTION query_ref_to_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  PROCEDURE create_ref_to_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, returning_block OUT VARCHAR2, collect_block OUT VARCHAR2, into_block OUT VARCHAR2, fk_block OUT VARCHAR2);
  PROCEDURE create_ref_to_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, returning_block OUT VARCHAR2, into_block OUT VARCHAR2, fk_block OUT VARCHAR2);
  FUNCTION query_ref_parent_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION create_ref_parent_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION create_ref_parent_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_array_delete_dummy(tab_name VARCHAR2);

  /*
  A delete function can consist of up to five parts:
    1. A recursive delete call, if the relation stores tree structures, the FK is set to NO ACTION and parent_id can be NULL
    2. Delete statements (or procedure call) for referencing tables where the FK is set to NO ACTION
    3. The central delete statement that removes the given entry/ies and returns the deleted IDs
    4. Deletes for unreferenced entries in tables where the FK is set to SET NULL or CASCADE when it is a n:m table
    5. If an FK covers the same column(s) as the PK, the referenced parent has to be deleted as well
  */

  FUNCTION get_short_name(tab_name VARCHAR2) RETURN VARCHAR2
  IS
  BEGIN
    -- TODO: query a table that stores the short version of a table (maybe objectclass?)
    RETURN substr(tab_name, 1, 17);
  END;

  --if referencing table requires an extra cleanup step, it needs its own delete function
  FUNCTION check_for_cleanup(
    tab_name VARCHAR2,
    schema_name VARCHAR2
  ) RETURN VARCHAR2
  IS
    cleanup_ref_table VARCHAR2(30);
  BEGIN
    SELECT
      COALESCE((
        -- reference to parent
        SELECT
          fk2.table_name
        FROM
          all_constraints fk
        JOIN
          all_cons_columns fka
          ON fka.constraint_name = fk.constraint_name
         AND fka.table_name = fk.table_name
         AND fka.owner = fk.owner
        JOIN
          all_constraints fk2
          ON fk2.constraint_name = fk.r_constraint_name
          AND fk2.owner = fk.owner
        JOIN (
          SELECT DISTINCT
            cp.table_name,
            cp.owner,
            first_value(pka.column_name) OVER (PARTITION BY cp.table_name ORDER BY pka.position DESC) AS column_name,
            first_value(pka.position) OVER (PARTITION BY cp.table_name ORDER BY pka.position DESC) AS position
          FROM
            all_constraints cp
          JOIN
            all_cons_columns pka
            ON pka.constraint_name = cp.constraint_name
           AND pka.table_name = cp.table_name
           AND pka.owner = cp.owner
          WHERE
            cp.constraint_type = 'P'
          ) pk
          ON pk.table_name = fk.table_name
         AND pk.owner = fk.owner
         AND pk.column_name = fka.column_name
        WHERE
          fk.table_name = tab_name
          AND fk.owner = schema_name
          AND fk.constraint_type = 'R'
          AND fk.delete_rule = 'NO ACTION'
          AND pk.position = 1
      ),(
        -- referencing tables
        SELECT DISTINCT
          c2.table_name
        FROM
          all_constraints c
        JOIN
          all_constraints c2
          ON c2.constraint_name = c.r_constraint_name
         AND c2.owner = c.owner
        WHERE
          c2.table_name = tab_name
          AND c2.owner = schema_name
          AND c.constraint_type = 'R'
          AND c.delete_rule = 'NO ACTION'
      ),(
        -- references to tables that need to be cleaned up
        SELECT DISTINCT
          c.table_name
        FROM
          all_constraints c
        JOIN
          all_constraints c2
          ON c2.constraint_name = c.r_constraint_name
         AND c2.owner = c.owner
        WHERE
          c.table_name = tab_name
          AND c.owner = schema_name
          AND c.constraint_type = 'R'
          AND c.delete_rule = 'SET NULL'
          AND (c2.table_name <> 'SURFACE_GEOMETRY'
           OR c.table_name = 'IMPLICIT_GEOMETRY'
           OR c.table_name = 'CITYOBJECT_GENERICATTRIB'
           OR c.table_name = 'CITYOBJECTGROUP')
      )) AS cleanup
      INTO
        cleanup_ref_table
      FROM
        dual;

    RETURN cleanup_ref_table;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN '';
  END;


  /*****************************
  * 1. Self references
  *
  * Look for nullable FK columns to omit root_id column
  *****************************/
  FUNCTION query_selfref_fk(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN SYS_REFCURSOR 
  IS
    self_cursor SYS_REFCURSOR;
  BEGIN
    OPEN self_cursor FOR
      SELECT
        a.column_name
      FROM
        all_constraints c
      JOIN
        all_cons_columns ac
        ON ac.constraint_name = c.constraint_name
       AND ac.table_name = c.table_name
       AND ac.owner = c.owner
      JOIN
        all_constraints c2
        ON c2.constraint_name = c.r_constraint_name
       AND c2.owner = c.owner
      JOIN
        all_tab_columns a
        ON a.column_name = ac.column_name
       AND a.table_name = ac.table_name
       AND a.owner = ac.owner
      WHERE 
        c.table_name = upper(tab_name)
        AND c.owner = upper(schema_name)
        AND c.table_name = c2.table_name
        AND c.constraint_type = 'R'
        AND c.delete_rule = 'NO ACTION'
        AND a.nullable = 'Y';
    RETURN self_cursor;
  END;

  -- ARRAY CASE
  FUNCTION gen_delete_selfref_by_ids_call(
    tab_name VARCHAR2,
    self_fk_column_name VARCHAR2
  ) RETURN VARCHAR2
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete referenced parts'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    t.id'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    part_ids'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||lower(tab_name)||' t,'
      ||chr(10)||'    TABLE(arr) a'
      ||chr(10)||'  WHERE'
      ||chr(10)||'    t.'||lower(self_fk_column_name)||' = a.COLUMN_VALUE'
      ||chr(10)||'    AND t.id != a.COLUMN_VALUE;'
      ||chr(10)
      ||chr(10)||'  IF part_ids.COUNT > 0 THEN'
      ||chr(10)||'    dummy_ids := delete_'||get_short_name(lower(tab_name))||'_batch(part_ids);'
      ||chr(10)||'  END IF;';
  END;

  PROCEDURE create_selfref_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    self_block OUT VARCHAR2
    ) 
  IS
    self_cursor SYS_REFCURSOR;
    parent_column VARCHAR2(30);
  BEGIN
    self_cursor := query_selfref_fk(tab_name, schema_name);

    LOOP
      FETCH self_cursor
      INTO parent_column;
      EXIT WHEN self_cursor%NOTFOUND;

      IF self_block IS NULL THEN
        -- create a dummy array delete function to avoid endless recursive calls
        create_array_delete_dummy(tab_name);
        vars := chr(10)|| '  part_ids ID_ARRAY;';
        self_block := '';
      END IF;

      self_block := self_block || gen_delete_selfref_by_ids_call(tab_name, parent_column);
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  FUNCTION gen_delete_selfref_by_id_call(
    tab_name VARCHAR2,
    self_fk_column_name VARCHAR2
  ) RETURN VARCHAR2
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete referenced parts'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    id'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    part_ids'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||lower(tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(self_fk_column_name)||' = pid'
      ||chr(10)||'    AND id != pid;'
      ||chr(10)
      ||chr(10)||'  IF part_ids.COUNT > 0 THEN'
      ||chr(10)||'    dummy_ids := delete_'||get_short_name(lower(tab_name))||'_batch(part_ids);'
      ||chr(10)||'  END IF;';
  END;

  PROCEDURE create_selfref_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    self_block OUT VARCHAR2
    ) 
  IS
    self_cursor SYS_REFCURSOR;
    parent_column VARCHAR2(30);
  BEGIN
    self_cursor := query_selfref_fk(tab_name, schema_name);

    LOOP
      FETCH self_cursor
      INTO parent_column;
      EXIT WHEN self_cursor%NOTFOUND;

      IF self_block IS NULL THEN
        -- create an array delete function
        citydb_delete_gen.create_array_delete_function(tab_name, schema_name);
        vars := chr(10)|| '  part_ids ID_ARRAY;';
        self_block := '';
      END IF;

      self_block := self_block || gen_delete_selfref_by_id_call(tab_name, parent_column);
    END LOOP;

    RETURN;
  END;


  /*****************************
  * 2. Referencing tables
  *****************************/  
  FUNCTION query_ref_fk(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN SYS_REFCURSOR 
  IS
    ref_cursor SYS_REFCURSOR;
  BEGIN
    OPEN ref_cursor FOR
      SELECT
        n_table,
        fk_n_column_name,
        ref_depth,
        clean_n_parent AS cleanup_n_table,
        m_table,
        fk_m_column_name,
        clean_m_parent AS cleanup_m_table
      FROM (
        SELECT
          c2.table_name AS root_table,
          c.table_name AS n_table,
          a.column_name AS fk_n_column_name,
          COALESCE(n.ref_depth, 1) AS ref_depth,
          citydb_delete_gen.check_for_cleanup(c.table_name, c.owner) AS clean_n_parent,
          m.m_table,
          m.fk_m_column_name,
          citydb_delete_gen.check_for_cleanup(m.m_table, m.owner) AS clean_m_parent
        FROM
          all_constraints c
        JOIN
          all_cons_columns a
          ON a.constraint_name = c.constraint_name
         AND a.table_name = c.table_name
         AND a.owner = c.owner
        JOIN
          all_constraints c2
          ON c2.constraint_name = c.r_constraint_name
         AND c2.owner = c.owner
        LEFT JOIN (
          -- get depth of referencing tables
          SELECT
            r.parent_table,
            r.owner,
            max(LEVEL) AS ref_depth
          FROM (
            SELECT
              n2.table_name AS parent_table,
              n.table_name AS ref_table,
              n.owner
            FROM
              all_constraints n
            JOIN
              all_constraints n2
              ON n2.constraint_name = n.r_constraint_name
             AND n2.owner = n.owner
            WHERE
              n2.owner = upper(schema_name)
              AND n.table_name <> n2.table_name
              AND n.constraint_type = 'R'
              AND n.delete_rule = 'NO ACTION'
          ) r
          START WITH
            r.parent_table = upper(tab_name)
          CONNECT BY
            r.parent_table = PRIOR r.ref_table
            AND r.ref_table <> r.parent_table
          GROUP BY
            r.parent_table,
            r.owner
          ) n
          ON n.parent_table = c.table_name
         AND n.owner = c.owner
        -- get n:m tables which are the NULL candidates from the n block
        -- the FK has to be set to CASCADE to decide for cleanup
        OUTER APPLY (
          SELECT
            mn2.table_name AS m_table,
            mna.column_name AS fk_m_column_name
          FROM
            all_constraints mn
          JOIN
            all_cons_columns mna
            ON mna.constraint_name = mn.constraint_name
           AND mna.table_name = mn.table_name
           AND mna.owner = mn.owner
          JOIN
            all_constraints mn2
            ON mn2.constraint_name = mn.r_constraint_name
            AND mn2.owner = mn.owner
          WHERE
            mn.table_name = c.table_name
            AND mn.owner = c.owner
            AND n.parent_table IS NULL
            AND mn2.table_name <> mn.table_name
            AND mn.constraint_type = 'R'
            AND mn.delete_rule = 'CASCADE'
        ) m
        WHERE
          c2.table_name = upper(tab_name)
          AND c2.owner = upper(schema_name)
          AND c.table_name <> c2.table_name
          AND c.constraint_type = 'R'
          AND c.delete_rule = 'NO ACTION'
      ) ref
      WHERE
        (clean_n_parent IS NULL OR clean_n_parent <> root_table)
        AND (clean_m_parent IS NULL OR clean_m_parent <> root_table)
      ORDER BY
        ref_depth DESC NULLS FIRST,
        n_table,
        m_table;
    RETURN ref_cursor;
  END;

  -- ARRAY CASE
  FUNCTION gen_delete_ref_by_ids_stmt(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(tab_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(tab_name)||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||lower(fk_column_name)
      ||chr(10)||'  );'
      ||chr(10);
  END;

  FUNCTION gen_delete_ref_by_ids_call(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(tab_name)||'s'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    t.id'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    child_ids'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||lower(tab_name)||' t,'
      ||chr(10)||'    TABLE(arr) a'
      ||chr(10)||'  WHERE'
      ||chr(10)||'    t.'||lower(fk_column_name)||' = a.COLUMN_VALUE;'
      ||chr(10)
      ||chr(10)||'  IF child_ids.COUNT > 0 THEN'
      ||chr(10)||'    dummy_ids := delete_'||get_short_name(lower(tab_name))||'_batch(child_ids);'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  FUNCTION gen_delete_m_ref_by_ids_stmt(
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(m_tab_name)||'(s) not being referenced any more'
      ||chr(10)||'  IF '||get_short_name(lower(m_tab_name))||'_ids.COUNT > 0 THEN'
      ||chr(10)||'    DELETE FROM'
      ||chr(10)||'      '||lower(m_tab_name)||' m'
      ||chr(10)||'    WHERE EXISTS ('
      ||chr(10)||'      SELECT DISTINCT'
      ||chr(10)||'        a.COLUMN_VALUE'
      ||chr(10)||'      FROM'
      ||chr(10)||'        TABLE('||get_short_name(lower(m_tab_name))||'_ids) a'
      ||chr(10)||'      LEFT JOIN'
      ||chr(10)||'        '||lower(n_m_tab_name)||' n2m'
      ||chr(10)||'        ON n2m.'||lower(fk_m_column_name)||' = a.COLUMN_VALUE'
      ||chr(10)||'      WHERE'
      ||chr(10)||'        a.COLUMN_VALUE = m.id'
      ||chr(10)||'        AND n2m.'||lower(fk_m_column_name)||' IS NULL'
      ||chr(10)||'    );'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  FUNCTION gen_delete_m_ref_by_ids_call(
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(m_tab_name)||'(s) not being referenced any more'
      ||chr(10)||'  IF '||get_short_name(lower(m_tab_name))||'_ids.COUNT > 0 THEN'
      ||chr(10)||'    SELECT DISTINCT'
      ||chr(10)||'      a.COLUMN_VALUE'
      ||chr(10)||'    BULK COLLECT INTO'
      ||chr(10)||'      '||get_short_name(lower(m_tab_name))||'_pids'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE('||get_short_name(lower(m_tab_name))||'_ids) a'
      ||chr(10)||'    LEFT JOIN'
      ||chr(10)||'      '||lower(n_m_tab_name)||' n2m'
      ||chr(10)||'      ON n2m.'||lower(fk_m_column_name)||' = a.COLUMN_VALUE'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      n2m.'||lower(fk_m_column_name)||' IS NULL;'
      ||chr(10)
      ||chr(10)||'    IF '||get_short_name(lower(m_tab_name))||'_pids.COUNT > 0 THEN'
      ||chr(10)||'      dummy_ids := delete_'||get_short_name(lower(m_tab_name))||'_batch('||get_short_name(lower(m_tab_name))||'_pids);'
      ||chr(10)||'    END IF;'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  FUNCTION gen_delete_n_m_ref_by_ids_stmt(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||lower(m_tab_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_tab_name)||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||lower(fk_n_column_name)
      ||chr(10)||'  )'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||fk_m_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	  '||get_short_name(lower(m_tab_name))||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_stmt(m_tab_name, fk_m_column_name, n_m_tab_name);
  END;

  FUNCTION gen_delete_n_m_ref_by_ids_call(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||lower(m_tab_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_tab_name)||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||lower(fk_n_column_name)
      ||chr(10)||'  )'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||fk_m_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	  '||get_short_name(lower(m_tab_name))||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_call(m_tab_name, fk_m_column_name, n_m_tab_name);
  END;

  PROCEDURE create_ref_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_cursor SYS_REFCURSOR;
    n_table VARCHAR(30);
    fk_n_column_name VARCHAR(30);
    ref_depth NUMBER;
    cleanup_n_table VARCHAR(30);
    m_table VARCHAR(30);
    fk_m_column_name VARCHAR(30);
    cleanup_m_table VARCHAR(30);
  BEGIN
    ref_cursor := query_ref_fk(tab_name, schema_name);

    LOOP
      FETCH ref_cursor
      INTO n_table, fk_n_column_name, ref_depth, cleanup_n_table, m_table, fk_m_column_name, cleanup_m_table;
      EXIT WHEN ref_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      IF (
        ref_depth > 1
        OR cleanup_n_table IS NOT NULL
        OR cleanup_m_table IS NOT NULL
      ) THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(
          COALESCE(m_table, n_table),
          schema_name
        );

        IF m_table IS NULL THEN
          IF vars IS NULL OR INSTR(vars, 'child_ids') = 0 THEN
            vars := vars ||chr(10)|| '  child_ids ID_ARRAY;';
          END IF;
          ref_block := ref_block || gen_delete_ref_by_ids_call(n_table, fk_n_column_name);
        ELSE
          vars := vars
            ||chr(10)||'  '||get_short_name(lower(m_table))||'_ids ID_ARRAY;'
            ||chr(10)||'  '||get_short_name(lower(m_table))||'_pids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_ids_call(n_table, fk_n_column_name, m_table, fk_m_column_name);
        END IF;      
      ELSE
        IF m_table IS NULL THEN
          ref_block := ref_block || gen_delete_ref_by_ids_stmt(n_table, fk_n_column_name);
        ELSE
          vars := vars ||chr(10)||'  '||get_short_name(lower(m_table))||'_ids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_ids_stmt(n_table, fk_n_column_name, m_table, fk_m_column_name);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  FUNCTION gen_delete_ref_by_id_stmt(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(tab_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(fk_column_name)||' = pid;'
      ||chr(10);
  END;

  FUNCTION gen_delete_ref_by_id_call(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(tab_name)||'s'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    id'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    child_ids'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||lower(tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(fk_column_name)||' = pid;'
      ||chr(10)
      ||chr(10)||'  IF child_ids.COUNT > 0 THEN'
      ||chr(10)||'    dummy_ids := delete_'||get_short_name(lower(tab_name))||'_batch(child_ids);'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  FUNCTION gen_delete_m_ref_by_id_stmt(
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(m_tab_name)||'(s) not being referenced any more'
      ||chr(10)||'  IF '||get_short_name(lower(m_tab_name))||'_ref_id IS NOT NULL THEN'
      ||chr(10)||'    DELETE FROM'
      ||chr(10)||'      '||lower(m_tab_name)||' m'
      ||chr(10)||'    WHERE EXISTS ('
      ||chr(10)||'      SELECT'
      ||chr(10)||'        1'
      ||chr(10)||'      FROM'
      ||chr(10)||'        TABLE(ID_ARRAY('||get_short_name(lower(m_tab_name))||'_ref_id)) a'
      ||chr(10)||'      LEFT JOIN'
      ||chr(10)||'        '||lower(n_m_tab_name)||' n2m'
      ||chr(10)||'        ON n2m.'||lower(fk_m_column_name)||' = a.COLUMN_VALUE'
      ||chr(10)||'      WHERE'
      ||chr(10)||'        a.COLUMN_VALUE = m.id'
      ||chr(10)||'        AND n2m.'||lower(fk_m_column_name)||' IS NULL'
      ||chr(10)||'    );'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  FUNCTION gen_delete_m_ref_by_id_call(
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||lower(m_tab_name)||'(s) not being referenced any more'
      ||chr(10)||'  IF '||get_short_name(lower(m_tab_name))||'_ref_id IS NOT NULL THEN'
      ||chr(10)||'    SELECT'
      ||chr(10)||'      a.COLUMN_VALUE'
      ||chr(10)||'    INTO'
      ||chr(10)||'      '||get_short_name(lower(m_tab_name))||'_pid'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(ID_ARRAY('||get_short_name(lower(m_tab_name))||'_ref_id)) a'
      ||chr(10)||'    LEFT JOIN'
      ||chr(10)||'      '||lower(n_m_tab_name)||' n2m'
      ||chr(10)||'      ON n2m.'||lower(fk_m_column_name)||' = a.COLUMN_VALUE'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      n2m.'||lower(fk_m_column_name)||' IS NULL;'
      ||chr(10)
      ||chr(10)||'    IF '||get_short_name(lower(m_tab_name))||'_pid IS NOT NULL THEN'
      ||chr(10)||'      dummy_id := delete_'||get_short_name(lower(m_tab_name))||'('||get_short_name(lower(m_tab_name))||'_pid);'
      ||chr(10)||'    END IF;'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  FUNCTION gen_delete_n_m_ref_by_id_stmt(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||lower(m_tab_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(fk_n_column_name)||' = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||lower(fk_m_column_name)
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	  '||get_short_name(lower(m_tab_name))||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_stmt(m_tab_name, fk_m_column_name, n_m_tab_name);
  END;

  FUNCTION gen_delete_n_m_ref_by_id_call(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||lower(m_tab_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(fk_n_column_name)||' = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||lower(fk_m_column_name)
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	  '||get_short_name(lower(m_tab_name))||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_call(m_tab_name, fk_m_column_name, n_m_tab_name);
  END;

  PROCEDURE create_ref_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_cursor SYS_REFCURSOR;
    n_table VARCHAR(30);
    fk_n_column_name VARCHAR(30);
    ref_depth NUMBER;
    cleanup_n_table VARCHAR(30);
    m_table VARCHAR(30);
    fk_m_column_name VARCHAR(30);
    cleanup_m_table VARCHAR(30);
  BEGIN
    ref_cursor := query_ref_fk(tab_name, schema_name);

    LOOP
      FETCH ref_cursor
      INTO n_table, fk_n_column_name, ref_depth, cleanup_n_table, m_table, fk_m_column_name, cleanup_m_table;
      EXIT WHEN ref_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      IF (
        ref_depth > 1
        OR cleanup_n_table IS NOT NULL
        OR cleanup_m_table IS NOT NULL
      ) THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(
          COALESCE(m_table, n_table),
          schema_name
        );

        IF m_table IS NULL THEN
          IF vars IS NULL OR INSTR(vars, 'child_ids') = 0 THEN
            vars := vars ||chr(10)|| '  child_ids ID_ARRAY;';
          END IF;
          ref_block := ref_block || gen_delete_ref_by_id_call(n_table, fk_n_column_name);
        ELSE
          vars := vars
            ||chr(10)||'  '||get_short_name(lower(m_table))||'_ids ID_ARRAY;'
            ||chr(10)||'  '||get_short_name(lower(m_table))||'_pids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_id_call(n_table, fk_n_column_name, m_table, fk_m_column_name);
        END IF;      
      ELSE
        IF m_table IS NULL THEN
          ref_block := ref_block || gen_delete_ref_by_id_stmt(n_table, fk_n_column_name);
        ELSE
          vars := vars ||chr(10)||'  '||get_short_name(lower(m_table))||'_ids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_id_stmt(n_table, fk_n_column_name, m_table, fk_m_column_name);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;


  /*****************************
  * 3. Main delete
  *
  * statements are not closed because more columns might be returned
  *****************************/
  -- ARRAY CASE
  FUNCTION gen_delete_by_ids_stmt(
    tab_name VARCHAR2
    ) RETURN VARCHAR2
  IS
  BEGIN
    RETURN
        chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(tab_name)||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      a.COLUMN_VALUE'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.id'
      ||chr(10)||'  )'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    id';
  END;

  -- SINGLE CASE
  FUNCTION gen_delete_by_id_stmt(
    tab_name VARCHAR2
    ) RETURN VARCHAR2
  IS
  BEGIN
    RETURN
        chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    id = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    id';
  END;


  /*****************************
  * 4. FKs in table
  *****************************/
  FUNCTION query_ref_to_fk(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN SYS_REFCURSOR 
  IS
    ref_to_cursor SYS_REFCURSOR;
  BEGIN
    OPEN ref_to_cursor FOR
      SELECT
        a_ref.table_name AS ref_table,
        a_ref.column_name AS ref_column,
        LISTAGG(ac.column_name, ','||chr(10)||'    ') WITHIN GROUP (ORDER BY ac.position) AS fk_columns,
        count(ac.column_name) AS column_count,
        citydb_delete_gen.check_for_cleanup(a_ref.table_name, a_ref.owner) AS cleanup_ref_table
      FROM
        all_constraints c
      JOIN
        all_cons_columns ac
        ON ac.constraint_name = c.constraint_name
       AND ac.table_name = c.table_name
       AND ac.owner = c.owner
      JOIN
        all_cons_columns a_ref
        ON a_ref.constraint_name = c.r_constraint_name
       AND a_ref.owner = c.owner
      WHERE
        c.table_name = upper(tab_name)
        AND c.owner = upper(schema_name)
        AND c.table_name <> a_ref.table_name
        AND c.constraint_type = 'R'
        AND c.delete_rule = 'SET NULL'
        AND (a_ref.table_name <> 'SURFACE_GEOMETRY'
         OR c.table_name = 'IMPLICIT_GEOMETRY'
         OR c.table_name = 'CITYOBJECT_GENERICATTRIB'
         OR c.table_name = 'CITYOBJECTGROUP')
      GROUP BY
        a_ref.table_name,
        a_ref.owner,
        a_ref.column_name;
    RETURN ref_to_cursor;
  END;

  -- ARRAY CASE
  PROCEDURE create_ref_to_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    returning_block OUT VARCHAR2,
    collect_block OUT VARCHAR2,
    into_block OUT VARCHAR2,
    fk_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    ref_table VARCHAR2(30);
    ref_column VARCHAR2(30);
    fk_columns VARCHAR2(500);
    column_count NUMBER;
    cleanup_ref_table VARCHAR2(30);
  BEGIN
    ref_to_cursor := query_ref_to_fk(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO ref_table, ref_column, fk_columns, column_count, cleanup_ref_table;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        returning_block := '';
        collect_block := '';
        into_block := '';
        fk_block := '';
      END IF;

      returning_block := returning_block ||','||chr(10)||'    '|| lower(fk_columns);

      IF column_count > 1 THEN
        -- additional collections and initialization of final list for referencing IDs required
        vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_ids ID_ARRAY := ID_ARRAY();';
        collect_block := collect_block||chr(10)||'  -- collect all '||get_short_name(lower(ref_table))||' ids into one nested table'||chr(10);
        FOR i IN 1..column_count LOOP
          vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_ids'||i||' ID_ARRAY;';
          into_block := into_block ||','||chr(10)||'    '||get_short_name(lower(ref_table))||'_ids'||i;
          collect_block := collect_block||'  '||get_short_name(lower(ref_table))||'_ids := '
            ||get_short_name(lower(ref_table))||'_ids MULTISET UNION ALL '||get_short_name(lower(ref_table))||'_ids'||i||';'||chr(10);
        END LOOP;
      ELSE
        vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_ids ID_ARRAY;';
        into_block := into_block ||','||chr(10)||'    '||get_short_name(lower(ref_table))||'_ids';
      END IF;

      IF cleanup_ref_table IS NOT NULL THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(ref_table, schema_name);
        vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_pids ID_ARRAY;';
        fk_block := fk_block || gen_delete_m_ref_by_ids_call(ref_table, ref_column, ref_table);
      ELSE
        fk_block := fk_block || gen_delete_m_ref_by_ids_stmt(ref_table, ref_column, ref_table);
      END IF;
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  PROCEDURE create_ref_to_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    returning_block OUT VARCHAR2,
    into_block OUT VARCHAR2,
    fk_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    ref_table VARCHAR2(30);
    ref_column VARCHAR2(30);
    fk_columns VARCHAR2(500);
    column_count NUMBER;
    cleanup_ref_table VARCHAR2(30);
  BEGIN
    ref_to_cursor := query_ref_to_fk(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO ref_table, ref_column, fk_columns, column_count, cleanup_ref_table;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        returning_block := '';
        into_block := '';
        fk_block := '';
      END IF;

      IF column_count > 1 THEN
        vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_ids ID_ARRAY;';
        returning_block := returning_block||','
          ||chr(10)||'    ID_ARRAY('
          ||chr(10)||'      '||lower(fk_columns)
          ||chr(10)||'    )';
        into_block := into_block||','||chr(10)||'    '||get_short_name(lower(ref_table))||'_ids';
      ELSE
        vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_ref_id NUMBER;';
        returning_block := returning_block ||','||chr(10)||'    '||lower(fk_columns);
        into_block := into_block||','||chr(10)||'    '||get_short_name(lower(ref_table))||'_ref_id';
      END IF;

      IF cleanup_ref_table IS NOT NULL THEN
        -- function call required, so create function first
        IF column_count > 1 THEN
          citydb_delete_gen.create_array_delete_function(ref_table, schema_name);
          vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_pids ID_ARRAY;';
          fk_block := fk_block || gen_delete_m_ref_by_ids_call(ref_table, ref_column, ref_table);
        ELSE
          citydb_delete_gen.create_delete_function(ref_table, schema_name);
          vars := vars ||chr(10)||'  '||get_short_name(lower(ref_table))||'_pid NUMBER;';
          fk_block := fk_block || gen_delete_m_ref_by_id_call(ref_table, ref_column, ref_table);
        END IF;
      ELSE
        IF column_count > 1 THEN
          fk_block := fk_block || gen_delete_m_ref_by_ids_stmt(ref_table, ref_column, ref_table);
        ELSE
          fk_block := fk_block || gen_delete_m_ref_by_id_stmt(ref_table, ref_column, ref_table);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;


  /*****************************
  * 5. FK which is PK 
  *****************************/
  FUNCTION query_ref_parent_fk(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    parent_table VARCHAR2;
  BEGIN
    SELECT
      p.table_name
    INTO
      parent_table
    FROM
      all_constraints fk
    JOIN
      all_cons_columns fka
      ON fka.constraint_name = fk.constraint_name
     AND fka.table_name = fk.table_name
     AND fka.owner = fk.owner
    JOIN (
      SELECT DISTINCT
        ctp.table_name,
        ctp.owner,
        first_value(pka.column_name) OVER (PARTITION BY ctp.table_name ORDER BY pka.position DESC) AS column_name,
        first_value(pka.position) OVER (PARTITION BY ctp.table_name ORDER BY pka.position DESC) AS position
      FROM
        all_constraints ctp
      JOIN
        all_cons_columns pka
        ON pka.constraint_name = ctp.constraint_name
       AND pka.table_name = ctp.table_name
       AND pka.owner = ctp.owner
      WHERE
        ctp.constraint_type = 'P'
      ) pk
      ON pk.table_name = fk.table_name
     AND pk.owner = fk.owner
     AND pk.column_name = fka.column_name
    JOIN
      all_constraints p
      ON p.constraint_name = fk.r_constraint_name
     AND p.owner = fk.owner
    WHERE
      fk.table_name = upper(tab_name)
      AND fk.owner = upper(schema_name)
      AND fk.constraint_type = 'R'
      AND fk.delete_rule = 'NO ACTION'
      AND pk.position = 1;

    RETURN parent_table;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN '';
  END;

  -- ARRAY CASE
  FUNCTION create_ref_parent_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    parent_table VARCHAR2(30);
    parent_block VARCHAR2(1000) := '';
  BEGIN
    parent_table := query_ref_parent_fk(tab_name, schema_name);

    IF parent_table IS NOT NULL THEN
      -- create array delete function for parent table
      citydb_delete_gen.create_array_delete_function(parent_table, schema_name);
      parent_block := parent_block
        ||chr(10)||'  -- delete '||lower(parent_table)
        ||chr(10)||'  IF deleted_ids.COUNT > 0 THEN'
        ||chr(10)||'    dummy_ids := delete_'||get_short_name(lower(parent_table))||'_batch(deleted_ids);'
        ||chr(10)||'  END IF;'
        ||chr(10);
    END IF;

    RETURN parent_block;
  END;

  -- SINGLE CASE
  FUNCTION create_ref_parent_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    parent_table VARCHAR2(30);
    parent_block VARCHAR2(1000) := '';
  BEGIN
    parent_table := query_ref_parent_fk(tab_name, schema_name);

    IF parent_table IS NOT NULL THEN
      -- create array delete function for parent table
      citydb_delete_gen.create_delete_function(parent_table, schema_name);
      parent_block := parent_block
        ||chr(10)||'  -- delete '||lower(parent_table)
        ||chr(10)||'  IF deleted_id IS NOT NULL THEN'
        ||chr(10)||'    dummy_id := delete_'||get_short_name(lower(parent_table))||'(deleted_id);'
        ||chr(10)||'  END IF;'
        ||chr(10);
    END IF;

    RETURN parent_block;
  END;


  /**************************
  * CREATE DELETE FUNCTION
  **************************/
  -- dummy function to compile array delete functions with recursions
  PROCEDURE create_array_delete_dummy(
    tab_name VARCHAR2
    )
  IS
    ddl_command VARCHAR2(500) := 
      'CREATE OR REPLACE FUNCTION gen_delete_'||get_short_name(lower(tab_name))||'_batch(arr ID_ARRAY) RETURN ID_ARRAY'
      ||chr(10)||'IS'
      ||chr(10)||'  deleted_ids ID_ARRAY;'
      ||chr(10)||'BEGIN'
      ||chr(10)||'  RETURN deleted_ids;'
      ||chr(10)||'END;';
  BEGIN
    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;

  -- ARRAY CASE
  PROCEDURE create_array_delete_function(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(10000) := 
      'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||get_short_name(lower(tab_name))||'_batch(arr ID_ARRAY) RETURN ID_ARRAY'
      ||chr(10)||'IS'||chr(10);
    declare_block VARCHAR2(500) := '  deleted_ids ID_ARRAY;';
    pre_block VARCHAR2(2000) := '';
    post_block VARCHAR2(2000) := '';
    delete_block VARCHAR2(1000) := '';
    delete_into_block VARCHAR2(500) :=
        chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    deleted_ids';
    vars VARCHAR2(500);
    self_block VARCHAR2(1000);
    ref_block VARCHAR2(2000);
    returning_block VARCHAR2(500);
    collect_block VARCHAR2(500);
    into_block VARCHAR2(500);
    fk_block VARCHAR2(1000);
  BEGIN
    -- SELF REFERENCES
    create_selfref_array_delete(tab_name, schema_name, vars, self_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(self_block, '');

    -- REFERENCING TABLES
    create_ref_array_delete(tab_name, schema_name, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- MAIN DELETE
    delete_block := gen_delete_by_ids_stmt(tab_name);

    -- FOREIGN KEYs which are set to ON DELETE SET NULL and are nullable
    create_ref_to_array_delete(tab_name, schema_name, vars, returning_block, collect_block, into_block, fk_block);
    declare_block := declare_block || COALESCE(vars, '');
    delete_block := delete_block || COALESCE(returning_block, '');
    delete_into_block := delete_into_block || COALESCE(into_block, '');
    post_block := post_block || COALESCE(collect_block, '') || COALESCE(fk_block, '');

    -- FOREIGN KEY which cover same columns AS primary key
    post_block := post_block || create_ref_parent_array_delete(tab_name, schema_name);

    -- create dummy variable if pre or post block are not null
    IF pre_block IS NOT NULL OR post_block IS NOT NULL THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY;';
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || pre_block
      ||chr(10)||'  -- delete '||lower(tab_name)||'s'
      || delete_block
      || delete_into_block || ';'
      ||chr(10)
      || post_block
      ||chr(10)||'  RETURN deleted_ids;'
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;

  -- SINGLE CASE
  PROCEDURE create_delete_function(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(10000) := 'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||get_short_name(lower(tab_name))||'(pid NUMBER) RETURN NUMBER'||chr(10)||'IS'||chr(10);
    declare_block VARCHAR2(500) := '  deleted_id NUMBER;';
    pre_block VARCHAR2(2000) := '';
    post_block VARCHAR2(1000) := '';
    delete_block VARCHAR2(1000) := '';
    delete_into_block VARCHAR2(500) := 
        chr(10)||'  INTO'
      ||chr(10)||'    deleted_id';
    vars VARCHAR2(500);
    self_block VARCHAR2(1000);
    ref_block VARCHAR2(2000);
    returning_block VARCHAR2(500);
    into_block VARCHAR2(500);
    fk_block VARCHAR2(1000);
  BEGIN
    -- SELF REFERENCES
    create_selfref_delete(tab_name, schema_name, vars, self_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(self_block, '');

    -- REFERENCING TABLES
    create_ref_delete(tab_name, schema_name, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- MAIN DELETE
    delete_block := gen_delete_by_id_stmt(tab_name);

    -- FOREIGN KEY which are set to ON DELETE SET NULL and are nullable
    create_ref_to_delete(tab_name, schema_name, vars, returning_block, into_block, fk_block);
    declare_block := declare_block || COALESCE(vars, '');
    delete_block := delete_block || COALESCE(returning_block, '');
    delete_into_block := delete_into_block || COALESCE(into_block, '');
    post_block := post_block || COALESCE(fk_block, '');

    -- FOREIGN KEY which cover same columns AS primary key
    post_block := post_block || create_ref_parent_delete(tab_name, schema_name);

    -- create dummy variable if pre or post block are not null
    IF pre_block IS NOT NULL OR fk_block IS NOT NULL THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY;';
    END IF;
    IF post_block IS NOT NULL THEN
      declare_block := declare_block ||chr(10)||'  dummy_id NUMBER;';
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || pre_block
      ||chr(10)||'  -- delete '||lower(tab_name)||'s'
      || delete_block
      || delete_into_block || ';'
      ||chr(10)
      || post_block
      ||chr(10)||'  RETURN deleted_id;'
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;

END citydb_delete_gen;
/