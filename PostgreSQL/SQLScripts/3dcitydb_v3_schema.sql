-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- PostgreSQL version: 9.3
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: "3DCityDB_v3.0" | type: DATABASE --
-- CREATE DATABASE "3DCityDB_v3.0"
-- 	ENCODING = 'UTF8'
-- 	TABLESPACE = pg_default
-- 	OWNER = postgres
-- ;
-- -- ddl-end --
-- 

-- object: postgis | type: EXTENSION --
CREATE EXTENSION postgis
      WITH SCHEMA public
      VERSION '2.1.1';
COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';
-- ddl-end --
-- ddl-end --

-- object: public.citymodel | type: TABLE --
CREATE TABLE public.citymodel(
	id integer NOT NULL DEFAULT nextval('citymodel_seq'::regclass),
	gmlid character varying(256),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	envelope geometry(POLYGONZ),
	creation_date timestamp,
	termination_date timestamp,
	last_modification_date timestamp,
	updating_person character varying(256),
	reason_for_update character varying(4000),
	lineage character varying(256),
	CONSTRAINT citymodel_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: citymodel_envelope_spx | type: INDEX --
CREATE INDEX citymodel_envelope_spx ON public.citymodel
	USING gist
	(
	  envelope
	);
-- ddl-end --


-- object: public.cityobject | type: TABLE --
CREATE TABLE public.cityobject(
	id integer NOT NULL DEFAULT nextval('cityobject_seq'::regclass),
	objectclass_id integer NOT NULL,
	gmlid character varying(256),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	envelope geometry(POLYGONZ),
	creation_date timestamp NOT NULL,
	termination_date timestamp,
	last_modification_date timestamp,
	updating_person character varying(256),
	reason_for_update character varying(4000),
	lineage character varying(256),
	relative_to_terrain character varying(256),
	relative_to_water character varying(256),
	xml_source text,
	CONSTRAINT cityobject_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: cityobject_inx | type: INDEX --
CREATE INDEX cityobject_inx ON public.cityobject
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_objectclass_fkx | type: INDEX --
CREATE INDEX cityobject_objectclass_fkx ON public.cityobject
	USING btree
	(
	  objectclass_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_envelope_spx | type: INDEX --
CREATE INDEX cityobject_envelope_spx ON public.cityobject
	USING gist
	(
	  envelope
	);
-- ddl-end --


-- object: public.cityobject_member | type: TABLE --
CREATE TABLE public.cityobject_member(
	citymodel_id integer NOT NULL,
	cityobject_id integer NOT NULL,
	CONSTRAINT cityobject_member_pk PRIMARY KEY (citymodel_id,cityobject_id)

);
-- ddl-end --
-- object: cityobject_member_fkx | type: INDEX --
CREATE INDEX cityobject_member_fkx ON public.cityobject_member
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_member_fkx1 | type: INDEX --
CREATE INDEX cityobject_member_fkx1 ON public.cityobject_member
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.external_reference | type: TABLE --
CREATE TABLE public.external_reference(
	id integer NOT NULL DEFAULT nextval('external_ref_seq'::regclass),
	infosys character varying(4000),
	name character varying(4000),
	uri character varying(4000),
	cityobject_id integer NOT NULL,
	CONSTRAINT external_reference_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: ext_ref_cityobject_fkx | type: INDEX --
CREATE INDEX ext_ref_cityobject_fkx ON public.external_reference
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.generalization | type: TABLE --
CREATE TABLE public.generalization(
	cityobject_id integer NOT NULL,
	generalizes_to_id integer NOT NULL,
	CONSTRAINT generalization_pk PRIMARY KEY (cityobject_id,generalizes_to_id)

);
-- ddl-end --
-- object: general_cityobject_fkx | type: INDEX --
CREATE INDEX general_cityobject_fkx ON public.generalization
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: general_generalizes_to_fkx | type: INDEX --
CREATE INDEX general_generalizes_to_fkx ON public.generalization
	USING btree
	(
	  generalizes_to_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.surface_geometry | type: TABLE --
CREATE TABLE public.surface_geometry(
	id integer NOT NULL DEFAULT nextval('surface_geometry_seq'::regclass),
	gmlid character varying(256),
	parent_id integer,
	root_id integer,
	is_solid numeric,
	is_composite numeric,
	is_triangulated numeric,
	is_xlink numeric,
	is_reverse numeric,
	geometry geometry(POLYGONZ),
	solid_geometry geometry,
	cityobject_id integer,
	CONSTRAINT surface_geometry_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: surface_geom_inx | type: INDEX --
CREATE INDEX surface_geom_inx ON public.surface_geometry
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_parent_fkx | type: INDEX --
CREATE INDEX surface_geom_parent_fkx ON public.surface_geometry
	USING btree
	(
	  parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_root_fkx | type: INDEX --
CREATE INDEX surface_geom_root_fkx ON public.surface_geometry
	USING btree
	(
	  root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_spx | type: INDEX --
CREATE INDEX surface_geom_spx ON public.surface_geometry
	USING gist
	(
	  geometry
	);
-- ddl-end --


-- object: public.cityobjectgroup | type: TABLE --
CREATE TABLE public.cityobjectgroup(
	id integer NOT NULL,
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	class character varying(256),
	function character varying(1000),
	usage character varying(1000),
	geometry geometry(POLYGONZ),
	surface_geometry_id integer,
	parent_cityobject_id integer,
	CONSTRAINT cityobjectgroup_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: group_geom_fkx | type: INDEX --
CREATE INDEX group_geom_fkx ON public.cityobjectgroup
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_parent_cityobj_fkx | type: INDEX --
CREATE INDEX group_parent_cityobj_fkx ON public.cityobjectgroup
	USING btree
	(
	  parent_cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_geom_spx | type: INDEX --
CREATE INDEX group_geom_spx ON public.cityobjectgroup
	USING gist
	(
	  geometry
	);
-- ddl-end --


-- object: public.group_to_cityobject | type: TABLE --
CREATE TABLE public.group_to_cityobject(
	cityobject_id integer NOT NULL DEFAULT nextval('group_to_cityobject_cityobject_id_seq'::regclass),
	cityobjectgroup_id integer NOT NULL,
	role character varying(256),
	CONSTRAINT group_to_cityobject_pk PRIMARY KEY (cityobject_id,cityobjectgroup_id)

);
-- ddl-end --
-- object: group_to_cityobject_fkx | type: INDEX --
CREATE INDEX group_to_cityobject_fkx ON public.group_to_cityobject
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_to_cityobject_fkx1 | type: INDEX --
CREATE INDEX group_to_cityobject_fkx1 ON public.group_to_cityobject
	USING btree
	(
	  cityobjectgroup_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.database_srs | type: TABLE --
CREATE TABLE public.database_srs(
	srid integer NOT NULL,
	gml_srs_name character varying(1000),
	CONSTRAINT database_srs_pk PRIMARY KEY (srid)

);
-- ddl-end --
-- object: public.objectclass | type: TABLE --
CREATE TABLE public.objectclass(
	id integer NOT NULL,
	classname character varying(256),
	superclass_id integer,
	CONSTRAINT objectclass_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: objectclass_superclass_fkx | type: INDEX --
CREATE INDEX objectclass_superclass_fkx ON public.objectclass
	USING btree
	(
	  superclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.implicit_geometry | type: TABLE --
CREATE TABLE public.implicit_geometry(
	id integer NOT NULL DEFAULT nextval('implicit_geometry_seq'::regclass),
	mime_type character varying(256),
	reference_to_library character varying(4000),
	library_object bytea,
	relative_geometry_id integer,
	CONSTRAINT implicit_geometry_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: implicit_geometry_fkx | type: INDEX --
CREATE INDEX implicit_geometry_fkx ON public.implicit_geometry
	USING btree
	(
	  relative_geometry_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geometry_inx | type: INDEX --
CREATE INDEX implicit_geometry_inx ON public.implicit_geometry
	USING btree
	(
	  reference_to_library
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.city_furniture | type: TABLE --
CREATE TABLE public.city_furniture(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod1_brep_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod1_other_geom geometry,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod1_implicit_rep_id integer,
	lod2_implicit_rep_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod1_implicit_ref_point geometry(POINTZ),
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod1_implicit_transformation character varying(1000),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT city_furniture_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: city_furn_lod1brep_fkx | type: INDEX --
CREATE INDEX city_furn_lod1brep_fkx ON public.city_furniture
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod2brep_fkx | type: INDEX --
CREATE INDEX city_furn_lod2brep_fkx ON public.city_furniture
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod3brep_fkx | type: INDEX --
CREATE INDEX city_furn_lod3brep_fkx ON public.city_furniture
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod4brep_fkx | type: INDEX --
CREATE INDEX city_furn_lod4brep_fkx ON public.city_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1xgeom_spx | type: INDEX --
CREATE INDEX city_furn_lod1xgeom_spx ON public.city_furniture
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: city_furn_lod2xgeom_spx | type: INDEX --
CREATE INDEX city_furn_lod2xgeom_spx ON public.city_furniture
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: city_furn_lod3xgeom_spx | type: INDEX --
CREATE INDEX city_furn_lod3xgeom_spx ON public.city_furniture
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: city_furn_lod4xgeom_spx | type: INDEX --
CREATE INDEX city_furn_lod4xgeom_spx ON public.city_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: city_furn_lod1impl_fkx | type: INDEX --
CREATE INDEX city_furn_lod1impl_fkx ON public.city_furniture
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod2impl_fkx | type: INDEX --
CREATE INDEX city_furn_lod2impl_fkx ON public.city_furniture
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod3impl_fkx | type: INDEX --
CREATE INDEX city_furn_lod3impl_fkx ON public.city_furniture
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod4impl_fkx | type: INDEX --
CREATE INDEX city_furn_lod4impl_fkx ON public.city_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1terr_spx | type: INDEX --
CREATE INDEX city_furn_lod1terr_spx ON public.city_furniture
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod2terr_spx | type: INDEX --
CREATE INDEX city_furn_lod2terr_spx ON public.city_furniture
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod3terr_spx | type: INDEX --
CREATE INDEX city_furn_lod3terr_spx ON public.city_furniture
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod4terr_spx | type: INDEX --
CREATE INDEX city_furn_lod4terr_spx ON public.city_furniture
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod1refpnt_spx | type: INDEX --
CREATE INDEX city_furn_lod1refpnt_spx ON public.city_furniture
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod2refpnt_spx | type: INDEX --
CREATE INDEX city_furn_lod2refpnt_spx ON public.city_furniture
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod3refpnt_spx | type: INDEX --
CREATE INDEX city_furn_lod3refpnt_spx ON public.city_furniture
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod4refpnt_spx | type: INDEX --
CREATE INDEX city_furn_lod4refpnt_spx ON public.city_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.cityobject_genericattrib | type: TABLE --
CREATE TABLE public.cityobject_genericattrib(
	id integer NOT NULL DEFAULT nextval('cityobject_genericatt_seq'::regclass),
	parent_genattrib_id integer,
	root_genattrib_id integer,
	attrname character varying(256) NOT NULL,
	datatype numeric,
	strval character varying(4000),
	intval integer,
	realval real,
	urival character varying(4000),
	dateval date,
	geomval geometry,
	blobval bytea,
	unit character varying(4000),
	genattrib_set_codespace character varying(4000),
	cityobject_id integer NOT NULL,
	surface_geometry_id integer,
	CONSTRAINT cityobj_genericattrib_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: genericattrib_parent_fkx | type: INDEX --
CREATE INDEX genericattrib_parent_fkx ON public.cityobject_genericattrib
	USING btree
	(
	  parent_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_root_fkx | type: INDEX --
CREATE INDEX genericattrib_root_fkx ON public.cityobject_genericattrib
	USING btree
	(
	  root_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_cityobj_fkx | type: INDEX --
CREATE INDEX genericattrib_cityobj_fkx ON public.cityobject_genericattrib
	USING btree
	(
	  cityobject_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_geom_fkx | type: INDEX --
CREATE INDEX genericattrib_geom_fkx ON public.cityobject_genericattrib
	USING btree
	(
	  surface_geometry_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.generic_cityobject | type: TABLE --
CREATE TABLE public.generic_cityobject(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_terrain_intersection geometry(MULTILINESTRINGZ),
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod0_brep_id integer,
	lod1_brep_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod0_other_geom geometry,
	lod1_other_geom geometry,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod0_implicit_rep_id integer,
	lod1_implicit_rep_id integer,
	lod2_implicit_rep_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod0_implicit_ref_point geometry(POINTZ),
	lod1_implicit_ref_point geometry(POINTZ),
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod0_implicit_transformation character varying(1000),
	lod1_implicit_transformation character varying(1000),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT generic_cityobject_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: gen_object_lod0terr_spx | type: INDEX --
CREATE INDEX gen_object_lod0terr_spx ON public.generic_cityobject
	USING gist
	(
	  lod0_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod1terr_spx | type: INDEX --
CREATE INDEX gen_object_lod1terr_spx ON public.generic_cityobject
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod2terr_spx | type: INDEX --
CREATE INDEX gen_object_lod2terr_spx ON public.generic_cityobject
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod3terr_spx | type: INDEX --
CREATE INDEX gen_object_lod3terr_spx ON public.generic_cityobject
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod4terr_spx | type: INDEX --
CREATE INDEX gen_object_lod4terr_spx ON public.generic_cityobject
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod0brep_fkx | type: INDEX --
CREATE INDEX gen_object_lod0brep_fkx ON public.generic_cityobject
	USING btree
	(
	  lod0_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod1brep_fkx | type: INDEX --
CREATE INDEX gen_object_lod1brep_fkx ON public.generic_cityobject
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod2brep_fkx | type: INDEX --
CREATE INDEX gen_object_lod2brep_fkx ON public.generic_cityobject
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod3brep_fkx | type: INDEX --
CREATE INDEX gen_object_lod3brep_fkx ON public.generic_cityobject
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod4brep_fkx | type: INDEX --
CREATE INDEX gen_object_lod4brep_fkx ON public.generic_cityobject
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod0xgeom_spx | type: INDEX --
CREATE INDEX gen_object_lod0xgeom_spx ON public.generic_cityobject
	USING gist
	(
	  lod0_other_geom
	);
-- ddl-end --

-- object: gen_object_lod1xgeom_spx | type: INDEX --
CREATE INDEX gen_object_lod1xgeom_spx ON public.generic_cityobject
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: gen_object_lod2xgeom_spx | type: INDEX --
CREATE INDEX gen_object_lod2xgeom_spx ON public.generic_cityobject
	USING gist
	(
	  lod2_other_geom ASC NULLS LAST
	);
-- ddl-end --

-- object: gen_object_lod3xgeom_spx | type: INDEX --
CREATE INDEX gen_object_lod3xgeom_spx ON public.generic_cityobject
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: gen_object_lod4xgeom_spx | type: INDEX --
CREATE INDEX gen_object_lod4xgeom_spx ON public.generic_cityobject
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: gen_object_lod0impl_fkx | type: INDEX --
CREATE INDEX gen_object_lod0impl_fkx ON public.generic_cityobject
	USING btree
	(
	  lod0_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod1impl_fkx | type: INDEX --
CREATE INDEX gen_object_lod1impl_fkx ON public.generic_cityobject
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod2impl_fkx | type: INDEX --
CREATE INDEX gen_object_lod2impl_fkx ON public.generic_cityobject
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod3impl_fkx | type: INDEX --
CREATE INDEX gen_object_lod3impl_fkx ON public.generic_cityobject
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod4impl_fkx | type: INDEX --
CREATE INDEX gen_object_lod4impl_fkx ON public.generic_cityobject
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod0refpnt_spx | type: INDEX --
CREATE INDEX gen_object_lod0refpnt_spx ON public.generic_cityobject
	USING gist
	(
	  lod0_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod1refpnt_spx | type: INDEX --
CREATE INDEX gen_object_lod1refpnt_spx ON public.generic_cityobject
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod2refpnt_spx | type: INDEX --
CREATE INDEX gen_object_lod2refpnt_spx ON public.generic_cityobject
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod3refpnt_spx | type: INDEX --
CREATE INDEX gen_object_lod3refpnt_spx ON public.generic_cityobject
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod4refpnt_spx | type: INDEX --
CREATE INDEX gen_object_lod4refpnt_spx ON public.generic_cityobject
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.address | type: TABLE --
CREATE TABLE public.address(
	id integer NOT NULL DEFAULT nextval('address_seq'::regclass),
	street character varying(1000),
	house_number character varying(256),
	po_box character varying(256),
	zip_code character varying(256),
	city character varying(256),
	state character varying(256),
	country character varying(256),
	multi_point geometry(MULTIPOINTZ),
	xal_source text,
	CONSTRAINT address_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: public.address_to_building | type: TABLE --
CREATE TABLE public.address_to_building(
	building_id integer NOT NULL,
	address_id integer NOT NULL,
	CONSTRAINT address_to_building_pk PRIMARY KEY (building_id,address_id)

);
-- ddl-end --
-- object: address_to_building_fkx | type: INDEX --
CREATE INDEX address_to_building_fkx ON public.address_to_building
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: address_to_building_fkx1 | type: INDEX --
CREATE INDEX address_to_building_fkx1 ON public.address_to_building
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.building | type: TABLE --
CREATE TABLE public.building(
	id integer NOT NULL,
	building_parent_id integer,
	building_root_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	year_of_construction date,
	year_of_demolition date,
	roof_type character varying(256),
	roof_type_codespace character varying(4000),
	measured_height double precision,
	measured_height_unit character varying(4000),
	storeys_above_ground numeric(8,0),
	storeys_below_ground numeric(8,0),
	storey_heights_above_ground character varying(4000),
	storey_heights_below_ground character varying(4000),
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_multi_curve geometry(MULTILINESTRINGZ),
	lod3_multi_curve geometry(MULTILINESTRINGZ),
	lod4_multi_curve geometry(MULTILINESTRINGZ),
	lod0_footprint_id integer,
	lod0_roofprint_id integer,
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod1_solid_id integer,
	lod2_solid_id integer,
	lod3_solid_id integer,
	lod4_solid_id integer,
	CONSTRAINT building_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: building_parent_fkx | type: INDEX --
CREATE INDEX building_parent_fkx ON public.building
	USING btree
	(
	  building_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_root_fkx | type: INDEX --
CREATE INDEX building_root_fkx ON public.building
	USING btree
	(
	  building_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1terr_spx | type: INDEX --
CREATE INDEX building_lod1terr_spx ON public.building
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: building_lod2terr_spx | type: INDEX --
CREATE INDEX building_lod2terr_spx ON public.building
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: building_lod3terr_spx | type: INDEX --
CREATE INDEX building_lod3terr_spx ON public.building
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: building_lod4terr_spx | type: INDEX --
CREATE INDEX building_lod4terr_spx ON public.building
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: building_lod2curve_spx | type: INDEX --
CREATE INDEX building_lod2curve_spx ON public.building
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: building_lod3curve_spx | type: INDEX --
CREATE INDEX building_lod3curve_spx ON public.building
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: building_lod4curve_spx | type: INDEX --
CREATE INDEX building_lod4curve_spx ON public.building
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: building_lod0footprint_fkx | type: INDEX --
CREATE INDEX building_lod0footprint_fkx ON public.building
	USING btree
	(
	  lod0_footprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod0roofprint_fkx | type: INDEX --
CREATE INDEX building_lod0roofprint_fkx ON public.building
	USING btree
	(
	  lod0_roofprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1msrf_fkx | type: INDEX --
CREATE INDEX building_lod1msrf_fkx ON public.building
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod2msrf_fkx | type: INDEX --
CREATE INDEX building_lod2msrf_fkx ON public.building
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod3msrf_fkx | type: INDEX --
CREATE INDEX building_lod3msrf_fkx ON public.building
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod4msrf_fkx | type: INDEX --
CREATE INDEX building_lod4msrf_fkx ON public.building
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1solid_fkx | type: INDEX --
CREATE INDEX building_lod1solid_fkx ON public.building
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod2solid_fkx | type: INDEX --
CREATE INDEX building_lod2solid_fkx ON public.building
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod3solid_fkx | type: INDEX --
CREATE INDEX building_lod3solid_fkx ON public.building
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod4solid_fkx | type: INDEX --
CREATE INDEX building_lod4solid_fkx ON public.building
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.building_furniture | type: TABLE --
CREATE TABLE public.building_furniture(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	room_id integer NOT NULL,
	lod4_brep_id integer,
	lod4_other_geom geometry,
	lod4_implicit_rep_id integer,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT building_furniture_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bldg_furn_room_fkx | type: INDEX --
CREATE INDEX bldg_furn_room_fkx ON public.building_furniture
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4brep_fkx | type: INDEX --
CREATE INDEX bldg_furn_lod4brep_fkx ON public.building_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4xgeom_spx | type: INDEX --
CREATE INDEX bldg_furn_lod4xgeom_spx ON public.building_furniture
	USING btree
	(
	  lod4_other_geom ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4impl_fkx | type: INDEX --
CREATE INDEX bldg_furn_lod4impl_fkx ON public.building_furniture
	USING btree
	(
	  lod4_implicit_rep_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4refpt_spx | type: INDEX --
CREATE INDEX bldg_furn_lod4refpt_spx ON public.building_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.building_installation | type: TABLE --
CREATE TABLE public.building_installation(
	id integer NOT NULL,
	is_external numeric,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	building_id integer,
	room_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod2_implcity_rep_id integer,
	lod3_implcity_rep_id integer,
	lod4_implcity_rep_id integer,
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT building_installation_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bldg_inst_building_fkx | type: INDEX --
CREATE INDEX bldg_inst_building_fkx ON public.building_installation
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_room_fkx | type: INDEX --
CREATE INDEX bldg_inst_room_fkx ON public.building_installation
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2brep_fkx | type: INDEX --
CREATE INDEX bldg_inst_lod2brep_fkx ON public.building_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod3brep_fkx | type: INDEX --
CREATE INDEX bldg_inst_lod3brep_fkx ON public.building_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod4brep_fkx | type: INDEX --
CREATE INDEX bldg_inst_lod4brep_fkx ON public.building_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2xgeom_spx | type: INDEX --
CREATE INDEX bldg_inst_lod2xgeom_spx ON public.building_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod3xgeom_spx | type: INDEX --
CREATE INDEX bldg_inst_lod3xgeom_spx ON public.building_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod4xgeom_spx | type: INDEX --
CREATE INDEX bldg_inst_lod4xgeom_spx ON public.building_installation
	USING gist
	(
	  lod4_other_geom ASC NULLS LAST
	);
-- ddl-end --

-- object: bldg_inst_lod2impl_fkx | type: INDEX --
CREATE INDEX bldg_inst_lod2impl_fkx ON public.building_installation
	USING btree
	(
	  lod2_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod3impl_fkx | type: INDEX --
CREATE INDEX bldg_inst_lod3impl_fkx ON public.building_installation
	USING btree
	(
	  lod3_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod4impl_fkx | type: INDEX --
CREATE INDEX bldg_inst_lod4impl_fkx ON public.building_installation
	USING btree
	(
	  lod4_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2refpt_spx | type: INDEX --
CREATE INDEX bldg_inst_lod2refpt_spx ON public.building_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_lod3refpt_spx | type: INDEX --
CREATE INDEX bldg_inst_lod3refpt_spx ON public.building_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_lod4refpt_spx | type: INDEX --
CREATE INDEX bldg_inst_lod4refpt_spx ON public.building_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.opening | type: TABLE --
CREATE TABLE public.opening(
	id integer NOT NULL,
	objectclass_id integer,
	address_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT opening_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: opening_objectclass_fkx | type: INDEX --
CREATE INDEX opening_objectclass_fkx ON public.opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_address_fkx | type: INDEX --
CREATE INDEX opening_address_fkx ON public.opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3msrf_fkx | type: INDEX --
CREATE INDEX opening_lod3msrf_fkx ON public.opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod4msrf_fkx | type: INDEX --
CREATE INDEX opening_lod4msrf_fkx ON public.opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3impl_fkx | type: INDEX --
CREATE INDEX opening_lod3impl_fkx ON public.opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod4impl_fkx | type: INDEX --
CREATE INDEX opening_lod4impl_fkx ON public.opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3refpt_spx | type: INDEX --
CREATE INDEX opening_lod3refpt_spx ON public.opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: opening_lod4refpt_spx | type: INDEX --
CREATE INDEX opening_lod4refpt_spx ON public.opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.opening_to_them_surface | type: TABLE --
CREATE TABLE public.opening_to_them_surface(
	opening_id integer NOT NULL,
	thematic_surface_id integer NOT NULL,
	CONSTRAINT opening_to_them_surface_pk PRIMARY KEY (opening_id,thematic_surface_id)

);
-- ddl-end --
-- object: open_to_them_surface_fkx | type: INDEX --
CREATE INDEX open_to_them_surface_fkx ON public.opening_to_them_surface
	USING btree
	(
	  opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: open_to_them_surface_fkx1 | type: INDEX --
CREATE INDEX open_to_them_surface_fkx1 ON public.opening_to_them_surface
	USING btree
	(
	  thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.room | type: TABLE --
CREATE TABLE public.room(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	building_id integer NOT NULL,
	lod4_multi_surface_id integer,
	lod4_solid_id integer,
	CONSTRAINT room_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: room_building_fkx | type: INDEX --
CREATE INDEX room_building_fkx ON public.room
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_lod4msrf_fkx | type: INDEX --
CREATE INDEX room_lod4msrf_fkx ON public.room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_lod4solid_fkx | type: INDEX --
CREATE INDEX room_lod4solid_fkx ON public.room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.thematic_surface | type: TABLE --
CREATE TABLE public.thematic_surface(
	id integer NOT NULL,
	objectclass_id integer,
	building_id integer,
	room_id integer,
	building_installation_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT thematic_surface_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: them_surface_objclass_fkx | type: INDEX --
CREATE INDEX them_surface_objclass_fkx ON public.thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_building_fkx | type: INDEX --
CREATE INDEX them_surface_building_fkx ON public.thematic_surface
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_room_fkx | type: INDEX --
CREATE INDEX them_surface_room_fkx ON public.thematic_surface
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_bldg_inst_fkx | type: INDEX --
CREATE INDEX them_surface_bldg_inst_fkx ON public.thematic_surface
	USING btree
	(
	  building_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod2msrf_fkx | type: INDEX --
CREATE INDEX them_surface_lod2msrf_fkx ON public.thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod3msrf_fkx | type: INDEX --
CREATE INDEX them_surface_lod3msrf_fkx ON public.thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod4msrf_fkx | type: INDEX --
CREATE INDEX them_surface_lod4msrf_fkx ON public.thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.appearance | type: TABLE --
CREATE TABLE public.appearance(
	id integer NOT NULL DEFAULT nextval('appearance_seq'::regclass),
	gmlid character varying(256),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	theme character varying(256),
	citymodel_id integer,
	cityobject_id integer,
	CONSTRAINT appearance_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: appearance_inx | type: INDEX --
CREATE INDEX appearance_inx ON public.appearance
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_theme_inx | type: INDEX --
CREATE INDEX appearance_theme_inx ON public.appearance
	USING btree
	(
	  theme ASC NULLS LAST
	);
-- ddl-end --

-- object: appearance_citymodel_fkx | type: INDEX --
CREATE INDEX appearance_citymodel_fkx ON public.appearance
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_cityobject_fkx | type: INDEX --
CREATE INDEX appearance_cityobject_fkx ON public.appearance
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.surface_data | type: TABLE --
CREATE TABLE public.surface_data(
	id integer NOT NULL DEFAULT nextval('surface_data_seq'::regclass),
	gmlid character varying(256),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	is_front numeric,
	objectclass_id integer,
	x3d_shininess double precision,
	x3d_transparency double precision,
	x3d_ambient_intensity double precision,
	x3d_specular_color character varying(256),
	x3d_diffuse_color character varying(256),
	x3d_emissive_color character varying(256),
	x3d_is_smooth numeric,
	tex_image_id integer,
	tex_texture_type character varying(256),
	tex_wrap_mode character varying(256),
	tex_border_color character varying(256),
	gt_prefer_worldfile numeric,
	gt_orientation character varying(256),
	gt_reference_point geometry(POINTZ),
	CONSTRAINT surface_data_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: surface_data_inx | type: INDEX --
CREATE INDEX surface_data_inx ON public.surface_data
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_data_spx | type: INDEX --
CREATE INDEX surface_data_spx ON public.surface_data
	USING gist
	(
	  gt_reference_point
	);
-- ddl-end --


-- object: public.textureparam | type: TABLE --
CREATE TABLE public.textureparam(
	surface_geometry_id integer NOT NULL,
	is_texture_parametrization numeric,
	world_to_texture character varying(1000),
	texture_coordinates character varying(4000),
	surface_data_id integer NOT NULL,
	CONSTRAINT textureparam_pk PRIMARY KEY (surface_geometry_id,surface_data_id)

);
-- ddl-end --
-- object: texparam_geom_fkx | type: INDEX --
CREATE INDEX texparam_geom_fkx ON public.textureparam
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: texparam_surface_data_fkx | type: INDEX --
CREATE INDEX texparam_surface_data_fkx ON public.textureparam
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.appear_to_surface_data | type: TABLE --
CREATE TABLE public.appear_to_surface_data(
	surface_data_id integer NOT NULL,
	appearance_id integer NOT NULL,
	CONSTRAINT appear_to_surface_data_pk PRIMARY KEY (surface_data_id,appearance_id)

);
-- ddl-end --
-- object: app_to_surf_data_fkx | type: INDEX --
CREATE INDEX app_to_surf_data_fkx ON public.appear_to_surface_data
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: app_to_surf_data_fkx1 | type: INDEX --
CREATE INDEX app_to_surf_data_fkx1 ON public.appear_to_surface_data
	USING btree
	(
	  appearance_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.breakline_relief | type: TABLE --
CREATE TABLE public.breakline_relief(
	id integer NOT NULL,
	ridge_or_valley_lines geometry(MULTILINESTRINGZ),
	break_lines geometry(MULTILINESTRINGZ),
	CONSTRAINT breakline_relief_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: breakline_ridge_spx | type: INDEX --
CREATE INDEX breakline_ridge_spx ON public.breakline_relief
	USING gist
	(
	  ridge_or_valley_lines
	);
-- ddl-end --

-- object: breakline_break_spx | type: INDEX --
CREATE INDEX breakline_break_spx ON public.breakline_relief
	USING gist
	(
	  break_lines
	);
-- ddl-end --


-- object: public.masspoint_relief | type: TABLE --
CREATE TABLE public.masspoint_relief(
	id integer NOT NULL,
	relief_points geometry(MULTIPOINTZ),
	CONSTRAINT masspoint_relief_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: masspoint_relief_spx | type: INDEX --
CREATE INDEX masspoint_relief_spx ON public.masspoint_relief
	USING gist
	(
	  relief_points
	);
-- ddl-end --


-- object: public.relief_component | type: TABLE --
CREATE TABLE public.relief_component(
	id integer NOT NULL,
	objectclass_id integer,
	lod numeric,
	extent geometry(POLYGON),
	CONSTRAINT relief_component_pk PRIMARY KEY (id),
	CONSTRAINT relief_comp_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)))

);
-- ddl-end --
-- object: relief_comp_objclass_fkx | type: INDEX --
CREATE INDEX relief_comp_objclass_fkx ON public.relief_component
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: relief_comp_extent_spx | type: INDEX --
CREATE INDEX relief_comp_extent_spx ON public.relief_component
	USING gist
	(
	  extent
	);
-- ddl-end --


-- object: public.relief_feat_to_rel_comp | type: TABLE --
CREATE TABLE public.relief_feat_to_rel_comp(
	relief_component_id integer NOT NULL,
	relief_feature_id integer NOT NULL,
	CONSTRAINT relief_feat_to_rel_comp_pk PRIMARY KEY (relief_component_id,relief_feature_id)

);
-- ddl-end --
-- object: public.relief_feature | type: TABLE --
CREATE TABLE public.relief_feature(
	id integer NOT NULL,
	lod numeric,
	CONSTRAINT relief_feature_pk PRIMARY KEY (id),
	CONSTRAINT relief_feat_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)))

);
-- ddl-end --
-- object: public.tin_relief | type: TABLE --
CREATE TABLE public.tin_relief(
	id integer NOT NULL,
	max_length double precision,
	stop_lines geometry(MULTILINESTRINGZ),
	break_lines geometry(MULTILINESTRINGZ),
	control_points geometry(MULTIPOINTZ),
	surface_geometry_id integer,
	CONSTRAINT tin_relief_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tin_relief_geom_fkx | type: INDEX --
CREATE INDEX tin_relief_geom_fkx ON public.tin_relief
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_stop_spx | type: INDEX --
CREATE INDEX tin_relief_stop_spx ON public.tin_relief
	USING gist
	(
	  stop_lines
	);
-- ddl-end --

-- object: tin_relief_break_spx | type: INDEX --
CREATE INDEX tin_relief_break_spx ON public.tin_relief
	USING gist
	(
	  break_lines
	);
-- ddl-end --

-- object: tin_relief_crtlpts_spx | type: INDEX --
CREATE INDEX tin_relief_crtlpts_spx ON public.tin_relief
	USING gist
	(
	  control_points
	);
-- ddl-end --


-- object: public.transportation_complex | type: TABLE --
CREATE TABLE public.transportation_complex(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_network geometry,
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT transportation_complex_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tran_complex_objclass_fkx | type: INDEX --
CREATE INDEX tran_complex_objclass_fkx ON public.transportation_complex
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod0net_spx | type: INDEX --
CREATE INDEX tran_complex_lod0net_spx ON public.transportation_complex
	USING gist
	(
	  lod0_network
	);
-- ddl-end --

-- object: tran_complex_lod1msrf_fkx | type: INDEX --
CREATE INDEX tran_complex_lod1msrf_fkx ON public.transportation_complex
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod2msrf_fkx | type: INDEX --
CREATE INDEX tran_complex_lod2msrf_fkx ON public.transportation_complex
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod3msrf_fkx | type: INDEX --
CREATE INDEX tran_complex_lod3msrf_fkx ON public.transportation_complex
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod4msrf_fkx | type: INDEX --
CREATE INDEX tran_complex_lod4msrf_fkx ON public.transportation_complex
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.traffic_area | type: TABLE --
CREATE TABLE public.traffic_area(
	id integer NOT NULL,
	is_auxiliary numeric,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	surface_material character varying(256),
	surface_material_codespace character varying(4000),
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	transportation_complex_id integer NOT NULL,
	CONSTRAINT traffic_area_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: traffic_area_lod2msrf_fkx | type: INDEX --
CREATE INDEX traffic_area_lod2msrf_fkx ON public.traffic_area
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_lod3msrf_fkx | type: INDEX --
CREATE INDEX traffic_area_lod3msrf_fkx ON public.traffic_area
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_lod4msrf_fkx | type: INDEX --
CREATE INDEX traffic_area_lod4msrf_fkx ON public.traffic_area
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_trancmplx_fkx | type: INDEX --
CREATE INDEX traffic_area_trancmplx_fkx ON public.traffic_area
	USING btree
	(
	  transportation_complex_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.land_use | type: TABLE --
CREATE TABLE public.land_use(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_multi_surface_id integer,
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT land_use_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: land_use_lod0msrf_fkx | type: INDEX --
CREATE INDEX land_use_lod0msrf_fkx ON public.land_use
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod1msrf_fkx | type: INDEX --
CREATE INDEX land_use_lod1msrf_fkx ON public.land_use
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod2msrf_fkx | type: INDEX --
CREATE INDEX land_use_lod2msrf_fkx ON public.land_use
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod3msrf_fkx | type: INDEX --
CREATE INDEX land_use_lod3msrf_fkx ON public.land_use
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod4msrf_fkx | type: INDEX --
CREATE INDEX land_use_lod4msrf_fkx ON public.land_use
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.plant_cover | type: TABLE --
CREATE TABLE public.plant_cover(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	average_height double precision,
	average_height_unit character varying(4000),
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod1_solid_id integer,
	lod2_solid_id integer,
	lod3_solid_id integer,
	lod4_solid_id integer,
	CONSTRAINT plant_cover_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: plant_cover_lod1msrf_fkx | type: INDEX --
CREATE INDEX plant_cover_lod1msrf_fkx ON public.plant_cover
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod2msrf_fkx | type: INDEX --
CREATE INDEX plant_cover_lod2msrf_fkx ON public.plant_cover
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod3msrf_fkx | type: INDEX --
CREATE INDEX plant_cover_lod3msrf_fkx ON public.plant_cover
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod4msrf_fkx | type: INDEX --
CREATE INDEX plant_cover_lod4msrf_fkx ON public.plant_cover
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod1solid_fkx | type: INDEX --
CREATE INDEX plant_cover_lod1solid_fkx ON public.plant_cover
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod2solid_fkx | type: INDEX --
CREATE INDEX plant_cover_lod2solid_fkx ON public.plant_cover
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod3solid_fkx | type: INDEX --
CREATE INDEX plant_cover_lod3solid_fkx ON public.plant_cover
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod4solid_fkx | type: INDEX --
CREATE INDEX plant_cover_lod4solid_fkx ON public.plant_cover
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.solitary_vegetat_object | type: TABLE --
CREATE TABLE public.solitary_vegetat_object(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	species character varying(1000),
	species_codespace character varying(4000),
	height double precision,
	height_unit character varying(4000),
	trunc_diameter double precision,
	trunc_diameter_unit character varying(4000),
	crown_diameter double precision,
	crown_diameter_unit character varying(4000),
	lod1_brep_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod1_other_geom geometry,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod1_implicit_rep_id integer,
	lod2_implicit_rep_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod1_implicit_ref_point geometry(POINTZ),
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod1_implicit_transformation character varying(1000),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT solitary_veg_object_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: sol_veg_obj_lod1brep_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod1brep_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod2brep_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod2brep_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod3brep_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod3brep_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod4brep_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod4brep_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1xgeom_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod1xgeom_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod2xgeom_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod2xgeom_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod3xgeom_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod3xgeom_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod4xgeom_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod4xgeom_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod1impl_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod1impl_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod2impl_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod2impl_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod3impl_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod3impl_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod4impl_fkx | type: INDEX --
CREATE INDEX sol_veg_obj_lod4impl_fkx ON public.solitary_vegetat_object
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1refpt_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod1refpt_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod2refpt_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod2refpt_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod3refpt_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod3refpt_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod4refpt_spx | type: INDEX --
CREATE INDEX sol_veg_obj_lod4refpt_spx ON public.solitary_vegetat_object
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.waterbody | type: TABLE --
CREATE TABLE public.waterbody(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_multi_curve geometry(MULTILINESTRINGZ),
	lod1_multi_curve geometry(MULTILINESTRINGZ),
	lod0_multi_surface_id integer,
	lod1_multi_surface_id integer,
	lod1_solid_id integer,
	lod2_solid_id integer,
	lod3_solid_id integer,
	lod4_solid_id integer,
	CONSTRAINT waterbody_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: waterbody_lod0curve_spx | type: INDEX --
CREATE INDEX waterbody_lod0curve_spx ON public.waterbody
	USING gist
	(
	  lod0_multi_curve
	);
-- ddl-end --

-- object: waterbody_lod1curve_spx | type: INDEX --
CREATE INDEX waterbody_lod1curve_spx ON public.waterbody
	USING gist
	(
	  lod1_multi_curve
	);
-- ddl-end --

-- object: waterbody_lod0msrf_fkx | type: INDEX --
CREATE INDEX waterbody_lod0msrf_fkx ON public.waterbody
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod1msrf_fkx | type: INDEX --
CREATE INDEX waterbody_lod1msrf_fkx ON public.waterbody
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod1solid_fkx | type: INDEX --
CREATE INDEX waterbody_lod1solid_fkx ON public.waterbody
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod2solid_fkx | type: INDEX --
CREATE INDEX waterbody_lod2solid_fkx ON public.waterbody
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod3solid_fkx | type: INDEX --
CREATE INDEX waterbody_lod3solid_fkx ON public.waterbody
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod4solid_fkx | type: INDEX --
CREATE INDEX waterbody_lod4solid_fkx ON public.waterbody
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.waterbod_to_waterbnd_srf | type: TABLE --
CREATE TABLE public.waterbod_to_waterbnd_srf(
	waterboundary_surface_id integer NOT NULL,
	waterbody_id integer NOT NULL,
	CONSTRAINT waterbod_to_waterbnd_pk PRIMARY KEY (waterboundary_surface_id,waterbody_id)

);
-- ddl-end --
-- object: waterbod_to_waterbnd_fkx | type: INDEX --
CREATE INDEX waterbod_to_waterbnd_fkx ON public.waterbod_to_waterbnd_srf
	USING btree
	(
	  waterboundary_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbod_to_waterbnd_fkx1 | type: INDEX --
CREATE INDEX waterbod_to_waterbnd_fkx1 ON public.waterbod_to_waterbnd_srf
	USING btree
	(
	  waterbody_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.waterboundary_surface | type: TABLE --
CREATE TABLE public.waterboundary_surface(
	id integer NOT NULL,
	objectclass_id integer,
	water_level character varying(256),
	water_level_codespace character varying(4000),
	lod2_surface_id integer,
	lod3_surface_id integer,
	lod4_surface_id integer,
	CONSTRAINT waterboundary_surface_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: waterbnd_srf_objclass_fkx | type: INDEX --
CREATE INDEX waterbnd_srf_objclass_fkx ON public.waterboundary_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod2srf_fkx | type: INDEX --
CREATE INDEX waterbnd_srf_lod2srf_fkx ON public.waterboundary_surface
	USING btree
	(
	  lod2_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod3srf_fkx | type: INDEX --
CREATE INDEX waterbnd_srf_lod3srf_fkx ON public.waterboundary_surface
	USING btree
	(
	  lod3_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod4srf_fkx | type: INDEX --
CREATE INDEX waterbnd_srf_lod4srf_fkx ON public.waterboundary_surface
	USING btree
	(
	  lod4_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.raster_relief | type: TABLE --
CREATE TABLE public.raster_relief(
	id integer NOT NULL,
	raster_uri character varying(4000),
	raster_id integer,
	CONSTRAINT raster_relief_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: raster_relief_raster_fkx | type: INDEX --
CREATE INDEX raster_relief_raster_fkx ON public.raster_relief
	USING btree
	(
	  raster_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.tunnel | type: TABLE --
CREATE TABLE public.tunnel(
	id integer NOT NULL,
	tunnel_parent_id integer,
	tunnel_root_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	year_of_construction date,
	year_of_demolition date,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_multi_curve geometry(MULTILINESTRINGZ),
	lod3_multi_curve geometry(MULTILINESTRINGZ),
	lod4_multi_curve geometry(MULTILINESTRINGZ),
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod1_solid_id smallint,
	lod2_solid_id smallint,
	lod3_solid_id smallint,
	lod4_solid_id smallint,
	CONSTRAINT tunnel_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tunnel_parent_fkx | type: INDEX --
CREATE INDEX tunnel_parent_fkx ON public.tunnel
	USING btree
	(
	  tunnel_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_root_fkx | type: INDEX --
CREATE INDEX tunnel_root_fkx ON public.tunnel
	USING btree
	(
	  tunnel_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod1terr_spx | type: INDEX --
CREATE INDEX tunnel_lod1terr_spx ON public.tunnel
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod2terr_spx | type: INDEX --
CREATE INDEX tunnel_lod2terr_spx ON public.tunnel
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod3terr_spx | type: INDEX --
CREATE INDEX tunnel_lod3terr_spx ON public.tunnel
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod4terr_spx | type: INDEX --
CREATE INDEX tunnel_lod4terr_spx ON public.tunnel
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod2curve_spx | type: INDEX --
CREATE INDEX tunnel_lod2curve_spx ON public.tunnel
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod3curve_spx | type: INDEX --
CREATE INDEX tunnel_lod3curve_spx ON public.tunnel
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod4curve_spx | type: INDEX --
CREATE INDEX tunnel_lod4curve_spx ON public.tunnel
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod1msrf_fkx | type: INDEX --
CREATE INDEX tunnel_lod1msrf_fkx ON public.tunnel
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod2msrf_fkx | type: INDEX --
CREATE INDEX tunnel_lod2msrf_fkx ON public.tunnel
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod3msrf_fkx | type: INDEX --
CREATE INDEX tunnel_lod3msrf_fkx ON public.tunnel
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod4msrf_fkx | type: INDEX --
CREATE INDEX tunnel_lod4msrf_fkx ON public.tunnel
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod1solid_fkx | type: INDEX --
CREATE INDEX tunnel_lod1solid_fkx ON public.tunnel
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod2solid_fkx | type: INDEX --
CREATE INDEX tunnel_lod2solid_fkx ON public.tunnel
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod3solid_fkx | type: INDEX --
CREATE INDEX tunnel_lod3solid_fkx ON public.tunnel
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod4solid_fkx | type: INDEX --
CREATE INDEX tunnel_lod4solid_fkx ON public.tunnel
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.tunnel_open_to_them_srf | type: TABLE --
CREATE TABLE public.tunnel_open_to_them_srf(
	tunnel_opening_id integer NOT NULL,
	tunnel_thematic_surface_id integer NOT NULL,
	CONSTRAINT tunnel_open_to_them_srf_pk PRIMARY KEY (tunnel_opening_id,tunnel_thematic_surface_id)

);
-- ddl-end --
-- object: tun_open_to_them_srf_fkx | type: INDEX --
CREATE INDEX tun_open_to_them_srf_fkx ON public.tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_open_to_them_srf_fkx1 | type: INDEX --
CREATE INDEX tun_open_to_them_srf_fkx1 ON public.tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.tunnel_hollow_space | type: TABLE --
CREATE TABLE public.tunnel_hollow_space(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_id integer NOT NULL,
	lod4_multi_surface_id integer,
	lod4_solid_id integer,
	CONSTRAINT tunnel_hollow_space_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tun_hspace_tunnel_fkx | type: INDEX --
CREATE INDEX tun_hspace_tunnel_fkx ON public.tunnel_hollow_space
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_lod4msrf_fkx | type: INDEX --
CREATE INDEX tun_hspace_lod4msrf_fkx ON public.tunnel_hollow_space
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_lod4solid_fkx | type: INDEX --
CREATE INDEX tun_hspace_lod4solid_fkx ON public.tunnel_hollow_space
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.tunnel_thematic_surface | type: TABLE --
CREATE TABLE public.tunnel_thematic_surface(
	id integer NOT NULL,
	objectclass_id integer,
	tunnel_id integer,
	tunnel_hollow_space_id integer,
	tunnel_installation_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT tunnel_thematic_surface_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tun_them_surf_objclass_fkx | type: INDEX --
CREATE INDEX tun_them_surf_objclass_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: tun_them_srf_tunnel_fkx | type: INDEX --
CREATE INDEX tun_them_srf_tunnel_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_hspace_fkx | type: INDEX --
CREATE INDEX tun_them_srf_hspace_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_tun_inst_fkx | type: INDEX --
CREATE INDEX tun_them_srf_tun_inst_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  tunnel_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod2msrf_fkx | type: INDEX --
CREATE INDEX tun_them_srf_lod2msrf_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod3msrf_fkx | type: INDEX --
CREATE INDEX tun_them_srf_lod3msrf_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod4msrf_fkx | type: INDEX --
CREATE INDEX tun_them_srf_lod4msrf_fkx ON public.tunnel_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.tex_image | type: TABLE --
CREATE TABLE public.tex_image(
	id integer NOT NULL DEFAULT nextval('tex_image_seq'::regclass),
	tey_image_uri character varying(4000),
	tey_image bytea,
	tex_mime_type character varying(256),
	tex_mime_type_codespace character varying(4000),
	CONSTRAINT tex_image_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: public.tunnel_opening | type: TABLE --
CREATE TABLE public.tunnel_opening(
	id integer NOT NULL,
	objectclass_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_opening_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tunnel_open_objclass_fkx | type: INDEX --
CREATE INDEX tunnel_open_objclass_fkx ON public.tunnel_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3msrf_fkx | type: INDEX --
CREATE INDEX tunnel_open_lod3msrf_fkx ON public.tunnel_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod4msrf_fkx | type: INDEX --
CREATE INDEX tunnel_open_lod4msrf_fkx ON public.tunnel_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3impl_fkx | type: INDEX --
CREATE INDEX tunnel_open_lod3impl_fkx ON public.tunnel_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod4impl_fkx | type: INDEX --
CREATE INDEX tunnel_open_lod4impl_fkx ON public.tunnel_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3refpt_spx | type: INDEX --
CREATE INDEX tunnel_open_lod3refpt_spx ON public.tunnel_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_open_lod4refpt_spx | type: INDEX --
CREATE INDEX tunnel_open_lod4refpt_spx ON public.tunnel_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.tunnel_installation | type: TABLE --
CREATE TABLE public.tunnel_installation(
	id integer NOT NULL,
	is_external numeric,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_id integer,
	tunnel_hollow_space_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod2_implcity_rep_id integer,
	lod3_implcity_rep_id integer,
	lod4_implcity_rep_id integer,
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_installation_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tunnel_inst_building_fkx | type: INDEX --
CREATE INDEX tunnel_inst_building_fkx ON public.tunnel_installation
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_room_fkx | type: INDEX --
CREATE INDEX tunnel_inst_room_fkx ON public.tunnel_installation
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2brep_fkx | type: INDEX --
CREATE INDEX tunnel_inst_lod2brep_fkx ON public.tunnel_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod3brep_fkx | type: INDEX --
CREATE INDEX tunnel_inst_lod3brep_fkx ON public.tunnel_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod4brep_fkx | type: INDEX --
CREATE INDEX tunnel_inst_lod4brep_fkx ON public.tunnel_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2xgeom_spx | type: INDEX --
CREATE INDEX tunnel_inst_lod2xgeom_spx ON public.tunnel_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod3xgeom_spx | type: INDEX --
CREATE INDEX tunnel_inst_lod3xgeom_spx ON public.tunnel_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod4xgeom_spx | type: INDEX --
CREATE INDEX tunnel_inst_lod4xgeom_spx ON public.tunnel_installation
	USING gist
	(
	  lod4_other_geom ASC NULLS LAST
	);
-- ddl-end --

-- object: tunnel_inst_lod2impl_fkx | type: INDEX --
CREATE INDEX tunnel_inst_lod2impl_fkx ON public.tunnel_installation
	USING btree
	(
	  lod2_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod3impl_fkx | type: INDEX --
CREATE INDEX tunnel_inst_lod3impl_fkx ON public.tunnel_installation
	USING btree
	(
	  lod3_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod4impl_fkx | type: INDEX --
CREATE INDEX tunnel_inst_lod4impl_fkx ON public.tunnel_installation
	USING btree
	(
	  lod4_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2refpt_spx | type: INDEX --
CREATE INDEX tunnel_inst_lod2refpt_spx ON public.tunnel_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_lod3refpt_spx | type: INDEX --
CREATE INDEX tunnel_inst_lod3refpt_spx ON public.tunnel_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_lod4refpt_spx | type: INDEX --
CREATE INDEX tunnel_inst_lod4refpt_spx ON public.tunnel_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.tunnel_furniture | type: TABLE --
CREATE TABLE public.tunnel_furniture(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_hollow_space_id integer NOT NULL,
	lod4_brep_id integer,
	lod4_other_geom geometry,
	lod4_implicit_rep_id integer,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_furniture_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: tunnel_furn_room_fkx | type: INDEX --
CREATE INDEX tunnel_furn_room_fkx ON public.tunnel_furniture
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4brep_fkx | type: INDEX --
CREATE INDEX tunnel_furn_lod4brep_fkx ON public.tunnel_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4xgeom_spx | type: INDEX --
CREATE INDEX tunnel_furn_lod4xgeom_spx ON public.tunnel_furniture
	USING btree
	(
	  lod4_other_geom ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4impl_fkx | type: INDEX --
CREATE INDEX tunnel_furn_lod4impl_fkx ON public.tunnel_furniture
	USING btree
	(
	  lod4_implicit_rep_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4refpt_spx | type: INDEX --
CREATE INDEX tunnel_furn_lod4refpt_spx ON public.tunnel_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.bridge | type: TABLE --
CREATE TABLE public.bridge(
	id integer NOT NULL,
	bridge_parent_id integer,
	bridge_root_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	year_of_construction date,
	year_of_demolition date,
	is_movable numeric,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_multi_curve geometry(MULTILINESTRINGZ),
	lod3_multi_curve geometry(MULTILINESTRINGZ),
	lod4_multi_curve geometry(MULTILINESTRINGZ),
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod1_solid_id integer,
	lod2_solid_id integer,
	lod3_solid_id integer,
	lod4_solid_id integer,
	CONSTRAINT bridge_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bridge_parent_fkx | type: INDEX --
CREATE INDEX bridge_parent_fkx ON public.bridge
	USING btree
	(
	  bridge_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_root_fkx | type: INDEX --
CREATE INDEX bridge_root_fkx ON public.bridge
	USING btree
	(
	  bridge_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod1terr_spx | type: INDEX --
CREATE INDEX bridge_lod1terr_spx ON public.bridge
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod2terr_spx | type: INDEX --
CREATE INDEX bridge_lod2terr_spx ON public.bridge
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod3terr_spx | type: INDEX --
CREATE INDEX bridge_lod3terr_spx ON public.bridge
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod4terr_spx | type: INDEX --
CREATE INDEX bridge_lod4terr_spx ON public.bridge
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod2curve_spx | type: INDEX --
CREATE INDEX bridge_lod2curve_spx ON public.bridge
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: bridge_lod3curve_spx | type: INDEX --
CREATE INDEX bridge_lod3curve_spx ON public.bridge
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: bridge_lod4curve_spx | type: INDEX --
CREATE INDEX bridge_lod4curve_spx ON public.bridge
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: bridge_lod1msrf_fkx | type: INDEX --
CREATE INDEX bridge_lod1msrf_fkx ON public.bridge
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod2msrf_fkx | type: INDEX --
CREATE INDEX bridge_lod2msrf_fkx ON public.bridge
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod3msrf_fkx | type: INDEX --
CREATE INDEX bridge_lod3msrf_fkx ON public.bridge
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod4msrf_fkx | type: INDEX --
CREATE INDEX bridge_lod4msrf_fkx ON public.bridge
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod1solid_fkx | type: INDEX --
CREATE INDEX bridge_lod1solid_fkx ON public.bridge
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod2solid_fkx | type: INDEX --
CREATE INDEX bridge_lod2solid_fkx ON public.bridge
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod3solid_fkx | type: INDEX --
CREATE INDEX bridge_lod3solid_fkx ON public.bridge
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod4solid_fkx | type: INDEX --
CREATE INDEX bridge_lod4solid_fkx ON public.bridge
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.bridge_furniture | type: TABLE --
CREATE TABLE public.bridge_furniture(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_room_id integer NOT NULL,
	lod4_brep_id integer,
	lod4_other_geom geometry,
	lod4_implicit_rep_id integer,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_furniture_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bridge_furn_brd_room_fkx | type: INDEX --
CREATE INDEX bridge_furn_brd_room_fkx ON public.bridge_furniture
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4brep_fkx | type: INDEX --
CREATE INDEX bridge_furn_lod4brep_fkx ON public.bridge_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4xgeom_spx | type: INDEX --
CREATE INDEX bridge_furn_lod4xgeom_spx ON public.bridge_furniture
	USING btree
	(
	  lod4_other_geom ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4impl_fkx | type: INDEX --
CREATE INDEX bridge_furn_lod4impl_fkx ON public.bridge_furniture
	USING btree
	(
	  lod4_implicit_rep_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4refpt_spx | type: INDEX --
CREATE INDEX bridge_furn_lod4refpt_spx ON public.bridge_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.bridge_installation | type: TABLE --
CREATE TABLE public.bridge_installation(
	id integer NOT NULL,
	is_external numeric,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id integer,
	bridge_room_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod2_implcity_rep_id integer,
	lod3_implcity_rep_id integer,
	lod4_implcity_rep_id integer,
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_installation_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bridge_inst_bridge_fkx | type: INDEX --
CREATE INDEX bridge_inst_bridge_fkx ON public.bridge_installation
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_brd_room_fkx | type: INDEX --
CREATE INDEX bridge_inst_brd_room_fkx ON public.bridge_installation
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2brep_fkx | type: INDEX --
CREATE INDEX bridge_inst_lod2brep_fkx ON public.bridge_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod3brep_fkx | type: INDEX --
CREATE INDEX bridge_inst_lod3brep_fkx ON public.bridge_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod4brep_fkx | type: INDEX --
CREATE INDEX bridge_inst_lod4brep_fkx ON public.bridge_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2xgeom_spx | type: INDEX --
CREATE INDEX bridge_inst_lod2xgeom_spx ON public.bridge_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod3xgeom_spx | type: INDEX --
CREATE INDEX bridge_inst_lod3xgeom_spx ON public.bridge_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod4xgeom_spx | type: INDEX --
CREATE INDEX bridge_inst_lod4xgeom_spx ON public.bridge_installation
	USING gist
	(
	  lod4_other_geom ASC NULLS LAST
	);
-- ddl-end --

-- object: bridge_inst_lod2impl_fkx | type: INDEX --
CREATE INDEX bridge_inst_lod2impl_fkx ON public.bridge_installation
	USING btree
	(
	  lod2_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod3impl_fkx | type: INDEX --
CREATE INDEX bridge_inst_lod3impl_fkx ON public.bridge_installation
	USING btree
	(
	  lod3_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod4impl_fkx | type: INDEX --
CREATE INDEX bridge_inst_lod4impl_fkx ON public.bridge_installation
	USING btree
	(
	  lod4_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2refpt_spx | type: INDEX --
CREATE INDEX bridge_inst_lod2refpt_spx ON public.bridge_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_lod3refpt_spx | type: INDEX --
CREATE INDEX bridge_inst_lod3refpt_spx ON public.bridge_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_lod4refpt_spx | type: INDEX --
CREATE INDEX bridge_inst_lod4refpt_spx ON public.bridge_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.bridge_opening | type: TABLE --
CREATE TABLE public.bridge_opening(
	id integer NOT NULL,
	objectclass_id integer,
	address_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_opening_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bridge_open_objclass_fkx | type: INDEX --
CREATE INDEX bridge_open_objclass_fkx ON public.bridge_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_address_fkx | type: INDEX --
CREATE INDEX bridge_open_address_fkx ON public.bridge_opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3msrf_fkx | type: INDEX --
CREATE INDEX bridge_open_lod3msrf_fkx ON public.bridge_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod4msrf_fkx | type: INDEX --
CREATE INDEX bridge_open_lod4msrf_fkx ON public.bridge_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3impl_fkx | type: INDEX --
CREATE INDEX bridge_open_lod3impl_fkx ON public.bridge_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod4impl_fkx | type: INDEX --
CREATE INDEX bridge_open_lod4impl_fkx ON public.bridge_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3refpt_spx | type: INDEX --
CREATE INDEX bridge_open_lod3refpt_spx ON public.bridge_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_open_lod4refpt_spx | type: INDEX --
CREATE INDEX bridge_open_lod4refpt_spx ON public.bridge_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.bridge_open_to_them_srf | type: TABLE --
CREATE TABLE public.bridge_open_to_them_srf(
	bridge_opening_id integer NOT NULL,
	bridge_thematic_surface_id integer NOT NULL,
	CONSTRAINT bridge_open_to_them_srf_pk PRIMARY KEY (bridge_opening_id,bridge_thematic_surface_id)

);
-- ddl-end --
-- object: brd_open_to_them_srf_fkx | type: INDEX --
CREATE INDEX brd_open_to_them_srf_fkx ON public.bridge_open_to_them_srf
	USING btree
	(
	  bridge_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_open_to_them_srf_fkx1 | type: INDEX --
CREATE INDEX brd_open_to_them_srf_fkx1 ON public.bridge_open_to_them_srf
	USING btree
	(
	  bridge_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.bridge_room | type: TABLE --
CREATE TABLE public.bridge_room(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id integer NOT NULL,
	lod4_multi_surface_id integer,
	lod4_solid_id integer,
	CONSTRAINT bridge_room_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bridge_room_bridge_fkx | type: INDEX --
CREATE INDEX bridge_room_bridge_fkx ON public.bridge_room
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_lod4msrf_fkx | type: INDEX --
CREATE INDEX bridge_room_lod4msrf_fkx ON public.bridge_room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_lod4solid_fkx | type: INDEX --
CREATE INDEX bridge_room_lod4solid_fkx ON public.bridge_room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.bridge_thematic_surface | type: TABLE --
CREATE TABLE public.bridge_thematic_surface(
	id integer NOT NULL,
	objectclass_id integer,
	bridge_id integer,
	bridge_room_id integer,
	bridge_installation_id integer,
	bridge_constr_element_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT bridge_thematic_surface_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: brd_them_srf_objclass_fkx | type: INDEX --
CREATE INDEX brd_them_srf_objclass_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_bridge_fkx | type: INDEX --
CREATE INDEX brd_them_srf_bridge_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_room_fkx | type: INDEX --
CREATE INDEX brd_them_srf_brd_room_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_inst_fkx | type: INDEX --
CREATE INDEX brd_them_srf_brd_inst_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  bridge_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_const_fkx | type: INDEX --
CREATE INDEX brd_them_srf_brd_const_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  bridge_constr_element_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod2msrf_fkx | type: INDEX --
CREATE INDEX brd_them_srf_lod2msrf_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod3msrf_fkx | type: INDEX --
CREATE INDEX brd_them_srf_lod3msrf_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod4msrf_fkx | type: INDEX --
CREATE INDEX brd_them_srf_lod4msrf_fkx ON public.bridge_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --


-- object: public.bridge_constr_element | type: TABLE --
CREATE TABLE public.bridge_constr_element(
	id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id integer,
	bridge_room_id integer,
	lod1_brep_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod1_other_geom geometry,
	lod2_other_geom geometry,
	lod3_other_geom geometry,
	lod4_other_geom geometry,
	lod1_implcity_rep_id integer,
	lod2_implcity_rep_id integer,
	lod3_implcity_rep_id integer,
	lod4_implcity_rep_id integer,
	lod1_implicit_ref_point geometry(POINTZ),
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod1_implicit_transformation character varying(1000),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_constr_element_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: bridge_constr_bridge_fkx | type: INDEX --
CREATE INDEX bridge_constr_bridge_fkx ON public.bridge_constr_element
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_brd_room_fkx | type: INDEX --
CREATE INDEX bridge_constr_brd_room_fkx ON public.bridge_constr_element
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod1brep_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod1brep_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	);
-- ddl-end --

-- object: bridge_constr_lod2brep_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod2brep_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod3brep_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod3brep_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod4brep_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod4brep_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_const_lod1xgeom_spx | type: INDEX --
CREATE INDEX bridge_const_lod1xgeom_spx ON public.bridge_constr_element
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod2xgeom_spx | type: INDEX --
CREATE INDEX bridge_const_lod2xgeom_spx ON public.bridge_constr_element
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod3xgeom_spx | type: INDEX --
CREATE INDEX bridge_const_lod3xgeom_spx ON public.bridge_constr_element
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod4xgeom_spx | type: INDEX --
CREATE INDEX bridge_const_lod4xgeom_spx ON public.bridge_constr_element
	USING gist
	(
	  lod4_other_geom ASC NULLS LAST
	);
-- ddl-end --

-- object: bridge_constr_lod1impl_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod1impl_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod1_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod2impl_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod2impl_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod2_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod3impl_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod3impl_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod3_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod4impl_fkx | type: INDEX --
CREATE INDEX bridge_constr_lod4impl_fkx ON public.bridge_constr_element
	USING btree
	(
	  lod4_implcity_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_const_lod1refpt_spx | type: INDEX --
CREATE INDEX bridge_const_lod1refpt_spx ON public.bridge_constr_element
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod2refpt_spx | type: INDEX --
CREATE INDEX bridge_const_lod2refpt_spx ON public.bridge_constr_element
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod3refpt_spx | type: INDEX --
CREATE INDEX bridge_const_lod3refpt_spx ON public.bridge_constr_element
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod4refpt_spx | type: INDEX --
CREATE INDEX bridge_const_lod4refpt_spx ON public.bridge_constr_element
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --


-- object: public.address_to_bridge | type: TABLE --
CREATE TABLE public.address_to_bridge(
	bridge_id integer,
	address_id integer,
	CONSTRAINT address_to_bridge_pk PRIMARY KEY (bridge_id,address_id)

);
-- ddl-end --
-- object: address_to_bridge_fkx | type: INDEX --
CREATE INDEX address_to_bridge_fkx ON public.address_to_bridge
	USING btree
	(
	  address_id ASC NULLS LAST
	);
-- ddl-end --

-- object: address_to_bridge_fkx1 | type: INDEX --
CREATE INDEX address_to_bridge_fkx1 ON public.address_to_bridge
	USING btree
	(
	  bridge_id ASC NULLS LAST
	);
-- ddl-end --


-- object: public.raster_relief_raster | type: TABLE --
CREATE TABLE public.raster_relief_raster(
	id integer DEFAULT nextval('raster_relief_raster_seq'::regclass),
	rasterproperty bytea,
	CONSTRAINT raster_relief_raster_pk PRIMARY KEY (id)

);
-- ddl-end --
-- object: public.cityobject_seq | type: SEQUENCE --
CREATE SEQUENCE public.cityobject_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.appearance_seq | type: SEQUENCE --
CREATE SEQUENCE public.appearance_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.implicit_geometry_seq | type: SEQUENCE --
CREATE SEQUENCE public.implicit_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.surface_geometry_seq | type: SEQUENCE --
CREATE SEQUENCE public.surface_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.address_seq | type: SEQUENCE --
CREATE SEQUENCE public.address_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.surface_data_seq | type: SEQUENCE --
CREATE SEQUENCE public.surface_data_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.citymodel_seq | type: SEQUENCE --
CREATE SEQUENCE public.citymodel_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.cityobject_genericatt_seq | type: SEQUENCE --
CREATE SEQUENCE public.cityobject_genericatt_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.external_ref_seq | type: SEQUENCE --
CREATE SEQUENCE public.external_ref_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.tex_image_seq | type: SEQUENCE --
CREATE SEQUENCE public.tex_image_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.raster_relief_raster_seq | type: SEQUENCE --
CREATE SEQUENCE public.raster_relief_raster_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 10000
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: cityobject_objectclass_fk | type: CONSTRAINT --
ALTER TABLE public.cityobject ADD CONSTRAINT cityobject_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: cityobject_member_fk | type: CONSTRAINT --
ALTER TABLE public.cityobject_member ADD CONSTRAINT cityobject_member_fk FOREIGN KEY (cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: cityobject_member_fk1 | type: CONSTRAINT --
ALTER TABLE public.cityobject_member ADD CONSTRAINT cityobject_member_fk1 FOREIGN KEY (citymodel_id)
REFERENCES public.citymodel (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: ext_ref_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.external_reference ADD CONSTRAINT ext_ref_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: general_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.generalization ADD CONSTRAINT general_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: general_generalizes_to_fk | type: CONSTRAINT --
ALTER TABLE public.generalization ADD CONSTRAINT general_generalizes_to_fk FOREIGN KEY (generalizes_to_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: surface_geom_parent_fk | type: CONSTRAINT --
ALTER TABLE public.surface_geometry ADD CONSTRAINT surface_geom_parent_fk FOREIGN KEY (id)
REFERENCES public.surface_geometry (parent_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: surface_geom_root_fk | type: CONSTRAINT --
ALTER TABLE public.surface_geometry ADD CONSTRAINT surface_geom_root_fk FOREIGN KEY (id)
REFERENCES public.surface_geometry (root_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: surface_geom_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.surface_geometry ADD CONSTRAINT surface_geom_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: group_geom_fk | type: CONSTRAINT --
ALTER TABLE public.cityobjectgroup ADD CONSTRAINT group_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: group_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.cityobjectgroup ADD CONSTRAINT group_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: group_parent_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.cityobjectgroup ADD CONSTRAINT group_parent_cityobject_fk FOREIGN KEY (parent_cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: group_to_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.group_to_cityobject ADD CONSTRAINT group_to_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: group_to_cityobject_fk1 | type: CONSTRAINT --
ALTER TABLE public.group_to_cityobject ADD CONSTRAINT group_to_cityobject_fk1 FOREIGN KEY (cityobjectgroup_id)
REFERENCES public.cityobjectgroup (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: objectclass_superclass_fk | type: CONSTRAINT --
ALTER TABLE public.objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY (superclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: implicit_geometry_geom_fk | type: CONSTRAINT --
ALTER TABLE public.implicit_geometry ADD CONSTRAINT implicit_geometry_geom_fk FOREIGN KEY (relative_geometry_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod1brep_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod1impl_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: city_furn_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.city_furniture ADD CONSTRAINT city_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: genericattrib_parent_fk | type: CONSTRAINT --
ALTER TABLE public.cityobject_genericattrib ADD CONSTRAINT genericattrib_parent_fk FOREIGN KEY (parent_genattrib_id)
REFERENCES public.cityobject_genericattrib (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: genericattrib_root_fk | type: CONSTRAINT --
ALTER TABLE public.cityobject_genericattrib ADD CONSTRAINT genericattrib_root_fk FOREIGN KEY (root_genattrib_id)
REFERENCES public.cityobject_genericattrib (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: genericattrib_cityobj_fk | type: CONSTRAINT --
ALTER TABLE public.cityobject_genericattrib ADD CONSTRAINT genericattrib_cityobj_fk FOREIGN KEY (cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: genericattrib_geom_fk | type: CONSTRAINT --
ALTER TABLE public.cityobject_genericattrib ADD CONSTRAINT genericattrib_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod0brep_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod0brep_fk FOREIGN KEY (lod0_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod1brep_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod0impl_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod0impl_fk FOREIGN KEY (lod0_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod1impl_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: gen_object_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.generic_cityobject ADD CONSTRAINT gen_object_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: address_to_building_fk | type: CONSTRAINT --
ALTER TABLE public.address_to_building ADD CONSTRAINT address_to_building_fk FOREIGN KEY (address_id)
REFERENCES public.address (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: address_to_building_fk1 | type: CONSTRAINT --
ALTER TABLE public.address_to_building ADD CONSTRAINT address_to_building_fk1 FOREIGN KEY (building_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_parent_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_parent_fk FOREIGN KEY (building_parent_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_root_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_root_fk FOREIGN KEY (building_root_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod0footprint_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod0footprint_fk FOREIGN KEY (lod0_footprint_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod0roofprint_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod0roofprint_fk FOREIGN KEY (lod0_roofprint_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod1solid_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod2solid_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod3solid_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: building_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.building ADD CONSTRAINT building_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_furn_cityobject_fk_cp1 | type: CONSTRAINT --
ALTER TABLE public.building_furniture ADD CONSTRAINT bldg_furn_cityobject_fk_cp1 FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_furn_room_fk_cp1 | type: CONSTRAINT --
ALTER TABLE public.building_furniture ADD CONSTRAINT bldg_furn_room_fk_cp1 FOREIGN KEY (room_id)
REFERENCES public.room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_furn_lod4brep_fk_cp1 | type: CONSTRAINT --
ALTER TABLE public.building_furniture ADD CONSTRAINT bldg_furn_lod4brep_fk_cp1 FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_furn_lod4impl_fk_cp1 | type: CONSTRAINT --
ALTER TABLE public.building_furniture ADD CONSTRAINT bldg_furn_lod4impl_fk_cp1 FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_building_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_building_fk FOREIGN KEY (building_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_room_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_room_fk FOREIGN KEY (room_id)
REFERENCES public.room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_lod2impl_fk FOREIGN KEY (lod2_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_lod3impl_fk FOREIGN KEY (lod3_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bldg_inst_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.building_installation ADD CONSTRAINT bldg_inst_lod4impl_fk FOREIGN KEY (lod4_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_objectclass_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_address_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_address_fk FOREIGN KEY (address_id)
REFERENCES public.address (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: opening_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.opening ADD CONSTRAINT opening_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: open_to_them_surface_fk | type: CONSTRAINT --
ALTER TABLE public.opening_to_them_surface ADD CONSTRAINT open_to_them_surface_fk FOREIGN KEY (opening_id)
REFERENCES public.opening (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: open_to_them_surface_fk1 | type: CONSTRAINT --
ALTER TABLE public.opening_to_them_surface ADD CONSTRAINT open_to_them_surface_fk1 FOREIGN KEY (thematic_surface_id)
REFERENCES public.thematic_surface (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: room_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.room ADD CONSTRAINT room_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: room_building_fk | type: CONSTRAINT --
ALTER TABLE public.room ADD CONSTRAINT room_building_fk FOREIGN KEY (building_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: room_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.room ADD CONSTRAINT room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: room_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.room ADD CONSTRAINT room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_building_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_building_fk FOREIGN KEY (building_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_room_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_room_fk FOREIGN KEY (room_id)
REFERENCES public.room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_bldg_inst_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_bldg_inst_fk FOREIGN KEY (building_installation_id)
REFERENCES public.building_installation (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: them_surface_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.thematic_surface ADD CONSTRAINT them_surface_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: appearance_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.appearance ADD CONSTRAINT appearance_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: appearance_citymodel_fk | type: CONSTRAINT --
ALTER TABLE public.appearance ADD CONSTRAINT appearance_citymodel_fk FOREIGN KEY (citymodel_id)
REFERENCES public.citymodel (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: surface_data_tex_image_fk | type: CONSTRAINT --
ALTER TABLE public.surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY (tex_image_id)
REFERENCES public.tex_image (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: surface_data_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.surface_data ADD CONSTRAINT surface_data_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: texparam_geom_fk | type: CONSTRAINT --
ALTER TABLE public.textureparam ADD CONSTRAINT texparam_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: texparam_surface_data_fk | type: CONSTRAINT --
ALTER TABLE public.textureparam ADD CONSTRAINT texparam_surface_data_fk FOREIGN KEY (surface_data_id)
REFERENCES public.surface_data (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: app_to_surf_data_fk | type: CONSTRAINT --
ALTER TABLE public.appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk FOREIGN KEY (surface_data_id)
REFERENCES public.surface_data (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: app_to_surf_data_fk1 | type: CONSTRAINT --
ALTER TABLE public.appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk1 FOREIGN KEY (appearance_id)
REFERENCES public.appearance (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: breakline_relief_comp_fk | type: CONSTRAINT --
ALTER TABLE public.breakline_relief ADD CONSTRAINT breakline_relief_comp_fk FOREIGN KEY (id)
REFERENCES public.relief_component (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: masspoint_relief_comp_fk | type: CONSTRAINT --
ALTER TABLE public.masspoint_relief ADD CONSTRAINT masspoint_relief_comp_fk FOREIGN KEY (id)
REFERENCES public.relief_component (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: relief_comp_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.relief_component ADD CONSTRAINT relief_comp_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: relief_comp_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.relief_component ADD CONSTRAINT relief_comp_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: rel_feat_to_rel_comp_fk | type: CONSTRAINT --
ALTER TABLE public.relief_feat_to_rel_comp ADD CONSTRAINT rel_feat_to_rel_comp_fk FOREIGN KEY (relief_component_id)
REFERENCES public.relief_component (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: rel_feat_to_rel_comp_fk1 | type: CONSTRAINT --
ALTER TABLE public.relief_feat_to_rel_comp ADD CONSTRAINT rel_feat_to_rel_comp_fk1 FOREIGN KEY (relief_feature_id)
REFERENCES public.relief_feature (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: relief_feat_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.relief_feature ADD CONSTRAINT relief_feat_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tin_relief_comp_fk | type: CONSTRAINT --
ALTER TABLE public.tin_relief ADD CONSTRAINT tin_relief_comp_fk FOREIGN KEY (id)
REFERENCES public.relief_component (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tin_relief_geom_fk | type: CONSTRAINT --
ALTER TABLE public.tin_relief ADD CONSTRAINT tin_relief_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tran_complex_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.transportation_complex ADD CONSTRAINT tran_complex_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tran_complex_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.transportation_complex ADD CONSTRAINT tran_complex_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tran_complex_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.transportation_complex ADD CONSTRAINT tran_complex_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tran_complex_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.transportation_complex ADD CONSTRAINT tran_complex_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tran_complex_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.transportation_complex ADD CONSTRAINT tran_complex_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tran_complex_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.transportation_complex ADD CONSTRAINT tran_complex_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: traffic_area_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.traffic_area ADD CONSTRAINT traffic_area_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: traffic_area_trancmplx_fk | type: CONSTRAINT --
ALTER TABLE public.traffic_area ADD CONSTRAINT traffic_area_trancmplx_fk FOREIGN KEY (transportation_complex_id)
REFERENCES public.transportation_complex (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: traffic_area_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.traffic_area ADD CONSTRAINT traffic_area_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: traffic_area_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.traffic_area ADD CONSTRAINT traffic_area_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: traffic_area_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.traffic_area ADD CONSTRAINT traffic_area_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: land_use_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.land_use ADD CONSTRAINT land_use_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: land_use_lod0msrf_fk | type: CONSTRAINT --
ALTER TABLE public.land_use ADD CONSTRAINT land_use_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: land_use_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.land_use ADD CONSTRAINT land_use_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: land_use_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.land_use ADD CONSTRAINT land_use_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: land_use_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.land_use ADD CONSTRAINT land_use_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: land_use_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.land_use ADD CONSTRAINT land_use_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod1solid_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod2solid_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod3solid_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: plant_cover_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.plant_cover ADD CONSTRAINT plant_cover_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod1brep_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod1impl_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: sol_veg_obj_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_lod0msrf_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_lod1solid_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_lod2solid_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_lod3solid_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbody_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.waterbody ADD CONSTRAINT waterbody_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbod_to_waterbnd_fk | type: CONSTRAINT --
ALTER TABLE public.waterbod_to_waterbnd_srf ADD CONSTRAINT waterbod_to_waterbnd_fk FOREIGN KEY (waterboundary_surface_id)
REFERENCES public.waterboundary_surface (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbod_to_waterbnd_fk1 | type: CONSTRAINT --
ALTER TABLE public.waterbod_to_waterbnd_srf ADD CONSTRAINT waterbod_to_waterbnd_fk1 FOREIGN KEY (waterbody_id)
REFERENCES public.waterbody (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbnd_srf_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.waterboundary_surface ADD CONSTRAINT waterbnd_srf_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbnd_srf_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.waterboundary_surface ADD CONSTRAINT waterbnd_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbnd_srf_lod2srf_fk | type: CONSTRAINT --
ALTER TABLE public.waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod2srf_fk FOREIGN KEY (lod2_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbnd_srf_lod3srf_fk | type: CONSTRAINT --
ALTER TABLE public.waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod3srf_fk FOREIGN KEY (lod3_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: waterbnd_srf_lod4srf_fk | type: CONSTRAINT --
ALTER TABLE public.waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod4srf_fk FOREIGN KEY (lod4_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: raster_relief_comp_fk | type: CONSTRAINT --
ALTER TABLE public.raster_relief ADD CONSTRAINT raster_relief_comp_fk FOREIGN KEY (id)
REFERENCES public.relief_component (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: raster_relief_raster_fk | type: CONSTRAINT --
ALTER TABLE public.raster_relief ADD CONSTRAINT raster_relief_raster_fk FOREIGN KEY (raster_id)
REFERENCES public.raster_relief_raster (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_parent_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_parent_fk FOREIGN KEY (tunnel_parent_id)
REFERENCES public.tunnel (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_root_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_root_fk FOREIGN KEY (tunnel_root_id)
REFERENCES public.tunnel (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod1solid_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod2solid_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod3solid_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel ADD CONSTRAINT tunnel_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_open_to_them_srf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_open_to_them_srf ADD CONSTRAINT tun_open_to_them_srf_fk FOREIGN KEY (tunnel_opening_id)
REFERENCES public.tunnel_opening (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_open_to_them_srf_fk1 | type: CONSTRAINT --
ALTER TABLE public.tunnel_open_to_them_srf ADD CONSTRAINT tun_open_to_them_srf_fk1 FOREIGN KEY (tunnel_thematic_surface_id)
REFERENCES public.tunnel_thematic_surface (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_hspace_cityobj_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_hollow_space ADD CONSTRAINT tun_hspace_cityobj_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: tun_hspace_tunnel_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_hollow_space ADD CONSTRAINT tun_hspace_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES public.tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: tun_hspace_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_hollow_space ADD CONSTRAINT tun_hspace_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: tun_hspace_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_hollow_space ADD CONSTRAINT tun_hspace_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_cityobj_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_cityobj_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_surf_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_surf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_tunnel_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES public.tunnel (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_hspace_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES public.tunnel_hollow_space (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_tun_inst_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_tun_inst_fk FOREIGN KEY (tunnel_installation_id)
REFERENCES public.tunnel_installation (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tun_them_srf_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_open_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_opening ADD CONSTRAINT tunnel_open_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_open_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_opening ADD CONSTRAINT tunnel_open_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_open_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_opening ADD CONSTRAINT tunnel_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_open_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_opening ADD CONSTRAINT tunnel_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_open_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_opening ADD CONSTRAINT tunnel_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_open_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_opening ADD CONSTRAINT tunnel_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_tunnel_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES public.tunnel (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_hspace_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES public.tunnel_hollow_space (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_lod2impl_fk FOREIGN KEY (lod2_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_lod3impl_fk FOREIGN KEY (lod3_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_inst_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_installation ADD CONSTRAINT tunnel_inst_lod4impl_fk FOREIGN KEY (lod4_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_furn_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_furniture ADD CONSTRAINT tunnel_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_furn_hspace_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_furniture ADD CONSTRAINT tunnel_furn_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES public.tunnel_hollow_space (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_furn_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_furniture ADD CONSTRAINT tunnel_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: tunnel_furn_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.tunnel_furniture ADD CONSTRAINT tunnel_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_parent_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_parent_fk FOREIGN KEY (bridge_parent_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_root_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_root_fk FOREIGN KEY (bridge_root_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod1msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod1solid_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod2solid_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod3solid_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.bridge ADD CONSTRAINT bridge_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_furn_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_furniture ADD CONSTRAINT bridge_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_furn_brd_room_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_furniture ADD CONSTRAINT bridge_furn_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES public.bridge_room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_furn_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_furniture ADD CONSTRAINT bridge_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_furn_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_furniture ADD CONSTRAINT bridge_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_bridge_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_brd_room_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES public.bridge_room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_lod2impl_fk FOREIGN KEY (lod2_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_lod3impl_fk FOREIGN KEY (lod3_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_inst_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_installation ADD CONSTRAINT bridge_inst_lod4impl_fk FOREIGN KEY (lod4_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_open_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_opening ADD CONSTRAINT bridge_open_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_open_address_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_opening ADD CONSTRAINT bridge_open_address_fk FOREIGN KEY (address_id)
REFERENCES public.address (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_open_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_opening ADD CONSTRAINT bridge_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_open_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_opening ADD CONSTRAINT bridge_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_open_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_opening ADD CONSTRAINT bridge_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_open_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_opening ADD CONSTRAINT bridge_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_open_to_them_srf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_open_to_them_srf ADD CONSTRAINT brd_open_to_them_srf_fk FOREIGN KEY (bridge_opening_id)
REFERENCES public.bridge_opening (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_open_to_them_srf_fk1 | type: CONSTRAINT --
ALTER TABLE public.bridge_open_to_them_srf ADD CONSTRAINT brd_open_to_them_srf_fk1 FOREIGN KEY (bridge_thematic_surface_id)
REFERENCES public.bridge_thematic_surface (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_room_cityobject_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_room ADD CONSTRAINT bridge_room_cityobject_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_room_bridge_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_room ADD CONSTRAINT bridge_room_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_room_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_room ADD CONSTRAINT bridge_room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_room_lod4solid_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_room ADD CONSTRAINT bridge_room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_cityobj_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_cityobj_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_objclass_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES public.objectclass (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_bridge_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_brd_room_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES public.bridge_room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_brd_inst_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_inst_fk FOREIGN KEY (bridge_installation_id)
REFERENCES public.bridge_installation (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_brd_const_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_const_fk FOREIGN KEY (bridge_constr_element_id)
REFERENCES public.bridge_constr_element (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_lod2msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_lod3msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: brd_them_srf_lod4msrf_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_cityobj_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_cityobj_fk FOREIGN KEY (id)
REFERENCES public.cityobject (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_bridge_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_brd_room_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES public.bridge_room (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod1brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod2brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod3brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod4brep_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES public.surface_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod1impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod1impl_fk FOREIGN KEY (lod1_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod2impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod2impl_fk FOREIGN KEY (lod2_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod3impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod3impl_fk FOREIGN KEY (lod3_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: bridge_constr_lod4impl_fk | type: CONSTRAINT --
ALTER TABLE public.bridge_constr_element ADD CONSTRAINT bridge_constr_lod4impl_fk FOREIGN KEY (lod4_implcity_rep_id)
REFERENCES public.implicit_geometry (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: address_to_bridge_fk | type: CONSTRAINT --
ALTER TABLE public.address_to_bridge ADD CONSTRAINT address_to_bridge_fk FOREIGN KEY (address_id)
REFERENCES public.address (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --


-- object: address_to_bridge_fk1 | type: CONSTRAINT --
ALTER TABLE public.address_to_bridge ADD CONSTRAINT address_to_bridge_fk1 FOREIGN KEY (bridge_id)
REFERENCES public.bridge (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
-- ddl-end --



