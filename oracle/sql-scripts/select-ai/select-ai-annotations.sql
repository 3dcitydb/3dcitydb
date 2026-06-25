-- select-ai-annotations.sql
-- Annotates the physical data tables exposed in the Select AI object_list
-- (FEATURE, PROPERTY, GEOMETRY_DATA, ADDRESS, ...) so Select AI sends accurate
-- table/column descriptions to the LLM.
-- The EAV query rules, objectclass-id map and containment graph are NOT here:
-- they are injected per request by CITYDB_AI.BUILD_CONTEXT (select-ai-property-catalog.sql).
--
-- Run as the application user (e.g. CITYDB) in the target PDB, typically after
-- select-ai-property-catalog.sql.

SET FEEDBACK ON
SET SERVEROUTPUT ON

-- ===============================================================
-- Table annotations for the Select AI object_list tables
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
    DESCRIPTION 'Central table storing all city objects, one row per feature, using an Entity-Attribute-Value model. The feature type is given by OBJECTCLASS_ID. Most attribute values live in the PROPERTY table (linked via FEATURE_ID); a few lifecycle fields are direct columns here.'
);
ALTER TABLE feature MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE feature MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'Discriminator for the feature type (CityGML object class id).'));
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
    DESCRIPTION 'Stores feature attributes as Entity-Attribute-Value rows: each row is one attribute of the feature referenced by FEATURE_ID. NAME holds the attribute name; the value is in a type-specific VAL_* column. Nested attributes of complex types reference their parent row via PARENT_ID.'
);
ALTER TABLE property MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key.'));
ALTER TABLE property MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to FEATURE. Links this property to its owning feature.'));
ALTER TABLE property MODIFY (parent_id ANNOTATIONS (ADD DESCRIPTION 'For nested/complex properties: references the parent property row. Used by complex types like con:Height whose sub-attributes (value, status, lowReference, highReference) are stored as child property rows.'));
ALTER TABLE property MODIFY (datatype_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to DATATYPE. Defines the data type of this property.'));
ALTER TABLE property MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to NAMESPACE.'));
ALTER TABLE property MODIFY (name ANNOTATIONS (ADD DESCRIPTION 'The attribute name. Case-sensitive.'));
ALTER TABLE property MODIFY (val_int ANNOTATIONS (ADD DESCRIPTION 'Integer value (also used for booleans: 0=false, 1=true).'));
ALTER TABLE property MODIFY (val_double ANNOTATIONS (ADD DESCRIPTION 'Double value (measurements, amounts).'));
ALTER TABLE property MODIFY (val_string ANNOTATIONS (ADD DESCRIPTION 'String value (text, codes, type names).'));
ALTER TABLE property MODIFY (val_timestamp ANNOTATIONS (ADD DESCRIPTION 'Timestamp value.'));
ALTER TABLE property MODIFY (val_uri ANNOTATIONS (ADD DESCRIPTION 'URI value.', LONG_FORM 'URI = Uniform Resource Identifier'));
ALTER TABLE property MODIFY (val_codespace ANNOTATIONS (ADD DESCRIPTION 'Code space for Code-type properties (accompanies VAL_STRING).'));
ALTER TABLE property MODIFY (val_uom ANNOTATIONS (ADD DESCRIPTION 'Unit of measurement for Measure-type properties (accompanies VAL_DOUBLE).', LONG_FORM 'UoM = Unit of Measure'));
ALTER TABLE property MODIFY (val_array ANNOTATIONS (ADD DESCRIPTION 'JSON array value for array-type properties. Use JSON_TABLE or JSON_VALUE to extract individual elements.'));
ALTER TABLE property MODIFY (val_lod ANNOTATIONS (ADD DESCRIPTION 'Level of Detail for geometry properties.', LONG_FORM 'Level of Detail'));
ALTER TABLE property MODIFY (val_geometry_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to GEOMETRY_DATA. Links to explicit geometries.'));
ALTER TABLE property MODIFY (val_implicitgeom_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to IMPLICIT_GEOMETRY. Links to template geometries.'));
ALTER TABLE property MODIFY (val_implicitgeom_refpoint ANNOTATIONS (ADD DESCRIPTION 'Reference point for implicit geometry placement.'));
ALTER TABLE property MODIFY (val_appearance_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to APPEARANCE.'));
ALTER TABLE property MODIFY (val_address_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to ADDRESS.'));
ALTER TABLE property MODIFY (val_feature_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to FEATURE. When set, links a parent feature to a contained child feature, forming the containment hierarchy.'));
ALTER TABLE property MODIFY (val_relation_type ANNOTATIONS (ADD DESCRIPTION 'Type of the feature relationship (integer).'));
ALTER TABLE property MODIFY (val_content ANNOTATIONS (ADD DESCRIPTION 'Arbitrary content as character lob.'));
ALTER TABLE property MODIFY (val_content_mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type of VAL_CONTENT.'));

-- =================================================================
-- GEOMETRY_DATA
-- =================================================================
ALTER TABLE geometry_data ANNOTATIONS (
  ADD
    MODULE 'Geometry',
    DESCRIPTION 'Stores all explicit and implicit geometries. Linked from PROPERTY via VAL_GEOMETRY_ID (reach a geometry by joining PROPERTY on FEATURE_ID + NAME, then GEOMETRY_DATA on ID = VAL_GEOMETRY_ID). Each geometry belongs to a feature via FEATURE_ID.'
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
    DESCRIPTION 'Template geometries that can be reused by multiple city objects.'
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
ALTER TABLE tex_image MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'MIME type of the texture image.'));
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

-- ADE, NAMESPACE, OBJECTCLASS, DATATYPE and the PROPERTY_CATALOG view are NOT
-- annotated: they are not in the profile object_list, so the LLM never sees them
-- (their content is injected by CITYDB_AI.BUILD_CONTEXT). They stay in the Part 2
-- drop list so upgrades strip any annotations from older installs.

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
-- FEATURE_CHANGELOG (optional — only exists when changelog is enabled)
-- =================================================================
DECLARE
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM user_tables WHERE table_name = 'FEATURE_CHANGELOG';
  IF v_exists = 0 THEN
    DBMS_OUTPUT.PUT_LINE('FEATURE_CHANGELOG table not found — skipping annotations.');
    RETURN;
  END IF;

  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog ANNOTATIONS (
    ADD
      MODULE 'Changelog',
      DESCRIPTION 'Audit log tracking INSERT, UPDATE, TERMINATE, and DELETE operations on top-level features. Each row records one transaction, created automatically by triggers on the FEATURE table. Use OBJECTCLASS_ID with the same mappings as the FEATURE table. For DELETE transactions FEATURE_ID is NULL (use OBJECTID to identify the feature). Filter by TRANSACTION_DATE for time-range queries, TRANSACTION_TYPE for the kind of change, and OBJECTID for a single feature''s history.'
  )]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Unique primary key (auto-generated sequence).'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'Foreign key to FEATURE. NULL for DELETE transactions because the feature has been removed.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'Feature type at time of transaction. Same IDs as FEATURE.OBJECTCLASS_ID.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'String identifier of the feature at time of transaction.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'Cross-system identifier of the feature at time of transaction.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'Authority for the identifier at time of transaction.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (envelope ANNOTATIONS (ADD DESCRIPTION 'Spatial envelope of the feature at time of transaction.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (transaction_type ANNOTATIONS (ADD DESCRIPTION 'Type of change: INSERT (new feature), UPDATE (modified), TERMINATE (termination_date set), DELETE (removed).'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (transaction_date ANNOTATIONS (ADD DESCRIPTION 'Timestamp when the transaction occurred. Use for time-range queries.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (db_user ANNOTATIONS (ADD DESCRIPTION 'Database user who performed the transaction.'))]';
  EXECUTE IMMEDIATE q'[ALTER TABLE feature_changelog MODIFY (reason_for_update ANNOTATIONS (ADD DESCRIPTION 'Optional reason provided for the change.'))]';

  DBMS_OUTPUT.PUT_LINE('FEATURE_CHANGELOG annotations added.');
END;
/

PROMPT Table annotations complete.
