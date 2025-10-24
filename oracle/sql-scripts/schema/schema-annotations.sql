ALTER TABLE address ANNOTATIONS (
  ADD
    MODULE 'Feature',
    DESCRIPTION 'Although ADDRESS is a feature type in CityGML, it is not stored in the FEATURE table. Instead, it is mapped to a dedicated ADDRESS table in the 3DCityDB relational schema. Address data is valuable in its own right and serves as foundation for specialized location services. Storing addresses in a separate table enables more efficient indexing, querying, and updates without impacting the FEATURE table, which may contain a large number of city objects and spatial features.'
);
ALTER TABLE address MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each address has a unique ID as the primary key assigned.'));
ALTER TABLE address MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'The OBJECTID column in the ADDRESS table is used to store a unique identifier for an address object.'));
ALTER TABLE address MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the address across different systems and potentially multiple versions of the same real-world object.'));
ALTER TABLE address MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER_CODESPACE column indicates the authority responsible for maintaining the identifier.'));
ALTER TABLE address MODIFY (street ANNOTATIONS (ADD DESCRIPTION 'The STREET column holds the name of the street or road where the address is located.'));
ALTER TABLE address MODIFY (house_number ANNOTATIONS (ADD DESCRIPTION 'The HOUSE_NUMBER column stores the building or house number.'));
ALTER TABLE address MODIFY (po_box ANNOTATIONS (ADD DESCRIPTION 'The PO_BOX column stores the post office box number associated with the address, if applicable.'));
ALTER TABLE address MODIFY (zip_code ANNOTATIONS (ADD DESCRIPTION 'The ZIP_CODE column holds the postal or ZIP code, helping to define the location more precisely.'));
ALTER TABLE address MODIFY (city ANNOTATIONS (ADD DESCRIPTION 'The CITY column stores the name of the city or locality.'));
ALTER TABLE address MODIFY (state ANNOTATIONS (ADD DESCRIPTION 'The STATE column contains the name of the state, province, or region.'));
ALTER TABLE address MODIFY (country ANNOTATIONS (ADD DESCRIPTION 'The COUNTRY column stores the name of the country in which the address resides.'));
ALTER TABLE address MODIFY (free_text ANNOTATIONS (ADD DESCRIPTION 'The FREE_TEXT column allows the storage of address information as unstructured text. It can be used to supplement or replace the other structured fields.'));
ALTER TABLE address MODIFY (multi_point ANNOTATIONS (ADD DESCRIPTION 'The MULTI_POINT column stores the geolocation of an address as multi-point geometry, enabling efficient spatial queries and reverse location services.'));
ALTER TABLE address MODIFY (content ANNOTATIONS (ADD DESCRIPTION 'If the original address information is more complex and needs to be preserved, the CONTENT column can be used to store the address data in its original format as a character blob.'));
ALTER TABLE address MODIFY (content_mime_type ANNOTATIONS (ADD DESCRIPTION 'The CONTENT_MIME_TYPE column specifying the MIME type of CONTENT column.'));

ALTER TABLE feature ANNOTATIONS (
  ADD
    MODULE 'Feature',
    DESCRIPTION 'The FEATURE table is the central table in the 3DCityDB v5 relational schema. It serves as the primary storage for all city objects and uniquely identifiable entities such as buildings, roads, or vegetation objects within your city model.'
);
ALTER TABLE feature MODIFY (id ANNOTATIONS (ADD DESCRIPTION  'Each feature has a unique ID as the primary key assigned.'));
ALTER TABLE feature MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'The OBJECTCLASS_ID enforces the type of the feature, such as building, window, city furniture, or tree. It serves as a foreign key to the OBJECTCLASS table, which lists all feature types supported by the 3DCityDB instance.'));
ALTER TABLE feature MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION  'The OBJECTID column is a string identifier used to uniquely reference a feature within the database and datasets.'));
ALTER TABLE feature MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the feature across different systems and potentially multiple versions of the same real-world object.'));
ALTER TABLE feature MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER_CODESPACE column indicates the authority responsible for maintaining the identifier.'));
ALTER TABLE feature MODIFY (envelope ANNOTATIONS (ADD DESCRIPTION 'The spatial ENVELOPE column stores the minimal 3D rectangle that encloses the features. It can be used for efficient spatial queries of features.'));
ALTER TABLE feature MODIFY (last_modification_date ANNOTATIONS (ADD DESCRIPTION  'The column LAST_MODIFICATION_DATE is specific to 3DCityDB and are not defined in CityGML. It stores the update history.'));
ALTER TABLE feature MODIFY (updating_person ANNOTATIONS (ADD DESCRIPTION 'The column UPDATING_PERSON is specific to 3DCityDB and are not defined in CityGML. It stores the person responsible for a change.'));
ALTER TABLE feature MODIFY (reason_for_update ANNOTATIONS (ADD DESCRIPTION 'The column REASON_FOR_UPDATE is specific to 3DCityDB and are not defined in CityGML. It specifies the reason for a change.'));
ALTER TABLE feature MODIFY (lineage ANNOTATIONS (ADD DESCRIPTION 'The column LINEAGE is specific to 3DCityDB and are not defined in CityGML. It specifies the origin of a feature.'));
ALTER TABLE feature MODIFY (creation_date ANNOTATIONS (ADD DESCRIPTION 'The CREATION_DATE refers to database time, indicating when the feature was inserted in the database.'));
ALTER TABLE feature MODIFY (termination_date ANNOTATIONS (ADD DESCRIPTION 'The TERMINATION_DATE refers to database time, indicating when the feature was terminated in the database.'));
ALTER TABLE feature MODIFY (valid_from ANNOTATIONS (ADD DESCRIPTION 'The column VALID_FROM defines when the lifespan of a feature started.'));
ALTER TABLE feature MODIFY (valid_to ANNOTATIONS (ADD DESCRIPTION 'The column VALID_TO defines when the lifespan of a feature ended.'));

ALTER TABLE property ANNOTATIONS (
  ADD
    MODULE 'Feature',
    DESCRIPTION 'The PROPERTY table is the central place for storing feature properties in the 3DCityDB. Each property is recorded with its name, namespace, data type, and value.'
);
ALTER TABLE property MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the PROPERTY table has a unique ID as the primary key assigned.'));
ALTER TABLE property MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'The FEATURE_ID column contains relationships to other features stored in the FEATURE table.'));
ALTER TABLE property MODIFY (parent_id ANNOTATIONS (ADD DESCRIPTION 'When complex types cannot be captured in a single row, they are instead represented hierarchically within the PROPERTY table. Nested attributes reference their parent attribute through the PARENT_ID foreign key, which links to the id primary key of the parent property.'));
ALTER TABLE property MODIFY (datatype_id ANNOTATIONS (ADD DESCRIPTION 'The DATATYPE_ID column enforces the data type of the property and uses a type definition in the DATATYPE table.'));
ALTER TABLE property MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'The NAMESPACE_ID is a foreign key referencing a namespace from the NAMESPACE table.'));
ALTER TABLE property MODIFY (name ANNOTATIONS (ADD DESCRIPTION 'The NAME column store the name of a property.'));
ALTER TABLE property MODIFY (val_int ANNOTATIONS (ADD DESCRIPTION 'The value of an integer type property is stored in the VAL_INT column.'));
ALTER TABLE property MODIFY (val_double ANNOTATIONS (ADD DESCRIPTION 'The value of a double type property is stored in the VAL_DOUBLE column.'));
ALTER TABLE property MODIFY (val_string ANNOTATIONS (ADD DESCRIPTION 'The value of a string type property is stored in the VAL_STRING column.'));
ALTER TABLE property MODIFY (val_timestamp ANNOTATIONS (ADD DESCRIPTION 'The value of a timestamp type property is stored in the VAL_TIMESTAMP column.'));
ALTER TABLE property MODIFY (val_uri ANNOTATIONS (ADD DESCRIPTION 'The value of an uri type property is stored in the VAL_URI column.', LONG_FORM 'URI = Uniform Resource Identifier'));
ALTER TABLE property MODIFY (val_codespace ANNOTATIONS (ADD DESCRIPTION 'The value of a codespace type property is stored in the VAL_CODESPACE column.'));
ALTER TABLE property MODIFY (val_uom ANNOTATIONS (ADD DESCRIPTION 'The value of an uom type property is stored in the VAL_UOM column.', LONG_FORM 'UoM = Unit of Measure'));
ALTER TABLE property MODIFY (val_array ANNOTATIONS (ADD DESCRIPTION 'The value of an array type property is stored in the VAL_ARRAY column. Array values of attributes are represented as JSON arrays. Items can either be simple values, JSON objects, or JSON arrays themselves.'));
ALTER TABLE property MODIFY (val_lod ANNOTATIONS (ADD DESCRIPTION 'The value of a lod type property is stored in the VAL_LOD column.', LONG_FORM 'Level of Detail'));
ALTER TABLE property MODIFY (val_geometry_id ANNOTATIONS (ADD DESCRIPTION 'Geometries are linked to features through the VAL_GEOMETRY_ID column, which references the GEOMETRY_DATA table. '));
ALTER TABLE property MODIFY (val_implicitgeom_id ANNOTATIONS (ADD DESCRIPTION 'Implicit geometries are referenced via the VAL_IMPLICITGEOM_ID foreign key and are also stored in the GEOMETRY_DATA table.'));
ALTER TABLE property MODIFY (val_implicitgeom_refpoint ANNOTATIONS (ADD DESCRIPTION 'The VAL_IMPLICITGEOM_REFPOINT column stores the reference point needed to define the implicit representation of a feature.'));
ALTER TABLE property MODIFY (val_appearance_id ANNOTATIONS (ADD DESCRIPTION 'Appearance information is linked using the VAL_APPEARANCE_ID foreign key, referencing the APPEARANCE table.'));
ALTER TABLE property MODIFY (val_address_id ANNOTATIONS (ADD DESCRIPTION 'Address information is linked using the VAL_ADDRESS_ID foreign key, referencing the ADDRESS tables.'));
ALTER TABLE property MODIFY (val_feature_id ANNOTATIONS (ADD DESCRIPTION 'tbd'));
ALTER TABLE property MODIFY (val_relation_type ANNOTATIONS (ADD DESCRIPTION 'The VAL_RELATION_TYPE defines the type of the feature relationship as an integer.'));
ALTER TABLE property MODIFY (val_content ANNOTATIONS (ADD DESCRIPTION 'The VAL_CONTENT column can hold arbitrary content as a character lob.'));
ALTER TABLE property MODIFY (val_content_mime_type ANNOTATIONS (ADD DESCRIPTION 'The VAL_CONTENT_MIME_TYPE column specifies the MIME type of the CONTENT column.'));


ALTER TABLE geometry_data ANNOTATIONS (
  ADD
    MODULE 'Geometry',
    DESCRIPTION 'The IMPLICIT_GEOMETRY table implements the concept of implicit geometries in CityGML.'
);
ALTER TABLE geometry_data MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the GEOMETRY table has a unique ID as the primary key assigned.'));
ALTER TABLE geometry_data MODIFY (geometry ANNOTATIONS (ADD DESCRIPTION 'The GEOMETRY column stores explicit feature geometries with real-world coordinates. All geometries must be stored with 3D coordinates and must be provided in the CRS defined for the 3DCityDB instance. To enable efficient spatial queries, the geometry column is indexed by default.', LONG_FORM 'CRS = Coordinate Reference System '));
ALTER TABLE geometry_data MODIFY (implicit_geometry ANNOTATIONS (ADD DESCRIPTION 'Implicit geometries are stored in the IMPLICIT_GEOMETRY column. An implicit geometry is a template that is stored only once in the 3DCityDB and can be reused by multiple city objects. Implicit geometries use local coordinates, which allows them to serve as templates for multiple city objects in the database. Implicit geometries are typically not involved in spatial queries, so the implicit_geometry column does not have a spatial index by default.'));
ALTER TABLE geometry_data MODIFY (geometry_properties ANNOTATIONS (ADD DESCRIPTION 'To preserve the ability to reuse and reference geometries and their parts, and to maintain the expressivity of CityGML geometry types, JSON-based metadata is stored alongside the geometry in the GEOMETRY_PROPERTIES column.'));
ALTER TABLE geometry_data MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'The FEATURE_ID column references as a foreign key to the FEATURE table. For implicit geometries it is set to NULL.'));

ALTER TABLE implicit_geometry ANNOTATIONS (
  ADD
    MODULE 'Geometry',
    DESCRIPTION 'The IMPLICIT_GEOMETRY table implements the concept of implicit geometries in CityGML.'
);
ALTER TABLE implicit_geometry MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the IMPLICIT_GEOMETRY table has a unique ID as the primary key assigned. An implicit geometry is a template that is stored only once in the 3DCityDB and can be reused by multiple city objects. Examples of implicit geometries include 3D tree models, where different tree species and heights are represented as template geometries.'));
ALTER TABLE implicit_geometry MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'The OBJECTID column provides a unique identifier for the implicit geometry.'));
ALTER TABLE implicit_geometry MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'The MIME_TYPE column contains the MIME type of the binary 3D model or external file.'));
ALTER TABLE implicit_geometry MODIFY (mime_type_codespace ANNOTATIONS (ADD DESCRIPTION 'The MIME_TYPE_CODESPACE column can store an optional code space for the MIME type, providing further context or classification.'));
ALTER TABLE implicit_geometry MODIFY (reference_to_library ANNOTATIONS (ADD DESCRIPTION 'The REFERENCE_TO_LIBRARY column is used if the 3D model is referenced through a URI, pointing to an external file or system.'));
ALTER TABLE implicit_geometry MODIFY (library_object ANNOTATIONS (ADD DESCRIPTION 'The LIBRARY_OBJECT column is used if the 3D model is stored as binary blob.'));
ALTER TABLE implicit_geometry MODIFY (relative_geometry_id ANNOTATIONS (ADD DESCRIPTION 'The RELATIVE_GEOMETRY_ID column is used if the 3D model is stored as geometries with local coordinates.'));

ALTER TABLE tex_image ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'The TEX_IMAGE table stores texture images for both ParameterizedTexture and GeoreferencedTexture.'
);
ALTER TABLE tex_image MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the TEX_IMAGE table has a unique ID as the primary key assigned.'));
ALTER TABLE tex_image MODIFY (image_uri ANNOTATIONS (ADD DESCRIPTION 'The IMAGE_URI column can store the file name or original path of the texture image.'));
ALTER TABLE tex_image MODIFY (image_data ANNOTATIONS (ADD DESCRIPTION 'Texture images for both ParameterizedTexture and GeoreferencedTexture can be stored as binary blobs in the IMAGE_DATA column. If the image should not be stored directly in the database, the IMAGE_DATA column is set to NULL.'));
ALTER TABLE tex_image MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'The MIME_TYPE column specifies the MIME type of the texture image, ensuring that the image can be processed correctly according to its format (e.g., image/png for a PNG image or image/jpeg for a JPEG image).'));
ALTER TABLE tex_image MODIFY (mime_type_codespace ANNOTATIONS (ADD DESCRIPTION 'The MIME_TYPE_CODESPACE column can store an optional code space for the MIME type, providing further context or classification.'));

ALTER TABLE appearance ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'The APPEARANCE table is the central component of the appearance module. Each record in the table represents a distinct appearance. Although Appearance is a feature type in CityGML, appearances are not stored in the FEATURE table. This is because appearances define visual and observable properties of surfaces, which are conceptually separate from the spatial features stored in the FEATURE table.'
);
ALTER TABLE appearance MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each appearance has a unique ID as the primary key assigned.'));
ALTER TABLE appearance MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'The OBJECTID column is an identifier and used to uniquely reference an appearance object within the database and datasets.'));
ALTER TABLE appearance MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the appearance across different systems and potentially multiple versions.'));
ALTER TABLE appearance MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER_CODESPACE indicates the authority responsible for maintaining the identifier.'));
ALTER TABLE appearance MODIFY (theme ANNOTATIONS (ADD DESCRIPTION 'Each appearance is associated with a specific theme for its surface data, stored as a string identifier in the THEME column.'));
ALTER TABLE appearance MODIFY (is_global ANNOTATIONS (ADD DESCRIPTION 'To designate an appearance as global, the IS_GLOBAL column should be set to 1 (true), and both FEATURE_ID and IMPLICIT_GEOMETRY_ID should be set to NULL.'));
ALTER TABLE appearance MODIFY (feature_id ANNOTATIONS (ADD DESCRIPTION 'The APPEARANCE table includes a FEATURE_ID column, providing a back-link to the FEATURE table.'));
ALTER TABLE appearance MODIFY (implicit_geometry_id ANNOTATIONS (ADD DESCRIPTION 'Appearances can be linked to an implicit geometry, which acts as a template geometry for multiple features. In this case, the appearance references the template in the IMPLICIT_GEOMETRY table via the IMPLICIT_GEOMETRY_ID column.'));

ALTER TABLE surface_data ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'The SURFACE_DATA table stores surface data such as textures and colors. These surface data elements are linked to an appearance through the APPEAR_TO_SURFACE_DATA table, which establishes a many-to-many (n:m) relationship.'
);
ALTER TABLE surface_data MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the SURFACE_DATA table has a unique ID as the primary key assigned.'));
ALTER TABLE surface_data MODIFY (objectid ANNOTATIONS (ADD DESCRIPTION 'The OBJECTID column is an identifier and used to uniquely reference an surface data elements within the database and datasets.'));
ALTER TABLE surface_data MODIFY (identifier ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER column provides an optional identifier to uniquely distinguish the surface data elements across different systems and potentially multiple versions.'));
ALTER TABLE surface_data MODIFY (identifier_codespace ANNOTATIONS (ADD DESCRIPTION 'The IDENTIFIER_CODESPACE indicates the authority responsible for maintaining the identifier.'));
ALTER TABLE surface_data MODIFY (is_front ANNOTATIONS (ADD DESCRIPTION 'The IS_FRONT column indicates whether the surface data should be applied to the front (is_front = 1) or back face (is_front = 0) of the target surface geometry.'));
ALTER TABLE surface_data MODIFY (objectclass_id ANNOTATIONS (ADD DESCRIPTION 'The OBJECTCLASS_ID column enforces the type of surface data, acting as a foreign key to the OBJECTCLASS metadata table.'));
ALTER TABLE surface_data MODIFY (x3d_shininess ANNOTATIONS (ADD DESCRIPTION 'The X3D_SHININESS column specifies the sharpness of the specular highlight (0..1).'));
ALTER TABLE surface_data MODIFY (x3d_transparency ANNOTATIONS (ADD DESCRIPTION 'The X3D_TRANSPARENCY column defines the transparency level of the material (0.0 = opaque, 1.0 = fully transparent).'));
ALTER TABLE surface_data MODIFY (x3d_ambient_intensity ANNOTATIONS (ADD DESCRIPTION 'The X3D_AMBIENT_INTENSITY column specifies the minimum percentage of diffuse color that is visible regardless of light sources (0..1).'));
ALTER TABLE surface_data MODIFY (x3d_specular_color ANNOTATIONS (ADD DESCRIPTION 'The X3D_SPECULAR_COLOR column sets the color of the specular reflection of the material in Hex format (#RRGGBB).'));
ALTER TABLE surface_data MODIFY (x3d_diffuse_color ANNOTATIONS (ADD DESCRIPTION 'The X3D_DIFFUSE_COLOR column defines the color of the material''s diffuse reflection in Hex format (#RRGGBB).'));
ALTER TABLE surface_data MODIFY (x3d_emissive_color ANNOTATIONS (ADD DESCRIPTION 'The X3D_EMISSIVE_COLOR column specifies the color of the material''s emission (self-illumination) in Hex format (#RRGGBB).'));
ALTER TABLE surface_data MODIFY ( x3d_is_smooth ANNOTATIONS (ADD DESCRIPTION 'The X3D_IS_SMOOTH column indicates whether the material is smooth (1) or faceted (0).'));
ALTER TABLE surface_data MODIFY (tex_image_id ANNOTATIONS (ADD DESCRIPTION 'The texture image is stored in the TEX_IMAGE table and linked through the TEX_IMAGE_ID foreign key, enabling multiple surface data to use the same texture image.'));
ALTER TABLE surface_data MODIFY (tex_texture_type ANNOTATIONS (ADD DESCRIPTION 'The TEX_IMAGE_TYPE defines the type of texture (specific, typical, unknown).'));
ALTER TABLE surface_data MODIFY (tex_wrap_mode ANNOTATIONS (ADD DESCRIPTION 'The TEX_WRAP_MODE column specifies how textures are wrapped (none, wrap, mirror, clamp, border).'));
ALTER TABLE surface_data MODIFY (tex_border_color ANNOTATIONS (ADD DESCRIPTION 'The TEX_BORDER_COLOR column defines the border color for the texture in Hex format (#RRGGBBAA).'));
ALTER TABLE surface_data MODIFY (gt_orientation ANNOTATIONS (ADD DESCRIPTION 'The GT_ORIENTATION column specifies the rotation and scaling of a georeferenced texture image as a 2x2 matrix, stored as JSON array in row-major order.'));
ALTER TABLE surface_data MODIFY (gt_reference_point ANNOTATIONS (ADD DESCRIPTION 'The GT_REFERENCE_POINT column defines the 2D point representing the center of the upper left image pixel in real-world space.'));

ALTER TABLE surface_data_mapping ANNOTATIONS (
ADD
    MODULE 'Appearance',
    DESCRIPTION 'The SURFACE_DATA_MAPPING table assigns surface data to surface geometries by linking an entry from the SURFACE_DATA table to the target geometry in the GEOMETRY_DATA table using the foreign keys SURFACE_DATA_ID and GEOMETRY_DATA_ID.'
);
ALTER TABLE surface_data_mapping MODIFY (surface_data_id ANNOTATIONS (ADD DESCRIPTION 'The SURFACE_DATA_MAPPING table assigns surface data to surface geometries by linking an entry from the SURFACE_DATA table to the target geometry in the GEOMETRY_DATA table using the foreign keys surface_data_id and geometry_data_id.'));
ALTER TABLE surface_data_mapping MODIFY (geometry_data_id ANNOTATIONS (ADD DESCRIPTION 'The SURFACE_DATA_MAPPING table assigns surface data to surface geometries by linking an entry from the SURFACE_DATA table to the target geometry in the GEOMETRY_DATA table using the foreign keys surface_data_id and geometry_data_id.'));
ALTER TABLE surface_data_mapping MODIFY (material_mapping ANNOTATIONS (ADD DESCRIPTION 'The material mappings are stored in the MATERIAL_MAPPING column.'));
ALTER TABLE surface_data_mapping MODIFY (texture_mapping ANNOTATIONS (ADD DESCRIPTION 'The texture mappings are stored in the TEXTURE_MAPPING column.'));
ALTER TABLE surface_data_mapping MODIFY (world_to_texture_mapping ANNOTATIONS (ADD DESCRIPTION 'The WORLD_TO_TEXTURE_MAPPING column contains matrix-based texture mappings.'));
ALTER TABLE surface_data_mapping MODIFY (georeferenced_texture_mapping ANNOTATIONS (ADD DESCRIPTION 'The GEOREFERENCED_TEXTURE_MAPPING column contains texture mappings for geo-referenced textures '));

ALTER TABLE appear_to_surface_data ANNOTATIONS (
  ADD
    MODULE 'Appearance',
    DESCRIPTION 'These surface data elements are linked to an appearance through the APPEAR_TO_SURFACE_DATA table, which establishes a many-to-many (n:m) relationship.'
);
ALTER TABLE appear_to_surface_data MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the APPEAR_TO_SURFACE_DATA table has a unique ID as the primary key assigned.'));
ALTER TABLE appear_to_surface_data MODIFY (appearance_id ANNOTATIONS (ADD DESCRIPTION 'The APPEARANCE_ID column references the APPEARANCE table.'));
ALTER TABLE appear_to_surface_data MODIFY (surface_data_id ANNOTATIONS (ADD DESCRIPTION 'The SURFACE_DATA_ID column references the SURFACE_DATA table.'));

ALTER TABLE codelist ANNOTATIONS (
  ADD
    MODULE 'Codelist',
    DESCRIPTION 'The CODELIST table is used to register codelists.'
);
ALTER TABLE codelist MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the CODELIST table has a unique ID as the primary key assigned.'));
ALTER TABLE codelist MODIFY (codelist_type ANNOTATIONS (ADD DESCRIPTION 'The CODELIST_TYPE column specifies the CityGML data type associated with the codelist.'));
ALTER TABLE codelist MODIFY (url ANNOTATIONS (ADD DESCRIPTION 'Each codelist is assigned a URL as a unique identifier, which is stored in the url column.'));
ALTER TABLE codelist MODIFY (mime_type ANNOTATIONS (ADD DESCRIPTION 'In case the url points to an existing external file, the MIME_TYPE column should specify the MIME type of the referenced codelist to ensure it can be processed correctly according to its format.'));

ALTER TABLE codelist_entry ANNOTATIONS (
  ADD
    MODULE 'Codelist',
    DESCRIPTION 'The CODELIST_ENTRY tables stores the values of the registered codelists.'
);
ALTER TABLE codelist_entry MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the CODELIST_ENTRY table has a unique ID as the primary key assigned.'));
ALTER TABLE codelist_entry MODIFY (codelist_id ANNOTATIONS (ADD DESCRIPTION 'Each value is linked to a codelist through the CODELIST_ID foreign key, which references an entry in the CODELIST table.'));
ALTER TABLE codelist_entry MODIFY (code ANNOTATIONS (ADD DESCRIPTION 'The code for each permissible codelist value is stored in the CODE column.'));
ALTER TABLE codelist_entry MODIFY (definition ANNOTATIONS (ADD DESCRIPTION 'The code definition or description is stored in the DEFINITION column.'));

ALTER TABLE ade ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'The 3DCityDB v5 relational schema fully supports the CityGML Application Domain Extension (ADE) mechanism, enabling the storage of domain-specific data that extends beyond the predefined feature and data types of CityGML. The ADE table serves as a registry for all ADEs added to the database.',
    LONG_FORM 'Application Domain Extension'
);
ALTER TABLE ade MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the ADE table has a unique ID as the primary key assigned.'));
ALTER TABLE ade MODIFY (name ANNOTATIONS (ADD DESCRIPTION 'tbd'));
ALTER TABLE ade MODIFY (description ANNOTATIONS (ADD DESCRIPTION 'tbd'));
ALTER TABLE ade MODIFY (version ANNOTATIONS (ADD DESCRIPTION 'tbd'));

ALTER TABLE database_srs ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'The DATABASE_SRS table holds information about the Coordinate Reference System (CRS) of the 3DCityDB v5 instance. This CRS is defined during the database setup and applies to all geometries stored in the 3DCityDB (with a few exceptions, such as implicit geometries).'
);
ALTER TABLE database_srs MODIFY (srid ANNOTATIONS (ADD DESCRIPTION 'tbd'));
ALTER TABLE database_srs MODIFY (srs_name ANNOTATIONS (ADD DESCRIPTION 'tbd'));

ALTER TABLE namespace ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'All types and properties in the 3DCityDB v5 must be associated with a namespace. This helps avoid name collisions and logically categorizes the content stored in the 3DCityDB v5 according to the CityGML 3.0 CM. Namespaces are recorded in the NAMESPACE table.'
);
ALTER TABLE namespace MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the NAMESPACE table has a unique ID as the primary key assigned.'));
ALTER TABLE namespace MODIFY (alias ANNOTATIONS (ADD DESCRIPTION 'Each namespace is associated with an ALIAS, which acts as a shortcut for the namespace and must be unique across all entries in the NAMESPACE table.'));
ALTER TABLE namespace MODIFY (namespace ANNOTATIONS (ADD DESCRIPTION 'The NAMESPACE column contains the namespace name.'));
ALTER TABLE namespace MODIFY (ade_id ANNOTATIONS (ADD DESCRIPTION 'The list of namespaces in the NAMESPACE table is not exhaustive and can be extended with user-defined namespaces, typically from an ADE. In this case, the ade_id foreign key must reference the ADE registered in the ADE table that defines the namespace.'));

ALTER TABLE objectclass ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'The OBJECTCLASS table serves as the registry for all feature types supported by the 3DCityDB v5. Every feature stored in the FEATURE table must be associated with a feature type from this table. When setting up a new 3DCityDB instance, the table is populated with type definitions for all feature classes defined in the CityGML 3.0 CM, including abstract classes.'
);
ALTER TABLE objectclass MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the OBJECTCLASS table has a unique ID as the primary key assigned.'));
ALTER TABLE objectclass MODIFY (superclass_id ANNOTATIONS (ADD DESCRIPTION 'Type inheritance is represented by the superclass_id column, which serves as a foreign key linking a subtype to its supertype. Transitive inheritance is supported, allowing feature types to form hierarchical structures.'));
ALTER TABLE objectclass MODIFY (classname ANNOTATIONS (ADD DESCRIPTION 'Every feature type registered in the OBJECTCLASS table is uniquely identified by its name and namespace, which are stored in the CLASSNAME and NAMESPACE_ID columns.'));
ALTER TABLE objectclass MODIFY (is_abstract ANNOTATIONS (ADD DESCRIPTION 'The flag IS_ABSTRACT determines whether the feature type is abstract based on the corresponding feature class definition in the CityGML 3.0 CM.'));
ALTER TABLE objectclass MODIFY (is_toplevel ANNOTATIONS (ADD DESCRIPTION 'The flag IS_TOPLEVEL determines whether the feature type is a top-level feature based on the corresponding feature class definition in the CityGML 3.0 CM.'));
ALTER TABLE objectclass MODIFY (ade_id ANNOTATIONS (ADD DESCRIPTION 'The ADE_ID foreign key must point to the ADE registered in the ADE table that defines the feature type.'));
ALTER TABLE objectclass MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'Every feature type registered in the OBJECTCLASS table is uniquely identified by its name and namespace, which are stored in the CLASSNAME and NAMESPACE_ID columns. The NAMESPACE_ID is a foreign key referencing a namespace from the NAMESPACE table.'));
ALTER TABLE objectclass MODIFY (schema ANNOTATIONS (ADD DESCRIPTION 'The SCHEMA column contains a JSON-based schema mapping that provides additional details about the feature type and its mapping to the relational schema of the 3DCityDB v5, including feature properties and their data types.'));

ALTER TABLE datatype ANNOTATIONS (
  ADD
    MODULE 'Metadata',
    DESCRIPTION 'The DATATYPE table serves as a registry for all data types supported by 3DCityDB v5. All feature properties stored in the PROPERTY table must reference their data type from this table. Its layout follows that of the OBJECTCLASS table. It is populated with type definitions for all data types defined in the CityGML 3.0 CM, including abstract types, during the setup of the 3DCityDB v5.'
);
ALTER TABLE datatype MODIFY (id ANNOTATIONS (ADD DESCRIPTION 'Each entry in the DATATYPE table has a unique ID as the primary key assigned.'));
ALTER TABLE datatype MODIFY (supertype_id ANNOTATIONS (ADD DESCRIPTION 'Type inheritance is represented by the SUPERTYPE_ID column, which serves as a foreign key linking a subtype to its supertype. Transitive inheritance is supported, allowing data types to form hierarchical structures.'));
ALTER TABLE datatype MODIFY (typename ANNOTATIONS (ADD DESCRIPTION 'Every data type registered in the DATATYPE table is uniquely identified by its name and namespace, which are stored in the TYPENAME and NAMESPACE_ID columns.'));
ALTER TABLE datatype MODIFY (is_abstract ANNOTATIONS (ADD DESCRIPTION 'The flag is_abstract determines whether the data type is abstract, based on the corresponding definition in the CityGML 3.0 CM.'));
ALTER TABLE datatype MODIFY (ade_id ANNOTATIONS (ADD DESCRIPTION 'Users can extend the DATATYPE table with custom data types, typically from an ADE. The ADE_ID foreign key must point to the ADE registered in the ADE table that defines the data type.'));
ALTER TABLE datatype MODIFY (namespace_id ANNOTATIONS (ADD DESCRIPTION 'Every data type registered in the DATATYPE table is uniquely identified by its name and namespace, which are stored in the TYPENAME and NAMESPACE_ID columns. The namespace_id is a foreign key referencing a namespace from the NAMESPACE table.'));
ALTER TABLE datatype MODIFY (schema ANNOTATIONS (ADD DESCRIPTION 'Each data type defines the structure and format for storing property values in the database, including details on the property value format and the table and column where the value is stored. This schema mapping information is available in the schema column in JSON format.'));

COMMIT;