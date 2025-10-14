-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: Okt 14, 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------


--
-- Clean up 3DCityDB tables and sequences
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

DROP SEQUENCE IF EXISTS address_seq;
DROP SEQUENCE IF EXISTS ade_seq;
DROP SEQUENCE IF EXISTS appear_to_surface_data_seq;
DROP SEQUENCE IF EXISTS appearance_seq;
DROP SEQUENCE IF EXISTS codelist_entry_seq;
DROP SEQUENCE IF EXISTS codelist_seq;
DROP SEQUENCE IF EXISTS feature_seq;
DROP SEQUENCE IF EXISTS geometry_data_seq;
DROP SEQUENCE IF EXISTS implicit_geometry_seq;
DROP SEQUENCE IF EXISTS property_seq;
DROP SEQUENCE IF EXISTS surface_data_seq;
DROP SEQUENCE IF EXISTS tex_image_seq;


--
-- Create 3DCityDB tables belonging to the following modules:
--   * Feature module
--   * Geometry module
--   * Appearance module
--   * CodeList module
--   * Metadata module
--

--
-- Create sequences
--

CREATE SEQUENCE address_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE ade_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 CACHE 20 NOCYCLE;
CREATE SEQUENCE appear_to_surface_data_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE appearance_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE codelist_entry_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE codelist_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE feature_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE geometry_data_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE implicit_geometry_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE property_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE surface_data_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;
CREATE SEQUENCE tex_image_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 20 NOCYCLE;

--
-- Table ADDRESS (Feature module)
--

CREATE TABLE IF NOT EXISTS address (
  id                            NUMBER(38) NOT NULL,
  objectid                      VARCHAR2(4000),
  identifier                    VARCHAR2(4000),
  identifier_codespace          VARCHAR2(4000),
  street                        VARCHAR2(4000),
  house_number                  VARCHAR2(4000),
  po_box                        VARCHAR2(4000),
  zip_code                      VARCHAR2(4000),
  city                          VARCHAR2(4000),
  state                         VARCHAR2(4000),
  country                       VARCHAR2(4000),
  free_text                     JSON,
  multi_point                   SDO_GEOMETRY,
  content                       CLOB,
  content_mime_type             VARCHAR2(4000),
  CONSTRAINT address_id_pk PRIMARY KEY ( id ) ENABLE
);

--
-- Table FEATURE (Feature module)
--

CREATE TABLE IF NOT EXISTS feature (
  id                            NUMBER(38) NOT NULL,
  objectclass_id                NUMBER(38),
  objectid                      VARCHAR2(4000),
  identifier                    VARCHAR2(4000),
  identifier_codespace          VARCHAR2(4000),
  envelope                      SDO_GEOMETRY,
  last_modification_date        TIMESTAMP WITH TIME ZONE,
  updating_person               VARCHAR2(4000),
  reason_for_update             VARCHAR2(4000),
  lineage                       VARCHAR2(4000),
  creation_date                 TIMESTAMP WITH TIME ZONE,
  termination_date              TIMESTAMP WITH TIME ZONE,
  valid_from                    TIMESTAMP WITH TIME ZONE,
  valid_to                      TIMESTAMP WITH TIME ZONE,
  CONSTRAINT feature_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

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
  id                            NUMBER(38) NOT NULL,
  feature_id                    NUMBER(38),
  parent_id                     NUMBER(38),
  datatype_id                   NUMBER(38),
  namespace_id                  NUMBER(38),
  name                          VARCHAR2(4000),
  val_int                       NUMBER(38),
  val_double                    NUMBER(38,3),
  val_string                    VARCHAR2(4000),
  val_timestamp                 TIMESTAMP WITH TIME ZONE,
  val_uri                       VARCHAR2(4000),
  val_codespace                 VARCHAR2(4000),
  val_uom                       VARCHAR2(4000),
  val_array                     JSON,
  val_lod                       VARCHAR2(4000),
  val_geometry_id               NUMBER(38),
  val_implicitgeom_id           NUMBER(38),
  val_implicitgeom_refpoint     SDO_GEOMETRY,
  val_appearance_id             NUMBER(38),
  val_address_id                NUMBER(38),
  val_feature_id                NUMBER(38),
  val_relation_type             NUMBER(38),
  val_content                   CLOB,
  val_content_mime_type         VARCHAR2(4000),
  CONSTRAINT property_id_pk PRIMARY KEY ( id ) ENABLE
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
  id                            NUMBER(38) NOT NULL,
  geometry                      SDO_GEOMETRY,
  implicit_geometry             SDO_GEOMETRY,
  geometry_properties           JSON,
  feature_id                    NUMBER(38),
  CONSTRAINT geometry_data_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX geometry_data_feature_idx ON geometry_data ( feature_id );

--
-- Table IMPLICIT_GEOMETRY (Geometry module)
--

CREATE TABLE IF NOT EXISTS implicit_geometry (
  id                            NUMBER(38) NOT NULL,
  objectid                      VARCHAR2(4000),
  mime_type                     VARCHAR2(4000),
  mime_type_codespace           VARCHAR2(4000),
  reference_to_library          VARCHAR2(4000),
  library_object                BLOB,
  relative_geometry_id          NUMBER(38),
  CONSTRAINT implicit_geometry_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX implicit_geometry_objectid_idx ON implicit_geometry ( objectid );
CREATE INDEX implicit_geometry_relative_geometry_idx ON implicit_geometry ( relative_geometry_id );

--
-- Table TEX_IMAGE (Appearance module)
--

CREATE TABLE IF NOT EXISTS tex_image (
  id                            NUMBER(38) NOT NULL,
  image_uri                     VARCHAR2(4000),
  image_data                    BLOB,
  mime_type                     VARCHAR2(4000),
  mime_type_codespace           VARCHAR2(4000),
  CONSTRAINT tex_image_id_pk PRIMARY KEY ( id ) ENABLE
);

--
-- Table APPEARANCE (Appearance module)
--

CREATE TABLE IF NOT EXISTS appearance (
  id                            NUMBER(38) NOT NULL,
  objectid                      VARCHAR2(4000),
  identifier                    VARCHAR2(4000),
  identifier_codespace          VARCHAR2(4000),
  theme                         VARCHAR2(4000),
  is_global                     NUMBER(1),
  feature_id                    NUMBER(38),
  implicit_geometry_id          NUMBER(38),
  CONSTRAINT appearance_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX appearance_feature_idx ON appearance ( feature_id );
CREATE INDEX appearance_implicit_geometry_idx ON appearance ( implicit_geometry_id );

--
-- Table SURFACE_DATA (Appearance module)
--

CREATE TABLE IF NOT EXISTS surface_data (
  id                            NUMBER(38) NOT NULL,
  objectid                      VARCHAR2(4000),
  identifier                    VARCHAR2(4000),
  identifier_codespace          VARCHAR2(4000),
  is_front                      NUMBER(1),
  objectclass_id                NUMBER(38) NOT NULL,
  x3d_shininess                 BINARY_DOUBLE,
  x3d_transparency              BINARY_DOUBLE,
  x3d_ambient_intensity         BINARY_DOUBLE,
  x3d_specular_color            VARCHAR2(4000),
  x3d_diffuse_color             VARCHAR2(4000),
  x3d_emissive_color            VARCHAR2(4000),
  x3d_is_smooth                 NUMBER(1),
  tex_image_id                  NUMBER(38),
  tex_texture_type              VARCHAR2(4000),
  tex_wrap_mode                 VARCHAR2(4000),
  tex_border_color              VARCHAR2(4000),
  gt_orientation                JSON,
  gt_reference_point            SDO_GEOMETRY,
  CONSTRAINT surface_data_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX surface_data_tex_image_idx ON surface_data ( tex_image_id );
CREATE INDEX surface_data_objectclass_idx ON surface_data ( objectclass_id );

--
-- Table SURFACE_DATA_MAPPING (Appearance module)
--

CREATE TABLE IF NOT EXISTS surface_data_mapping (
  surface_data_id               NUMBER(38) NOT NULL,
  geometry_data_id              NUMBER(38) NOT NULL,
  material_mapping              JSON,
  texture_mapping               JSON,
  world_to_texture_mapping      JSON,
  georeferenced_texture_mapping JSON,
  CONSTRAINT surface_data_mapping_pk PRIMARY KEY ( geometry_data_id, surface_data_id ) ENABLE
);

-- Create indices

CREATE INDEX surface_data_mapping_geometry_data_idx ON surface_data_mapping ( geometry_data_id );
CREATE INDEX surface_data_mapping_surface_data_idx ON surface_data_mapping ( surface_data_id );

--
-- Table APPEAR_TO_SURFACE_DATA (Appearance module)
--

CREATE TABLE IF NOT EXISTS appear_to_surface_data (
  id                            NUMBER(38) NOT NULL,
  appearance_id                 NUMBER(38) NOT NULL,
  surface_data_id               NUMBER(38),
  CONSTRAINT appear_to_surface_data_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX appear_to_surface_data_appearance_idx ON appear_to_surface_data ( appearance_id );
CREATE INDEX appear_to_surface_data_surface_data_idx ON appear_to_surface_data ( surface_data_id );

--
-- Table CODELIST (Codelist module)
--

CREATE TABLE IF NOT EXISTS codelist (
  id                            NUMBER(38) NOT NULL,
  codelist_type                 VARCHAR2(4000),
  url                           VARCHAR2(4000),
  mime_type                     VARCHAR2(4000),
  CONSTRAINT codelist_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX codelist_codelist_type_idx ON codelist ( codelist_type );

--
-- Table CODELIST_ENTRY (Codelist module)
--

CREATE TABLE IF NOT EXISTS codelist_entry (
  id                            NUMBER(38) NOT NULL,
	codelist_id                   NUMBER(38) NOT NULL,
	code                          VARCHAR2(4000),
	definition                    VARCHAR2(4000),
	CONSTRAINT codelist_entry_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX codelist_entry_codelist_idx ON codelist_entry ( codelist_id );

--
-- Table ADE (Metadata module)
--

CREATE TABLE IF NOT EXISTS ade (
  id                            NUMBER(38) NOT NULL,
  name                          VARCHAR2(4000) NOT NULL,
  description                   VARCHAR2(4000),
  version                       VARCHAR2(4000),
  CONSTRAINT ade_id_pk PRIMARY KEY ( id ) ENABLE
);

--
-- Table DATABASE_SRS (Metadata module)
--

CREATE TABLE IF NOT EXISTS database_srs (
	srid                          NUMBER(38) NOT NULL,
	srs_name                      VARCHAR2(4000),
	CONSTRAINT database_srs_pk PRIMARY KEY ( srid ) ENABLE
);

--
-- Table NAMESPACE (Metadata module)
--

CREATE TABLE IF NOT EXISTS namespace (
  id                            NUMBER(38) NOT NULL,
  alias                         VARCHAR2(4000),
  namespace                     VARCHAR2(4000),
  ade_id                        NUMBER(38),
  CONSTRAINT namespace_id_pk PRIMARY KEY ( id ) ENABLE,
  CONSTRAINT namespace_alias_uk UNIQUE (alias) ENABLE
);

--
-- Table OBJECTCLASS (Metadata module)
--

CREATE TABLE IF NOT EXISTS objectclass (
  id                            NUMBER(38) NOT NULL,
  superclass_id                 NUMBER(38),
  classname                     VARCHAR2(4000),
  is_abstract                   NUMBER(1),
  is_toplevel                   NUMBER(1),
  ade_id                        NUMBER(38),
  namespace_id                  NUMBER(38),
  schema                        JSON,
  CONSTRAINT objectclass_id_pk PRIMARY KEY ( id ) ENABLE
);

-- Create indices

CREATE INDEX objectclass_superclass_idx ON objectclass ( superclass_id );

--
-- Table DATA_TYPE (Metadata module)
--

CREATE TABLE IF NOT EXISTS datatype (
  id                            NUMBER(38) NOT NULL,
  supertype_id                  NUMBER(38),
  typename                      VARCHAR2(4000),
  is_abstract                   NUMBER(1),
  ade_id                        NUMBER(38),
  namespace_id                  NUMBER(38),
  schema                        JSON,
  CONSTRAINT datatype_id_pk PRIMARY KEY ( id ) ENABLE
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

