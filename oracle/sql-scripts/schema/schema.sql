-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: Sep 12, 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

-----------------------------------------------------
-- Open tasks:
--   1. Postprocessing
--     a. Register SDO Metadata
--     b. Create spatial indexes
-----------------------------------------------------


--
-- Clean up 3DCityDB tables
--

DROP TABLE IF EXISTS address CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS ade CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS codelist CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS codelist_entry CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS database_srs CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS feature CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS geometry_data CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS implicit_geometry CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS namespace CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS objectclass CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS tex_image CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS appearance CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS datatype CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS property CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS surface_data CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS surface_data_mapping CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS appear_to_surface_data CASCADE CONSTRAINTS PURGE;

--
-- Create 3DCityDB tables belonging to the following modules:
--   * Feature module
--   * Geometry module
--   * Appearance module
--   * CodeList module
--   * Metadata module
--

--
-- Table ADDRESS (Feature module)
--

CREATE TABLE IF NOT EXISTS address (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each address has a unique ID as the primary key assigned.'),
  objectid                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The OBJECTID column in the ADDRESS table is used to store a unique identifier for an address object.'),
  identifier                    VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the address across different systems and potentially multiple versions of the same real-world object.'),
  identifier_codespace          VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER_CODESPACE column indicates the authority responsible for maintaining the identifier.'),
  street                        VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The STREET column holds the name of the street or road where the address is located.'),
  house_number                  VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The HOUSE_NUMBER column stores the building or house number.'),
  po_box                        VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The PO_BOX column stores the post office box number associated with the address, if applicable.'),
  zip_code                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The ZIP_CODE column holds the postal or ZIP code, helping to define the location more precisely.'),
  city                          VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The CITY column stores the name of the city or locality.'),
  state                         VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The STATE column contains the name of the state, province, or region.'),
  country                       VARCHAR2(2) ANNOTATIONS (DESCRIPTION 'The COUNTRY column stores the name of the country in which the address resides.'),
  free_text                     JSON ANNOTATIONS (DESCRIPTION 'The FREE_TEXT column allows the storage of address information as unstructured text. It can be used to supplement or replace the other structured fields.'),
  multi_point                   SDO_GEOMETRY ANNOTATIONS (DESCRIPTION 'The MULTI_POINT column stores the geolocation of an address as multi-point geometry, enabling efficient spatial queries and reverse location services.'),
  content                       CLOB ANNOTATIONS (DESCRIPTION 'If the original address information is more complex and needs to be preserved, the CONTENT column can be used to store the address data in its original format as a character blob.'),
  content_mime_type             VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'The CONTENT_MIME_TYPE column specifying the MIME type of CONTENT column.'),
  CONSTRAINT address_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Feature',
  DESCRIPTION 'Although ADDRESS is a feature type in CityGML, it is not stored in the FEATURE table. Instead, it is mapped to a dedicated ADDRESS table in the 3DCityDB relational schema. Address data is valuable in its own right and serves as foundation for specialized location services. Storing addresses in a separate table enables more efficient indexing, querying, and updates without impacting the FEATURE table, which may contain a large number of city objects and spatial features.'
);

--
-- Table FEATURE (Feature module)
--

CREATE TABLE IF NOT EXISTS feature (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each feature has a unique ID as the primary key assigned.'),
  objectclass_id                NUMBER(38) ANNOTATIONS (DESCRIPTION 'The OBJECTCLASS_ID enforces the type of the feature, such as building, window, city furniture, or tree. It serves as a foreign key to the OBJECTCLASS table, which lists all feature types supported by the 3DCityDB instance.'),
  objectid                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The OBJECTID column is a string identifier used to uniquely reference a feature within the database and datasets.'),
  identifier                    VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the feature across different systems and potentially multiple versions of the same real-world object.'),
  identifier_codespace          VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER_CODESPACE column indicates the authority responsible for maintaining the identifier.'),
  envelope                      SDO_GEOMETRY ANNOTATIONS (DESCRIPTION 'The spatial ENVELOPE column stores the minimal 3D rectangle that encloses the features. It can be used for efficient spatial queries of features.'),
  last_modification_date        TIMESTAMP WITH TIME ZONE ANNOTATIONS (DESCRIPTION 'The column LAST_MODIFICATION_DATE is specific to 3DCityDB and are not defined in CityGML. It stores the update history.'),
  updating_person               VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The column UPDATING_PERSON is specific to 3DCityDB and are not defined in CityGML. It stores the person responsible for a change.'),
  reason_for_update             VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The column REASON_FOR_UPDATE is specific to 3DCityDB and are not defined in CityGML. It specifies the reason for a change.'),
  lineage                       VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The column LINEAGE is specific to 3DCityDB and are not defined in CityGML. It specifies the origin of a feature.'),
  creation_date                 TIMESTAMP WITH TIME ZONE ANNOTATIONS (DESCRIPTION 'The CREATION_DATE refers to database time, indicating when the feature was inserted in the database.'),
  termination_date              TIMESTAMP WITH TIME ZONE ANNOTATIONS (DESCRIPTION 'The TERMINATION_DATE refers to database time, indicating when the feature was terminated in the database.'),
  valid_from                    TIMESTAMP WITH TIME ZONE ANNOTATIONS (DESCRIPTION 'The column VALID_FROM defines when the lifespan of a feature started.'),
  valid_to                      TIMESTAMP WITH TIME ZONE ANNOTATIONS (DESCRIPTION 'The column VALID_TO defines when the lifespan of a feature ended.'),
  CONSTRAINT feature_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Feature',
  DESCRIPTION 'The FEATURE table is the central table in the 3DCityDB v5 relational schema. It serves as the primary storage for all city objects and uniquely identifiable entities such as buildings, roads, or vegetation objects within your city model.'
);

-- Register SDO Metadata (Postprocessing)

-- INSERT INTO USER_SDO_GEOM_METADATA ( ... );

-- Create indices

-- CREATE INDEX feature_envelope_sdx ON feature ( envelope ) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2; -- Postprocessing
CREATE INDEX feature_objectclass_idx ON feature ( objectclass_id );
CREATE INDEX feature_objectid_idx ON feature ( objectid );
CREATE INDEX feature_identifier_idx ON feature ( identifier, identifier_codespace );
CREATE INDEX feature_creation_date_idx ON feature ( creation_date );
CREATE INDEX feature_termination_date_idx ON feature ( termination_date );
CREATE INDEX feature_valid_from_idx ON feature ( valid_from );
CREATE INDEX feature_valid_to_idx ON feature ( valid_to );

-- Activate temporal validity

ALTER TABLE feature ADD PERIOD FOR valid_period (valid_from, valid_to);

--
-- Table PROPERTY (Feature module)
--

CREATE TABLE IF NOT EXISTS property (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the PROPERTY table has a unique ID as the primary key assigned.'),
  feature_id                    NUMBER(38) ANNOTATIONS (DESCRIPTION 'The FEATURE_ID column contains relationships to other features stored in the FEATURE table.'),
  parent_id                     NUMBER(38) ANNOTATIONS (DESCRIPTION 'When complex types cannot be captured in a single row, they are instead represented hierarchically within the PROPERTY table. Nested attributes reference their parent attribute through the PARENT_ID foreign key, which links to the id primary key of the parent property.'),
  datatype_id                   NUMBER(38) ANNOTATIONS (DESCRIPTION 'The DATATYPE_ID column enforces the data type of the property and uses a type definition in the DATATYPE table.'),
  namespace_id                  NUMBER(38) ANNOTATIONS (DESCRIPTION 'The NAMESPACE_ID is a foreign key referencing a namespace from the NAMESPACE table.'),
  name                          VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The NAME column store the name of a property.'),
  val_int                       NUMBER(38) ANNOTATIONS (DESCRIPTION 'The value of an integer type property is stored in the VAL_INT column.'),
  val_double                    NUMBER(38,3) ANNOTATIONS (DESCRIPTION 'The value of a double type property is stored in the VAL_DOUBLE column.'),
  val_string                    VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The value of a string type property is stored in the VAL_STRING column.'),
  val_timestamp                 TIMESTAMP WITH TIME ZONE ANNOTATIONS (DESCRIPTION 'The value of a timestamp type property is stored in the VAL_TIMESTAMP column.'),
  val_uri                       VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The value of an uri type property is stored in the VAL_URI column.', LONG_FORM 'URI = Uniform Resource Identifier'),
  val_codespace                 VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The value of a codespace type property is stored in the VAL_CODESPACE column.'),
  val_uom                       VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The value of an uom type property is stored in the VAL_UOM column.', LONG_FORM 'UoM = Unit of Measure'),
  val_array                     JSON ANNOTATIONS (DESCRIPTION 'The value of an array type property is stored in the VAL_ARRAY column. Array values of attributes are represented as JSON arrays. Items can either be simple values, JSON objects, or JSON arrays themselves.'),
  val_lod                       VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The value of a lod type property is stored in the VAL_LOD column.', LONG_FORM 'Level of Detail'),
  val_geometry_id               NUMBER(38) ANNOTATIONS (DESCRIPTION 'Geometries are linked to features through the VAL_GEOMETRY_ID column, which references the GEOMETRY_DATA table. '),
  val_implicitgeom_id           NUMBER(38) ANNOTATIONS (DESCRIPTION 'Implicit geometries are referenced via the VAL_IMPLICITGEOM_ID foreign key and are also stored in the GEOMETRY_DATA table.'),
  val_implicitgeom_refpoint     SDO_GEOMETRY ANNOTATIONS (DESCRIPTION 'The VAL_IMPLICITGEOM_REFPOINT column stores the reference point needed to define the implicit representation of a feature.'),
  val_appearance_id             NUMBER(38) ANNOTATIONS (DESCRIPTION 'Appearance information is linked using the VAL_APPEARANCE_ID foreign key, referencing the APPEARANCE table.'),
  val_address_id                NUMBER(38) ANNOTATIONS (DESCRIPTION 'Address information is linked using the VAL_ADDRESS_ID foreign key, referencing the ADDRESS tables.'),
  val_feature_id                NUMBER(38) ANNOTATIONS (DESCRIPTION 'tbd'),
  val_relation_type             NUMBER(38) ANNOTATIONS (DESCRIPTION 'The VAL_RELATION_TYPE defines the type of the feature relationship as an integer.'),
  val_content                   CLOB ANNOTATIONS (DESCRIPTION 'The VAL_CONTENT column can hold arbitrary content as a character lob.'),
  val_content_mime_type         VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'The VAL_CONTENT_MIME_TYPE column specifies the MIME type of the CONTENT column.'),
  CONSTRAINT property_id_pk PRIMARY KEY ( id ) ENABLE,
  CONSTRAINT property_val_relation_type_chk CHECK (val_relation_type IN (0, 1)) ENABLE
) ANNOTATIONS (
  MODULE 'Feature',
  DESCRIPTION 'The PROPERTY table is the central place for storing feature properties in the 3DCityDB. Each property is recorded with its name, namespace, data type, and value.'
);

-- Create indices

CREATE INDEX property_feature_idx ON property ( feature_id );
CREATE INDEX property_parent_idx ON property ( parent_id );
CREATE INDEX property_namespace_idx ON property ( namespace_id );
CREATE INDEX property_name_idx ON property ( name );
CREATE INDEX property_val_int_idx ON property ( val_int );
CREATE INDEX property_val_double_idx ON property ( val_double );
CREATE INDEX property_val_string_idx ON property ( val_string );
CREATE INDEX property_val_timestamp_idx ON property ( val_timestamp );
CREATE INDEX property_val_uri_idx ON property ( val_uri );
CREATE INDEX property_val_uom_idx ON property ( val_uom );
CREATE INDEX property_val_lod_idx ON property ( val_lod );
CREATE INDEX property_val_geometry_idx ON property ( val_geometry_id );
CREATE INDEX property_val_implicitgeom_idx ON property ( val_implicitgeom_id );
CREATE INDEX property_val_appearance_idx ON property ( val_appearance_id );
CREATE INDEX property_val_address_idx ON property ( val_address_id );
CREATE INDEX property_val_feature_idx ON property ( val_feature_id );
CREATE INDEX property_val_relation_type_idx ON property ( val_relation_type );

--
-- Table GEOMETRY_DATA (Geometry module)
--

CREATE TABLE IF NOT EXISTS geometry_data (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the GEOMETRY table has a unique ID as the primary key assigned.'),
  geometry                      SDO_GEOMETRY ANNOTATIONS (DESCRIPTION 'The GEOMETRY column stores explicit feature geometries with real-world coordinates. All geometries must be stored with 3D coordinates and must be provided in the CRS defined for the 3DCityDB instance. To enable efficient spatial queries, the geometry column is indexed by default.', LONG_FORM 'CRS = Coordinate Reference System '),
  implicit_geometry             SDO_GEOMETRY ANNOTATIONS (DESCRIPTION 'Implicit geometries are stored in the IMPLICIT_GEOMETRY column. An implicit geometry is a template that is stored only once in the 3DCityDB and can be reused by multiple city objects. Implicit geometries use local coordinates, which allows them to serve as templates for multiple city objects in the database. Implicit geometries are typically not involved in spatial queries, so the implicit_geometry column does not have a spatial index by default.'),
  geometry_properties           JSON ANNOTATIONS (DESCRIPTION 'To preserve the ability to reuse and reference geometries and their parts, and to maintain the expressivity of CityGML geometry types, JSON-based metadata is stored alongside the geometry in the GEOMETRY_PROPERTIES column.'),
  feature_id                    NUMBER(38) ANNOTATIONS (DESCRIPTION 'The FEATURE_ID column references as a foreign key to the FEATURE table. For implicit geometries it is set to NULL.'),
  CONSTRAINT geometry_data_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Geometry',
  DESCRIPTION 'The GEOMETRY_DATA table serves as the central location for storing both explicit and implicit geometry data of the features in the 3DCityDB. It supports various geometry types, including points, lines, surface-based geometries, and volume geometries.'
);

-- Register SDO Metadata (Postprocessing)

-- INSERT INTO USER_SDO_GEOM_METADATA ( ... )

-- Create indices

-- CREATE INDEX geometry_data_sdx ON geometry_data ( geometry ) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;  -- Postprocessing
CREATE INDEX geometry_data_feature_idx ON geometry_data ( feature_id );

--
-- Table IMPLICIT_GEOMETRY (Geometry module)
--

CREATE TABLE IF NOT EXISTS implicit_geometry (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the IMPLICIT_GEOMETRY table has a unique ID as the primary key assigned. An implicit geometry is a template that is stored only once in the 3DCityDB and can be reused by multiple city objects. Examples of implicit geometries include 3D tree models, where different tree species and heights are represented as template geometries.'),
  objectid                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The OBJECTID column provides a unique identifier for the implicit geometry.'),
  mime_type                     VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The MIME_TYPE column contains the MIME type of the binary 3D model or external file.'),
  mime_type_codespace           VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The MIME_TYPE_CODESPACE column can store an optional code space for the MIME type, providing further context or classification.'),
  reference_to_library          VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The REFERENCE_TO_LIBRARY column is used if the 3D model is referenced through a URI, pointing to an external file or system.'),
  library_object                BLOB ANNOTATIONS (DESCRIPTION 'The LIBRARY_OBJECT column is used if the 3D model is stored as binary blob.'),
  relative_geometry_id          NUMBER(38) ANNOTATIONS (DESCRIPTION 'The RELATIVE_GEOMETRY_ID column is used if the 3D model is stored as geometries with local coordinates.'),
  CONSTRAINT implicit_geometry_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Geometry',
  DESCRIPTION 'The IMPLICIT_GEOMETRY table implements the concept of implicit geometries in CityGML.'
);

-- Create indices

CREATE INDEX implicit_geometry_objectid_idx ON implicit_geometry ( objectid );
CREATE INDEX implicit_geometry_relative_geometry_idx ON implicit_geometry ( relative_geometry_id );

--
-- Table TEX_IMAGE (Appearance module)
--

CREATE TABLE IF NOT EXISTS tex_image (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the TEX_IMAGE table has a unique ID as the primary key assigned.'),
  image_uri                     VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The IMAGE_URI column can store the file name or original path of the texture image.'),
  image_data                    BLOB ANNOTATIONS (DESCRIPTION 'Texture images for both ParameterizedTexture and GeoreferencedTexture can be stored as binary blobs in the IMAGE_DATA column. If the image should not be stored directly in the database, the IMAGE_DATA column is set to NULL.'),
  mime_type                     VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The MIME_TYPE column specifies the MIME type of the texture image, ensuring that the image can be processed correctly according to its format (e.g., image/png for a PNG image or image/jpeg for a JPEG image).'),
  mime_type_codespace           VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The MIME_TYPE_CODESPACE column can store an optional code space for the MIME type, providing further context or classification.'),
  CONSTRAINT tex_image_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Appearance',
  DESCRIPTION 'The TEX_IMAGE table stores texture images for both ParameterizedTexture and GeoreferencedTexture.'
);

--
-- Table APPEARANCE (Appearance module)
--

CREATE TABLE IF NOT EXISTS appearance (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY ANNOTATIONS (DESCRIPTION 'Each appearance has a unique ID as the primary key assigned.'),
  objectid                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The OBJECTID column is an identifier and used to uniquely reference an appearance object within the database and datasets.'),
  identifier                    VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the appearance across different systems and potentially multiple versions.'),
  identifier_codespace          VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER_CODESPACE indicates the authority responsible for maintaining the identifier.'),
  theme                         VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'Each appearance is associated with a specific theme for its surface data, stored as a string identifier in the THEME column.'),
  is_global                     NUMBER(1) ANNOTATIONS (DESCRIPTION 'To designate an appearance as global, the IS_GLOBAL column should be set to 1 (true), and both FEATURE_ID and IMPLICIT_GEOMETRY_ID should be set to NULL.'),
  feature_id                    NUMBER(38) ANNOTATIONS (DESCRIPTION 'The APPEARANCE table includes a FEATURE_ID column, providing a back-link to the FEATURE table.'),
  implicit_geometry_id          NUMBER(38) ANNOTATIONS (DESCRIPTION ' Appearances can be linked to an implicit geometry, which acts as a template geometry for multiple features. In this case, the appearance references the template in the IMPLICIT_GEOMETRY table via the IMPLICIT_GEOMETRY_ID column.'),
  CONSTRAINT appearance_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Appearance',
  DESCRIPTION 'The APPEARANCE table is the central component of the appearance module. Each record in the table represents a distinct appearance. Although Appearance is a feature type in CityGML, appearances are not stored in the FEATURE table. This is because appearances define visual and observable properties of surfaces, which are conceptually separate from the spatial features stored in the FEATURE table.'
);

-- Create indices

CREATE INDEX appearance_feature_idx ON appearance ( feature_id );
CREATE INDEX appearance_implicit_geometry_idx ON appearance ( implicit_geometry_id );

--
-- Table SURFACE_DATA (Appearance module)
--

CREATE TABLE IF NOT EXISTS surface_data (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the SURFACE_DATA table has a unique ID as the primary key assigned.'),
  objectid                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The OBJECTID column is an identifier and used to uniquely reference an surface data elements within the database and datasets.'),
  identifier                    VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the surface data elements across different systems and potentially multiple versions.'),
  identifier_codespace          VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'The IDENTIFIER_CODESPACE indicates the authority responsible for maintaining the identifier.'),
  is_front                      NUMBER(1) ANNOTATIONS (DESCRIPTION 'The IS_FRONT column indicates whether the surface data should be applied to the front (is_front = 1) or back face (is_front = 0) of the target surface geometry.'),
  objectclass_id                NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'The OBJECTCLASS_ID column enforces the type of surface data, acting as a foreign key to the OBJECTCLASS metadata table.'),
  x3d_shininess                 BINARY_DOUBLE ANNOTATIONS (DESCRIPTION 'The X3D_SHININESS column specifies the sharpness of the specular highlight (0..1).'),
  x3d_transparency              BINARY_DOUBLE ANNOTATIONS (DESCRIPTION 'The X3D_TRANSPARENCY column defines the transparency level of the material (0.0 = opaque, 1.0 = fully transparent).'),
  x3d_ambient_intensity         BINARY_DOUBLE ANNOTATIONS (DESCRIPTION 'The X3D_AMBIENT_INTENSITY column specifies the minimum percentage of diffuse color that is visible regardless of light sources (0..1).'),
  x3d_specular_color            VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The X3D_SPECULAR_COLOR column sets the color of the specular reflection of the material in Hex format (#RRGGBB).'),
  x3d_diffuse_color             VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The X3D_DIFFUSE_COLOR column defines the color of the material''s diffuse reflection in Hex format (#RRGGBB).'),
  x3d_emissive_color            VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The X3D_EMISSIVE_COLOR column specifies the color of the material''s emission (self-illumination) in Hex format (#RRGGBB).'),
  x3d_is_smooth                 NUMBER(1) ANNOTATIONS (DESCRIPTION 'The X3D_IS_SMOOTH column indicates whether the material is smooth (1) or faceted (0).'),
  tex_image_id                  NUMBER(38) ANNOTATIONS (DESCRIPTION 'The texture image is stored in the TEX_IMAGE table and linked through the TEX_IMAGE_ID foreign key, enabling multiple surface data to use the same texture image.'),
  tex_texture_type              VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The TEX_IMAGE_TYPE defines the type of texture (specific, typical, unknown).'),
  tex_wrap_mode                 VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The TEX_WRAP_MODE column specifies how textures are wrapped (none, wrap, mirror, clamp, border).'),
  tex_border_color              VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The TEX_BORDER_COLOR column defines the border color for the texture in Hex format (#RRGGBBAA).'),
  gt_orientation                JSON ANNOTATIONS (DESCRIPTION 'The GT_ORIENTATION column specifies the rotation and scaling of a georeferenced texture image as a 2x2 matrix, stored as JSON array in row-major order.'),
  gt_reference_point            SDO_GEOMETRY ANNOTATIONS (DESCRIPTION 'The GT_REFERENCE_POINT column defines the 2D point representing the center of the upper left image pixel in real-world space.'),
  CONSTRAINT surface_data_id_pk PRIMARY KEY ( id ) ENABLE,
  CONSTRAINT surface_data_is_front_chk CHECK (is_front IN (0, 1)) ENABLE
) ANNOTATIONS (
  MODULE 'Appearance',
  DESCRIPTION 'The SURFACE_DATA table stores surface data such as textures and colors. These surface data elements are linked to an appearance through the APPEAR_TO_SURFACE_DATA table, which establishes a many-to-many (n:m) relationship.'
);

-- Create indices

CREATE INDEX surface_data_tex_image_idx ON surface_data ( tex_image_id );
CREATE INDEX surface_data_objectclass_idx ON surface_data ( objectclass_id );

--
-- Table SURFACE_DATA_MAPPING (Appearance module)
--

CREATE TABLE IF NOT EXISTS surface_data_mapping (
  surface_data_id               NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'The SURFACE_DATA_MAPPING table assigns surface data to surface geometries by linking an entry from the SURFACE_DATA table to the target geometry in the GEOMETRY_DATA table using the foreign keys surface_data_id and geometry_data_id.'),
  geometry_data_id              NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'The SURFACE_DATA_MAPPING table assigns surface data to surface geometries by linking an entry from the SURFACE_DATA table to the target geometry in the GEOMETRY_DATA table using the foreign keys surface_data_id and geometry_data_id.'),
  material_mapping              JSON ANNOTATIONS (DESCRIPTION 'The material mappings are stored in the MATERIAL_MAPPING column.'),
  texture_mapping               JSON ANNOTATIONS (DESCRIPTION 'The texture mappings are stored in the TEXTURE_MAPPING column.'),
  world_to_texture_mapping      JSON ANNOTATIONS (DESCRIPTION 'The WORLD_TO_TEXTURE_MAPPING column contains matrix-based texture mappings.'),
  georeferenced_texture_mapping JSON ANNOTATIONS (DESCRIPTION 'The GEOREFERENCED_TEXTURE_MAPPING column contains texture mappings for geo-referenced textures '),
  CONSTRAINT surface_data_mapping_pk PRIMARY KEY ( geometry_data_id, surface_data_id ) ENABLE
) ANNOTATIONS (
  MODULE 'Appearance',
  DESCRIPTION 'The SURFACE_DATA_MAPPING table assigns surface data to surface geometries by linking an entry from the SURFACE_DATA table to the target geometry in the GEOMETRY_DATA table using the foreign keys SURFACE_DATA_ID and GEOMETRY_DATA_ID.'
);

-- Create indices

CREATE INDEX surface_data_mapping_geometry_data_idx ON surface_data_mapping ( geometry_data_id );
CREATE INDEX surface_data_mapping_surface_data_idx ON surface_data_mapping ( surface_data_id );

--
-- Table APPEAR_TO_SURFACE_DATA (Appearance module)
--

CREATE TABLE IF NOT EXISTS appear_to_surface_data (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the APPEAR_TO_SURFACE_DATA table has a unique ID as the primary key assigned.'),
  appearance_id                 NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'The APPEARANCE_ID column references the APPEARANCE table.'),
  surface_data_id               NUMBER(38) ANNOTATIONS (DESCRIPTION 'The SURFACE_DATA_ID column references the SURFACE_DATA table.'),
  CONSTRAINT appear_to_surface_data_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Appearance',
  DESCRIPTION 'These surface data elements are linked to an appearance through the APPEAR_TO_SURFACE_DATA table, which establishes a many-to-many (n:m) relationship.'
);

-- Create indices

CREATE INDEX appear_to_surface_data_appearance_idx ON appear_to_surface_data ( appearance_id );
CREATE INDEX appear_to_surface_data_surface_data_idx ON appear_to_surface_data ( surface_data_id );

--
-- Table CODELIST (Codelist module)
--

CREATE TABLE IF NOT EXISTS codelist (
  id                            NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'Each entry in the CODELIST table has a unique ID as the primary key assigned.'),
  codelist_type                 VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The CODELIST_TYPE column specifies the CityGML data type associated with the codelist.'),
  url                           VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'Each codelist is assigned a URL as a unique identifier, which is stored in the url column.'),
  mime_type                     VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'In case the url points to an existing external file, the MIME_TYPE column should specify the MIME type of the referenced codelist to ensure it can be processed correctly according to its format.'),
  CONSTRAINT codelist_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Codelist',
  DESCRIPTION 'The CODELIST table is used to register codelists.'
);

-- Create indices

CREATE INDEX codelist_codelist_type_idx ON codelist ( codelist_type );

--
-- Table CODELIST_ENTRY (Codelist module)
--

CREATE TABLE IF NOT EXISTS codelist_entry (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the CODELIST_ENTRY table has a unique ID as the primary key assigned.'),
	codelist_id                   NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'Each value is linked to a codelist through the CODELIST_ID foreign key, which references an entry in the CODELIST table.'),
	code                          VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The code for each permissible codelist value is stored in the CODE column.'),
	definition                    VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The code definition or description is stored in the DEFINITION column.'),
	CONSTRAINT codelist_entry_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Codelist',
  DESCRIPTION 'The CODELIST_ENTRY tables stores the values of the registered codelists.'
);

-- Create indices

CREATE INDEX codelist_entry_codelist_idx ON codelist_entry ( codelist_id );

--
-- Table ADE (Metadata module)
--

CREATE TABLE IF NOT EXISTS ade (
  id                            NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1) ANNOTATIONS (DESCRIPTION 'Each entry in the ADE table has a unique ID as the primary key assigned.'),
  name                          VARCHAR2(1000) NOT NULL ANNOTATIONS (DESCRIPTION 'tbd'),
  description                   VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'tbd'),
  version                       VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'tbd'),
  CONSTRAINT ade_id_pk PRIMARY KEY ( id ) ENABLE
) ANNOTATIONS (
  MODULE 'Metadata',
  DESCRIPTION 'The 3DCityDB v5 relational schema fully supports the CityGML Application Domain Extension (ADE) mechanism, enabling the storage of domain-specific data that extends beyond the predefined feature and data types of CityGML. The ADE table serves as a registry for all ADEs added to the database.',
  LONG_FORM 'Application Domain Extension'
);

--
-- Table DATABASE_SRS (Metadata module)
--

CREATE TABLE IF NOT EXISTS database_srs (
	srid                          NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'tbd'),
	srs_name                      VARCHAR2(1000) ANNOTATIONS (DESCRIPTION 'tbd'),
	CONSTRAINT database_srs_pk PRIMARY KEY ( srid ) ENABLE
) ANNOTATIONS (
  MODULE 'Metadata',
  DESCRIPTION 'The DATABASE_SRS table holds information about the Coordinate Reference System (CRS) of the 3DCityDB v5 instance. This CRS is defined during the database setup and applies to all geometries stored in the 3DCityDB (with a few exceptions, such as implicit geometries).'
);

--
-- Table NAMESPACE (Metadata module)
--

CREATE TABLE IF NOT EXISTS namespace (
  id                            NUMBER(38) ANNOTATIONS (DESCRIPTION 'Each entry in the NAMESPACE table has a unique ID as the primary key assigned.'),
  alias                         VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'Each namespace is associated with an ALIAS, which acts as a shortcut for the namespace and must be unique across all entries in the NAMESPACE table.'),
  namespace                     VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'The NAMESPACE column contains the namespace name.'),
  ade_id                        NUMBER(38) ANNOTATIONS (DESCRIPTION 'The list of namespaces in the NAMESPACE table is not exhaustive and can be extended with user-defined namespaces, typically from an ADE. In this case, the ade_id foreign key must reference the ADE registered in the ADE table that defines the namespace.'),
  CONSTRAINT namespace_id_pk PRIMARY KEY ( id ) ENABLE,
  CONSTRAINT namespace_alias_uk UNIQUE (alias) ENABLE
) ANNOTATIONS (
  MODULE 'Metadata',
  DESCRIPTION 'All types and properties in the 3DCityDB v5 must be associated with a namespace. This helps avoid name collisions and logically categorizes the content stored in the 3DCityDB v5 according to the CityGML 3.0 CM. Namespaces are recorded in the NAMESPACE table.'
);

--
-- Table OBJECTCLASS (Metadata module)
--

CREATE TABLE IF NOT EXISTS objectclass (
  id                            NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'Each entry in the OBJECTCLASS table has a unique ID as the primary key assigned.'),
  superclass_id                 NUMBER(38) ANNOTATIONS (DESCRIPTION 'Type inheritance is represented by the superclass_id column, which serves as a foreign key linking a subtype to its supertype. Transitive inheritance is supported, allowing feature types to form hierarchical structures.'),
  classname                     VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'Every feature type registered in the OBJECTCLASS table is uniquely identified by its name and namespace, which are stored in the CLASSNAME and NAMESPACE_ID columns.'),
  is_abstract                   NUMBER(1) ANNOTATIONS (DESCRIPTION 'The flag IS_ABSTRACT determines whether the feature type is abstract based on the corresponding feature class definition in the CityGML 3.0 CM.'),
  is_toplevel                   NUMBER(1) ANNOTATIONS (DESCRIPTION 'The flag IS_TOPLEVEL determines whether the feature type is a top-level feature based on the corresponding feature class definition in the CityGML 3.0 CM.'),
  ade_id                        NUMBER(38) ANNOTATIONS (DESCRIPTION 'The ADE_ID foreign key must point to the ADE registered in the ADE table that defines the feature type.'),
  namespace_id                  NUMBER(38) ANNOTATIONS (DESCRIPTION 'Every feature type registered in the OBJECTCLASS table is uniquely identified by its name and namespace, which are stored in the CLASSNAME and NAMESPACE_ID columns. The NAMESPACE_ID is a foreign key referencing a namespace from the NAMESPACE table.'),
  schema                        JSON ANNOTATIONS (DESCRIPTION 'The SCHEMA column contains a JSON-based schema mapping that provides additional details about the feature type and its mapping to the relational schema of the 3DCityDB v5, including feature properties and their data types.'),
  CONSTRAINT objectclass_id_pk PRIMARY KEY ( id ) ENABLE,
  CONSTRAINT objectclass_is_abstract_chk CHECK (is_abstract IN (0, 1)) ENABLE,
  CONSTRAINT objectclass_is_toplevel_chk CHECK (is_toplevel IN (0, 1)) ENABLE
) ANNOTATIONS (
  MODULE 'Metadata',
  DESCRIPTION 'The OBJECTCLASS table serves as the registry for all feature types supported by the 3DCityDB v5. Every feature stored in the FEATURE table must be associated with a feature type from this table. When setting up a new 3DCityDB instance, the table is populated with type definitions for all feature classes defined in the CityGML 3.0 CM, including abstract classes.'
);

-- Create indices

CREATE INDEX objectclass_superclass_idx ON objectclass ( superclass_id );

--
-- Table DATA_TYPE (Metadata module)
--

CREATE TABLE IF NOT EXISTS datatype (
  id                            NUMBER(38) NOT NULL ANNOTATIONS (DESCRIPTION 'Each entry in the DATATYPE table has a unique ID as the primary key assigned.'),
  supertype_id                  NUMBER(38) ANNOTATIONS (DESCRIPTION 'Type inheritance is represented by the SUPERTYPE_ID column, which serves as a foreign key linking a subtype to its supertype. Transitive inheritance is supported, allowing data types to form hierarchical structures.'),
  typename                      VARCHAR2(4000) ANNOTATIONS (DESCRIPTION 'Every data type registered in the DATATYPE table is uniquely identified by its name and namespace, which are stored in the TYPENAME and NAMESPACE_ID columns.'),
  is_abstract                   NUMBER(1) ANNOTATIONS (DESCRIPTION 'The flag is_abstract determines whether the data type is abstract, based on the corresponding definition in the CityGML 3.0 CM.'),
  ade_id                        NUMBER(38) ANNOTATIONS (DESCRIPTION 'Users can extend the DATATYPE table with custom data types, typically from an ADE. The ADE_ID foreign key must point to the ADE registered in the ADE table that defines the data type.'),
  namespace_id                  NUMBER(38) ANNOTATIONS (DESCRIPTION 'Every data type registered in the DATATYPE table is uniquely identified by its name and namespace, which are stored in the TYPENAME and NAMESPACE_ID columns. The namespace_id is a foreign key referencing a namespace from the NAMESPACE table.'),
  schema                        JSON ANNOTATIONS (DESCRIPTION 'Each data type defines the structure and format for storing property values in the database, including details on the property value format and the table and column where the value is stored. This schema mapping information is available in the schema column in JSON format.'),
  CONSTRAINT datatype_id_pk PRIMARY KEY ( id ) ENABLE,
  CONSTRAINT datatype_is_abstract_chk CHECK (is_abstract IN (0, 1)) ENABLE
) ANNOTATIONS (
  MODULE 'Metadata',
  DESCRIPTION 'The DATATYPE table serves as a registry for all data types supported by 3DCityDB v5. All feature properties stored in the PROPERTY table must reference their data type from this table. Its layout follows that of the OBJECTCLASS table. It is populated with type definitions for all data types defined in the CityGML 3.0 CM, including abstract types, during the setup of the 3DCityDB v5.'
);

-- Create indices

CREATE INDEX datatype_supertype_idx ON datatype ( supertype_id );

--
-- Add constraints
--

ALTER TABLE property ADD CONSTRAINT property_parent_fk FOREIGN KEY ( parent_id ) REFERENCES property ( id ) ON DELETE SET NULL;
ALTER TABLE property ADD CONSTRAINT property_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature ( id ) ON DELETE CASCADE;
ALTER TABLE property ADD CONSTRAINT property_val_geometry_fk FOREIGN KEY ( val_geometry_id ) REFERENCES geometry_data ( id ) ON DELETE CASCADE;
ALTER TABLE property ADD CONSTRAINT property_val_implicitgeom_fk FOREIGN KEY ( val_implicitgeom_id ) REFERENCES implicit_geometry ( id ) ON DELETE CASCADE;
ALTER TABLE property ADD CONSTRAINT property_val_appearance_fk FOREIGN KEY ( val_appearance_id ) REFERENCES appearance ( id ) ON DELETE CASCADE;
ALTER TABLE property ADD CONSTRAINT property_val_address_fk FOREIGN KEY ( val_address_id ) REFERENCES address ( id ) ON DELETE CASCADE;
ALTER TABLE property ADD CONSTRAINT property_val_feature_fk FOREIGN KEY ( val_feature_id ) REFERENCES feature ( id ) ON DELETE CASCADE;

ALTER TABLE geometry_data ADD CONSTRAINT geometry_data_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature ( id ) ON DELETE SET NULL;

ALTER TABLE implicit_geometry ADD CONSTRAINT implicit_geometry_relative_geometry_fk FOREIGN KEY ( relative_geometry_id ) REFERENCES geometry_data ( id ) ON DELETE CASCADE;

ALTER TABLE appearance ADD CONSTRAINT appearance_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature ( id ) ON DELETE SET NULL;
ALTER TABLE appearance ADD CONSTRAINT appearance_implicit_geometry_fk FOREIGN KEY ( implicit_geometry_id ) REFERENCES implicit_geometry ( id ) ON DELETE CASCADE;

ALTER TABLE surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY ( tex_image_id ) REFERENCES tex_image ( id ) ON DELETE SET NULL;
ALTER TABLE surface_data ADD CONSTRAINT surface_data_objectclass_fk FOREIGN KEY ( objectclass_id ) REFERENCES objectclass ( id ) ON DELETE SET NULL;

ALTER TABLE surface_data_mapping ADD CONSTRAINT surface_data_mapping_geometry_data_fk FOREIGN KEY ( geometry_data_id ) REFERENCES geometry_data ( id ) ON DELETE CASCADE;
ALTER TABLE surface_data_mapping ADD CONSTRAINT surface_data_mapping_surface_data_fk FOREIGN KEY ( surface_data_id ) REFERENCES surface_data ( id ) ON DELETE CASCADE;

ALTER TABLE appear_to_surface_data ADD CONSTRAINT appear_to_surface_data_appearance_fk FOREIGN KEY ( appearance_id ) REFERENCES appearance ( id ) ON DELETE CASCADE;
ALTER TABLE appear_to_surface_data ADD CONSTRAINT appear_to_surface_data_surface_data_fk FOREIGN KEY ( surface_data_id ) REFERENCES surface_data ( id ) ON DELETE CASCADE;

ALTER TABLE codelist_entry ADD CONSTRAINT codelist_entry_codelist_fk FOREIGN KEY ( codelist_id )  REFERENCES codelist ( id ) ON DELETE CASCADE;

ALTER TABLE namespace ADD CONSTRAINT namespace_ade_fk FOREIGN KEY ( ade_id ) REFERENCES ade ( id ) ON DELETE CASCADE;

ALTER TABLE objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY ( superclass_id ) REFERENCES objectclass ( id ) ON DELETE CASCADE;
ALTER TABLE objectclass ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY ( ade_id ) REFERENCES ade ( id ) ON DELETE CASCADE;
ALTER TABLE objectclass ADD CONSTRAINT objectclass_namespace_fk FOREIGN KEY ( namespace_id ) REFERENCES namespace ( id ) ON DELETE CASCADE;

ALTER TABLE datatype ADD CONSTRAINT datatype_superclass_fk FOREIGN KEY ( supertype_id ) REFERENCES datatype ( id ) ON DELETE CASCADE;
ALTER TABLE datatype ADD CONSTRAINT datatype_ade_fk FOREIGN KEY ( ade_id ) REFERENCES ade ( id );
ALTER TABLE datatype ADD CONSTRAINT datatype_namespace_fk FOREIGN KEY ( namespace_id ) REFERENCES namespace ( id ) ON DELETE CASCADE;

