-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
--     
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: "3DCityDB_v3.3" | type: DATABASE --
-- -- DROP DATABASE IF EXISTS "3DCityDB_v3.3";
-- CREATE DATABASE "3DCityDB_v3.3"
-- 	ENCODING = 'UTF8'
-- 	TABLESPACE = pg_default
-- 	OWNER = postgres
-- ;
-- -- ddl-end --
-- 

-- object: citydb | type: SCHEMA --
-- DROP SCHEMA IF EXISTS citydb CASCADE;
CREATE SCHEMA citydb;
-- ddl-end --

--SET search_path TO pg_catalog,public,citydb;
-- ddl-end --

-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
--CREATE EXTENSION postgis
--      WITH SCHEMA public;
-- ddl-end --
--COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';
-- ddl-end --

-- object: citydb.citymodel_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.citymodel_seq CASCADE;
CREATE SEQUENCE citydb.citymodel_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.cityobject_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.cityobject_seq CASCADE;
CREATE SEQUENCE citydb.cityobject_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.cityobject_member | type: TABLE --
-- DROP TABLE IF EXISTS citydb.cityobject_member CASCADE;
CREATE TABLE citydb.cityobject_member(
	citymodel_id integer NOT NULL,
	cityobject_id integer NOT NULL,
	CONSTRAINT cityobject_member_pk PRIMARY KEY (citymodel_id,cityobject_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.external_ref_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.external_ref_seq CASCADE;
CREATE SEQUENCE citydb.external_ref_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.generalization | type: TABLE --
-- DROP TABLE IF EXISTS citydb.generalization CASCADE;
CREATE TABLE citydb.generalization(
	cityobject_id integer NOT NULL,
	generalizes_to_id integer NOT NULL,
	CONSTRAINT generalization_pk PRIMARY KEY (cityobject_id,generalizes_to_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.surface_geometry_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.surface_geometry_seq CASCADE;
CREATE SEQUENCE citydb.surface_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.cityobjectgroup | type: TABLE --
-- DROP TABLE IF EXISTS citydb.cityobjectgroup CASCADE;
CREATE TABLE citydb.cityobjectgroup(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	brep_id integer,
	other_geom geometry(GEOMETRYZ),
	parent_cityobject_id integer,
	CONSTRAINT cityobjectgroup_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.group_to_cityobject | type: TABLE --
-- DROP TABLE IF EXISTS citydb.group_to_cityobject CASCADE;
CREATE TABLE citydb.group_to_cityobject(
	cityobject_id integer NOT NULL,
	cityobjectgroup_id integer NOT NULL,
	role character varying(256),
	CONSTRAINT group_to_cityobject_pk PRIMARY KEY (cityobject_id,cityobjectgroup_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.database_srs | type: TABLE --
-- DROP TABLE IF EXISTS citydb.database_srs CASCADE;
CREATE TABLE citydb.database_srs(
	srid integer NOT NULL,
	gml_srs_name character varying(1000),
	CONSTRAINT database_srs_pk PRIMARY KEY (srid)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.objectclass | type: TABLE --
-- DROP TABLE IF EXISTS citydb.objectclass CASCADE;
CREATE TABLE citydb.objectclass(
	id integer NOT NULL,
	is_ade_class numeric,
	classname character varying(256),
	tablename character varying(30),
	superclass_id integer,
	baseclass_id integer,
	CONSTRAINT objectclass_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.implicit_geometry_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.implicit_geometry_seq CASCADE;
CREATE SEQUENCE citydb.implicit_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.city_furniture | type: TABLE --
-- DROP TABLE IF EXISTS citydb.city_furniture CASCADE;
CREATE TABLE citydb.city_furniture(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.cityobject_genericatt_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.cityobject_genericatt_seq CASCADE;
CREATE SEQUENCE citydb.cityobject_genericatt_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.generic_cityobject | type: TABLE --
-- DROP TABLE IF EXISTS citydb.generic_cityobject CASCADE;
CREATE TABLE citydb.generic_cityobject(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod0_other_geom geometry(GEOMETRYZ),
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.address_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.address_seq CASCADE;
CREATE SEQUENCE citydb.address_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.address_to_building | type: TABLE --
-- DROP TABLE IF EXISTS citydb.address_to_building CASCADE;
CREATE TABLE citydb.address_to_building(
	building_id integer NOT NULL,
	address_id integer NOT NULL,
	CONSTRAINT address_to_building_pk PRIMARY KEY (building_id,address_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.building | type: TABLE --
-- DROP TABLE IF EXISTS citydb.building CASCADE;
CREATE TABLE citydb.building(
	id integer NOT NULL,
	objectclass_id integer,
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
	storey_heights_ag_unit character varying(4000),
	storey_heights_below_ground character varying(4000),
	storey_heights_bg_unit character varying(4000),
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.building_furniture | type: TABLE --
-- DROP TABLE IF EXISTS citydb.building_furniture CASCADE;
CREATE TABLE citydb.building_furniture(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	room_id integer NOT NULL,
	lod4_brep_id integer,
	lod4_other_geom geometry(GEOMETRYZ),
	lod4_implicit_rep_id integer,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT building_furniture_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.building_installation | type: TABLE --
-- DROP TABLE IF EXISTS citydb.building_installation CASCADE;
CREATE TABLE citydb.building_installation(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod2_implicit_rep_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT building_installation_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.opening | type: TABLE --
-- DROP TABLE IF EXISTS citydb.opening CASCADE;
CREATE TABLE citydb.opening(
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.opening_to_them_surface | type: TABLE --
-- DROP TABLE IF EXISTS citydb.opening_to_them_surface CASCADE;
CREATE TABLE citydb.opening_to_them_surface(
	opening_id integer NOT NULL,
	thematic_surface_id integer NOT NULL,
	CONSTRAINT opening_to_them_surface_pk PRIMARY KEY (opening_id,thematic_surface_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.room | type: TABLE --
-- DROP TABLE IF EXISTS citydb.room CASCADE;
CREATE TABLE citydb.room(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.thematic_surface | type: TABLE --
-- DROP TABLE IF EXISTS citydb.thematic_surface CASCADE;
CREATE TABLE citydb.thematic_surface(
	id integer NOT NULL,
	objectclass_id integer,
	building_id integer,
	room_id integer,
	building_installation_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT thematic_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.appearance_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.appearance_seq CASCADE;
CREATE SEQUENCE citydb.appearance_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.surface_data_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.surface_data_seq CASCADE;
CREATE SEQUENCE citydb.surface_data_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.textureparam | type: TABLE --
-- DROP TABLE IF EXISTS citydb.textureparam CASCADE;
CREATE TABLE citydb.textureparam(
	surface_geometry_id integer NOT NULL,
	objectclass_id integer,
	is_texture_parametrization numeric,
	world_to_texture character varying(1000),
	texture_coordinates geometry(POLYGON),
	surface_data_id integer NOT NULL,
	CONSTRAINT textureparam_pk PRIMARY KEY (surface_geometry_id,surface_data_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.appear_to_surface_data | type: TABLE --
-- DROP TABLE IF EXISTS citydb.appear_to_surface_data CASCADE;
CREATE TABLE citydb.appear_to_surface_data(
	surface_data_id integer NOT NULL,
	appearance_id integer NOT NULL,
	CONSTRAINT appear_to_surface_data_pk PRIMARY KEY (surface_data_id,appearance_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.breakline_relief | type: TABLE --
-- DROP TABLE IF EXISTS citydb.breakline_relief CASCADE;
CREATE TABLE citydb.breakline_relief(
	id integer NOT NULL,
	objectclass_id integer,
	ridge_or_valley_lines geometry(MULTILINESTRINGZ),
	break_lines geometry(MULTILINESTRINGZ),
	CONSTRAINT breakline_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.masspoint_relief | type: TABLE --
-- DROP TABLE IF EXISTS citydb.masspoint_relief CASCADE;
CREATE TABLE citydb.masspoint_relief(
	id integer NOT NULL,
	objectclass_id integer,
	relief_points geometry(MULTIPOINTZ),
	CONSTRAINT masspoint_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.relief_component | type: TABLE --
-- DROP TABLE IF EXISTS citydb.relief_component CASCADE;
CREATE TABLE citydb.relief_component(
	id integer NOT NULL,
	objectclass_id integer,
	lod numeric,
	extent geometry(POLYGON),
	CONSTRAINT relief_component_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100),
	CONSTRAINT relief_comp_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)))

);
-- ddl-end --

-- object: citydb.relief_feat_to_rel_comp | type: TABLE --
-- DROP TABLE IF EXISTS citydb.relief_feat_to_rel_comp CASCADE;
CREATE TABLE citydb.relief_feat_to_rel_comp(
	relief_component_id integer NOT NULL,
	relief_feature_id integer NOT NULL,
	CONSTRAINT relief_feat_to_rel_comp_pk PRIMARY KEY (relief_component_id,relief_feature_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.relief_feature | type: TABLE --
-- DROP TABLE IF EXISTS citydb.relief_feature CASCADE;
CREATE TABLE citydb.relief_feature(
	id integer NOT NULL,
	objectclass_id integer,
	lod numeric,
	CONSTRAINT relief_feature_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100),
	CONSTRAINT relief_feat_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)))

);
-- ddl-end --

-- object: citydb.tin_relief | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tin_relief CASCADE;
CREATE TABLE citydb.tin_relief(
	id integer NOT NULL,
	objectclass_id integer,
	max_length double precision,
	max_length_unit character varying(4000),
	stop_lines geometry(MULTILINESTRINGZ),
	break_lines geometry(MULTILINESTRINGZ),
	control_points geometry(MULTIPOINTZ),
	surface_geometry_id integer,
	CONSTRAINT tin_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.transportation_complex | type: TABLE --
-- DROP TABLE IF EXISTS citydb.transportation_complex CASCADE;
CREATE TABLE citydb.transportation_complex(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_network geometry(GEOMETRYZ),
	lod1_multi_surface_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT transportation_complex_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.traffic_area | type: TABLE --
-- DROP TABLE IF EXISTS citydb.traffic_area CASCADE;
CREATE TABLE citydb.traffic_area(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.land_use | type: TABLE --
-- DROP TABLE IF EXISTS citydb.land_use CASCADE;
CREATE TABLE citydb.land_use(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.plant_cover | type: TABLE --
-- DROP TABLE IF EXISTS citydb.plant_cover CASCADE;
CREATE TABLE citydb.plant_cover(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod1_multi_solid_id integer,
	lod2_multi_solid_id integer,
	lod3_multi_solid_id integer,
	lod4_multi_solid_id integer,
	CONSTRAINT plant_cover_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.solitary_vegetat_object | type: TABLE --
-- DROP TABLE IF EXISTS citydb.solitary_vegetat_object CASCADE;
CREATE TABLE citydb.solitary_vegetat_object(
	id integer NOT NULL,
	objectclass_id integer,
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
	trunk_diameter double precision,
	trunk_diameter_unit character varying(4000),
	crown_diameter double precision,
	crown_diameter_unit character varying(4000),
	lod1_brep_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.waterbody | type: TABLE --
-- DROP TABLE IF EXISTS citydb.waterbody CASCADE;
CREATE TABLE citydb.waterbody(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.waterbod_to_waterbnd_srf | type: TABLE --
-- DROP TABLE IF EXISTS citydb.waterbod_to_waterbnd_srf CASCADE;
CREATE TABLE citydb.waterbod_to_waterbnd_srf(
	waterboundary_surface_id integer NOT NULL,
	waterbody_id integer NOT NULL,
	CONSTRAINT waterbod_to_waterbnd_pk PRIMARY KEY (waterboundary_surface_id,waterbody_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.waterboundary_surface | type: TABLE --
-- DROP TABLE IF EXISTS citydb.waterboundary_surface CASCADE;
CREATE TABLE citydb.waterboundary_surface(
	id integer NOT NULL,
	objectclass_id integer,
	water_level character varying(256),
	water_level_codespace character varying(4000),
	lod2_surface_id integer,
	lod3_surface_id integer,
	lod4_surface_id integer,
	CONSTRAINT waterboundary_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.raster_relief | type: TABLE --
-- DROP TABLE IF EXISTS citydb.raster_relief CASCADE;
CREATE TABLE citydb.raster_relief(
	id integer NOT NULL,
	objectclass_id integer,
	raster_uri character varying(4000),
	coverage_id integer,
	CONSTRAINT raster_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tunnel | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel CASCADE;
CREATE TABLE citydb.tunnel(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod1_solid_id integer,
	lod2_solid_id integer,
	lod3_solid_id integer,
	lod4_solid_id integer,
	CONSTRAINT tunnel_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tunnel_open_to_them_srf | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel_open_to_them_srf CASCADE;
CREATE TABLE citydb.tunnel_open_to_them_srf(
	tunnel_opening_id integer NOT NULL,
	tunnel_thematic_surface_id integer NOT NULL,
	CONSTRAINT tunnel_open_to_them_srf_pk PRIMARY KEY (tunnel_opening_id,tunnel_thematic_surface_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tunnel_hollow_space | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel_hollow_space CASCADE;
CREATE TABLE citydb.tunnel_hollow_space(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tunnel_thematic_surface | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel_thematic_surface CASCADE;
CREATE TABLE citydb.tunnel_thematic_surface(
	id integer NOT NULL,
	objectclass_id integer,
	tunnel_id integer,
	tunnel_hollow_space_id integer,
	tunnel_installation_id integer,
	lod2_multi_surface_id integer,
	lod3_multi_surface_id integer,
	lod4_multi_surface_id integer,
	CONSTRAINT tunnel_thematic_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tex_image_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.tex_image_seq CASCADE;
CREATE SEQUENCE citydb.tex_image_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.tunnel_opening | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel_opening CASCADE;
CREATE TABLE citydb.tunnel_opening(
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tunnel_installation | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel_installation CASCADE;
CREATE TABLE citydb.tunnel_installation(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod2_implicit_rep_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_installation_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tunnel_furniture | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tunnel_furniture CASCADE;
CREATE TABLE citydb.tunnel_furniture(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_hollow_space_id integer NOT NULL,
	lod4_brep_id integer,
	lod4_other_geom geometry(GEOMETRYZ),
	lod4_implicit_rep_id integer,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_furniture_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge CASCADE;
CREATE TABLE citydb.bridge(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_furniture | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_furniture CASCADE;
CREATE TABLE citydb.bridge_furniture(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_room_id integer NOT NULL,
	lod4_brep_id integer,
	lod4_other_geom geometry(GEOMETRYZ),
	lod4_implicit_rep_id integer,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_furniture_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_installation | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_installation CASCADE;
CREATE TABLE citydb.bridge_installation(
	id integer NOT NULL,
	objectclass_id integer,
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
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod2_implicit_rep_id integer,
	lod3_implicit_rep_id integer,
	lod4_implicit_rep_id integer,
	lod2_implicit_ref_point geometry(POINTZ),
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod2_implicit_transformation character varying(1000),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_installation_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_opening | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_opening CASCADE;
CREATE TABLE citydb.bridge_opening(
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_open_to_them_srf | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_open_to_them_srf CASCADE;
CREATE TABLE citydb.bridge_open_to_them_srf(
	bridge_opening_id integer NOT NULL,
	bridge_thematic_surface_id integer NOT NULL,
	CONSTRAINT bridge_open_to_them_srf_pk PRIMARY KEY (bridge_opening_id,bridge_thematic_surface_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_room | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_room CASCADE;
CREATE TABLE citydb.bridge_room(
	id integer NOT NULL,
	objectclass_id integer,
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_thematic_surface | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_thematic_surface CASCADE;
CREATE TABLE citydb.bridge_thematic_surface(
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.bridge_constr_element | type: TABLE --
-- DROP TABLE IF EXISTS citydb.bridge_constr_element CASCADE;
CREATE TABLE citydb.bridge_constr_element(
	id integer NOT NULL,
	objectclass_id integer,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id integer,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod1_brep_id integer,
	lod2_brep_id integer,
	lod3_brep_id integer,
	lod4_brep_id integer,
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
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
	CONSTRAINT bridge_constr_element_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.address_to_bridge | type: TABLE --
-- DROP TABLE IF EXISTS citydb.address_to_bridge CASCADE;
CREATE TABLE citydb.address_to_bridge(
	bridge_id integer NOT NULL,
	address_id integer NOT NULL,
	CONSTRAINT address_to_bridge_pk PRIMARY KEY (bridge_id,address_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.grid_coverage_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.grid_coverage_seq CASCADE;
CREATE SEQUENCE citydb.grid_coverage_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.cityobject | type: TABLE --
-- DROP TABLE IF EXISTS citydb.cityobject CASCADE;
CREATE TABLE citydb.cityobject(
	id integer NOT NULL DEFAULT nextval('citydb.cityobject_seq'::regclass),
	objectclass_id integer NOT NULL,
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	envelope geometry(POLYGONZ),
	creation_date timestamp with time zone,
	termination_date timestamp with time zone,
	relative_to_terrain character varying(256),
	relative_to_water character varying(256),
	last_modification_date timestamp with time zone,
	updating_person character varying(256),
	reason_for_update character varying(4000),
	lineage character varying(256),
	xml_source text,
	CONSTRAINT cityobject_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.appearance | type: TABLE --
-- DROP TABLE IF EXISTS citydb.appearance CASCADE;
CREATE TABLE citydb.appearance(
	id integer NOT NULL DEFAULT nextval('citydb.appearance_seq'::regclass),
	objectclass_id integer,
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	theme character varying(256),
	citymodel_id integer,
	cityobject_id integer,
	CONSTRAINT appearance_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.implicit_geometry | type: TABLE --
-- DROP TABLE IF EXISTS citydb.implicit_geometry CASCADE;
CREATE TABLE citydb.implicit_geometry(
	id integer NOT NULL DEFAULT nextval('citydb.implicit_geometry_seq'::regclass),
	objectclass_id integer,
	mime_type character varying(256),
	reference_to_library character varying(4000),
	library_object bytea,
	relative_brep_id integer,
	relative_other_geom geometry(GEOMETRYZ),
	CONSTRAINT implicit_geometry_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.surface_geometry | type: TABLE --
-- DROP TABLE IF EXISTS citydb.surface_geometry CASCADE;
CREATE TABLE citydb.surface_geometry(
	id integer NOT NULL DEFAULT nextval('citydb.surface_geometry_seq'::regclass),
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	parent_id integer,
	root_id integer,
	is_solid numeric,
	is_composite numeric,
	is_triangulated numeric,
	is_xlink numeric,
	is_reverse numeric,
	solid_geometry geometry(POLYHEDRALSURFACEZ),
	geometry geometry(POLYGONZ),
	implicit_geometry geometry(POLYGONZ),
	cityobject_id integer,
	CONSTRAINT surface_geometry_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.address | type: TABLE --
-- DROP TABLE IF EXISTS citydb.address CASCADE;
CREATE TABLE citydb.address(
	id integer NOT NULL DEFAULT nextval('citydb.address_seq'::regclass),
	objectclass_id integer,
	gmlid varchar(256),
	gmlid_codespace varchar(1000),
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
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.surface_data | type: TABLE --
-- DROP TABLE IF EXISTS citydb.surface_data CASCADE;
CREATE TABLE citydb.surface_data(
	id integer NOT NULL DEFAULT nextval('citydb.surface_data_seq'::regclass),
	objectclass_id integer,
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	is_front numeric,
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
	gt_reference_point geometry(POINT),
	CONSTRAINT surface_data_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.citymodel | type: TABLE --
-- DROP TABLE IF EXISTS citydb.citymodel CASCADE;
CREATE TABLE citydb.citymodel(
	id integer NOT NULL DEFAULT nextval('citydb.citymodel_seq'::regclass),
	objectclass_id integer,
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	envelope geometry(POLYGONZ),
	creation_date timestamp with time zone,
	termination_date timestamp with time zone,
	last_modification_date timestamp with time zone,
	updating_person character varying(256),
	reason_for_update character varying(4000),
	lineage character varying(256),
	CONSTRAINT citymodel_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.cityobject_genericattrib | type: TABLE --
-- DROP TABLE IF EXISTS citydb.cityobject_genericattrib CASCADE;
CREATE TABLE citydb.cityobject_genericattrib(
	id integer NOT NULL DEFAULT nextval('citydb.cityobject_genericatt_seq'::regclass),
	parent_genattrib_id integer,
	root_genattrib_id integer,
	attrname character varying(256) NOT NULL,
	datatype integer,
	strval character varying(4000),
	intval integer,
	realval double precision,
	urival character varying(4000),
	dateval timestamp with time zone,
	unit character varying(4000),
	genattribset_codespace character varying(4000),
	blobval bytea,
	geomval geometry(GEOMETRYZ),
	surface_geometry_id integer,
	cityobject_id integer NOT NULL,
	CONSTRAINT cityobj_genericattrib_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.external_reference | type: TABLE --
-- DROP TABLE IF EXISTS citydb.external_reference CASCADE;
CREATE TABLE citydb.external_reference(
	id integer NOT NULL DEFAULT nextval('citydb.external_ref_seq'::regclass),
	infosys character varying(4000),
	name character varying(4000),
	uri character varying(4000),
	cityobject_id integer NOT NULL,
	CONSTRAINT external_reference_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.tex_image | type: TABLE --
-- DROP TABLE IF EXISTS citydb.tex_image CASCADE;
CREATE TABLE citydb.tex_image(
	id integer NOT NULL DEFAULT nextval('citydb.tex_image_seq'::regclass),
	tex_image_uri character varying(4000),
	tex_image_data bytea,
	tex_mime_type character varying(256),
	tex_mime_type_codespace character varying(4000),
	CONSTRAINT tex_image_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.grid_coverage | type: TABLE --
-- DROP TABLE IF EXISTS citydb.grid_coverage CASCADE;
CREATE TABLE citydb.grid_coverage(
	id integer NOT NULL DEFAULT nextval('citydb.grid_coverage_seq'::regclass),
	rasterproperty raster,
	CONSTRAINT grid_coverage_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: cityobject_member_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.cityobject_member_fkx CASCADE;
CREATE INDEX cityobject_member_fkx ON citydb.cityobject_member
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_member_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.cityobject_member_fkx1 CASCADE;
CREATE INDEX cityobject_member_fkx1 ON citydb.cityobject_member
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: general_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.general_cityobject_fkx CASCADE;
CREATE INDEX general_cityobject_fkx ON citydb.generalization
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: general_generalizes_to_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.general_generalizes_to_fkx CASCADE;
CREATE INDEX general_generalizes_to_fkx ON citydb.generalization
	USING btree
	(
	  generalizes_to_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.group_brep_fkx CASCADE;
CREATE INDEX group_brep_fkx ON citydb.cityobjectgroup
	USING btree
	(
	  brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.group_xgeom_spx CASCADE;
CREATE INDEX group_xgeom_spx ON citydb.cityobjectgroup
	USING gist
	(
	  other_geom
	);
-- ddl-end --

-- object: group_parent_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.group_parent_cityobj_fkx CASCADE;
CREATE INDEX group_parent_cityobj_fkx ON citydb.cityobjectgroup
	USING btree
	(
	  parent_cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_to_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.group_to_cityobject_fkx CASCADE;
CREATE INDEX group_to_cityobject_fkx ON citydb.group_to_cityobject
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_to_cityobject_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.group_to_cityobject_fkx1 CASCADE;
CREATE INDEX group_to_cityobject_fkx1 ON citydb.group_to_cityobject
	USING btree
	(
	  cityobjectgroup_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: objectclass_superclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.objectclass_superclass_fkx CASCADE;
CREATE INDEX objectclass_superclass_fkx ON citydb.objectclass
	USING btree
	(
	  superclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod1terr_spx CASCADE;
CREATE INDEX city_furn_lod1terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod2terr_spx CASCADE;
CREATE INDEX city_furn_lod2terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod3terr_spx CASCADE;
CREATE INDEX city_furn_lod3terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod4terr_spx CASCADE;
CREATE INDEX city_furn_lod4terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod1brep_fkx CASCADE;
CREATE INDEX city_furn_lod1brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod2brep_fkx CASCADE;
CREATE INDEX city_furn_lod2brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod3brep_fkx CASCADE;
CREATE INDEX city_furn_lod3brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod4brep_fkx CASCADE;
CREATE INDEX city_furn_lod4brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod1xgeom_spx CASCADE;
CREATE INDEX city_furn_lod1xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: city_furn_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod2xgeom_spx CASCADE;
CREATE INDEX city_furn_lod2xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: city_furn_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod3xgeom_spx CASCADE;
CREATE INDEX city_furn_lod3xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: city_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod4xgeom_spx CASCADE;
CREATE INDEX city_furn_lod4xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: city_furn_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod1impl_fkx CASCADE;
CREATE INDEX city_furn_lod1impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod2impl_fkx CASCADE;
CREATE INDEX city_furn_lod2impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod3impl_fkx CASCADE;
CREATE INDEX city_furn_lod3impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod4impl_fkx CASCADE;
CREATE INDEX city_furn_lod4impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod1refpnt_spx CASCADE;
CREATE INDEX city_furn_lod1refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod2refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod2refpnt_spx CASCADE;
CREATE INDEX city_furn_lod2refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod3refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod3refpnt_spx CASCADE;
CREATE INDEX city_furn_lod3refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod4refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_lod4refpnt_spx CASCADE;
CREATE INDEX city_furn_lod4refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod0terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod0terr_spx CASCADE;
CREATE INDEX gen_object_lod0terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod0_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod1terr_spx CASCADE;
CREATE INDEX gen_object_lod1terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod2terr_spx CASCADE;
CREATE INDEX gen_object_lod2terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod3terr_spx CASCADE;
CREATE INDEX gen_object_lod3terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod4terr_spx CASCADE;
CREATE INDEX gen_object_lod4terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod0brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod0brep_fkx CASCADE;
CREATE INDEX gen_object_lod0brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod0_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod1brep_fkx CASCADE;
CREATE INDEX gen_object_lod1brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod2brep_fkx CASCADE;
CREATE INDEX gen_object_lod2brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod3brep_fkx CASCADE;
CREATE INDEX gen_object_lod3brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod4brep_fkx CASCADE;
CREATE INDEX gen_object_lod4brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod0xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod0xgeom_spx CASCADE;
CREATE INDEX gen_object_lod0xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod0_other_geom
	);
-- ddl-end --

-- object: gen_object_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod1xgeom_spx CASCADE;
CREATE INDEX gen_object_lod1xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: gen_object_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod2xgeom_spx CASCADE;
CREATE INDEX gen_object_lod2xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: gen_object_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod3xgeom_spx CASCADE;
CREATE INDEX gen_object_lod3xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: gen_object_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod4xgeom_spx CASCADE;
CREATE INDEX gen_object_lod4xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: gen_object_lod0impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod0impl_fkx CASCADE;
CREATE INDEX gen_object_lod0impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod0_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod1impl_fkx CASCADE;
CREATE INDEX gen_object_lod1impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod2impl_fkx CASCADE;
CREATE INDEX gen_object_lod2impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod3impl_fkx CASCADE;
CREATE INDEX gen_object_lod3impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod4impl_fkx CASCADE;
CREATE INDEX gen_object_lod4impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod0refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod0refpnt_spx CASCADE;
CREATE INDEX gen_object_lod0refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod0_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod1refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod1refpnt_spx CASCADE;
CREATE INDEX gen_object_lod1refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod2refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod2refpnt_spx CASCADE;
CREATE INDEX gen_object_lod2refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod3refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod3refpnt_spx CASCADE;
CREATE INDEX gen_object_lod3refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod4refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_lod4refpnt_spx CASCADE;
CREATE INDEX gen_object_lod4refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: address_to_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_to_building_fkx CASCADE;
CREATE INDEX address_to_building_fkx ON citydb.address_to_building
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: address_to_building_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_to_building_fkx1 CASCADE;
CREATE INDEX address_to_building_fkx1 ON citydb.address_to_building
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_parent_fkx CASCADE;
CREATE INDEX building_parent_fkx ON citydb.building
	USING btree
	(
	  building_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_root_fkx CASCADE;
CREATE INDEX building_root_fkx ON citydb.building
	USING btree
	(
	  building_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod1terr_spx CASCADE;
CREATE INDEX building_lod1terr_spx ON citydb.building
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: building_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod2terr_spx CASCADE;
CREATE INDEX building_lod2terr_spx ON citydb.building
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: building_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod3terr_spx CASCADE;
CREATE INDEX building_lod3terr_spx ON citydb.building
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: building_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod4terr_spx CASCADE;
CREATE INDEX building_lod4terr_spx ON citydb.building
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: building_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod2curve_spx CASCADE;
CREATE INDEX building_lod2curve_spx ON citydb.building
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: building_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod3curve_spx CASCADE;
CREATE INDEX building_lod3curve_spx ON citydb.building
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: building_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod4curve_spx CASCADE;
CREATE INDEX building_lod4curve_spx ON citydb.building
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: building_lod0footprint_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod0footprint_fkx CASCADE;
CREATE INDEX building_lod0footprint_fkx ON citydb.building
	USING btree
	(
	  lod0_footprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod0roofprint_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod0roofprint_fkx CASCADE;
CREATE INDEX building_lod0roofprint_fkx ON citydb.building
	USING btree
	(
	  lod0_roofprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod1msrf_fkx CASCADE;
CREATE INDEX building_lod1msrf_fkx ON citydb.building
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod2msrf_fkx CASCADE;
CREATE INDEX building_lod2msrf_fkx ON citydb.building
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod3msrf_fkx CASCADE;
CREATE INDEX building_lod3msrf_fkx ON citydb.building
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod4msrf_fkx CASCADE;
CREATE INDEX building_lod4msrf_fkx ON citydb.building
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod1solid_fkx CASCADE;
CREATE INDEX building_lod1solid_fkx ON citydb.building
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod2solid_fkx CASCADE;
CREATE INDEX building_lod2solid_fkx ON citydb.building
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod3solid_fkx CASCADE;
CREATE INDEX building_lod3solid_fkx ON citydb.building
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_lod4solid_fkx CASCADE;
CREATE INDEX building_lod4solid_fkx ON citydb.building
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_furn_room_fkx CASCADE;
CREATE INDEX bldg_furn_room_fkx ON citydb.building_furniture
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_furn_lod4brep_fkx CASCADE;
CREATE INDEX bldg_furn_lod4brep_fkx ON citydb.building_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_furn_lod4xgeom_spx CASCADE;
CREATE INDEX bldg_furn_lod4xgeom_spx ON citydb.building_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bldg_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_furn_lod4impl_fkx CASCADE;
CREATE INDEX bldg_furn_lod4impl_fkx ON citydb.building_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_furn_lod4refpt_spx CASCADE;
CREATE INDEX bldg_furn_lod4refpt_spx ON citydb.building_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_objclass_fkx CASCADE;
CREATE INDEX bldg_inst_objclass_fkx ON citydb.building_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: bldg_inst_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_building_fkx CASCADE;
CREATE INDEX bldg_inst_building_fkx ON citydb.building_installation
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_room_fkx CASCADE;
CREATE INDEX bldg_inst_room_fkx ON citydb.building_installation
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod2brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod2brep_fkx ON citydb.building_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod3brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod3brep_fkx ON citydb.building_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod4brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod4brep_fkx ON citydb.building_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod2xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod2xgeom_spx ON citydb.building_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod3xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod3xgeom_spx ON citydb.building_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod4xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod4xgeom_spx ON citydb.building_installation
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod2impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod2impl_fkx ON citydb.building_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod3impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod3impl_fkx ON citydb.building_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod4impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod4impl_fkx ON citydb.building_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod2refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod2refpt_spx ON citydb.building_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod3refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod3refpt_spx ON citydb.building_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_inst_lod4refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod4refpt_spx ON citydb.building_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: opening_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_objectclass_fkx CASCADE;
CREATE INDEX opening_objectclass_fkx ON citydb.opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_address_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_address_fkx CASCADE;
CREATE INDEX opening_address_fkx ON citydb.opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_lod3msrf_fkx CASCADE;
CREATE INDEX opening_lod3msrf_fkx ON citydb.opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_lod4msrf_fkx CASCADE;
CREATE INDEX opening_lod4msrf_fkx ON citydb.opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_lod3impl_fkx CASCADE;
CREATE INDEX opening_lod3impl_fkx ON citydb.opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_lod4impl_fkx CASCADE;
CREATE INDEX opening_lod4impl_fkx ON citydb.opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_lod3refpt_spx CASCADE;
CREATE INDEX opening_lod3refpt_spx ON citydb.opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: opening_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.opening_lod4refpt_spx CASCADE;
CREATE INDEX opening_lod4refpt_spx ON citydb.opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: open_to_them_surface_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.open_to_them_surface_fkx CASCADE;
CREATE INDEX open_to_them_surface_fkx ON citydb.opening_to_them_surface
	USING btree
	(
	  opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: open_to_them_surface_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.open_to_them_surface_fkx1 CASCADE;
CREATE INDEX open_to_them_surface_fkx1 ON citydb.opening_to_them_surface
	USING btree
	(
	  thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.room_building_fkx CASCADE;
CREATE INDEX room_building_fkx ON citydb.room
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.room_lod4msrf_fkx CASCADE;
CREATE INDEX room_lod4msrf_fkx ON citydb.room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.room_lod4solid_fkx CASCADE;
CREATE INDEX room_lod4solid_fkx ON citydb.room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_objclass_fkx CASCADE;
CREATE INDEX them_surface_objclass_fkx ON citydb.thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_building_fkx CASCADE;
CREATE INDEX them_surface_building_fkx ON citydb.thematic_surface
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_room_fkx CASCADE;
CREATE INDEX them_surface_room_fkx ON citydb.thematic_surface
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_bldg_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_bldg_inst_fkx CASCADE;
CREATE INDEX them_surface_bldg_inst_fkx ON citydb.thematic_surface
	USING btree
	(
	  building_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_lod2msrf_fkx CASCADE;
CREATE INDEX them_surface_lod2msrf_fkx ON citydb.thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_lod3msrf_fkx CASCADE;
CREATE INDEX them_surface_lod3msrf_fkx ON citydb.thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.them_surface_lod4msrf_fkx CASCADE;
CREATE INDEX them_surface_lod4msrf_fkx ON citydb.thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: texparam_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.texparam_geom_fkx CASCADE;
CREATE INDEX texparam_geom_fkx ON citydb.textureparam
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: texparam_surface_data_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.texparam_surface_data_fkx CASCADE;
CREATE INDEX texparam_surface_data_fkx ON citydb.textureparam
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: app_to_surf_data_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.app_to_surf_data_fkx CASCADE;
CREATE INDEX app_to_surf_data_fkx ON citydb.appear_to_surface_data
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: app_to_surf_data_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.app_to_surf_data_fkx1 CASCADE;
CREATE INDEX app_to_surf_data_fkx1 ON citydb.appear_to_surface_data
	USING btree
	(
	  appearance_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: breakline_ridge_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.breakline_ridge_spx CASCADE;
CREATE INDEX breakline_ridge_spx ON citydb.breakline_relief
	USING gist
	(
	  ridge_or_valley_lines
	);
-- ddl-end --

-- object: breakline_break_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.breakline_break_spx CASCADE;
CREATE INDEX breakline_break_spx ON citydb.breakline_relief
	USING gist
	(
	  break_lines
	);
-- ddl-end --

-- object: masspoint_relief_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.masspoint_relief_spx CASCADE;
CREATE INDEX masspoint_relief_spx ON citydb.masspoint_relief
	USING gist
	(
	  relief_points
	);
-- ddl-end --

-- object: relief_comp_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.relief_comp_objclass_fkx CASCADE;
CREATE INDEX relief_comp_objclass_fkx ON citydb.relief_component
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: relief_comp_extent_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.relief_comp_extent_spx CASCADE;
CREATE INDEX relief_comp_extent_spx ON citydb.relief_component
	USING gist
	(
	  extent
	);
-- ddl-end --

-- object: rel_feat_to_rel_comp_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.rel_feat_to_rel_comp_fkx CASCADE;
CREATE INDEX rel_feat_to_rel_comp_fkx ON citydb.relief_feat_to_rel_comp
	USING btree
	(
	  relief_component_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: rel_feat_to_rel_comp_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.rel_feat_to_rel_comp_fkx1 CASCADE;
CREATE INDEX rel_feat_to_rel_comp_fkx1 ON citydb.relief_feat_to_rel_comp
	USING btree
	(
	  relief_feature_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tin_relief_geom_fkx CASCADE;
CREATE INDEX tin_relief_geom_fkx ON citydb.tin_relief
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_stop_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tin_relief_stop_spx CASCADE;
CREATE INDEX tin_relief_stop_spx ON citydb.tin_relief
	USING gist
	(
	  stop_lines
	);
-- ddl-end --

-- object: tin_relief_break_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tin_relief_break_spx CASCADE;
CREATE INDEX tin_relief_break_spx ON citydb.tin_relief
	USING gist
	(
	  break_lines
	);
-- ddl-end --

-- object: tin_relief_crtlpts_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tin_relief_crtlpts_spx CASCADE;
CREATE INDEX tin_relief_crtlpts_spx ON citydb.tin_relief
	USING gist
	(
	  control_points
	);
-- ddl-end --

-- object: tran_complex_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tran_complex_objclass_fkx CASCADE;
CREATE INDEX tran_complex_objclass_fkx ON citydb.transportation_complex
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod0net_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tran_complex_lod0net_spx CASCADE;
CREATE INDEX tran_complex_lod0net_spx ON citydb.transportation_complex
	USING gist
	(
	  lod0_network
	);
-- ddl-end --

-- object: tran_complex_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tran_complex_lod1msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod1msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tran_complex_lod2msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod2msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tran_complex_lod3msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod3msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tran_complex_lod4msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod4msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.traffic_area_objclass_fkx CASCADE;
CREATE INDEX traffic_area_objclass_fkx ON citydb.traffic_area
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: traffic_area_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.traffic_area_lod2msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod2msrf_fkx ON citydb.traffic_area
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.traffic_area_lod3msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod3msrf_fkx ON citydb.traffic_area
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.traffic_area_lod4msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod4msrf_fkx ON citydb.traffic_area
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_trancmplx_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.traffic_area_trancmplx_fkx CASCADE;
CREATE INDEX traffic_area_trancmplx_fkx ON citydb.traffic_area
	USING btree
	(
	  transportation_complex_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod0msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.land_use_lod0msrf_fkx CASCADE;
CREATE INDEX land_use_lod0msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.land_use_lod1msrf_fkx CASCADE;
CREATE INDEX land_use_lod1msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.land_use_lod2msrf_fkx CASCADE;
CREATE INDEX land_use_lod2msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.land_use_lod3msrf_fkx CASCADE;
CREATE INDEX land_use_lod3msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.land_use_lod4msrf_fkx CASCADE;
CREATE INDEX land_use_lod4msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod1msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod1msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod2msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod2msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod3msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod3msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod4msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod4msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod1msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod1msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod1msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod1_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod2msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod2msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod2msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod2_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod3msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod3msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod3msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod3_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod4msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_lod4msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod4msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod4_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod1brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod2brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod3brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod4brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod1xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod2xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod3xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod4xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod1impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod2impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod3impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod4impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod1refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod2refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod3refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod4refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: waterbody_lod0curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod0curve_spx CASCADE;
CREATE INDEX waterbody_lod0curve_spx ON citydb.waterbody
	USING gist
	(
	  lod0_multi_curve
	);
-- ddl-end --

-- object: waterbody_lod1curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod1curve_spx CASCADE;
CREATE INDEX waterbody_lod1curve_spx ON citydb.waterbody
	USING gist
	(
	  lod1_multi_curve
	);
-- ddl-end --

-- object: waterbody_lod0msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod0msrf_fkx CASCADE;
CREATE INDEX waterbody_lod0msrf_fkx ON citydb.waterbody
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod1msrf_fkx CASCADE;
CREATE INDEX waterbody_lod1msrf_fkx ON citydb.waterbody
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod1solid_fkx CASCADE;
CREATE INDEX waterbody_lod1solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod2solid_fkx CASCADE;
CREATE INDEX waterbody_lod2solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod3solid_fkx CASCADE;
CREATE INDEX waterbody_lod3solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_lod4solid_fkx CASCADE;
CREATE INDEX waterbody_lod4solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbod_to_waterbnd_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbod_to_waterbnd_fkx CASCADE;
CREATE INDEX waterbod_to_waterbnd_fkx ON citydb.waterbod_to_waterbnd_srf
	USING btree
	(
	  waterboundary_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbod_to_waterbnd_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbod_to_waterbnd_fkx1 CASCADE;
CREATE INDEX waterbod_to_waterbnd_fkx1 ON citydb.waterbod_to_waterbnd_srf
	USING btree
	(
	  waterbody_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbnd_srf_objclass_fkx CASCADE;
CREATE INDEX waterbnd_srf_objclass_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod2srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbnd_srf_lod2srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod2srf_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  lod2_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod3srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbnd_srf_lod3srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod3srf_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  lod3_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod4srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbnd_srf_lod4srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod4srf_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  lod4_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: raster_relief_coverage_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.raster_relief_coverage_fkx CASCADE;
CREATE INDEX raster_relief_coverage_fkx ON citydb.raster_relief
	USING btree
	(
	  coverage_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_parent_fkx CASCADE;
CREATE INDEX tunnel_parent_fkx ON citydb.tunnel
	USING btree
	(
	  tunnel_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_root_fkx CASCADE;
CREATE INDEX tunnel_root_fkx ON citydb.tunnel
	USING btree
	(
	  tunnel_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod1terr_spx CASCADE;
CREATE INDEX tunnel_lod1terr_spx ON citydb.tunnel
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod2terr_spx CASCADE;
CREATE INDEX tunnel_lod2terr_spx ON citydb.tunnel
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod3terr_spx CASCADE;
CREATE INDEX tunnel_lod3terr_spx ON citydb.tunnel
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod4terr_spx CASCADE;
CREATE INDEX tunnel_lod4terr_spx ON citydb.tunnel
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod2curve_spx CASCADE;
CREATE INDEX tunnel_lod2curve_spx ON citydb.tunnel
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod3curve_spx CASCADE;
CREATE INDEX tunnel_lod3curve_spx ON citydb.tunnel
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod4curve_spx CASCADE;
CREATE INDEX tunnel_lod4curve_spx ON citydb.tunnel
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod1msrf_fkx CASCADE;
CREATE INDEX tunnel_lod1msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod2msrf_fkx CASCADE;
CREATE INDEX tunnel_lod2msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod3msrf_fkx CASCADE;
CREATE INDEX tunnel_lod3msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod4msrf_fkx CASCADE;
CREATE INDEX tunnel_lod4msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod1solid_fkx CASCADE;
CREATE INDEX tunnel_lod1solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod2solid_fkx CASCADE;
CREATE INDEX tunnel_lod2solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod3solid_fkx CASCADE;
CREATE INDEX tunnel_lod3solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_lod4solid_fkx CASCADE;
CREATE INDEX tunnel_lod4solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_open_to_them_srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_open_to_them_srf_fkx CASCADE;
CREATE INDEX tun_open_to_them_srf_fkx ON citydb.tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_open_to_them_srf_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_open_to_them_srf_fkx1 CASCADE;
CREATE INDEX tun_open_to_them_srf_fkx1 ON citydb.tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_hspace_tunnel_fkx CASCADE;
CREATE INDEX tun_hspace_tunnel_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_hspace_lod4msrf_fkx CASCADE;
CREATE INDEX tun_hspace_lod4msrf_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_hspace_lod4solid_fkx CASCADE;
CREATE INDEX tun_hspace_lod4solid_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_objclass_fkx CASCADE;
CREATE INDEX tun_them_srf_objclass_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_tunnel_fkx CASCADE;
CREATE INDEX tun_them_srf_tunnel_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_hspace_fkx CASCADE;
CREATE INDEX tun_them_srf_hspace_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_tun_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_tun_inst_fkx CASCADE;
CREATE INDEX tun_them_srf_tun_inst_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  tunnel_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_lod2msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod2msrf_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_lod3msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod3msrf_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_them_srf_lod4msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod4msrf_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_objclass_fkx CASCADE;
CREATE INDEX tunnel_open_objclass_fkx ON citydb.tunnel_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_lod3msrf_fkx CASCADE;
CREATE INDEX tunnel_open_lod3msrf_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_lod4msrf_fkx CASCADE;
CREATE INDEX tunnel_open_lod4msrf_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_lod3impl_fkx CASCADE;
CREATE INDEX tunnel_open_lod3impl_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_open_lod4impl_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_lod3refpt_spx CASCADE;
CREATE INDEX tunnel_open_lod3refpt_spx ON citydb.tunnel_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_open_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_open_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_open_lod4refpt_spx ON citydb.tunnel_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_objclass_fkx CASCADE;
CREATE INDEX tunnel_inst_objclass_fkx ON citydb.tunnel_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: tunnel_inst_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_tunnel_fkx CASCADE;
CREATE INDEX tunnel_inst_tunnel_fkx ON citydb.tunnel_installation
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_hspace_fkx CASCADE;
CREATE INDEX tunnel_inst_hspace_fkx ON citydb.tunnel_installation
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod2brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod2brep_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod3brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod3brep_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod4brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod4brep_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod2xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod2xgeom_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod3xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod3xgeom_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod4xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod4xgeom_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod2impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod2impl_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod3impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod3impl_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod4impl_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod2refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod2refpt_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod3refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod3refpt_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_inst_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod4refpt_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_furn_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_furn_hspace_fkx CASCADE;
CREATE INDEX tunnel_furn_hspace_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_furn_lod4brep_fkx CASCADE;
CREATE INDEX tunnel_furn_lod4brep_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_furn_lod4xgeom_spx CASCADE;
CREATE INDEX tunnel_furn_lod4xgeom_spx ON citydb.tunnel_furniture
	USING btree
	(
	  lod4_other_geom ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_furn_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_furn_lod4impl_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_furn_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_furn_lod4refpt_spx ON citydb.tunnel_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_parent_fkx CASCADE;
CREATE INDEX bridge_parent_fkx ON citydb.bridge
	USING btree
	(
	  bridge_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_root_fkx CASCADE;
CREATE INDEX bridge_root_fkx ON citydb.bridge
	USING btree
	(
	  bridge_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod1terr_spx CASCADE;
CREATE INDEX bridge_lod1terr_spx ON citydb.bridge
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod2terr_spx CASCADE;
CREATE INDEX bridge_lod2terr_spx ON citydb.bridge
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod3terr_spx CASCADE;
CREATE INDEX bridge_lod3terr_spx ON citydb.bridge
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod4terr_spx CASCADE;
CREATE INDEX bridge_lod4terr_spx ON citydb.bridge
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod2curve_spx CASCADE;
CREATE INDEX bridge_lod2curve_spx ON citydb.bridge
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: bridge_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod3curve_spx CASCADE;
CREATE INDEX bridge_lod3curve_spx ON citydb.bridge
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: bridge_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod4curve_spx CASCADE;
CREATE INDEX bridge_lod4curve_spx ON citydb.bridge
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: bridge_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod1msrf_fkx CASCADE;
CREATE INDEX bridge_lod1msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod2msrf_fkx CASCADE;
CREATE INDEX bridge_lod2msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod3msrf_fkx CASCADE;
CREATE INDEX bridge_lod3msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_lod4msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod1solid_fkx CASCADE;
CREATE INDEX bridge_lod1solid_fkx ON citydb.bridge
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod2solid_fkx CASCADE;
CREATE INDEX bridge_lod2solid_fkx ON citydb.bridge
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod3solid_fkx CASCADE;
CREATE INDEX bridge_lod3solid_fkx ON citydb.bridge
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_lod4solid_fkx CASCADE;
CREATE INDEX bridge_lod4solid_fkx ON citydb.bridge
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_furn_brd_room_fkx CASCADE;
CREATE INDEX bridge_furn_brd_room_fkx ON citydb.bridge_furniture
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_furn_lod4brep_fkx CASCADE;
CREATE INDEX bridge_furn_lod4brep_fkx ON citydb.bridge_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_furn_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_furn_lod4xgeom_spx ON citydb.bridge_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bridge_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_furn_lod4impl_fkx CASCADE;
CREATE INDEX bridge_furn_lod4impl_fkx ON citydb.bridge_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_furn_lod4refpt_spx CASCADE;
CREATE INDEX bridge_furn_lod4refpt_spx ON citydb.bridge_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_objclass_fkx CASCADE;
CREATE INDEX bridge_inst_objclass_fkx ON citydb.bridge_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: bridge_inst_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_bridge_fkx CASCADE;
CREATE INDEX bridge_inst_bridge_fkx ON citydb.bridge_installation
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_brd_room_fkx CASCADE;
CREATE INDEX bridge_inst_brd_room_fkx ON citydb.bridge_installation
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod2brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod2brep_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod3brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod3brep_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod4brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod4brep_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod2xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod2xgeom_spx ON citydb.bridge_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod3xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod3xgeom_spx ON citydb.bridge_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod4xgeom_spx ON citydb.bridge_installation
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod2impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod2impl_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod3impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod3impl_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod4impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod4impl_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod2refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod2refpt_spx ON citydb.bridge_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod3refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod3refpt_spx ON citydb.bridge_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_inst_lod4refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod4refpt_spx ON citydb.bridge_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_open_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_objclass_fkx CASCADE;
CREATE INDEX bridge_open_objclass_fkx ON citydb.bridge_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_address_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_address_fkx CASCADE;
CREATE INDEX bridge_open_address_fkx ON citydb.bridge_opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_lod3msrf_fkx CASCADE;
CREATE INDEX bridge_open_lod3msrf_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_open_lod4msrf_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_lod3impl_fkx CASCADE;
CREATE INDEX bridge_open_lod3impl_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_lod4impl_fkx CASCADE;
CREATE INDEX bridge_open_lod4impl_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_lod3refpt_spx CASCADE;
CREATE INDEX bridge_open_lod3refpt_spx ON citydb.bridge_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_open_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_open_lod4refpt_spx CASCADE;
CREATE INDEX bridge_open_lod4refpt_spx ON citydb.bridge_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: brd_open_to_them_srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_open_to_them_srf_fkx CASCADE;
CREATE INDEX brd_open_to_them_srf_fkx ON citydb.bridge_open_to_them_srf
	USING btree
	(
	  bridge_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_open_to_them_srf_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_open_to_them_srf_fkx1 CASCADE;
CREATE INDEX brd_open_to_them_srf_fkx1 ON citydb.bridge_open_to_them_srf
	USING btree
	(
	  bridge_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_room_bridge_fkx CASCADE;
CREATE INDEX bridge_room_bridge_fkx ON citydb.bridge_room
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_room_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_room_lod4msrf_fkx ON citydb.bridge_room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_room_lod4solid_fkx CASCADE;
CREATE INDEX bridge_room_lod4solid_fkx ON citydb.bridge_room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_objclass_fkx CASCADE;
CREATE INDEX brd_them_srf_objclass_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_bridge_fkx CASCADE;
CREATE INDEX brd_them_srf_bridge_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_brd_room_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_room_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_brd_inst_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_inst_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_const_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_brd_const_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_const_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_constr_element_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_lod2msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod2msrf_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_lod3msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod3msrf_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.brd_them_srf_lod4msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod4msrf_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_bridge_fkx CASCADE;
CREATE INDEX bridge_constr_bridge_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod1terr_spx CASCADE;
CREATE INDEX bridge_constr_lod1terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod2terr_spx CASCADE;
CREATE INDEX bridge_constr_lod2terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod3terr_spx CASCADE;
CREATE INDEX bridge_constr_lod3terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod4terr_spx CASCADE;
CREATE INDEX bridge_constr_lod4terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod1brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod1brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod2brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod2brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod3brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod3brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod4brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod4brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_const_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod1xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod1xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod2xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod2xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod3xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod3xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod4xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bridge_constr_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod1impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod1impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod2impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod2impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod3impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod3impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_lod4impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod4impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_const_lod1refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod1refpt_spx CASCADE;
CREATE INDEX bridge_const_lod1refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod2refpt_spx CASCADE;
CREATE INDEX bridge_const_lod2refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod3refpt_spx CASCADE;
CREATE INDEX bridge_const_lod3refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_const_lod4refpt_spx CASCADE;
CREATE INDEX bridge_const_lod4refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: address_to_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_to_bridge_fkx CASCADE;
CREATE INDEX address_to_bridge_fkx ON citydb.address_to_bridge
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: address_to_bridge_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_to_bridge_fkx1 CASCADE;
CREATE INDEX address_to_bridge_fkx1 ON citydb.address_to_bridge
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.cityobject_inx CASCADE;
CREATE INDEX cityobject_inx ON citydb.cityobject
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.cityobject_objectclass_fkx CASCADE;
CREATE INDEX cityobject_objectclass_fkx ON citydb.cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_envelope_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.cityobject_envelope_spx CASCADE;
CREATE INDEX cityobject_envelope_spx ON citydb.cityobject
	USING gist
	(
	  envelope
	);
-- ddl-end --

-- object: appearance_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.appearance_inx CASCADE;
CREATE INDEX appearance_inx ON citydb.appearance
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_theme_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.appearance_theme_inx CASCADE;
CREATE INDEX appearance_theme_inx ON citydb.appearance
	USING btree
	(
	  theme ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_citymodel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.appearance_citymodel_fkx CASCADE;
CREATE INDEX appearance_citymodel_fkx ON citydb.appearance
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.appearance_cityobject_fkx CASCADE;
CREATE INDEX appearance_cityobject_fkx ON citydb.appearance
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geom_ref2lib_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.implicit_geom_ref2lib_inx CASCADE;
CREATE INDEX implicit_geom_ref2lib_inx ON citydb.implicit_geometry
	USING btree
	(
	  reference_to_library ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geom_brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.implicit_geom_brep_fkx CASCADE;
CREATE INDEX implicit_geom_brep_fkx ON citydb.implicit_geometry
	USING btree
	(
	  relative_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_geom_inx CASCADE;
CREATE INDEX surface_geom_inx ON citydb.surface_geometry
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_geom_parent_fkx CASCADE;
CREATE INDEX surface_geom_parent_fkx ON citydb.surface_geometry
	USING btree
	(
	  parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_geom_root_fkx CASCADE;
CREATE INDEX surface_geom_root_fkx ON citydb.surface_geometry
	USING btree
	(
	  root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_geom_spx CASCADE;
CREATE INDEX surface_geom_spx ON citydb.surface_geometry
	USING gist
	(
	  geometry
	);
-- ddl-end --

-- object: surface_geom_solid_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_geom_solid_spx CASCADE;
CREATE INDEX surface_geom_solid_spx ON citydb.surface_geometry
	USING gist
	(
	  solid_geometry
	);
-- ddl-end --

-- object: surface_geom_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_geom_cityobj_fkx CASCADE;
CREATE INDEX surface_geom_cityobj_fkx ON citydb.surface_geometry
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_data_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_data_inx CASCADE;
CREATE INDEX surface_data_inx ON citydb.surface_data
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_data_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_data_spx CASCADE;
CREATE INDEX surface_data_spx ON citydb.surface_data
	USING gist
	(
	  gt_reference_point
	);
-- ddl-end --

-- object: surface_data_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_data_objclass_fkx CASCADE;
CREATE INDEX surface_data_objclass_fkx ON citydb.surface_data
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: surface_data_tex_image_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.surface_data_tex_image_fkx CASCADE;
CREATE INDEX surface_data_tex_image_fkx ON citydb.surface_data
	USING btree
	(
	  tex_image_id ASC NULLS LAST
	);
-- ddl-end --

-- object: citymodel_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.citymodel_inx CASCADE;
CREATE INDEX citymodel_inx ON citydb.citymodel
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	);
-- ddl-end --

-- object: genericattrib_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.genericattrib_parent_fkx CASCADE;
CREATE INDEX genericattrib_parent_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  parent_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.genericattrib_root_fkx CASCADE;
CREATE INDEX genericattrib_root_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  root_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.genericattrib_geom_fkx CASCADE;
CREATE INDEX genericattrib_geom_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.genericattrib_cityobj_fkx CASCADE;
CREATE INDEX genericattrib_cityobj_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: ext_ref_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.ext_ref_cityobject_fkx CASCADE;
CREATE INDEX ext_ref_cityobject_fkx ON citydb.external_reference
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: grid_coverage_raster_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.grid_coverage_raster_spx CASCADE;
CREATE INDEX grid_coverage_raster_spx ON citydb.grid_coverage
	USING gist
	(
	  (ST_ConvexHull(rasterproperty))
	);
-- ddl-end --

-- object: cityobject_lineage_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.cityobject_lineage_inx CASCADE;
CREATE INDEX cityobject_lineage_inx ON citydb.cityobject
	USING btree
	(
	  lineage ASC NULLS LAST
	);
-- ddl-end --

-- object: citymodel_envelope_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.citymodel_envelope_spx CASCADE;
CREATE INDEX citymodel_envelope_spx ON citydb.citymodel
	USING gist
	(
	  envelope
	);
-- ddl-end --

-- object: address_inx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_inx CASCADE;
CREATE INDEX address_inx ON citydb.address
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	);
-- ddl-end --

-- object: address_point_spx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_point_spx CASCADE;
CREATE INDEX address_point_spx ON citydb.address
	USING gist
	(
	  multi_point
	);
-- ddl-end --

-- object: citydb.schema | type: TABLE --
-- DROP TABLE IF EXISTS citydb.schema CASCADE;
CREATE TABLE citydb.schema(
	id integer NOT NULL,
	is_root_schema numeric,
	name character varying(1000),
	namespace_uri character varying(4000),
	db_prefix character varying(10),
	version character varying(50),
	xml_prefix character varying(50),
	xml_schema_location character varying(4000),
	xml_schemafile bytea,
	xml_schemafile_type character varying(256),
	xml_schemamapping_file text,
	drop_db_script text,
	CONSTRAINT schema_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: citydb.schema_to_objectclass | type: TABLE --
-- DROP TABLE IF EXISTS citydb.schema_to_objectclass CASCADE;
CREATE TABLE citydb.schema_to_objectclass(
	schema_id integer NOT NULL,
	objectclass_id integer NOT NULL,
	CONSTRAINT schema_to_objectclass_pk PRIMARY KEY (schema_id,objectclass_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: schema_to_objectclass_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.schema_to_objectclass_fkx1 CASCADE;
CREATE INDEX schema_to_objectclass_fkx1 ON citydb.schema_to_objectclass
	USING btree
	(
	  schema_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: schema_to_objectclass_fkx2 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.schema_to_objectclass_fkx2 CASCADE;
CREATE INDEX schema_to_objectclass_fkx2 ON citydb.schema_to_objectclass
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: objectclass_baseclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.objectclass_baseclass_fkx CASCADE;
CREATE INDEX objectclass_baseclass_fkx ON citydb.objectclass
	USING btree
	(
	  baseclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: citydb.schema_referencing | type: TABLE --
-- DROP TABLE IF EXISTS citydb.schema_referencing CASCADE;
CREATE TABLE citydb.schema_referencing(
	local_id integer NOT NULL,
	referencing_id integer NOT NULL,
	CONSTRAINT schema_referencing_pk PRIMARY KEY (local_id,referencing_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: schema_referencing_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.schema_referencing_fkx1 CASCADE;
CREATE INDEX schema_referencing_fkx1 ON citydb.schema_referencing
	USING btree
	(
	  local_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: schema_referencing_fkx2 | type: INDEX --
-- DROP INDEX IF EXISTS citydb.schema_referencing_fkx2 CASCADE;
CREATE INDEX schema_referencing_fkx2 ON citydb.schema_referencing
	USING btree
	(
	  referencing_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: citydb.schema_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.schema_seq CASCADE;
CREATE SEQUENCE citydb.schema_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: citydb.objectclass_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citydb.objectclass_seq CASCADE;
CREATE SEQUENCE citydb.objectclass_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 10000
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: address_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.address_objclass_fkx CASCADE;
CREATE INDEX address_objclass_fkx ON citydb.address
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.appearance_objclass_fkx CASCADE;
CREATE INDEX appearance_objclass_fkx ON citydb.appearance
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: breakline_rel_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.breakline_rel_objclass_fkx CASCADE;
CREATE INDEX breakline_rel_objclass_fkx ON citydb.breakline_relief
	USING btree
	(
	  objectclass_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_objectclass_fkx CASCADE;
CREATE INDEX bridge_objectclass_fkx ON citydb.bridge
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_constr_objclass_fkx CASCADE;
CREATE INDEX bridge_constr_objclass_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_furn_objclass_fkx CASCADE;
CREATE INDEX bridge_furn_objclass_fkx ON citydb.bridge_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bridge_room_objclass_fkx CASCADE;
CREATE INDEX bridge_room_objclass_fkx ON citydb.bridge_room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.building_objectclass_fkx CASCADE;
CREATE INDEX building_objectclass_fkx ON citydb.building
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.bldg_furn_objclass_fkx CASCADE;
CREATE INDEX bldg_furn_objclass_fkx ON citydb.building_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.city_furn_objclass_fkx CASCADE;
CREATE INDEX city_furn_objclass_fkx ON citydb.city_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: citymodel_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.citymodel_objectclass_fkx CASCADE;
CREATE INDEX citymodel_objectclass_fkx ON citydb.citymodel
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.group_objectclass_fkx CASCADE;
CREATE INDEX group_objectclass_fkx ON citydb.cityobjectgroup
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.gen_object_objclass_fkx CASCADE;
CREATE INDEX gen_object_objclass_fkx ON citydb.generic_cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geom_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.implicit_geom_objclass_fkx CASCADE;
CREATE INDEX implicit_geom_objclass_fkx ON citydb.implicit_geometry
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.land_use_objclass_fkx CASCADE;
CREATE INDEX land_use_objclass_fkx ON citydb.land_use
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: masspoint_rel_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.masspoint_rel_objclass_fkx CASCADE;
CREATE INDEX masspoint_rel_objclass_fkx ON citydb.masspoint_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.plant_cover_objclass_fkx CASCADE;
CREATE INDEX plant_cover_objclass_fkx ON citydb.plant_cover
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: raster_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.raster_relief_objclass_fkx CASCADE;
CREATE INDEX raster_relief_objclass_fkx ON citydb.raster_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: relief_feat_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.relief_feat_objclass_fkx CASCADE;
CREATE INDEX relief_feat_objclass_fkx ON citydb.relief_feature
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: "ROOM_OBJECTCLASS_FKX" | type: INDEX --
-- DROP INDEX IF EXISTS citydb."ROOM_OBJECTCLASS_FKX" CASCADE;
CREATE INDEX "ROOM_OBJECTCLASS_FKX" ON citydb.room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.sol_veg_obj_objclass_fkx CASCADE;
CREATE INDEX sol_veg_obj_objclass_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: texparam_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.texparam_objclass_fkx CASCADE;
CREATE INDEX texparam_objclass_fkx ON citydb.textureparam
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tin_relief_objclass_fkx CASCADE;
CREATE INDEX tin_relief_objclass_fkx ON citydb.tin_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_objectclass_fkx CASCADE;
CREATE INDEX tunnel_objectclass_fkx ON citydb.tunnel
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tunnel_furn_objclass_fkx CASCADE;
CREATE INDEX tunnel_furn_objclass_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.tun_hspace_objclass_fkx CASCADE;
CREATE INDEX tun_hspace_objclass_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS citydb.waterbody_objclass_fkx CASCADE;
CREATE INDEX waterbody_objclass_fkx ON citydb.waterbody
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_member_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject_member DROP CONSTRAINT IF EXISTS cityobject_member_fk CASCADE;
ALTER TABLE citydb.cityobject_member ADD CONSTRAINT cityobject_member_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: cityobject_member_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject_member DROP CONSTRAINT IF EXISTS cityobject_member_fk1 CASCADE;
ALTER TABLE citydb.cityobject_member ADD CONSTRAINT cityobject_member_fk1 FOREIGN KEY (citymodel_id)
REFERENCES citydb.citymodel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: general_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generalization DROP CONSTRAINT IF EXISTS general_cityobject_fk CASCADE;
ALTER TABLE citydb.generalization ADD CONSTRAINT general_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: general_generalizes_to_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generalization DROP CONSTRAINT IF EXISTS general_generalizes_to_fk CASCADE;
ALTER TABLE citydb.generalization ADD CONSTRAINT general_generalizes_to_fk FOREIGN KEY (generalizes_to_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobjectgroup DROP CONSTRAINT IF EXISTS group_cityobject_fk CASCADE;
ALTER TABLE citydb.cityobjectgroup ADD CONSTRAINT group_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobjectgroup DROP CONSTRAINT IF EXISTS group_brep_fk CASCADE;
ALTER TABLE citydb.cityobjectgroup ADD CONSTRAINT group_brep_fk FOREIGN KEY (brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_parent_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobjectgroup DROP CONSTRAINT IF EXISTS group_parent_cityobj_fk CASCADE;
ALTER TABLE citydb.cityobjectgroup ADD CONSTRAINT group_parent_cityobj_fk FOREIGN KEY (parent_cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobjectgroup DROP CONSTRAINT IF EXISTS group_objectclass_fk CASCADE;
ALTER TABLE citydb.cityobjectgroup ADD CONSTRAINT group_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_to_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.group_to_cityobject DROP CONSTRAINT IF EXISTS group_to_cityobject_fk CASCADE;
ALTER TABLE citydb.group_to_cityobject ADD CONSTRAINT group_to_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_to_cityobject_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.group_to_cityobject DROP CONSTRAINT IF EXISTS group_to_cityobject_fk1 CASCADE;
ALTER TABLE citydb.group_to_cityobject ADD CONSTRAINT group_to_cityobject_fk1 FOREIGN KEY (cityobjectgroup_id)
REFERENCES citydb.cityobjectgroup (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: objectclass_superclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.objectclass DROP CONSTRAINT IF EXISTS objectclass_superclass_fk CASCADE;
ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY (superclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: objectclass_baseclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.objectclass DROP CONSTRAINT IF EXISTS objectclass_baseclass_fk CASCADE;
ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_baseclass_fk FOREIGN KEY (baseclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_cityobject_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod1brep_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod2brep_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod3brep_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod4brep_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod1impl_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod2impl_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod3impl_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod4impl_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.city_furniture DROP CONSTRAINT IF EXISTS city_furn_objclass_fk CASCADE;
ALTER TABLE citydb.city_furniture ADD CONSTRAINT city_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_cityobject_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod0brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod0brep_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod0brep_fk FOREIGN KEY (lod0_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod1brep_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod2brep_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod3brep_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod4brep_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod0impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod0impl_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod0impl_fk FOREIGN KEY (lod0_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod1impl_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod2impl_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod3impl_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod4impl_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_objclass_fk CASCADE;
ALTER TABLE citydb.generic_cityobject ADD CONSTRAINT gen_object_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_building_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.address_to_building DROP CONSTRAINT IF EXISTS address_to_building_fk CASCADE;
ALTER TABLE citydb.address_to_building ADD CONSTRAINT address_to_building_fk FOREIGN KEY (address_id)
REFERENCES citydb.address (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_building_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.address_to_building DROP CONSTRAINT IF EXISTS address_to_building_fk1 CASCADE;
ALTER TABLE citydb.address_to_building ADD CONSTRAINT address_to_building_fk1 FOREIGN KEY (building_id)
REFERENCES citydb.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_cityobject_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_parent_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_parent_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_parent_fk FOREIGN KEY (building_parent_id)
REFERENCES citydb.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_root_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_root_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_root_fk FOREIGN KEY (building_root_id)
REFERENCES citydb.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod0footprint_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod0footprint_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod0footprint_fk FOREIGN KEY (lod0_footprint_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod0roofprint_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod0roofprint_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod0roofprint_fk FOREIGN KEY (lod0_roofprint_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod1msrf_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod2msrf_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod3msrf_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod4msrf_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod1solid_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod2solid_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod3solid_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_lod4solid_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building DROP CONSTRAINT IF EXISTS building_objectclass_fk CASCADE;
ALTER TABLE citydb.building ADD CONSTRAINT building_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_cityobject_fk CASCADE;
ALTER TABLE citydb.building_furniture ADD CONSTRAINT bldg_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_room_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_room_fk CASCADE;
ALTER TABLE citydb.building_furniture ADD CONSTRAINT bldg_furn_room_fk FOREIGN KEY (room_id)
REFERENCES citydb.room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_lod4brep_fk CASCADE;
ALTER TABLE citydb.building_furniture ADD CONSTRAINT bldg_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_lod4impl_fk CASCADE;
ALTER TABLE citydb.building_furniture ADD CONSTRAINT bldg_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_objclass_fk CASCADE;
ALTER TABLE citydb.building_furniture ADD CONSTRAINT bldg_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_cityobject_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_objclass_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_building_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_building_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_building_fk FOREIGN KEY (building_id)
REFERENCES citydb.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_room_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_room_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_room_fk FOREIGN KEY (room_id)
REFERENCES citydb.room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod2brep_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod3brep_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod4brep_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod2impl_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod3impl_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod4impl_fk CASCADE;
ALTER TABLE citydb.building_installation ADD CONSTRAINT bldg_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_cityobject_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_objectclass_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_address_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_address_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_address_fk FOREIGN KEY (address_id)
REFERENCES citydb.address (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_lod3msrf_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_lod4msrf_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_lod3impl_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening DROP CONSTRAINT IF EXISTS opening_lod4impl_fk CASCADE;
ALTER TABLE citydb.opening ADD CONSTRAINT opening_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: open_to_them_surface_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.opening_to_them_surface DROP CONSTRAINT IF EXISTS open_to_them_surface_fk CASCADE;
ALTER TABLE citydb.opening_to_them_surface ADD CONSTRAINT open_to_them_surface_fk FOREIGN KEY (opening_id)
REFERENCES citydb.opening (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: open_to_them_surface_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.opening_to_them_surface DROP CONSTRAINT IF EXISTS open_to_them_surface_fk1 CASCADE;
ALTER TABLE citydb.opening_to_them_surface ADD CONSTRAINT open_to_them_surface_fk1 FOREIGN KEY (thematic_surface_id)
REFERENCES citydb.thematic_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.room DROP CONSTRAINT IF EXISTS room_cityobject_fk CASCADE;
ALTER TABLE citydb.room ADD CONSTRAINT room_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_building_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.room DROP CONSTRAINT IF EXISTS room_building_fk CASCADE;
ALTER TABLE citydb.room ADD CONSTRAINT room_building_fk FOREIGN KEY (building_id)
REFERENCES citydb.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.room DROP CONSTRAINT IF EXISTS room_lod4msrf_fk CASCADE;
ALTER TABLE citydb.room ADD CONSTRAINT room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.room DROP CONSTRAINT IF EXISTS room_lod4solid_fk CASCADE;
ALTER TABLE citydb.room ADD CONSTRAINT room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.room DROP CONSTRAINT IF EXISTS room_objectclass_fk CASCADE;
ALTER TABLE citydb.room ADD CONSTRAINT room_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_cityobject_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_objclass_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_building_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_building_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_building_fk FOREIGN KEY (building_id)
REFERENCES citydb.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_room_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_room_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_room_fk FOREIGN KEY (room_id)
REFERENCES citydb.room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_bldg_inst_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_bldg_inst_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_bldg_inst_fk FOREIGN KEY (building_installation_id)
REFERENCES citydb.building_installation (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_lod2msrf_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_lod3msrf_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.thematic_surface DROP CONSTRAINT IF EXISTS them_surface_lod4msrf_fk CASCADE;
ALTER TABLE citydb.thematic_surface ADD CONSTRAINT them_surface_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: texparam_geom_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.textureparam DROP CONSTRAINT IF EXISTS texparam_geom_fk CASCADE;
ALTER TABLE citydb.textureparam ADD CONSTRAINT texparam_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: texparam_surface_data_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.textureparam DROP CONSTRAINT IF EXISTS texparam_surface_data_fk CASCADE;
ALTER TABLE citydb.textureparam ADD CONSTRAINT texparam_surface_data_fk FOREIGN KEY (surface_data_id)
REFERENCES citydb.surface_data (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: texparam_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.textureparam DROP CONSTRAINT IF EXISTS texparam_objclass_fk CASCADE;
ALTER TABLE citydb.textureparam ADD CONSTRAINT texparam_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: app_to_surf_data_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.appear_to_surface_data DROP CONSTRAINT IF EXISTS app_to_surf_data_fk CASCADE;
ALTER TABLE citydb.appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk FOREIGN KEY (surface_data_id)
REFERENCES citydb.surface_data (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: app_to_surf_data_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.appear_to_surface_data DROP CONSTRAINT IF EXISTS app_to_surf_data_fk1 CASCADE;
ALTER TABLE citydb.appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk1 FOREIGN KEY (appearance_id)
REFERENCES citydb.appearance (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: breakline_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.breakline_relief DROP CONSTRAINT IF EXISTS breakline_relief_comp_fk CASCADE;
ALTER TABLE citydb.breakline_relief ADD CONSTRAINT breakline_relief_comp_fk FOREIGN KEY (id)
REFERENCES citydb.relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: breakline_rel_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.breakline_relief DROP CONSTRAINT IF EXISTS breakline_rel_objclass_fk CASCADE;
ALTER TABLE citydb.breakline_relief ADD CONSTRAINT breakline_rel_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: masspoint_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.masspoint_relief DROP CONSTRAINT IF EXISTS masspoint_relief_comp_fk CASCADE;
ALTER TABLE citydb.masspoint_relief ADD CONSTRAINT masspoint_relief_comp_fk FOREIGN KEY (id)
REFERENCES citydb.relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: masspoint_rel_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.masspoint_relief DROP CONSTRAINT IF EXISTS masspoint_rel_objclass_fk CASCADE;
ALTER TABLE citydb.masspoint_relief ADD CONSTRAINT masspoint_rel_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_comp_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.relief_component DROP CONSTRAINT IF EXISTS relief_comp_cityobject_fk CASCADE;
ALTER TABLE citydb.relief_component ADD CONSTRAINT relief_comp_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_comp_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.relief_component DROP CONSTRAINT IF EXISTS relief_comp_objclass_fk CASCADE;
ALTER TABLE citydb.relief_component ADD CONSTRAINT relief_comp_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: rel_feat_to_rel_comp_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.relief_feat_to_rel_comp DROP CONSTRAINT IF EXISTS rel_feat_to_rel_comp_fk CASCADE;
ALTER TABLE citydb.relief_feat_to_rel_comp ADD CONSTRAINT rel_feat_to_rel_comp_fk FOREIGN KEY (relief_component_id)
REFERENCES citydb.relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: rel_feat_to_rel_comp_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.relief_feat_to_rel_comp DROP CONSTRAINT IF EXISTS rel_feat_to_rel_comp_fk1 CASCADE;
ALTER TABLE citydb.relief_feat_to_rel_comp ADD CONSTRAINT rel_feat_to_rel_comp_fk1 FOREIGN KEY (relief_feature_id)
REFERENCES citydb.relief_feature (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_feat_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.relief_feature DROP CONSTRAINT IF EXISTS relief_feat_cityobject_fk CASCADE;
ALTER TABLE citydb.relief_feature ADD CONSTRAINT relief_feat_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_feat_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.relief_feature DROP CONSTRAINT IF EXISTS relief_feat_objclass_fk CASCADE;
ALTER TABLE citydb.relief_feature ADD CONSTRAINT relief_feat_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tin_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tin_relief DROP CONSTRAINT IF EXISTS tin_relief_comp_fk CASCADE;
ALTER TABLE citydb.tin_relief ADD CONSTRAINT tin_relief_comp_fk FOREIGN KEY (id)
REFERENCES citydb.relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tin_relief_geom_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tin_relief DROP CONSTRAINT IF EXISTS tin_relief_geom_fk CASCADE;
ALTER TABLE citydb.tin_relief ADD CONSTRAINT tin_relief_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tin_relief_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tin_relief DROP CONSTRAINT IF EXISTS tin_relief_objclass_fk CASCADE;
ALTER TABLE citydb.tin_relief ADD CONSTRAINT tin_relief_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_objclass_fk CASCADE;
ALTER TABLE citydb.transportation_complex ADD CONSTRAINT tran_complex_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_cityobject_fk CASCADE;
ALTER TABLE citydb.transportation_complex ADD CONSTRAINT tran_complex_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod1msrf_fk CASCADE;
ALTER TABLE citydb.transportation_complex ADD CONSTRAINT tran_complex_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod2msrf_fk CASCADE;
ALTER TABLE citydb.transportation_complex ADD CONSTRAINT tran_complex_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod3msrf_fk CASCADE;
ALTER TABLE citydb.transportation_complex ADD CONSTRAINT tran_complex_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod4msrf_fk CASCADE;
ALTER TABLE citydb.transportation_complex ADD CONSTRAINT tran_complex_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.traffic_area DROP CONSTRAINT IF EXISTS traffic_area_cityobject_fk CASCADE;
ALTER TABLE citydb.traffic_area ADD CONSTRAINT traffic_area_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.traffic_area DROP CONSTRAINT IF EXISTS traffic_area_objclass_fk CASCADE;
ALTER TABLE citydb.traffic_area ADD CONSTRAINT traffic_area_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.traffic_area DROP CONSTRAINT IF EXISTS traffic_area_lod2msrf_fk CASCADE;
ALTER TABLE citydb.traffic_area ADD CONSTRAINT traffic_area_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.traffic_area DROP CONSTRAINT IF EXISTS traffic_area_lod3msrf_fk CASCADE;
ALTER TABLE citydb.traffic_area ADD CONSTRAINT traffic_area_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.traffic_area DROP CONSTRAINT IF EXISTS traffic_area_lod4msrf_fk CASCADE;
ALTER TABLE citydb.traffic_area ADD CONSTRAINT traffic_area_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_trancmplx_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.traffic_area DROP CONSTRAINT IF EXISTS traffic_area_trancmplx_fk CASCADE;
ALTER TABLE citydb.traffic_area ADD CONSTRAINT traffic_area_trancmplx_fk FOREIGN KEY (transportation_complex_id)
REFERENCES citydb.transportation_complex (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_cityobject_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod0msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_lod0msrf_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_lod1msrf_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_lod2msrf_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_lod3msrf_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_lod4msrf_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.land_use DROP CONSTRAINT IF EXISTS land_use_objclass_fk CASCADE;
ALTER TABLE citydb.land_use ADD CONSTRAINT land_use_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_cityobject_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod1msrf_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod2msrf_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod3msrf_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod4msrf_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod1msolid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod1msolid_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod1msolid_fk FOREIGN KEY (lod1_multi_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod2msolid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod2msolid_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod2msolid_fk FOREIGN KEY (lod2_multi_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod3msolid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod3msolid_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod3msolid_fk FOREIGN KEY (lod3_multi_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod4msolid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod4msolid_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_lod4msolid_fk FOREIGN KEY (lod4_multi_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.plant_cover DROP CONSTRAINT IF EXISTS plant_cover_objclass_fk CASCADE;
ALTER TABLE citydb.plant_cover ADD CONSTRAINT plant_cover_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_cityobject_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod1brep_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod2brep_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod3brep_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod4brep_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod1impl_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod2impl_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod3impl_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod4impl_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_objclass_fk CASCADE;
ALTER TABLE citydb.solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_cityobject_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod0msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_lod0msrf_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_lod1msrf_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_lod1solid_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_lod2solid_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_lod3solid_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_lod4solid_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbody DROP CONSTRAINT IF EXISTS waterbody_objclass_fk CASCADE;
ALTER TABLE citydb.waterbody ADD CONSTRAINT waterbody_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbod_to_waterbnd_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbod_to_waterbnd_srf DROP CONSTRAINT IF EXISTS waterbod_to_waterbnd_fk CASCADE;
ALTER TABLE citydb.waterbod_to_waterbnd_srf ADD CONSTRAINT waterbod_to_waterbnd_fk FOREIGN KEY (waterboundary_surface_id)
REFERENCES citydb.waterboundary_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbod_to_waterbnd_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.waterbod_to_waterbnd_srf DROP CONSTRAINT IF EXISTS waterbod_to_waterbnd_fk1 CASCADE;
ALTER TABLE citydb.waterbod_to_waterbnd_srf ADD CONSTRAINT waterbod_to_waterbnd_fk1 FOREIGN KEY (waterbody_id)
REFERENCES citydb.waterbody (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_cityobject_fk CASCADE;
ALTER TABLE citydb.waterboundary_surface ADD CONSTRAINT waterbnd_srf_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_objclass_fk CASCADE;
ALTER TABLE citydb.waterboundary_surface ADD CONSTRAINT waterbnd_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_lod2srf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_lod2srf_fk CASCADE;
ALTER TABLE citydb.waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod2srf_fk FOREIGN KEY (lod2_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_lod3srf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_lod3srf_fk CASCADE;
ALTER TABLE citydb.waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod3srf_fk FOREIGN KEY (lod3_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_lod4srf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_lod4srf_fk CASCADE;
ALTER TABLE citydb.waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod4srf_fk FOREIGN KEY (lod4_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.raster_relief DROP CONSTRAINT IF EXISTS raster_relief_comp_fk CASCADE;
ALTER TABLE citydb.raster_relief ADD CONSTRAINT raster_relief_comp_fk FOREIGN KEY (id)
REFERENCES citydb.relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_coverage_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.raster_relief DROP CONSTRAINT IF EXISTS raster_relief_coverage_fk CASCADE;
ALTER TABLE citydb.raster_relief ADD CONSTRAINT raster_relief_coverage_fk FOREIGN KEY (coverage_id)
REFERENCES citydb.grid_coverage (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.raster_relief DROP CONSTRAINT IF EXISTS raster_relief_objclass_fk CASCADE;
ALTER TABLE citydb.raster_relief ADD CONSTRAINT raster_relief_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_cityobject_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_parent_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_parent_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_parent_fk FOREIGN KEY (tunnel_parent_id)
REFERENCES citydb.tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_root_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_root_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_root_fk FOREIGN KEY (tunnel_root_id)
REFERENCES citydb.tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod1msrf_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod2msrf_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod3msrf_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod4msrf_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod1solid_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod2solid_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod3solid_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_lod4solid_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel DROP CONSTRAINT IF EXISTS tunnel_objectclass_fk CASCADE;
ALTER TABLE citydb.tunnel ADD CONSTRAINT tunnel_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_open_to_them_srf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_open_to_them_srf DROP CONSTRAINT IF EXISTS tun_open_to_them_srf_fk CASCADE;
ALTER TABLE citydb.tunnel_open_to_them_srf ADD CONSTRAINT tun_open_to_them_srf_fk FOREIGN KEY (tunnel_opening_id)
REFERENCES citydb.tunnel_opening (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_open_to_them_srf_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_open_to_them_srf DROP CONSTRAINT IF EXISTS tun_open_to_them_srf_fk1 CASCADE;
ALTER TABLE citydb.tunnel_open_to_them_srf ADD CONSTRAINT tun_open_to_them_srf_fk1 FOREIGN KEY (tunnel_thematic_surface_id)
REFERENCES citydb.tunnel_thematic_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_cityobj_fk CASCADE;
ALTER TABLE citydb.tunnel_hollow_space ADD CONSTRAINT tun_hspace_cityobj_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_tunnel_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_tunnel_fk CASCADE;
ALTER TABLE citydb.tunnel_hollow_space ADD CONSTRAINT tun_hspace_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES citydb.tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_lod4msrf_fk CASCADE;
ALTER TABLE citydb.tunnel_hollow_space ADD CONSTRAINT tun_hspace_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_lod4solid_fk CASCADE;
ALTER TABLE citydb.tunnel_hollow_space ADD CONSTRAINT tun_hspace_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_objclass_fk CASCADE;
ALTER TABLE citydb.tunnel_hollow_space ADD CONSTRAINT tun_hspace_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_cityobj_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_cityobj_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_objclass_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_tunnel_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_tunnel_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES citydb.tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_hspace_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_hspace_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES citydb.tunnel_hollow_space (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_tun_inst_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_tun_inst_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_tun_inst_fk FOREIGN KEY (tunnel_installation_id)
REFERENCES citydb.tunnel_installation (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_lod2msrf_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_lod3msrf_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_lod4msrf_fk CASCADE;
ALTER TABLE citydb.tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_cityobject_fk CASCADE;
ALTER TABLE citydb.tunnel_opening ADD CONSTRAINT tunnel_open_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_objclass_fk CASCADE;
ALTER TABLE citydb.tunnel_opening ADD CONSTRAINT tunnel_open_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod3msrf_fk CASCADE;
ALTER TABLE citydb.tunnel_opening ADD CONSTRAINT tunnel_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod4msrf_fk CASCADE;
ALTER TABLE citydb.tunnel_opening ADD CONSTRAINT tunnel_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod3impl_fk CASCADE;
ALTER TABLE citydb.tunnel_opening ADD CONSTRAINT tunnel_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod4impl_fk CASCADE;
ALTER TABLE citydb.tunnel_opening ADD CONSTRAINT tunnel_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_cityobject_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_objclass_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_tunnel_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_tunnel_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES citydb.tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_hspace_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_hspace_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES citydb.tunnel_hollow_space (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod2brep_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod3brep_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod4brep_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod2impl_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod3impl_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod4impl_fk CASCADE;
ALTER TABLE citydb.tunnel_installation ADD CONSTRAINT tunnel_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_cityobject_fk CASCADE;
ALTER TABLE citydb.tunnel_furniture ADD CONSTRAINT tunnel_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_hspace_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_hspace_fk CASCADE;
ALTER TABLE citydb.tunnel_furniture ADD CONSTRAINT tunnel_furn_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES citydb.tunnel_hollow_space (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_lod4brep_fk CASCADE;
ALTER TABLE citydb.tunnel_furniture ADD CONSTRAINT tunnel_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_lod4impl_fk CASCADE;
ALTER TABLE citydb.tunnel_furniture ADD CONSTRAINT tunnel_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_objclass_fk CASCADE;
ALTER TABLE citydb.tunnel_furniture ADD CONSTRAINT tunnel_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_cityobject_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_parent_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_parent_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_parent_fk FOREIGN KEY (bridge_parent_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_root_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_root_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_root_fk FOREIGN KEY (bridge_root_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod1msrf_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod2msrf_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod3msrf_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod4msrf_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod1solid_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod2solid_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod3solid_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_lod4solid_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge DROP CONSTRAINT IF EXISTS bridge_objectclass_fk CASCADE;
ALTER TABLE citydb.bridge ADD CONSTRAINT bridge_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_cityobject_fk CASCADE;
ALTER TABLE citydb.bridge_furniture ADD CONSTRAINT bridge_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_brd_room_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_brd_room_fk CASCADE;
ALTER TABLE citydb.bridge_furniture ADD CONSTRAINT bridge_furn_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES citydb.bridge_room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_lod4brep_fk CASCADE;
ALTER TABLE citydb.bridge_furniture ADD CONSTRAINT bridge_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_lod4impl_fk CASCADE;
ALTER TABLE citydb.bridge_furniture ADD CONSTRAINT bridge_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_objclass_fk CASCADE;
ALTER TABLE citydb.bridge_furniture ADD CONSTRAINT bridge_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_cityobject_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_objclass_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_bridge_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_brd_room_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_brd_room_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES citydb.bridge_room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod2brep_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod3brep_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod4brep_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod2impl_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod3impl_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod4impl_fk CASCADE;
ALTER TABLE citydb.bridge_installation ADD CONSTRAINT bridge_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_cityobject_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_objclass_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_address_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_address_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_address_fk FOREIGN KEY (address_id)
REFERENCES citydb.address (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod3msrf_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod4msrf_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod3impl_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod4impl_fk CASCADE;
ALTER TABLE citydb.bridge_opening ADD CONSTRAINT bridge_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_open_to_them_srf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_open_to_them_srf DROP CONSTRAINT IF EXISTS brd_open_to_them_srf_fk CASCADE;
ALTER TABLE citydb.bridge_open_to_them_srf ADD CONSTRAINT brd_open_to_them_srf_fk FOREIGN KEY (bridge_opening_id)
REFERENCES citydb.bridge_opening (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_open_to_them_srf_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_open_to_them_srf DROP CONSTRAINT IF EXISTS brd_open_to_them_srf_fk1 CASCADE;
ALTER TABLE citydb.bridge_open_to_them_srf ADD CONSTRAINT brd_open_to_them_srf_fk1 FOREIGN KEY (bridge_thematic_surface_id)
REFERENCES citydb.bridge_thematic_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_room DROP CONSTRAINT IF EXISTS bridge_room_cityobject_fk CASCADE;
ALTER TABLE citydb.bridge_room ADD CONSTRAINT bridge_room_cityobject_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_room DROP CONSTRAINT IF EXISTS bridge_room_bridge_fk CASCADE;
ALTER TABLE citydb.bridge_room ADD CONSTRAINT bridge_room_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_room DROP CONSTRAINT IF EXISTS bridge_room_lod4msrf_fk CASCADE;
ALTER TABLE citydb.bridge_room ADD CONSTRAINT bridge_room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_room DROP CONSTRAINT IF EXISTS bridge_room_lod4solid_fk CASCADE;
ALTER TABLE citydb.bridge_room ADD CONSTRAINT bridge_room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: "BRIDGE_ROOM_OBJCLASS_FK" | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_room DROP CONSTRAINT IF EXISTS "BRIDGE_ROOM_OBJCLASS_FK" CASCADE;
ALTER TABLE citydb.bridge_room ADD CONSTRAINT "BRIDGE_ROOM_OBJCLASS_FK" FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_cityobj_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_cityobj_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_objclass_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_bridge_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_brd_room_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_brd_room_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES citydb.bridge_room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_brd_inst_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_brd_inst_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_inst_fk FOREIGN KEY (bridge_installation_id)
REFERENCES citydb.bridge_installation (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_brd_const_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_brd_const_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_const_fk FOREIGN KEY (bridge_constr_element_id)
REFERENCES citydb.bridge_constr_element (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_lod2msrf_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_lod3msrf_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_lod4msrf_fk CASCADE;
ALTER TABLE citydb.bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_cityobj_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_cityobj_fk FOREIGN KEY (id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_bridge_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod1brep_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod2brep_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod3brep_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod4brep_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod1impl_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod2impl_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod3impl_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod4impl_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES citydb.implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_objclass_fk CASCADE;
ALTER TABLE citydb.bridge_constr_element ADD CONSTRAINT bridge_constr_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.address_to_bridge DROP CONSTRAINT IF EXISTS address_to_bridge_fk CASCADE;
ALTER TABLE citydb.address_to_bridge ADD CONSTRAINT address_to_bridge_fk FOREIGN KEY (address_id)
REFERENCES citydb.address (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_bridge_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.address_to_bridge DROP CONSTRAINT IF EXISTS address_to_bridge_fk1 CASCADE;
ALTER TABLE citydb.address_to_bridge ADD CONSTRAINT address_to_bridge_fk1 FOREIGN KEY (bridge_id)
REFERENCES citydb.bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: cityobject_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject DROP CONSTRAINT IF EXISTS cityobject_objectclass_fk CASCADE;
ALTER TABLE citydb.cityobject ADD CONSTRAINT cityobject_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: appearance_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.appearance DROP CONSTRAINT IF EXISTS appearance_cityobject_fk CASCADE;
ALTER TABLE citydb.appearance ADD CONSTRAINT appearance_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: appearance_citymodel_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.appearance DROP CONSTRAINT IF EXISTS appearance_citymodel_fk CASCADE;
ALTER TABLE citydb.appearance ADD CONSTRAINT appearance_citymodel_fk FOREIGN KEY (citymodel_id)
REFERENCES citydb.citymodel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: appearance_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.appearance DROP CONSTRAINT IF EXISTS appearance_objclass_fk CASCADE;
ALTER TABLE citydb.appearance ADD CONSTRAINT appearance_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: implicit_geom_brep_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.implicit_geometry DROP CONSTRAINT IF EXISTS implicit_geom_brep_fk CASCADE;
ALTER TABLE citydb.implicit_geometry ADD CONSTRAINT implicit_geom_brep_fk FOREIGN KEY (relative_brep_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: implicit_geom_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.implicit_geometry DROP CONSTRAINT IF EXISTS implicit_geom_objclass_fk CASCADE;
ALTER TABLE citydb.implicit_geometry ADD CONSTRAINT implicit_geom_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_geom_parent_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.surface_geometry DROP CONSTRAINT IF EXISTS surface_geom_parent_fk CASCADE;
ALTER TABLE citydb.surface_geometry ADD CONSTRAINT surface_geom_parent_fk FOREIGN KEY (parent_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_geom_root_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.surface_geometry DROP CONSTRAINT IF EXISTS surface_geom_root_fk CASCADE;
ALTER TABLE citydb.surface_geometry ADD CONSTRAINT surface_geom_root_fk FOREIGN KEY (root_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_geom_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.surface_geometry DROP CONSTRAINT IF EXISTS surface_geom_cityobj_fk CASCADE;
ALTER TABLE citydb.surface_geometry ADD CONSTRAINT surface_geom_cityobj_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.address DROP CONSTRAINT IF EXISTS address_objectclass_fk CASCADE;
ALTER TABLE citydb.address ADD CONSTRAINT address_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_data_tex_image_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.surface_data DROP CONSTRAINT IF EXISTS surface_data_tex_image_fk CASCADE;
ALTER TABLE citydb.surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY (tex_image_id)
REFERENCES citydb.tex_image (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_data_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.surface_data DROP CONSTRAINT IF EXISTS surface_data_objclass_fk CASCADE;
ALTER TABLE citydb.surface_data ADD CONSTRAINT surface_data_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: citymodel_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.citymodel DROP CONSTRAINT IF EXISTS citymodel_objectclass_fk CASCADE;
ALTER TABLE citydb.citymodel ADD CONSTRAINT citymodel_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_parent_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_parent_fk CASCADE;
ALTER TABLE citydb.cityobject_genericattrib ADD CONSTRAINT genericattrib_parent_fk FOREIGN KEY (parent_genattrib_id)
REFERENCES citydb.cityobject_genericattrib (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_root_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_root_fk CASCADE;
ALTER TABLE citydb.cityobject_genericattrib ADD CONSTRAINT genericattrib_root_fk FOREIGN KEY (root_genattrib_id)
REFERENCES citydb.cityobject_genericattrib (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_geom_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_geom_fk CASCADE;
ALTER TABLE citydb.cityobject_genericattrib ADD CONSTRAINT genericattrib_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES citydb.surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_cityobj_fk CASCADE;
ALTER TABLE citydb.cityobject_genericattrib ADD CONSTRAINT genericattrib_cityobj_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: ext_ref_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE citydb.external_reference DROP CONSTRAINT IF EXISTS ext_ref_cityobject_fk CASCADE;
ALTER TABLE citydb.external_reference ADD CONSTRAINT ext_ref_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES citydb.cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_to_objectclass_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.schema_to_objectclass DROP CONSTRAINT IF EXISTS schema_to_objectclass_fk1 CASCADE;
ALTER TABLE citydb.schema_to_objectclass ADD CONSTRAINT schema_to_objectclass_fk1 FOREIGN KEY (schema_id)
REFERENCES citydb.schema (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_to_objectclass_fk2 | type: CONSTRAINT --
-- ALTER TABLE citydb.schema_to_objectclass DROP CONSTRAINT IF EXISTS schema_to_objectclass_fk2 CASCADE;
ALTER TABLE citydb.schema_to_objectclass ADD CONSTRAINT schema_to_objectclass_fk2 FOREIGN KEY (objectclass_id)
REFERENCES citydb.objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_referencing_fk1 | type: CONSTRAINT --
-- ALTER TABLE citydb.schema_referencing DROP CONSTRAINT IF EXISTS schema_referencing_fk1 CASCADE;
ALTER TABLE citydb.schema_referencing ADD CONSTRAINT schema_referencing_fk1 FOREIGN KEY (local_id)
REFERENCES citydb.schema (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_referencing_fk2 | type: CONSTRAINT --
-- ALTER TABLE citydb.schema_referencing DROP CONSTRAINT IF EXISTS schema_referencing_fk2 CASCADE;
ALTER TABLE citydb.schema_referencing ADD CONSTRAINT schema_referencing_fk2 FOREIGN KEY (referencing_id)
REFERENCES citydb.schema (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --