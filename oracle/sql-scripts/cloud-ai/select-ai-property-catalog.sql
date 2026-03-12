-- select-ai-property-catalog.sql
-- Sets up Oracle Select AI context for the 3DCityDB schema:
--   1. Creates and populates the PROPERTY_CATALOG table
--      (flattened property catalog with inheritance resolved)
--   2. Adds semantic annotations on all core tables and columns
--
-- Run as the application user (e.g. CITYDB) in the target PDB
-- AFTER schema.sql, objectclass-instances.sql and datatype-instances.sql.

SET FEEDBACK ON
SET SERVEROUTPUT ON

-- ===============================================================
-- PART 1 – PROPERTY_CATALOG table
-- ===============================================================

-- ---------------------------------------------------------------
-- 1.1 Drop / create the PROPERTY_CATALOG table
-- ---------------------------------------------------------------
PROMPT Dropping existing PROPERTY_CATALOG table (if exists) ...
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE property_catalog PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

PROMPT Creating PROPERTY_CATALOG table ...
CREATE TABLE property_catalog (
  objectclass_id        NUMBER(10)    NOT NULL,
  feature_type          VARCHAR2(255) NOT NULL,
  is_toplevel           NUMBER(1)     NOT NULL,
  property_name         VARCHAR2(255) NOT NULL,
  parent_property       VARCHAR2(255),
  value_column          VARCHAR2(50),
  join_table            VARCHAR2(255),
  target_objectclass_id NUMBER(10),
  target_feature_type   VARCHAR2(255),
  relation_type         VARCHAR2(50),
  description           VARCHAR2(4000)
);

-- ---------------------------------------------------------------
-- 1.2 Populate: resolve inheritance + map containment targets
-- ---------------------------------------------------------------
PROMPT Populating PROPERTY_CATALOG ...

INSERT INTO property_catalog
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
-- Build a full descendant tree so we can resolve abstract
-- FeatureProperty targets (e.g. AbstractSpaceBoundary) to
-- their concrete subclasses (WallSurface, RoofSurface ...).
descendant_chain (root_id, descendant_id) AS (
  SELECT id, id FROM objectclass
  UNION ALL
  SELECT dc.root_id, oc.id
  FROM descendant_chain dc
  JOIN objectclass oc ON oc.superclass_id = dc.descendant_id
)
SELECT DISTINCT
  rp.objectclass_id,
  oc_src.classname,
  oc_src.is_toplevel,
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
  rp.description
FROM raw_props rp
JOIN objectclass oc_src
  ON oc_src.id = rp.objectclass_id
-- Look up value column and join table from DATATYPE schema
LEFT JOIN datatype_map dm
  ON dm.type_id = rp.property_type
-- Match the target identifier to an objectclass (containment only)
LEFT JOIN objectclass oc_tgt
  ON rp.relation_type = 'contains'
  AND rp.property_target IS NOT NULL
  AND JSON_VALUE(oc_tgt.schema, '$.identifier') = rp.property_target
-- Walk down to concrete descendants of the target
LEFT JOIN descendant_chain dc
  ON dc.root_id = oc_tgt.id
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
  dsp.sub_name,
  rp.property_name,
  COALESCE(UPPER(sub_dm.value_col), UPPER(sub_dm.join_col)),
  UPPER(sub_dm.join_tbl),
  NULL,
  NULL,
  NULL,
  dsp.sub_description
FROM raw_props rp
JOIN objectclass oc_src ON oc_src.id = rp.objectclass_id
JOIN datatype_subprops dsp ON dsp.parent_type_id = rp.property_type
LEFT JOIN datatype_map sub_dm ON sub_dm.type_id = dsp.sub_type;

COMMIT;

DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM property_catalog;
  DBMS_OUTPUT.PUT_LINE('PROPERTY_CATALOG populated: ' || v_cnt || ' rows.');
END;
/

-- ===============================================================
-- PART 2 – Schema annotations for Select AI context
-- ===============================================================

-- Drop all existing annotations to make this script idempotent.
PROMPT Dropping existing annotations ...
DECLARE
  PROCEDURE drop_annotations(p_table VARCHAR2) IS
    v_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('MODULE', 'DESCRIPTION', 'LONG_FORM');
  BEGIN
    FOR i IN 1..v_names.COUNT LOOP
      BEGIN
        EXECUTE IMMEDIATE
          'ALTER TABLE "' || p_table || '" ANNOTATIONS (DROP "' || v_names(i) || '")';
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
    END LOOP;
    FOR c IN (
      SELECT column_name FROM user_tab_columns WHERE table_name = p_table
    ) LOOP
      FOR i IN 1..v_names.COUNT LOOP
        BEGIN
          EXECUTE IMMEDIATE
            'ALTER TABLE "' || p_table || '" MODIFY ("' || c.column_name
            || '" ANNOTATIONS (DROP "' || v_names(i) || '"))';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
      END LOOP;
    END LOOP;
  END;
BEGIN
  drop_annotations('ADDRESS');
  drop_annotations('FEATURE');
  drop_annotations('PROPERTY');
  drop_annotations('GEOMETRY_DATA');
  drop_annotations('IMPLICIT_GEOMETRY');
  drop_annotations('TEX_IMAGE');
  drop_annotations('APPEARANCE');
  drop_annotations('SURFACE_DATA');
  drop_annotations('SURFACE_DATA_MAPPING');
  drop_annotations('APPEAR_TO_SURFACE_DATA');
  drop_annotations('CODELIST');
  drop_annotations('CODELIST_ENTRY');
  drop_annotations('ADE');
  drop_annotations('DATABASE_SRS');
  drop_annotations('NAMESPACE');
  drop_annotations('OBJECTCLASS');
  drop_annotations('DATATYPE');
  drop_annotations('PROPERTY_CATALOG');
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
    DESCRIPTION 'Central table storing all city objects using an Entity-Attribute-Value (EAV) pattern. The feature type is determined by OBJECTCLASS_ID (foreign key to OBJECTCLASS). Feature properties are stored in the PROPERTY table joined via PROPERTY.FEATURE_ID = FEATURE.ID. IMPORTANT: To look up which properties a feature type has and which PROPERTY VAL_* column stores each value, query the PROPERTY_CATALOG table by feature_type or objectclass_id. Features form a containment hierarchy linked through PROPERTY rows where VAL_FEATURE_ID points to child features. To traverse: FEATURE (parent) -> PROPERTY (feature_id) -> FEATURE (val_feature_id). Use PROPERTY_CATALOG.target_objectclass_id to find valid child types. Example (EAV simple property): SELECT f.objectid, p.val_string FROM feature f JOIN property p ON p.feature_id = f.id WHERE f.objectclass_id = 901 AND p.name = ''roofType''. Example (two-hop containment, windows per building): SELECT b.objectid, COUNT(w.id) FROM feature b JOIN property p1 ON p1.feature_id = b.id JOIN feature ws ON ws.id = p1.val_feature_id AND ws.objectclass_id IN (709,712,710) JOIN property p2 ON p2.feature_id = ws.id JOIN feature w ON w.id = p2.val_feature_id AND w.objectclass_id = 719 WHERE b.objectclass_id = 901 GROUP BY b.objectid.'
);
ALTER TABLE feature MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE feature MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'Determines the feature type. Do NOT join OBJECTCLASS to resolve type names. Use the objectclass_id values listed in COMMENT ON TABLE FEATURE directly.'));
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
    DESCRIPTION 'Stores feature properties using an EAV (Entity-Attribute-Value) pattern. Each row is one property of a feature, joined via FEATURE_ID. The NAME column holds the property name. The value is stored in a type-specific VAL_* column. IMPORTANT: To determine which VAL_* column stores a given property, query: SELECT value_column FROM property_catalog WHERE feature_type = ''Building'' AND property_name = ''roofType''. For linked objects: VAL_FEATURE_ID references FEATURE (containment hierarchy), VAL_GEOMETRY_ID references GEOMETRY_DATA, VAL_ADDRESS_ID references ADDRESS, VAL_APPEARANCE_ID references APPEARANCE, VAL_IMPLICITGEOM_ID references IMPLICIT_GEOMETRY. Code-type properties store the value in VAL_STRING and the code space in VAL_CODESPACE. Measure-type properties store the value in VAL_DOUBLE and the unit in VAL_UOM.'
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
-- PROPERTY_CATALOG (self-annotation)
-- =================================================================
ALTER TABLE property_catalog ANNOTATIONS (
  ADD
    MODULE 'Select AI',
    DESCRIPTION 'Property catalog with inheritance resolved. Each row maps a property to its storage location. IMPORTANT: When PARENT_PROPERTY IS NOT NULL, the property is a sub-property. You MUST use a two-hop PARENT_ID join: JOIN property p_parent ON p_parent.feature_id=f.id AND p_parent.name=<parent_property> JOIN property p_child ON p_child.parent_id=p_parent.id AND p_child.name=<property_name>, value in p_child.<value_column>. Example: height has sub-properties lowReference, highReference, value, status. To query lowReference of height: JOIN property p_h ON p_h.feature_id=f.id AND p_h.name=''height'' JOIN property p_lr ON p_lr.parent_id=p_h.id AND p_lr.name=''lowReference'' WHERE p_lr.val_string=''someValue''. Simple properties (PARENT_PROPERTY IS NULL): SELECT p.<value_column> FROM feature f JOIN property p ON p.feature_id=f.id AND p.name=''<property_name>'' WHERE f.objectclass_id=<objectclass_id>. VALUE_COLUMN: VAL_* columns are in PROPERTY table; others (CREATION_DATE) are FEATURE columns. JOIN_TABLE: GEOMETRY_DATA, ADDRESS, FEATURE (containment), etc. Containment: use TARGET_OBJECTCLASS_ID to filter child features. See LONG_FORM for complete sub-property listing.'
);

-- Dynamically generate LONG_FORM from PROPERTY_CATALOG data so that
-- ADE complex types are automatically included.
PROMPT Generating dynamic LONG_FORM annotation for PROPERTY_CATALOG ...
DECLARE
  v_ref     VARCHAR2(4000);
  v_prev    VARCHAR2(255) := NULL;
  v_first   BOOLEAN := TRUE;
  -- Oracle annotation values are limited to 4000 chars (ORA-11545).
  v_maxlen  CONSTANT NUMBER := 4000;
  v_entry   VARCHAR2(500);
  v_sql     VARCHAR2(32767);
BEGIN
  -- Build complete sub-property listing: "parent: sub1(COL), sub2(COL). ..."
  -- This tells the LLM which properties require a PARENT_ID join.
  v_ref := 'PARENT_ID sub-properties (query via two-hop join). ';

  FOR r IN (
    SELECT DISTINCT parent_property, property_name, value_column
    FROM property_catalog
    WHERE parent_property IS NOT NULL
    ORDER BY parent_property, property_name
  ) LOOP
    v_entry := '';
    IF v_prev IS NULL OR v_prev != r.parent_property THEN
      IF v_prev IS NOT NULL THEN
        v_entry := v_entry || '. ';
      END IF;
      v_entry := v_entry || r.parent_property || ': ';
      v_prev := r.parent_property;
      v_first := TRUE;
    END IF;
    IF NOT v_first THEN
      v_entry := v_entry || ', ';
    END IF;
    v_entry := v_entry || r.property_name
            || '(' || NVL(r.value_column, 'COMPLEX') || ')';
    v_first := FALSE;

    -- Stop before exceeding 4000 char limit
    IF LENGTH(v_ref) + LENGTH(v_entry) > v_maxlen - 50 THEN
      v_ref := v_ref || '...';
      EXIT;
    END IF;
    v_ref := v_ref || v_entry;
  END LOOP;

  -- Final safety truncation
  IF LENGTH(v_ref) > v_maxlen THEN
    v_ref := SUBSTR(v_ref, 1, v_maxlen - 4) || '...';
  END IF;

  -- Use a separate VARCHAR2(32767) for the SQL to avoid overflow
  -- when REPLACE doubles the single quotes.
  v_sql := 'ALTER TABLE property_catalog ANNOTATIONS (ADD LONG_FORM '''
         || REPLACE(v_ref, '''', '''''') || ''')';
  EXECUTE IMMEDIATE v_sql;

  DBMS_OUTPUT.PUT_LINE('LONG_FORM annotation generated ('
    || LENGTH(v_ref) || ' / ' || v_maxlen || ' chars).');
END;
/
ALTER TABLE property_catalog MODIFY (
  objectclass_id ANNOTATIONS (ADD DESCRIPTION
    'The objectclass_id of the feature type. Use this value to filter FEATURE.OBJECTCLASS_ID.')
);
ALTER TABLE property_catalog MODIFY (
  feature_type ANNOTATIONS (ADD DESCRIPTION
    'Human-readable feature type name, e.g. Building, Road, Bridge. Matches OBJECTCLASS.CLASSNAME.')
);
ALTER TABLE property_catalog MODIFY (
  is_toplevel ANNOTATIONS (ADD DESCRIPTION
    'Whether this feature type is a top-level city object (1) or a subordinate part (0). Top-level features like Building, Road, Bridge can be queried directly.')
);
ALTER TABLE property_catalog MODIFY (
  property_name ANNOTATIONS (ADD DESCRIPTION
    'The property name. Use this to filter PROPERTY.NAME when querying EAV properties. Examples: class, function, usage, roofType, storeysAboveGround, boundary, lod2Solid. For sub-properties (parent_property IS NOT NULL) this is the child property name (e.g. lowReference).')
);
ALTER TABLE property_catalog MODIFY (
  parent_property ANNOTATIONS (ADD DESCRIPTION
    'For sub-properties of complex types (con:Height, core:Occupancy, con:ConstructionEvent, etc.): the name of the parent property. NULL for top-level properties. When NOT NULL, the sub-property is stored as a child PROPERTY row linked via PARENT_ID. Query pattern: JOIN property p_parent ON p_parent.feature_id = f.id AND p_parent.name = <parent_property> JOIN property p_child ON p_child.parent_id = p_parent.id AND p_child.name = <property_name>, then read p_child.<value_column>. Example 1 (height.lowReference): JOIN property p_h ON p_h.feature_id=f.id AND p_h.name=''height'' JOIN property p_lr ON p_lr.parent_id=p_h.id AND p_lr.name=''lowReference'' -> p_lr.val_string. Example 2 (constructionEvent.dateOfEvent): JOIN property p_ce ON p_ce.feature_id=f.id AND p_ce.name=''constructionEvent'' JOIN property p_doe ON p_doe.parent_id=p_ce.id AND p_doe.name=''dateOfEvent'' -> p_doe.val_timestamp.')
);
ALTER TABLE property_catalog MODIFY (
  value_column ANNOTATIONS (ADD DESCRIPTION
    'Which column stores the property value, derived from DATATYPE.SCHEMA. For simple types: value.column (e.g. VAL_STRING, VAL_INT, VAL_DOUBLE). For reference types: join.fromColumn (e.g. VAL_FEATURE_ID, VAL_GEOMETRY_ID, VAL_ADDRESS_ID). Columns without VAL_ prefix (e.g. CREATION_DATE) are direct FEATURE table columns. NULL means the property uses nested sub-properties via PROPERTY.PARENT_ID.')
);
ALTER TABLE property_catalog MODIFY (
  join_table ANNOTATIONS (ADD DESCRIPTION
    'For reference-type properties: the table to JOIN to via VALUE_COLUMN. Derived from DATATYPE.SCHEMA join.table. Examples: FEATURE (containment via VAL_FEATURE_ID), GEOMETRY_DATA (geometries via VAL_GEOMETRY_ID), ADDRESS (addresses via VAL_ADDRESS_ID), APPEARANCE, IMPLICIT_GEOMETRY. NULL for simple-value properties and direct FEATURE columns.')
);
ALTER TABLE property_catalog MODIFY (
  target_objectclass_id ANNOTATIONS (ADD DESCRIPTION
    'For containment FeatureProperty: the objectclass_id of the concrete child feature type. Use to filter child FEATURE.OBJECTCLASS_ID. For example, Building boundary has targets 709 (WallSurface), 712 (RoofSurface), 710 (GroundSurface), etc. NULL for non-containment properties.')
);
ALTER TABLE property_catalog MODIFY (
  target_feature_type ANNOTATIONS (ADD DESCRIPTION
    'For containment FeatureProperty: the name of the concrete child feature type, e.g. WallSurface, RoofSurface. NULL for non-containment properties.')
);
ALTER TABLE property_catalog MODIFY (
  relation_type ANNOTATIONS (ADD DESCRIPTION
    'For FeatureProperty: contains (parent owns child in hierarchy) or relates (reference link). Use contains relations for containment hierarchy queries.')
);
ALTER TABLE property_catalog MODIFY (
  description ANNOTATIONS (ADD DESCRIPTION
    'Human-readable description of the property from the CityGML schema mapping.')
);

-- ===============================================================
-- PART 3 – Table comments with objectclass_id mappings
-- ===============================================================
-- Dynamically generate COMMENT ON TABLE FEATURE listing all
-- top-level feature type -> objectclass_id mappings so that the
-- LLM can use objectclass_id values directly without joins.

PROMPT Generating COMMENT ON TABLE FEATURE with objectclass_id mappings ...
DECLARE
  v_comment VARCHAR2(4000);
  v_entry   VARCHAR2(200);
BEGIN
  v_comment := 'Feature type objectclass_id mappings (use directly in WHERE clause, do NOT join OBJECTCLASS): ';

  FOR r IN (
    SELECT id, classname
    FROM objectclass
    WHERE is_abstract = 0 AND is_toplevel = 1
    ORDER BY classname
  ) LOOP
    v_entry := r.classname || '=' || r.id || ', ';
    EXIT WHEN LENGTH(v_comment) + LENGTH(v_entry) > 3950;
    v_comment := v_comment || v_entry;
  END LOOP;

  -- Remove trailing comma-space
  v_comment := RTRIM(v_comment, ', ');

  EXECUTE IMMEDIATE 'COMMENT ON TABLE feature IS '''
    || REPLACE(v_comment, '''', '''''') || '''';

  DBMS_OUTPUT.PUT_LINE('COMMENT ON TABLE FEATURE generated ('
    || LENGTH(v_comment) || ' chars).');
END;
/

PROMPT Select AI context setup complete.
