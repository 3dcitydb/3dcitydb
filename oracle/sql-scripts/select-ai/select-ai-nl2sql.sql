-- select-ai-nl2sql.sql
-- Custom natural-language-to-SQL layer for the 3DCityDB on top of
-- Oracle Select AI (DBMS_CLOUD_AI).
--
-- WHY THIS EXISTS
-- ---------------
-- The native `SELECT AI "<question>"` syntax is single-shot NL2SQL: when it
-- builds the prompt for the LLM it only harvests STRUCTURAL metadata of the
-- objects in the profile's object_list (column names/types, constraints,
-- comments, annotations). It never reads the *rows* of a table. That means
-- the PROPERTY_CATALOG view -- whose value is entirely in its rows (which
-- property of which feature type is stored in which VAL_* column) -- is
-- invisible to the model. The model is therefore forced to guess property
-- names and value columns, and a single-shot statement cannot "first query
-- the catalog, then query the data".
--
-- This script flips the approach: it renders the resolved PROPERTY_CATALOG
-- (plus the EAV query rules and objectclass-id map) into a compact TEXT
-- catalog so the model sees the complete property->storage mapping up front.
-- That catalog text is exposed two ways:
--
--   A) NATIVE Select AI injection (recommended) -- keep standard NL2SQL, but
--      inject the catalog as the prompt. Select AI still augments with the
--      physical table DDL from the profile object_list; build_context adds the
--      semantic layer it cannot infer (EAV pattern + property->column catalog).
--      Because the catalog rows now travel in the prompt, PROPERTY_CATALOG (and
--      the pure-metadata tables OBJECTCLASS/DATATYPE/NAMESPACE/ADE) are removed
--      from the object_list in select-ai-create-profile.sql.
--
--        -- inspect the exact prompt that would be sent (no LLM call, no DML):
--        SELECT DBMS_CLOUD_AI.GENERATE(
--                 prompt       => citydb_ai.build_context('How many buildings?'),
--                 profile_name => 'OPENAI',
--                 action       => 'showprompt') FROM dual;
--        -- get / run the SQL (these call the LLM):
--        SELECT AI showsql How many buildings are higher than 20 m?   -- (native prefix, no catalog)
--        SELECT DBMS_CLOUD_AI.GENERATE(
--                 prompt => citydb_ai.build_context('How many buildings higher than 20 m?'),
--                 profile_name => 'OPENAI', action => 'showsql') FROM dual;
--
--   B) Self-contained 'chat' wrapper -- build_prompt is a full standalone prompt
--      and object_list is ignored. Invoke from PL/SQL (GENERATE does internal
--      DML, so SELECT ... FROM dual would raise ORA-14551):
--        VAR rc REFCURSOR
--        EXEC :rc := citydb_ai.ask('List the 10 tallest buildings with their height');
--        PRINT rc
--
-- Run as the application user (e.g. CITYDB) in the target PDB AFTER
-- select-ai-property-catalog.sql and select-ai-create-profile.sql.

SET FEEDBACK ON
SET SERVEROUTPUT ON
SET DEFINE OFF

-- ===============================================================
-- 1. Materialized LLM context (rendered once, refreshed on demand)
-- ===============================================================
-- Rendering the full catalog walks several recursive CTEs in
-- PROPERTY_CATALOG, so we cache the result here instead of rebuilding it
-- before every question. Re-run CITYDB_AI.REFRESH_CONTEXT after any schema
-- change (new ADE, reimport of objectclass/datatype metadata).
PROMPT Creating AI_SCHEMA_CONTEXT cache table ...
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ai_schema_context PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE ai_schema_context (
  id          NUMBER        DEFAULT 1 PRIMARY KEY,
  content     CLOB,
  row_count   NUMBER,
  refreshed_at TIMESTAMP
);

-- ===============================================================
-- 2. CITYDB_AI package
-- ===============================================================
PROMPT Creating CITYDB_AI package specification ...
CREATE OR REPLACE PACKAGE citydb_ai AS
  -- Profile used for every GENERATE call. Created by select-ai-create-profile.sql.
  g_profile_name CONSTANT VARCHAR2(30) := 'OPENAI';

  -- (Re)render the PROPERTY_CATALOG into the AI_SCHEMA_CONTEXT cache.
  PROCEDURE refresh_context;

  -- Return the cached LLM context text (renders it first if the cache is empty).
  FUNCTION context_text RETURN CLOB;

  -- Slim context for INJECTION into native Select AI (action => showsql/runsql/
  -- showprompt): EAV data-model rules + the catalog + the question, but WITHOUT
  -- a system role or output-format instructions (Select AI supplies those and
  -- the physical table DDL from the profile object_list). Use this from SQL:
  --   SELECT DBMS_CLOUD_AI.GENERATE(
  --            prompt => citydb_ai.build_context('<question>'),
  --            profile_name => 'OPENAI', action => 'showsql') FROM dual;
  FUNCTION build_context(p_question IN CLOB) RETURN CLOB;

  -- Full standalone prompt for action => 'chat' (no schema augmentation):
  -- wraps build_context with a system role and an "output only SQL" instruction.
  FUNCTION build_prompt(p_question IN CLOB) RETURN CLOB;

  -- Ask the LLM for SQL only and return the cleaned statement (no markdown).
  FUNCTION generate_sql(p_question IN CLOB) RETURN CLOB;

  -- Generate SQL for the question, execute it, and return an open cursor.
  FUNCTION ask(p_question IN CLOB) RETURN SYS_REFCURSOR;
END citydb_ai;
/

PROMPT Creating CITYDB_AI package body ...
CREATE OR REPLACE PACKAGE BODY citydb_ai AS

  -- whitespace set for LOB-safe LTRIM/RTRIM (TRIM is not supported on CLOB)
  c_ws CONSTANT VARCHAR2(4) := ' ' || CHR(9) || CHR(10) || CHR(13);

  -- ---- internal: append a VARCHAR2 buffer to a CLOB efficiently ------------
  PROCEDURE append_line(p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
  BEGIN
    DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text);
  END;

  -- ---- render the catalog into one CLOB -----------------------------------
  FUNCTION render_catalog RETURN CLOB IS
    v_ctx       CLOB;
    v_prev_oc   NUMBER := -1;
    v_cnt       NUMBER := 0;
    v_lf        CONSTANT VARCHAR2(2) := CHR(10);
  BEGIN
    DBMS_LOB.CREATETEMPORARY(v_ctx, TRUE);

    append_line(v_ctx,
      '=== 3DCITYDB PROPERTY CATALOG ===' || v_lf ||
      'Per feature type: every property and where its value is stored.' || v_lf ||
      'Header format: [alias:FeatureType id=<objectclass_id> TOPLEVEL?].' || v_lf ||
      'Use the exact property name (case-sensitive) shown before "->" for PROPERTY.NAME filters.' || v_lf ||
      'Mapping legend:' || v_lf ||
      '  prop -> property.val_x        : JOIN property p ON p.feature_id=f.id AND p.name=''prop''; value in p.val_x' || v_lf ||
      '  prop -> feature.col           : value is the direct FEATURE column f.col (no PROPERTY join)' || v_lf ||
      '  parent.child -> property.val_x: two-hop. JOIN property pp ON pp.feature_id=f.id AND pp.name=''parent''' || v_lf ||
      '                                  JOIN property pc ON pc.parent_id=pp.id AND pc.name=''child''; value in pc.val_x' || v_lf ||
      '  prop -> <table> via property.val_x_id : JOIN property p (feature_id,name) JOIN <table> t ON t.id=p.val_x_id' || v_lf ||
      '  prop -> contains T1(id1),T2(id2) via VAL_FEATURE_ID : child features. JOIN property p (feature_id,name)' || v_lf ||
      '                                  JOIN feature fc ON fc.id=p.val_feature_id AND fc.objectclass_id IN (id1,id2,...)' || v_lf ||
      '  (complex; see sub-properties) : value lives in the parent.child sub-property lines below.' || v_lf || v_lf);

    FOR r IN (
      SELECT
        pc.objectclass_id,
        pc.namespace_alias,
        pc.feature_type,
        pc.is_toplevel,
        pc.parent_property,
        pc.property_name,
        CASE
          WHEN pc.relation_type = 'contains' THEN
            pc.property_name || ' -> contains '
            || LISTAGG(
                 CASE WHEN pc.target_objectclass_id IS NOT NULL
                      THEN pc.target_feature_type || '(' || pc.target_objectclass_id || ')'
                 END,
                 ',' ON OVERFLOW TRUNCATE)
                 WITHIN GROUP (ORDER BY pc.target_objectclass_id)
            || ' via VAL_FEATURE_ID'
          WHEN pc.parent_property IS NOT NULL THEN
            pc.parent_property || '.' || pc.property_name
            || ' -> property.' || LOWER(pc.value_column)
          WHEN pc.join_table IS NOT NULL THEN
            pc.property_name || ' -> ' || LOWER(pc.join_table)
            || ' via property.' || LOWER(pc.value_column)
          WHEN pc.value_column LIKE 'VAL\_%' ESCAPE '\' THEN
            pc.property_name || ' -> property.' || LOWER(pc.value_column)
          WHEN pc.value_column IS NOT NULL THEN
            pc.property_name || ' -> feature.' || LOWER(pc.value_column)
          ELSE
            pc.property_name || ' -> (complex; see sub-properties)'
        END AS line
      FROM property_catalog pc
      -- Keep every top-level property; drop sub-properties (parent.child) that
      -- have no storage column resolved -- they would render a useless
      -- "parent.child -> property." line with an empty value column.
      WHERE pc.parent_property IS NULL OR pc.value_column IS NOT NULL
      GROUP BY
        pc.objectclass_id, pc.namespace_alias, pc.feature_type, pc.is_toplevel,
        pc.parent_property, pc.property_name, pc.relation_type,
        pc.value_column, pc.join_table
      ORDER BY
        pc.is_toplevel DESC, pc.namespace_alias, pc.feature_type, pc.objectclass_id,
        pc.parent_property NULLS FIRST, pc.property_name
    ) LOOP
      IF r.objectclass_id != v_prev_oc THEN
        append_line(v_ctx, v_lf || '[' || NVL(r.namespace_alias, '?') || ':' || r.feature_type
          || ' id=' || r.objectclass_id
          || CASE WHEN r.is_toplevel = 1 THEN ' TOPLEVEL' END || ']' || v_lf);
        v_prev_oc := r.objectclass_id;
      END IF;
      append_line(v_ctx, '  ' || r.line || v_lf);
      v_cnt := v_cnt + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Rendered ' || v_cnt || ' catalog lines ('
      || DBMS_LOB.GETLENGTH(v_ctx) || ' chars).');
    RETURN v_ctx;
  END render_catalog;

  -- ---- public: refresh the cache ------------------------------------------
  PROCEDURE refresh_context IS
    v_ctx CLOB;
  BEGIN
    v_ctx := render_catalog;
    DELETE FROM ai_schema_context WHERE id = 1;
    INSERT INTO ai_schema_context (id, content, row_count, refreshed_at)
    VALUES (1, v_ctx, (SELECT COUNT(*) FROM property_catalog), SYSTIMESTAMP);
    COMMIT;
    DBMS_LOB.FREETEMPORARY(v_ctx);
  END refresh_context;

  -- ---- public: read cache (render lazily if empty) ------------------------
  FUNCTION context_text RETURN CLOB IS
    v_ctx CLOB;
  BEGIN
    BEGIN
      SELECT content INTO v_ctx FROM ai_schema_context WHERE id = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        refresh_context;
        SELECT content INTO v_ctx FROM ai_schema_context WHERE id = 1;
    END;
    RETURN v_ctx;
  END context_text;

  -- ---- public: slim context (EAV rules + catalog + question) --------------
  -- Shared by both paths. Holds the SEMANTIC layer Select AI cannot infer from
  -- physical DDL: the EAV access pattern and the property->storage catalog.
  -- Deliberately contains NO system role and NO output-format instruction, so
  -- it can be injected as the prompt of a native Select AI NL2SQL call without
  -- fighting Select AI's own template.
  FUNCTION build_context(p_question IN CLOB) RETURN CLOB IS
    v_ctx CLOB;
    v_lf  CONSTANT VARCHAR2(2) := CHR(10);
  BEGIN
    IF p_question IS NULL OR DBMS_LOB.GETLENGTH(p_question) = 0 THEN
      RAISE_APPLICATION_ERROR(-20800, 'Question must not be empty.');
    END IF;

    DBMS_LOB.CREATETEMPORARY(v_ctx, TRUE);

    append_line(v_ctx,
      'DATA MODEL (Entity-Attribute-Value):' || v_lf ||
      '- FEATURE: one row per city object. Its type is FEATURE.OBJECTCLASS_ID (an integer).' || v_lf ||
      '  NEVER join the OBJECTCLASS table; filter f.objectclass_id by the literal id from the catalog header.' || v_lf ||
      '- PROPERTY: attributes of a feature (EAV). Join via PROPERTY.FEATURE_ID = FEATURE.ID and' || v_lf ||
      '  filter PROPERTY.NAME = ''<exact property name>''. The value sits in a type-specific column' || v_lf ||
      '  (val_string, val_int, val_double, val_timestamp, val_uri, val_feature_id, val_geometry_id, ...).' || v_lf ||
      '  Code value: val_string (+ val_codespace). Measure value: val_double (+ val_uom). Boolean: val_int (0/1).' || v_lf ||
      '- Nested/complex properties use PROPERTY.PARENT_ID (two-hop join; see catalog "parent.child" lines).' || v_lf ||
      '- Containment hierarchy: a parent feature owns child features through a PROPERTY whose' || v_lf ||
      '  VAL_FEATURE_ID points at the child FEATURE.ID. Deep nesting may need MULTI-HOP traversal' || v_lf ||
      '  (e.g. Building -> WallSurface -> WindowSurface), repeating the property+feature join per hop.' || v_lf ||
      '- GEOMETRY_DATA.GEOMETRY holds SDO_GEOMETRY; reach it via a property''s val_geometry_id.' || v_lf ||
      '- ADDRESS is reached via a property''s val_address_id (addresses are NOT in FEATURE).' || v_lf || v_lf ||
      'CATALOG RULES:' || v_lf ||
      '- Use ONLY the feature types, property names and storage columns from the CATALOG below.' || v_lf ||
      '- Property names are case-sensitive; copy them verbatim.' || v_lf ||
      '- Prefer table aliases f (feature), p / pp / pc (property), gd (geometry_data).' || v_lf || v_lf);

    DBMS_LOB.APPEND(v_ctx, context_text);

    append_line(v_ctx, v_lf || v_lf || '=== USER QUESTION ===' || v_lf);
    DBMS_LOB.APPEND(v_ctx, p_question);

    RETURN v_ctx;
  END build_context;

  -- ---- public: full standalone prompt for action => 'chat' ----------------
  FUNCTION build_prompt(p_question IN CLOB) RETURN CLOB IS
    v_prompt CLOB;
    v_ctx    CLOB;
    v_lf     CONSTANT VARCHAR2(2) := CHR(10);
  BEGIN
    DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);

    append_line(v_prompt,
      'You are an expert Oracle SQL generator for a 3D City Database (3DCityDB v5, CityGML 3.0).' || v_lf ||
      'Translate the user question into ONE valid Oracle SQL SELECT statement.' || v_lf ||
      'Output ONLY the SQL statement. No markdown fences, no comments, no explanation, no trailing semicolon.' || v_lf || v_lf);

    v_ctx := build_context(p_question);
    DBMS_LOB.APPEND(v_prompt, v_ctx);
    IF DBMS_LOB.ISTEMPORARY(v_ctx) = 1 THEN
      DBMS_LOB.FREETEMPORARY(v_ctx);
    END IF;

    append_line(v_prompt, v_lf || v_lf || 'SQL:');

    RETURN v_prompt;
  END build_prompt;

  -- ---- internal: strip markdown fences / stray prose ----------------------
  FUNCTION clean_sql(p_raw IN CLOB) RETURN CLOB IS
    v_sql CLOB := p_raw;
    v_pos PLS_INTEGER;
  BEGIN
    -- drop markdown code fences (```sql ... ```)
    v_sql := REGEXP_REPLACE(v_sql, '```[[:alpha:]]*', '');
    v_sql := REPLACE(v_sql, '```', '');
    -- if the model prefixed prose, cut to the first SELECT/WITH keyword
    v_pos := REGEXP_INSTR(UPPER(v_sql), '(^|[[:space:]])(SELECT|WITH)[[:space:]]');
    IF v_pos > 1 THEN
      v_sql := SUBSTR(v_sql, v_pos);
    END IF;
    -- trim surrounding whitespace and a trailing semicolon (illegal for OPEN..FOR)
    v_sql := LTRIM(v_sql, c_ws);
    v_sql := RTRIM(v_sql, c_ws || ';');
    RETURN v_sql;
  END clean_sql;

  -- ---- public: generate cleaned SQL ---------------------------------------
  FUNCTION generate_sql(p_question IN CLOB) RETURN CLOB IS
    v_prompt CLOB;
    v_raw    CLOB;
    v_sql    CLOB;
  BEGIN
    IF p_question IS NULL OR DBMS_LOB.GETLENGTH(p_question) = 0 THEN
      RAISE_APPLICATION_ERROR(-20800, 'Question must not be empty.');
    END IF;
    v_prompt := build_prompt(p_question);
    v_raw := DBMS_CLOUD_AI.GENERATE(
               prompt       => v_prompt,
               profile_name => g_profile_name,
               action       => 'chat');
    v_sql := clean_sql(v_raw);
    -- release the session-duration temporary prompt LOB
    IF DBMS_LOB.ISTEMPORARY(v_prompt) = 1 THEN
      DBMS_LOB.FREETEMPORARY(v_prompt);
    END IF;
    RETURN v_sql;
  END generate_sql;

  -- ---- public: generate + execute -----------------------------------------
  FUNCTION ask(p_question IN CLOB) RETURN SYS_REFCURSOR IS
    v_sql CLOB;
    v_rc  SYS_REFCURSOR;
  BEGIN
    v_sql := generate_sql(p_question);
    -- safety guard: only read-only statements (SELECT / WITH ...) may be executed
    IF NOT REGEXP_LIKE(v_sql, '^[[:space:]]*(SELECT|WITH)[[:space:](]', 'i') THEN
      RAISE_APPLICATION_ERROR(-20801,
        'Generated statement is not a read-only query: ' || SUBSTR(v_sql, 1, 200));
    END IF;
    OPEN v_rc FOR v_sql;
    RETURN v_rc;
  END ask;

END citydb_ai;
/

-- ===============================================================
-- 3. Populate the cache now
-- ===============================================================
PROMPT Rendering initial AI schema context ...
BEGIN
  citydb_ai.refresh_context;
END;
/

DECLARE
  v_len NUMBER;
  v_rows NUMBER;
BEGIN
  SELECT DBMS_LOB.GETLENGTH(content), row_count
    INTO v_len, v_rows
    FROM ai_schema_context WHERE id = 1;
  DBMS_OUTPUT.PUT_LINE('CITYDB_AI ready. Catalog context = ' || v_len
    || ' chars from ' || v_rows || ' property_catalog rows.');
END;
/

PROMPT CITYDB_AI NL2SQL layer setup complete.
