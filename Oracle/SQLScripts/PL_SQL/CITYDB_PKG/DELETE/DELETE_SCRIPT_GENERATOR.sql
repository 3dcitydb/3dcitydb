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
  FUNCTION check_for_cleanup(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION is_child_ref(fk_column_name VARCHAR2, tab_name VARCHAR2, ref_table_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN NUMBER;
  FUNCTION create_array_delete_function(tab_name VARCHAR2, schema_name VARCHAR2 := USER, path STRARRAY := STRARRAY()) RETURN STRARRAY;
  FUNCTION create_delete_function(tab_name VARCHAR2, schema_name VARCHAR2 := USER, path STRARRAY := STRARRAY()) RETURN STRARRAY;
  FUNCTION create_array_delete_member_fct(tab_name VARCHAR2, schema_name VARCHAR2 := USER, path STRARRAY := STRARRAY()) RETURN STRARRAY;
  FUNCTION create_delete_member_fct(tab_name VARCHAR2, schema_name VARCHAR2 := USER, path STRARRAY := STRARRAY()) RETURN STRARRAY;
END citydb_delete_gen;
/

CREATE OR REPLACE PACKAGE BODY citydb_delete_gen
AS
  FUNCTION has_objclass_id(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN NUMBER;
  PROCEDURE query_ref_tables_and_columns(tab_name VARCHAR2, ref_parent_to_exclude VARCHAR2, schema_name VARCHAR2 := USER, ref_tables OUT STRARRAY, ref_columns OUT STRARRAY);
  FUNCTION query_ref_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  FUNCTION gen_delete_ref_by_ids_stmt(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_ref_by_ids_call(tab_name VARCHAR2, fk_column_name VARCHAR2, has_objclass_param BOOLEAN := FALSE, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_ids_stmt(m_table_name VARCHAR2, m_fk_column_name VARCHAR2, fk_table_name STRARRAY, fk_columns STRARRAY, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_ids_call(m_table_name VARCHAR2, fk_table_name STRARRAY, fk_columns STRARRAY, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_ids_stmt(n_m_table_name VARCHAR2, n_fk_column_name VARCHAR2, m_table_name VARCHAR2, m_fk_column_name VARCHAR2, m_ref_column_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_ids_call(n_m_table_name VARCHAR2, n_fk_column_name VARCHAR2, m_table_name VARCHAR2, m_fk_column_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_ref_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, ref_path IN OUT STRARRAY, vars OUT VARCHAR2, child_ref_block OUT VARCHAR2, ref_block OUT VARCHAR2);
  FUNCTION gen_delete_ref_by_id_stmt(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION gen_delete_ref_by_id_call(tab_name VARCHAR2, fk_column_name VARCHAR2, has_objclass_param BOOLEAN := FALSE, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_id_stmt(m_table_name VARCHAR2, m_fk_column_name VARCHAR2, fk_table_name STRARRAY, fk_columns STRARRAY, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_m_ref_by_id_call(m_table_name VARCHAR2, fk_table_name STRARRAY, fk_columns STRARRAY, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_id_stmt(n_m_table_name VARCHAR2, n_fk_column_name VARCHAR2, m_table_name VARCHAR2, m_fk_column_name VARCHAR2, m_ref_column_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION gen_delete_n_m_ref_by_id_call(n_m_table_name VARCHAR2, n_fk_column_name VARCHAR2, m_table_name VARCHAR2, m_fk_column_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_ref_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, ref_path IN OUT STRARRAY, vars OUT VARCHAR2, child_ref_block OUT VARCHAR2, ref_block OUT VARCHAR2);
  FUNCTION query_selfref_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  FUNCTION gen_delete_selfref_by_ids_call(tab_name VARCHAR2, self_fk_column_name VARCHAR2, has_objclass_param BOOLEAN := FALSE, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_selfref_array_delete(tab_name VARCHAR2, has_objclass_param BOOLEAN := FALSE, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, self_block OUT VARCHAR2);
  FUNCTION gen_delete_selfref_by_id_call(tab_name VARCHAR2, self_fk_column_name VARCHAR2, has_objclass_param BOOLEAN := FALSE, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_selfref_delete(tab_name VARCHAR2, has_objclass_param BOOLEAN := FALSE, schema_name VARCHAR2 := USER, selfref_path IN OUT STRARRAY, vars OUT VARCHAR2, self_block OUT VARCHAR2);
  FUNCTION gen_delete_by_ids_stmt(tab_name VARCHAR2, has_objclass_param BOOLEAN := FALSE) RETURN VARCHAR2;
  FUNCTION gen_delete_by_id_stmt(tab_name VARCHAR2, has_objclass_param BOOLEAN := FALSE) RETURN VARCHAR2;
  FUNCTION query_ref_to_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  PROCEDURE create_ref_to_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, ref_to_path IN OUT STRARRAY, vars OUT VARCHAR2, returning_block OUT VARCHAR2, collect_block OUT VARCHAR2, into_block OUT VARCHAR2, fk_block OUT VARCHAR2);
  PROCEDURE create_ref_to_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, ref_to_path IN OUT STRARRAY, vars OUT VARCHAR2, returning_block OUT VARCHAR2, into_block OUT VARCHAR2, fk_block OUT VARCHAR2);
  FUNCTION query_ref_parent_fk(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_ref_parent_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, ref_to_parent_path IN OUT STRARRAY, parent_block OUT VARCHAR2);
  PROCEDURE create_ref_parent_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, ref_to_parent_path IN OUT STRARRAY, parent_block OUT VARCHAR2);
  PROCEDURE create_array_delete_dummy(tab_name VARCHAR2, schema_name VARCHAR2 := USER);
  PROCEDURE create_delete_dummy(tab_name VARCHAR2, schema_name VARCHAR2 := USER);
  PROCEDURE create_array_delete_post_dummy(tab_name VARCHAR2, schema_name VARCHAR2 := USER);
  PROCEDURE create_delete_post_dummy(tab_name VARCHAR2, schema_name VARCHAR2 := USER);
  FUNCTION query_member_1n(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  PROCEDURE create_member_1n_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, member_1n_path IN OUT STRARRAY, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  PROCEDURE create_member_1n_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, member_1n_path IN OUT STRARRAY, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  FUNCTION query_member_nm(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN SYS_REFCURSOR;
  PROCEDURE create_member_nm_array_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, member_nm_path IN OUT STRARRAY, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  PROCEDURE create_member_nm_delete(tab_name VARCHAR2, schema_name VARCHAR2 := USER, member_nm_path IN OUT STRARRAY, vars OUT VARCHAR2, ref_block OUT VARCHAR2);

  /*
  A delete function can consist of up to five parts:
    1. Delete statements (or procedure call) for referencing tables where the FK is set to NO ACTION
    2. A recursive delete call, if the relation stores tree structures, the FK is set to NO ACTION and parent_id can be NULL
    3. The central delete statement that removes the given entry/ies and returns the deleted IDs
    4. Deletes for unreferenced entries in tables where the FK is set to SET NULL
    5. If an FK is set to CASCADE and covers the same column(s) as the PK, the referenced parent will be deleted
  */

  --if referencing table requires an extra cleanup step, it needs its own delete function
  FUNCTION check_for_cleanup(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
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
          AND c2.table_name <> 'CITYOBJECT'
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

  FUNCTION is_child_ref(
    fk_column_name VARCHAR2,
    tab_name VARCHAR2,
    ref_table_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN NUMBER
  IS
    is_child NUMBER(1);
  BEGIN
    SELECT
      1
    INTO
      is_child
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
      fk.table_name = upper(tab_name)
      AND fk.owner = upper(schema_name)
      AND fk2.table_name = upper(ref_table_name)
      AND fk.constraint_type = 'R'
      AND pk.position = 1
      AND pk.column_name = fk_column_name;

    RETURN is_child;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 0;
  END;

  FUNCTION has_objclass_id(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN NUMBER
  IS
    has_class_id NUMBER(1);
  BEGIN
    SELECT
      1
    INTO
      has_class_id
    FROM
      all_tab_columns
    WHERE
      table_name = upper(tab_name)
      AND owner = upper(schema_name)
      AND column_name = 'OBJECTCLASS_ID';

    RETURN has_class_id;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 0;
  END;

  PROCEDURE query_ref_tables_and_columns(
    tab_name VARCHAR2,
    ref_parent_to_exclude VARCHAR2,
    schema_name VARCHAR2 := USER,
    ref_tables OUT STRARRAY,
    ref_columns OUT STRARRAY
    )
  IS
  BEGIN
    SELECT
      c.table_name,
      a.column_name
    BULK COLLECT INTO
      ref_tables,
      ref_columns
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
    LEFT OUTER JOIN (
      SELECT
        mn.table_name,
        mn.owner,
        mn2.table_name AS m_table_name,
        mna.column_name AS m_fk_column_name
      FROM
        all_constraints mn
      JOIN
        all_cons_columns mna
        ON mna.constraint_name = mn.constraint_name
       AND mna.table_name = mn.table_name
       AND mna.owner = mn.owner
      JOIN 
        all_constraints mnp
        ON mnp.table_name = mn.table_name
       AND mnp.owner = mn.owner
      JOIN
        all_cons_columns mnpa
        ON mnpa.constraint_name = mnp.constraint_name
       AND mnpa.table_name = mn.table_name
       AND mnpa.owner = mn.owner
       AND mnpa.column_name = mna.column_name
      JOIN
        all_constraints mn2
        ON mn2.constraint_name = mn.r_constraint_name
       AND mn2.owner = mn.owner
      WHERE
        mn2.table_name <> mn.table_name
        AND mn.constraint_type = 'R'
        AND mnp.constraint_type = 'P'
      ) m
      ON m.table_name = c.table_name
     AND m.owner = c.owner
     AND a.column_name = m.m_fk_column_name
    WHERE
      c2.table_name = upper(tab_name)
      AND c2.owner = upper(schema_name)
      AND c.table_name <> upper(ref_parent_to_exclude)
      AND c.constraint_type = 'R'
      AND (c.delete_rule = 'SET NULL' OR (c.delete_rule = 'CASCADE' AND m.m_table_name IS NOT NULL))
      AND citydb_delete_gen.is_child_ref(a.column_name, c.table_name, upper(tab_name), upper(schema_name)) = 0
    ORDER BY
      c.table_name,
      a.column_name;

    RETURN;
  END;


  /*****************************
  * 1. Referencing tables
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
        n.n_table_name,
        n.n_fk_column_name,
        n.cleanup_n_table,
        n.is_child,
        m.m_table_name,
        m.m_fk_column_name,
        m.m_ref_column_name,
        citydb_delete_gen.check_for_cleanup(m.m_table_name, m.owner) AS cleanup_m_table
      FROM (
        SELECT
          c2.table_name AS root_table_name,
          c.table_name AS n_table_name,
          c.owner,
          a.column_name AS n_fk_column_name,
          citydb_delete_gen.check_for_cleanup(c.table_name, c.owner) AS cleanup_n_table,
          citydb_delete_gen.is_child_ref(a.column_name, c.table_name, c2.table_name, c.owner) AS is_child,
          c.delete_rule
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
        WHERE
          c2.table_name = upper(tab_name)
          AND c2.owner = upper(schema_name)
          AND c.table_name <> c2.table_name
          AND c.constraint_type = 'R'
      ) n
      -- get n:m tables which returned NULL for cleanup_n_table in the n block
      -- the FK has to be set to CASCADE to decide for cleanup
      -- found FK column needs to be part of the PK
      LEFT OUTER JOIN (
        SELECT
          mn.table_name,
          mn.owner,
          mn2.table_name AS m_table_name,
          mna.column_name AS m_fk_column_name,
          mna_ref.column_name AS m_ref_column_name
        FROM
          all_constraints mn
        JOIN
          all_cons_columns mna
          ON mna.constraint_name = mn.constraint_name
         AND mna.table_name = mn.table_name
         AND mna.owner = mn.owner
        JOIN 
          all_constraints mnp
          ON mnp.table_name = mn.table_name
         AND mnp.owner = mn.owner
        JOIN
          all_cons_columns mnpa
          ON mnpa.constraint_name = mnp.constraint_name
         AND mnpa.table_name = mn.table_name
         AND mnpa.owner = mn.owner
         AND mnpa.column_name = mna.column_name
        JOIN
          all_constraints mn2
          ON mn2.constraint_name = mn.r_constraint_name
         AND mn2.owner = mn.owner
        JOIN
          all_cons_columns mna_ref
          ON mna_ref.constraint_name = mn.r_constraint_name
         AND mna_ref.owner = mn.owner
        WHERE
          mn2.table_name <> mn.table_name
          AND mn.constraint_type = 'R'
          AND mnp.constraint_type = 'P'
        ) m
        ON m.table_name = n.n_table_name
       AND m.owner = n.owner
       AND n.cleanup_n_table IS NULL
      WHERE
        (n.delete_rule = 'NO ACTION' OR n.is_child = 1)
        AND (n.root_table_name <> m.m_table_name OR m.m_table_name IS NULL)
      ORDER BY
        n.is_child DESC,
        n.n_table_name,
        m.m_table_name;
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
      ||chr(10)||'      TABLE(pids) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||lower(fk_column_name)
      ||chr(10)||'  );'
      ||chr(10);
  END;

  FUNCTION gen_delete_ref_by_ids_call(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
  BEGIN
    IF has_objclass_param THEN
      RETURN
          chr(10)||'  -- delete '||lower(tab_name)||'s'
        ||chr(10)||'  SELECT'
        ||chr(10)||'    t.id,'
        ||chr(10)||'    t.objectclass_id'
        ||chr(10)||'  BULK COLLECT INTO'
        ||chr(10)||'    child_ids,'
        ||chr(10)||'    child_class_ids'
        ||chr(10)||'  FROM'
        ||chr(10)||'    '||lower(tab_name)||' t,'
        ||chr(10)||'    TABLE(pids) a'
        ||chr(10)||'  WHERE'
        ||chr(10)||'    t.'||lower(fk_column_name)||' = a.COLUMN_VALUE;'
        ||chr(10)
        ||chr(10)||'  IF child_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(child_ids, SET(child_class_ids));'
        ||chr(10)||'  END IF;'
        ||chr(10);
    ELSE
      RETURN
          chr(10)||'  -- delete '||lower(tab_name)||'s'
        ||chr(10)||'  SELECT'
        ||chr(10)||'    t.id'
        ||chr(10)||'  BULK COLLECT INTO'
        ||chr(10)||'    child_ids'
        ||chr(10)||'  FROM'
        ||chr(10)||'    '||lower(tab_name)||' t,'
        ||chr(10)||'    TABLE(pids) a'
        ||chr(10)||'  WHERE'
        ||chr(10)||'    t.'||lower(fk_column_name)||' = a.COLUMN_VALUE;'
        ||chr(10)
        ||chr(10)||'  IF child_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(child_ids);'
        ||chr(10)||'  END IF;'
        ||chr(10);    
    END IF;
  END;

  FUNCTION gen_delete_m_ref_by_ids_stmt(
    m_table_name VARCHAR2,
    m_fk_column_name VARCHAR2,
    fk_table_name STRARRAY,
    fk_columns STRARRAY,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    stmt VARCHAR2(8000);
    where_clause VARCHAR2(4000);
  BEGIN
    stmt := 
        chr(10)||'  -- delete '||lower(m_table_name)||'(s) not being referenced any more'
      ||chr(10)||'  IF '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids IS NOT EMPTY THEN'
      ||chr(10)||'    DELETE FROM'
      ||chr(10)||'      '||lower(m_table_name)||' m'
      ||chr(10)||'    WHERE EXISTS ('
      ||chr(10)||'      SELECT DISTINCT'
      ||chr(10)||'        a.COLUMN_VALUE'
      ||chr(10)||'      FROM'
      ||chr(10)||'        TABLE('||citydb_util.get_short_name(m_table_name, schema_name)||'_ids) a';

    where_clause := 
        chr(10)||'      WHERE'
      ||chr(10)||'        m.'||lower(m_fk_column_name)||' = a.COLUMN_VALUE';

    FOR t IN
      fk_table_name.FIRST .. fk_table_name.LAST
    LOOP
      stmt := stmt
        ||chr(10)||'      LEFT JOIN'
        ||chr(10)||'        '||lower(fk_table_name(t))||' n'||t
        ||chr(10)||'        ON n'||t||'.'||lower(fk_columns(t))||' = a.COLUMN_VALUE';

      where_clause := where_clause
        ||chr(10)||'        AND n'||t||'.'||lower(fk_columns(t))||' IS NULL';
    END LOOP;

    stmt := stmt
      || where_clause
      ||chr(10)||'    );'
      ||chr(10)||'  END IF;'
      ||chr(10);

    RETURN stmt;
  END;
  
  FUNCTION gen_delete_m_ref_by_ids_call(
    m_table_name VARCHAR2,
    fk_table_name STRARRAY,
    fk_columns STRARRAY,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    call_stmt VARCHAR2(8000);
    where_clause VARCHAR2(4000);
    where_and VARCHAR2(4) := '';
  BEGIN
    call_stmt :=
        chr(10)||'  -- delete '||lower(m_table_name)||'(s) not being referenced any more'
      ||chr(10)||'  IF '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids IS NOT EMPTY THEN'
      ||chr(10)||'    SELECT DISTINCT'
      ||chr(10)||'      a.COLUMN_VALUE'
      ||chr(10)||'    BULK COLLECT INTO'
      ||chr(10)||'      '||citydb_util.get_short_name(m_table_name, schema_name)||'_pids'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE('||citydb_util.get_short_name(m_table_name, schema_name)||'_ids) a';

    where_clause := chr(10)||'    WHERE';

    FOR t IN
      fk_table_name.FIRST .. fk_table_name.LAST
    LOOP
      call_stmt := call_stmt
        ||chr(10)||'    LEFT JOIN'
        ||chr(10)||'      '||lower(fk_table_name(t))||' n'||t
        ||chr(10)||'      ON n'||t||'.'||lower(fk_columns(t))||' = a.COLUMN_VALUE';

      where_clause := where_clause
        ||chr(10)||'      '||where_and||'n'||t||'.'||lower(fk_columns(t))||' IS NULL';

      where_and := 'AND ';
    END LOOP;

    call_stmt := call_stmt
      || where_clause || ';'
      ||chr(10)
      ||chr(10)||'    IF '||citydb_util.get_short_name(m_table_name, schema_name)||'_pids IS NOT EMPTY THEN'
      ||chr(10)||'      dummy_ids := delete_'||citydb_util.get_short_name(m_table_name, schema_name)||'_batch('||citydb_util.get_short_name(m_table_name, schema_name)||'_pids);'
      ||chr(10)||'    END IF;'
      ||chr(10)||'  END IF;'
      ||chr(10);

    RETURN call_stmt;
  END;

  FUNCTION gen_delete_n_m_ref_by_ids_stmt(
    n_m_table_name VARCHAR2,
    n_fk_column_name VARCHAR2,
    m_table_name VARCHAR2,
    m_fk_column_name VARCHAR2,
    m_ref_column_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    ref_tables STRARRAY;
    ref_columns STRARRAY;
  BEGIN
    query_ref_tables_and_columns(m_table_name, n_m_table_name, schema_name, ref_tables, ref_columns);
    ref_tables := STRARRAY(n_m_table_name) MULTISET UNION ALL COALESCE(ref_tables, STRARRAY());
    ref_columns := STRARRAY(m_fk_column_name) MULTISET UNION ALL COALESCE(ref_columns, STRARRAY());

    RETURN
        chr(10)||'  -- delete references to '||lower(m_table_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_table_name)||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(pids) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||lower(n_fk_column_name)
      ||chr(10)||'  )'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||m_fk_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_stmt(m_table_name, m_ref_column_name, ref_tables, ref_columns, schema_name);
  END;

  FUNCTION gen_delete_n_m_ref_by_ids_call(
    n_m_table_name VARCHAR2,
    n_fk_column_name VARCHAR2,
    m_table_name VARCHAR2,
    m_fk_column_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    ref_tables STRARRAY;
    ref_columns STRARRAY;
  BEGIN
    query_ref_tables_and_columns(m_table_name, n_m_table_name, schema_name, ref_tables, ref_columns);
    ref_tables := STRARRAY(n_m_table_name) MULTISET UNION ALL COALESCE(ref_tables, STRARRAY());
    ref_columns := STRARRAY(m_fk_column_name) MULTISET UNION ALL COALESCE(ref_columns, STRARRAY());

    RETURN
        chr(10)||'  -- delete references to '||lower(m_table_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_table_name)||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(pids) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||lower(n_fk_column_name)
      ||chr(10)||'  )'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||lower(m_fk_column_name)
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_call(m_table_name, ref_tables, ref_columns, schema_name);
  END;

  PROCEDURE create_ref_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    ref_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    child_ref_block OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_cursor SYS_REFCURSOR;
    n_table_name VARCHAR2(30);
    n_fk_column_name VARCHAR2(30);
    cleanup_n_table VARCHAR2(30);
    is_child NUMBER;
    m_table_name VARCHAR2(30);
    m_fk_column_name VARCHAR2(30);
    m_ref_column_name VARCHAR2(30);
    cleanup_m_table VARCHAR2(30);
    objclass ID_ARRAY;
    has_objclass_param BOOLEAN := FALSE;
  BEGIN
    ref_cursor := query_ref_fk(tab_name, schema_name);

    LOOP
      FETCH ref_cursor
      INTO n_table_name, n_fk_column_name, cleanup_n_table, is_child,
           m_table_name, m_fk_column_name, m_ref_column_name, cleanup_m_table;
      EXIT WHEN ref_cursor%NOTFOUND;

      IF ref_block IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      IF (
        cleanup_n_table IS NOT NULL
        OR cleanup_m_table IS NOT NULL
      ) THEN
        IF m_table_name IS NULL THEN
          IF is_child = 1 THEN
            -- find objectclass of child to set filter
            EXECUTE IMMEDIATE 'SELECT '||schema_name||'.citydb_objclass.table_name_to_objectclass_ids(:1) FROM dual'
              INTO objclass USING n_table_name;

            -- if found set objectclass condition
            IF objclass IS NOT EMPTY THEN
              IF child_ref_block IS NULL THEN
                -- create dummy function as it is needed in delete function for child
                create_array_delete_post_dummy(tab_name, schema_name);
                child_ref_block := '';
              END IF;
              child_ref_block := child_ref_block ||
                  chr(10)||'  -- delete '||lower(n_table_name)||'s'
                ||chr(10)||'  IF class_ids MULTISET INTERSECT ID_ARRAY('||citydb_util.id_array2string(objclass, ',')||') IS NOT EMPTY THEN'
                ||chr(10)||'    deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_'||citydb_util.get_short_name(n_table_name, schema_name)||'_batch(pids, class_ids), ID_ARRAY());'
                ||chr(10)||'  END IF;'
                ||chr(10);
            ELSE
              ref_block := ref_block ||
                  chr(10)||'  -- delete '||lower(n_table_name)||'s'
                ||chr(10)||'  dummy_ids := delete_'||citydb_util.get_short_name(n_table_name, schema_name)||'_batch(pids);'
                ||chr(10);
            END IF;
          ELSE
            IF vars IS NULL OR INSTR(vars, 'child_ids') = 0 THEN
              vars := vars ||chr(10)|| '  child_ids ID_ARRAY;';
            END IF;

            -- check if delete function for n_table_name has objclass_id parameter
            has_objclass_param := has_objclass_id(n_table_name, schema_name) = 1;

            IF has_objclass_param THEN
              IF vars IS NULL OR INSTR(vars, 'child_class_ids') = 0 THEN
                vars := vars ||chr(10)|| '  child_class_ids ID_ARRAY;';
              END IF;
            END IF;

            ref_block := ref_block || gen_delete_ref_by_ids_call(n_table_name, n_fk_column_name, has_objclass_param, schema_name);
          END IF;

          -- create array delete function for referencing childs
          IF lower(n_table_name) || '_array' NOT MEMBER OF ref_path THEN
            ref_path := citydb_delete_gen.create_array_delete_function(n_table_name, schema_name, ref_path);
          END IF;
        ELSE
          vars := vars
            ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids ID_ARRAY;'
            ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_pids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_ids_call(n_table_name, n_fk_column_name, m_table_name, m_fk_column_name, schema_name);

          -- create array delete function for referencing features
          IF lower(m_table_name) || '_array' NOT MEMBER OF ref_path THEN
            ref_path := citydb_delete_gen.create_array_delete_function(m_table_name, schema_name, ref_path);
          END IF;
        END IF;
      ELSE
        IF m_table_name IS NULL THEN
          ref_block := ref_block || gen_delete_ref_by_ids_stmt(n_table_name, n_fk_column_name);
        ELSE
          vars := vars ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_ids_stmt(n_table_name, n_fk_column_name, m_table_name, m_fk_column_name, m_ref_column_name, schema_name);
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
        chr(10)||'  -- delete '||lower(tab_name)
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(fk_column_name)||' = pid;'
      ||chr(10);
  END;

  FUNCTION gen_delete_ref_by_id_call(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
  BEGIN
    IF has_objclass_param THEN
      RETURN
          chr(10)||'  -- delete '||lower(tab_name)||'s'
        ||chr(10)||'  SELECT'
        ||chr(10)||'    id,'
        ||chr(10)||'    objectclass_id'
        ||chr(10)||'  BULK COLLECT INTO'
        ||chr(10)||'    child_ids,'
        ||chr(10)||'    child_class_ids'
        ||chr(10)||'  FROM'
        ||chr(10)||'    '||lower(tab_name)
        ||chr(10)||'  WHERE'
        ||chr(10)||'    '||lower(fk_column_name)||' = pid;'
        ||chr(10)
        ||chr(10)||'  IF child_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(child_ids, SET(child_class_ids));'
        ||chr(10)||'  END IF;'
        ||chr(10);
    ELSE
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
        ||chr(10)||'  IF child_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(child_ids);'
        ||chr(10)||'  END IF;'
        ||chr(10);
    END IF;
  END;

  FUNCTION gen_delete_m_ref_by_id_stmt(
    m_table_name VARCHAR2,
    m_fk_column_name VARCHAR2,
    fk_table_name STRARRAY,
    fk_columns STRARRAY,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    stmt VARCHAR2(8000);
    where_clause VARCHAR2(4000);
  BEGIN
    stmt := 
        chr(10)||'  -- delete '||lower(m_table_name)||' not being referenced any more'
      ||chr(10)||'  IF '||citydb_util.get_short_name(m_table_name, schema_name)||'_ref_id IS NOT NULL THEN'
      ||chr(10)||'    DELETE FROM'
      ||chr(10)||'      '||lower(m_table_name)||' m'
      ||chr(10)||'    WHERE EXISTS ('
      ||chr(10)||'      SELECT'
      ||chr(10)||'        1'
      ||chr(10)||'      FROM'
      ||chr(10)||'        TABLE(ID_ARRAY('||citydb_util.get_short_name(m_table_name, schema_name)||'_ref_id)) a';

    where_clause := 
        chr(10)||'      WHERE'
      ||chr(10)||'        m.'||lower(m_fk_column_name)||' = a.COLUMN_VALUE';

    FOR t IN
      fk_table_name.FIRST .. fk_table_name.LAST
    LOOP
      stmt := stmt
        ||chr(10)||'      LEFT JOIN'
        ||chr(10)||'        '||lower(fk_table_name(t))||' n'||t
        ||chr(10)||'        ON n'||t||'.'||lower(fk_columns(t))||' = a.COLUMN_VALUE';

      where_clause := where_clause
        ||chr(10)||'        AND n'||t||'.'||lower(fk_columns(t))||' IS NULL';
    END LOOP;

    stmt := stmt
      || where_clause
      ||chr(10)||'    );'
      ||chr(10)||'  END IF;'
      ||chr(10);

    RETURN stmt;
  END;

  FUNCTION gen_delete_m_ref_by_id_call(
    m_table_name VARCHAR2,
    fk_table_name STRARRAY,
    fk_columns STRARRAY,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    call_stmt VARCHAR2(8000);
    where_clause VARCHAR2(4000);
    where_and VARCHAR2(4) := '';
  BEGIN
    call_stmt :=
        chr(10)||'  -- delete '||lower(m_table_name)||' not being referenced any more'
      ||chr(10)||'  IF '||citydb_util.get_short_name(m_table_name, schema_name)||'_ref_id IS NOT NULL THEN'
      ||chr(10)||'    SELECT'
      ||chr(10)||'      a.COLUMN_VALUE'
      ||chr(10)||'    INTO'
      ||chr(10)||'      '||citydb_util.get_short_name(m_table_name, schema_name)||'_pid'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(ID_ARRAY('||citydb_util.get_short_name(m_table_name, schema_name)||'_ref_id)) a';

    where_clause := chr(10)||'    WHERE';

    FOR t IN
      fk_table_name.FIRST .. fk_table_name.LAST
    LOOP
      call_stmt := call_stmt      
        ||chr(10)||'    LEFT JOIN'
        ||chr(10)||'      '||lower(fk_table_name(t))||' n'||t
        ||chr(10)||'      ON n'||t||'.'||lower(fk_columns(t))||' = a.COLUMN_VALUE';

      where_clause := where_clause
        ||chr(10)||'      '||where_and||'n'||t||'.'||lower(fk_columns(t))||' IS NULL';

      where_and := 'AND ';
    END LOOP;

    call_stmt := call_stmt
      || where_clause || ';'
      ||chr(10)
      ||chr(10)||'    IF '||citydb_util.get_short_name(m_table_name, schema_name)||'_pid IS NOT NULL THEN'
      ||chr(10)||'      dummy_id := delete_'||citydb_util.get_short_name(m_table_name, schema_name)||'('||citydb_util.get_short_name(m_table_name, schema_name)||'_pid);'
      ||chr(10)||'    END IF;'
      ||chr(10)||'  END IF;'
      ||chr(10);

    RETURN call_stmt;
  END;

  FUNCTION gen_delete_n_m_ref_by_id_stmt(
    n_m_table_name VARCHAR2,
    n_fk_column_name VARCHAR2,
    m_table_name VARCHAR2,
    m_fk_column_name VARCHAR2,
    m_ref_column_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    ref_tables STRARRAY;
    ref_columns STRARRAY;
  BEGIN
    query_ref_tables_and_columns(m_table_name, n_m_table_name, schema_name, ref_tables, ref_columns);
    ref_tables := STRARRAY(n_m_table_name) MULTISET UNION ALL COALESCE(ref_tables, STRARRAY());
    ref_columns := STRARRAY(m_fk_column_name) MULTISET UNION ALL COALESCE(ref_columns, STRARRAY());

    RETURN
        chr(10)||'  -- delete references to '||lower(m_table_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_table_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(n_fk_column_name)||' = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||lower(m_fk_column_name)
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_stmt(m_table_name, m_ref_column_name, ref_tables, ref_columns, schema_name);
  END;

  FUNCTION gen_delete_n_m_ref_by_id_call(
    n_m_table_name VARCHAR2,
    n_fk_column_name VARCHAR2,
    m_table_name VARCHAR2,
    m_fk_column_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    ref_tables STRARRAY;
    ref_columns STRARRAY;
  BEGIN
    query_ref_tables_and_columns(m_table_name, n_m_table_name, schema_name, ref_tables, ref_columns);
    ref_tables := STRARRAY(n_m_table_name) MULTISET UNION ALL COALESCE(ref_tables, STRARRAY());
    ref_columns := STRARRAY(m_fk_column_name) MULTISET UNION ALL COALESCE(ref_columns, STRARRAY());

    RETURN
        chr(10)||'  -- delete references to '||lower(m_table_name)||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(n_m_table_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(n_fk_column_name)||' = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||lower(m_fk_column_name)
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids;'
      ||chr(10)|| gen_delete_m_ref_by_ids_call(m_table_name, ref_tables, ref_columns, schema_name);
  END;

  PROCEDURE create_ref_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    ref_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    child_ref_block OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_cursor SYS_REFCURSOR;
    n_table_name VARCHAR2(30);
    n_fk_column_name VARCHAR2(30);
    cleanup_n_table VARCHAR2(30);
    is_child NUMBER;
    m_table_name VARCHAR2(30);
    m_fk_column_name VARCHAR2(30);
    m_ref_column_name VARCHAR2(30);
    cleanup_m_table VARCHAR2(30);
    objclass ID_ARRAY;
    has_objclass_param BOOLEAN := FALSE;
  BEGIN
    ref_cursor := query_ref_fk(tab_name, schema_name);

    LOOP
      FETCH ref_cursor
      INTO n_table_name, n_fk_column_name, cleanup_n_table, is_child,
           m_table_name, m_fk_column_name, m_ref_column_name, cleanup_m_table;
      EXIT WHEN ref_cursor%NOTFOUND;

      IF ref_block IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      IF (
        cleanup_n_table IS NOT NULL
        OR cleanup_m_table IS NOT NULL
      ) THEN
        IF is_child = 1 THEN
          -- find objectclass of child to set filter
          EXECUTE IMMEDIATE 'SELECT '||schema_name||'.citydb_objclass.table_name_to_objectclass_ids(:1) FROM dual'
            INTO objclass USING n_table_name;

          -- if found set objectclass condition
          IF objclass IS NOT EMPTY THEN
            IF child_ref_block IS NULL THEN
              -- create dummy function as it is needed in delete function for child
              create_delete_post_dummy(tab_name, schema_name);
              child_ref_block := '';
            END IF;
            child_ref_block := child_ref_block ||
                chr(10)||'  -- delete '||lower(n_table_name)
              ||chr(10)||'  IF class_id IN ('||citydb_util.id_array2string(objclass, ',')||') THEN'
              ||chr(10)||'    deleted_id := delete_'||citydb_util.get_short_name(n_table_name, schema_name)||'(pid, class_id);'
              ||chr(10)||'  END IF;'
              ||chr(10);
          ELSE
            ref_block := ref_block ||
                chr(10)||'  -- delete '||lower(n_table_name)
              ||chr(10)||'  dummy_id := delete_'||citydb_util.get_short_name(n_table_name, schema_name)||'(pid);'
              ||chr(10);
          END IF;

          -- create delete function for child
          IF lower(n_table_name) NOT MEMBER OF ref_path THEN
            ref_path := citydb_delete_gen.create_delete_function(n_table_name, schema_name, ref_path);
          END IF;
        ELSE
          IF m_table_name IS NULL THEN
            IF vars IS NULL OR INSTR(vars, 'child_ids') = 0 THEN
              vars := vars ||chr(10)|| '  child_ids ID_ARRAY;';
            END IF;

            -- check if delete function for n_table_name has objclass_id parameter
            has_objclass_param := has_objclass_id(n_table_name, schema_name) = 1;

            IF has_objclass_param THEN
              IF vars IS NULL OR INSTR(vars, 'child_class_ids') = 0 THEN
                vars := vars ||chr(10)|| '  child_class_ids ID_ARRAY;';
              END IF;
            END IF;

            ref_block := ref_block || gen_delete_ref_by_id_call(n_table_name, n_fk_column_name, has_objclass_param, schema_name);
          ELSE
            vars := vars
              ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids ID_ARRAY;'
              ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_pids ID_ARRAY;';
            ref_block := ref_block || gen_delete_n_m_ref_by_id_call(n_table_name, n_fk_column_name, m_table_name, m_fk_column_name, schema_name);
          END IF;

          -- create array delete function for referencing features
          IF lower(COALESCE(m_table_name, n_table_name)) || '_array' NOT MEMBER OF ref_path THEN
            ref_path := citydb_delete_gen.create_array_delete_function(COALESCE(m_table_name, n_table_name), schema_name, ref_path);
          END IF;
        END IF;
      ELSE
        IF m_table_name IS NULL THEN
          ref_block := ref_block || gen_delete_ref_by_id_stmt(n_table_name, n_fk_column_name);
        ELSE
          vars := vars ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids ID_ARRAY;';
          ref_block := ref_block || gen_delete_n_m_ref_by_id_stmt(n_table_name, n_fk_column_name, m_table_name, m_fk_column_name, m_ref_column_name, schema_name);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;


  /*****************************
  * 2. Self references
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
    self_fk_column_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE,
    schema_name VARCHAR2 := USER
  ) RETURN VARCHAR2
  IS
  BEGIN
    IF has_objclass_param THEN
      RETURN
          chr(10)||'  -- delete referenced parts'
        ||chr(10)||'  SELECT'
        ||chr(10)||'    t.id,'
        ||chr(10)||'    t.objectclass_id'
        ||chr(10)||'  BULK COLLECT INTO'
        ||chr(10)||'    part_ids,'
        ||chr(10)||'    part_class_ids'
        ||chr(10)||'  FROM'
        ||chr(10)||'    '||lower(tab_name)||' t,'
        ||chr(10)||'    TABLE(pids) a'
        ||chr(10)||'  WHERE'
        ||chr(10)||'    t.'||lower(self_fk_column_name)||' = a.COLUMN_VALUE'
        ||chr(10)||'    AND t.id != a.COLUMN_VALUE;'
        ||chr(10)
        ||chr(10)||'  IF part_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(part_ids, SET(part_class_ids));'
        ||chr(10)||'  END IF;'
        ||chr(10);
    ELSE
      RETURN
          chr(10)||'  -- delete referenced parts'
        ||chr(10)||'  SELECT'
        ||chr(10)||'    t.id'
        ||chr(10)||'  BULK COLLECT INTO'
        ||chr(10)||'    part_ids'
        ||chr(10)||'  FROM'
        ||chr(10)||'    '||lower(tab_name)||' t,'
        ||chr(10)||'    TABLE(pids) a'
        ||chr(10)||'  WHERE'
        ||chr(10)||'    t.'||lower(self_fk_column_name)||' = a.COLUMN_VALUE'
        ||chr(10)||'    AND t.id != a.COLUMN_VALUE;'
        ||chr(10)
        ||chr(10)||'  IF part_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(part_ids);'
        ||chr(10)||'  END IF;'
        ||chr(10);
    END IF;
  END;

  PROCEDURE create_selfref_array_delete(
    tab_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE,
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
        create_array_delete_dummy(tab_name, schema_name);
        vars := chr(10)|| '  part_ids ID_ARRAY;';
        IF has_objclass_param THEN
          vars := vars ||chr(10)|| '  part_class_ids ID_ARRAY;';
        END IF;
        self_block := '';
      END IF;

      self_block := self_block || gen_delete_selfref_by_ids_call(tab_name, parent_column, has_objclass_param, schema_name);
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  FUNCTION gen_delete_selfref_by_id_call(
    tab_name VARCHAR2,
    self_fk_column_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE,
    schema_name VARCHAR2 := USER
  ) RETURN VARCHAR2
  IS
  BEGIN
    IF has_objclass_param THEN
      RETURN
          chr(10)||'  -- delete referenced parts'
        ||chr(10)||'  SELECT'
        ||chr(10)||'    id,'
        ||chr(10)||'    objectclass_id'
        ||chr(10)||'  BULK COLLECT INTO'
        ||chr(10)||'    part_ids,'
        ||chr(10)||'    part_class_ids'
        ||chr(10)||'  FROM'
        ||chr(10)||'    '||lower(tab_name)
        ||chr(10)||'  WHERE'
        ||chr(10)||'    '||lower(self_fk_column_name)||' = pid'
        ||chr(10)||'    AND id != pid;'
        ||chr(10)
        ||chr(10)||'  IF part_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(part_ids, SET(part_class_ids));'
        ||chr(10)||'  END IF;'
        ||chr(10);    
    ELSE
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
        ||chr(10)||'  IF part_ids IS NOT EMPTY THEN'
        ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch(part_ids);'
        ||chr(10)||'  END IF;'
        ||chr(10);
    END IF;
  END;

  PROCEDURE create_selfref_delete(
    tab_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE,
    schema_name VARCHAR2 := USER,
    selfref_path IN OUT STRARRAY,
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
        vars := chr(10)|| '  part_ids ID_ARRAY;';
        IF has_objclass_param THEN
          vars := vars ||chr(10)|| '  part_class_ids ID_ARRAY;';
        END IF;
        self_block := '';
      END IF;

      self_block := self_block || gen_delete_selfref_by_id_call(tab_name, parent_column, has_objclass_param, schema_name);
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
    tab_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE
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
      ||chr(10)||'      TABLE(pids) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.id'     
      ||chr(10)||'    )'
      || CASE WHEN has_objclass_param
           THEN chr(10)||'    AND t.objectclass_id MEMBER OF class_ids'
           ELSE ''
         END           
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    id';
  END;

  -- SINGLE CASE
  FUNCTION gen_delete_by_id_stmt(
    tab_name VARCHAR2,
    has_objclass_param BOOLEAN := FALSE
    ) RETURN VARCHAR2
  IS
  BEGIN
    RETURN
        chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||lower(tab_name)
      ||chr(10)||'  WHERE'
      ||chr(10)||'    id = pid'
      || CASE WHEN has_objclass_param
           THEN chr(10)||'    AND objectclass_id = class_id'
           ELSE ''
         END 
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
        a_ref.table_name AS ref_table_name,
        a_ref.column_name AS ref_column_name,
        LISTAGG(ac.column_name, ','||chr(10)||'    ') WITHIN GROUP (ORDER BY ac.position) AS fk_columns,
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
        AND a_ref.table_name <> 'CITYOBJECT'
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
    ref_to_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    returning_block OUT VARCHAR2,
    collect_block OUT VARCHAR2,
    into_block OUT VARCHAR2,
    fk_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    ref_table_name VARCHAR2(30);
    ref_column_name VARCHAR2(30);
    fk_columns VARCHAR2(1000);
    cleanup_ref_table VARCHAR2(30);
    ref_to_ref_tables STRARRAY;
    ref_to_ref_columns STRARRAY;
    ref_tables STRARRAY;
    ref_columns STRARRAY;
  BEGIN
    ref_to_cursor := query_ref_to_fk(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO ref_table_name, ref_column_name, fk_columns, cleanup_ref_table;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        returning_block := '';
        collect_block := '';
        into_block := '';
        fk_block := '';
      END IF;

      returning_block := returning_block ||','||chr(10)||'    '|| lower(fk_columns);

      -- prepare arrays for referencing tables and columns to cleanup
      ref_to_ref_tables := STRARRAY();
      ref_to_ref_columns := citydb_util.split(fk_columns, ','||chr(10)||'    ');
      FOR c IN
        ref_to_ref_columns.FIRST .. ref_to_ref_columns.LAST
      LOOP
        ref_to_ref_tables.extend;
        ref_to_ref_tables(ref_to_ref_tables.count) := tab_name;
      END LOOP;

      IF ref_to_ref_columns.count > 1 THEN
        -- additional collections and initialization of final list for referencing IDs required
        vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids ID_ARRAY := ID_ARRAY();';
        collect_block := collect_block||chr(10)||'  -- collect all '||citydb_util.get_short_name(ref_table_name, schema_name)||' ids into one nested table'||chr(10);
        FOR i IN 1..ref_to_ref_columns.count LOOP
          vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids'||i||' ID_ARRAY;';
          into_block := into_block ||','||chr(10)||'    '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids'||i;
          collect_block := collect_block||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids := '
            ||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids MULTISET UNION ALL '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids'||i||';'||chr(10);
        END LOOP;
      ELSE
        vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids ID_ARRAY;';
        into_block := into_block ||','||chr(10)||'    '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids';
      END IF;

      IF
        ref_table_name <> 'IMPLICIT_GEOMETRY'
        AND ref_table_name <> 'SURFACE_GEOMETRY'
        AND ref_table_name <> 'CITYOBJECT'
      THEN
        query_ref_tables_and_columns(ref_table_name, tab_name, schema_name, ref_tables, ref_columns);
        ref_to_ref_tables := ref_to_ref_tables MULTISET UNION ALL COALESCE(ref_tables, STRARRAY());
        ref_to_ref_columns := ref_to_ref_columns MULTISET UNION ALL COALESCE(ref_columns, STRARRAY());
      END IF;

      IF cleanup_ref_table IS NOT NULL THEN
        -- function call required, so create function first
        IF lower(ref_table_name) || '_array' NOT MEMBER OF ref_to_path THEN
          ref_to_path := citydb_delete_gen.create_array_delete_function(ref_table_name, schema_name, ref_to_path);
        END IF;
        vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_pids ID_ARRAY;';
        fk_block := fk_block || gen_delete_m_ref_by_ids_call(ref_table_name, ref_to_ref_tables, ref_to_ref_columns, schema_name);
      ELSE
        fk_block := fk_block || gen_delete_m_ref_by_ids_stmt(ref_table_name, ref_column_name, ref_to_ref_tables, ref_to_ref_columns, schema_name);
      END IF;
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  PROCEDURE create_ref_to_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    ref_to_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    returning_block OUT VARCHAR2,
    into_block OUT VARCHAR2,
    fk_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    ref_table_name VARCHAR2(30);
    ref_column_name VARCHAR2(30);
    fk_columns VARCHAR2(1000);
    cleanup_ref_table VARCHAR2(30);
    fk_columns_count NUMBER;
    ref_to_ref_tables STRARRAY;
    ref_to_ref_columns STRARRAY;
    ref_tables STRARRAY;
    ref_columns STRARRAY;
  BEGIN
    ref_to_cursor := query_ref_to_fk(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO ref_table_name, ref_column_name, fk_columns, cleanup_ref_table;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        returning_block := '';
        into_block := '';
        fk_block := '';
      END IF;

      -- prepare arrays for referencing tables and columns to cleanup
      ref_to_ref_tables := STRARRAY();
      ref_to_ref_columns := citydb_util.split(fk_columns, ','||chr(10)||'    ');
      fk_columns_count := ref_to_ref_columns.count;
      FOR c IN
        ref_to_ref_columns.FIRST .. ref_to_ref_columns.LAST
      LOOP
        ref_to_ref_tables.extend;
        ref_to_ref_tables(ref_to_ref_tables.count) := tab_name;
      END LOOP;

      IF fk_columns_count > 1 THEN
        vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids ID_ARRAY;';
        returning_block := returning_block||','
          ||chr(10)||'    ID_ARRAY('
          ||chr(10)||'    '||lower(fk_columns)
          ||chr(10)||'    )';
        into_block := into_block||','||chr(10)||'    '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ids';
      ELSE
        vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ref_id NUMBER;';
        returning_block := returning_block ||','||chr(10)||'    '||lower(fk_columns);
        into_block := into_block||','||chr(10)||'    '||citydb_util.get_short_name(ref_table_name, schema_name)||'_ref_id';
      END IF;

      IF
        ref_table_name <> 'IMPLICIT_GEOMETRY'
        AND ref_table_name <> 'SURFACE_GEOMETRY'
        AND ref_table_name <> 'CITYOBJECT'
      THEN
        query_ref_tables_and_columns(ref_table_name, tab_name, schema_name, ref_tables, ref_columns);
        ref_to_ref_tables := ref_to_ref_tables MULTISET UNION ALL COALESCE(ref_tables, STRARRAY());
        ref_to_ref_columns := ref_to_ref_columns MULTISET UNION ALL COALESCE(ref_columns, STRARRAY());
      END IF;

      IF cleanup_ref_table IS NOT NULL THEN
        -- function call required, so create function first
        IF fk_columns_count > 1 THEN
          IF lower(ref_table_name) || '_array' NOT MEMBER OF ref_to_path THEN
            ref_to_path := citydb_delete_gen.create_array_delete_function(ref_table_name, schema_name, ref_to_path);
          END IF;
          vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_pids ID_ARRAY;';
          fk_block := fk_block || gen_delete_m_ref_by_ids_call(ref_table_name, ref_to_ref_tables, ref_to_ref_columns, schema_name);
        ELSE
          IF lower(ref_table_name) NOT MEMBER OF ref_to_path THEN
            ref_to_path := citydb_delete_gen.create_delete_function(ref_table_name, schema_name, ref_to_path);
          END IF;
          vars := vars ||chr(10)||'  '||citydb_util.get_short_name(ref_table_name, schema_name)||'_pid NUMBER;';
          fk_block := fk_block || gen_delete_m_ref_by_id_call(ref_table_name, ref_to_ref_tables, ref_to_ref_columns, schema_name);
        END IF;
      ELSE
        IF fk_columns_count > 1 THEN
          fk_block := fk_block || gen_delete_m_ref_by_ids_stmt(ref_table_name, ref_column_name, ref_to_ref_tables, ref_to_ref_columns, schema_name);
        ELSE
          fk_block := fk_block || gen_delete_m_ref_by_id_stmt(ref_table_name, ref_column_name, ref_to_ref_tables, ref_to_ref_columns, schema_name);
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
    parent_table VARCHAR2(30);
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
      AND pk.position = 1;

    RETURN parent_table;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN '';
  END;

  -- ARRAY CASE
  PROCEDURE create_ref_parent_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    ref_to_parent_path IN OUT STRARRAY,
    parent_block OUT VARCHAR2
    ) 
  IS
    parent_table VARCHAR2(30);
    objclass ID_ARRAY;
  BEGIN
    -- check if given table has objectclass_id column
    EXECUTE IMMEDIATE 'SELECT '||schema_name||'.citydb_objclass.table_name_to_objectclass_ids(:1) FROM dual'
      INTO objclass USING tab_name;

    -- if found delete parent object
    IF objclass IS NOT EMPTY THEN
      parent_table := query_ref_parent_fk(tab_name, schema_name);

      IF parent_table IS NOT NULL THEN
        IF lower(parent_table) || '_array' NOT MEMBER OF ref_to_parent_path THEN
          ref_to_parent_path := citydb_delete_gen.create_array_delete_function(parent_table, schema_name, ref_to_parent_path);
        END IF;
        parent_block :=
            chr(10)||'  -- delete '||lower(parent_table)||'s'
          ||chr(10)||'  IF deleted_ids IS NOT EMPTY THEN'
          ||chr(10)||'    dummy_ids := delete_'||citydb_util.get_short_name(parent_table, schema_name)||'_post_bat(deleted_ids, class_ids);'
          ||chr(10)||'  END IF;'
          ||chr(10);
      END IF;
    END IF;

    RETURN;
  END;

  -- SINGLE CASE
  PROCEDURE create_ref_parent_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    ref_to_parent_path IN OUT STRARRAY,
    parent_block OUT VARCHAR2
    ) 
  IS
    parent_table VARCHAR2(30);
    objclass ID_ARRAY;
  BEGIN
    -- check if given table has objectclass_id column
    EXECUTE IMMEDIATE 'SELECT '||schema_name||'.citydb_objclass.table_name_to_objectclass_ids(:1) FROM dual'
      INTO objclass USING tab_name;

    -- if found delete parent object
    IF objclass IS NOT EMPTY THEN
      parent_table := query_ref_parent_fk(tab_name, schema_name);

      IF parent_table IS NOT NULL THEN
        IF lower(parent_table) NOT MEMBER OF ref_to_parent_path THEN
          ref_to_parent_path := citydb_delete_gen.create_delete_function(parent_table, schema_name, ref_to_parent_path);
        END IF;
        parent_block :=
            chr(10)||'  -- delete '||lower(parent_table)
          ||chr(10)||'  IF deleted_id IS NOT NULL THEN'
          ||chr(10)||'    dummy_id := delete_'||citydb_util.get_short_name(parent_table, schema_name)||'_post(deleted_id, class_id);'
          ||chr(10)||'  END IF;'
          ||chr(10);
      END IF;
    END IF;

    RETURN;
  END;


  /**************************
  * CREATE DELETE FUNCTION
  **************************/
  -- dummy function to compile array delete functions
  PROCEDURE create_array_delete_dummy(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(500) := 
      'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch('
      || 'pids ID_ARRAY, '
      || 'objclass_ids ID_ARRAY := ID_ARRAY()'
      || ') RETURN ID_ARRAY'
      ||chr(10)||'IS'
      ||chr(10)||'  deleted_ids ID_ARRAY := ID_ARRAY();'
      ||chr(10)||'BEGIN'
      ||chr(10)||'  RETURN deleted_ids;'
      ||chr(10)||'END;';
  BEGIN
    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;

  -- dummy function to compile delete functions
  PROCEDURE create_delete_dummy(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(500) := 
      'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'('
      || 'pid NUMBER, '
      || 'objclass_id NUMBER := 0'
      || ') RETURN NUMBER'
      ||chr(10)||'IS'
      ||chr(10)||'  deleted_id NUMBER;'
      ||chr(10)||'BEGIN'
      ||chr(10)||'  RETURN deleted_id;'
      ||chr(10)||'END;';
  BEGIN
    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;

  -- dummy function to compile array delete functions
  PROCEDURE create_array_delete_post_dummy(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(500) := 
      'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_post_bat('
      || 'pids ID_ARRAY,'
      || 'objclass_ids ID_ARRAY'
      || ') RETURN ID_ARRAY'
      ||chr(10)||'IS'
      ||chr(10)||'  deleted_ids ID_ARRAY := ID_ARRAY();'
      ||chr(10)||'BEGIN'
      ||chr(10)||'  RETURN deleted_ids;'
      ||chr(10)||'END;';
  BEGIN
    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;

  -- dummy function to compile delete functions
  PROCEDURE create_delete_post_dummy(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(500) := 
      'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_post('
      || 'pid NUMBER,'
      || 'objclass_id NUMBER'
      || ') RETURN NUMBER'
      ||chr(10)||'IS'
      ||chr(10)||'  deleted_id NUMBER;'
      ||chr(10)||'BEGIN'
      ||chr(10)||'  RETURN deleted_id;'
      ||chr(10)||'END;';
  BEGIN
    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
  END;


  -- ARRAY CASE
  FUNCTION create_array_delete_function(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    path STRARRAY := STRARRAY()
    ) RETURN STRARRAY
  IS
    create_path STRARRAY := path;
    ddl_command VARCHAR2(32767) := 'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_batch';
    ddl_command_2 VARCHAR2(32767);
    has_objclass_param BOOLEAN := FALSE;
    declare_block VARCHAR2(1000) := '  deleted_ids ID_ARRAY := ID_ARRAY();';
    objclass_block VARCHAR2(11000) := '';
    objclass_filter_block VARCHAR2(10000) := '';
    pre_block VARCHAR2(12000) := '';
    post_block VARCHAR2(12000) := '';
    delete_block VARCHAR2(2000) := '';
    delete_into_block VARCHAR2(2000) :=
        chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    deleted_ids';
    vars VARCHAR2(1000);
    self_block VARCHAR2(2000);
    child_ref_block VARCHAR2(8000);
    ref_block VARCHAR2(8000);
    returning_block VARCHAR2(2000);
    collect_block VARCHAR2(2000);
    into_block VARCHAR2(2000);
    fk_block VARCHAR2(8000);
    parent_block VARCHAR2(1000);
    return_block VARCHAR2(30) := '  RETURN deleted_ids;';
  BEGIN
    -- add table_name to path
    create_path.extend;
    create_path(create_path.count) := lower(tab_name) || '_array';

    -- create dummy function in case it is needed for compiling subsequent functions
    create_array_delete_dummy(tab_name, schema_name);

    -- check if table contains objectclass_id column in order to create second parameter
    has_objclass_param := has_objclass_id(tab_name, schema_name) = 1;

    IF has_objclass_param THEN
      ddl_command := ddl_command || '(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY())';
      declare_block := declare_block ||chr(10)||'  class_ids ID_ARRAY;';
      objclass_block :=
          chr(10)||'  -- fetch objectclass_id if not set'
        ||chr(10)||'  IF objclass_ids IS EMPTY THEN'
        ||chr(10)||'    SELECT'
        ||chr(10)||'      DISTINCT t.objectclass_id'
        ||chr(10)||'    BULK COLLECT INTO'
        ||chr(10)||'      class_ids'
        ||chr(10)||'    FROM'
        ||chr(10)||'      '||lower(tab_name)|| ' t,'
        ||chr(10)||'      TABLE(pids) a'
        ||chr(10)||'    WHERE'
        ||chr(10)||'      t.id = a.COLUMN_VALUE;'
        ||chr(10)||'  ELSE'
        ||chr(10)||'    class_ids := SET(objclass_ids);'
        ||chr(10)||'  END IF;'
        ||chr(10)
        ||chr(10)||'  IF class_ids IS EMPTY THEN'
        ||chr(10)||'    DBMS_OUTPUT.PUT_LINE(''Objectclass_id unknown! Check OBJECTCLASS table.'');'
        ||chr(10)||'    RETURN NULL;'
        ||chr(10)||'  END IF;'
        ||chr(10);
    ELSE
      ddl_command := ddl_command || '(pids ID_ARRAY)';
    END IF;

    -- complete function header
    ddl_command := ddl_command || ' RETURN ID_ARRAY'||chr(10)||'IS'||chr(10);

    -- REFERENCING TABLES
    create_ref_array_delete(tab_name, schema_name, create_path, vars, child_ref_block, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    objclass_filter_block := objclass_filter_block || COALESCE(child_ref_block, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- if objclass_filter_block is set finish function here
    IF objclass_filter_block IS NOT NULL THEN
      ddl_command := ddl_command
                 ||'  deleted_ids ID_ARRAY := ID_ARRAY();'
        ||chr(10)||'  class_ids ID_ARRAY;'
        ||chr(10)||'BEGIN'
        || objclass_block
        || objclass_filter_block
        ||chr(10)||'  IF pids.count <> deleted_ids.count THEN'
        ||chr(10)||'    deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_post_bat(pids, class_ids), ID_ARRAY());'
        ||chr(10)||'  END IF;'
        ||chr(10)
        ||chr(10)|| return_block
        ||chr(10)||'END;';

      -- need to add _post delete method first
      ddl_command_2 := ddl_command;

      -- clear objclass_block as it is not needed in a _post delete method
      objclass_block := chr(10)||'  class_ids := objclass_ids;'||chr(10);

      -- start a seperate post function which is called by child delete functions
      ddl_command := 'CREATE OR REPLACE FUNCTION '
        ||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_post_bat'
        ||'(pids ID_ARRAY, objclass_ids ID_ARRAY) RETURN ID_ARRAY'||chr(10)||'IS'||chr(10);
    END IF;

    -- SELF REFERENCES
    create_selfref_array_delete(tab_name, has_objclass_param, schema_name, vars, self_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(self_block, '');

    -- MAIN DELETE
    delete_block := gen_delete_by_ids_stmt(tab_name, has_objclass_param);

    -- FOREIGN KEYs which are set to ON DELETE SET NULL and are nullable
    create_ref_to_array_delete(tab_name, schema_name, create_path, vars, returning_block, collect_block, into_block, fk_block);
    declare_block := declare_block || COALESCE(vars, '');
    delete_block := delete_block || COALESCE(returning_block, '');
    delete_into_block := delete_into_block || COALESCE(into_block, '');
    post_block := post_block || COALESCE(collect_block, '') || COALESCE(fk_block, '');

    -- FOREIGN KEY which cover same columns AS primary key
    create_ref_parent_array_delete(tab_name, schema_name, create_path, parent_block);
    post_block := post_block || COALESCE(parent_block, '');

    -- create dummy variable if pre or post block are not null
    IF pre_block IS NOT NULL OR post_block IS NOT NULL THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY;';
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || objclass_block
      || pre_block
      ||chr(10)||'  -- delete '||lower(tab_name)||'s'
      || delete_block
      || delete_into_block || ';'
      ||chr(10)
      || post_block
      ||chr(10)|| return_block
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
    IF ddl_command_2 IS NOT NULL THEN
      EXECUTE IMMEDIATE ddl_command_2;
      COMMIT;
    END IF;

    RETURN create_path;
  END;

  -- SINGLE CASE
  FUNCTION create_delete_function(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    path STRARRAY := STRARRAY()
    ) RETURN STRARRAY
  IS
    create_path STRARRAY := path;
    ddl_command VARCHAR2(32767) := 'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name);
    ddl_command_2 VARCHAR2(32767);
    has_objclass_param BOOLEAN := FALSE;
    declare_block VARCHAR2(1000) := '  deleted_id NUMBER;';
    objclass_block VARCHAR2(11000) := '';
    objclass_filter_block VARCHAR2(10000) := '';
    pre_block VARCHAR2(12000) := '';
    post_block VARCHAR2(12000) := '';
    delete_block VARCHAR2(2000) := '';
    delete_into_block VARCHAR2(2000) := 
        chr(10)||'  INTO'
      ||chr(10)||'    deleted_id';
    vars VARCHAR2(1000);
    self_block VARCHAR2(2000);
    child_ref_block VARCHAR2(8000);
    ref_block VARCHAR2(8000);
    returning_block VARCHAR2(2000);
    into_block VARCHAR2(2000);
    fk_block VARCHAR2(8000);
    parent_block VARCHAR2(1000);
    return_block VARCHAR2(30) := '  RETURN deleted_id;';
  BEGIN
    -- add table_name to path
    create_path.extend;
    create_path(create_path.count) := lower(tab_name);

    -- create dummy function in case it is needed for compiling subsequent functions
    create_delete_dummy(tab_name, schema_name);

    -- check if table contains objectclass_id column in order to create second parameter
    has_objclass_param := has_objclass_id(tab_name, schema_name) = 1;

    IF has_objclass_param THEN
      ddl_command := ddl_command || '(pid NUMBER, objclass_id NUMBER := 0)';
      declare_block := declare_block ||chr(10)||'  class_id NUMBER;';
      objclass_block :=
          chr(10)||'  -- fetch objectclass_id if not set'
        ||chr(10)||'  IF objclass_id = 0 THEN'
        ||chr(10)||'    SELECT'
        ||chr(10)||'      objectclass_id'
        ||chr(10)||'    INTO'
        ||chr(10)||'      class_id'
        ||chr(10)||'    FROM'
        ||chr(10)||'      '||lower(tab_name)
        ||chr(10)||'    WHERE'
        ||chr(10)||'      id = pid;'
        ||chr(10)||'  ELSE'
        ||chr(10)||'    class_id := objclass_id;'
        ||chr(10)||'  END IF;'
        ||chr(10)
        ||chr(10)||'  IF class_id IS NULL THEN'
        ||chr(10)||'    DBMS_OUTPUT.PUT_LINE(''Objectclass_id unknown! Check OBJECTCLASS table.'');'
        ||chr(10)||'    RETURN NULL;'
        ||chr(10)||'  END IF;'
        ||chr(10);
    ELSE
      ddl_command := ddl_command || '(pid NUMBER)';
    END IF;

    -- complete function header
    ddl_command := ddl_command || ' RETURN NUMBER'||chr(10)||'IS'||chr(10);

    -- REFERENCING TABLES
    create_ref_delete(tab_name, schema_name, create_path, vars, child_ref_block, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    objclass_filter_block := objclass_filter_block || COALESCE(child_ref_block, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- if objclass_filter_block is set finish function here
    IF objclass_filter_block IS NOT NULL THEN
      ddl_command := ddl_command
                 ||'  deleted_id NUMBER;'
        ||chr(10)||'  class_id NUMBER;'
        ||chr(10)||'BEGIN'
        || objclass_block
        || objclass_filter_block
        ||chr(10)||'  IF deleted_id IS NULL THEN'
        ||chr(10)||'    deleted_id := delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_post(pid, class_id);'
        ||chr(10)||'  END IF;'
        ||chr(10)
        ||chr(10)|| return_block
        ||chr(10)||'END;';

      -- need to add _post delete method first
      ddl_command_2 := ddl_command;

      -- clear objclass_block as it is not needed in a _post delete method
      objclass_block := chr(10)||'  class_id := objclass_id;'||chr(10);

      -- start a seperate post function which is called by child delete functions
      ddl_command := 'CREATE OR REPLACE FUNCTION '
        ||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_post'
        ||'(pid NUMBER, objclass_id NUMBER) RETURN NUMBER'||chr(10)||'IS'||chr(10);
    END IF;

    -- SELF REFERENCES
    create_selfref_delete(tab_name, has_objclass_param, schema_name, create_path, vars, self_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(self_block, '');

    -- MAIN DELETE
    delete_block := gen_delete_by_id_stmt(tab_name, has_objclass_param);

    -- FOREIGN KEY which are set to ON DELETE SET NULL and are nullable
    create_ref_to_delete(tab_name, schema_name, create_path, vars, returning_block, into_block, fk_block);
    declare_block := declare_block || COALESCE(vars, '');
    delete_block := delete_block || COALESCE(returning_block, '');
    delete_into_block := delete_into_block || COALESCE(into_block, '');
    post_block := post_block || COALESCE(fk_block, '');

    -- FOREIGN KEY which cover same columns AS primary key
    create_ref_parent_delete(tab_name, schema_name, create_path, parent_block);
    post_block := post_block || COALESCE(parent_block, '');

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
      || objclass_block
      || pre_block
      ||chr(10)||'  -- delete '||lower(tab_name)
      || delete_block
      || delete_into_block || ';'
      ||chr(10)
      || post_block
      ||chr(10)|| return_block
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
    COMMIT;
    IF ddl_command_2 IS NOT NULL THEN
      EXECUTE IMMEDIATE ddl_command_2;
      COMMIT;
    END IF;

    RETURN create_path;
  END;


  /*****************************
  * Referencing member 1:n
  *****************************/
  FUNCTION query_member_1n(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN SYS_REFCURSOR
  IS
    ref_to_cursor SYS_REFCURSOR;
  BEGIN
    OPEN ref_to_cursor FOR
      SELECT
        c.table_name AS member_table_name,
        ac.column_name AS member_fk_column
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
      WHERE
        c2.table_name = upper(tab_name)
        AND c2.owner = upper(schema_name)
        AND c.constraint_type = 'R'
        AND c.delete_rule = 'SET NULL'
        AND c.table_name IN
        (
        SELECT
          fk.table_name
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
          fk2.table_name = upper(tab_name)
          AND fk2.owner = upper(schema_name)
          AND fk.constraint_type = 'R'
          AND pk.position = 1
        );
    RETURN ref_to_cursor;
  END;

  -- ARRAY CASE
  PROCEDURE create_member_1n_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    member_1n_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    member_table_name VARCHAR2(30);
    member_fk_column VARCHAR2(30);
    has_objclass_param BOOLEAN := FALSE;
  BEGIN
    ref_to_cursor := query_member_1n(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO member_table_name, member_fk_column;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      -- function call required, so create function first
      IF lower(member_table_name) || '_array' NOT MEMBER OF member_1n_path THEN
        member_1n_path := citydb_delete_gen.create_array_delete_function(member_table_name, schema_name, member_1n_path);
      END IF;

      IF vars IS NULL OR INSTR(vars, 'child_ids') = 0 THEN
        vars := vars ||chr(10)|| '  child_ids ID_ARRAY;';
      END IF;

      -- check if delete function for member_table_name has objclass_id parameter
      has_objclass_param := has_objclass_id(member_table_name, schema_name) = 1;

      IF has_objclass_param THEN
        IF vars IS NULL OR INSTR(vars, 'child_class_ids') = 0 THEN
          vars := vars ||chr(10)|| '  child_class_ids ID_ARRAY;';
        END IF;
      END IF;
      
      ref_block := ref_block || gen_delete_ref_by_ids_call(member_table_name, member_fk_column, has_objclass_param, schema_name);
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  PROCEDURE create_member_1n_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    member_1n_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    member_table_name VARCHAR2(30);
    member_fk_column VARCHAR2(30);
    has_objclass_param BOOLEAN := FALSE;
  BEGIN
    ref_to_cursor := query_member_1n(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO member_table_name, member_fk_column;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      -- function call required, so create function first
      IF lower(member_table_name) || '_array' NOT MEMBER OF member_1n_path THEN
        member_1n_path := citydb_delete_gen.create_array_delete_function(member_table_name, schema_name, member_1n_path);
      END IF;

      IF vars IS NULL OR INSTR(vars, 'child_ids') = 0 THEN
        vars := vars ||chr(10)|| '  child_ids ID_ARRAY;';
      END IF;

      -- check if delete function for member_table_name has objclass_id parameter
      has_objclass_param := has_objclass_id(member_table_name, schema_name) = 1;

      IF has_objclass_param THEN
        IF vars IS NULL OR INSTR(vars, 'child_class_ids') = 0 THEN
          vars := vars ||chr(10)|| '  child_class_ids ID_ARRAY;';
        END IF;
      END IF;

      ref_block := ref_block || gen_delete_ref_by_id_call(member_table_name, member_fk_column, has_objclass_param, schema_name);
    END LOOP;

    RETURN;
  END;


  /*****************************
  * Referencing member n:m
  *****************************/
  FUNCTION query_member_nm(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN SYS_REFCURSOR
  IS
    ref_to_cursor SYS_REFCURSOR;
  BEGIN
    OPEN ref_to_cursor FOR
      SELECT
        c.table_name AS n_table_name,
        a.column_name AS n_fk_column_name,
        m.m_table_name,
        m.m_fk_column_name
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
      JOIN (
        SELECT
          mn.table_name,
          mn.owner,
          mn2.table_name AS m_table_name,
          mna.column_name AS m_fk_column_name
        FROM
          all_constraints mn
        JOIN
          all_cons_columns mna
          ON mna.constraint_name = mn.constraint_name
         AND mna.table_name = mn.table_name
         AND mna.owner = mn.owner
        JOIN 
          all_constraints mnp
          ON mnp.table_name = mn.table_name
         AND mnp.owner = mn.owner
        JOIN
          all_cons_columns mnpa
          ON mnpa.constraint_name = mnp.constraint_name
         AND mnpa.table_name = mn.table_name
         AND mnpa.owner = mn.owner
         AND mnpa.column_name = mna.column_name
        JOIN
          all_constraints mn2
          ON mn2.constraint_name = mn.r_constraint_name
         AND mn2.owner = mn.owner
        WHERE
          mn2.table_name <> mn.table_name
          AND mn.constraint_type = 'R'
          AND mn.delete_rule = 'CASCADE'
          AND mnp.constraint_type = 'P'
        ) m
        ON m.table_name = c.table_name
       AND m.owner = c.owner
      WHERE
        c2.table_name = upper(tab_name)
        AND c2.owner = upper(schema_name)
        AND c.constraint_type = 'R'
        AND c.delete_rule = 'CASCADE'
        AND c2.table_name <> m.m_table_name;
    RETURN ref_to_cursor;
  END;

  -- ARRAY CASE
  PROCEDURE create_member_nm_array_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    member_nm_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    n_table_name VARCHAR2(30);
    n_fk_column_name VARCHAR2(30);
    m_table_name VARCHAR2(30);
    m_fk_column_name VARCHAR2(30);
  BEGIN
    ref_to_cursor := query_member_nm(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO n_table_name, n_fk_column_name, m_table_name, m_fk_column_name;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      -- function call required, so create function first
      IF lower(m_table_name) || '_array' NOT MEMBER OF member_nm_path THEN
        member_nm_path := citydb_delete_gen.create_array_delete_function(m_table_name, schema_name, member_nm_path);
      END IF;

      vars := vars
        ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids ID_ARRAY;'
        ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_pids ID_ARRAY;';
      ref_block := ref_block || gen_delete_n_m_ref_by_ids_call(n_table_name, n_fk_column_name, m_table_name, m_fk_column_name, schema_name);
    END LOOP;

    RETURN;
  END;

  -- SINGLE CASE
  PROCEDURE create_member_nm_delete(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    member_nm_path IN OUT STRARRAY,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
    ref_to_cursor SYS_REFCURSOR;
    n_table_name VARCHAR2(30);
    n_fk_column_name VARCHAR2(30);
    m_table_name VARCHAR2(30);
    m_fk_column_name VARCHAR2(30);
  BEGIN
    ref_to_cursor := query_member_nm(tab_name, schema_name);

    LOOP
      FETCH ref_to_cursor
      INTO n_table_name, n_fk_column_name, m_table_name, m_fk_column_name;
      EXIT WHEN ref_to_cursor%NOTFOUND;

      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      -- function call required, so create function first
      IF lower(m_table_name) || '_array' NOT MEMBER OF member_nm_path THEN
        member_nm_path := citydb_delete_gen.create_array_delete_function(m_table_name, schema_name, member_nm_path);
      END IF;

      vars := vars
        ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_ids ID_ARRAY;'
        ||chr(10)||'  '||citydb_util.get_short_name(m_table_name, schema_name)||'_pids ID_ARRAY;';
      ref_block := ref_block || gen_delete_n_m_ref_by_id_call(n_table_name, n_fk_column_name, m_table_name, m_fk_column_name, schema_name);
    END LOOP;

    RETURN;
  END;


  /**************************
  * CREATE DELETE MEMBER FUNCTION
  **************************/
  FUNCTION create_array_delete_member_fct(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    path STRARRAY := STRARRAY()
    ) RETURN STRARRAY
  IS
    create_path STRARRAY := path;
    ddl_command VARCHAR2(30000) := 'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_w_mem_bat(pids ID_ARRAY) RETURN ID_ARRAY'||chr(10)||'IS'||chr(10);
    declare_block VARCHAR2(1000) := '  deleted_ids ID_ARRAY;';
    pre_block VARCHAR2(14000) := '';
    vars VARCHAR2(1000);
    ref_block VARCHAR2(14000);
  BEGIN
    -- add table_name to path
    create_path.extend;
    create_path(create_path.count) := lower(tab_name) || '_array_with_members';

    -- MEMBER REFERENCES 1:n
    create_member_1n_array_delete(tab_name, schema_name, create_path, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- MEMBER REFERENCES n:m
    create_member_nm_array_delete(tab_name, schema_name, create_path, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- create dummy variable if pre block is not null
    IF pre_block IS NOT NULL THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY;';
    END IF;

    -- delete member function is calling the regular delete function in the end
    -- so create regular delete function first
    IF lower(tab_name) || '_array' NOT MEMBER OF create_path THEN
      create_path := citydb_delete_gen.create_array_delete_function(tab_name, schema_name, create_path);
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || pre_block
      ||chr(10)||'  -- delete '||lower(tab_name)||'s'
      ||chr(10)||'  RETURN delete_' ||citydb_util.get_short_name(tab_name, schema_name)||'_batch(pids);'
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
    COMMIT;

    RETURN create_path;
  END;

  FUNCTION create_delete_member_fct(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    path STRARRAY := STRARRAY()
    ) RETURN STRARRAY
  IS
    create_path STRARRAY := path;
    ddl_command VARCHAR2(30000) := 'CREATE OR REPLACE FUNCTION '||schema_name||'.delete_'||citydb_util.get_short_name(tab_name, schema_name)||'_w_members(pid NUMBER) RETURN NUMBER'||chr(10)||'IS'||chr(10);
    declare_block VARCHAR2(1000) := '  deleted_id NUMBER;';
    pre_block VARCHAR2(14000) := '';
    vars VARCHAR2(1000);
    ref_block VARCHAR2(14000);
  BEGIN
    -- add table_name to path
    create_path.extend;
    create_path(create_path.count) := lower(tab_name) || '_with_members';

    -- MEMBER REFERENCES 1:n
    create_member_1n_delete(tab_name, schema_name, create_path, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- MEMBER REFERENCES n:m
    create_member_nm_delete(tab_name, schema_name, create_path, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- create dummy variable if pre block is not null
    IF pre_block IS NOT NULL THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY;';
    END IF;

    -- delete member function is calling the regular delete function in the end
    -- so create regular delete function first
    IF lower(tab_name) NOT MEMBER OF create_path THEN
      create_path := citydb_delete_gen.create_delete_function(tab_name, schema_name, create_path);
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || pre_block
      ||chr(10)||'  -- delete '||lower(tab_name)
      ||chr(10)||'  RETURN delete_' ||citydb_util.get_short_name(tab_name, schema_name)||'(pid);'
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
    COMMIT;

    RETURN create_path;
  END;

END citydb_delete_gen;
/