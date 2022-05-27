-- TABLES CREATION

-- create tables_ INHERITED FROM 3DCITYDB v4 (not dropped tables)

CREATE  TABLE citydb.aggregation_info ( 
	child_id             integer  NOT NULL  ,
	parent_id            integer  NOT NULL  ,
	join_table_or_column_name varchar(30)  NOT NULL  ,
	min_occurs           integer    ,
	max_occurs           integer    ,
	is_composite         numeric    ,
	CONSTRAINT aggregation_info_pk PRIMARY KEY ( child_id, parent_id, join_table_or_column_name )
 );

CREATE  TABLE citydb.schema_to_objectclass ( 
	schema_id            integer  NOT NULL  ,
	objectclass_id       integer  NOT NULL  ,
	CONSTRAINT schema_to_objectclass_pk PRIMARY KEY ( schema_id, objectclass_id )
 );

CREATE  TABLE citydb.schema_referencing ( 
	referencing_id       integer  NOT NULL  ,
	referenced_id        integer  NOT NULL  ,
	CONSTRAINT schema_referencing_pk PRIMARY KEY ( referenced_id, referencing_id )
 );

CREATE  TABLE citydb."schema" ( 
	id                   SERIAL,
	is_ade_root          numeric  NOT NULL  ,
	citygml_version      varchar(50)  NOT NULL  ,
	xml_namespace_uri    varchar(4000)  NOT NULL  ,
	xml_namespace_prefix varchar(50)  NOT NULL  ,
	xml_schema_location  varchar(4000)    ,
	xml_schemafile       bytea    ,
	xml_schemafile_type  varchar(256)    ,
	ade_id               integer    ,
	CONSTRAINT schema_pk PRIMARY KEY ( id )
 );

CREATE  TABLE citydb.ade ( 
	id                   SERIAL  ,
	adeid                varchar(256)  NOT NULL  ,
	name                 varchar(1000)  NOT NULL  ,
	description          varchar(4000)    ,
	"version"            varchar(50)    ,
	db_prefix            varchar(10)  NOT NULL  ,
	xml_schemamapping_file text    ,
	drop_db_script       text    ,
	creation_date        timestamptz    ,
	creation_person      varchar(256)    ,
	CONSTRAINT ade_pk PRIMARY KEY ( id )
 );

CREATE  TABLE citydb.objectclass ( 
	id                   integer  NOT NULL  ,
	ade_id               integer    ,
	baseclass_id         integer    ,
	classname            varchar(256)    ,
	is_ade_class         numeric    ,
	is_toplevel          numeric    ,
	superclass_id        integer    ,
	tablename            varchar(30)    ,
	CONSTRAINT objectclass_pk PRIMARY KEY ( id )
 );

CREATE  TABLE citydb.tex_image ( 
	id                   BIGSERIAL  ,
	tex_image_uri        varchar(4000)    ,
	tex_image_data       bytea    ,
	tex_mime_type        varchar(256)    ,
	tex_mime_type_codespace varchar(4000)    ,
	CONSTRAINT tex_image_pk PRIMARY KEY ( id )
 );

 CREATE  TABLE citydb.textureparam ( 
	surface_geometry_id  bigint  NOT NULL  ,
	is_texture_parametrization numeric    ,
	world_to_texture     varchar(1000)    ,
	texture_coordinates  geometry(Polygon)    ,
	surface_data_id      bigint  NOT NULL  ,
	CONSTRAINT textureparam_pk PRIMARY KEY ( surface_geometry_id, surface_data_id )
 );

CREATE  TABLE citydb.implicit_geometry ( 
	id                   BIGSERIAL ,
	mime_type            varchar(256)    ,
	reference_to_library varchar(4000)    ,
	library_object       bytea    ,
	relative_brep_id     bigint    ,
	relative_other_geom  geometry(GeometryZ)    ,
	CONSTRAINT implicit_geometry_pk PRIMARY KEY ( id )
 );

CREATE  TABLE citydb.surface_data ( 
	id                   BIGSERIAL  ,
	gmlid                varchar(256)    ,
	gmlid_codespace      varchar(1000)    ,
	name                 varchar(1000)    ,
	name_codespace       varchar(4000)    ,
	description          varchar(4000)    ,
	is_front             numeric    ,
	objectclass_id       integer  NOT NULL  ,
	x3d_shininess        double precision    ,
	x3d_transparency     double precision    ,
	x3d_ambient_intensity double precision    ,
	x3d_specular_color   varchar(256)    ,
	x3d_diffuse_color    varchar(256)    ,
	x3d_emissive_color   varchar(256)    ,
	x3d_is_smooth        numeric    ,
	tex_image_id         bigint    ,
	tex_texture_type     varchar(256)    ,
	tex_wrap_mode        varchar(256)    ,
	tex_border_color     varchar(256)    ,
	gt_prefer_worldfile  numeric    ,
	gt_orientation       varchar(256)    ,
	gt_reference_point   geometry(Point)   ,
	CONSTRAINT surface_data_pk PRIMARY KEY ( id )
 );

CREATE TABLE IF NOT EXISTS citydb.surface_geometry
(
    id BIGSERIAL,
    gmlid character varying(256) COLLATE pg_catalog."default",
    gmlid_codespace character varying(1000) COLLATE pg_catalog."default",
    parent_id bigint,
    root_id bigint,
    is_solid numeric,
    is_composite numeric,
    is_triangulated numeric,
    is_xlink numeric,
    is_reverse numeric,
    solid_geometry geometry(PolyhedralSurfaceZ),
    geometry geometry(PolygonZ),
    implicit_geometry geometry(PolygonZ),
    cityobject_id bigint,
    CONSTRAINT surface_geometry_pk PRIMARY KEY (id)
        WITH (FILLFACTOR=100)
);

CREATE TABLE citydb.grid_coverage ( 
	id                   BIGSERIAL  ,
	rasterproperty       raster    ,
	CONSTRAINT grid_coverage_pk PRIMARY KEY ( id )
 );

CREATE TABLE citydb.database_srs ( 
	srid                 integer  NOT NULL  ,
	gml_srs_name         varchar(1000)    ,
	CONSTRAINT database_srs_pk PRIMARY KEY ( srid )
 );

CREATE TABLE citydb.cityobject_member ( 
	citymodel_id         bigint  NOT NULL  ,
	cityobject_id        bigint  NOT NULL  ,
	CONSTRAINT cityobject_member_pk PRIMARY KEY ( citymodel_id, cityobject_id )
 );

CREATE TABLE citydb.citymodel ( 
	id                   BIGSERIAL  ,
	gmlid                varchar(256)    ,
	gmlid_codespace      varchar(1000)    ,
	name                 varchar(1000)    ,
	name_codespace       varchar(4000)    ,
	description          varchar(4000)    ,
	envelope             geometry(PolygonZ)    ,
	creation_date        timestamptz    ,
	termination_date     timestamptz    ,
	last_modification_date timestamptz    ,
	updating_person      varchar(256)    ,
	reason_for_update    varchar(4000)    ,
	lineage              varchar(256)    ,
	CONSTRAINT citymodel_pk PRIMARY KEY ( id )
 );

CREATE TABLE citydb.appear_to_surface_data ( 
	surface_data_id      bigint  NOT NULL  ,
	appearance_id        bigint  NOT NULL  ,
	CONSTRAINT appear_to_surface_data_pk PRIMARY KEY ( surface_data_id, appearance_id )
 );

CREATE TABLE citydb.appearance ( 
	id                   BIGSERIAL  ,
	gmlid                varchar(256)    ,
	gmlid_codespace      varchar(1000)    ,
	name                 varchar(1000)    ,
	name_codespace       varchar(4000)    ,
	description          varchar(4000)    ,
	theme                varchar(256)    ,
	citymodel_id         bigint    ,
	cityobject_id        bigint    ,
	CONSTRAINT appearance_pk PRIMARY KEY ( id )
 );


-- create tables_ ADDED IN 3DCITYDB v5 (all new tables)

CREATE TABLE citydb.feature ( 
	id                   BIGSERIAL PRIMARY KEY ,
	objectclass_id       integer  NOT NULL ,
	is_toplevel          boolean   ,
	space_or_boundary_type varchar(256)   ,
	gmlid                varchar(256)   ,
	gmlid_namespace      varchar(256)   ,
	identifier           varchar(256)   ,
	identifier_namespace varchar(256)   ,
	envelope             geometry   ,
	last_modification_date timestamptz(6)   ,
	updating_person      varchar(256)   ,
	reason_for_update    varchar(4000)   ,
	lineage              varchar(256)   ,
	xml_source           text   ,
	creation_date        timestamptz(6)   ,
	termination_date     timestamptz(6)   ,
	valid_from           timestamptz(6)   ,
	valid_to             timestamptz(6)    
 );

CREATE TABLE citydb.feature_relation ( 
	id                   BIGSERIAL PRIMARY KEY ,
	from_feature         bigint  NOT NULL ,
	to_feature           bigint  NOT NULL ,
	namespace            varchar(256)   ,
	name                 varchar(256)   ,
	relationtype         varchar(256)   ,
	relationtype_codelist varchar(256)   
 );

CREATE TABLE citydb.codelist ( 
	id                   BIGSERIAL PRIMARY KEY ,
	codelist_type        varchar(256)   ,
	url                  varchar(4000)   ,
	mimetype             varchar(256)   ,
	CONSTRAINT codelist_codelist_type_unique UNIQUE ( codelist_type ) 
 );

CREATE TABLE citydb.codelist_entry ( 
	id                   BIGSERIAL PRIMARY KEY ,
	codelist_id          INTEGER  NOT NULL ,
	code                 varchar(256)   ,
	definition           varchar(256)   
 );


CREATE TABLE citydb.property 	
			( 
			id                   BIGSERIAL PRIMARY KEY ,
			feature_id           bigint   ,
			relation_id          bigint   ,
			parent_id            bigint   ,
			root_id              bigint   ,
			namespace            varchar(256)   ,
			name                 varchar(256)   ,
			index_number         integer   ,
			datatype             varchar   ,
			data_valtype         integer   ,
			val_int              bigint   ,
			val_double			 numeric ,
			val_string           varchar(256)   ,
			val_date             timestamptz   ,
			val_uri              varchar(4000)   ,
			val_geometry         geometry   ,
			val_surface_geometry bigint   ,
			val_implicitgeom_id	 bigint   ,
			val_implicitgeom_refpoint geometry(PointZ),
			val_implicitgeom_transform varchar(1000),
			val_grid_coverage	 bigint ,
			val_appearance       bigint   ,
			val_dynamizer        bigint   ,
			val_feature			 bigint ,
			val_feature_is_xlink int,
			val_code         	 varchar(256)   ,
			val_codelist         integer   ,
			val_uom              varchar   ,
			val_complex          json   ,
			val_xml              xml
		 );

-- CONSTRAINTS

-- add constraints_ FOR TABLES INHERITED FROM 3DCITYDB v4 (not dropped tables)

ALTER TABLE citydb.aggregation_info ADD CONSTRAINT aggregation_info_fk1 FOREIGN KEY ( child_id ) REFERENCES citydb.objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.aggregation_info ADD CONSTRAINT aggregation_info_fk2 FOREIGN KEY ( parent_id ) REFERENCES citydb.objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_to_objectclass ADD CONSTRAINT schema_to_objectclass_fk2 FOREIGN KEY ( objectclass_id ) REFERENCES citydb.objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_to_objectclass ADD CONSTRAINT schema_to_objectclass_fk1 FOREIGN KEY ( schema_id ) REFERENCES citydb."schema"( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb."schema" ADD CONSTRAINT schema_ade_fk FOREIGN KEY ( ade_id ) REFERENCES citydb.ade( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_referencing ADD CONSTRAINT schema_referencing_fk1 FOREIGN KEY ( referencing_id ) REFERENCES citydb."schema"( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_referencing ADD CONSTRAINT schema_referencing_fk2 FOREIGN KEY ( referenced_id ) REFERENCES citydb."schema"( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY ( ade_id ) REFERENCES citydb.ade( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_baseclass_fk FOREIGN KEY ( baseclass_id ) REFERENCES citydb.objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY ( superclass_id ) REFERENCES citydb.objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.textureparam ADD CONSTRAINT texparam_surface_data_fk FOREIGN KEY ( surface_data_id ) REFERENCES citydb.surface_data( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.textureparam ADD CONSTRAINT texparam_geom_fk FOREIGN KEY ( surface_geometry_id ) REFERENCES citydb.surface_geometry( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.implicit_geometry ADD CONSTRAINT implicit_geom_brep_fk FOREIGN KEY ( relative_brep_id ) REFERENCES citydb.surface_geometry( id )  ON UPDATE CASCADE;

ALTER TABLE citydb.surface_data ADD CONSTRAINT surface_data_objclass_fk FOREIGN KEY ( objectclass_id ) REFERENCES citydb.objectclass( id )  ON UPDATE CASCADE;

ALTER TABLE citydb.surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY ( tex_image_id ) REFERENCES citydb.tex_image( id )  ON UPDATE CASCADE;

ALTER TABLE citydb.cityobject_member ADD CONSTRAINT cityobject_member_fk1 FOREIGN KEY ( citymodel_id ) REFERENCES citydb.citymodel( id )  ON UPDATE CASCADE;

ALTER TABLE citydb.appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk1 FOREIGN KEY ( appearance_id ) REFERENCES citydb.appearance( id )  ON UPDATE CASCADE;

ALTER TABLE citydb.appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk FOREIGN KEY ( surface_data_id ) REFERENCES citydb.surface_data( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.appearance ADD CONSTRAINT appearance_citymodel_fk FOREIGN KEY ( citymodel_id ) REFERENCES citydb.citymodel( id )  ON UPDATE CASCADE;

ALTER TABLE citydb.surface_geometry ADD CONSTRAINT surface_geom_cityobj_fk FOREIGN KEY (cityobject_id)
        REFERENCES citydb.feature (id) MATCH FULL
        ON UPDATE CASCADE
        ON DELETE NO ACTION;

ALTER TABLE citydb.surface_geometry ADD CONSTRAINT surface_geom_parent_fk FOREIGN KEY (parent_id)
        REFERENCES citydb.surface_geometry (id) MATCH FULL
        ON UPDATE CASCADE
        ON DELETE NO ACTION;

ALTER TABLE citydb.surface_geometry ADD CONSTRAINT surface_geom_root_fk FOREIGN KEY (root_id)
        REFERENCES citydb.surface_geometry (id) MATCH FULL
        ON UPDATE CASCADE
        ON DELETE NO ACTION;

-- add constraints_ FOR TABLES ADDED IN 3DCITYDB v5 (all new tables)

ALTER TABLE citydb.feature 
    ADD CONSTRAINT feature_objectclass_fk 
        FOREIGN KEY ( objectclass_id ) 
        REFERENCES citydb.objectclass( id )  
        ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.feature
    ADD CONSTRAINT feature_gmlid_unique 
        UNIQUE (gmlid);

ALTER TABLE citydb.feature_relation 
	ADD CONSTRAINT feature_relation_to_feature_fk 
		FOREIGN KEY ( to_feature ) 
		REFERENCES citydb.feature( id )  
		ON UPDATE CASCADE;

ALTER TABLE citydb.feature_relation 
	ADD CONSTRAINT feature_to_feature_relation_fk 
		FOREIGN KEY ( from_feature ) 
		REFERENCES citydb.feature( id )  
		ON UPDATE CASCADE;

ALTER TABLE citydb.feature_relation
    ADD CONSTRAINT feature_relation_from_to_namespace_name_unique 
    	UNIQUE (from_feature, to_feature, namespace, name);

ALTER TABLE citydb.codelist_entry 
	ADD CONSTRAINT fk_codelist_entry_codelist 
	FOREIGN KEY ( codelist_id ) 
	REFERENCES citydb.codelist( id )  
	ON UPDATE CASCADE
	ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.codelist_entry
    ADD CONSTRAINT unique_codelist_entry_codelist_id_code 
    UNIQUE (codelist_id, code);

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_feature_fk 
		FOREIGN KEY ( feature_id ) 
		REFERENCES citydb.feature( id )  
		ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_codelist_fk 
		FOREIGN KEY ( val_codelist ) 
		REFERENCES citydb.codelist( id )  
		ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_surface_geometry_fk 
		FOREIGN KEY ( val_surface_geometry ) 
		REFERENCES citydb.surface_geometry( id )  
		ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_implicitgeom_id_fk 
		FOREIGN KEY ( val_implicitgeom_id ) 
		REFERENCES citydb.implicit_geometry( id )  
		ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_appearance_fk 
		FOREIGN KEY ( val_appearance ) 
		REFERENCES citydb.appearance( id )  
		ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_val_feature_fk 
		FOREIGN KEY ( val_feature ) 
		REFERENCES citydb.feature( id )  
		ON UPDATE CASCADE;

ALTER TABLE IF EXISTS citydb.property
    ADD CONSTRAINT property_unique_feature_id_namespace_name_index 
    	UNIQUE (feature_id, namespace, name, index_number);

-- COMMENTS
-- create comments_ FOR TABLES INHERITED FROM 3DCITYDB v4 (not dropped tables)

-- create comments_ FOR TABLES ADDED IN 3DCITYDB v5 (all new tables)

COMMENT 
    ON TABLE citydb.feature 
        IS 'added at 3DCityDB Version 5.0 for CityGML 3.0';

COMMENT 
    ON COLUMN citydb.feature.id
        IS 'Primary key / surrogate';

COMMENT ON COLUMN citydb.feature.objectclass_id
    IS 'Foreign key to OBJECTCLASS(id) - CityGML feature type ';

COMMENT ON COLUMN citydb.feature.is_toplevel
    IS 'true, if this feature is a toplevel feature';

COMMENT ON COLUMN citydb.feature.space_or_boundary_type
    IS 'name of the most specific CityGML abstract space or space boundary class (e.g. AbstractOccupiedSpace)';

COMMENT ON COLUMN citydb.feature.envelope
    IS 'Bounding volume of the feature (if it has a geometry)';

COMMENT ON COLUMN citydb.feature.last_modification_date
    IS 'Adopted from 3DCityDB Version 4';

COMMENT ON COLUMN citydb.feature.updating_person
    IS 'Adopted from 3DCityDB Version 4';

COMMENT ON COLUMN citydb.feature.reason_for_update
    IS 'Adopted from 3DCityDB Version 4';

COMMENT ON COLUMN citydb.feature.lineage
    IS 'Adopted from 3DCityDB Version 4';

COMMENT ON COLUMN citydb.feature.xml_source
    IS 'Adopted from 3DCityDB Version 4 - has this been used in the past?';

COMMENT ON TABLE citydb.feature_relation IS 'added at 3DCityDB Version 5.0 for CityGML 3.0';

COMMENT ON TABLE citydb.codelist IS 'added at 3DCityDB Version 5.0 for CityGML 3.0';

COMMENT ON TABLE citydb.codelist_entry IS 'added at 3DCityDB Version 5.0 for CityGML 3.0';

COMMENT ON TABLE citydb.property IS 'added at 3DCityDB Version 5.0 for CityGML 3.0';

COMMENT ON COLUMN citydb.property.id
    IS 'Primary key / surrogate';

COMMENT ON COLUMN citydb.property.feature_id
    IS 'Foreign key to FEATURE(id) - if the property belongs to a feature_relation, then this attribute is NULL';

COMMENT ON COLUMN citydb.property.parent_id
    IS 'Foreign key to PROPERTY(id). If this property belongs to a named set of properties (as supported for generic attributes), this attribute links to the parent group';

COMMENT ON COLUMN citydb.property.root_id
    IS 'Foreign key to PROPERTY(id). Points to the id of the root property entry (only relevant when using nested properties as supported by generic attributes)';

COMMENT ON COLUMN citydb.property.namespace
    IS 'CityGML 3.0 namespace in which this property is defined';

COMMENT ON COLUMN citydb.property.name
    IS 'Property name (or should we put qualified names here? E.g. core:relativeToWater or core:lod2Solid)';

COMMENT ON COLUMN citydb.property.index_number
    IS 'Index number (if multiple properties with the same name are stored and the order should be preserved)';

COMMENT ON COLUMN citydb.property.datatype
    IS 'the datatype should be given as a qualified datatype name from the CityGML schema (e.g. gml:GenericName, gml:DateTime)';

COMMENT ON COLUMN citydb.property.data_valtype
    IS 'tells in which attribute(s) the value is actually stored (0=val_int, 1=val_double, 2=val_string, 3=val_date, etc.)';

COMMENT ON COLUMN citydb.property.val_surface_geometry
    IS 'Foreign key to SURFACE_GEOMETRY(id)';

COMMENT ON COLUMN citydb.property.val_implicitgeom_id
    IS 'Foreign key to IMPLICIT_GEOMETRY(id)';

COMMENT ON COLUMN citydb.property.val_implicitgeom_refpoint
    IS 'base point in 3D world coordinates for the instantiation of the implicit geometry';

COMMENT ON COLUMN citydb.property.val_implicitgeom_transform
    IS '4x4 transformation matrix encoded as a string of space separated double values (as strings) in row major sequence';

COMMENT ON COLUMN citydb.property.val_grid_coverage
    IS 'Foreign key to GRID_COVERAGE(id)'; 

COMMENT ON COLUMN citydb.property.val_appearance
    IS 'Foreign key to APPEARANCE(id)'; 

COMMENT ON COLUMN citydb.property.val_dynamizer
    IS 'Foreign key to APPEARANCE(id)'; 

COMMENT ON COLUMN citydb.property.val_feature
    IS 'Foreign key to FEATURE(id)'; 

COMMENT ON COLUMN citydb.property.val_feature_is_xlink
    IS '0=related feature was represented inline, 1=related feature was referenced using an XLink';

COMMENT ON COLUMN citydb.property.val_code
    IS 'if a code from a codelist should be stored, we could also put the code in the val_string attribute and omit this attribute';  

COMMENT ON COLUMN citydb.property.val_codelist
    IS 'Foreign key to CODELIST(code) (or alternatively - if we do not store codelists also in the 3DCityDB - then a URL to the codelist)';  

COMMENT ON COLUMN citydb.property.val_uom
    IS 'unit of measure (for all subtypes of gml:Measure); the value is stored in val_double';  

COMMENT ON COLUMN citydb.property.val_complex
    IS 'stores all data of complex datatypes as a JSON string (e.g. con:Height)';

COMMENT ON COLUMN citydb.property.val_xml
    IS 'stores XML data';     


-- INDEXES

-- create indexes_ FOR TABLES INHERITED FROM 3DCITYDB v4 (not dropped tables)

CREATE INDEX schema_to_objectclass_fkx1 ON citydb.schema_to_objectclass  ( schema_id );

CREATE INDEX schema_to_objectclass_fkx2 ON citydb.schema_to_objectclass  ( objectclass_id );

CREATE INDEX schema_referencing_fkx1 ON citydb.schema_referencing  ( referenced_id );

CREATE INDEX schema_referencing_fkx2 ON citydb.schema_referencing  ( referencing_id );

CREATE INDEX objectclass_superclass_fkx ON citydb.objectclass  ( superclass_id );

CREATE INDEX objectclass_baseclass_fkx ON citydb.objectclass  ( baseclass_id );

CREATE INDEX texparam_geom_fkx ON citydb.textureparam  ( surface_geometry_id );

CREATE INDEX texparam_surface_data_fkx ON citydb.textureparam  ( surface_data_id );

CREATE INDEX implicit_geom_ref2lib_inx ON citydb.implicit_geometry  ( reference_to_library );

CREATE INDEX implicit_geom_brep_fkx ON citydb.implicit_geometry  ( relative_brep_id );

CREATE INDEX surface_data_inx ON citydb.surface_data  ( gmlid, gmlid_codespace );

CREATE INDEX surface_data_tex_image_fkx ON citydb.surface_data  ( tex_image_id );

CREATE INDEX surface_data_objclass_fkx ON citydb.surface_data  ( objectclass_id );

CREATE INDEX surface_data_spx ON citydb.surface_data  ( gt_reference_point );

CREATE INDEX grid_coverage_raster_spx ON citydb.grid_coverage  ( st_convexhull(rasterproperty) );

CREATE INDEX cityobject_member_fkx ON citydb.cityobject_member  ( cityobject_id );

CREATE INDEX cityobject_member_fkx1 ON citydb.cityobject_member  ( citymodel_id );

CREATE INDEX citymodel_inx ON citydb.citymodel  ( gmlid, gmlid_codespace );

CREATE INDEX citymodel_envelope_spx ON citydb.citymodel  ( envelope );

CREATE INDEX app_to_surf_data_fkx ON citydb.appear_to_surface_data  ( surface_data_id );

CREATE INDEX app_to_surf_data_fkx1 ON citydb.appear_to_surface_data  ( appearance_id );

CREATE INDEX appearance_inx ON citydb.appearance  ( gmlid, gmlid_codespace );

CREATE INDEX appearance_theme_inx ON citydb.appearance  ( theme );

CREATE INDEX appearance_citymodel_fkx ON citydb.appearance  ( citymodel_id );

CREATE INDEX appearance_cityobject_fkx ON citydb.appearance  ( cityobject_id );

CREATE INDEX IF NOT EXISTS surface_geom_cityobj_fkx
    ON citydb.surface_geometry USING btree
    (cityobject_id ASC NULLS LAST)
    WITH (FILLFACTOR=90)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS surface_geom_inx
    ON citydb.surface_geometry USING btree
    (gmlid COLLATE pg_catalog."default" ASC NULLS LAST, gmlid_codespace COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (FILLFACTOR=90)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS surface_geom_parent_fkx
    ON citydb.surface_geometry USING btree
    (parent_id ASC NULLS LAST)
    WITH (FILLFACTOR=90)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS surface_geom_root_fkx
    ON citydb.surface_geometry USING btree
    (root_id ASC NULLS LAST)
    WITH (FILLFACTOR=90)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS surface_geom_solid_spx
    ON citydb.surface_geometry USING gist
    (solid_geometry)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS surface_geom_spx
    ON citydb.surface_geometry USING gist
    (geometry)
    TABLESPACE pg_default;
-- create indexes_ FOR TABLES ADDED IN 3DCITYDB v5 (all new tables)

CREATE INDEX IF NOT EXISTS feature_objectclass_id_idx 
	ON citydb.feature ( objectclass_id );

CREATE INDEX IF NOT EXISTS feature_is_toplevel_btr
    ON citydb.feature USING btree
    (is_toplevel ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS feature_gmlid_btr
    ON citydb.feature USING btree
    (gmlid COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

--Also possible to try with GIN/GIST indexes
CREATE INDEX IF NOT EXISTS feature_identifier
    ON citydb.feature USING btree
    (identifier COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS feature_envelope_gist
    ON citydb.feature USING gist
    (envelope)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS feature_relation_from_feature_idx 
	ON citydb.feature_relation ( from_feature );

CREATE INDEX IF NOT EXISTS feature_relation_to_feature_idx 
	ON citydb.feature_relation ( to_feature );

CREATE INDEX IF NOT EXISTS feature_relation_namespace_btr
    ON citydb.feature_relation USING btree
    (namespace COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS feature_relation_name_btr
    ON citydb.feature_relation USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS feature_relation_relationtype_btr
    ON citydb.feature_relation USING btree
    (relationtype COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS codelist_codelist_type_btr
    ON citydb.codelist USING btree
    (codelist_type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_parent_id_fk 
		FOREIGN KEY ( parent_id ) 
		REFERENCES citydb.property( id ) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
		DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE IF EXISTS citydb.property 
	ADD CONSTRAINT property_root_id_fk 
		FOREIGN KEY ( root_id ) 
		REFERENCES citydb.property( id ) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
		DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX IF NOT EXISTS codelist_entry_codelist_id_idx 
	ON citydb.codelist_entry ( codelist_id );

CREATE INDEX IF NOT EXISTS property_feature_id_idx 
    ON citydb.property ( feature_id );

CREATE INDEX IF NOT EXISTS property_relation_id_idx 
    ON citydb.property ( relation_id );

CREATE INDEX IF NOT EXISTS property_parent_id_idx 
    ON citydb.property ( parent_id );

--Make a test with Tokyo or NYC dataset to decide which indexing type will be more beneficial.
CREATE INDEX IF NOT EXISTS property_namespace_btr
    ON citydb.property USING btree
    (namespace COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_name_btr
    ON citydb.property USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_root_id_idx
    ON citydb.property USING btree
    (root_id ASC NULLS LAST)
    TABLESPACE pg_default;

 CREATE INDEX IF NOT EXISTS property_conHeight_val_complex_value_btr
    ON citydb.property USING btree
    (((val_complex ->> 'value')::double precision) ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_data_valtype_btr
    ON citydb.property USING btree
    (data_valtype ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_val_feature_btr
    ON citydb.property USING btree
    (val_feature ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_namespace_name_btr
    ON citydb.property USING btree
        (namespace COLLATE pg_catalog."default" ASC NULLS LAST
        , name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_val_string_btr
    ON citydb.property USING btree
    (val_string COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_val_uom_btr
    ON citydb.property USING btree
    (val_uom COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS property_val_uri_btr
    ON citydb.property USING btree
    (val_uri COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;