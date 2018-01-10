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
  PROCEDURE create_array_delete_function(tab_name VARCHAR2, tab_short_name VARCHAR2, schema_name VARCHAR2 := USER);
  PROCEDURE create_delete_function(tab_name VARCHAR2, tab_short_name VARCHAR2, schema_name VARCHAR2 := USER);
END citydb_delete_gen;
/

CREATE OR REPLACE PACKAGE BODY citydb_delete_gen
AS
  FUNCTION delete_self_ref_by_ids(tab_name VARCHAR2, tab_short_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION delete_n_table_by_ids(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_n_table_by_ids(tab_name VARCHAR2, tab_short_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_m_table_by_ids(m_tab_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_m_table_by_ids(m_tab_name VARCHAR2, m_tab_short_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_n_m_table_by_ids(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_n_m_table_by_ids(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, m_tab_short_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE delete_refs_by_ids(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  PROCEDURE delete_fkeys_by_ids(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, returning_block OUT VARCHAR2, into_block OUT VARCHAR2, fk_block OUT VARCHAR2);
  FUNCTION delete_parent_by_ids(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION delete_self_ref_by_id(tab_name VARCHAR2, tab_short_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION delete_n_table_by_id(tab_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_n_table_by_id(tab_name VARCHAR2, tab_short_name VARCHAR2, fk_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_m_table_by_id(m_tab_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_m_table_by_id(m_tab_name VARCHAR2, m_tab_short_name VARCHAR2, fk_m_column_name VARCHAR2, n_m_tab_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_n_m_table_by_id(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION delete_n_m_table_by_id(n_m_tab_name VARCHAR2, fk_n_column_name VARCHAR2, m_tab_name VARCHAR2, m_tab_short_name VARCHAR2, fk_m_column_name VARCHAR2) RETURN VARCHAR2;
  PROCEDURE delete_refs_by_id(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, ref_block OUT VARCHAR2);
  PROCEDURE delete_fkeys_by_id(tab_name VARCHAR2, schema_name VARCHAR2 := USER, vars OUT VARCHAR2, returning_block OUT VARCHAR2, into_block OUT VARCHAR2, fk_block OUT VARCHAR2);
  FUNCTION delete_parent_by_id(tab_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE create_array_delete_dummy(table_short_name VARCHAR2);

  /***********************
  * DELETE BY IDS (ARRAY)
  ***********************/
  -- creates code block to delete referenced entries in same table with function call
  FUNCTION delete_self_ref_by_ids(
    tab_name VARCHAR2,
    tab_short_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    self_block VARCHAR2(1000);
  BEGIN
    SELECT LISTAGG(
        chr(10)||'  -- delete referenced parts'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    t.id'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||tab_name||' t,'
      ||chr(10)||'    TABLE(arr) a'
      ||chr(10)||'  WHERE'
      ||chr(10)||'    t.'||lower(a.column_name)||' = a.a_id'
      ||chr(10)||'    AND t.id != a.a_id'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||tab_name||'_ids;'
      ||chr(10)
      ||chr(10)||'  dummy_ids := delete_'||tab_short_name||'('||tab_name||'_ids);'
      ||chr(10), '') WITHIN GROUP (ORDER BY a.column_id)
    INTO
      self_block
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
      AND a.nullable = 'Y'
    GROUP BY
      c.table_name;

    IF self_block IS NOT NULL THEN
      -- create a dummy array delete function to enable compiling
      create_array_delete_dummy(tab_short_name);
    END IF;

    RETURN COALESCE(self_block,'');
  END;

  -- creates code block to delete referenced entries in n table
  FUNCTION delete_n_table_by_ids(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||tab_name||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||tab_name||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||fk_column_name
      ||chr(10)||'  );'
      ||chr(10);
  END;

  -- creates code block to delete referenced entries in n table with function call
  FUNCTION delete_n_table_by_ids(
    tab_name VARCHAR2,
    tab_short_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||tab_name||'s'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    t.id'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||tab_name||' t,'
      ||chr(10)||'    TABLE(arr) a'
      ||chr(10)||'  WHERE'
      ||chr(10)||'    t.'||fk_column_name||' = a.COLUMN_VALUE'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||tab_name||'_ids;'
      ||chr(10)
      ||chr(10)||'  dummy_ids := delete_'||tab_short_name||'('||tab_name||'_ids);'
      ||chr(10);
  END;

  -- creates code block to delete unreferenced entries in m table
  FUNCTION delete_m_table_by_ids(
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||m_tab_name||'(s) not being referenced any more'
      ||chr(10)||'  IF -1 = ALL('||m_tab_name||'_ids) IS NOT NULL THEN'
      ||chr(10)||'    DELETE FROM'
      ||chr(10)||'      '||m_tab_name||' m'
      ||chr(10)||'    WHERE EXISTS ('
      ||chr(10)||'      SELECT'
      ||chr(10)||'        DISTINCT COLUMN_VALUE'
      ||chr(10)||'      FROM'
      ||chr(10)||'        TABLE('||m_tab_name||'_ids) a'
      ||chr(10)||'      LEFT JOIN'
      ||chr(10)||'        '||n_m_tab_name||' n2m'
      ||chr(10)||'        ON n2m.'||fk_m_column_name||' = a.COLUMN_VALUE'
      ||chr(10)||'      WHERE'
      ||chr(10)||'        a.COLUMN_VALUE = m.id'
      ||chr(10)||'        AND n2m.'||fk_m_column_name||' IS NULL'
      ||chr(10)||'    );'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  -- creates code block to delete unreferenced entries in m table with function call
  FUNCTION delete_m_table_by_ids(
    m_tab_name VARCHAR2,
    m_tab_short_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||m_tab_name||'(s) not being referenced any more'
      ||chr(10)||'  IF -1 = ALL('||m_tab_name||'_ids) IS NOT NULL THEN'
      ||chr(10)||'    SELECT'
      ||chr(10)||'      DISTINCT a.COLUMN_VALUE'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE('||m_tab_name||'_ids) a'
      ||chr(10)||'    LEFT JOIN'
      ||chr(10)||'      '||n_m_tab_name||' n2m'
      ||chr(10)||'      ON n2m.'||fk_m_column_name||' = a.COLUMN_VALUE'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      AND n2m.'||fk_m_column_name||' IS NULL'
      ||chr(10)||'    BULK COLLECT INTO'
      ||chr(10)||'      '||m_tab_name||'_ids;'
      ||chr(10)
      ||chr(10)||'    dummy_ids := delete_'||m_tab_short_name||'('||m_tab_name||'_ids);'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  -- creates code block to delete referenced entries in n:m table
  -- adds another code block to delete unreferenced entries in m table
  FUNCTION delete_n_m_table_by_ids(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||m_tab_name||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||n_m_tab_name||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||fk_n_column_name
      ||chr(10)||'  );'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||fk_m_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	 '||m_tab_name||'_ids;'
      ||chr(10) || delete_m_table_by_ids(m_tab_name, fk_m_column_name, n_m_tab_name);
  END;

  -- creates code block to delete referenced entries in n:m table
  -- adds another code block to delete unreferenced entries in m table with function call
  FUNCTION delete_n_m_table_by_ids(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    m_tab_short_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||m_tab_name||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||n_m_tab_name||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      1'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr) a'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_VALUE = t.'||fk_n_column_name
      ||chr(10)||'  );'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||fk_m_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	 '||m_tab_name||'_ids;'
      ||chr(10) || delete_m_table_by_ids(m_tab_name, m_tab_short_name, fk_m_column_name, n_m_tab_name);
  END;

  -- creates code block to delete referenced entries
  PROCEDURE delete_refs_by_ids(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT DISTINCT
        c.table_name AS n_table,
        c.table_name AS n_table_short,
        a.column_name AS fk_n_column_name,
        rf.ref_count,
        rf.ref_depth,
        p.clean_parent,
        rt.m_table,
        rt.m_table AS m_table_short,
        rt.fk_m_column_name,
        rtrf.m_table_count,
        rtrf.m_table_depth,
        rtp.m_table_clean_parent
      FROM
        all_constraints c
      JOIN
        all_cons_columns a
        ON a.constraint_name = c.constraint_name
       AND a.table_name = c.table_name
      JOIN
        all_constraints c2
        ON c2.constraint_name = c.r_constraint_name
        AND c2.owner = c.owner
      LEFT JOIN (
        -- count references of referencing tables
        -- > 1 ref = extra delete function
        SELECT
          parent_table,
          count(parent_table) AS ref_count,
          max(LEVEL) AS ref_depth
        FROM (
          SELECT DISTINCT
            ct.table_name AS parent_table,
            ct2.table_name AS ref_table,
            LEVEL
          FROM
            all_constraints ct
          JOIN
            all_constraints ct2
            ON ct2.constraint_name = ct.r_constraint_name
            AND ct2.owner = ct.owner
          START WITH
            ct2.table_name = upper(tab_name)
            AND ct2.owner = upper(schema_name)
            AND ct.table_name <> ct2.table_name
            AND ct.constraint_type = 'R'
            AND ct.delete_rule = 'NO ACTION'
          CONNECT BY PRIOR
            ct2.table_name = ct.table_name
            AND ct.constraint_type = 'R'
            AND ct.delete_rule = 'NO ACTION'
        )
        GROUP BY
          parent_table
      ) rf
      ON rf.parent_table = c.table_name
      -- check for FKs in ref tables which cover same columns as the PK
      -- if found = extra delete function to clean parent, except parent table = :1
      OUTER APPLY (
        SELECT
          fk.table_name AS clean_parent
        FROM
          all_constraints fk
        JOIN
          all_cons_columns fka
          ON fka.constraint_name = fk.constraint_name
         AND fka.table_name = fk.table_name
         AND fka.owner = fk.owner
        JOIN (
          SELECT
            ctp.table_name,
            ctp.owner,
            pka.column_name
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
        WHERE fk.table_name = c.table_name
          AND fk.owner = c.owner
          AND fk.constraint_type = 'R'
          AND fk.delete_rule = 'NO ACTION'
      ) p
      -- get tables from n:m relationships to cleanup
      -- the FK has to be delete_rule = 'CASCADE' to decide for cleanup
      OUTER APPLY (
        SELECT
          ct2.table_name AS m_table,
          fka.column_name AS fk_m_column_name
        FROM
          all_constraints ct
        JOIN
          all_cons_columns fka
          ON fka.table_name = ct.table_name
         AND fka.owner = ct.owner
        JOIN
          all_constraints ct2
          ON ct2.constraint_name = ct.r_constraint_name
          AND ct2.owner = ct.owner 
        WHERE
          ct.table_name = c.table_name
          AND ct.owner = c.owner
          AND ct2.table_name <> ct.table_name
          AND ct.constraint_type = 'R'
          AND ct.delete_rule = 'CASCADE'
      ) rt
      -- count references of n:m tables
      -- this time, any FK type counts, > 1 ref = extra delete function
      OUTER APPLY (
        SELECT
          parent_table,
          count(parent_table) AS m_table_count,
          max(LEVEL) AS m_table_depth
        FROM (
          SELECT DISTINCT
            ct.table_name AS parent_table,
            ct2.table_name AS ref_table,
            LEVEL
          FROM
            all_constraints ct
          JOIN
            all_constraints ct2
            ON ct2.constraint_name = ct.r_constraint_name
            AND ct2.owner = ct.owner
          START WITH
            ct2.table_name = rt.m_table
            AND ct2.owner = rt.owner
            AND ct.table_name <> ct2.table_name
            AND ct.constraint_type = 'R'
          CONNECT BY PRIOR
            ct2.table_name = ct.table_name
            AND ct.constraint_type = 'R'
        )
        GROUP BY
          parent_table
      ) rtrf
      -- check for FKs in n:m tables which cover same columns as PK
      -- if found = extra delete function to clean parent, except parent table = :1
      OUTER APPLY (
        SELECT
          fk.table_name AS clean_parent
        FROM
          all_constraints fk
        JOIN
          all_cons_columns fka
          ON fka.constraint_name = fk.constraint_name
         AND fka.table_name = fk.table_name
         AND fka.owner = fk.owner
        JOIN (
          SELECT
            ctp.table_name,
            ctp.owner,
            pka.column_name
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
        WHERE fk.table_name = rt.table_name
          AND fk.owner = rt.owner
          AND fk.constraint_type = 'R'
          AND fk.delete_rule = 'NO ACTION'
      ) rtp
      WHERE
        c2.table_name = upper(tab_name)
        AND c2.owner = upper(schema_name)
        AND c.table_name <> c2.table_name
        AND c.constraint_type = 'R'
        AND c.delete_rule = 'NO ACTION'
        AND (p.clean_parent IS NULL OR p.clean_parent <> c2.table_name)
        AND (rtp.m_table_clean_parent IS NULL OR rtp.m_table_clean_parent <> c2.table_name)
      ORDER BY
        c.table_name,
        rt.m_table,
        rf.ref_depth NULLS FIRST,
        rtrf.m_table_count DESC,
        rtrf.m_table_depth NULLS FIRST
    )
    LOOP
      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      IF (
        rec.ref_count > 1
        OR rec.ref_depth > 1
        OR rec.clean_parent IS NOT NULL
        ) OR (
        rec.m_table_count > 1
        OR rec.m_table_depth > 1
        OR rec.m_table_clean_parent IS NOT NULL
      ) THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(
          COALESCE(rec.m_table, rec.n_table),
          COALESCE(rec.m_table_short, rec.n_table_short),
          schema_name
        );

        IF rec.m_table IS NULL THEN
          ref_block := ref_block || delete_n_table_by_ids(rec.n_table, rec.n_table_short, rec.fk_n_column_name);
        ELSE
          vars := vars ||chr(10)||'  '|| rec.m_table_short||'_ids ID_ARRAY;';
          ref_block := ref_block || delete_n_m_table_by_ids(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.m_table_short, rec.fk_m_column_name);
        END IF;      
      ELSE
        IF rec.m_table IS NULL THEN
          ref_block := ref_block || delete_n_table_by_ids(rec.n_table, rec.fk_n_column_name);
        ELSE
          vars := vars ||chr(10)||'  '|| rec.m_table||'_ids ID_ARRAY;';
          ref_block := ref_block || delete_n_m_table_by_ids(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.fk_m_column_name);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;

  -- creates code block to delete referenced entries by foreign keys
  PROCEDURE delete_fkeys_by_ids(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    returning_block OUT VARCHAR2,
    into_block OUT VARCHAR2,
    fk_block OUT VARCHAR2
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT
        fk.fk_table,
        fk.fk_table AS fk_table_short,
        fk.fk_column,
        fk.ref_columns,
        fk.column_count,
        rf.has_ref
      FROM (
        SELECT
          c2.table_name AS fk_table,
          a_ref.column_name AS fk_column,
          LISTAGG(a.column_name, chr(10)||'    ') WITHIN GROUP (ORDER BY a.column_id) AS ref_columns,
          count(a.column_name) AS column_count
        FROM
          all_constraints c
        JOIN
          all_cons_columns ac
          ON ac.constraint_name = c.constraint_name
         AND ac.table_name = c.table_name
         AND ac.owner = c.owner
        JOIN
          all_tab_columns a
          ON a.column_name = ac.column_name
         AND a.table_name = ac.table_name
         AND a.owner = ac.owner
        JOIN
          all_constraints c2
          ON c2.constraint_name = c.r_constraint_name
          AND c2.owner = c.owner
        JOIN
          all_cons_columns a_ref
          ON a_ref.constraint_name = c2.constraint_name
         AND a_ref.owner = c2.owner
        WHERE
          c.table_name = upper(tab_name)
          AND c.owner = upper(schema_name)
          AND c.table_name <> c2.table_name
          AND c.constraint_type = 'R'
          AND c.delete_rule = 'RESTRICT'
          AND a.nullable = 'Y'
        GROUP BY
          c2.table_name,
          a_ref.column_name
      ) fk
      OUTER APPLY (
        SELECT
          1 AS has_ref
        FROM
          all_constraints ct
        JOIN
          all_constraints ct2
          ON ct2.constraint_name = ct.r_constraint_name
          AND ct2.owner = ct.owner
        WHERE
          ct.table_name = fk.fk_table
          AND ct2.table_name <> fk.fk_table
          AND ct.constraint_type = 'R'
          AND (ct.delete_rule = 'NO ACTION' OR ct.delete_rule = 'RESTRICT')
      ) rf
    )
    LOOP
      IF vars IS NULL THEN
        vars := '';
        returning_block := '';
        into_block := '';
        fk_block := '';
      END IF;

      vars := vars ||chr(10)||'  '|| rec.fk_table||'_ids ID_ARRAY;';
      returning_block := returning_block ||chr(10)||'      '|| rec.ref_columns;
      into_block := into_block ||chr(10)||'    '|| rec.fk_table||'_ids';

      IF rec.has_ref = 1 THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(rec.fk_table, rec.fk_table_short, schema_name);
        fk_block := fk_block || delete_m_table_by_ids(rec.fk_table, rec.fk_table_short, rec.fk_column, rec.fk_table);
      ELSE
        fk_block := fk_block || delete_m_table_by_ids(rec.fk_table, rec.fk_column, rec.fk_table);
      END IF;
    END LOOP;

    RETURN;
  END;

  -- creates code block to delete referenced parent entries
  FUNCTION delete_parent_by_ids(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    parent_block VARCHAR2(1000) := '';
  BEGIN
    FOR rec IN (
      SELECT
        p.table_name AS parent_table,
        p.table_name AS parent_table_short
      FROM
        all_constraints fk
      JOIN all_cons_columns fka
        ON fka.constraint_name = fk.constraint_name
       AND fka.table_name = fk.table_name
       AND fka.owner = fk.owner
      JOIN (
        SELECT
          ctp.table_name,
          ctp.owner,
          pka.column_name
        FROM
          all_constraints ctp
        JOIN all_cons_columns pka
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
      WHERE fk.table_name = upper(tab_name)
        AND fk.owner = upper(schema_name)
        AND fk.constraint_type = 'R'
        AND fk.delete_rule = 'NO ACTION'
    )
    LOOP
      -- create array delete function for parent table
      citydb_delete_gen.create_array_delete_function(rec.parent_table, rec.parent_table_short, schema_name);

      -- add delete call for parent table
      parent_block := parent_block
        ||chr(10)||'  -- delete '|| rec.parent_table
        ||chr(10)||'  dummy_ids := delete_'|| rec.parent_table_short||'(deleted_ids);'
        ||chr(10);
    END LOOP;

    RETURN COALESCE(parent_block,'');
  END;


  /***********************
  * DELETE BY ID
  ***********************/
  -- creates code block to delete referenced entries in same table with function call
  FUNCTION delete_self_ref_by_id(
    tab_name VARCHAR2,
    tab_short_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    self_block VARCHAR2(1000);
  BEGIN
    SELECT LISTAGG(
        chr(10)||'  -- delete referenced parts'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    id'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||tab_name
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||lower(a.column_name)||' = pid'
      ||chr(10)||'    AND id != pid'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||tab_name||'_ids;'
      ||chr(10)
      ||chr(10)||'  dummy_ids := delete_'||tab_short_name||'('||tab_name||'_ids);'
      ||chr(10), '')  WITHIN GROUP (ORDER BY a.column_id)
    INTO
      self_block
    FROM
      all_constraints c
    JOIN
      all_cons_columns ac
      ON ac.constraint_name = c.constraint_name
     AND ac.table_name = c.table_name
     AND ac.owner = c.owner
    JOIN
      all_tab_columns a
      ON a.column_name = ac.column_name
     AND a.table_name = ac.table_name
     AND a.owner = ac.owner
    JOIN
      all_constraints c2
      ON c2.constraint_name = c.r_constraint_name
     AND c2.owner = c.owner 
    WHERE 
      c.table_name = upper(tab_name)
      AND c.owner = upper(schema_name)
      AND c.table_name = c2.table_name
      AND c.constraint_type = 'R'
      AND c.delete_rule = 'NO ACTION'
      AND a.nullable = 'Y'
    GROUP BY
      c.table_name;

    IF self_block IS NOT NULL THEN
      -- create a dummy array delete function to enable compiling
      create_array_delete_dummy(tab_short_name);
    END IF;

    RETURN COALESCE(self_block,'');
  END;

  -- creates code block to delete referenced entries in n table
  FUNCTION delete_n_table_by_id(
    tab_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||tab_name||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||tab_name
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||fk_column_name||' = pid;'
      ||chr(10);
  END;

  -- creates code block to delete referenced entries in n table with function call
  FUNCTION delete_n_table_by_id(
    tab_name VARCHAR2,
    tab_short_name VARCHAR2,
    fk_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||tab_name||'s'
      ||chr(10)||'  SELECT'
      ||chr(10)||'    id'
      ||chr(10)||'  FROM'
      ||chr(10)||'    '||tab_name
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||fk_column_name||' = pid'
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    '||tab_name||'_ids;'
      ||chr(10)
      ||chr(10)||'  dummy_ids := delete_'||tab_short_name||'('||tab_name||'_ids);'
      ||chr(10);
  END;

  -- creates code block to delete unreferenced entries in m table
  FUNCTION delete_m_table_by_id(
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||m_tab_name||'(s) not being referenced any more'
      ||chr(10)||'  IF '||m_tab_name||'_ref_id IS NOT NULL THEN'
      ||chr(10)||'    DELETE FROM'
      ||chr(10)||'      '||m_tab_name||' m'
      ||chr(10)||'    WHERE EXISTS ('
      ||chr(10)||'      SELECT'
      ||chr(10)||'        1'
      ||chr(10)||'      FROM'
      ||chr(10)||'        TABLE('||m_tab_name||'_ref_id) a'
      ||chr(10)||'      LEFT JOIN'
      ||chr(10)||'        '||n_m_tab_name||' n2m'
      ||chr(10)||'        ON n2m.'||fk_m_column_name||' = a.COLUMN_NAME'
      ||chr(10)||'      WHERE'
      ||chr(10)||'        a.COLUMN_VALUE = m.id'
      ||chr(10)||'        n2m.'||fk_m_column_name||' IS NULL'
      ||chr(10)||'    );'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  -- creates code block to delete unreferenced entries in m table with function call
  FUNCTION delete_m_table_by_id(
    m_tab_name VARCHAR2,
    m_tab_short_name VARCHAR2,
    fk_m_column_name VARCHAR2,
    n_m_tab_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete '||m_tab_name||'(s) not being referenced any more'
      ||chr(10)||'  IF '||m_tab_name||'_ref_id IS NOT NULL THEN'
      ||chr(10)||'    SELECT'
      ||chr(10)||'      a.COLUMN_VALUE'
      ||chr(10)||'    INTO'
      ||chr(10)||'      '||m_tab_name||'_pid'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE('||m_tab_name||'_ref_id) a'
      ||chr(10)||'    LEFT JOIN'
      ||chr(10)||'      '||n_m_tab_name||' n2m'
      ||chr(10)||'      ON n2m.'||fk_m_column_name||' = a.COLUMN_VALUE'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      AND n2m.'||fk_m_column_name||' IS NULL'
      ||chr(10)||'    BULK COLLECT INTO'
      ||chr(10)||'      '||m_tab_name||'_ids;'
      ||chr(10)
      ||chr(10)||'    dummy_ids := delete_'||m_tab_short_name||'('||m_tab_name||'_pid);'
      ||chr(10)||'  END IF;'
      ||chr(10);
  END;

  -- creates code block to delete referenced entries in n:m table
  -- adds another code block to delete unreferenced entries in m table
  FUNCTION delete_n_m_table_by_id(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||m_tab_name||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||n_m_tab_name
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||fk_n_column_name||' = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||fk_m_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	 '||m_tab_name||'_ids;'
      ||chr(10) || delete_m_table_by_ids(m_tab_name, fk_m_column_name, n_m_tab_name);
  END;

  -- creates code block to delete referenced entries in n:m table
  -- adds another code block to delete unreferenced entries in m table with function call
  FUNCTION delete_n_m_table_by_id(
    n_m_tab_name VARCHAR2,
    fk_n_column_name VARCHAR2,
    m_tab_name VARCHAR2,
    m_tab_short_name VARCHAR2,
    fk_m_column_name VARCHAR2
    ) RETURN VARCHAR2 
  IS
  BEGIN
    RETURN
        chr(10)||'  -- delete references to '||m_tab_name||'s'
      ||chr(10)||'  DELETE FROM'
      ||chr(10)||'    '||n_m_tab_name
      ||chr(10)||'  WHERE'
      ||chr(10)||'    '||fk_n_column_name||' = pid'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    '||fk_m_column_name
      ||chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'	 '||m_tab_name||'_ids;'
      ||chr(10) || delete_m_table_by_ids(m_tab_name, m_tab_short_name, fk_m_column_name, n_m_tab_name);
  END;


  -- creates code block to delete referenced entries
  PROCEDURE delete_refs_by_id(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    ref_block OUT VARCHAR2
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT DISTINCT
        c.table_name AS n_table,
        c.table_name AS n_table_short,
        a.column_name AS fk_n_column_name,
        rf.ref_count,
        rf.ref_depth,
        p.clean_parent,
        rt.m_table,
        rt.m_table AS m_table_short,
        rt.fk_m_column_name,
        rtrf.m_table_count,
        rtrf.m_table_depth,
        rtp.m_table_clean_parent
      FROM
        all_constraints c
      JOIN all_cons_columns a
        ON a.constraint_name = c.constraint_name
       AND a.table_name = c.table_name
      JOIN
        all_constraints c2
        ON c2.constraint_name = c.r_constraint_name
        AND c2.owner = c.owner
      LEFT JOIN (
        -- count references of referencing tables
        -- > 1 ref = extra delete function
        SELECT
          parent_table,
          count(parent_table) AS ref_count,
          max(LEVEL) AS ref_depth
        FROM (
          SELECT DISTINCT
            ct.table_name AS parent_table,
            ct2.table_name AS ref_table,
            LEVEL
          FROM
            all_constraints ct
          JOIN
            all_constraints ct2
            ON ct2.constraint_name = ct.r_constraint_name
            AND ct2.owner = ct.owner
          START WITH
            ct2.table_name = upper(tab_name)
            AND ct2.owner = upper(schema_name)
            AND ct.table_name <> ct2.table_name
            AND ct.constraint_type = 'R'
            AND ct.delete_rule = 'NO ACTION'
          CONNECT BY PRIOR
            ct2.table_name = ct.table_name
            AND ct.constraint_type = 'R'
            AND ct.delete_rule = 'NO ACTION'
        )
        GROUP BY
          parent_table
      ) rf
      ON rf.parent_table = c.table_name
      -- check for FKs in ref tables which cover same columns as the PK
      -- if found = extra delete function to clean parent, except parent table = :1
      OUTER APPLY (
        SELECT
          fk.table_name AS clean_parent
        FROM
          all_constraints fk
        JOIN all_cons_columns fka
          ON fka.constraint_name = fk.constraint_name
         AND fka.table_name = fk.table_name
         AND fka.owner = fk.owner
        JOIN (
          SELECT
            ctp.table_name,
            ctp.owner,
            pka.column_name
          FROM
            all_constraints ctp
          JOIN all_cons_columns pka
            ON pka.constraint_name = ctp.constraint_name
           AND pka.table_name = ctp.table_name
           AND pka.owner = ctp.owner
          WHERE
            ctp.constraint_type = 'P'
          ) pk
          ON pk.table_name = fk.table_name
         AND pk.owner = fk.owner
         AND pk.column_name = fka.column_name
        WHERE fk.table_name = c.table_name
          AND fk.owner = c.owner
          AND fk.constraint_type = 'R'
          AND fk.delete_rule = 'NO ACTION'
      ) p
      -- get tables from n:m relationships to cleanup
      -- the FK has to be delete_rule = 'CASCADE' to decide for cleanup
      OUTER APPLY (
        SELECT
          ct2.table_name AS m_table,
          fka.column_name AS fk_m_column_name
        FROM
          all_constraints ct
        JOIN all_cons_columns fka
          ON fka.table_name = ct.table_name
         AND fka.owner = ct.owner
        JOIN
          all_constraints ct2
          ON ct2.constraint_name = ct.r_constraint_name
          AND ct2.owner = ct.owner 
        WHERE
          ct.table_name = c.table_name
          AND ct.owner = c.owner
          AND ct2.table_name <> ct.table_name
          AND ct.constraint_type = 'R'
          AND ct.delete_rule = 'CASCADE'
      ) rt
      -- count references of n:m tables
      -- this time, any FK type counts, > 1 ref = extra delete function
      OUTER APPLY (
        SELECT
          parent_table,
          count(parent_table) AS m_table_count,
          max(LEVEL) AS m_table_depth
        FROM (
          SELECT DISTINCT
            ct.table_name AS parent_table,
            ct2.table_name AS ref_table,
            LEVEL
          FROM
            all_constraints ct
          JOIN
            all_constraints ct2
            ON ct2.constraint_name = ct.r_constraint_name
            AND ct2.owner = ct.owner
          START WITH
            ct2.table_name = rt.m_table
            AND ct2.owner = rt.owner
            AND ct.table_name <> ct2.table_name
            AND ct.constraint_type = 'R'
          CONNECT BY PRIOR
            ct2.table_name = ct.table_name
            AND ct.constraint_type = 'R'
        )
        GROUP BY
          parent_table
      ) rtrf
      -- check for FKs in n:m tables which cover same columns as PK
      -- if found = extra delete function to clean parent, except parent table = :1
      OUTER APPLY (
        SELECT
          fk.table_name AS clean_parent
        FROM
          all_constraints fk
        JOIN all_cons_columns fka
          ON fka.constraint_name = fk.constraint_name
         AND fka.table_name = fk.table_name
         AND fka.owner = fk.owner
        JOIN (
          SELECT
            ctp.table_name,
            ctp.owner,
            pka.column_name
          FROM
            all_constraints ctp
          JOIN all_cons_columns pka
            ON pka.constraint_name = ctp.constraint_name
           AND pka.table_name = ctp.table_name
           AND pka.owner = ctp.owner
          WHERE
            ctp.constraint_type = 'P'
          ) pk
          ON pk.table_name = fk.table_name
         AND pk.owner = fk.owner
         AND pk.column_name = fka.column_name
        WHERE fk.table_name = rt.table_name
          AND fk.owner = rt.owner
          AND fk.constraint_type = 'R'
          AND fk.delete_rule = 'NO ACTION'
      ) rtp
      WHERE
        c2.table_name = upper(tab_name)
        AND c2.owner = upper(schema_name)
        AND c.table_name <> c2.table_name
        AND c.constraint_type = 'R'
        AND c.delete_rule = 'NO ACTION'
        AND (p.clean_parent IS NULL OR p.clean_parent <> c2.table_name)
        AND (rtp.m_table_clean_parent IS NULL OR rtp.m_table_clean_parent <> c2.table_name)
      ORDER BY
        c.table_name,
        rt.m_table,
        rf.ref_depth NULLS FIRST,
        rtrf.m_table_count DESC,
        rtrf.m_table_depth NULLS FIRST
    )
    LOOP
      IF vars IS NULL THEN
        vars := '';
        ref_block := '';
      END IF;

      IF (
        rec.ref_count > 1
        OR rec.ref_depth > 1
        OR rec.clean_parent IS NOT NULL
        ) OR (
        rec.m_table_count > 1
        OR rec.m_table_depth > 1
        OR rec.m_table_clean_parent IS NOT NULL
      ) THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(
          COALESCE(rec.m_table, rec.n_table),
          COALESCE(rec.m_table_short, rec.n_table_short),
          schema_name
        );

        IF rec.m_table IS NULL THEN
          ref_block := ref_block || delete_n_table_by_id(rec.n_table, rec.n_table_short, rec.fk_n_column_name);
        ELSE
          vars := vars ||chr(10)||'  '|| rec.m_table_short||'_ids ID_ARRAY;';
          ref_block := ref_block || delete_n_m_table_by_id(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.m_table_short, rec.fk_m_column_name);
        END IF;      
      ELSE
        IF rec.m_table IS NULL THEN
          ref_block := ref_block || delete_n_table_by_id(rec.n_table, rec.fk_n_column_name);
        ELSE
          vars := vars ||chr(10)||'  '|| rec.m_table||'_ids ID_ARRAY;';
          ref_block := ref_block || delete_n_m_table_by_id(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.fk_m_column_name);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;

  -- creates code block to delete referenced entries by foreign keys
  PROCEDURE delete_fkeys_by_id(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER,
    vars OUT VARCHAR2,
    returning_block OUT VARCHAR2,
    into_block OUT VARCHAR2,
    fk_block OUT VARCHAR2
    )
  IS
  BEGIN
    FOR rec IN (
      SELECT
        fk.fk_table,
        fk.fk_table AS fk_table_short,
        fk.fk_column,
        fk.ref_columns,
        fk.column_count,
        rf.has_ref
      FROM (
        SELECT
          c2.table_name AS fk_table,
          a_ref.column_name AS fk_column,
          LISTAGG(a.column_name, chr(10)||'      ') WITHIN GROUP (ORDER BY a.column_id) AS ref_columns,
          count(a.column_name) AS column_count
        FROM
          all_constraints c
        JOIN
          all_cons_columns ac
          ON ac.constraint_name = c.constraint_name
         AND ac.table_name = c.table_name
         AND ac.owner = c.owner
        JOIN
          all_tab_columns a
          ON a.column_name = ac.column_name
         AND a.table_name = ac.table_name
         AND a.owner = ac.owner
        JOIN
          all_constraints c2
          ON c2.constraint_name = c.r_constraint_name
          AND c2.owner = c.owner
        JOIN
          all_cons_columns a_ref
          ON a_ref.constraint_name = c2.constraint_name
         AND a_ref.owner = c2.owner
        WHERE
          c.table_name = upper(tab_name)
          AND c.owner = upper(schema_name)
          AND c.table_name <> c2.table_name
          AND c.constraint_type = 'R'
          AND c.delete_rule = 'RESTRICT'
          AND a.nullable = 'Y'
        GROUP BY
          c2.table_name,
          a_ref.column_name
      ) fk
      OUTER APPLY (
        SELECT
          1 AS has_ref
        FROM
          all_constraints ct
        JOIN
          all_constraints ct2
          ON ct2.constraint_name = ct.r_constraint_name
          AND ct2.owner = ct.owner
        WHERE
          ct.table_name = fk.fk_table
          AND ct2.table_name <> fk.fk_table
          AND ct.constraint_type = 'R'
          AND (ct.delete_rule = 'NO ACTION' OR ct.delete_rule = 'RESTRICT')
      ) rf
    )
    LOOP
      IF vars IS NULL THEN
        vars := '';
        returning_block := '';
        into_block := '';
        fk_block := '';
      END IF;

      IF rec.column_count > 1 THEN
        vars := vars ||chr(10)||'  '|| rec.fk_table||'_ids ID_ARRAY;';
        returning_block := returning_block ||chr(10)||'    ID_ARRAY('|| rec.ref_columns||')';
        into_block := into_block ||chr(10)||'    '|| rec.fk_table||'_ids';
      ELSE
        vars := vars ||chr(10)||'  '|| rec.fk_table||'_ref_id NUMBER;';
        returning_block := returning_block ||chr(10)||'    '|| rec.ref_columns;
        into_block := into_block ||chr(10)||'    '|| rec.fk_table||'_ref_id';
      END IF;

      IF rec.has_ref = 1 THEN
        -- function call required, so create function first
        citydb_delete_gen.create_array_delete_function(rec.fk_table, rec.fk_table_short, schema_name);
        IF rec.column_count > 1 THEN
          fk_block := fk_block || delete_m_table_by_ids(rec.fk_table, rec.fk_table_short, rec.fk_column, rec.fk_table);
        ELSE
          fk_block := fk_block || delete_m_table_by_id(rec.fk_table, rec.fk_table_short, rec.fk_column, rec.fk_table);
        END IF;
      ELSE
        IF rec.column_count > 1 THEN
          fk_block := fk_block || delete_m_table_by_ids(rec.fk_table, rec.fk_column, rec.fk_table);
        ELSE
          fk_block := fk_block || delete_m_table_by_id(rec.fk_table, rec.fk_column, rec.fk_table);
        END IF;
      END IF;
    END LOOP;

    RETURN;
  END;

  -- creates code block to delete referenced parent entries
  FUNCTION delete_parent_by_id(
    tab_name VARCHAR2,
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2 
  IS
    parent_block VARCHAR2(1000) := '';
  BEGIN
    FOR rec IN (
      SELECT
        p.table_name AS parent_table,
        p.table_name AS parent_table_short
      FROM
        all_constraints fk
      JOIN all_cons_columns fka
        ON fka.constraint_name = fk.constraint_name
       AND fka.table_name = fk.table_name
       AND fka.owner = fk.owner
      JOIN (
        SELECT
          ctp.table_name,
          ctp.owner,
          pka.column_name
        FROM
          all_constraints ctp
        JOIN all_cons_columns pka
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
      WHERE fk.table_name = upper(tab_name)
        AND fk.owner = upper(schema_name)
        AND fk.constraint_type = 'R'
        AND fk.delete_rule = 'NO ACTION'
    )
    LOOP
      -- create array delete function for parent table
      citydb_delete_gen.create_delete_function(rec.parent_table, rec.parent_table_short, schema_name);

      -- add delete call for parent table
      parent_block := parent_block
        ||chr(10)||'  -- delete '|| rec.parent_table
        ||chr(10)||'  dummy_id := delete_'|| rec.parent_table_short||'(deleted_id);'
        ||chr(10);
    END LOOP;

    RETURN COALESCE(parent_block,'');
  END;


  /**************************
  * CREATE DELETE FUNCTION
  **************************/
  -- dummy function to compile array delete functions with recursions
  PROCEDURE create_array_delete_dummy(
    table_short_name VARCHAR2
    )
  IS
    ddl_command VARCHAR2(500) := 
      'CREATE OR REPLACE FUNCTION delete_'||table_short_name||'(arr ID_ARRAY) RETURN ID_ARRAY'
      ||chr(10)||'IS'
      ||chr(10)||'  deleted_ids ID_ARRAY;'
      ||chr(10)||'BEGIN'
      ||chr(10)||'  RETURN deleted_ids;'
      ||chr(10)||'END;';
  BEGIN
    EXECUTE IMMEDIATE ddl_command;
  END;

  -- creates a array delete function for given table
  -- returns deleted IDs (set of int)
  PROCEDURE create_array_delete_function(
    tab_name VARCHAR2,
    tab_short_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(10000) := 
      'CREATE OR REPLACE FUNCTION delete_'||tab_short_name||'(arr ID_ARRAY) RETURN ID_ARRAY'
      ||chr(10)||'IS';
    declare_block VARCHAR2(500) := chr(10)||'  deleted_ids ID_ARRAY;';
    pre_block VARCHAR2(2000) := '';
    post_block VARCHAR2(1000) := '';
    delete_block VARCHAR2(1000) :=
      '  DELETE FROM'
      ||chr(10)||'    '||tab_name||' t'
      ||chr(10)||'  WHERE EXISTS ('
      ||chr(10)||'    SELECT'
      ||chr(10)||'      a.COLUMN_NAME'
      ||chr(10)||'    FROM'
      ||chr(10)||'      TABLE(arr)'
      ||chr(10)||'    WHERE'
      ||chr(10)||'      a.COLUMN_NAME = t.id'
      ||chr(10)||'  )'
      ||chr(10)||'  RETURNING'
      ||chr(10)||'    id';
    delete_into_block VARCHAR2(500) :=
        chr(10)||'  BULK COLLECT INTO'
      ||chr(10)||'    deleted_ids';
    vars VARCHAR2(500);
    ref_block VARCHAR2(2000);
    returning_block VARCHAR2(500);
    into_block VARCHAR2(500);
    fk_block VARCHAR2(1000);
  BEGIN
    -- SELF-REFERENCES
    pre_block := delete_self_ref_by_ids(tab_name, tab_short_name, schema_name);

    -- REFERENCING TABLES
    delete_refs_by_ids(tab_name, schema_name, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- FOREIGN KEY which are set to ON DELETE RESTRICT
    delete_fkeys_by_ids(tab_name, schema_name, vars, returning_block, into_block, fk_block);
    declare_block := declare_block || COALESCE(vars, '');
    delete_block := delete_block || COALESCE(returning_block, '');
    delete_into_block := delete_into_block || COALESCE(into_block, '');
    post_block := post_block || COALESCE(fk_block, '');

    -- FOREIGN KEY which cover same columns AS primary key
    post_block := post_block || delete_parent_by_ids(tab_name, schema_name);

    -- create dummy variable if pre or post block are not null
    IF pre_block <> '' OR post_block <> '' THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY';
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || pre_block
      ||chr(10)||'  -- delete '||tab_name||'s'
      || delete_block
      || delete_into_block || ';'
      || post_block
      ||chr(10)||'  RETURN deleted_ids;'
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
  END;

  -- creates a delete function for given table
  -- returns deleted ID (int)
  PROCEDURE create_delete_function(
    tab_name VARCHAR2,
    tab_short_name VARCHAR2,
    schema_name VARCHAR2 := USER
    )
  IS
    ddl_command VARCHAR2(10000) := 'CREATE OR REPLACE FUNCTION delete_'||tab_short_name||'(pid NUMBER) RETURN NUMBER'||chr(10)||'IS'||chr(10);
    declare_block VARCHAR2(500) := chr(10)||''||chr(10)||'  deleted_id NUMBER;';
    pre_block VARCHAR2(2000) := '';
    post_block VARCHAR2(1000) := '';
    delete_block VARCHAR2(1000) := chr(10)||'  DELETE FROM'||chr(10)||'    '||tab_name||chr(10)||'  WHERE'||chr(10)||'    id = pid'||chr(10)||'  RETURNING'||chr(10)||'    id';
    delete_into_block VARCHAR2(500) := chr(10)||'  INTO'||chr(10)||'    deleted_id';
    vars VARCHAR2(500);
    ref_block VARCHAR2(2000);
    returning_block VARCHAR2(500);
    into_block VARCHAR2(500);
    fk_block VARCHAR2(1000);
  BEGIN
    -- SELF-REFERENCES
    pre_block := delete_self_ref_by_id(tab_name, tab_short_name, schema_name);

    -- REFERENCING TABLES
    delete_refs_by_id(tab_name, schema_name, vars, ref_block);
    declare_block := declare_block || COALESCE(vars, '');
    pre_block := pre_block || COALESCE(ref_block, '');

    -- FOREIGN KEY which are set to ON DELETE RESTRICT
    delete_fkeys_by_id(tab_name, schema_name, vars, returning_block, into_block, fk_block);
    declare_block := declare_block || COALESCE(vars, '');
    delete_block := delete_block || COALESCE(returning_block, '');
    delete_into_block := delete_into_block || COALESCE(into_block, '');
    post_block := post_block || COALESCE(fk_block, '');

    -- FOREIGN KEY which cover same columns AS primary key
    post_block := delete_parent_by_id(tab_name, schema_name);

    -- create dummy variable if pre or post block are not null
    IF pre_block <> '' THEN
      declare_block := declare_block ||chr(10)||'  dummy_ids ID_ARRAY';
    END IF;
    IF post_block <> '' THEN
      declare_block := declare_block ||chr(10)||'  dummy_id NUMBER';
    END IF;

    -- putting all together
    ddl_command := ddl_command
      || declare_block
      ||chr(10)||'BEGIN'
      || pre_block
      ||chr(10)||'  -- delete '||tab_name||'s'
      || delete_block
      || delete_into_block || ';'
      || post_block
      ||chr(10)||'  RETURN deleted_id;'
      ||chr(10)||'END;';

    EXECUTE IMMEDIATE ddl_command;
  END;

END citydb_delete_gen;
/