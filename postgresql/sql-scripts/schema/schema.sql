CREATE SEQUENCE address_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE ade_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  MAXVALUE 2147483647  CACHE 1  NO CYCLE;

CREATE SEQUENCE appear_to_surface_data_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE appearance_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE codelist_entry_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE codelist_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE feature_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE geometry_data_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE implicit_geometry_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE property_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE surface_data_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE SEQUENCE tex_image_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE  TABLE address ( 
	id                   bigint DEFAULT nextval('address_seq'::regclass) NOT NULL  ,
	objectid             text    ,
	identifier           text    ,
	identifier_codespace text    ,
	street               text    ,
	house_number         text    ,
	po_box               text    ,
	zip_code             text    ,
	city                 text    ,
	"state"              text    ,
	country              text    ,
	free_text            jsonb    ,
	multi_point          geometry(MULTIPOINTZ)    ,
	content              text    ,
	content_mime_type    text    ,
	CONSTRAINT address_pk PRIMARY KEY ( id )
 );

CREATE  TABLE ade ( 
	id                   integer DEFAULT nextval('ade_seq'::regclass) NOT NULL  ,
	name                 text  NOT NULL  ,
	description          text    ,
	"version"            text    ,
	CONSTRAINT ade_pk PRIMARY KEY ( id )
 );

CREATE  TABLE codelist ( 
	id                   bigint DEFAULT nextval('codelist_seq'::regclass) NOT NULL  ,
	codelist_type        text    ,
	url                  text    ,
	mime_type            text    ,
	CONSTRAINT codelist_pk PRIMARY KEY ( id )
 );

CREATE INDEX codelist_codelist_type_inx ON codelist  ( codelist_type );

CREATE  TABLE codelist_entry ( 
	id                   bigint DEFAULT nextval('codelist_entry_seq'::regclass) NOT NULL  ,
	codelist_id          bigint  NOT NULL  ,
	code                 text    ,
	definition           text    ,
	CONSTRAINT codelist_entry_pk PRIMARY KEY ( id )
 );

CREATE INDEX codelist_entry_codelist_fkx ON codelist_entry  ( codelist_id );

CREATE  TABLE database_srs ( 
	srid                 integer  NOT NULL  ,
	srs_name             text    ,
	CONSTRAINT database_srs_pk PRIMARY KEY ( srid )
 );

CREATE  TABLE feature ( 
	id                   bigint DEFAULT nextval('feature_seq'::regclass) NOT NULL  ,
	objectclass_id       integer  NOT NULL  ,
	objectid             text    ,
	identifier           text    ,
	identifier_codespace text    ,
	envelope             geometry(GEOMETRYZ)    ,
	last_modification_date timestamptz    ,
	updating_person      text    ,
	reason_for_update    text    ,
	lineage              text    ,
	creation_date        timestamptz    ,
	termination_date     timestamptz    ,
	valid_from           timestamptz    ,
	valid_to             timestamptz    ,
	CONSTRAINT feature_pk PRIMARY KEY ( id )
 );

CREATE INDEX feature_objectclass_inx ON feature  ( objectclass_id  );

CREATE INDEX feature_objectid_inx ON feature  ( objectid  );

CREATE INDEX feature_identifier_inx ON feature  ( identifier , identifier_codespace );

CREATE INDEX feature_creation_date_inx ON feature  ( creation_date );

CREATE INDEX feature_termination_date_inx ON feature  ( termination_date );

CREATE INDEX feature_valid_from_inx ON feature  ( valid_from );

CREATE INDEX feature_valid_to_inx ON feature  ( valid_to );

CREATE  TABLE geometry_data ( 
	id                   bigint DEFAULT nextval('geometry_data_seq'::regclass) NOT NULL  ,
	geometry             geometry(GEOMETRYZ)    ,
	implicit_geometry    geometry(GEOMETRYZ)    ,
	geometry_properties  jsonb    ,
	feature_id           bigint    ,
	CONSTRAINT geometry_data_pk PRIMARY KEY ( id )
 );

CREATE INDEX geometry_data_feature_fkx ON geometry_data  ( feature_id );

CREATE  TABLE implicit_geometry ( 
	id                   bigint DEFAULT nextval('implicit_geometry_seq'::regclass) NOT NULL  ,
	objectid             text    ,
	mime_type            text    ,
	mime_type_codespace  text    ,
	reference_to_library text    ,
	library_object       bytea    ,
	relative_geometry_id bigint    ,
	CONSTRAINT implicit_geometry_pk PRIMARY KEY ( id )
 );

CREATE INDEX implicit_geometry_fkx ON implicit_geometry  ( relative_geometry_id );

CREATE INDEX implicit_geometry_objectid_inx ON implicit_geometry  ( objectid );

CREATE  TABLE namespace ( 
	id                   integer  NOT NULL  ,
	"alias"              text    ,
	namespace            text    ,
	ade_id               integer    ,
	CONSTRAINT namespace_pk PRIMARY KEY ( id )
 );

CREATE  TABLE objectclass ( 
	id                   integer  NOT NULL  ,
	superclass_id        integer    ,
	classname            text    ,
	is_abstract          integer    ,
	is_toplevel          integer    ,
	ade_id               integer    ,
	namespace_id         integer    ,
	"schema"             jsonb    ,
	CONSTRAINT objectclass_pk PRIMARY KEY ( id )
 );

CREATE INDEX objectclass_superclass_fkx ON objectclass  ( superclass_id );

CREATE  TABLE tex_image ( 
	id                   bigint DEFAULT nextval('tex_image_seq'::regclass) NOT NULL  ,
	image_uri            text    ,
	image_data           bytea    ,
	mime_type            text    ,
	mime_type_codespace  text    ,
	CONSTRAINT tex_image_pk PRIMARY KEY ( id )
 );

CREATE  TABLE appearance ( 
	id                   bigint DEFAULT nextval('appearance_seq'::regclass) NOT NULL  ,
	objectid             text    ,
	identifier           text    ,
	identifier_codespace text    ,
	theme                text    ,
	is_global            integer    ,
	feature_id           bigint    ,
	implicit_geometry_id bigint    ,
	CONSTRAINT appearance_pk PRIMARY KEY ( id )
 );

CREATE INDEX appearance_feature_fkx ON appearance  ( feature_id );

CREATE INDEX appearance_implicit_geom_fkx ON appearance  ( implicit_geometry_id );

CREATE INDEX appearance_theme_inx ON appearance  ( theme );

CREATE  TABLE datatype ( 
	id                   integer  NOT NULL  ,
	supertype_id         integer    ,
	typename             text    ,
	is_abstract          integer    ,
	ade_id               integer    ,
	namespace_id         integer    ,
	"schema"             jsonb    ,
	CONSTRAINT datatype_pk PRIMARY KEY ( id )
 );

CREATE INDEX datatype_supertype_fkx ON datatype  ( supertype_id );

CREATE  TABLE property ( 
	id                   bigint DEFAULT nextval('property_seq'::regclass) NOT NULL  ,
	feature_id           bigint    ,
	parent_id            bigint    ,
	datatype_id          integer  NOT NULL  ,
	namespace_id         integer    ,
	name                 text    ,
	val_int              bigint    ,
	val_double           double precision    ,
	val_string           text    ,
	val_timestamp        timestamptz    ,
	val_uri              text    ,
	val_codespace        text    ,
	val_uom              text    ,
	val_array            jsonb    ,
	val_lod              text    ,
	val_geometry_id      bigint    ,
	val_implicitgeom_id  bigint    ,
	val_implicitgeom_refpoint geometry(POINTZ)    ,
	val_appearance_id    bigint    ,
	val_address_id       bigint    ,
	val_feature_id       bigint    ,
	val_relation_type    integer    ,
	val_content          text    ,
	val_content_mime_type text    ,
	CONSTRAINT property_pk PRIMARY KEY ( id )
 );

CREATE INDEX property_feature_fkx ON property  ( feature_id );

CREATE INDEX property_parent_fkx ON property  ( parent_id );

CREATE INDEX property_namespace_inx ON property  ( namespace_id );

CREATE INDEX property_name_inx ON property  ( name );

CREATE INDEX property_val_string_inx ON property  ( val_string ) WHERE val_string IS NOT NULL;

CREATE INDEX property_val_uom_inx ON property  ( val_uom ) WHERE val_uom IS NOT NULL;

CREATE INDEX property_val_uri_inx ON property  ( val_uri ) WHERE val_uri IS NOT NULL;

CREATE INDEX property_val_int_inx ON property  ( val_int ) WHERE val_int IS NOT NULL;

CREATE INDEX property_val_double_inx ON property  ( val_double ) WHERE val_double IS NOT NULL;

CREATE INDEX property_val_date_inx ON property  ( val_timestamp ) WHERE val_timestamp IS NOT NULL;

CREATE INDEX property_val_feature_fkx ON property  ( val_feature_id );

CREATE INDEX property_val_geometry_fkx ON property  ( val_geometry_id );

CREATE INDEX property_val_implicitgeom_fkx ON property  ( val_implicitgeom_id );

CREATE INDEX property_val_appearance_fkx ON property  ( val_appearance_id );

CREATE INDEX property_val_relation_type_inx ON property  ( val_relation_type );

CREATE INDEX property_val_address_fkx ON property  ( val_address_id );

CREATE INDEX property_val_lod_inx ON property  ( val_lod );

CREATE  TABLE surface_data ( 
	id                   bigint DEFAULT nextval('surface_data_seq'::regclass) NOT NULL  ,
	objectid             text    ,
	identifier           text    ,
	identifier_codespace text    ,
	is_front             integer    ,
	objectclass_id       integer  NOT NULL  ,
	x3d_shininess        double precision    ,
	x3d_transparency     double precision    ,
	x3d_ambient_intensity double precision    ,
	x3d_specular_color   text    ,
	x3d_diffuse_color    text    ,
	x3d_emissive_color   text    ,
	x3d_is_smooth        integer    ,
	tex_image_id         bigint    ,
	tex_texture_type     text    ,
	tex_wrap_mode        text    ,
	tex_border_color     text    ,
	gt_orientation       jsonb    ,
	gt_reference_point   geometry(POINT)    ,
	CONSTRAINT surface_data_pk PRIMARY KEY ( id )
 );

CREATE INDEX surface_data_tex_image_fkx ON surface_data  ( tex_image_id );

CREATE INDEX surface_data_objclass_fkx ON surface_data  ( objectclass_id );

CREATE  TABLE surface_data_mapping ( 
	surface_data_id      bigint  NOT NULL  ,
	geometry_data_id     bigint  NOT NULL  ,
	material_mapping     jsonb    ,
	texture_mapping      jsonb    ,
	world_to_texture_mapping jsonb    ,
	georeferenced_texture_mapping jsonb    ,
	CONSTRAINT surface_data_mapping_pk PRIMARY KEY ( geometry_data_id, surface_data_id )
 );

CREATE INDEX surface_data_mapping_fkx1 ON surface_data_mapping  ( geometry_data_id );

CREATE INDEX surface_data_mapping_fkx2 ON surface_data_mapping  ( surface_data_id );

CREATE  TABLE appear_to_surface_data ( 
	id                   bigint DEFAULT nextval('appear_to_surface_data_seq'::regclass) NOT NULL  ,
	appearance_id        bigint  NOT NULL  ,
	surface_data_id      bigint    ,
	CONSTRAINT appear_to_surface_data_pk PRIMARY KEY ( id )
 );

CREATE INDEX appear_to_surface_data_fkx1 ON appear_to_surface_data  ( surface_data_id );

CREATE INDEX appear_to_surface_data_fkx2 ON appear_to_surface_data  ( appearance_id );

ALTER TABLE appear_to_surface_data ADD CONSTRAINT appear_to_surface_data_fk1 FOREIGN KEY ( surface_data_id ) REFERENCES surface_data( id ) ON DELETE CASCADE;

ALTER TABLE appear_to_surface_data ADD CONSTRAINT appear_to_surface_data_fk2 FOREIGN KEY ( appearance_id ) REFERENCES appearance( id ) ON DELETE CASCADE;

ALTER TABLE appearance ADD CONSTRAINT appearance_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature( id ) ON DELETE SET NULL;

ALTER TABLE appearance ADD CONSTRAINT appearance_implicit_geom_fk FOREIGN KEY ( implicit_geometry_id ) REFERENCES implicit_geometry( id ) ON DELETE CASCADE;

ALTER TABLE codelist_entry ADD CONSTRAINT codelist_entry_codelist_fk FOREIGN KEY ( codelist_id ) REFERENCES codelist( id ) ON DELETE CASCADE;

ALTER TABLE datatype ADD CONSTRAINT datatype_ade_fk FOREIGN KEY ( ade_id ) REFERENCES ade( id ) ON DELETE CASCADE;

ALTER TABLE datatype ADD CONSTRAINT datatype_namespace_fk FOREIGN KEY ( namespace_id ) REFERENCES namespace( id ) ON DELETE CASCADE;

ALTER TABLE datatype ADD CONSTRAINT datatype_supertype_fk FOREIGN KEY ( supertype_id ) REFERENCES datatype( id ) ON DELETE CASCADE;

ALTER TABLE geometry_data ADD CONSTRAINT geometry_data_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature( id ) ON DELETE SET NULL;

ALTER TABLE implicit_geometry ADD CONSTRAINT implicit_geometry_fk FOREIGN KEY ( relative_geometry_id ) REFERENCES geometry_data( id ) ON DELETE CASCADE;

ALTER TABLE namespace ADD CONSTRAINT fk_namespace_ade FOREIGN KEY ( ade_id ) REFERENCES ade( id ) ON DELETE CASCADE;

ALTER TABLE objectclass ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY ( ade_id ) REFERENCES ade( id ) ON DELETE CASCADE;

ALTER TABLE objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY ( superclass_id ) REFERENCES objectclass( id ) ON DELETE CASCADE;

ALTER TABLE objectclass ADD CONSTRAINT objectclass_namespace_fk FOREIGN KEY ( namespace_id ) REFERENCES namespace( id ) ON DELETE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_appearance_fk FOREIGN KEY ( val_appearance_id ) REFERENCES appearance( id ) ON DELETE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature( id );

ALTER TABLE property ADD CONSTRAINT property_val_feature_fk FOREIGN KEY ( val_feature_id ) REFERENCES feature( id ) ON DELETE SET NULL;

ALTER TABLE property ADD CONSTRAINT property_val_implicitgeom_fk FOREIGN KEY ( val_implicitgeom_id ) REFERENCES implicit_geometry( id ) ON DELETE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_parent_fk FOREIGN KEY ( parent_id ) REFERENCES property( id ) ON DELETE SET NULL;

ALTER TABLE property ADD CONSTRAINT property_val_geometry_fk FOREIGN KEY ( val_geometry_id ) REFERENCES geometry_data( id ) ON DELETE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_val_address_fk FOREIGN KEY ( val_address_id ) REFERENCES address( id ) ON DELETE CASCADE;

ALTER TABLE surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY ( tex_image_id ) REFERENCES tex_image( id ) ON DELETE SET NULL;

ALTER TABLE surface_data_mapping ADD CONSTRAINT surface_data_mapping_fk1 FOREIGN KEY ( geometry_data_id ) REFERENCES geometry_data( id ) ON DELETE CASCADE;

ALTER TABLE surface_data_mapping ADD CONSTRAINT surface_data_mapping_fk2 FOREIGN KEY ( surface_data_id ) REFERENCES surface_data( id ) ON DELETE CASCADE;

