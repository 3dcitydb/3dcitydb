-- select-ai-property-catalog.sql
-- Sets up Oracle Select AI context for the 3DCityDB schema:
--   1. Creates the PROPERTY_CATALOG view
--      (flattened property catalog with inheritance resolved)
--   2. Adds semantic annotations on all core tables and columns
--
-- Run as the application user (e.g. CITYDB) in the target PDB
-- AFTER schema.sql, objectclass-instances.sql and datatype-instances.sql.

SET FEEDBACK ON
SET SERVEROUTPUT ON

-- ===============================================================
-- PART 1 – PROPERTY_CATALOG view
-- ===============================================================

-- ---------------------------------------------------------------
-- 1.1 Drop legacy table (if upgrading) and create view
-- ---------------------------------------------------------------
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
  relation_type, description, query_pattern
) AS
WITH
-- Walk UP from each concrete class to collect all ancestor IDs.
ancestor_chain (leaf_id, current_id) AS (
  SELECT id, id
  FROM objectclass
  WHERE is_abstract = 0
  UNION ALL
  SELECT ac.leaf_id, oc.superclass_id
  FROM ancestor_chain ac
  JOIN objectclass oc ON oc.id = ac.current_id
  WHERE oc.superclass_id IS NOT NULL
),
-- Extract properties from each ancestor's SCHEMA JSON.
-- Handles two patterns:
--   a) type-based  (type: "core:Code")         -> stored in PROPERTY table
--   b) direct-col  (value.column: "valid_from") -> stored in FEATURE table
raw_props AS (
  SELECT
    ac.leaf_id AS objectclass_id,
    jt.property_name,
    jt.property_type,
    jt.direct_column,
    jt.property_target,
    jt.relation_type,
    jt.description
  FROM ancestor_chain ac
  JOIN objectclass oc ON oc.id = ac.current_id
  CROSS APPLY JSON_TABLE(oc.schema, '$.properties[*]'
    COLUMNS (
      property_name   VARCHAR2(255)  PATH '$.name',
      property_type   VARCHAR2(255)  PATH '$.type',
      direct_column   VARCHAR2(255)  PATH '$.value.column',
      property_target VARCHAR2(255)  PATH '$.target',
      relation_type   VARCHAR2(50)   PATH '$.relationType',
      description     VARCHAR2(4000) PATH '$.description'
    )
  ) jt
  WHERE oc.schema IS NOT NULL
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
-- Extract sub-properties from complex data types (con:Height,
-- core:Occupancy, etc.) whose sub-attributes are stored as child
-- rows in PROPERTY joined via PARENT_ID.
datatype_subprops AS (
  SELECT
    JSON_VALUE(dt.schema, '$.identifier') AS parent_type_id,
    jt.sub_name,
    jt.sub_type,
    jt.sub_description
  FROM datatype dt
  CROSS APPLY JSON_TABLE(dt.schema, '$.properties[*]'
    COLUMNS (
      sub_name        VARCHAR2(255)  PATH '$.name',
      sub_type        VARCHAR2(255)  PATH '$.type',
      sub_description VARCHAR2(4000) PATH '$.description'
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
    UPPER(rp.direct_column),          -- direct FEATURE-table column
    UPPER(dm.value_col),              -- simple types: value.column
    UPPER(dm.join_col)                -- reference types: join.fromColumn
  ),
  -- Join table for reference types (e.g. geometry_data, address, feature) --
  UPPER(dm.join_tbl),
  -- Resolve containment targets to concrete objectclass_ids ----------------
  CASE WHEN rp.relation_type = 'contains'
    THEN tgt_concrete.id ELSE NULL END,
  CASE WHEN rp.relation_type = 'contains'
    THEN tgt_concrete.classname ELSE NULL END,
  rp.relation_type,
  rp.description,
  -- Pre-built SQL query pattern for this property
  CASE
    -- Direct FEATURE-table column (e.g. VALID_FROM, CREATION_DATE)
    WHEN rp.direct_column IS NOT NULL THEN
      'SELECT f.' || LOWER(rp.direct_column)
        || ' FROM feature f'
        || ' WHERE f.objectclass_id = ' || rp.objectclass_id
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
  END
FROM raw_props rp
JOIN objectclass oc_src
  ON oc_src.id = rp.objectclass_id
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
-- Sub-properties of complex types (accessed via PROPERTY.PARENT_ID join).
-- Query pattern for sub-properties:
--   JOIN property parent ON parent.feature_id = f.id AND parent.name = '<parent_property>'
--   JOIN property child  ON child.parent_id = parent.id AND child.name = '<property_name>'
--   Value in child.<value_column>
SELECT DISTINCT
  rp.objectclass_id,
  oc_src.classname,
  oc_src.is_toplevel,
  ns.alias,
  oc_src.ade_id,
  dsp.sub_name,
  rp.property_name,
  COALESCE(UPPER(sub_dm.value_col), UPPER(sub_dm.join_col)),
  UPPER(sub_dm.join_tbl),
  NULL,
  NULL,
  NULL,
  dsp.sub_description,
  -- Pre-built SQL query pattern for this sub-property (two-hop PARENT_ID join)
  CASE
    -- Sub-property references a join table
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
  END
FROM raw_props rp
JOIN objectclass oc_src ON oc_src.id = rp.objectclass_id
LEFT JOIN namespace ns ON ns.id = oc_src.namespace_id
JOIN datatype_subprops dsp ON dsp.parent_type_id = rp.property_type
LEFT JOIN datatype_map sub_dm ON sub_dm.type_id = dsp.sub_type;

DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM property_catalog;
  DBMS_OUTPUT.PUT_LINE('PROPERTY_CATALOG view created: ' || v_cnt || ' rows resolved.');
END;
/

-- ===============================================================
-- PART 2 – Schema annotations for Select AI context
-- ===============================================================

-- Drop all existing annotations to make this script idempotent.
PROMPT Dropping existing annotations ...
DECLARE
  PROCEDURE drop_annotations(p_object VARCHAR2) IS
    v_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('MODULE', 'DESCRIPTION', 'LONG_FORM');
    v_kind  VARCHAR2(5);
  BEGIN
    BEGIN
      SELECT CASE WHEN object_type = 'VIEW' THEN 'VIEW' ELSE 'TABLE' END
        INTO v_kind FROM user_objects
       WHERE object_name = p_object AND ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
    END;
    FOR i IN 1..v_names.COUNT LOOP
      BEGIN
        EXECUTE IMMEDIATE
          'ALTER ' || v_kind || ' "' || p_object || '" ANNOTATIONS (DROP "' || v_names(i) || '")';
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
    END LOOP;
    FOR c IN (
      SELECT column_name FROM user_tab_columns WHERE table_name = p_object
    ) LOOP
      FOR i IN 1..v_names.COUNT LOOP
        BEGIN
          EXECUTE IMMEDIATE
            'ALTER ' || v_kind || ' "' || p_object || '" MODIFY ("' || c.column_name
            || '" ANNOTATIONS (DROP "' || v_names(i) || '"))';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
      END LOOP;
    END LOOP;
  END;
BEGIN
  -- Only drop annotations on tables managed by THIS script.
  -- ADE extension scripts should manage their own annotations separately.
  FOR t IN (
    SELECT column_value AS table_name
    FROM TABLE(SYS.ODCIVARCHAR2LIST(
      'ADDRESS', 'FEATURE', 'PROPERTY', 'GEOMETRY_DATA',
      'IMPLICIT_GEOMETRY', 'TEX_IMAGE', 'APPEARANCE',
      'SURFACE_DATA', 'SURFACE_DATA_MAPPING',
      'APPEAR_TO_SURFACE_DATA', 'CODELIST', 'CODELIST_ENTRY',
      'ADE', 'DATABASE_SRS', 'NAMESPACE', 'OBJECTCLASS',
      'DATATYPE', 'PROPERTY_CATALOG'
    ))
  ) LOOP
    drop_annotations(t.table_name);
  END LOOP;
END;
/

PROMPT Adding annotations ...

-- =================================================================
-- ADDRESS
-- =================================================================
ALTER TABLE address ANNOTATIONS (
  ADD
    MODULE 'Feature',
    DESCRIPTION 'Although ADDRESS is a feature type in CityGML, it is not stored in the FEATURE table. Instead, it is mapped to a dedicated ADDRESS table. Storing addresses separately enables efficient indexing and querying. Features reference addresses via PROPERTY.VAL_ADDRESS_ID.'
);
ALTER TABLE address MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE address MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'Unique string identifier for the address object.'));
ALTER TABLE address MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'Optional cross-system identifier.'));
ALTER TABLE address MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'Authority responsible for maintaining the identifier.'));
ALTER TABLE address MODIFY (street ANNOTATIONS (ADD DESCRIPTION 'Street or road name.'));
ALTER TABLE address MODIFY (house_number ANNOTATIONS (ADD DESCRIPTION 'Building or house number.'));
ALTER TABLE address MODIFY (po_box ANNOTATIONS (ADD DESCRIPTION 'Post office box number.'));
ALTER TABLE address MODIFY (zip_code ANNOTATIONS (ADD DESCRIPTION 'Postal or ZIP code.'));
ALTER TABLE address MODIFY (city ANNOTATIONS (ADD DESCRIPTION 'City or locality name.'));
ALTER TABLE address MODIFY (state ANNOTATIONS (ADD DESCRIPTION 'State, province, or region.'));
ALTER TABLE address MODIFY (country ANNOTATIONS (ADD DESCRIPTION 'Country name.'));
ALTER TABLE address MODIFY (free_text ANNOTATIONS (ADD DESCRIPTION 'Unstructured text address.'));
ALTER TABLE address MODIFY (multi_point ANNOTATIONS (ADD DESCRIPTION 'Geolocation as multi-point geometry.'));
ALTER TABLE address MODIFY (content ANNOTATIONS (ADD DESCRIPTION 'Original address data preserved as a character blob.'));
ALTER TABLE address MODIFY (content_mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type of the CONTENT column.'));

-- =================================================================
-- FEATURE
-- =================================================================
ALTER TABLE feature ANNOTATIONS (
  ADD
    MODULE 'Feature',
    DESCRIPTION 'Central table storing all city objects (EAV pattern). Type determined by OBJECTCLASS_ID (see table comment for type-to-ID mappings like Building=901). Properties in PROPERTY table via FEATURE_ID. Query: SELECT p.<value_column> FROM feature f JOIN property p ON p.feature_id=f.id AND p.name=''<name>'' WHERE f.objectclass_id=<id>. Always check PROPERTY_CATALOG for value_column and parent_property before querying. Containment hierarchy via PROPERTY.VAL_FEATURE_ID.'
);
ALTER TABLE feature MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE feature MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'Determines the feature type. Do NOT join OBJECTCLASS table. Use objectclass_id directly from table comment mappings (e.g. Building=901).'));
ALTER TABLE feature MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'String identifier to uniquely reference a feature within the database.'));
ALTER TABLE feature MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'Optional cross-system identifier.'));
ALTER TABLE feature MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'Authority responsible for maintaining the identifier.'));
ALTER TABLE feature MODIFY (envelope ANNOTATIONS (ADD DESCRIPTION 'Spatial envelope (minimal 3D bounding box) for efficient spatial queries.'));
ALTER TABLE feature MODIFY (last_modification_date ANNOTATIONS (ADD DESCRIPTION 'Timestamp of the last modification (3DCityDB-specific).'));
ALTER TABLE feature MODIFY (updating_person ANNOTATIONS (ADD DESCRIPTION 'Person responsible for a change (3DCityDB-specific).'));
ALTER TABLE feature MODIFY (reason_for_update ANNOTATIONS (ADD DESCRIPTION 'Reason for a change (3DCityDB-specific).'));
ALTER TABLE feature MODIFY (lineage ANNOTATIONS (ADD DESCRIPTION 'Origin of the feature (3DCityDB-specific).'));
ALTER TABLE feature MODIFY (creation_date ANNOTATIONS (ADD DESCRIPTION 'Database time when the feature was inserted.'));
ALTER TABLE feature MODIFY (termination_date ANNOTATIONS (ADD DESCRIPTION 'Database time when the feature was terminated.'));
ALTER TABLE feature MODIFY (valid_from ANNOTATIONS (ADD DESCRIPTION 'Real-world start of the feature lifespan.'));
ALTER TABLE feature MODIFY (valid_to ANNOTATIONS (ADD DESCRIPTION 'Real-world end of the feature lifespan.'));

-- =================================================================
-- PROPERTY
-- =================================================================
ALTER TABLE property ANNOTATIONS (
  ADD
    MODULE 'Feature',
    DESCRIPTION 'Stores feature properties (EAV). Each row is one property joined via FEATURE_ID. NAME holds the property name, value in a type-specific VAL_* column (check PROPERTY_CATALOG.value_column). CRITICAL: If PROPERTY_CATALOG.parent_property IS NOT NULL, you MUST use two-hop join: property p_parent (name=parent_property) then property p_child (parent_id=p_parent.id, name=property_name). See table comment for WRONG/CORRECT examples.'
);
ALTER TABLE property MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE property MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to FEATURE. Links this property to its owning feature.'));
ALTER TABLE property MODIFY (parent_id ANNOTATIONS (ADD DESCRIPTION 'For nested/complex properties: references the parent property row. Used by complex types like con:Height whose sub-attributes (value, status, lowReference, highReference) are stored as child property rows.'));
ALTER TABLE property MODIFY (datatype_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to DATATYPE. Defines the data type of this property.'));
ALTER TABLE property MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to NAMESPACE.'));
ALTER TABLE property MODIFY (name ANNOTATIONS (ADD DESCRIPTION 'Property name. Use PROPERTY_CATALOG to look up which feature types have which property names and which VAL_* column stores the value.'));
ALTER TABLE property MODIFY (val_int ANNOTATIONS (ADD DESCRIPTION 'Integer value (also used for booleans: 0=false, 1=true).'));
ALTER TABLE property MODIFY (val_double ANNOTATIONS (ADD DESCRIPTION 'Double value (measurements, amounts).'));
ALTER TABLE property MODIFY (val_string ANNOTATIONS (ADD DESCRIPTION 'String value (text, codes, type names).'));
ALTER TABLE property MODIFY (val_timestamp ANNOTATIONS (ADD DESCRIPTION 'Timestamp value.'));
ALTER TABLE property MODIFY (val_uri ANNOTATIONS (ADD DESCRIPTION 'URI value.', LONG_FORM 'URI = Uniform Resource Identifier'));
ALTER TABLE property MODIFY (val_codespace ANNOTATIONS (ADD DESCRIPTION 'Code space for Code-type properties (accompanies VAL_STRING).'));
ALTER TABLE property MODIFY (val_uom ANNOTATIONS (ADD DESCRIPTION 'Unit of measurement for Measure-type properties (accompanies VAL_DOUBLE).', LONG_FORM 'UoM = Unit of Measure'));
ALTER TABLE property MODIFY (val_array ANNOTATIONS (ADD DESCRIPTION 'JSON array value for array-type properties.'));
ALTER TABLE property MODIFY (val_lod ANNOTATIONS (ADD DESCRIPTION 'Level of Detail for geometry properties.', LONG_FORM 'Level of Detail'));
ALTER TABLE property MODIFY (val_geometry_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to GEOMETRY_DATA. Links to explicit geometries.'));
ALTER TABLE property MODIFY (val_implicitgeom_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to IMPLICIT_GEOMETRY. Links to template geometries.'));
ALTER TABLE property MODIFY (val_implicitgeom_refpoint ANNOTATIONS (ADD DESCRIPTION 'Reference point for implicit geometry placement.'));
ALTER TABLE property MODIFY (val_appearance_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to APPEARANCE.'));
ALTER TABLE property MODIFY (val_address_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to ADDRESS.'));
ALTER TABLE property MODIFY (val_feature_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to FEATURE. Creates parent-child containment hierarchy. To find valid child types for a parent, query: SELECT target_objectclass_id, target_feature_type FROM property_catalog WHERE objectclass_id = <parent_objectclass_id> AND value_column = ''VAL_FEATURE_ID'' AND relation_type = ''contains''. Each containment hop: parent FEATURE -> PROPERTY (feature_id) -> child FEATURE (val_feature_id).'));
ALTER TABLE property MODIFY (val_relation_type ANNOTATIONS (ADD DESCRIPTION 'Type of the feature relationship (integer).'));
ALTER TABLE property MODIFY (val_content ANNOTATIONS (ADD DESCRIPTION 'Arbitrary content as character lob.'));
ALTER TABLE property MODIFY (val_content_mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type of VAL_CONTENT.'));

-- =================================================================
-- GEOMETRY_DATA
-- =================================================================
ALTER TABLE geometry_data ANNOTATIONS (
  ADD
    MODULE 'Geometry',
    DESCRIPTION 'Stores all explicit and implicit geometries. Linked from PROPERTY via VAL_GEOMETRY_ID. Each geometry belongs to a feature via FEATURE_ID. Example: SELECT gd.geometry FROM feature f JOIN property p ON p.feature_id = f.id JOIN geometry_data gd ON gd.id = p.val_geometry_id WHERE f.objectclass_id = 901 AND p.name = ''lod2Solid''.'
);
ALTER TABLE geometry_data MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE geometry_data MODIFY (geometry ANNOTATIONS (ADD DESCRIPTION 'Explicit feature geometry with real-world 3D coordinates (SDO_GEOMETRY). Spatially indexed.', LONG_FORM 'CRS = Coordinate Reference System'));
ALTER TABLE geometry_data MODIFY (implicit_geometry ANNOTATIONS (ADD DESCRIPTION 'Template geometry using local coordinates. Reusable by multiple features. Not spatially indexed by default.'));
ALTER TABLE geometry_data MODIFY (geometry_properties ANNOTATIONS (ADD DESCRIPTION 'JSON metadata about the geometry type and structure.'));
ALTER TABLE geometry_data MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to FEATURE. NULL for implicit geometries.'));

-- =================================================================
-- IMPLICIT_GEOMETRY
-- =================================================================
ALTER TABLE implicit_geometry ANNOTATIONS (
  ADD
    MODULE 'Geometry',
    DESCRIPTION 'Template geometries that can be reused by multiple city objects (e.g. 3D tree models).'
);
ALTER TABLE implicit_geometry MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE implicit_geometry MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'Unique identifier.'));
ALTER TABLE implicit_geometry MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type of the binary 3D model or external file.'));
ALTER TABLE implicit_geometry MODIFY (mime_type_codespace ANNOTATIONS (ADD DESCRIPTION 'Optional code space for the MIME type.'));
ALTER TABLE implicit_geometry MODIFY (reference_to_library ANNOTATIONS (ADD DESCRIPTION 'URI reference to an external 3D model file.'));
ALTER TABLE implicit_geometry MODIFY (library_object ANNOTATIONS (ADD DESCRIPTION 'Binary blob of the 3D model.'));
ALTER TABLE implicit_geometry MODIFY (relative_geometry_id ANNOTATIONS (ADD DESCRIPTION 'Reference to geometry stored with local coordinates.'));

-- =================================================================
-- TEX_IMAGE
-- =================================================================
ALTER TABLE tex_image ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'Stores texture images for ParameterizedTexture and GeoreferencedTexture.'
);
ALTER TABLE tex_image MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE tex_image MODIFY (image_uri ANNOTATIONS (ADD DESCRIPTION 'File name or original path of the texture image.'));
ALTER TABLE tex_image MODIFY (image_data ANNOTATIONS (ADD DESCRIPTION 'Texture image as binary blob. NULL if stored externally.'));
ALTER TABLE tex_image MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type of the texture image (e.g. image/png, image/jpeg).'));
ALTER TABLE tex_image MODIFY (mime_type_codespace ANNOTATIONS (ADD DESCRIPTION 'Optional code space for the MIME type.'));

-- =================================================================
-- APPEARANCE
-- =================================================================
ALTER TABLE appearance ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'Central appearance table. Appearances define visual properties of surfaces and are not stored in the FEATURE table. Linked to features via FEATURE_ID or to implicit geometries via IMPLICIT_GEOMETRY_ID.'
);
ALTER TABLE appearance MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE appearance MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'Unique string identifier.'));
ALTER TABLE appearance MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'Optional cross-system identifier.'));
ALTER TABLE appearance MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'Authority for the identifier.'));
ALTER TABLE appearance MODIFY (theme ANNOTATIONS (ADD DESCRIPTION 'Theme name for the surface data.'));
ALTER TABLE appearance MODIFY (is_global ANNOTATIONS (ADD DESCRIPTION '1 = global appearance (FEATURE_ID and IMPLICIT_GEOMETRY_ID are NULL).'));
ALTER TABLE appearance MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'Back-link to FEATURE.'));
ALTER TABLE appearance MODIFY (implicit_geometry_id ANNOTATIONS (ADD DESCRIPTION 'Link to IMPLICIT_GEOMETRY for template appearances.'));

-- =================================================================
-- SURFACE_DATA
-- =================================================================
ALTER TABLE surface_data ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'Stores textures and materials. Linked to appearances via APPEAR_TO_SURFACE_DATA (n:m). Linked to target geometries via SURFACE_DATA_MAPPING.'
);
ALTER TABLE surface_data MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE surface_data MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'Unique string identifier.'));
ALTER TABLE surface_data MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'Optional cross-system identifier.'));
ALTER TABLE surface_data MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'Authority for the identifier.'));
ALTER TABLE surface_data MODIFY (is_front ANNOTATIONS (ADD DESCRIPTION '1 = front face, 0 = back face.'));
ALTER TABLE surface_data MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'Type of surface data (foreign key to OBJECTCLASS): X3DMaterial=1102, ParameterizedTexture=1104, GeoreferencedTexture=1105.'));
ALTER TABLE surface_data MODIFY (x3d_shininess ANNOTATIONS (ADD DESCRIPTION 'Specular highlight sharpness (0..1).'));
ALTER TABLE surface_data MODIFY (x3d_transparency ANNOTATIONS (ADD DESCRIPTION 'Transparency (0.0=opaque, 1.0=fully transparent).'));
ALTER TABLE surface_data MODIFY (x3d_ambient_intensity ANNOTATIONS (ADD DESCRIPTION 'Minimum diffuse color visibility (0..1).'));
ALTER TABLE surface_data MODIFY (x3d_specular_color ANNOTATIONS (ADD DESCRIPTION 'Specular reflection color (#RRGGBB).'));
ALTER TABLE surface_data MODIFY (x3d_diffuse_color ANNOTATIONS (ADD DESCRIPTION 'Diffuse reflection color (#RRGGBB).'));
ALTER TABLE surface_data MODIFY (x3d_emissive_color ANNOTATIONS (ADD DESCRIPTION 'Self-illumination color (#RRGGBB).'));
ALTER TABLE surface_data MODIFY (x3d_is_smooth ANNOTATIONS (ADD DESCRIPTION '1 = smooth, 0 = faceted.'));
ALTER TABLE surface_data MODIFY (tex_image_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to TEX_IMAGE.'));
ALTER TABLE surface_data MODIFY (tex_texture_type ANNOTATIONS (ADD DESCRIPTION 'Texture type: specific, typical, unknown.'));
ALTER TABLE surface_data MODIFY (tex_wrap_mode ANNOTATIONS (ADD DESCRIPTION 'Wrap mode: none, wrap, mirror, clamp, border.'));
ALTER TABLE surface_data MODIFY (tex_border_color ANNOTATIONS (ADD DESCRIPTION 'Border color (#RRGGBBAA).'));
ALTER TABLE surface_data MODIFY (gt_orientation ANNOTATIONS (ADD DESCRIPTION 'Georeferenced texture 2x2 rotation/scaling matrix as JSON array.'));
ALTER TABLE surface_data MODIFY (gt_reference_point ANNOTATIONS (ADD DESCRIPTION 'Georeferenced texture reference point in real-world space.'));

-- =================================================================
-- SURFACE_DATA_MAPPING
-- =================================================================
ALTER TABLE surface_data_mapping ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'Links surface data to target geometries via SURFACE_DATA_ID and GEOMETRY_DATA_ID.'
);
ALTER TABLE surface_data_mapping MODIFY (surface_data_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to SURFACE_DATA.'));
ALTER TABLE surface_data_mapping MODIFY (geometry_data_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to GEOMETRY_DATA.'));
ALTER TABLE surface_data_mapping MODIFY (material_mapping ANNOTATIONS (ADD DESCRIPTION 'Material mapping data.'));
ALTER TABLE surface_data_mapping MODIFY (texture_mapping ANNOTATIONS (ADD DESCRIPTION 'Texture coordinate mapping data.'));
ALTER TABLE surface_data_mapping MODIFY (world_to_texture_mapping ANNOTATIONS (ADD DESCRIPTION 'Matrix-based texture mapping.'));
ALTER TABLE surface_data_mapping MODIFY (georeferenced_texture_mapping ANNOTATIONS (ADD DESCRIPTION 'Georeferenced texture mapping data.'));

-- =================================================================
-- APPEAR_TO_SURFACE_DATA
-- =================================================================
ALTER TABLE appear_to_surface_data ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'Many-to-many link between APPEARANCE and SURFACE_DATA.'
);
ALTER TABLE appear_to_surface_data MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE appear_to_surface_data MODIFY (appearance_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to APPEARANCE.'));
ALTER TABLE appear_to_surface_data MODIFY (surface_data_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to SURFACE_DATA.'));

-- =================================================================
-- CODELIST / CODELIST_ENTRY
-- =================================================================
ALTER TABLE codelist ANNOTATIONS (
  ADD
    MODULE 'Codelist',
    DESCRIPTION 'Registry of codelists used for Code-type property values.'
);
ALTER TABLE codelist MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE codelist MODIFY (codelist_type ANNOTATIONS (ADD DESCRIPTION 'CityGML data type associated with the codelist.'));
ALTER TABLE codelist MODIFY (url ANNOTATIONS (ADD DESCRIPTION 'URL as unique codelist identifier.'));
ALTER TABLE codelist MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type if url points to an external file.'));

ALTER TABLE codelist_entry ANNOTATIONS (
  ADD
    MODULE 'Codelist',
    DESCRIPTION 'Stores individual codelist values.'
);
ALTER TABLE codelist_entry MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE codelist_entry MODIFY (codelist_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to CODELIST.'));
ALTER TABLE codelist_entry MODIFY (code ANNOTATIONS (ADD DESCRIPTION 'The code value.'));
ALTER TABLE codelist_entry MODIFY (definition ANNOTATIONS (ADD DESCRIPTION 'Code definition or description.'));

-- =================================================================
-- ADE
-- =================================================================
ALTER TABLE ade ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'Registry of Application Domain Extensions (ADE) that extend the CityGML schema.',
    LONG_FORM 'Application Domain Extension'
);
ALTER TABLE ade MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE ade MODIFY (name ANNOTATIONS (ADD DESCRIPTION 'ADE name.'));
ALTER TABLE ade MODIFY (description ANNOTATIONS (ADD DESCRIPTION 'ADE description.'));
ALTER TABLE ade MODIFY (version ANNOTATIONS (ADD DESCRIPTION 'ADE version.'));

-- =================================================================
-- DATABASE_SRS
-- =================================================================
ALTER TABLE database_srs ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'Coordinate Reference System (CRS) of this 3DCityDB instance. Applies to all stored geometries.'
);
ALTER TABLE database_srs MODIFY (srid ANNOTATIONS (ADD DESCRIPTION 'Spatial Reference ID.'));
ALTER TABLE database_srs MODIFY (srs_name ANNOTATIONS (ADD DESCRIPTION 'Name of the spatial reference system.'));

-- =================================================================
-- NAMESPACE
-- =================================================================
ALTER TABLE namespace ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'Registry of namespaces. All types and properties must be associated with a namespace.'
);
ALTER TABLE namespace MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE namespace MODIFY (alias ANNOTATIONS (ADD DESCRIPTION 'Namespace alias (shortcut), must be unique.'));
ALTER TABLE namespace MODIFY (namespace ANNOTATIONS (ADD DESCRIPTION 'Full namespace URI.'));
ALTER TABLE namespace MODIFY (ade_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to ADE for user-defined namespaces.'));

-- =================================================================
-- OBJECTCLASS
-- =================================================================
ALTER TABLE objectclass ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'Registry of all feature types. Every FEATURE row references an objectclass via OBJECTCLASS_ID. To find the objectclass_id for a type name or its properties, query the PROPERTY_CATALOG table. The SCHEMA column contains a JSON schema mapping describing properties specific to this type (without inherited properties).'
);
ALTER TABLE objectclass MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key. Used as FEATURE.OBJECTCLASS_ID.'));
ALTER TABLE objectclass MODIFY (superclass_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to parent type for inheritance hierarchy.'));
ALTER TABLE objectclass MODIFY (classname ANNOTATIONS (ADD DESCRIPTION 'Feature type name (e.g. Building, Road, Bridge).'));
ALTER TABLE objectclass MODIFY (is_abstract ANNOTATIONS (ADD DESCRIPTION '1 = abstract type (cannot be instantiated directly).'));
ALTER TABLE objectclass MODIFY (is_toplevel ANNOTATIONS (ADD DESCRIPTION '1 = top-level feature type.'));
ALTER TABLE objectclass MODIFY (ade_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to ADE for extension types.'));
ALTER TABLE objectclass MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to NAMESPACE.'));
ALTER TABLE objectclass MODIFY (schema ANNOTATIONS (ADD DESCRIPTION 'JSON schema mapping for this type''s own properties. The PROPERTY_CATALOG table provides the fully resolved (inheritance-aware) version.'));

-- =================================================================
-- DATATYPE
-- =================================================================
ALTER TABLE datatype ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'Registry of data types. Each PROPERTY row references a data type via DATATYPE_ID. The PROPERTY_CATALOG table provides the resolved mapping from property names to PROPERTY VAL_* columns.'
);
ALTER TABLE datatype MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE datatype MODIFY (supertype_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to parent type for inheritance.'));
ALTER TABLE datatype MODIFY (typename ANNOTATIONS (ADD DESCRIPTION 'Data type name (e.g. Code, Integer, Measure, FeatureProperty).'));
ALTER TABLE datatype MODIFY (is_abstract ANNOTATIONS (ADD DESCRIPTION '1 = abstract data type.'));
ALTER TABLE datatype MODIFY (ade_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to ADE for extension types.'));
ALTER TABLE datatype MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to NAMESPACE.'));
ALTER TABLE datatype MODIFY (schema ANNOTATIONS (ADD DESCRIPTION 'JSON schema mapping describing how values of this type are stored (column, type, sub-attributes, joins).'));

-- =================================================================
-- PROPERTY_CATALOG view (self-annotation)
-- =================================================================
ALTER VIEW property_catalog ANNOTATIONS (
  ADD
    MODULE 'Select AI',
    DESCRIPTION 'Property catalog with inheritance resolved. Maps each property to its storage location. ALWAYS query this table FIRST to get value_column, parent_property, and query_pattern. The query_pattern column provides a ready-to-use SQL template for each property. If parent_property IS NOT NULL, use two-hop PARENT_ID join on PROPERTY table. If parent_property IS NULL, use direct single join.'
);

ALTER VIEW property_catalog MODIFY (
  objectclass_id ANNOTATIONS (ADD DESCRIPTION
    'The objectclass_id of the feature type. Use this value to filter FEATURE.OBJECTCLASS_ID.')
);
ALTER VIEW property_catalog MODIFY (
  feature_type ANNOTATIONS (ADD DESCRIPTION
    'Human-readable feature type name, e.g. Building, Road, Bridge. Matches OBJECTCLASS.CLASSNAME.')
);
ALTER VIEW property_catalog MODIFY (
  is_toplevel ANNOTATIONS (ADD DESCRIPTION
    'Whether this feature type is a top-level city object (1) or a subordinate part (0). Top-level features like Building, Road, Bridge can be queried directly.')
);
ALTER VIEW property_catalog MODIFY (
  namespace_alias ANNOTATIONS (ADD DESCRIPTION
    'CityGML module or ADE namespace alias (e.g. bldg, con, tran). Identifies which module defines this feature type. NULL should not normally occur.')
);
ALTER VIEW property_catalog MODIFY (
  ade_id ANNOTATIONS (ADD DESCRIPTION
    'NULL for core CityGML types. Non-NULL references ADE.ID for Application Domain Extension types. Use to filter or group ADE-specific properties.')
);
ALTER VIEW property_catalog MODIFY (
  property_name ANNOTATIONS (ADD DESCRIPTION
    'The property name. Use this to filter PROPERTY.NAME when querying EAV properties. Examples: class, function, usage, roofType, storeysAboveGround, boundary, lod2Solid. For sub-properties (parent_property IS NOT NULL) this is the child property name (e.g. lowReference).')
);
ALTER VIEW property_catalog MODIFY (
  parent_property ANNOTATIONS (ADD DESCRIPTION
    'NULL for simple properties. When NOT NULL, this is a sub-property: query requires two-hop PARENT_ID join. Pattern: JOIN property p_parent ON p_parent.feature_id=f.id AND p_parent.name=<this column value> JOIN property p_child ON p_child.parent_id=p_parent.id AND p_child.name=<property_name>, read p_child.<value_column>.')
);
ALTER VIEW property_catalog MODIFY (
  value_column ANNOTATIONS (ADD DESCRIPTION
    'Which column stores the property value, derived from DATATYPE.SCHEMA. For simple types: value.column (e.g. VAL_STRING, VAL_INT, VAL_DOUBLE). For reference types: join.fromColumn (e.g. VAL_FEATURE_ID, VAL_GEOMETRY_ID, VAL_ADDRESS_ID). Columns without VAL_ prefix (e.g. CREATION_DATE) are direct FEATURE table columns. NULL means the property uses nested sub-properties via PROPERTY.PARENT_ID.')
);
ALTER VIEW property_catalog MODIFY (
  join_table ANNOTATIONS (ADD DESCRIPTION
    'For reference-type properties: the table to JOIN to via VALUE_COLUMN. Derived from DATATYPE.SCHEMA join.table. Examples: FEATURE (containment via VAL_FEATURE_ID), GEOMETRY_DATA (geometries via VAL_GEOMETRY_ID), ADDRESS (addresses via VAL_ADDRESS_ID), APPEARANCE, IMPLICIT_GEOMETRY. NULL for simple-value properties and direct FEATURE columns.')
);
ALTER VIEW property_catalog MODIFY (
  target_objectclass_id ANNOTATIONS (ADD DESCRIPTION
    'For containment FeatureProperty: the objectclass_id of the concrete child feature type. Use to filter child FEATURE.OBJECTCLASS_ID. For example, Building boundary has targets 709 (WallSurface), 712 (RoofSurface), 710 (GroundSurface), etc. NULL for non-containment properties.')
);
ALTER VIEW property_catalog MODIFY (
  target_feature_type ANNOTATIONS (ADD DESCRIPTION
    'For containment FeatureProperty: the name of the concrete child feature type, e.g. WallSurface, RoofSurface. NULL for non-containment properties.')
);
ALTER VIEW property_catalog MODIFY (
  relation_type ANNOTATIONS (ADD DESCRIPTION
    'For FeatureProperty: contains (parent owns child in hierarchy) or relates (reference link). Use contains relations for containment hierarchy queries.')
);
ALTER VIEW property_catalog MODIFY (
  description ANNOTATIONS (ADD DESCRIPTION
    'Human-readable description of the property from the CityGML schema mapping.')
);
ALTER VIEW property_catalog MODIFY (
  query_pattern ANNOTATIONS (ADD DESCRIPTION
    'Ready-to-use SQL query template for retrieving this property value. Copy and adapt this pattern to build your query. For sub-properties (parent_property IS NOT NULL), the pattern includes the required two-hop PARENT_ID join. NULL for complex parent types whose sub-properties should be queried individually.')
);

-- ===============================================================
-- PART 3 – Table comments (query rules + mappings for Select AI)
-- ===============================================================
-- Annotations describe what tables/columns ARE.
-- Comments describe HOW TO QUERY them with rules and examples.
-- Both are sent to the LLM when "annotations" and "comments" are
-- enabled in the Select AI profile.

-- ---------------------------------------------------------------
-- 3.1 COMMENT ON TABLE FEATURE (dynamic: objectclass_id mappings)
-- ---------------------------------------------------------------
PROMPT Generating COMMENT ON TABLE FEATURE ...
DECLARE
  v_comment VARCHAR2(4000);
  v_entry   VARCHAR2(200);
  v_pentry  VARCHAR2(500);
BEGIN
  -- Part A: Query rules + objectclass_id mappings
  v_comment := 'RULES: '
    || '(1) Do NOT join OBJECTCLASS. Use objectclass_id directly. '
    || '(2) Properties in PROPERTY (EAV): JOIN property p ON p.feature_id=f.id AND p.name=''<name>''. '
    || '(3) Check PROPERTY_CATALOG for value_column and parent_property. '
    || '(4) Containment: child features linked via PROPERTY.VAL_FEATURE_ID. '
    || 'CRITICAL: some types require MULTI-HOP traversal. '
    || 'WindowSurface belongs to WallSurface, NOT directly to Building. '
    || 'To find windows: Building(901)--boundary-->WallSurface(709)--fillingSurface-->WindowSurface(719). '
    || 'Pattern: f_parent JOIN property p1 (feature_id,name) JOIN feature f_child (p1.val_feature_id) '
    || 'JOIN property p2 (feature_id,name) JOIN feature f_grandchild (p2.val_feature_id). '
    || 'IDS: ';

  FOR r IN (
    SELECT ns.alias, oc.id, oc.classname
    FROM objectclass oc
    LEFT JOIN namespace ns ON ns.id = oc.namespace_id
    WHERE oc.is_abstract = 0 AND oc.is_toplevel = 1
    ORDER BY oc.ade_id NULLS FIRST, ns.alias, oc.classname
  ) LOOP
    v_entry := NVL(r.alias, '?') || ':' || r.classname || '=' || r.id || ', ';
    EXIT WHEN LENGTH(v_comment) + LENGTH(v_entry) > 2500;
    v_comment := v_comment || v_entry;
  END LOOP;
  v_comment := RTRIM(v_comment, ', ') || '. ';

  -- Part B: Containment paths from PROPERTY_CATALOG
  -- Generate: "ParentType(id)--propName-->ChildType(id)" chains.
  -- Non-toplevel paths (second-hop, e.g. WallSurface-->WindowSurface) are
  -- listed first because they are critical for multi-hop traversal.
  v_comment := v_comment || 'CONTAINMENT PATHS: ';

  FOR r IN (
    SELECT DISTINCT
      pc.feature_type || '(' || pc.objectclass_id || ')'
        || '--' || pc.property_name || '-->'
        || pc.target_feature_type || '(' || pc.target_objectclass_id || ')' AS path_segment,
      pc.is_toplevel
    FROM property_catalog pc
    WHERE pc.relation_type = 'contains'
      AND pc.target_objectclass_id IS NOT NULL
    ORDER BY pc.is_toplevel ASC, 1
  ) LOOP
    v_pentry := r.path_segment || ', ';
    EXIT WHEN LENGTH(v_comment) + LENGTH(v_pentry) > 3950;
    v_comment := v_comment || v_pentry;
  END LOOP;

  v_comment := RTRIM(v_comment, ', ');

  EXECUTE IMMEDIATE 'COMMENT ON TABLE feature IS '''
    || REPLACE(v_comment, '''', '''''') || '''';

  DBMS_OUTPUT.PUT_LINE('COMMENT ON TABLE FEATURE generated ('
    || LENGTH(v_comment) || ' chars).');
END;
/

-- ---------------------------------------------------------------
-- 3.2 COMMENT ON TABLE PROPERTY (static: PARENT_ID join rules)
-- ---------------------------------------------------------------
PROMPT Adding COMMENT ON TABLE PROPERTY ...
DECLARE
  v_comment VARCHAR2(4000);
BEGIN
  v_comment := 'QUERY RULES: '
    || 'CRITICAL: Some properties are sub-properties of complex types. '
    || 'You MUST check PROPERTY_CATALOG.PARENT_PROPERTY before querying. '
    || 'If PARENT_PROPERTY IS NOT NULL, use a two-hop PARENT_ID join. '
    || q'[WRONG: JOIN property p ON p.feature_id=f.id AND p.name='lowReference' (RETURNS NO ROWS). ]'
    || q'[CORRECT: JOIN property p_parent ON p_parent.feature_id=f.id AND p_parent.name='height' ]'
    || q'[JOIN property p_child ON p_child.parent_id=p_parent.id AND p_child.name='lowReference', ]'
    || 'value in p_child.val_string. '
    || q'[If PARENT_PROPERTY IS NULL, use direct join: JOIN property p ON p.feature_id=f.id AND p.name='<name>'. ]'
    || 'VALUE COLUMNS: val_string (text/codes), val_int (integers/booleans), val_double (measurements), '
    || 'val_timestamp (dates), val_feature_id (child features), val_geometry_id (geometries), '
    || 'val_address_id (addresses). '
    || 'Code properties: value in val_string, code space in val_codespace. '
    || 'Measure properties: value in val_double, unit in val_uom.';
  EXECUTE IMMEDIATE 'COMMENT ON TABLE property IS '''
    || REPLACE(v_comment, '''', '''''') || '''';
END;
/

-- ---------------------------------------------------------------
-- 3.3 COMMENT ON TABLE PROPERTY_CATALOG (dynamic: sub-properties)
-- ---------------------------------------------------------------
PROMPT Generating COMMENT ON TABLE PROPERTY_CATALOG ...
DECLARE
  v_comment VARCHAR2(4000);
BEGIN
  v_comment := 'QUERY RULES: '
    || 'Always query this table first to find value_column, parent_property, and query_pattern. '
    || 'The query_pattern column provides a ready-to-use SQL template for each property. '
    || 'Copy and adapt query_pattern to build your actual query. '
    || 'If parent_property IS NOT NULL, the query_pattern already includes the two-hop PARENT_ID join. '
    || 'If parent_property IS NULL, use direct single join as shown in query_pattern.';

  EXECUTE IMMEDIATE 'COMMENT ON TABLE property_catalog IS '''
    || REPLACE(v_comment, '''', '''''') || '''';

  DBMS_OUTPUT.PUT_LINE('COMMENT ON TABLE PROPERTY_CATALOG generated ('
    || LENGTH(v_comment) || ' chars).');
END;
/

PROMPT Select AI context setup complete.
