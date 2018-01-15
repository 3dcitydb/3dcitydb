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

/***********************
* DELETE BY IDS (ARRAY)
***********************/
-- creates code block to delete referenced entries in same table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_self_ref_by_ids(
  table_name TEXT,
  table_short_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS
$$
DECLARE
  self_block TEXT;
BEGIN
  SELECT string_agg(
    E'\n  -- delete referenced parts'
    || E'\n  PERFORM'
    || E'\n    gen.delete_'||$2||'(array_agg(t.id))'
    || E'\n  FROM'
    || E'\n    '||$1||' t,'
    || E'\n    unnest($1) a(a_id)'
    || E'\n  WHERE'
    || E'\n    t.'||a.attname||' = a.a_id'
    || E'\n    AND t.id != a.a_id;\n', ''
    )
  INTO
    self_block
  FROM
    pg_constraint c
  JOIN
    pg_attribute a
    ON a.attrelid = c.conrelid
   AND a.attnum = ANY (c.conkey)
  WHERE
    c.conrelid = ($3 || '.' || $1)::regclass::oid
    AND c.conrelid = c.confrelid
    AND c.contype = 'f'
    AND c.confdeltype = 'a'
    AND a.attnotnull = FALSE;

  IF self_block IS NOT NULL THEN
    -- create a dummy array delete function to enable compiling
    PERFORM citydb_pkg.create_array_delete_dummy($2);
  END IF;

  RETURN COALESCE(self_block,'');
END;
$$
LANGUAGE plpgsql;

-- creates code block to delete referenced entries in n table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_table_by_ids(
  table_name TEXT,
  fk_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'s'
  || E'\n  DELETE FROM'
  || E'\n    '||$1||' t'
  || E'\n  USING'
  || E'\n    unnest($1) a(a_id)'
  || E'\n  WHERE'
  || E'\n    t.'||$2||E' = a.a_id;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries in n table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_table_by_ids(
  table_name TEXT,
  table_short_name TEXT,
  fk_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'s'
  || E'\n  PERFORM'
  || E'\n    gen.delete_'||$2||E'(array_agg(t.id))'
  || E'\n  FROM'
  || E'\n    '||$1|| ' t,'
  || E'\n    unnest($1) a(a_id)'
  || E'\n  WHERE'
  || E'\n    t.'||$3||E' = a.a_id;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete unreferenced entries in m table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_m_table_by_ids(
  m_table_name TEXT,
  fk_m_column_name TEXT,
  n_m_table_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'(s) not being referenced any more'
  || E'\n  IF -1 = ALL('||$1||'_ids) IS NOT NULL THEN'
  || E'\n    DELETE FROM'
  || E'\n      '||$1||' m'
  || E'\n    USING'
  || E'\n      (SELECT DISTINCT unnest('||$1||'_ids) AS a_id) a'
  || E'\n    LEFT JOIN'
  || E'\n'     ||$3||' n2m'
  || E'\n      ON n2m.'||$2||' = a.a_id'
  || E'\n    WHERE'
  || E'\n      m.id = a.a_id'
  || E'\n      AND n2m.'||$2||' IS NULL;'
  || E'\n  END IF;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete unreferenced entries in m table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_m_table_by_ids(
  m_table_name TEXT,
  m_table_short_name TEXT,
  fk_m_column_name TEXT,
  n_m_table_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'(s) not being referenced any more'
  || E'\n  IF -1 = ALL('||$1||'_ids) IS NOT NULL THEN'
  || E'\n    PERFORM'
  || E'\n      gen.delete_'||$2||'(array_agg(a.a_id))'
  || E'\n    FROM'
  || E'\n      (SELECT DISTINCT unnest('||$1||'_ids) AS a_id) a'
  || E'\n    LEFT JOIN'
  || E'\n      '||$4||' n2m'
  || E'\n      ON n2m.'||$3||' = a.a_id'
  || E'\n    WHERE'
  || E'\n      n2m.'||$3||' IS NULL;'
  || E'\n  END IF;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries in n:m table
-- adds another code block to delete unreferenced entries in m table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_m_table_by_ids(
  n_m_table_name TEXT,
  fk_n_column_name TEXT,
  m_table_name TEXT,
  fk_m_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT E'\n  -- delete references to '||$3||'s'
  || E'\n  WITH delete_'||$3||'_refs AS ('
  || E'\n    DELETE FROM'
  || E'\n      '||$1||' t'
  || E'\n    USING'
  || E'\n      unnest($1) a(a_id)'
  || E'\n    WHERE'
  || E'\n      t.'||$2||' = a.a_id'
  || E'\n    RETURNING'
  || E'\n      t.'||$4
  || E'\n  )'
  || E'\n  SELECT'
  || E'\n    array_agg('||$4||')'
  || E'\n  INTO'
  || E'\n    '||$3||'_ids'
  || E'\n  FROM'
  || E'\n    delete_'||$3||'_refs;'
  || E'\n' || delete_m_table_by_ids($3, $4, $1);
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries in n:m table
-- adds another code block to delete unreferenced entries in m table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_m_table_by_ids(
  n_m_table_name TEXT,
  fk_n_column_name TEXT,
  m_table_name TEXT,
  m_table_short_name TEXT,
  fk_m_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT E'\n  -- delete references to '||$3||'s'
  || E'\n  WITH delete_'||$4||'_refs AS ('
  || E'\n    DELETE FROM'
  || E'\n      '||$1||' t'
  || E'\n    USING'
  || E'\n      unnest($1) a(a_id)'
  || E'\n    WHERE'
  || E'\n      t.'||$2||' = a.a_id'
  || E'\n    RETURNING'
  || E'\n      t.'||$5
  || E'\n  )'
  || E'\n  SELECT'
  || E'\n    array_agg('||$5||')'
  || E'\n  INTO'
  || E'\n    '||$3||'_ids'
  || E'\n  FROM'
  || E'\n    delete_'||$4||'_refs;'
  || E'\n' || delete_m_table_by_ids($3, $4, $5, $1);
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries
CREATE OR REPLACE FUNCTION citydb_pkg.delete_refs_by_ids(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb',
  OUT vars TEXT,
  OUT ref_block TEXT
  ) RETURNS RECORD AS
$$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN (
    SELECT
      c.conrelid::regclass::text AS n_table,
      c.conrelid::regclass::text AS n_table_short,
      a.attname AS fk_n_column_name,
      n.ref_count,
      n.ref_depth,
      p.clean_parent,
      m.m_table::regclass::text,
      m.m_table::regclass::text AS m_table_short,
      m.fk_m_column_name,
      m.m_table_count,
      m.m_table_clean_parent
    FROM
      pg_constraint c
    JOIN
      pg_attribute a
      ON a.attrelid = c.conrelid
     AND a.attnum = ANY (c.conkey)
    LEFT JOIN (
      -- count references of referencing tables
      -- > 1 ref = extra delete function
      WITH RECURSIVE ref_table_depth(parent_table, ref_table, depth) AS (
        SELECT
          confrelid AS parent_table,
          conrelid AS ref_table,
          1 AS depth
        FROM
          pg_constraint
        WHERE
          confrelid = ($2 || '.' || $1)::regclass::oid
          AND conrelid <> confrelid
          AND contype = 'f'
          AND confdeltype = 'a'
        UNION ALL
          SELECT
            r.confrelid AS parent_table,
            r.conrelid AS ref_table,
            d.depth + 1 AS depth
          FROM
            pg_constraint r,
            ref_table_depth d
          WHERE
            d.ref_table = r.confrelid
            AND d.ref_table <> r.conrelid
            AND r.contype = 'f'
            AND r.confdeltype = 'a'
      )
      SELECT
        parent_table,
        count(parent_table) AS ref_count,
        max(depth) AS ref_depth
      FROM
        ref_table_depth
      GROUP BY
        parent_table
    ) n
    ON n.parent_table = c.conrelid
    -- check for FKs in ref tables which cover same columns as the PK
    -- if found = extra delete function to clean parent, except parent table = $1
    LEFT JOIN LATERAL (
      SELECT
        fk.confrelid AS clean_parent
      FROM
        pg_constraint fk
      JOIN (
        SELECT
          conrelid,
          conkey
        FROM
          pg_constraint
        WHERE
          contype = 'p'
        ) pk
        ON pk.conrelid = fk.conrelid
       AND pk.conkey = fk.conkey
      WHERE
        fk.conrelid = c.conrelid
        AND fk.contype = 'f'
        AND fk.confdeltype = 'a'
    ) p ON (true)
    -- get tables from n:m relationships to cleanup
    -- the FK has to be confdeltype = 'c' to decide for cleanup
    -- count references of n:m tables and check for FKs cover same columns as PK
    LEFT JOIN LATERAL (
      SELECT
        mn.confrelid AS m_table,
        mna.attname AS fk_m_column_name,
        mr.m_table_count,
        mp.m_table_clean_parent
      FROM
        pg_constraint mn
      JOIN
        pg_attribute mna
        ON mna.attrelid = mn.conrelid
       AND mna.attnum = ANY (mn.conkey)
      LEFT JOIN LATERAL (
        SELECT
          count(conrelid) AS m_table_count
        FROM
          pg_constraint
        WHERE
          confrelid = mn.confrelid
          AND conrelid <> confrelid
          AND contype = 'f'
        GROUP BY
          confrelid
      ) mr
      ON (true)
      LEFT JOIN LATERAL (
        SELECT
          fk.confrelid AS m_table_clean_parent
        FROM
          pg_constraint fk
        JOIN (
          SELECT
            conrelid,
            conkey
          FROM
            pg_constraint
          WHERE
            contype = 'p'
          ) pk
          ON pk.conrelid = fk.conrelid
         AND pk.conkey = fk.conkey
        WHERE
          fk.conrelid = mn.confrelid
          AND fk.contype = 'f'
          AND fk.confdeltype = 'a'
      ) mp
      ON (true)
      WHERE
        mn.conrelid = c.conrelid
        AND mn.confrelid <> c.conrelid
        AND mn.contype = 'f'
        AND mn.confdeltype = 'c'
    ) m ON (true)
    WHERE
      c.confrelid = ($2 || '.' || $1)::regclass::oid
      AND c.conrelid <> c.confrelid
      AND c.contype = 'f'
      AND c.confdeltype = 'a'
      AND (p.clean_parent IS NULL OR p.clean_parent <> c.confrelid)
      AND (m.m_table_clean_parent IS NULL OR m.m_table_clean_parent <> c.confrelid)
    ORDER BY
      c.conrelid,
      m.m_table,
      n.ref_depth NULLS FIRST,
      m.m_table_count DESC
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
      OR rec.m_table_clean_parent IS NOT NULL
    ) THEN
      -- function call required, so create function first
      PERFORM
        citydb_pkg.create_array_delete_function(
          COALESCE(rec.m_table, rec.n_table),
          COALESCE(rec.m_table_short, rec.n_table_short),
          $2
        );

      IF rec.m_table IS NULL THEN
        ref_block := ref_block || citydb_pkg.delete_n_table_by_ids(rec.n_table, rec.n_table_short, rec.fk_n_column_name);
      ELSE
        vars := vars || E'\n  '||rec.m_table_short||'_ids int[] := ''{}'';';
        ref_block := ref_block || citydb_pkg.delete_n_m_table_by_ids(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.m_table_short, rec.fk_m_column_name);
      END IF;      
    ELSE
      IF rec.m_table IS NULL THEN
        ref_block := ref_block || citydb_pkg.delete_n_table_by_ids(rec.n_table, rec.fk_n_column_name);
      ELSE
        vars := vars || E'\n  '||rec.m_table||'_ids int[] := ''{}'';';
        ref_block := ref_block || citydb_pkg.delete_n_m_table_by_ids(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.fk_m_column_name);
      END IF;
    END IF;
  END LOOP;

  RETURN;
END;
$$
LANGUAGE plpgsql STRICT;

-- creates code block to delete referenced entries by foreign keys
CREATE OR REPLACE FUNCTION citydb_pkg.delete_fkeys_by_ids(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb',
  OUT vars TEXT,
  OUT returning_block TEXT,
  OUT collect_block TEXT,
  OUT into_block TEXT,
  OUT fk_block TEXT
  ) RETURNS RECORD AS
$$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN (
    SELECT
      fk.fk_table_oid::regclass::text AS fk_table,
      fk.fk_table_oid::regclass::text AS fk_table_short,
      fk.fk_column,
      fk.ref_columns,
      fk.concat_id_arrays,
      rf.has_ref
    FROM (
      SELECT
        c.confrelid AS fk_table_oid,
        a_ref.attname AS fk_column,
        string_agg(a.attname, E',\n      ' ORDER BY a.attnum) AS ref_columns,
        string_agg('array_agg('||a.attname||')', E' ||\n    ' ORDER BY a.attnum) AS concat_id_arrays
      FROM
        pg_constraint c
      JOIN
        pg_attribute a
        ON a.attrelid = c.conrelid
       AND a.attnum = ANY (c.conkey)
      JOIN
        pg_attribute a_ref
        ON a_ref.attrelid = c.confrelid
       AND a_ref.attnum = ANY (c.confkey)
       WHERE
         c.conrelid = ($2 || '.' || $1)::regclass::oid
         AND c.conrelid <> c.confrelid
         AND c.contype = 'f'
         AND c.confdeltype = 'r'
         AND NOT a.attnotnull
       GROUP BY
         c.confrelid,
         a_ref.attname
    ) fk
    LEFT JOIN LATERAL (
      SELECT
        TRUE AS has_ref
      FROM
        pg_constraint
      WHERE
        conrelid = fk.fk_table_oid
        AND confrelid <> fk.fk_table_oid
        AND contype = 'f'
        AND (confdeltype = 'a' OR confdeltype = 'r')
    ) rf ON (true)
  )
  LOOP
    IF vars IS NULL THEN
      vars := '';
      returning_block := '';
      collect_block := '';
      into_block := '';
      fk_block := '';
    END IF;

    vars := vars || E'\n  '||rec.fk_table||'_ids int[] := ''{}'';';
    returning_block := returning_block || E',\n      ' || rec.ref_columns;
    collect_block := collect_block || E',\n    ' || rec.concat_id_arrays;
    into_block := into_block || E',\n    '||rec.fk_table||'_ids';

    IF rec.has_ref THEN
      -- function call required, so create function first
      PERFORM citydb_pkg.create_array_delete_function(rec.fk_table, rec.fk_table_short, $2);
      fk_block := fk_block || citydb_pkg.delete_m_table_by_ids(rec.fk_table, rec.fk_table_short, rec.fk_column, rec.fk_table);
    ELSE
      fk_block := fk_block || citydb_pkg.delete_m_table_by_ids(rec.fk_table, rec.fk_column, rec.fk_table);
    END IF;
  END LOOP;

  RETURN;
END;
$$
LANGUAGE plpgsql STRICT;


-- creates code block to delete referenced parent entries
CREATE OR REPLACE FUNCTION citydb_pkg.delete_parent_by_ids(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS
$$
DECLARE
  rec RECORD;
  parent_block TEXT := '';
BEGIN
  FOR rec IN (
    SELECT 
      f.confrelid::regclass::text AS parent_table,
      f.confrelid::regclass::text AS parent_table_short
    FROM
      pg_constraint f,
      pg_constraint p
    WHERE
      f.conrelid = ($2 || '.' || $1)::regclass::oid
      AND p.conrelid = ($2 || '.' || $1)::regclass::oid
      AND f.conkey = p.conkey
      AND f.contype = 'f'
      AND p.contype = 'p'
      AND f.confdeltype = 'a'
  )
  LOOP
    -- create array delete function for parent table
    PERFORM citydb_pkg.create_array_delete_function(rec.parent_table, rec.parent_table_short, $2);

    -- add delete call for parent table
    parent_block := parent_block
      || E'\n  -- delete '||rec.parent_table
      || E'\n  PERFORM gen.delete_'||rec.parent_table_short||E'(deleted_ids);\n';
  END LOOP;

  RETURN COALESCE(parent_block,'');
END;
$$
LANGUAGE plpgsql;


/***********************
* DELETE BY ID
***********************/
-- creates code block to delete referenced entries in same table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_self_ref_by_id(
  table_name TEXT,
  table_short_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS
$$
DECLARE
  self_block TEXT;
BEGIN
  SELECT string_agg(
    E'\n  --delete referenced parts'
    || E'\n  PERFORM'
    || E'\n    gen.delete_'||$2||'(array_agg(id))'
    || E'\n  FROM'
    || E'\n    '||$1
    || E'\n  WHERE'
    || E'\n    ' ||a.attname|| ' = $1'
    || E'\n    AND id != $1;\n', '')
  INTO
    self_block
  FROM
    pg_constraint c
  JOIN
    pg_attribute a
    ON a.attrelid = c.conrelid
   AND a.attnum = ANY (c.conkey)
  WHERE
    c.conrelid = ($3 || '.' || $1)::regclass::oid
    AND c.conrelid = c.confrelid
    AND c.contype = 'f'
    AND c.confdeltype = 'a'
    AND a.attnotnull = FALSE;

  IF self_block IS NOT NULL THEN
    -- create a dummy array delete function to enable compiling
    PERFORM citydb_pkg.create_array_delete_function($1, $2, $3);
  END IF;

  RETURN COALESCE(self_block,'');
END;
$$
LANGUAGE plpgsql;

-- creates code block to delete referenced entries in n table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_table_by_id(
  table_name TEXT,
  fk_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'s'
  || E'\n  DELETE FROM'
  || E'\n    '||$1
  || E'\n  WHERE'
  || E'\n    '||$2||E' = $1;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries in n table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_table_by_id(
  table_name TEXT,
  table_short_name TEXT,
  fk_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'s'
  || E'\n  PERFORM'
  || E'\n    gen.delete_'||$2||E'(array_agg(id))'
  || E'\n  FROM'
  || E'\n    '||$1
  || E'\n  WHERE'
  || E'\n    '||$3||E' = $1;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete unreferenced entries in m table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_m_table_by_id(
  m_table_name TEXT,
  fk_m_column_name TEXT,
  n_m_table_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'(s) not being referenced any more'
  || E'\n  IF '||$1||'_ref_id IS NOT NULL THEN'
  || E'\n    DELETE FROM'
  || E'\n      '||$1||' m'
  || E'\n    USING'
  || E'\n      (VALUES ('||$1||'_ref_id)) a(a_id)'
  || E'\n    LEFT JOIN'
  || E'\n'     ||$3||' n2m'
  || E'\n      ON n2m.'||$2||' = a.a_id'
  || E'\n    WHERE'
  || E'\n      m.id = a.a_id'
  || E'\n      AND n2m.'||$2||' IS NULL;'
  || E'\n  END IF;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete unreferenced entries in m table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_m_table_by_id(
  m_table_name TEXT,
  m_table_short_name TEXT,
  fk_m_column_name TEXT,
  n_m_table_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT
  E'\n  -- delete '||$1||'(s) not being referenced any more'
  || E'\n  IF '||$1||'_ref_id IS NOT NULL THEN'
  || E'\n    PERFORM'
  || E'\n      gen.delete_'||$2||'(a.a_id)'
  || E'\n    FROM'
  || E'\n      (VALUES ('||$1||'_ref_id)) a(a_id)'
  || E'\n    LEFT JOIN'
  || E'\n'     ||$4||' n2m'
  || E'\n      ON n2m.'||$3||' = a.a_id'
  || E'\n    WHERE'
  || E'\n      n2m.'||$3||' IS NULL;'
  || E'\n  END IF;\n';
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries in n:m table
-- adds another code block to delete unreferenced entries in m table
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_m_table_by_id(
  n_m_table_name TEXT,
  fk_n_column_name TEXT,
  m_table_name TEXT,
  fk_m_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT E'\n  -- delete references to '||$3||'s'
  || E'\n  WITH delete_'||$3||'_refs AS ('
  || E'\n    DELETE FROM'
  || E'\n      '||$1
  || E'\n    WHERE'
  || E'\n      '||$2||' = $1'
  || E'\n    RETURNING'
  || E'\n      '||$4
  || E'\n  )'
  || E'\n  SELECT'
  || E'\n    array_agg('||$4||')'
  || E'\n  INTO'
  || E'\n    '||$3||'_ids'
  || E'\n  FROM'
  || E'\n    delete_'||$3||'_refs;'
  || E'\n' || delete_m_table_by_ids($3, $4, $1);
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries in n:m table
-- adds another code block to delete unreferenced entries in m table with function call
CREATE OR REPLACE FUNCTION citydb_pkg.delete_n_m_table_by_id(
  n_m_table_name TEXT,
  fk_n_column_name TEXT,
  m_table_name TEXT,
  m_table_short_name TEXT,
  fk_m_column_name TEXT
  ) RETURNS TEXT AS 
$$
SELECT E'\n  -- delete references to '||$3||'s'
  || E'\n  WITH delete_'||$4||'_refs AS ('
  || E'\n    DELETE FROM'
  || E'\n      '||$1
  || E'\n    WHERE'
  || E'\n      '||$2||' = $1'
  || E'\n    RETURNING'
  || E'\n      '||$5
  || E'\n  )'
  || E'\n  SELECT'
  || E'\n    array_agg('||$5||')'
  || E'\n  INTO'
  || E'\n    '||$4||'_ids'
  || E'\n  FROM'
  || E'\n    delete_'||$4||'_refs;'
  || E'\n' || delete_m_table_by_ids($3, $4, $5, $1);
$$
LANGUAGE sql STRICT;

-- creates code block to delete referenced entries
CREATE OR REPLACE FUNCTION citydb_pkg.delete_refs_by_id(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb',
  OUT vars TEXT,
  OUT ref_block TEXT
  ) RETURNS RECORD AS
$$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN (
    SELECT
      c.conrelid::regclass::text AS n_table,
      c.conrelid::regclass::text AS n_table_short,
      a.attname AS fk_n_column_name,
      n.ref_count,
      n.ref_depth,
      p.clean_parent,
      m.m_table::regclass::text,
      m.m_table::regclass::text AS m_table_short,
      m.fk_m_column_name,
      m.m_table_count,
      m.m_table_clean_parent
    FROM
      pg_constraint c
    JOIN
      pg_attribute a
      ON a.attrelid = c.conrelid
     AND a.attnum = ANY (c.conkey)
    LEFT JOIN (
      -- count references of referencing tables
      -- > 1 ref = extra delete function
      WITH RECURSIVE ref_table_depth(parent_table, ref_table, depth) AS (
        SELECT
          confrelid AS parent_table,
          conrelid AS ref_table,
          1 AS depth
        FROM
          pg_constraint
        WHERE
          confrelid = ($2 || '.' || $1)::regclass::oid
          AND conrelid <> confrelid
          AND contype = 'f'
          AND confdeltype = 'a'
        UNION ALL
          SELECT
            r.confrelid AS parent_table,
            r.conrelid AS ref_table,
            d.depth + 1 AS depth
          FROM
            pg_constraint r,
            ref_table_depth d
          WHERE
            d.ref_table = r.confrelid
            AND d.ref_table <> r.conrelid
            AND r.contype = 'f'
            AND r.confdeltype = 'a'
      )
      SELECT
        parent_table,
        count(parent_table) AS ref_count,
        max(depth) AS ref_depth
      FROM
        ref_table_depth
      GROUP BY
        parent_table
    ) n
    ON n.parent_table = c.conrelid
    -- check for FKs in ref tables which cover same columns as the PK
    -- if found = extra delete function to clean parent, except parent table = $1
    LEFT JOIN LATERAL (
      SELECT
        fk.confrelid AS clean_parent
      FROM
        pg_constraint fk
      JOIN (
        SELECT
          conrelid,
          conkey
        FROM
          pg_constraint
        WHERE
          contype = 'p'
        ) pk
        ON pk.conrelid = fk.conrelid
       AND pk.conkey = fk.conkey
      WHERE
        fk.conrelid = c.conrelid
        AND fk.contype = 'f'
        AND fk.confdeltype = 'a'
    ) p ON (true)
    -- get tables from n:m relationships to cleanup
    -- the FK has to be confdeltype = 'c' to decide for cleanup
    -- count references of n:m tables and check for FKs cover same columns as PK
    LEFT JOIN LATERAL (
      SELECT
        mn.confrelid AS m_table,
        mna.attname AS fk_m_column_name,
        mr.m_table_count,
        mp.m_table_clean_parent
      FROM
        pg_constraint mn
      JOIN
        pg_attribute mna
        ON mna.attrelid = mn.conrelid
       AND mna.attnum = ANY (mn.conkey)
      LEFT JOIN LATERAL (
        SELECT
          count(confrelid) AS m_table_count
        FROM
          pg_constraint
        WHERE
          confrelid = mn.confrelid
          AND conrelid <> confrelid
          AND contype = 'f'
        GROUP BY
          confrelid
      ) mr
      ON (true)
      LEFT JOIN LATERAL (
        SELECT
          fk.confrelid AS m_table_clean_parent
        FROM
          pg_constraint fk
        JOIN (
          SELECT
            conrelid,
            conkey
          FROM
            pg_constraint
          WHERE
            contype = 'p'
          ) pk
          ON pk.conrelid = fk.conrelid
         AND pk.conkey = fk.conkey
        WHERE
          fk.conrelid = mn.confrelid
          AND fk.contype = 'f'
          AND fk.confdeltype = 'a'
      ) mp
      ON (true)
      WHERE
        mn.conrelid = c.conrelid
        AND mn.confrelid <> c.conrelid
        AND mn.contype = 'f'
        AND mn.confdeltype = 'c'
    ) m ON (true)
    WHERE
      c.confrelid = ($2 || '.' || $1)::regclass::oid
      AND c.conrelid <> c.confrelid
      AND c.contype = 'f'
      AND c.confdeltype = 'a'
      AND (p.clean_parent IS NULL OR p.clean_parent <> c.confrelid)
      AND (m.m_table_clean_parent IS NULL OR m.m_table_clean_parent <> c.confrelid)
    ORDER BY
      c.conrelid,
      m.m_table,
      n.ref_depth NULLS FIRST,
      m.m_table_count DESC
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
      OR rec.m_table_clean_parent IS NOT NULL
    ) THEN
      -- function call required, so create function first
      PERFORM
        citydb_pkg.create_array_delete_function(
          COALESCE(rec.m_table, rec.n_table),
          COALESCE(rec.m_table_short, rec.n_table_short),
          $2
        );

      IF rec.m_table IS NULL THEN
        ref_block := ref_block || citydb_pkg.delete_n_table_by_id(rec.n_table, rec.n_table_short, rec.fk_n_column_name);
      ELSE
        vars := vars || E'\n  '||rec.m_table_short||'_ids int[] := ''{}'';';
        ref_block := ref_block || citydb_pkg.delete_n_m_table_by_id(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.m_table_short, rec.fk_m_column_name);
      END IF;      
    ELSE
      IF rec.m_table IS NULL THEN
        ref_block := ref_block || citydb_pkg.delete_n_table_by_id(rec.n_table, rec.fk_n_column_name);
      ELSE
        vars := vars || E'\n  '||rec.m_table||'_ids int[] := ''{}'';';
        ref_block := ref_block || citydb_pkg.delete_n_m_table_by_id(rec.n_table, rec.fk_n_column_name, rec.m_table, rec.fk_m_column_name);
      END IF;
    END IF;
  END LOOP;

  RETURN;
END;
$$
LANGUAGE plpgsql STRICT;

-- creates code block to delete referenced entries by foreign keys
CREATE OR REPLACE FUNCTION citydb_pkg.delete_fkeys_by_id(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb',
  OUT vars TEXT,
  OUT returning_block TEXT,
  OUT into_block TEXT,
  OUT fk_block TEXT
  ) RETURNS RECORD AS
$$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN (
    SELECT
      fk.fk_table_oid::regclass::text AS fk_table,
      fk.fk_table_oid::regclass::text AS fk_table_short,
      fk.fk_column,
      fk.ref_columns,
      fk.column_count,
      rf.has_ref
    FROM (
      SELECT
        c.confrelid AS fk_table_oid,
        a_ref.attname AS fk_column,
        string_agg(a.attname, E',\n      ' ORDER BY a.attnum) AS ref_columns,
        count(a.attname) AS column_count
      FROM
        pg_constraint c
      JOIN
        pg_attribute a
        ON a.attrelid = c.conrelid
       AND a.attnum = ANY (c.conkey)
      JOIN
        pg_attribute a_ref
        ON a_ref.attrelid = c.confrelid
       AND a_ref.attnum = ANY (c.confkey)
       WHERE
         c.conrelid = ($2 || '.' || $1)::regclass::oid
         AND c.conrelid <> c.confrelid
         AND c.contype = 'f'
         AND c.confdeltype = 'r'
         AND NOT a.attnotnull
       GROUP BY
         c.confrelid,
         a_ref.attname
    ) fk
    LEFT JOIN LATERAL (
      SELECT
        TRUE AS has_ref
      FROM
        pg_constraint
      WHERE
        conrelid = fk.fk_table_oid
        AND confrelid <> fk.fk_table_oid
        AND contype = 'f'
        AND (confdeltype = 'a' OR confdeltype = 'r')
    ) rf ON (true)
  )
  LOOP
    IF vars IS NULL THEN
      vars := '';
      returning_block := '';
      into_block := '';
      fk_block := '';
    END IF;

    IF rec.column_count > 1 THEN
      vars := vars || E'\n  '||rec.fk_table||'_ids int[] := ''{}'';';
      returning_block := returning_block || E',\n    ARRAY['||rec.ref_columns||']';
      into_block := into_block || E',\n    ' ||rec.fk_table||'_ids';
    ELSE
      vars := vars || E'\n  '||rec.fk_table||'_ref_id int;';
      returning_block := returning_block || E',\n    '||rec.ref_columns;
      into_block := into_block || E',\n    ' ||rec.fk_table||'_ref_id';
    END IF;

    IF rec.has_ref THEN
      -- function call required, so create function first
      PERFORM citydb_pkg.create_array_delete_function(rec.fk_table, rec.fk_table_short, $2);
      IF rec.column_count > 1 THEN
        fk_block := fk_block || citydb_pkg.delete_m_table_by_ids(rec.fk_table, rec.fk_table_short, rec.fk_column, rec.fk_table);
      ELSE
        fk_block := fk_block || citydb_pkg.delete_m_table_by_id(rec.fk_table, rec.fk_table_short, rec.fk_column, rec.fk_table);
      END IF;
    ELSE
      IF rec.column_count > 1 THEN
        fk_block := fk_block || citydb_pkg.delete_m_table_by_ids(rec.fk_table, rec.fk_column, rec.fk_table);
      ELSE
        fk_block := fk_block || citydb_pkg.delete_m_table_by_id(rec.fk_table, rec.fk_column, rec.fk_table);
      END IF;
    END IF;
  END LOOP;

  RETURN;
END;
$$
LANGUAGE plpgsql STRICT;

-- creates code block to delete referenced parent entries
CREATE OR REPLACE FUNCTION citydb_pkg.delete_parent_by_id(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS
$$
DECLARE
  rec RECORD;
  parent_block TEXT := '';
BEGIN
  FOR rec IN (
    SELECT 
      f.confrelid::regclass::text AS parent_table,
      f.confrelid::regclass::text AS parent_table_short
    FROM
      pg_constraint f,
      pg_constraint p
    WHERE
      f.conrelid = ($2 || '.' || $1)::regclass::oid
      AND p.conrelid = ($2 || '.' || $1)::regclass::oid
      AND f.conkey = p.conkey
      AND f.contype = 'f'
      AND p.contype = 'p'
      AND f.confdeltype = 'a'
  )
  LOOP
    -- create array delete function for parent table
    PERFORM citydb_pkg.create_delete_function(rec.parent_table, rec.parent_table_short, $2);

    -- add delete call for parent table
    parent_block := parent_block
      || E'\n  -- delete '||rec.parent_table
      || E'\n  PERFORM gen.delete_'||rec.parent_table_short||E'(deleted_id);\n';
  END LOOP;

  RETURN COALESCE(parent_block,'');
END;
$$
LANGUAGE plpgsql;


/**************************
* CREATE DELETE FUNCTION
**************************/
-- dummy function to compile array delete functions with recursions
CREATE OR REPLACE FUNCTION citydb_pkg.create_array_delete_dummy(
  table_short_name TEXT
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  ddl_command TEXT := 'CREATE OR REPLACE FUNCTION gen.delete_' || $1 || E'(int[]) RETURNS SETOF int AS\n$body$'
    || E'\nDECLARE\n  deleted_ids int[] := ''{}'';'
    || E'\nBEGIN\n  RETURN QUERY SELECT unnest(deleted_ids);\nEND;'
    || E'\n$body$\nLANGUAGE plpgsql STRICT;';
BEGIN
  EXECUTE ddl_command;
END;
$$
LANGUAGE plpgsql STRICT;

-- creates a array delete function for given table
-- returns deleted IDs (set of int)
CREATE OR REPLACE FUNCTION citydb_pkg.create_array_delete_function(
  table_name TEXT,
  table_short_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  ddl_command TEXT := 'CREATE OR REPLACE FUNCTION gen.delete_' ||$2|| E'(int[]) RETURNS SETOF int AS\n$body$';
  declare_block TEXT := E'\nDECLARE\n  deleted_ids int[] := ''{}'';';
  pre_block TEXT := '';
  post_block TEXT := '';
  delete_agg_start TEXT := E'\n  WITH delete_objects AS (\n  ';
  delete_block TEXT := E'  DELETE FROM\n      '||$1||E' t\n    USING\n      unnest($1) a(a_id)\n    WHERE\n      t.id = a.a_id\n    RETURNING\n      id';
  delete_agg_end TEXT := E'\n  )\n  SELECT\n    array_agg(id)';
  return_block TEXT := E'\n  RETURN QUERY\n    SELECT unnest(deleted_ids);';
BEGIN
  -- SELF-REFERENCES
  pre_block := citydb_pkg.delete_self_ref_by_ids($1, $2, $3);

  -- REFERENCING TABLES
  SELECT
    declare_block || COALESCE(vars, ''),
    pre_block || COALESCE(ref_block, '')
  INTO
    declare_block,
    pre_block
  FROM
    citydb_pkg.delete_refs_by_ids($1, $3);

  -- FOREIGN KEY which are set to ON DELETE RESTRICT
  SELECT
    declare_block || COALESCE(vars, ''),
    delete_block || COALESCE(returning_block, ''),
    delete_agg_end || COALESCE(collect_block, '') 
      || E'\n  INTO\n    deleted_ids'
      || COALESCE(into_block, '')
      || E'\n  FROM\n    delete_objects;\n',
    COALESCE(fk_block, '')
  INTO
    declare_block,
    delete_block,
    delete_agg_end,
    post_block
  FROM
    citydb_pkg.delete_fkeys_by_ids($1, $3);

  -- FOREIGN KEY which cover same columns as primary key
  post_block := post_block || citydb_pkg.delete_parent_by_ids($1, $3);
  
  -- if there is no FK to clean up IDs can be returned directly with DELETE statement 
  IF post_block = '' THEN
    delete_agg_start := E'\n  RETURN QUERY\n  ';
    delete_block := delete_block;
    delete_agg_end := ';';
    return_block := '';
  END IF;

  -- putting all together
  IF pre_block = '' AND post_block = '' THEN
    ddl_command := ddl_command
      || E'\n  -- delete '||$1||'s'
      || E'\n' || delete_block || ';'
      || E'\n$body$\nLANGUAGE sql STRICT';
  ELSE
    ddl_command := ddl_command
      || declare_block
      || E'\nBEGIN'
      || pre_block
      || E'\n  -- delete '||$1||'s'
      || delete_agg_start
      || delete_block
      || delete_agg_end
      || post_block
      || return_block
      || E'\nEND;'
      || E'\n$body$'
      || E'\nLANGUAGE plpgsql STRICT';
  END IF;

  EXECUTE ddl_command;
END;
$$
LANGUAGE plpgsql STRICT;


-- creates a delete function for given table
-- returns deleted ID (int)
CREATE OR REPLACE FUNCTION citydb_pkg.create_delete_function(
  table_name TEXT,
  table_short_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  ddl_command TEXT := 'CREATE OR REPLACE FUNCTION gen.delete_' ||$2|| E'(int) RETURNS int AS\n$body$';
  declare_block TEXT := E'\nDECLARE\n  deleted_id INTEGER;';
  pre_block TEXT := '';
  post_block TEXT := '';
  delete_block TEXT := E'\n  DELETE FROM\n    '||$1||E'\n  WHERE\n    id = $1\n  RETURNING\n    id';
  delete_into_block TEXT := E'\n  INTO\n    deleted_id';
BEGIN
  -- SELF-REFERENCES
  pre_block := citydb_pkg.delete_self_ref_by_id($1, $2, $3);

  -- REFERENCING TABLES
  SELECT
    declare_block || COALESCE(vars, ''),
    pre_block || COALESCE(ref_block, '')
  INTO
    declare_block,
    pre_block
  FROM
    citydb_pkg.delete_refs_by_id($1, $3);

  -- FOREIGN KEY which are set to ON DELETE RESTRICT
  SELECT
    declare_block || COALESCE(vars, ''),
    delete_block || COALESCE(returning_block, ''),
    delete_into_block || COALESCE(into_block, '') || E';\n',
    COALESCE(fk_block, '')
  INTO
    declare_block,
    delete_block,
    delete_into_block,
    post_block
  FROM
    citydb_pkg.delete_fkeys_by_id($1, $3);

  -- FOREIGN KEY which cover same columns as primary key
  post_block := citydb_pkg.delete_parent_by_id($1, $3);

  -- putting all together
  IF pre_block = '' AND post_block = '' THEN
    ddl_command := ddl_command
      || E'\n  -- delete '||$1||'s'
      || delete_block || ';'
      || E'\n$body$\nLANGUAGE sql STRICT';
  ELSE
    ddl_command := ddl_command
      || declare_block
      || E'\nBEGIN'
      || pre_block
      || E'\n  -- delete '||$1||'s'
      || delete_block
      || delete_into_block
      || post_block
      || E'\n  RETURN deleted_id;'
      || E'\nEND;'
      || E'\n$body$'
      || E'\nLANGUAGE plpgsql STRICT';
  END IF;

  EXECUTE ddl_command;
END;
$$
LANGUAGE plpgsql STRICT;