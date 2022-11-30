CREATE SEQUENCE address_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE ade_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE appearance_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE codelist_entry_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE codelist_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE feature_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE geometry_data_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE implicit_geometry_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE property_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE surface_data_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE SEQUENCE tex_image_seq INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE OWNED BY NONE;

CREATE  TABLE ade (
  id                   integer DEFAULT nextval('ade_seq'::regclass) NOT NULL  ,
  adeid                text  NOT NULL  ,
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
  CONSTRAINT codelist_pkey PRIMARY KEY ( id )
);

CREATE INDEX codelist_codelist_type_inx ON codelist  ( codelist_type );

CREATE  TABLE codelist_entry (
  id                   bigint DEFAULT nextval('codelist_entry_seq'::regclass) NOT NULL  ,
  codelist_id          bigint  NOT NULL  ,
  code                 text    ,
  definition           text    ,
  CONSTRAINT codelist_entry_pkey PRIMARY KEY ( id )
);

CREATE INDEX codelist_entry_codelist_idx ON codelist_entry  ( codelist_id );

CREATE  TABLE database_srs (
  srid                 integer  NOT NULL  ,
  srs_name             text    ,
  CONSTRAINT database_srs_pk PRIMARY KEY ( srid )
);

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
  is_toplevel          numeric    ,
  ade_id               integer    ,
  namespace_id         integer    ,
  CONSTRAINT objectclass_pk PRIMARY KEY ( id )
);

CREATE INDEX objectclass_superclass_fkx ON objectclass  ( superclass_id );

CREATE  TABLE tex_image (
  id                   bigint DEFAULT nextval('tex_image_seq'::regclass) NOT NULL  ,
  tex_image_uri        text    ,
  tex_image_data       bytea    ,
  tex_mime_type        text    ,
  tex_mime_type_codespace text    ,
  CONSTRAINT tex_image_pk PRIMARY KEY ( id )
);

CREATE  TABLE aggregation_info (
  child_id             integer  NOT NULL  ,
  parent_id            integer  NOT NULL  ,
  property_name        text  NOT NULL  ,
  property_namespace_id integer    ,
  min_occurs           integer    ,
  max_occurs           integer    ,
  is_composite         numeric
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

CREATE INDEX feature_objectclass_fkx ON feature  ( objectclass_id  );

CREATE INDEX feature_objectid_inx ON feature  ( objectid  );

CREATE INDEX feature_envelope_spx ON feature USING GiST ( envelope );

CREATE INDEX feature_identifier_inx ON feature  ( identifier , identifier_codespace );

CREATE  TABLE geometry_data (
  id                   bigint DEFAULT nextval('geometry_data_seq'::regclass) NOT NULL  ,
  "type"               integer    ,
  objectid             text    ,
  geometry             geometry(GEOMETRYZ)    ,
  implicit_geometry    geometry(GEOMETRYZ)    ,
  geom_properties      json    ,
  feature_id           bigint    ,
  CONSTRAINT geometry_data_pk PRIMARY KEY ( id )
);

CREATE INDEX geometry_data_objectid_inx ON geometry_data  ( objectid );

CREATE INDEX geometry_data_feature_fkx ON geometry_data  ( feature_id );

CREATE INDEX geometry_data_spx ON geometry_data USING GiST ( geometry );

CREATE  TABLE implicit_geometry (
  id                   bigint DEFAULT nextval('implicit_geometry_seq'::regclass) NOT NULL  ,
  objectid             text    ,
  mime_type            text    ,
  reference_to_library text    ,
  library_object       bytea    ,
  relative_geometry_id bigint    ,
  CONSTRAINT implicit_geometry_pk PRIMARY KEY ( id )
);

CREATE INDEX implicit_geom_ref2lib_inx ON implicit_geometry  ( reference_to_library );

CREATE INDEX implicit_geometry_fkx ON implicit_geometry  ( relative_geometry_id );

CREATE INDEX implicit_geometry_inx ON implicit_geometry  ( objectid );

CREATE  TABLE surface_data (
  id                   bigint DEFAULT nextval('surface_data_seq'::regclass) NOT NULL  ,
  objectid             text    ,
  identifier           text    ,
  identifier_codespace text    ,
  is_front             numeric    ,
  objectclass_id       integer  NOT NULL  ,
  x3d_shininess        double precision    ,
  x3d_transparency     double precision    ,
  x3d_ambient_intensity double precision    ,
  x3d_specular_color   text    ,
  x3d_diffuse_color    text    ,
  x3d_emissive_color   text    ,
  x3d_is_smooth        numeric    ,
  tex_image_id         bigint    ,
  tex_texture_type     text    ,
  tex_wrap_mode        text    ,
  tex_border_color     text    ,
  gt_prefer_worldfile  numeric    ,
  gt_orientation       text    ,
  gt_reference_point   geometry(POINT)    ,
  CONSTRAINT surface_data_pk PRIMARY KEY ( id )
);

CREATE INDEX surface_data_objectid_inx ON surface_data  ( objectid );

CREATE INDEX surface_data_tex_image_fkx ON surface_data  ( tex_image_id );

CREATE INDEX surface_data_objclass_fkx ON surface_data  ( objectclass_id );

CREATE INDEX surface_data_spx ON surface_data  ( gt_reference_point );

CREATE INDEX surface_data_identifier_inx ON surface_data  ( identifier, identifier_codespace );

CREATE  TABLE surface_data_mapping (
  surface_data_id      bigint  NOT NULL  ,
  geometry_data_id     bigint  NOT NULL  ,
  texture_mapping      json    ,
  material_mapping     json    ,
  world_to_texture_mapping json    ,
  CONSTRAINT surface_data_mapping_pk PRIMARY KEY ( geometry_data_id, surface_data_id )
);

CREATE INDEX surface_data_mapping_fkx1 ON surface_data_mapping  ( geometry_data_id );

CREATE INDEX surface_data_mapping_fkx2 ON surface_data_mapping  ( surface_data_id );

CREATE  TABLE address (
  id                   bigint DEFAULT nextval('address_seq'::regclass) NOT NULL  ,
  street               text    ,
  house_number         text    ,
  po_box               text    ,
  zip_code             text    ,
  city                 text    ,
  "state"              text    ,
  country              text    ,
  free_text            json    ,
  CONSTRAINT address_pk PRIMARY KEY ( id )
);

CREATE  TABLE appearance (
  id                   bigint DEFAULT nextval('appearance_seq'::regclass) NOT NULL  ,
  objectid             text    ,
  identifier           text    ,
  identifier_codespace text    ,
  theme                text    ,
  creation_date        timestamptz    ,
  termination_date     timestamptz    ,
  valid_from           timestamptz    ,
  valid_to             timestamptz    ,
  is_global            numeric    ,
  feature_id           bigint    ,
  CONSTRAINT appearance_pk PRIMARY KEY ( id )
);

CREATE INDEX appearance_objectid_inx ON appearance  ( objectid );

CREATE INDEX appearance_theme_inx ON appearance  ( theme );

CREATE INDEX appearance_feature_fkx ON appearance  ( feature_id );

CREATE INDEX appearance_identifier_inx ON appearance  ( identifier, identifier_codespace );

CREATE  TABLE property (
  id                   bigint DEFAULT nextval('property_seq'::regclass) NOT NULL  ,
  feature_id           bigint    ,
  parent_id            bigint    ,
  root_id              bigint    ,
  lod                  text    ,
  namespace_id         integer    ,
  name                 text    ,
  index_number         integer    ,
  data_valtype         integer    ,
  val_int              bigint    ,
  val_double           double precision    ,
  val_string           text    ,
  val_timestamp        timestamptz    ,
  val_uri              text    ,
  val_address_id       bigint    ,
  val_geometry_id      bigint    ,
  val_implicitgeom_id  bigint    ,
  val_implicitgeom_refpoint geometry(GEOMETRYZ)    ,
  val_implicitgeom_transform text    ,
  val_appearance_id    bigint    ,
  val_feature_id       bigint    ,
  val_is_reference     integer    ,
  val_codespace        text    ,
  val_uom              text    ,
  val_content          text    ,
  val_content_mime_type text    ,
  CONSTRAINT property_pk PRIMARY KEY ( id )
);

CREATE INDEX property_feature_fkx ON property  ( feature_id );

CREATE INDEX property_parent_fkx ON property  ( parent_id );

CREATE INDEX property_root_fkx ON property  ( root_id );

CREATE INDEX property_data_valtype_inx ON property  ( data_valtype );

CREATE INDEX property_val_feature_fkx ON property  ( val_feature_id );

CREATE INDEX property_namespace_name_inx ON property  ( namespace_id, name );

CREATE INDEX property_val_string_inx ON property  ( val_string );

CREATE INDEX property_val_uom_inx ON property  ( val_uom );

CREATE INDEX property_val_uri_inx ON property  ( val_uri );

CREATE INDEX property_lod_inx ON property  ( lod );

CREATE INDEX property_val_int_inx ON property  ( val_int );

CREATE INDEX property_val_double_inx ON property  ( val_double );

CREATE INDEX property_val_date_inx ON property  ( val_timestamp );

CREATE INDEX property_val_geometry_fkx ON property  ( val_geometry_id );

CREATE INDEX property_val_implicitgeom_fkx ON property  ( val_implicitgeom_id );

CREATE INDEX property_val_appearance_fkx ON property  ( val_appearance_id );

CREATE INDEX property_val_address_fkx ON property  ( val_address_id );

CREATE INDEX property_val_implicitgeom_spx ON property USING GiST ( val_implicitgeom_refpoint );

CREATE INDEX property_namespace_fkx ON property  ( namespace_id );

CREATE  TABLE appear_to_surface_data (
  surface_data_id      bigint  NOT NULL  ,
  appearance_id        bigint  NOT NULL  ,
  CONSTRAINT appear_to_surface_data_pk PRIMARY KEY ( surface_data_id, appearance_id )
);

CREATE INDEX appear_to_surface_data_fkx1 ON appear_to_surface_data  ( surface_data_id );

CREATE INDEX appear_to_surface_data_fkx2 ON appear_to_surface_data  ( appearance_id );

ALTER TABLE address ADD CONSTRAINT address_feature_fk FOREIGN KEY ( id ) REFERENCES feature( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE aggregation_info ADD CONSTRAINT aggregation_info_child_fk FOREIGN KEY ( child_id ) REFERENCES objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE aggregation_info ADD CONSTRAINT aggregation_info_parent_fk FOREIGN KEY ( parent_id ) REFERENCES objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE aggregation_info ADD CONSTRAINT aggregation_info_namespace_fk FOREIGN KEY ( property_namespace_id ) REFERENCES namespace( id );

ALTER TABLE appear_to_surface_data ADD CONSTRAINT appear_to_surface_data_fk1 FOREIGN KEY ( surface_data_id ) REFERENCES surface_data( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE appear_to_surface_data ADD CONSTRAINT appear_to_surface_data_fk2 FOREIGN KEY ( appearance_id ) REFERENCES appearance( id )  ON UPDATE CASCADE;

ALTER TABLE appearance ADD CONSTRAINT appearance_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature( id )  ON UPDATE CASCADE;

ALTER TABLE codelist_entry ADD CONSTRAINT codelist_entry_codelist_fk FOREIGN KEY ( codelist_id ) REFERENCES codelist( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE feature ADD CONSTRAINT feature_objectclass_fk FOREIGN KEY ( objectclass_id ) REFERENCES objectclass( id )  ON UPDATE CASCADE;

ALTER TABLE geometry_data ADD CONSTRAINT geometry_data_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature( id )  ON UPDATE CASCADE;

ALTER TABLE implicit_geometry ADD CONSTRAINT implicit_geometry_fk FOREIGN KEY ( relative_geometry_id ) REFERENCES geometry_data( id )  ON UPDATE CASCADE;

ALTER TABLE namespace ADD CONSTRAINT fk_namespace_ade FOREIGN KEY ( ade_id ) REFERENCES ade( id );

ALTER TABLE objectclass ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY ( ade_id ) REFERENCES ade( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY ( superclass_id ) REFERENCES objectclass( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objectclass ADD CONSTRAINT objectclass_namespace_fk FOREIGN KEY ( namespace_id ) REFERENCES namespace( id );

ALTER TABLE property ADD CONSTRAINT property_appearance_fk FOREIGN KEY ( val_appearance_id ) REFERENCES appearance( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_feature_fk FOREIGN KEY ( feature_id ) REFERENCES feature( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_val_feature_fk FOREIGN KEY ( val_feature_id ) REFERENCES feature( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_val_implicitgeom_fk FOREIGN KEY ( val_implicitgeom_id ) REFERENCES implicit_geometry( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_parent_fk FOREIGN KEY ( parent_id ) REFERENCES property( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_root_fk FOREIGN KEY ( root_id ) REFERENCES property( id ) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE property ADD CONSTRAINT property_val_geometry_fk FOREIGN KEY ( val_geometry_id ) REFERENCES geometry_data( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_val_address_fk FOREIGN KEY ( val_address_id ) REFERENCES address( id )  ON UPDATE CASCADE;

ALTER TABLE property ADD CONSTRAINT property_namespace_fk FOREIGN KEY ( namespace_id ) REFERENCES namespace( id );

ALTER TABLE surface_data ADD CONSTRAINT surface_data_objclass_fk FOREIGN KEY ( objectclass_id ) REFERENCES objectclass( id )  ON UPDATE CASCADE;

ALTER TABLE surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY ( tex_image_id ) REFERENCES tex_image( id )  ON UPDATE CASCADE;

ALTER TABLE surface_data_mapping ADD CONSTRAINT surface_data_mapping_fk1 FOREIGN KEY ( geometry_data_id ) REFERENCES geometry_data( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE surface_data_mapping ADD CONSTRAINT surface_data_mapping_fk2 FOREIGN KEY ( surface_data_id ) REFERENCES surface_data( id ) ON DELETE CASCADE ON UPDATE CASCADE;