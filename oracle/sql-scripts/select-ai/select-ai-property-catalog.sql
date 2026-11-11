-- select-ai-property-catalog.sql
-- Builds the property catalog and its LLM-prompt renderer for the 3DCityDB
-- natural-language-to-SQL layer on top of Oracle Select AI (DBMS_CLOUD_AI).
--
--   PART 1 -- PROPERTY_CATALOG view: a flattened, inheritance-resolved catalog
--             mapping every CityGML property of every feature type to its
--             storage location (a PROPERTY VAL_* column, a direct column of
--             the table its class is stored in -- FEATURE, or ADDRESS /
--             APPEARANCE / SURFACE_DATA / IMPLICIT_GEOMETRY -- or a containment
--             target), tagged with the ancestor class that DECLARES each
--             property. PROPERTY_CATALOG_TEXT renders one
--             compact "prop -> storage" line per property on top of it. Neither
--             is in the Select AI object_list.
--   PART 2 -- CITYDB_AI package: assembles PART 1 (plus the EAV query rules)
--             into the prompt. Properties shared via inheritance are emitted
--             ONCE as named blocks (@namespace:AbstractClass); each feature type
--             lists the blocks it inherits plus its own properties -- keeping
--             the injected catalog compact for a native Select AI NL2SQL call.
--
-- WHY PART 2 EXISTS
-- ----------------
-- Native `SELECT AI "<question>"` feeds the LLM only the STRUCTURAL metadata of
-- the object_list tables (columns, types, comments) -- never their ROWS. So the
-- PROPERTY_CATALOG view, whose value IS its rows (which property maps to which
-- VAL_* column), is invisible to the model and it just guesses. BUILD_CONTEXT
-- renders the catalog to text and injects it as the prompt, supplying the
-- semantic layer Select AI cannot infer from DDL (EAV pattern + property->column
-- map + the meaning of the object_list tables, which carry no comments or
-- annotations). A bare `SELECT AI "<question>"` bypasses all of it -- always go
-- through BUILD_CONTEXT as shown below. Because the rows now travel in the
-- prompt, PROPERTY_CATALOG and the metadata tables OBJECTCLASS/DATATYPE/
-- NAMESPACE/ADE are kept out of the object_list (see select-ai-create-profile.sql).
--
--   -- inspect the prompt (no LLM call, no DML), or get / run the SQL:
--   SELECT DBMS_CLOUD_AI.GENERATE(
--            prompt       => citydb_ai.build_context('How many buildings higher than 20 m?'),
--            profile_name => 'OPENAI',
--            action       => 'showprompt') FROM dual;   -- or 'showsql' / 'runsql'
--
-- Run as the application user (e.g. CITYDB) in the target PDB AFTER
-- schema.sql, objectclass-instances.sql and datatype-instances.sql.

SET FEEDBACK ON
SET SERVEROUTPUT ON

-- ===============================================================
-- PART 1 – PROPERTY_CATALOG view (data source for PART 2)
-- ===============================================================
PROMPT Dropping legacy PROPERTY_CATALOG table (if exists) ...
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE property_catalog PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

PROMPT Creating PROPERTY_CATALOG view ...
CREATE OR REPLACE VIEW property_catalog (
  objectclass_id, feature_type, is_toplevel, namespace_alias,
  ade_id, property_name, parent_property, value_column,
  join_table, target_objectclass_id, target_feature_type,
  relation_type, description, query_pattern,
  declaring_class_id, declaring_class_name, declaring_namespace_alias, inheritance_level,
  source_table, join_condition, sub_storage
) AS
WITH
-- Walk UP from each concrete class to collect all ancestor IDs.
ancestor_chain (leaf_id, current_id, lvl) AS (
  SELECT id, id, 0
  FROM objectclass
  WHERE is_abstract = 0
  UNION ALL
  SELECT ac.leaf_id, oc.superclass_id, ac.lvl + 1
  FROM ancestor_chain ac
  JOIN objectclass oc ON oc.id = ac.current_id
  WHERE oc.superclass_id IS NOT NULL
),
-- Extract properties from each ancestor's SCHEMA JSON.
-- Handles these patterns:
--   a) type-based  (type: "core:Code")         -> stored in PROPERTY table
--   b) direct-col  (value.column: "valid_from") -> column of the class's own
--      table ($.table: FEATURE, ADDRESS, APPEARANCE, SURFACE_DATA, ...)
--   c) join        (join / joinTable)           -> column or row of another
--      table reached from the class's own table (e.g. TEX_IMAGE)
raw_props_base AS (
  SELECT
    ac.leaf_id AS objectclass_id,
    ac.current_id AS declaring_class_id,   -- ancestor class that declares the property
    ac.lvl AS inheritance_level,           -- 0 = the leaf itself, higher = nearer the root
    jt.property_name,
    jt.property_type,
    jt.direct_column,
    jt.property_target,
    jt.relation_type,
    jt.description,
    jt.join_table, jt.join_from, jt.join_to,
    jt.link_table, jt.link_src_col, jt.src_col, jt.link_tgt_col, jt.tgt_table, jt.tgt_col,
    jt.ord, jt.parent_idx
  FROM ancestor_chain ac
  JOIN objectclass oc ON oc.id = ac.current_id
  CROSS APPLY JSON_TABLE(oc.schema, '$.properties[*]'
    COLUMNS (
      ord             FOR ORDINALITY,
      -- 0-based index of the property this one qualifies (e.g. the codeSpace
      -- of mimeType); it is stored alongside that property
      parent_idx      NUMBER         PATH '$.parent',
      property_name   VARCHAR2(255)  PATH '$.name',
      property_type   VARCHAR2(255)  PATH '$.type',
      direct_column   VARCHAR2(255)  PATH '$.value.column',
      property_target VARCHAR2(255)  PATH '$.target',
      relation_type   VARCHAR2(50)   PATH '$.relationType',
      description     VARCHAR2(4000) PATH '$.description',
      -- c) 1:n join: <join_table>.<join_to> = <own table>.<join_from>
      join_table      VARCHAR2(128)  PATH '$.join.table',
      join_from       VARCHAR2(128)  PATH '$.join.fromColumn',
      join_to         VARCHAR2(128)  PATH '$.join.toColumn',
      -- c) n:m join through a link table (e.g. APPEAR_TO_SURFACE_DATA)
      link_table      VARCHAR2(128)  PATH '$.joinTable.table',
      link_src_col    VARCHAR2(128)  PATH '$.joinTable.sourceJoin.toColumn',
      src_col         VARCHAR2(128)  PATH '$.joinTable.sourceJoin.fromColumn',
      link_tgt_col    VARCHAR2(128)  PATH '$.joinTable.targetJoin.fromColumn',
      tgt_table       VARCHAR2(128)  PATH '$.joinTable.targetJoin.table',
      tgt_col         VARCHAR2(128)  PATH '$.joinTable.targetJoin.toColumn'
    )
  ) jt
  WHERE oc.schema IS NOT NULL
),
-- A property that qualifies another one ("parent") lives where that one does,
-- so it inherits the parent's join when it has none of its own.
raw_props AS (
  SELECT
    b.objectclass_id, b.declaring_class_id, b.inheritance_level,
    b.property_name, b.property_type, b.direct_column, b.property_target,
    b.relation_type, b.description,
    COALESCE(b.join_table, pp.join_table) AS join_table,
    COALESCE(b.join_from, pp.join_from) AS join_from,
    COALESCE(b.join_to, pp.join_to) AS join_to,
    b.link_table, b.link_src_col, b.src_col, b.link_tgt_col, b.tgt_table, b.tgt_col
  FROM raw_props_base b
  LEFT JOIN raw_props_base pp
    ON pp.objectclass_id = b.objectclass_id
    AND pp.declaring_class_id = b.declaring_class_id
    AND pp.ord = b.parent_idx + 1
    AND b.join_table IS NULL
),
-- Extract value-column and join-table mappings from DATATYPE.SCHEMA.
-- This replaces hardcoded type->column mapping with data-driven lookup.
--   Simple types (Code,Integer,...): value.column  (e.g. "val_string")
--   Reference types (FeatureProperty,...): join.fromColumn (e.g. "val_feature_id")
--   Complex types (con:Height,...): neither -> NULL
datatype_map AS (
  SELECT
    JSON_VALUE(schema, '$.identifier') AS type_id,
    JSON_VALUE(schema, '$.value.column') AS value_col,
    JSON_VALUE(schema, '$.join.fromColumn') AS join_col,
    JSON_VALUE(schema, '$.join.table') AS join_tbl
  FROM datatype
  WHERE schema IS NOT NULL
),
-- Extract sub-properties from complex data types. They are stored in one of
-- two ways, told apart by the sub-property's own "join":
--   * join on PARENT_ID (con:Height, core:Occupancy, ...): a CHILD row in
--     PROPERTY that references the parent row via PARENT_ID
--   * no join (core:QualifiedArea, core:ExternalReference, core:Code, ...): a
--     column of the parent property's OWN row, given by the sub-property's
--     value.column or by its type.
datatype_subprops AS (
  SELECT
    JSON_VALUE(dt.schema, '$.identifier') AS parent_type_id,
    jt.sub_name,
    jt.sub_type,
    jt.sub_description,
    jt.sub_column,
    CASE WHEN LOWER(jt.sub_join_to) = 'parent_id' THEN 1 ELSE 0 END AS is_child_row
  FROM datatype dt
  CROSS APPLY JSON_TABLE(dt.schema, '$.properties[*]'
    COLUMNS (
      sub_name        VARCHAR2(255)  PATH '$.name',
      sub_type        VARCHAR2(255)  PATH '$.type',
      sub_description VARCHAR2(4000) PATH '$.description',
      sub_column      VARCHAR2(255)  PATH '$.value.column',
      sub_join_to     VARCHAR2(128)  PATH '$.join.toColumn'
    )
  ) jt
  WHERE dt.schema IS NOT NULL
    AND JSON_EXISTS(dt.schema, '$.properties')
),
-- Pre-compute identifiers to avoid repeated JSON extraction in joins.
oc_identifiers AS (
  SELECT id, JSON_VALUE(schema, '$.identifier') AS identifier
  FROM objectclass
  WHERE schema IS NOT NULL
),
-- Build descendant tree only for objectclasses that are
-- containment targets (not the full tree).
descendant_chain (root_id, descendant_id) AS (
  SELECT oci.id, oci.id
  FROM oc_identifiers oci
  WHERE EXISTS (
    SELECT 1 FROM raw_props rp
    WHERE rp.relation_type = 'contains'
      AND rp.property_target = oci.identifier
  )
  UNION ALL
  SELECT dc.root_id, oc.id
  FROM descendant_chain dc
  JOIN objectclass oc ON oc.superclass_id = dc.descendant_id
)
SELECT DISTINCT
  rp.objectclass_id,
  oc_src.classname,
  oc_src.is_toplevel,
  ns.alias,
  oc_src.ade_id,
  rp.property_name,
  NULL,                             -- parent_property (top-level properties)
  -- Map to storage column (data-driven from DATATYPE.SCHEMA) ---------------
  COALESCE(
    UPPER(rp.direct_column),          -- direct column (own table, or join table)
    UPPER(dm.value_col),              -- simple types: value.column
    UPPER(dm.join_col)                -- reference types: join.fromColumn
  ),
  -- Join table: a property-level join (pattern c) first, else the one of a
  -- reference type (e.g. geometry_data, address, feature) -------------------
  COALESCE(UPPER(rp.join_table), UPPER(rp.tgt_table), UPPER(dm.join_tbl)),
  -- Resolve containment targets to concrete objectclass_ids ----------------
  CASE WHEN rp.relation_type = 'contains'
    THEN tgt_concrete.id ELSE NULL END,
  CASE WHEN rp.relation_type = 'contains'
    THEN tgt_concrete.classname ELSE NULL END,
  rp.relation_type,
  rp.description,
  -- Pre-built SQL query pattern for this property
  CASE
    -- Reached through a property-level join (pattern c): no simple pattern
    WHEN rp.join_table IS NOT NULL OR rp.link_table IS NOT NULL THEN NULL
    -- Direct FEATURE-table column (e.g. VALID_FROM, CREATION_DATE)
    WHEN rp.direct_column IS NOT NULL
         AND LOWER(JSON_VALUE(oc_src.schema, '$.table')) = 'feature' THEN
      'SELECT f.' || LOWER(rp.direct_column)
        || ' FROM feature f'
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    -- Direct column of another table (ADDRESS, APPEARANCE, SURFACE_DATA, ...)
    WHEN rp.direct_column IS NOT NULL THEN
      'SELECT t.' || LOWER(rp.direct_column)
        || ' FROM ' || LOWER(JSON_VALUE(oc_src.schema, '$.table')) || ' t'
        || CASE WHEN LOWER(JSON_VALUE(oc_src.schema, '$.table')) = 'surface_data'
                THEN ' WHERE t.objectclass_id = ' || rp.objectclass_id END
    -- Containment: parent -> child feature via val_feature_id
    WHEN rp.relation_type = 'contains' AND tgt_concrete.id IS NOT NULL THEN
      'SELECT f_child.* FROM feature f'
        || ' JOIN property p ON p.feature_id = f.id'
        || ' AND p.name = ''' || rp.property_name || ''''
        || ' JOIN feature f_child ON f_child.id = p.val_feature_id'
        || ' AND f_child.objectclass_id = ' || tgt_concrete.id
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    -- Reference to join table (geometry_data, address, appearance, etc.)
    WHEN dm.join_col IS NOT NULL AND dm.join_tbl IS NOT NULL THEN
      'SELECT jt.* FROM feature f'
        || ' JOIN property p ON p.feature_id = f.id'
        || ' AND p.name = ''' || rp.property_name || ''''
        || ' JOIN ' || LOWER(dm.join_tbl) || ' jt ON jt.id = p.' || LOWER(dm.join_col)
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    -- Simple EAV value (val_string, val_int, val_double, etc.)
    WHEN dm.value_col IS NOT NULL THEN
      'SELECT p.' || LOWER(dm.value_col)
        || ' FROM feature f'
        || ' JOIN property p ON p.feature_id = f.id'
        || ' AND p.name = ''' || rp.property_name || ''''
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    -- Complex parent type (sub-properties queried individually) -> NULL
    ELSE NULL
  END,
  -- Inheritance provenance: which ancestor class declared this property -------
  rp.declaring_class_id,
  dcoc.classname,
  dcns.alias,
  rp.inheritance_level,
  -- Table the class is stored in (FEATURE for city objects) -------------------
  UPPER(JSON_VALUE(oc_src.schema, '$.table')),
  -- Join condition of a property-level join (pattern c) -----------------------
  CASE
    WHEN rp.join_table IS NOT NULL THEN
      LOWER(rp.join_table || '.' || rp.join_to || ' = '
        || JSON_VALUE(oc_src.schema, '$.table') || '.' || rp.join_from)
    WHEN rp.link_table IS NOT NULL THEN
      LOWER(rp.link_table || '.' || rp.link_src_col || ' = '
        || JSON_VALUE(oc_src.schema, '$.table') || '.' || rp.src_col)
        || ' AND '
        || LOWER(rp.tgt_table || '.' || rp.tgt_col || ' = '
        || rp.link_table || '.' || rp.link_tgt_col)
  END,
  NULL                              -- sub_storage (top-level properties)
FROM raw_props rp
JOIN objectclass oc_src
  ON oc_src.id = rp.objectclass_id
-- Metadata of the declaring (ancestor) class, for inheritance-block rendering
JOIN objectclass dcoc
  ON dcoc.id = rp.declaring_class_id
LEFT JOIN namespace dcns ON dcns.id = dcoc.namespace_id
LEFT JOIN namespace ns ON ns.id = oc_src.namespace_id
-- Look up value column and join table from DATATYPE schema
LEFT JOIN datatype_map dm
  ON dm.type_id = rp.property_type
-- Match the target identifier to an objectclass (containment only)
LEFT JOIN oc_identifiers oci
  ON rp.relation_type = 'contains'
  AND rp.property_target IS NOT NULL
  AND oci.identifier = rp.property_target
-- Walk down to concrete descendants of the target
LEFT JOIN descendant_chain dc
  ON dc.root_id = oci.id
LEFT JOIN objectclass tgt_concrete
  ON tgt_concrete.id = dc.descendant_id
  AND tgt_concrete.is_abstract = 0
  AND rp.relation_type = 'contains'
UNION ALL
-- Sub-properties of complex types. SUB_STORAGE tells where the value is:
--   CHILD_ROW : a child PROPERTY row (two-hop join via PARENT_ID)
--     JOIN property parent ON parent.feature_id = f.id AND parent.name = '<parent_property>'
--     JOIN property child  ON child.parent_id = parent.id AND child.name = '<property_name>'
--     Value in child.<value_column>
--   SAME_ROW  : a column of the parent property's own row (single join)
--     JOIN property parent ON parent.feature_id = f.id AND parent.name = '<parent_property>'
--     Value in parent.<value_column>
--   QUALIFIER : like SAME_ROW, but the parent row also holds a value of its own
--     (codeSpace of a Code, uom of a Measure, lod of a geometry, ...)
SELECT DISTINCT
  rp.objectclass_id,
  oc_src.classname,
  oc_src.is_toplevel,
  ns.alias,
  oc_src.ade_id,
  dsp.sub_name,
  rp.property_name,
  COALESCE(UPPER(dsp.sub_column), UPPER(sub_dm.value_col), UPPER(sub_dm.join_col)),
  UPPER(sub_dm.join_tbl),
  NULL,
  NULL,
  NULL,
  dsp.sub_description,
  -- Pre-built SQL query pattern for this sub-property
  CASE
    -- Stored in the parent property's own row (single join)
    WHEN dsp.is_child_row = 0
         AND COALESCE(dsp.sub_column, sub_dm.value_col, sub_dm.join_col) IS NOT NULL THEN
      'SELECT pp.' || LOWER(COALESCE(dsp.sub_column, sub_dm.value_col, sub_dm.join_col))
        || ' FROM feature f'
        || ' JOIN property pp ON pp.feature_id = f.id'
        || ' AND pp.name = ''' || rp.property_name || ''''
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    -- Child row (two-hop PARENT_ID join) that references a join table
    WHEN sub_dm.join_col IS NOT NULL AND sub_dm.join_tbl IS NOT NULL THEN
      'SELECT jt.* FROM feature f'
        || ' JOIN property pp ON pp.feature_id = f.id'
        || ' AND pp.name = ''' || rp.property_name || ''''
        || ' JOIN property p_child ON p_child.parent_id = pp.id'
        || ' AND p_child.name = ''' || dsp.sub_name || ''''
        || ' JOIN ' || LOWER(sub_dm.join_tbl) || ' jt ON jt.id = p_child.' || LOWER(sub_dm.join_col)
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    -- Sub-property has a direct value column
    WHEN sub_dm.value_col IS NOT NULL THEN
      'SELECT p_child.' || LOWER(sub_dm.value_col)
        || ' FROM feature f'
        || ' JOIN property pp ON pp.feature_id = f.id'
        || ' AND pp.name = ''' || rp.property_name || ''''
        || ' JOIN property p_child ON p_child.parent_id = pp.id'
        || ' AND p_child.name = ''' || dsp.sub_name || ''''
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
    ELSE NULL
  END,
  -- Sub-properties inherit the declaring class of their parent property -------
  rp.declaring_class_id,
  dcoc.classname,
  dcns.alias,
  rp.inheritance_level,
  UPPER(JSON_VALUE(oc_src.schema, '$.table')),
  NULL,                             -- join_condition
  CASE
    WHEN dsp.is_child_row = 1 THEN 'CHILD_ROW'
    WHEN COALESCE(parent_dm.value_col, parent_dm.join_col) IS NOT NULL THEN 'QUALIFIER'
    ELSE 'SAME_ROW'
  END
FROM raw_props rp
JOIN objectclass oc_src ON oc_src.id = rp.objectclass_id
JOIN objectclass dcoc ON dcoc.id = rp.declaring_class_id
LEFT JOIN namespace dcns ON dcns.id = dcoc.namespace_id
LEFT JOIN namespace ns ON ns.id = oc_src.namespace_id
JOIN datatype_subprops dsp ON dsp.parent_type_id = rp.property_type
LEFT JOIN datatype_map parent_dm ON parent_dm.type_id = rp.property_type
LEFT JOIN datatype_map sub_dm ON sub_dm.type_id = dsp.sub_type;

DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM property_catalog;
  DBMS_OUTPUT.PUT_LINE('PROPERTY_CATALOG view created: ' || v_cnt || ' rows resolved.');
END;
/

-- ---------------------------------------------------------------
-- PROPERTY_CATALOG_TEXT: one rendered catalog LINE per (feature type,
-- property), tagged with the class that declares it. This is where the
-- "prop -> storage" text and the containment LISTAGG live (once), so the
-- package only has to group and concatenate. IS_INHERITED = 1 means the
-- property comes from an ancestor class (rendered once as a shared BLOCK);
-- IS_INHERITED = 0 means the feature type declares it itself.
-- ---------------------------------------------------------------
PROMPT Creating PROPERTY_CATALOG_TEXT view ...
CREATE OR REPLACE VIEW property_catalog_text (
  objectclass_id, namespace_alias, feature_type, is_toplevel,
  declaring_class_id, block_name, inheritance_level, is_inherited, line,
  source_table
) AS
SELECT
  pc.objectclass_id,
  NVL(pc.namespace_alias, '?'),
  pc.feature_type,
  pc.is_toplevel,
  pc.declaring_class_id,
  NVL(pc.declaring_namespace_alias, '?') || ':' || pc.declaring_class_name,
  pc.inheritance_level,
  CASE WHEN pc.declaring_class_id = pc.objectclass_id THEN 0 ELSE 1 END,
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
      || CASE WHEN pc.sub_storage = 'SAME_ROW' THEN ' (same row)' END
    WHEN pc.join_condition IS NOT NULL THEN
      pc.property_name || ' -> ' || LOWER(pc.join_table)
      || CASE WHEN pc.value_column IS NOT NULL THEN '.' || LOWER(pc.value_column) END
      || ' ON ' || pc.join_condition
    WHEN pc.join_table IS NOT NULL THEN
      pc.property_name || ' -> ' || LOWER(pc.join_table)
      || ' via property.' || LOWER(pc.value_column)
    WHEN pc.value_column LIKE 'VAL\_%' ESCAPE '\' THEN
      pc.property_name || ' -> property.' || LOWER(pc.value_column)
    WHEN pc.value_column IS NOT NULL THEN
      pc.property_name || ' -> ' || LOWER(pc.source_table) || '.' || LOWER(pc.value_column)
    ELSE
      pc.property_name || ' -> (complex; see sub-properties)'
  END,
  LOWER(pc.source_table)
FROM property_catalog pc
-- Keep every top-level property. Of the sub-properties (parent.child) keep the
-- ones with a resolved storage column, except QUALIFIER ones: codeSpace, uom,
-- lod, ... recur on every Code / Measure / geometry property and are described
-- once by the data-model rules in BUILD_CONTEXT instead.
WHERE pc.parent_property IS NULL
   OR (pc.value_column IS NOT NULL AND pc.sub_storage <> 'QUALIFIER')
GROUP BY
  pc.objectclass_id, pc.namespace_alias, pc.feature_type, pc.is_toplevel,
  pc.declaring_class_id, pc.declaring_namespace_alias, pc.declaring_class_name,
  pc.inheritance_level, pc.parent_property, pc.property_name, pc.relation_type,
  pc.value_column, pc.join_table, pc.source_table, pc.join_condition, pc.sub_storage;

PROMPT PROPERTY_CATALOG views ready.

-- ===============================================================
-- PART 2 – CITYDB_AI package (renders PART 1 into the LLM prompt)
-- ===============================================================
PROMPT Creating CITYDB_AI package specification ...
CREATE OR REPLACE PACKAGE citydb_ai AS

  -- Slim context for INJECTION into native Select AI: EAV data-model rules + the
  -- PROPERTY_CATALOG + the question, but WITHOUT a system role or output-format
  -- instructions (Select AI supplies those and the physical-table DDL from the
  -- profile object_list). See the file header for a call example.
  FUNCTION build_context(p_question IN CLOB) RETURN CLOB;
END citydb_ai;
/

PROMPT Creating CITYDB_AI package body ...
CREATE OR REPLACE PACKAGE BODY citydb_ai AS

  -- ---- internal: append a VARCHAR2 buffer to a CLOB efficiently ------------
  PROCEDURE append_line(p_clob IN OUT NOCOPY CLOB, p_text IN VARCHAR2) IS
  BEGIN
    DBMS_LOB.WRITEAPPEND(p_clob, LENGTH(p_text), p_text);
  END;

  -- ---- render the catalog into one CLOB -----------------------------------
  -- Properties shared by many feature types via CityGML inheritance are emitted
  -- ONCE as named BLOCKS (@namespace:AbstractClass). Each concrete feature type
  -- then lists the blocks it inherits ("[...] : @A @B") plus only the properties
  -- it declares itself. PROPERTY_CATALOG(_TEXT) is small, so this is rendered on
  -- demand per question rather than cached.
  FUNCTION render_catalog RETURN CLOB IS
    v_ctx   CLOB;
    v_prev  NUMBER := -1;
    v_hdr   VARCHAR2(4000);
    v_lf    CONSTANT VARCHAR2(2) := CHR(10);
    -- PROPERTY_CATALOG_TEXT sits on recursive CTEs, so we scan it a FIXED number
    -- of times (block refs, own lines, blocks, type headers) and buffer the
    -- per-type pieces in memory instead of querying once per feature type.
    TYPE str_t IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    v_refs  str_t;   -- objectclass_id -> "@blockA @blockB ..."
    v_own   str_t;   -- objectclass_id -> its own (self-declared) lines, joined
  BEGIN
    DBMS_LOB.CREATETEMPORARY(v_ctx, TRUE);

    append_line(v_ctx,
      '=== 3DCITYDB PROPERTY CATALOG ===' || v_lf ||
      'Per feature type: every property and where its value is stored.' || v_lf ||
      'Shared (inherited) properties are factored into BLOCKS listed first. A' || v_lf ||
      'feature header "[alias:Type id=N] : @A @B" means the type ALSO HAS every' || v_lf ||
      'property under blocks @A and @B -- resolve inherited properties by reading' || v_lf ||
      'those blocks. Lines under a header are the type''s OWN (self-declared) properties.' || v_lf ||
      'Header format: [alias:FeatureType id=<objectclass_id> TOPLEVEL? table=T?] : @blocks.' || v_lf ||
      'A header with "table=T" is NOT a FEATURE row: its rows live in table T, and its id is no' || v_lf ||
      'FEATURE.OBJECTCLASS_ID (of these tables only SURFACE_DATA has an OBJECTCLASS_ID column).' || v_lf ||
      'Use the exact property name (case-sensitive) shown before "->" for PROPERTY.NAME filters.' || v_lf ||
      'Mapping legend:' || v_lf ||
      '  prop -> property.val_x        : JOIN property p ON p.feature_id=f.id AND p.name=''prop''; value in p.val_x' || v_lf ||
      '  prop -> <table>.col           : value is a direct column of <table> (no PROPERTY join): feature.col' || v_lf ||
      '                                  is FEATURE column f.col; other tables belong to "table=T" headers' || v_lf ||
      '  prop -> <table>[.col] ON <cond>: JOIN <table> with the join condition <cond>; value in <table>.col' || v_lf ||
      '  parent.child -> property.val_x: two-hop. JOIN property pp ON pp.feature_id=f.id AND pp.name=''parent''' || v_lf ||
      '                                  JOIN property pc ON pc.parent_id=pp.id AND pc.name=''child''; value in pc.val_x' || v_lf ||
      '  parent.child -> property.val_x (same row): ONE hop, no child row. JOIN property pp ON' || v_lf ||
      '                                  pp.feature_id=f.id AND pp.name=''parent''; value in pp.val_x' || v_lf ||
      '  prop -> <table> via property.val_x_id : JOIN property p (feature_id,name) JOIN <table> t ON t.id=p.val_x_id' || v_lf ||
      '  prop -> contains T1(id1),T2(id2) via VAL_FEATURE_ID : child features. JOIN property p (feature_id,name)' || v_lf ||
      '                                  JOIN feature fc ON fc.id=p.val_feature_id AND fc.objectclass_id IN (id1,id2,...)' || v_lf ||
      '  (complex; see sub-properties) : value lives in the parent.child sub-property lines below.' || v_lf);

    -- Pre-compute, per feature type, the space-separated list of inherited
    -- blocks, ordered root -> leaf (highest inheritance_level first).
    FOR b IN (
      SELECT objectclass_id,
             LISTAGG('@' || block_name, ' ')
               WITHIN GROUP (ORDER BY inheritance_level DESC, block_name) AS refs
      FROM ( SELECT DISTINCT objectclass_id, block_name, inheritance_level
             FROM property_catalog_text
             WHERE is_inherited = 1 )
      GROUP BY objectclass_id
    ) LOOP
      v_refs(b.objectclass_id) := b.refs;
    END LOOP;

    -- Scan 2: buffer each feature type's OWN (self-declared) lines.
    FOR r IN (
      SELECT objectclass_id, line
      FROM property_catalog_text
      WHERE is_inherited = 0
      ORDER BY objectclass_id, line
    ) LOOP
      IF NOT v_own.EXISTS(r.objectclass_id) THEN
        v_own(r.objectclass_id) := '';
      END IF;
      v_own(r.objectclass_id) := v_own(r.objectclass_id) || '  ' || r.line || v_lf;
    END LOOP;

    -- ===================== inherited property blocks =====================
    -- Scan 3: emit each ancestor block once.
    append_line(v_ctx, v_lf || '=== INHERITED PROPERTY BLOCKS ===' || v_lf);
    FOR r IN (
      SELECT DISTINCT t.declaring_class_id, t.block_name, t.line
      FROM property_catalog_text t
      WHERE t.is_inherited = 1
      ORDER BY t.block_name, t.line
    ) LOOP
      IF r.declaring_class_id != v_prev THEN
        append_line(v_ctx, v_lf || '@' || r.block_name || v_lf);
        v_prev := r.declaring_class_id;
      END IF;
      append_line(v_ctx, '  ' || r.line || v_lf);
    END LOOP;

    -- ===================== concrete feature types ========================
    -- Scan 4: type headers (with inherited-block refs) + buffered own lines.
    append_line(v_ctx, v_lf || '=== FEATURE TYPES ===' || v_lf);
    FOR t IN (
      SELECT DISTINCT objectclass_id, namespace_alias, feature_type, is_toplevel, source_table
      FROM property_catalog_text
      ORDER BY is_toplevel DESC, namespace_alias, feature_type, objectclass_id
    ) LOOP
      v_hdr := v_lf || '[' || t.namespace_alias || ':' || t.feature_type
        || ' id=' || t.objectclass_id
        || CASE WHEN t.is_toplevel = 1 THEN ' TOPLEVEL' END
        || CASE WHEN t.source_table <> 'feature' THEN ' table=' || t.source_table END || ']';
      IF v_refs.EXISTS(t.objectclass_id) THEN
        v_hdr := v_hdr || ' : ' || v_refs(t.objectclass_id);
      END IF;
      append_line(v_ctx, v_hdr || v_lf);

      IF v_own.EXISTS(t.objectclass_id) THEN
        append_line(v_ctx, v_own(t.objectclass_id));
      END IF;
    END LOOP;

    -- ===================== reverse containment index =====================
    -- Scan 5: for each contained child type, which property reaches it and which
    -- class declares that property (a @block above, or a [type] header). Supports
    -- TARGET-FIRST path finding. Aggregated by DECLARING class (not concrete
    -- containers) so a property like boundary appears once, not per owning type.
    append_line(v_ctx, v_lf || '=== CONTAINED-BY INDEX ===' || v_lf ||
      'Reverse map: for each child feature type, the property/-ies whose "contains" includes' || v_lf ||
      'it, each tagged [declaring class] (find that class as a @block or a [type] header).' || v_lf ||
      'To reach the child, end your containment path at that property on a feature that has it.' || v_lf ||
      'Top-level types (reachable only as members of the CityModel collection) are omitted --' || v_lf ||
      'query those directly by objectclass_id.' || v_lf);
    FOR r IN (
      SELECT x.tgt, x.tgt_id,
             LISTAGG(x.via, ', ' ON OVERFLOW TRUNCATE)
               WITHIN GROUP (ORDER BY x.via) AS vias
      FROM (
        SELECT DISTINCT
          pc.target_feature_type || '(' || pc.target_objectclass_id || ')' AS tgt,
          pc.target_objectclass_id AS tgt_id,
          pc.property_name || ' [' || NVL(pc.declaring_namespace_alias, '?')
            || ':' || pc.declaring_class_name || ']' AS via
        FROM property_catalog pc
        WHERE pc.relation_type = 'contains'
          AND pc.target_objectclass_id IS NOT NULL
          -- Exclude the CityModel document-root collection (featureMember /
          -- cityObjectMember / ...): it "contains" almost every type, so here it is
          -- pure noise and is never the parent for a "belongs to X" query. Those
          -- membership properties stay listed under the [core:CityModel] header.
          AND NVL(pc.declaring_class_name, '?') <> 'CityModel'
      ) x
      GROUP BY x.tgt, x.tgt_id
      ORDER BY x.tgt
    ) LOOP
      append_line(v_ctx, '  ' || r.tgt || ' <- ' || r.vias || v_lf);
    END LOOP;

    RETURN v_ctx;
  END render_catalog;

  -- ---- public: slim context (EAV rules + catalog + question; rationale in spec)
  FUNCTION build_context(p_question IN CLOB) RETURN CLOB IS
    v_ctx CLOB;
    v_cat CLOB;
    v_lf  CONSTANT VARCHAR2(2) := CHR(10);
    v_ns  VARCHAR2(4000);   -- 'alias=id ...' of every namespace, ADEs included
    v_sd  VARCHAR2(4000);   -- 'classname=id, ...' of the SURFACE_DATA kinds
    v_log NUMBER;           -- > 0 when the FEATURE_CHANGELOG table exists
  BEGIN
    IF p_question IS NULL OR DBMS_LOB.GETLENGTH(p_question) = 0 THEN
      RAISE_APPLICATION_ERROR(-20800, 'Question must not be empty.');
    END IF;

    SELECT LISTAGG(alias || '=' || id, ' ') WITHIN GROUP (ORDER BY id)
      INTO v_ns FROM namespace WHERE alias IS NOT NULL;

    SELECT LISTAGG(classname || '=' || id, ', ') WITHIN GROUP (ORDER BY id)
      INTO v_sd FROM objectclass
     WHERE classname IN ('X3DMaterial', 'ParameterizedTexture', 'GeoreferencedTexture');

    SELECT COUNT(*) INTO v_log FROM user_tables WHERE table_name = 'FEATURE_CHANGELOG';

    DBMS_LOB.CREATETEMPORARY(v_ctx, TRUE);

    append_line(v_ctx,
      'DATA MODEL (Entity-Attribute-Value):' || v_lf ||
      '- FEATURE: one row per city object. Its type is FEATURE.OBJECTCLASS_ID (an integer).' || v_lf ||
      '  NEVER join the OBJECTCLASS table; filter f.objectclass_id by the literal id from the catalog header.' || v_lf ||
      '- A feature whose TERMINATION_DATE is set is historic. Questions are about current features' || v_lf ||
      '  unless they ask for terminated or historic ones, so the feature the question counts or lists' || v_lf ||
      '  gets f.termination_date IS NULL; joined child features need no such filter.' || v_lf ||
      '- PROPERTY: attributes of a feature (EAV). Join via PROPERTY.FEATURE_ID = FEATURE.ID and' || v_lf ||
      '  filter PROPERTY.NAME = ''<exact property name>''. The value sits in a type-specific column' || v_lf ||
      '  (val_string, val_int, val_double, val_timestamp, val_uri, val_feature_id, val_geometry_id, ...).' || v_lf ||
      '  Code value: val_string (+ val_codespace). Measure value: val_double (+ val_uom). Boolean: val_int (0/1).' || v_lf ||
      '  When the question writes a property with a namespace prefix (bldg:function), the prefix also' || v_lf ||
      '  fixes PROPERTY.NAMESPACE_ID: ' || v_ns || v_lf ||
      '- Nested/complex properties are the catalog "parent.child" lines: the child is a PROPERTY row of' || v_lf ||
      '  its own, linked by PROPERTY.PARENT_ID (two-hop join) -- unless the line is marked (same row),' || v_lf ||
      '  where it is a column of the parent property''s own row.' || v_lf ||
      '- MULTI-VALUED PROPERTIES: a feature can have several PROPERTY rows with the same NAME, so a' || v_lf ||
      '  property p stands for the SET of its values (for a nested path: the values reached through' || v_lf ||
      '  the whole join chain). Predicates on p use SQL three-valued logic over this set:' || v_lf ||
      '  * a comparison (such as =, <>, <, IN, LIKE, BETWEEN) is TRUE if some value satisfies it;' || v_lf ||
      '    else NULL if the set is empty or contains NULL; else FALSE.' || v_lf ||
      '  * p IS NULL is TRUE if the set has no non-NULL value, else FALSE; IS NOT NULL inverts it.' || v_lf ||
      '  * NOT, AND, OR combine these as in SQL; a feature is selected only when the filter is TRUE.' || v_lf ||
      '  In SQL, give each predicate its own correlated subquery over the value rows of p.' || v_lf ||
      '- Containment: a parent owns child features via a PROPERTY whose VAL_FEATURE_ID is the' || v_lf ||
      '  child FEATURE.ID. Traverse it TARGET-FIRST by these rules:' || v_lf ||
      '  (1) Identify the wanted feature type T. From the CONTAINED-BY INDEX (end of catalog)' || v_lf ||
      '      read EVERY property whose "contains" list includes T''s id; your path MUST end at' || v_lf ||
      '      one of those properties, on a feature that has it.' || v_lf ||
      '  (2) At each hop use ONLY a property whose "contains" list includes the next type''s id,' || v_lf ||
      '      and filter the joined feature by that exact objectclass_id (match NAME + id).' || v_lf ||
      '  (3) If the terminating property sits on an intermediate type, hop down to it first:' || v_lf ||
      '      follow a property whose "contains" lists that intermediate type, join, then repeat' || v_lf ||
      '      -- one property+feature join per hop -- until you reach the property that lists T.' || v_lf ||
      '  (4) Never filter a containment join by an objectclass_id absent from that property''s' || v_lf ||
      '      "contains" list, and never choose the terminating property by NAME resemblance to' || v_lf ||
      '      T -- the "contains" list is the only authority; a wrong path returns nothing.' || v_lf ||
      '  (5) For "all T within / belonging to / inside a <container>" where T may be nested at' || v_lf ||
      '      ANY depth, a fixed join chain UNDER-counts (it misses T nested inside intermediate' || v_lf ||
      '      sub-containers). Instead RECURSE the containment tree from the' || v_lf ||
      '      container down, following ONLY containment edges (PROPERTY.VAL_RELATION_TYPE = 1;' || v_lf ||
      '      VAL_RELATION_TYPE = 0 is a non-owning cross-reference),' || v_lf ||
      '      then filter by T''s objectclass_id:' || v_lf ||
      '        WITH sub(id) AS (' || v_lf ||
      '          SELECT f.id FROM feature f WHERE <container filter>' || v_lf ||
      '          UNION ALL' || v_lf ||
      '          SELECT p.val_feature_id FROM sub s JOIN property p ON p.feature_id = s.id' || v_lf ||
      '            AND p.val_relation_type = 1 AND p.val_feature_id IS NOT NULL)' || v_lf ||
      '        SELECT COUNT(DISTINCT ft.id) FROM feature ft JOIN sub ON sub.id = ft.id WHERE ft.objectclass_id = <T id>;' || v_lf ||
      '      Containment is a DAG, not a strict tree: a feature can be reached by MORE THAN ONE' || v_lf ||
      '      path, and the recursion''s UNION ALL keeps every path. ALWAYS de-duplicate by' || v_lf ||
      '      feature id -- COUNT(DISTINCT ft.id), or SELECT DISTINCT when listing.' || v_lf ||
      '      Rules (1)-(4) still apply when you want a SPECIFIC/direct relationship rather than' || v_lf ||
      '      the whole subtree.' || v_lf ||
      '- GEOMETRY_DATA.GEOMETRY holds SDO_GEOMETRY; reach it via a property''s val_geometry_id.' || v_lf ||
      '- ADDRESS is reached via a property''s val_address_id (addresses are NOT in FEATURE).' || v_lf);

    -- Semantics of the remaining object_list tables. The tables carry no
    -- comments or annotations, so this text is all the LLM learns about them.
    append_line(v_ctx,
      '- VAL_ARRAY holds a JSON array (array-type properties); extract elements with JSON_TABLE or' || v_lf ||
      '  JSON_VALUE. VAL_LOD is the level of detail of a geometry property.' || v_lf ||
      '- IMPLICIT_GEOMETRY: reusable template geometry, reached via a property''s val_implicitgeom_id;' || v_lf ||
      '  the same property row holds its placement: VAL_ARRAY (transformation matrix) and' || v_lf ||
      '  VAL_IMPLICITGEOM_REFPOINT (reference point).' || v_lf ||
      '  Its shape is the GEOMETRY_DATA row IMPLICIT_GEOMETRY.RELATIVE_GEOMETRY_ID, stored in the column' || v_lf ||
      '  GEOMETRY_DATA.IMPLICIT_GEOMETRY (local coordinates; GEOMETRY_DATA.FEATURE_ID is NULL for it).' || v_lf ||
      '- APPEARANCE (not in FEATURE): belongs to a feature via APPEARANCE.FEATURE_ID or to a template' || v_lf ||
      '  via APPEARANCE.IMPLICIT_GEOMETRY_ID; IS_GLOBAL = 1 means it belongs to neither. Its textures and' || v_lf ||
      '  materials are SURFACE_DATA rows, linked n:m through APPEAR_TO_SURFACE_DATA (appearance_id,' || v_lf ||
      '  surface_data_id). SURFACE_DATA.OBJECTCLASS_ID gives the kind: ' || v_sd || '.' || v_lf ||
      '  SURFACE_DATA_MAPPING (surface_data_id, geometry_data_id) links surface data to its target' || v_lf ||
      '  geometries; texture images are in TEX_IMAGE via SURFACE_DATA.TEX_IMAGE_ID.' || v_lf ||
      '- CODELIST (codelist_type, url) registers codelists; CODELIST_ENTRY (codelist_id, code,' || v_lf ||
      '  definition) holds their values.' || v_lf ||
      '- DATABASE_SRS: SRID and SRS_NAME of the coordinate reference system of all stored geometries.' || v_lf);

    -- FEATURE_CHANGELOG exists only when the changelog extension is enabled.
    IF v_log > 0 THEN
      append_line(v_ctx,
        '- FEATURE_CHANGELOG: audit log, one row per change of a top-level feature. TRANSACTION_TYPE is' || v_lf ||
        '  ''INSERT'', ''UPDATE'', ''TERMINATE'' or ''DELETE''; TRANSACTION_DATE is when it happened;' || v_lf ||
        '  OBJECTCLASS_ID uses the same ids as FEATURE. Once a feature is deleted, FEATURE_ID is NULL in' || v_lf ||
        '  ALL of its rows -- trace a feature''s history by OBJECTID, not FEATURE_ID.' || v_lf);
    END IF;

    append_line(v_ctx, v_lf ||
      'CATALOG RULES:' || v_lf ||
      '- Use ONLY the feature types, property names and storage columns from the CATALOG below.' || v_lf ||
      '- Property names are case-sensitive; copy them verbatim.' || v_lf ||
      '- Prefer table aliases f (feature), p / pp / pc (property), gd (geometry_data).' || v_lf || v_lf);

    -- render_catalog returns a session-duration temporary LOB; capture it so we
    -- can release it after appending (an inline call would leak it every question).
    v_cat := render_catalog;
    DBMS_LOB.APPEND(v_ctx, v_cat);
    IF DBMS_LOB.ISTEMPORARY(v_cat) = 1 THEN
      DBMS_LOB.FREETEMPORARY(v_cat);
    END IF;

    append_line(v_ctx, v_lf || v_lf || '=== USER QUESTION ===' || v_lf);
    DBMS_LOB.APPEND(v_ctx, p_question);

    RETURN v_ctx;
  END build_context;

END citydb_ai;
/

PROMPT CITYDB_AI NL2SQL layer setup complete.
