-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
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
-- CREATE SCHEMA citydb;
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

-- object: citymodel_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS citymodel_seq CASCADE;
CREATE SEQUENCE citymodel_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: cityobject_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS cityobject_seq CASCADE;
CREATE SEQUENCE cityobject_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: cityobject_member | type: TABLE --
-- DROP TABLE IF EXISTS cityobject_member CASCADE;
CREATE TABLE cityobject_member(
	citymodel_id bigint NOT NULL,
	cityobject_id bigint NOT NULL,
	CONSTRAINT cityobject_member_pk PRIMARY KEY (citymodel_id,cityobject_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: external_ref_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS external_ref_seq CASCADE;
CREATE SEQUENCE external_ref_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: generalization | type: TABLE --
-- DROP TABLE IF EXISTS generalization CASCADE;
CREATE TABLE generalization(
	cityobject_id bigint NOT NULL,
	generalizes_to_id bigint NOT NULL,
	CONSTRAINT generalization_pk PRIMARY KEY (cityobject_id,generalizes_to_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: surface_geometry_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS surface_geometry_seq CASCADE;
CREATE SEQUENCE surface_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: cityobjectgroup | type: TABLE --
-- DROP TABLE IF EXISTS cityobjectgroup CASCADE;
CREATE TABLE cityobjectgroup(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	brep_id bigint,
	other_geom geometry(GEOMETRYZ),
	parent_cityobject_id bigint,
	CONSTRAINT cityobjectgroup_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: group_to_cityobject | type: TABLE --
-- DROP TABLE IF EXISTS group_to_cityobject CASCADE;
CREATE TABLE group_to_cityobject(
	cityobject_id bigint NOT NULL,
	cityobjectgroup_id bigint NOT NULL,
	role character varying(256),
	CONSTRAINT group_to_cityobject_pk PRIMARY KEY (cityobject_id,cityobjectgroup_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: database_srs | type: TABLE --
-- DROP TABLE IF EXISTS database_srs CASCADE;
CREATE TABLE database_srs(
	srid integer NOT NULL,
	gml_srs_name character varying(1000),
	CONSTRAINT database_srs_pk PRIMARY KEY (srid)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: objectclass | type: TABLE --
-- DROP TABLE IF EXISTS objectclass CASCADE;
CREATE TABLE objectclass(
	id integer NOT NULL,
	is_ade_class numeric,
	is_toplevel numeric,
	classname character varying(256),
	tablename character varying(30),
	superclass_id integer,
	baseclass_id integer,
	ade_id integer,
	CONSTRAINT objectclass_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: implicit_geometry_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS implicit_geometry_seq CASCADE;
CREATE SEQUENCE implicit_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: city_furniture | type: TABLE --
-- DROP TABLE IF EXISTS city_furniture CASCADE;
CREATE TABLE city_furniture(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
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
	lod1_brep_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod1_implicit_rep_id bigint,
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: cityobject_genericatt_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS cityobject_genericatt_seq CASCADE;
CREATE SEQUENCE cityobject_genericatt_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: generic_cityobject | type: TABLE --
-- DROP TABLE IF EXISTS generic_cityobject CASCADE;
CREATE TABLE generic_cityobject(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
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
	lod0_brep_id bigint,
	lod1_brep_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod0_other_geom geometry(GEOMETRYZ),
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod0_implicit_rep_id bigint,
	lod1_implicit_rep_id bigint,
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: address_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS address_seq CASCADE;
CREATE SEQUENCE address_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: address_to_building | type: TABLE --
-- DROP TABLE IF EXISTS address_to_building CASCADE;
CREATE TABLE address_to_building(
	building_id bigint NOT NULL,
	address_id bigint NOT NULL,
	CONSTRAINT address_to_building_pk PRIMARY KEY (building_id,address_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: building | type: TABLE --
-- DROP TABLE IF EXISTS building CASCADE;
CREATE TABLE building(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	building_parent_id bigint,
	building_root_id bigint,
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
	lod0_footprint_id bigint,
	lod0_roofprint_id bigint,
	lod1_multi_surface_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod1_solid_id bigint,
	lod2_solid_id bigint,
	lod3_solid_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT building_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: building_furniture | type: TABLE --
-- DROP TABLE IF EXISTS building_furniture CASCADE;
CREATE TABLE building_furniture(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	room_id bigint,
	lod4_brep_id bigint,
	lod4_other_geom geometry(GEOMETRYZ),
	lod4_implicit_rep_id bigint,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT building_furniture_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: building_installation | type: TABLE --
-- DROP TABLE IF EXISTS building_installation CASCADE;
CREATE TABLE building_installation(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	building_id bigint,
	room_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: opening | type: TABLE --
-- DROP TABLE IF EXISTS opening CASCADE;
CREATE TABLE opening(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	address_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT opening_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: opening_to_them_surface | type: TABLE --
-- DROP TABLE IF EXISTS opening_to_them_surface CASCADE;
CREATE TABLE opening_to_them_surface(
	opening_id bigint NOT NULL,
	thematic_surface_id bigint NOT NULL,
	CONSTRAINT opening_to_them_surface_pk PRIMARY KEY (opening_id,thematic_surface_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: room | type: TABLE --
-- DROP TABLE IF EXISTS room CASCADE;
CREATE TABLE room(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	building_id bigint,
	lod4_multi_surface_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT room_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: thematic_surface | type: TABLE --
-- DROP TABLE IF EXISTS thematic_surface CASCADE;
CREATE TABLE thematic_surface(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	building_id bigint,
	room_id bigint,
	building_installation_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	CONSTRAINT thematic_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: appearance_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS appearance_seq CASCADE;
CREATE SEQUENCE appearance_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: surface_data_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS surface_data_seq CASCADE;
CREATE SEQUENCE surface_data_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: textureparam | type: TABLE --
-- DROP TABLE IF EXISTS textureparam CASCADE;
CREATE TABLE textureparam(
	surface_geometry_id bigint NOT NULL,
	is_texture_parametrization numeric,
	world_to_texture character varying(1000),
	texture_coordinates geometry(POLYGON),
	surface_data_id bigint NOT NULL,
	CONSTRAINT textureparam_pk PRIMARY KEY (surface_geometry_id,surface_data_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: appear_to_surface_data | type: TABLE --
-- DROP TABLE IF EXISTS appear_to_surface_data CASCADE;
CREATE TABLE appear_to_surface_data(
	surface_data_id bigint NOT NULL,
	appearance_id bigint NOT NULL,
	CONSTRAINT appear_to_surface_data_pk PRIMARY KEY (surface_data_id,appearance_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: breakline_relief | type: TABLE --
-- DROP TABLE IF EXISTS breakline_relief CASCADE;
CREATE TABLE breakline_relief(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	ridge_or_valley_lines geometry(MULTILINESTRINGZ),
	break_lines geometry(MULTILINESTRINGZ),
	CONSTRAINT breakline_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: masspoint_relief | type: TABLE --
-- DROP TABLE IF EXISTS masspoint_relief CASCADE;
CREATE TABLE masspoint_relief(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	relief_points geometry(MULTIPOINTZ),
	CONSTRAINT masspoint_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: relief_component | type: TABLE --
-- DROP TABLE IF EXISTS relief_component CASCADE;
CREATE TABLE relief_component(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	lod numeric,
	extent geometry(POLYGON),
	CONSTRAINT relief_component_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100),
	CONSTRAINT relief_comp_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)))

);
-- ddl-end --

-- object: relief_feat_to_rel_comp | type: TABLE --
-- DROP TABLE IF EXISTS relief_feat_to_rel_comp CASCADE;
CREATE TABLE relief_feat_to_rel_comp(
	relief_component_id bigint NOT NULL,
	relief_feature_id bigint NOT NULL,
	CONSTRAINT relief_feat_to_rel_comp_pk PRIMARY KEY (relief_component_id,relief_feature_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: relief_feature | type: TABLE --
-- DROP TABLE IF EXISTS relief_feature CASCADE;
CREATE TABLE relief_feature(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	lod numeric,
	CONSTRAINT relief_feature_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100),
	CONSTRAINT relief_feat_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)))

);
-- ddl-end --

-- object: tin_relief | type: TABLE --
-- DROP TABLE IF EXISTS tin_relief CASCADE;
CREATE TABLE tin_relief(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	max_length double precision,
	max_length_unit character varying(4000),
	stop_lines geometry(MULTILINESTRINGZ),
	break_lines geometry(MULTILINESTRINGZ),
	control_points geometry(MULTIPOINTZ),
	surface_geometry_id bigint,
	CONSTRAINT tin_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: transportation_complex | type: TABLE --
-- DROP TABLE IF EXISTS transportation_complex CASCADE;
CREATE TABLE transportation_complex(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_network geometry(GEOMETRYZ),
	lod1_multi_surface_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	CONSTRAINT transportation_complex_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: traffic_area | type: TABLE --
-- DROP TABLE IF EXISTS traffic_area CASCADE;
CREATE TABLE traffic_area(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	surface_material character varying(256),
	surface_material_codespace character varying(4000),
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	transportation_complex_id bigint,
	CONSTRAINT traffic_area_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: land_use | type: TABLE --
-- DROP TABLE IF EXISTS land_use CASCADE;
CREATE TABLE land_use(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_multi_surface_id bigint,
	lod1_multi_surface_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	CONSTRAINT land_use_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: plant_cover | type: TABLE --
-- DROP TABLE IF EXISTS plant_cover CASCADE;
CREATE TABLE plant_cover(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	average_height double precision,
	average_height_unit character varying(4000),
	lod1_multi_surface_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod1_multi_solid_id bigint,
	lod2_multi_solid_id bigint,
	lod3_multi_solid_id bigint,
	lod4_multi_solid_id bigint,
	CONSTRAINT plant_cover_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: solitary_vegetat_object | type: TABLE --
-- DROP TABLE IF EXISTS solitary_vegetat_object CASCADE;
CREATE TABLE solitary_vegetat_object(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
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
	lod1_brep_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod1_implicit_rep_id bigint,
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: waterbody | type: TABLE --
-- DROP TABLE IF EXISTS waterbody CASCADE;
CREATE TABLE waterbody(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	lod0_multi_curve geometry(MULTILINESTRINGZ),
	lod1_multi_curve geometry(MULTILINESTRINGZ),
	lod0_multi_surface_id bigint,
	lod1_multi_surface_id bigint,
	lod1_solid_id bigint,
	lod2_solid_id bigint,
	lod3_solid_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT waterbody_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: waterbod_to_waterbnd_srf | type: TABLE --
-- DROP TABLE IF EXISTS waterbod_to_waterbnd_srf CASCADE;
CREATE TABLE waterbod_to_waterbnd_srf(
	waterboundary_surface_id bigint NOT NULL,
	waterbody_id bigint NOT NULL,
	CONSTRAINT waterbod_to_waterbnd_pk PRIMARY KEY (waterboundary_surface_id,waterbody_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: waterboundary_surface | type: TABLE --
-- DROP TABLE IF EXISTS waterboundary_surface CASCADE;
CREATE TABLE waterboundary_surface(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	water_level character varying(256),
	water_level_codespace character varying(4000),
	lod2_surface_id bigint,
	lod3_surface_id bigint,
	lod4_surface_id bigint,
	CONSTRAINT waterboundary_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: raster_relief | type: TABLE --
-- DROP TABLE IF EXISTS raster_relief CASCADE;
CREATE TABLE raster_relief(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	raster_uri character varying(4000),
	coverage_id bigint,
	CONSTRAINT raster_relief_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tunnel | type: TABLE --
-- DROP TABLE IF EXISTS tunnel CASCADE;
CREATE TABLE tunnel(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	tunnel_parent_id bigint,
	tunnel_root_id bigint,
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
	lod1_multi_surface_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod1_solid_id bigint,
	lod2_solid_id bigint,
	lod3_solid_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT tunnel_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tunnel_open_to_them_srf | type: TABLE --
-- DROP TABLE IF EXISTS tunnel_open_to_them_srf CASCADE;
CREATE TABLE tunnel_open_to_them_srf(
	tunnel_opening_id bigint NOT NULL,
	tunnel_thematic_surface_id bigint NOT NULL,
	CONSTRAINT tunnel_open_to_them_srf_pk PRIMARY KEY (tunnel_opening_id,tunnel_thematic_surface_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tunnel_hollow_space | type: TABLE --
-- DROP TABLE IF EXISTS tunnel_hollow_space CASCADE;
CREATE TABLE tunnel_hollow_space(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_id bigint,
	lod4_multi_surface_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT tunnel_hollow_space_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tunnel_thematic_surface | type: TABLE --
-- DROP TABLE IF EXISTS tunnel_thematic_surface CASCADE;
CREATE TABLE tunnel_thematic_surface(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	tunnel_id bigint,
	tunnel_hollow_space_id bigint,
	tunnel_installation_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	CONSTRAINT tunnel_thematic_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tex_image_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tex_image_seq CASCADE;
CREATE SEQUENCE tex_image_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: tunnel_opening | type: TABLE --
-- DROP TABLE IF EXISTS tunnel_opening CASCADE;
CREATE TABLE tunnel_opening(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_opening_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tunnel_installation | type: TABLE --
-- DROP TABLE IF EXISTS tunnel_installation CASCADE;
CREATE TABLE tunnel_installation(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_id bigint,
	tunnel_hollow_space_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: tunnel_furniture | type: TABLE --
-- DROP TABLE IF EXISTS tunnel_furniture CASCADE;
CREATE TABLE tunnel_furniture(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	tunnel_hollow_space_id bigint,
	lod4_brep_id bigint,
	lod4_other_geom geometry(GEOMETRYZ),
	lod4_implicit_rep_id bigint,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT tunnel_furniture_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge | type: TABLE --
-- DROP TABLE IF EXISTS bridge CASCADE;
CREATE TABLE bridge(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	bridge_parent_id bigint,
	bridge_root_id bigint,
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
	lod1_multi_surface_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod1_solid_id bigint,
	lod2_solid_id bigint,
	lod3_solid_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT bridge_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge_furniture | type: TABLE --
-- DROP TABLE IF EXISTS bridge_furniture CASCADE;
CREATE TABLE bridge_furniture(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_room_id bigint,
	lod4_brep_id bigint,
	lod4_other_geom geometry(GEOMETRYZ),
	lod4_implicit_rep_id bigint,
	lod4_implicit_ref_point geometry(POINTZ),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_furniture_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge_installation | type: TABLE --
-- DROP TABLE IF EXISTS bridge_installation CASCADE;
CREATE TABLE bridge_installation(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id bigint,
	bridge_room_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: bridge_opening | type: TABLE --
-- DROP TABLE IF EXISTS bridge_opening CASCADE;
CREATE TABLE bridge_opening(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	address_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
	lod3_implicit_ref_point geometry(POINTZ),
	lod4_implicit_ref_point geometry(POINTZ),
	lod3_implicit_transformation character varying(1000),
	lod4_implicit_transformation character varying(1000),
	CONSTRAINT bridge_opening_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge_open_to_them_srf | type: TABLE --
-- DROP TABLE IF EXISTS bridge_open_to_them_srf CASCADE;
CREATE TABLE bridge_open_to_them_srf(
	bridge_opening_id bigint NOT NULL,
	bridge_thematic_surface_id bigint NOT NULL,
	CONSTRAINT bridge_open_to_them_srf_pk PRIMARY KEY (bridge_opening_id,bridge_thematic_surface_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge_room | type: TABLE --
-- DROP TABLE IF EXISTS bridge_room CASCADE;
CREATE TABLE bridge_room(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id bigint,
	lod4_multi_surface_id bigint,
	lod4_solid_id bigint,
	CONSTRAINT bridge_room_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge_thematic_surface | type: TABLE --
-- DROP TABLE IF EXISTS bridge_thematic_surface CASCADE;
CREATE TABLE bridge_thematic_surface(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	bridge_id bigint,
	bridge_room_id bigint,
	bridge_installation_id bigint,
	bridge_constr_element_id bigint,
	lod2_multi_surface_id bigint,
	lod3_multi_surface_id bigint,
	lod4_multi_surface_id bigint,
	CONSTRAINT bridge_thematic_surface_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: bridge_constr_element | type: TABLE --
-- DROP TABLE IF EXISTS bridge_constr_element CASCADE;
CREATE TABLE bridge_constr_element(
	id bigint NOT NULL,
	objectclass_id integer NOT NULL,
	class character varying(256),
	class_codespace character varying(4000),
	function character varying(1000),
	function_codespace character varying(4000),
	usage character varying(1000),
	usage_codespace character varying(4000),
	bridge_id bigint,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ),
	lod1_brep_id bigint,
	lod2_brep_id bigint,
	lod3_brep_id bigint,
	lod4_brep_id bigint,
	lod1_other_geom geometry(GEOMETRYZ),
	lod2_other_geom geometry(GEOMETRYZ),
	lod3_other_geom geometry(GEOMETRYZ),
	lod4_other_geom geometry(GEOMETRYZ),
	lod1_implicit_rep_id bigint,
	lod2_implicit_rep_id bigint,
	lod3_implicit_rep_id bigint,
	lod4_implicit_rep_id bigint,
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

-- object: address_to_bridge | type: TABLE --
-- DROP TABLE IF EXISTS address_to_bridge CASCADE;
CREATE TABLE address_to_bridge(
	bridge_id bigint NOT NULL,
	address_id bigint NOT NULL,
	CONSTRAINT address_to_bridge_pk PRIMARY KEY (bridge_id,address_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: grid_coverage_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS grid_coverage_seq CASCADE;
CREATE SEQUENCE grid_coverage_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: cityobject | type: TABLE --
-- DROP TABLE IF EXISTS cityobject CASCADE;
CREATE TABLE cityobject(
	id bigint NOT NULL DEFAULT nextval('cityobject_seq'::regclass),
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

-- object: appearance | type: TABLE --
-- DROP TABLE IF EXISTS appearance CASCADE;
CREATE TABLE appearance(
	id bigint NOT NULL DEFAULT nextval('appearance_seq'::regclass),
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	theme character varying(256),
	citymodel_id bigint,
	cityobject_id bigint,
	CONSTRAINT appearance_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: implicit_geometry | type: TABLE --
-- DROP TABLE IF EXISTS implicit_geometry CASCADE;
CREATE TABLE implicit_geometry(
	id bigint NOT NULL DEFAULT nextval('implicit_geometry_seq'::regclass),
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	mime_type character varying(256),
	reference_to_library character varying(4000),
	library_object bytea,
	relative_brep_id bigint,
	relative_other_geom geometry(GEOMETRYZ),
	CONSTRAINT implicit_geometry_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: surface_geometry | type: TABLE --
-- DROP TABLE IF EXISTS surface_geometry CASCADE;
CREATE TABLE surface_geometry(
	id bigint NOT NULL DEFAULT nextval('surface_geometry_seq'::regclass),
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	parent_id bigint,
	root_id bigint,
	is_solid numeric,
	is_composite numeric,
	is_triangulated numeric,
	is_xlink numeric,
	is_reverse numeric,
	solid_geometry geometry(POLYHEDRALSURFACEZ),
	geometry geometry(POLYGONZ),
	implicit_geometry geometry(POLYGONZ),
	cityobject_id bigint,
	CONSTRAINT surface_geometry_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: address | type: TABLE --
-- DROP TABLE IF EXISTS address CASCADE;
CREATE TABLE address(
	id bigint NOT NULL DEFAULT nextval('address_seq'::regclass),
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

-- object: surface_data | type: TABLE --
-- DROP TABLE IF EXISTS surface_data CASCADE;
CREATE TABLE surface_data(
	id bigint NOT NULL DEFAULT nextval('surface_data_seq'::regclass),
	gmlid character varying(256),
	gmlid_codespace varchar(1000),
	name character varying(1000),
	name_codespace character varying(4000),
	description character varying(4000),
	is_front numeric,
	objectclass_id integer NOT NULL,
	x3d_shininess double precision,
	x3d_transparency double precision,
	x3d_ambient_intensity double precision,
	x3d_specular_color character varying(256),
	x3d_diffuse_color character varying(256),
	x3d_emissive_color character varying(256),
	x3d_is_smooth numeric,
	tex_image_id bigint,
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

-- object: citymodel | type: TABLE --
-- DROP TABLE IF EXISTS citymodel CASCADE;
CREATE TABLE citymodel(
	id bigint NOT NULL DEFAULT nextval('citymodel_seq'::regclass),
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

-- object: cityobject_genericattrib | type: TABLE --
-- DROP TABLE IF EXISTS cityobject_genericattrib CASCADE;
CREATE TABLE cityobject_genericattrib(
	id bigint NOT NULL DEFAULT nextval('cityobject_genericatt_seq'::regclass),
	parent_genattrib_id bigint,
	root_genattrib_id bigint,
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
	surface_geometry_id bigint,
	cityobject_id bigint,
	CONSTRAINT cityobj_genericattrib_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: external_reference | type: TABLE --
-- DROP TABLE IF EXISTS external_reference CASCADE;
CREATE TABLE external_reference(
	id bigint NOT NULL DEFAULT nextval('external_ref_seq'::regclass),
	infosys character varying(4000),
	name character varying(4000),
	uri character varying(4000),
	cityobject_id bigint,
	CONSTRAINT external_reference_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: tex_image | type: TABLE --
-- DROP TABLE IF EXISTS tex_image CASCADE;
CREATE TABLE tex_image(
	id bigint NOT NULL DEFAULT nextval('tex_image_seq'::regclass),
	tex_image_uri character varying(4000),
	tex_image_data bytea,
	tex_mime_type character varying(256),
	tex_mime_type_codespace character varying(4000),
	CONSTRAINT tex_image_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: grid_coverage | type: TABLE --
-- DROP TABLE IF EXISTS grid_coverage CASCADE;
CREATE TABLE grid_coverage(
	id bigint NOT NULL DEFAULT nextval('grid_coverage_seq'::regclass),
	rasterproperty raster,
	CONSTRAINT grid_coverage_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: schema_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS schema_seq CASCADE;
CREATE SEQUENCE schema_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: ade_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS ade_seq CASCADE;
CREATE SEQUENCE ade_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: cityobject_member_fkx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_member_fkx CASCADE;
CREATE INDEX cityobject_member_fkx ON cityobject_member
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_member_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_member_fkx1 CASCADE;
CREATE INDEX cityobject_member_fkx1 ON cityobject_member
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: general_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS general_cityobject_fkx CASCADE;
CREATE INDEX general_cityobject_fkx ON generalization
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: general_generalizes_to_fkx | type: INDEX --
-- DROP INDEX IF EXISTS general_generalizes_to_fkx CASCADE;
CREATE INDEX general_generalizes_to_fkx ON generalization
	USING btree
	(
	  generalizes_to_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_brep_fkx CASCADE;
CREATE INDEX group_brep_fkx ON cityobjectgroup
	USING btree
	(
	  brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS group_xgeom_spx CASCADE;
CREATE INDEX group_xgeom_spx ON cityobjectgroup
	USING gist
	(
	  other_geom
	);
-- ddl-end --

-- object: group_parent_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_parent_cityobj_fkx CASCADE;
CREATE INDEX group_parent_cityobj_fkx ON cityobjectgroup
	USING btree
	(
	  parent_cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_to_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_to_cityobject_fkx CASCADE;
CREATE INDEX group_to_cityobject_fkx ON group_to_cityobject
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_to_cityobject_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS group_to_cityobject_fkx1 CASCADE;
CREATE INDEX group_to_cityobject_fkx1 ON group_to_cityobject
	USING btree
	(
	  cityobjectgroup_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: objectclass_superclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS objectclass_superclass_fkx CASCADE;
CREATE INDEX objectclass_superclass_fkx ON objectclass
	USING btree
	(
	  superclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1terr_spx CASCADE;
CREATE INDEX city_furn_lod1terr_spx ON city_furniture
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2terr_spx CASCADE;
CREATE INDEX city_furn_lod2terr_spx ON city_furniture
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3terr_spx CASCADE;
CREATE INDEX city_furn_lod3terr_spx ON city_furniture
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4terr_spx CASCADE;
CREATE INDEX city_furn_lod4terr_spx ON city_furniture
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: city_furn_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1brep_fkx CASCADE;
CREATE INDEX city_furn_lod1brep_fkx ON city_furniture
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2brep_fkx CASCADE;
CREATE INDEX city_furn_lod2brep_fkx ON city_furniture
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3brep_fkx CASCADE;
CREATE INDEX city_furn_lod3brep_fkx ON city_furniture
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4brep_fkx CASCADE;
CREATE INDEX city_furn_lod4brep_fkx ON city_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1xgeom_spx CASCADE;
CREATE INDEX city_furn_lod1xgeom_spx ON city_furniture
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: city_furn_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2xgeom_spx CASCADE;
CREATE INDEX city_furn_lod2xgeom_spx ON city_furniture
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: city_furn_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3xgeom_spx CASCADE;
CREATE INDEX city_furn_lod3xgeom_spx ON city_furniture
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: city_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4xgeom_spx CASCADE;
CREATE INDEX city_furn_lod4xgeom_spx ON city_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: city_furn_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1impl_fkx CASCADE;
CREATE INDEX city_furn_lod1impl_fkx ON city_furniture
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2impl_fkx CASCADE;
CREATE INDEX city_furn_lod2impl_fkx ON city_furniture
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3impl_fkx CASCADE;
CREATE INDEX city_furn_lod3impl_fkx ON city_furniture
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4impl_fkx CASCADE;
CREATE INDEX city_furn_lod4impl_fkx ON city_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_lod1refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1refpnt_spx CASCADE;
CREATE INDEX city_furn_lod1refpnt_spx ON city_furniture
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod2refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2refpnt_spx CASCADE;
CREATE INDEX city_furn_lod2refpnt_spx ON city_furniture
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod3refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3refpnt_spx CASCADE;
CREATE INDEX city_furn_lod3refpnt_spx ON city_furniture
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: city_furn_lod4refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4refpnt_spx CASCADE;
CREATE INDEX city_furn_lod4refpnt_spx ON city_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod0terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0terr_spx CASCADE;
CREATE INDEX gen_object_lod0terr_spx ON generic_cityobject
	USING gist
	(
	  lod0_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1terr_spx CASCADE;
CREATE INDEX gen_object_lod1terr_spx ON generic_cityobject
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2terr_spx CASCADE;
CREATE INDEX gen_object_lod2terr_spx ON generic_cityobject
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3terr_spx CASCADE;
CREATE INDEX gen_object_lod3terr_spx ON generic_cityobject
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4terr_spx CASCADE;
CREATE INDEX gen_object_lod4terr_spx ON generic_cityobject
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: gen_object_lod0brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0brep_fkx CASCADE;
CREATE INDEX gen_object_lod0brep_fkx ON generic_cityobject
	USING btree
	(
	  lod0_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1brep_fkx CASCADE;
CREATE INDEX gen_object_lod1brep_fkx ON generic_cityobject
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2brep_fkx CASCADE;
CREATE INDEX gen_object_lod2brep_fkx ON generic_cityobject
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3brep_fkx CASCADE;
CREATE INDEX gen_object_lod3brep_fkx ON generic_cityobject
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4brep_fkx CASCADE;
CREATE INDEX gen_object_lod4brep_fkx ON generic_cityobject
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod0xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0xgeom_spx CASCADE;
CREATE INDEX gen_object_lod0xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod0_other_geom
	);
-- ddl-end --

-- object: gen_object_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1xgeom_spx CASCADE;
CREATE INDEX gen_object_lod1xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: gen_object_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2xgeom_spx CASCADE;
CREATE INDEX gen_object_lod2xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: gen_object_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3xgeom_spx CASCADE;
CREATE INDEX gen_object_lod3xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: gen_object_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4xgeom_spx CASCADE;
CREATE INDEX gen_object_lod4xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: gen_object_lod0impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0impl_fkx CASCADE;
CREATE INDEX gen_object_lod0impl_fkx ON generic_cityobject
	USING btree
	(
	  lod0_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1impl_fkx CASCADE;
CREATE INDEX gen_object_lod1impl_fkx ON generic_cityobject
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2impl_fkx CASCADE;
CREATE INDEX gen_object_lod2impl_fkx ON generic_cityobject
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3impl_fkx CASCADE;
CREATE INDEX gen_object_lod3impl_fkx ON generic_cityobject
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4impl_fkx CASCADE;
CREATE INDEX gen_object_lod4impl_fkx ON generic_cityobject
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_lod0refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0refpnt_spx CASCADE;
CREATE INDEX gen_object_lod0refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod0_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod1refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1refpnt_spx CASCADE;
CREATE INDEX gen_object_lod1refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod2refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2refpnt_spx CASCADE;
CREATE INDEX gen_object_lod2refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod3refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3refpnt_spx CASCADE;
CREATE INDEX gen_object_lod3refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: gen_object_lod4refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4refpnt_spx CASCADE;
CREATE INDEX gen_object_lod4refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: address_to_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS address_to_building_fkx CASCADE;
CREATE INDEX address_to_building_fkx ON address_to_building
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: address_to_building_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS address_to_building_fkx1 CASCADE;
CREATE INDEX address_to_building_fkx1 ON address_to_building
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_parent_fkx CASCADE;
CREATE INDEX building_parent_fkx ON building
	USING btree
	(
	  building_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_root_fkx CASCADE;
CREATE INDEX building_root_fkx ON building
	USING btree
	(
	  building_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod1terr_spx CASCADE;
CREATE INDEX building_lod1terr_spx ON building
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: building_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2terr_spx CASCADE;
CREATE INDEX building_lod2terr_spx ON building
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: building_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3terr_spx CASCADE;
CREATE INDEX building_lod3terr_spx ON building
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: building_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4terr_spx CASCADE;
CREATE INDEX building_lod4terr_spx ON building
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: building_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2curve_spx CASCADE;
CREATE INDEX building_lod2curve_spx ON building
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: building_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3curve_spx CASCADE;
CREATE INDEX building_lod3curve_spx ON building
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: building_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4curve_spx CASCADE;
CREATE INDEX building_lod4curve_spx ON building
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: building_lod0footprint_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod0footprint_fkx CASCADE;
CREATE INDEX building_lod0footprint_fkx ON building
	USING btree
	(
	  lod0_footprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod0roofprint_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod0roofprint_fkx CASCADE;
CREATE INDEX building_lod0roofprint_fkx ON building
	USING btree
	(
	  lod0_roofprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod1msrf_fkx CASCADE;
CREATE INDEX building_lod1msrf_fkx ON building
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2msrf_fkx CASCADE;
CREATE INDEX building_lod2msrf_fkx ON building
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3msrf_fkx CASCADE;
CREATE INDEX building_lod3msrf_fkx ON building
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4msrf_fkx CASCADE;
CREATE INDEX building_lod4msrf_fkx ON building
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod1solid_fkx CASCADE;
CREATE INDEX building_lod1solid_fkx ON building
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2solid_fkx CASCADE;
CREATE INDEX building_lod2solid_fkx ON building
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3solid_fkx CASCADE;
CREATE INDEX building_lod3solid_fkx ON building
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4solid_fkx CASCADE;
CREATE INDEX building_lod4solid_fkx ON building
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_room_fkx CASCADE;
CREATE INDEX bldg_furn_room_fkx ON building_furniture
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4brep_fkx CASCADE;
CREATE INDEX bldg_furn_lod4brep_fkx ON building_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4xgeom_spx CASCADE;
CREATE INDEX bldg_furn_lod4xgeom_spx ON building_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bldg_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4impl_fkx CASCADE;
CREATE INDEX bldg_furn_lod4impl_fkx ON building_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4refpt_spx CASCADE;
CREATE INDEX bldg_furn_lod4refpt_spx ON building_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_objclass_fkx CASCADE;
CREATE INDEX bldg_inst_objclass_fkx ON building_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: bldg_inst_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_building_fkx CASCADE;
CREATE INDEX bldg_inst_building_fkx ON building_installation
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_room_fkx CASCADE;
CREATE INDEX bldg_inst_room_fkx ON building_installation
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod2brep_fkx ON building_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod3brep_fkx ON building_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod4brep_fkx ON building_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod2xgeom_spx ON building_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod3xgeom_spx ON building_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod4xgeom_spx ON building_installation
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bldg_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod2impl_fkx ON building_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod3impl_fkx ON building_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod4impl_fkx ON building_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod2refpt_spx ON building_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod3refpt_spx ON building_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bldg_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod4refpt_spx ON building_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: opening_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_objectclass_fkx CASCADE;
CREATE INDEX opening_objectclass_fkx ON opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_address_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_address_fkx CASCADE;
CREATE INDEX opening_address_fkx ON opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod3msrf_fkx CASCADE;
CREATE INDEX opening_lod3msrf_fkx ON opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod4msrf_fkx CASCADE;
CREATE INDEX opening_lod4msrf_fkx ON opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod3impl_fkx CASCADE;
CREATE INDEX opening_lod3impl_fkx ON opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod4impl_fkx CASCADE;
CREATE INDEX opening_lod4impl_fkx ON opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: opening_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod3refpt_spx CASCADE;
CREATE INDEX opening_lod3refpt_spx ON opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: opening_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod4refpt_spx CASCADE;
CREATE INDEX opening_lod4refpt_spx ON opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: open_to_them_surface_fkx | type: INDEX --
-- DROP INDEX IF EXISTS open_to_them_surface_fkx CASCADE;
CREATE INDEX open_to_them_surface_fkx ON opening_to_them_surface
	USING btree
	(
	  opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: open_to_them_surface_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS open_to_them_surface_fkx1 CASCADE;
CREATE INDEX open_to_them_surface_fkx1 ON opening_to_them_surface
	USING btree
	(
	  thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_building_fkx CASCADE;
CREATE INDEX room_building_fkx ON room
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_lod4msrf_fkx CASCADE;
CREATE INDEX room_lod4msrf_fkx ON room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_lod4solid_fkx CASCADE;
CREATE INDEX room_lod4solid_fkx ON room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_objclass_fkx CASCADE;
CREATE INDEX them_surface_objclass_fkx ON thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_building_fkx CASCADE;
CREATE INDEX them_surface_building_fkx ON thematic_surface
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_room_fkx CASCADE;
CREATE INDEX them_surface_room_fkx ON thematic_surface
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_bldg_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_bldg_inst_fkx CASCADE;
CREATE INDEX them_surface_bldg_inst_fkx ON thematic_surface
	USING btree
	(
	  building_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_lod2msrf_fkx CASCADE;
CREATE INDEX them_surface_lod2msrf_fkx ON thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_lod3msrf_fkx CASCADE;
CREATE INDEX them_surface_lod3msrf_fkx ON thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: them_surface_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_lod4msrf_fkx CASCADE;
CREATE INDEX them_surface_lod4msrf_fkx ON thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: texparam_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS texparam_geom_fkx CASCADE;
CREATE INDEX texparam_geom_fkx ON textureparam
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: texparam_surface_data_fkx | type: INDEX --
-- DROP INDEX IF EXISTS texparam_surface_data_fkx CASCADE;
CREATE INDEX texparam_surface_data_fkx ON textureparam
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: app_to_surf_data_fkx | type: INDEX --
-- DROP INDEX IF EXISTS app_to_surf_data_fkx CASCADE;
CREATE INDEX app_to_surf_data_fkx ON appear_to_surface_data
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: app_to_surf_data_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS app_to_surf_data_fkx1 CASCADE;
CREATE INDEX app_to_surf_data_fkx1 ON appear_to_surface_data
	USING btree
	(
	  appearance_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: breakline_ridge_spx | type: INDEX --
-- DROP INDEX IF EXISTS breakline_ridge_spx CASCADE;
CREATE INDEX breakline_ridge_spx ON breakline_relief
	USING gist
	(
	  ridge_or_valley_lines
	);
-- ddl-end --

-- object: breakline_break_spx | type: INDEX --
-- DROP INDEX IF EXISTS breakline_break_spx CASCADE;
CREATE INDEX breakline_break_spx ON breakline_relief
	USING gist
	(
	  break_lines
	);
-- ddl-end --

-- object: masspoint_relief_spx | type: INDEX --
-- DROP INDEX IF EXISTS masspoint_relief_spx CASCADE;
CREATE INDEX masspoint_relief_spx ON masspoint_relief
	USING gist
	(
	  relief_points
	);
-- ddl-end --

-- object: relief_comp_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS relief_comp_objclass_fkx CASCADE;
CREATE INDEX relief_comp_objclass_fkx ON relief_component
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: relief_comp_extent_spx | type: INDEX --
-- DROP INDEX IF EXISTS relief_comp_extent_spx CASCADE;
CREATE INDEX relief_comp_extent_spx ON relief_component
	USING gist
	(
	  extent
	);
-- ddl-end --

-- object: rel_feat_to_rel_comp_fkx | type: INDEX --
-- DROP INDEX IF EXISTS rel_feat_to_rel_comp_fkx CASCADE;
CREATE INDEX rel_feat_to_rel_comp_fkx ON relief_feat_to_rel_comp
	USING btree
	(
	  relief_component_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: rel_feat_to_rel_comp_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS rel_feat_to_rel_comp_fkx1 CASCADE;
CREATE INDEX rel_feat_to_rel_comp_fkx1 ON relief_feat_to_rel_comp
	USING btree
	(
	  relief_feature_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_geom_fkx CASCADE;
CREATE INDEX tin_relief_geom_fkx ON tin_relief
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_stop_spx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_stop_spx CASCADE;
CREATE INDEX tin_relief_stop_spx ON tin_relief
	USING gist
	(
	  stop_lines
	);
-- ddl-end --

-- object: tin_relief_break_spx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_break_spx CASCADE;
CREATE INDEX tin_relief_break_spx ON tin_relief
	USING gist
	(
	  break_lines
	);
-- ddl-end --

-- object: tin_relief_crtlpts_spx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_crtlpts_spx CASCADE;
CREATE INDEX tin_relief_crtlpts_spx ON tin_relief
	USING gist
	(
	  control_points
	);
-- ddl-end --

-- object: tran_complex_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_objclass_fkx CASCADE;
CREATE INDEX tran_complex_objclass_fkx ON transportation_complex
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod0net_spx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod0net_spx CASCADE;
CREATE INDEX tran_complex_lod0net_spx ON transportation_complex
	USING gist
	(
	  lod0_network
	);
-- ddl-end --

-- object: tran_complex_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod1msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod1msrf_fkx ON transportation_complex
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod2msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod2msrf_fkx ON transportation_complex
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod3msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod3msrf_fkx ON transportation_complex
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tran_complex_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod4msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod4msrf_fkx ON transportation_complex
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_objclass_fkx CASCADE;
CREATE INDEX traffic_area_objclass_fkx ON traffic_area
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: traffic_area_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_lod2msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod2msrf_fkx ON traffic_area
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_lod3msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod3msrf_fkx ON traffic_area
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_lod4msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod4msrf_fkx ON traffic_area
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: traffic_area_trancmplx_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_trancmplx_fkx CASCADE;
CREATE INDEX traffic_area_trancmplx_fkx ON traffic_area
	USING btree
	(
	  transportation_complex_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod0msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod0msrf_fkx CASCADE;
CREATE INDEX land_use_lod0msrf_fkx ON land_use
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod1msrf_fkx CASCADE;
CREATE INDEX land_use_lod1msrf_fkx ON land_use
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod2msrf_fkx CASCADE;
CREATE INDEX land_use_lod2msrf_fkx ON land_use
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod3msrf_fkx CASCADE;
CREATE INDEX land_use_lod3msrf_fkx ON land_use
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod4msrf_fkx CASCADE;
CREATE INDEX land_use_lod4msrf_fkx ON land_use
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod1msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod1msrf_fkx ON plant_cover
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod2msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod2msrf_fkx ON plant_cover
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod3msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod3msrf_fkx ON plant_cover
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod4msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod4msrf_fkx ON plant_cover
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod1msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod1msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod1msolid_fkx ON plant_cover
	USING btree
	(
	  lod1_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod2msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod2msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod2msolid_fkx ON plant_cover
	USING btree
	(
	  lod2_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod3msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod3msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod3msolid_fkx ON plant_cover
	USING btree
	(
	  lod3_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_lod4msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod4msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod4msolid_fkx ON plant_cover
	USING btree
	(
	  lod4_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod1brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod2brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod3brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod4brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod1xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod2xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod3xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod4xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: sol_veg_obj_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod1impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod2impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod3impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod4impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_lod1refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod1refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod2refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod3refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: sol_veg_obj_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod4refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: waterbody_lod0curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod0curve_spx CASCADE;
CREATE INDEX waterbody_lod0curve_spx ON waterbody
	USING gist
	(
	  lod0_multi_curve
	);
-- ddl-end --

-- object: waterbody_lod1curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod1curve_spx CASCADE;
CREATE INDEX waterbody_lod1curve_spx ON waterbody
	USING gist
	(
	  lod1_multi_curve
	);
-- ddl-end --

-- object: waterbody_lod0msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod0msrf_fkx CASCADE;
CREATE INDEX waterbody_lod0msrf_fkx ON waterbody
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod1msrf_fkx CASCADE;
CREATE INDEX waterbody_lod1msrf_fkx ON waterbody
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod1solid_fkx CASCADE;
CREATE INDEX waterbody_lod1solid_fkx ON waterbody
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod2solid_fkx CASCADE;
CREATE INDEX waterbody_lod2solid_fkx ON waterbody
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod3solid_fkx CASCADE;
CREATE INDEX waterbody_lod3solid_fkx ON waterbody
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod4solid_fkx CASCADE;
CREATE INDEX waterbody_lod4solid_fkx ON waterbody
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbod_to_waterbnd_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbod_to_waterbnd_fkx CASCADE;
CREATE INDEX waterbod_to_waterbnd_fkx ON waterbod_to_waterbnd_srf
	USING btree
	(
	  waterboundary_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbod_to_waterbnd_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS waterbod_to_waterbnd_fkx1 CASCADE;
CREATE INDEX waterbod_to_waterbnd_fkx1 ON waterbod_to_waterbnd_srf
	USING btree
	(
	  waterbody_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_objclass_fkx CASCADE;
CREATE INDEX waterbnd_srf_objclass_fkx ON waterboundary_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod2srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_lod2srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod2srf_fkx ON waterboundary_surface
	USING btree
	(
	  lod2_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod3srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_lod3srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod3srf_fkx ON waterboundary_surface
	USING btree
	(
	  lod3_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbnd_srf_lod4srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_lod4srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod4srf_fkx ON waterboundary_surface
	USING btree
	(
	  lod4_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: raster_relief_coverage_fkx | type: INDEX --
-- DROP INDEX IF EXISTS raster_relief_coverage_fkx CASCADE;
CREATE INDEX raster_relief_coverage_fkx ON raster_relief
	USING btree
	(
	  coverage_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_parent_fkx CASCADE;
CREATE INDEX tunnel_parent_fkx ON tunnel
	USING btree
	(
	  tunnel_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_root_fkx CASCADE;
CREATE INDEX tunnel_root_fkx ON tunnel
	USING btree
	(
	  tunnel_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod1terr_spx CASCADE;
CREATE INDEX tunnel_lod1terr_spx ON tunnel
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2terr_spx CASCADE;
CREATE INDEX tunnel_lod2terr_spx ON tunnel
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3terr_spx CASCADE;
CREATE INDEX tunnel_lod3terr_spx ON tunnel
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4terr_spx CASCADE;
CREATE INDEX tunnel_lod4terr_spx ON tunnel
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: tunnel_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2curve_spx CASCADE;
CREATE INDEX tunnel_lod2curve_spx ON tunnel
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3curve_spx CASCADE;
CREATE INDEX tunnel_lod3curve_spx ON tunnel
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4curve_spx CASCADE;
CREATE INDEX tunnel_lod4curve_spx ON tunnel
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: tunnel_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod1msrf_fkx CASCADE;
CREATE INDEX tunnel_lod1msrf_fkx ON tunnel
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2msrf_fkx CASCADE;
CREATE INDEX tunnel_lod2msrf_fkx ON tunnel
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3msrf_fkx CASCADE;
CREATE INDEX tunnel_lod3msrf_fkx ON tunnel
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4msrf_fkx CASCADE;
CREATE INDEX tunnel_lod4msrf_fkx ON tunnel
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod1solid_fkx CASCADE;
CREATE INDEX tunnel_lod1solid_fkx ON tunnel
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2solid_fkx CASCADE;
CREATE INDEX tunnel_lod2solid_fkx ON tunnel
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3solid_fkx CASCADE;
CREATE INDEX tunnel_lod3solid_fkx ON tunnel
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4solid_fkx CASCADE;
CREATE INDEX tunnel_lod4solid_fkx ON tunnel
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_open_to_them_srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_open_to_them_srf_fkx CASCADE;
CREATE INDEX tun_open_to_them_srf_fkx ON tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_open_to_them_srf_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS tun_open_to_them_srf_fkx1 CASCADE;
CREATE INDEX tun_open_to_them_srf_fkx1 ON tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_tunnel_fkx CASCADE;
CREATE INDEX tun_hspace_tunnel_fkx ON tunnel_hollow_space
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_lod4msrf_fkx CASCADE;
CREATE INDEX tun_hspace_lod4msrf_fkx ON tunnel_hollow_space
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_lod4solid_fkx CASCADE;
CREATE INDEX tun_hspace_lod4solid_fkx ON tunnel_hollow_space
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_objclass_fkx CASCADE;
CREATE INDEX tun_them_srf_objclass_fkx ON tunnel_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_tunnel_fkx CASCADE;
CREATE INDEX tun_them_srf_tunnel_fkx ON tunnel_thematic_surface
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_hspace_fkx CASCADE;
CREATE INDEX tun_them_srf_hspace_fkx ON tunnel_thematic_surface
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_tun_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_tun_inst_fkx CASCADE;
CREATE INDEX tun_them_srf_tun_inst_fkx ON tunnel_thematic_surface
	USING btree
	(
	  tunnel_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_lod2msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod2msrf_fkx ON tunnel_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_lod3msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod3msrf_fkx ON tunnel_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_them_srf_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_lod4msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod4msrf_fkx ON tunnel_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_objclass_fkx CASCADE;
CREATE INDEX tunnel_open_objclass_fkx ON tunnel_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod3msrf_fkx CASCADE;
CREATE INDEX tunnel_open_lod3msrf_fkx ON tunnel_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod4msrf_fkx CASCADE;
CREATE INDEX tunnel_open_lod4msrf_fkx ON tunnel_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod3impl_fkx CASCADE;
CREATE INDEX tunnel_open_lod3impl_fkx ON tunnel_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_open_lod4impl_fkx ON tunnel_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_open_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod3refpt_spx CASCADE;
CREATE INDEX tunnel_open_lod3refpt_spx ON tunnel_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_open_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_open_lod4refpt_spx ON tunnel_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_objclass_fkx CASCADE;
CREATE INDEX tunnel_inst_objclass_fkx ON tunnel_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: tunnel_inst_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_tunnel_fkx CASCADE;
CREATE INDEX tunnel_inst_tunnel_fkx ON tunnel_installation
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_hspace_fkx CASCADE;
CREATE INDEX tunnel_inst_hspace_fkx ON tunnel_installation
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod2brep_fkx ON tunnel_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod3brep_fkx ON tunnel_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod4brep_fkx ON tunnel_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod2xgeom_spx ON tunnel_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod3xgeom_spx ON tunnel_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod4xgeom_spx ON tunnel_installation
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: tunnel_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod2impl_fkx ON tunnel_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod3impl_fkx ON tunnel_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod4impl_fkx ON tunnel_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod2refpt_spx ON tunnel_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod3refpt_spx ON tunnel_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod4refpt_spx ON tunnel_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: tunnel_furn_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_hspace_fkx CASCADE;
CREATE INDEX tunnel_furn_hspace_fkx ON tunnel_furniture
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4brep_fkx CASCADE;
CREATE INDEX tunnel_furn_lod4brep_fkx ON tunnel_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4xgeom_spx CASCADE;
CREATE INDEX tunnel_furn_lod4xgeom_spx ON tunnel_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: tunnel_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_furn_lod4impl_fkx ON tunnel_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_furn_lod4refpt_spx ON tunnel_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_parent_fkx CASCADE;
CREATE INDEX bridge_parent_fkx ON bridge
	USING btree
	(
	  bridge_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_root_fkx CASCADE;
CREATE INDEX bridge_root_fkx ON bridge
	USING btree
	(
	  bridge_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod1terr_spx CASCADE;
CREATE INDEX bridge_lod1terr_spx ON bridge
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2terr_spx CASCADE;
CREATE INDEX bridge_lod2terr_spx ON bridge
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3terr_spx CASCADE;
CREATE INDEX bridge_lod3terr_spx ON bridge
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4terr_spx CASCADE;
CREATE INDEX bridge_lod4terr_spx ON bridge
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: bridge_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2curve_spx CASCADE;
CREATE INDEX bridge_lod2curve_spx ON bridge
	USING gist
	(
	  lod2_multi_curve
	);
-- ddl-end --

-- object: bridge_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3curve_spx CASCADE;
CREATE INDEX bridge_lod3curve_spx ON bridge
	USING gist
	(
	  lod3_multi_curve
	);
-- ddl-end --

-- object: bridge_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4curve_spx CASCADE;
CREATE INDEX bridge_lod4curve_spx ON bridge
	USING gist
	(
	  lod4_multi_curve
	);
-- ddl-end --

-- object: bridge_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod1msrf_fkx CASCADE;
CREATE INDEX bridge_lod1msrf_fkx ON bridge
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2msrf_fkx CASCADE;
CREATE INDEX bridge_lod2msrf_fkx ON bridge
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3msrf_fkx CASCADE;
CREATE INDEX bridge_lod3msrf_fkx ON bridge
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_lod4msrf_fkx ON bridge
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod1solid_fkx CASCADE;
CREATE INDEX bridge_lod1solid_fkx ON bridge
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2solid_fkx CASCADE;
CREATE INDEX bridge_lod2solid_fkx ON bridge
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3solid_fkx CASCADE;
CREATE INDEX bridge_lod3solid_fkx ON bridge
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4solid_fkx CASCADE;
CREATE INDEX bridge_lod4solid_fkx ON bridge
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_brd_room_fkx CASCADE;
CREATE INDEX bridge_furn_brd_room_fkx ON bridge_furniture
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4brep_fkx CASCADE;
CREATE INDEX bridge_furn_lod4brep_fkx ON bridge_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_furn_lod4xgeom_spx ON bridge_furniture
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bridge_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4impl_fkx CASCADE;
CREATE INDEX bridge_furn_lod4impl_fkx ON bridge_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4refpt_spx CASCADE;
CREATE INDEX bridge_furn_lod4refpt_spx ON bridge_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_objclass_fkx CASCADE;
CREATE INDEX bridge_inst_objclass_fkx ON bridge_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: bridge_inst_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_bridge_fkx CASCADE;
CREATE INDEX bridge_inst_bridge_fkx ON bridge_installation
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_brd_room_fkx CASCADE;
CREATE INDEX bridge_inst_brd_room_fkx ON bridge_installation
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod2brep_fkx ON bridge_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod3brep_fkx ON bridge_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod4brep_fkx ON bridge_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod2xgeom_spx ON bridge_installation
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod3xgeom_spx ON bridge_installation
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod4xgeom_spx ON bridge_installation
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bridge_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod2impl_fkx ON bridge_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod3impl_fkx ON bridge_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod4impl_fkx ON bridge_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod2refpt_spx ON bridge_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod3refpt_spx ON bridge_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod4refpt_spx ON bridge_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_open_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_objclass_fkx CASCADE;
CREATE INDEX bridge_open_objclass_fkx ON bridge_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_address_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_address_fkx CASCADE;
CREATE INDEX bridge_open_address_fkx ON bridge_opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod3msrf_fkx CASCADE;
CREATE INDEX bridge_open_lod3msrf_fkx ON bridge_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_open_lod4msrf_fkx ON bridge_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod3impl_fkx CASCADE;
CREATE INDEX bridge_open_lod3impl_fkx ON bridge_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod4impl_fkx CASCADE;
CREATE INDEX bridge_open_lod4impl_fkx ON bridge_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_open_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod3refpt_spx CASCADE;
CREATE INDEX bridge_open_lod3refpt_spx ON bridge_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_open_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod4refpt_spx CASCADE;
CREATE INDEX bridge_open_lod4refpt_spx ON bridge_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: brd_open_to_them_srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_open_to_them_srf_fkx CASCADE;
CREATE INDEX brd_open_to_them_srf_fkx ON bridge_open_to_them_srf
	USING btree
	(
	  bridge_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_open_to_them_srf_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS brd_open_to_them_srf_fkx1 CASCADE;
CREATE INDEX brd_open_to_them_srf_fkx1 ON bridge_open_to_them_srf
	USING btree
	(
	  bridge_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_bridge_fkx CASCADE;
CREATE INDEX bridge_room_bridge_fkx ON bridge_room
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_room_lod4msrf_fkx ON bridge_room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_lod4solid_fkx CASCADE;
CREATE INDEX bridge_room_lod4solid_fkx ON bridge_room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_objclass_fkx CASCADE;
CREATE INDEX brd_them_srf_objclass_fkx ON bridge_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_bridge_fkx CASCADE;
CREATE INDEX brd_them_srf_bridge_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_brd_room_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_room_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_brd_inst_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_inst_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_brd_const_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_brd_const_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_const_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_constr_element_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_lod2msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod2msrf_fkx ON bridge_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_lod3msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod3msrf_fkx ON bridge_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: brd_them_srf_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_lod4msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod4msrf_fkx ON bridge_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_bridge_fkx CASCADE;
CREATE INDEX bridge_constr_bridge_fkx ON bridge_constr_element
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod1terr_spx CASCADE;
CREATE INDEX bridge_constr_lod1terr_spx ON bridge_constr_element
	USING gist
	(
	  lod1_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod2terr_spx CASCADE;
CREATE INDEX bridge_constr_lod2terr_spx ON bridge_constr_element
	USING gist
	(
	  lod2_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod3terr_spx CASCADE;
CREATE INDEX bridge_constr_lod3terr_spx ON bridge_constr_element
	USING gist
	(
	  lod3_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod4terr_spx CASCADE;
CREATE INDEX bridge_constr_lod4terr_spx ON bridge_constr_element
	USING gist
	(
	  lod4_terrain_intersection
	);
-- ddl-end --

-- object: bridge_constr_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod1brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod1brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod2brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod2brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod3brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod3brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod4brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod4brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_const_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod1xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod1xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod1_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod2xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod2xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod2_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod3xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod3xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod3_other_geom
	);
-- ddl-end --

-- object: bridge_const_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod4xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod4_other_geom
	);
-- ddl-end --

-- object: bridge_constr_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod1impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod1impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod2impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod2impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod3impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod3impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod4impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod4impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_const_lod1refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod1refpt_spx CASCADE;
CREATE INDEX bridge_const_lod1refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod1_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod2refpt_spx CASCADE;
CREATE INDEX bridge_const_lod2refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod2_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod3refpt_spx CASCADE;
CREATE INDEX bridge_const_lod3refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod3_implicit_ref_point
	);
-- ddl-end --

-- object: bridge_const_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod4refpt_spx CASCADE;
CREATE INDEX bridge_const_lod4refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod4_implicit_ref_point
	);
-- ddl-end --

-- object: address_to_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS address_to_bridge_fkx CASCADE;
CREATE INDEX address_to_bridge_fkx ON address_to_bridge
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: address_to_bridge_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS address_to_bridge_fkx1 CASCADE;
CREATE INDEX address_to_bridge_fkx1 ON address_to_bridge
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_inx CASCADE;
CREATE INDEX cityobject_inx ON cityobject
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_objectclass_fkx CASCADE;
CREATE INDEX cityobject_objectclass_fkx ON cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_envelope_spx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_envelope_spx CASCADE;
CREATE INDEX cityobject_envelope_spx ON cityobject
	USING gist
	(
	  envelope
	);
-- ddl-end --

-- object: appearance_inx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_inx CASCADE;
CREATE INDEX appearance_inx ON appearance
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_theme_inx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_theme_inx CASCADE;
CREATE INDEX appearance_theme_inx ON appearance
	USING btree
	(
	  theme ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_citymodel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_citymodel_fkx CASCADE;
CREATE INDEX appearance_citymodel_fkx ON appearance
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: appearance_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_cityobject_fkx CASCADE;
CREATE INDEX appearance_cityobject_fkx ON appearance
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geom_ref2lib_inx | type: INDEX --
-- DROP INDEX IF EXISTS implicit_geom_ref2lib_inx CASCADE;
CREATE INDEX implicit_geom_ref2lib_inx ON implicit_geometry
	USING btree
	(
	  reference_to_library ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geom_brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS implicit_geom_brep_fkx CASCADE;
CREATE INDEX implicit_geom_brep_fkx ON implicit_geometry
	USING btree
	(
	  relative_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_inx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_inx CASCADE;
CREATE INDEX surface_geom_inx ON surface_geometry
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_parent_fkx CASCADE;
CREATE INDEX surface_geom_parent_fkx ON surface_geometry
	USING btree
	(
	  parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_root_fkx CASCADE;
CREATE INDEX surface_geom_root_fkx ON surface_geometry
	USING btree
	(
	  root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_geom_spx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_spx CASCADE;
CREATE INDEX surface_geom_spx ON surface_geometry
	USING gist
	(
	  geometry
	);
-- ddl-end --

-- object: surface_geom_solid_spx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_solid_spx CASCADE;
CREATE INDEX surface_geom_solid_spx ON surface_geometry
	USING gist
	(
	  solid_geometry
	);
-- ddl-end --

-- object: surface_geom_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_cityobj_fkx CASCADE;
CREATE INDEX surface_geom_cityobj_fkx ON surface_geometry
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_data_inx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_inx CASCADE;
CREATE INDEX surface_data_inx ON surface_data
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: surface_data_spx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_spx CASCADE;
CREATE INDEX surface_data_spx ON surface_data
	USING gist
	(
	  gt_reference_point
	);
-- ddl-end --

-- object: surface_data_tex_image_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_tex_image_fkx CASCADE;
CREATE INDEX surface_data_tex_image_fkx ON surface_data
	USING btree
	(
	  tex_image_id ASC NULLS LAST
	);
-- ddl-end --

-- object: citymodel_inx | type: INDEX --
-- DROP INDEX IF EXISTS citymodel_inx CASCADE;
CREATE INDEX citymodel_inx ON citymodel
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	);
-- ddl-end --

-- object: genericattrib_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_parent_fkx CASCADE;
CREATE INDEX genericattrib_parent_fkx ON cityobject_genericattrib
	USING btree
	(
	  parent_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_root_fkx CASCADE;
CREATE INDEX genericattrib_root_fkx ON cityobject_genericattrib
	USING btree
	(
	  root_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_geom_fkx CASCADE;
CREATE INDEX genericattrib_geom_fkx ON cityobject_genericattrib
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: genericattrib_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_cityobj_fkx CASCADE;
CREATE INDEX genericattrib_cityobj_fkx ON cityobject_genericattrib
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: ext_ref_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS ext_ref_cityobject_fkx CASCADE;
CREATE INDEX ext_ref_cityobject_fkx ON external_reference
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: grid_coverage_raster_spx | type: INDEX --
-- DROP INDEX IF EXISTS grid_coverage_raster_spx CASCADE;
CREATE INDEX grid_coverage_raster_spx ON grid_coverage
	USING gist
	(
	  (ST_ConvexHull(rasterproperty))
	);
-- ddl-end --

-- object: cityobject_lineage_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_lineage_inx CASCADE;
CREATE INDEX cityobject_lineage_inx ON cityobject
	USING btree
	(
	  lineage ASC NULLS LAST
	);
-- ddl-end --

-- object: citymodel_envelope_spx | type: INDEX --
-- DROP INDEX IF EXISTS citymodel_envelope_spx CASCADE;
CREATE INDEX citymodel_envelope_spx ON citymodel
	USING gist
	(
	  envelope
	);
-- ddl-end --

-- object: address_inx | type: INDEX --
-- DROP INDEX IF EXISTS address_inx CASCADE;
CREATE INDEX address_inx ON address
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	);
-- ddl-end --

-- object: address_point_spx | type: INDEX --
-- DROP INDEX IF EXISTS address_point_spx CASCADE;
CREATE INDEX address_point_spx ON address
	USING gist
	(
	  multi_point
	);
-- ddl-end --

-- object: schema | type: TABLE --
-- DROP TABLE IF EXISTS schema CASCADE;
CREATE TABLE schema(
	id integer NOT NULL DEFAULT nextval('schema_seq'::regclass),
	is_ade_root numeric NOT NULL,
	citygml_version character varying(50) NOT NULL,
	xml_namespace_uri character varying(4000) NOT NULL,
	xml_namespace_prefix character varying(50) NOT NULL,
	xml_schema_location character varying(4000),
	xml_schemafile bytea,
	xml_schemafile_type character varying(256),
	ade_id integer,
	CONSTRAINT schema_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: schema_to_objectclass | type: TABLE --
-- DROP TABLE IF EXISTS schema_to_objectclass CASCADE;
CREATE TABLE schema_to_objectclass(
	schema_id integer NOT NULL,
	objectclass_id integer NOT NULL,
	CONSTRAINT schema_to_objectclass_pk PRIMARY KEY (schema_id,objectclass_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: schema_to_objectclass_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS schema_to_objectclass_fkx1 CASCADE;
CREATE INDEX schema_to_objectclass_fkx1 ON schema_to_objectclass
	USING btree
	(
	  schema_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: schema_to_objectclass_fkx2 | type: INDEX --
-- DROP INDEX IF EXISTS schema_to_objectclass_fkx2 CASCADE;
CREATE INDEX schema_to_objectclass_fkx2 ON schema_to_objectclass
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: objectclass_baseclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS objectclass_baseclass_fkx CASCADE;
CREATE INDEX objectclass_baseclass_fkx ON objectclass
	USING btree
	(
	  baseclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: schema_referencing | type: TABLE --
-- DROP TABLE IF EXISTS schema_referencing CASCADE;
CREATE TABLE schema_referencing(
	referencing_id integer NOT NULL,
	referenced_id integer NOT NULL,
	CONSTRAINT schema_referencing_pk PRIMARY KEY (referenced_id,referencing_id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: schema_referencing_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS schema_referencing_fkx1 CASCADE;
CREATE INDEX schema_referencing_fkx1 ON schema_referencing
	USING btree
	(
	  referenced_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: schema_referencing_fkx2 | type: INDEX --
-- DROP INDEX IF EXISTS schema_referencing_fkx2 CASCADE;
CREATE INDEX schema_referencing_fkx2 ON schema_referencing
	USING btree
	(
	  referencing_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: breakline_rel_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS breakline_rel_objclass_fkx CASCADE;
CREATE INDEX breakline_rel_objclass_fkx ON breakline_relief
	USING btree
	(
	  objectclass_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_objectclass_fkx CASCADE;
CREATE INDEX bridge_objectclass_fkx ON bridge
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_constr_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_objclass_fkx CASCADE;
CREATE INDEX bridge_constr_objclass_fkx ON bridge_constr_element
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_objclass_fkx CASCADE;
CREATE INDEX bridge_furn_objclass_fkx ON bridge_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bridge_room_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_objclass_fkx CASCADE;
CREATE INDEX bridge_room_objclass_fkx ON bridge_room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: building_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_objectclass_fkx CASCADE;
CREATE INDEX building_objectclass_fkx ON building
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: bldg_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_objclass_fkx CASCADE;
CREATE INDEX bldg_furn_objclass_fkx ON building_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: city_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_objclass_fkx CASCADE;
CREATE INDEX city_furn_objclass_fkx ON city_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: group_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_objectclass_fkx CASCADE;
CREATE INDEX group_objectclass_fkx ON cityobjectgroup
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: gen_object_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_objclass_fkx CASCADE;
CREATE INDEX gen_object_objclass_fkx ON generic_cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: land_use_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_objclass_fkx CASCADE;
CREATE INDEX land_use_objclass_fkx ON land_use
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: masspoint_rel_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS masspoint_rel_objclass_fkx CASCADE;
CREATE INDEX masspoint_rel_objclass_fkx ON masspoint_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: plant_cover_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_objclass_fkx CASCADE;
CREATE INDEX plant_cover_objclass_fkx ON plant_cover
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: raster_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS raster_relief_objclass_fkx CASCADE;
CREATE INDEX raster_relief_objclass_fkx ON raster_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: relief_feat_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS relief_feat_objclass_fkx CASCADE;
CREATE INDEX relief_feat_objclass_fkx ON relief_feature
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: room_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_objectclass_fkx CASCADE;
CREATE INDEX room_objectclass_fkx ON room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sol_veg_obj_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_objclass_fkx CASCADE;
CREATE INDEX sol_veg_obj_objclass_fkx ON solitary_vegetat_object
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tin_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_objclass_fkx CASCADE;
CREATE INDEX tin_relief_objclass_fkx ON tin_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_objectclass_fkx CASCADE;
CREATE INDEX tunnel_objectclass_fkx ON tunnel
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tunnel_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_objclass_fkx CASCADE;
CREATE INDEX tunnel_furn_objclass_fkx ON tunnel_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: tun_hspace_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_objclass_fkx CASCADE;
CREATE INDEX tun_hspace_objclass_fkx ON tunnel_hollow_space
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: waterbody_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_objclass_fkx CASCADE;
CREATE INDEX waterbody_objclass_fkx ON waterbody
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: ade | type: TABLE --
-- DROP TABLE IF EXISTS ade CASCADE;
CREATE TABLE ade(
	id integer NOT NULL DEFAULT nextval('ade_seq'::regclass),
	adeid character varying(256) NOT NULL,
	name character varying(1000) NOT NULL,
	description character varying(4000),
	version character varying(50),
	db_prefix character varying(10) NOT NULL,
	xml_schemamapping_file text,
	drop_db_script text,
	creation_date timestamp with time zone,
	creation_person character varying(256),
	CONSTRAINT ade_pk PRIMARY KEY (id)
	 WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: surface_data_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_objclass_fkx CASCADE;
CREATE INDEX surface_data_objclass_fkx ON surface_data
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);
-- ddl-end --

-- object: aggregation_info | type: TABLE --
-- DROP TABLE IF EXISTS aggregation_info CASCADE;
CREATE TABLE aggregation_info(
	child_id integer NOT NULL,
	parent_id integer NOT NULL,
	join_table_or_column_name character varying(30) NOT NULL,
	min_occurs integer,
	max_occurs integer,
	is_composite numeric,
	CONSTRAINT aggregation_info_pk PRIMARY KEY (child_id,parent_id,join_table_or_column_name)

);
-- ddl-end --

-- object: cityobj_creation_date_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobj_creation_date_inx CASCADE;
CREATE INDEX cityobj_creation_date_inx ON cityobject
	USING btree
	(
	  creation_date
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobj_term_date_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobj_term_date_inx CASCADE;
CREATE INDEX cityobj_term_date_inx ON cityobject
	USING btree
	(
	  termination_date
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobj_last_mod_date_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobj_last_mod_date_inx CASCADE;
CREATE INDEX cityobj_last_mod_date_inx ON cityobject
	USING btree
	(
	  last_modification_date
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: implicit_geom_inx | type: INDEX --
-- DROP INDEX IF EXISTS implicit_geom_inx CASCADE;
CREATE INDEX implicit_geom_inx ON implicit_geometry
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: cityobject_member_fk | type: CONSTRAINT --
-- ALTER TABLE cityobject_member DROP CONSTRAINT IF EXISTS cityobject_member_fk CASCADE;
ALTER TABLE cityobject_member ADD CONSTRAINT cityobject_member_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: cityobject_member_fk1 | type: CONSTRAINT --
-- ALTER TABLE cityobject_member DROP CONSTRAINT IF EXISTS cityobject_member_fk1 CASCADE;
ALTER TABLE cityobject_member ADD CONSTRAINT cityobject_member_fk1 FOREIGN KEY (citymodel_id)
REFERENCES citymodel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: general_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE generalization DROP CONSTRAINT IF EXISTS general_cityobject_fk CASCADE;
ALTER TABLE generalization ADD CONSTRAINT general_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: general_generalizes_to_fk | type: CONSTRAINT --
-- ALTER TABLE generalization DROP CONSTRAINT IF EXISTS general_generalizes_to_fk CASCADE;
ALTER TABLE generalization ADD CONSTRAINT general_generalizes_to_fk FOREIGN KEY (generalizes_to_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: group_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE cityobjectgroup DROP CONSTRAINT IF EXISTS group_cityobject_fk CASCADE;
ALTER TABLE cityobjectgroup ADD CONSTRAINT group_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_brep_fk | type: CONSTRAINT --
-- ALTER TABLE cityobjectgroup DROP CONSTRAINT IF EXISTS group_brep_fk CASCADE;
ALTER TABLE cityobjectgroup ADD CONSTRAINT group_brep_fk FOREIGN KEY (brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_parent_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE cityobjectgroup DROP CONSTRAINT IF EXISTS group_parent_cityobj_fk CASCADE;
ALTER TABLE cityobjectgroup ADD CONSTRAINT group_parent_cityobj_fk FOREIGN KEY (parent_cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE cityobjectgroup DROP CONSTRAINT IF EXISTS group_objectclass_fk CASCADE;
ALTER TABLE cityobjectgroup ADD CONSTRAINT group_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: group_to_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE group_to_cityobject DROP CONSTRAINT IF EXISTS group_to_cityobject_fk CASCADE;
ALTER TABLE group_to_cityobject ADD CONSTRAINT group_to_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: group_to_cityobject_fk1 | type: CONSTRAINT --
-- ALTER TABLE group_to_cityobject DROP CONSTRAINT IF EXISTS group_to_cityobject_fk1 CASCADE;
ALTER TABLE group_to_cityobject ADD CONSTRAINT group_to_cityobject_fk1 FOREIGN KEY (cityobjectgroup_id)
REFERENCES cityobjectgroup (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: objectclass_superclass_fk | type: CONSTRAINT --
-- ALTER TABLE objectclass DROP CONSTRAINT IF EXISTS objectclass_superclass_fk CASCADE;
ALTER TABLE objectclass ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY (superclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: objectclass_baseclass_fk | type: CONSTRAINT --
-- ALTER TABLE objectclass DROP CONSTRAINT IF EXISTS objectclass_baseclass_fk CASCADE;
ALTER TABLE objectclass ADD CONSTRAINT objectclass_baseclass_fk FOREIGN KEY (baseclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: objectclass_ade_fk | type: CONSTRAINT --
-- ALTER TABLE objectclass DROP CONSTRAINT IF EXISTS objectclass_ade_fk CASCADE;
ALTER TABLE objectclass ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY (ade_id)
REFERENCES ade (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_cityobject_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod1brep_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod2brep_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod3brep_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod4brep_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod1impl_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod2impl_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod3impl_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_lod4impl_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: city_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE city_furniture DROP CONSTRAINT IF EXISTS city_furn_objclass_fk CASCADE;
ALTER TABLE city_furniture ADD CONSTRAINT city_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_cityobject_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod0brep_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod0brep_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod0brep_fk FOREIGN KEY (lod0_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod1brep_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod2brep_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod3brep_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod4brep_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod0impl_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod0impl_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod0impl_fk FOREIGN KEY (lod0_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod1impl_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod2impl_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod3impl_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_lod4impl_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: gen_object_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE generic_cityobject DROP CONSTRAINT IF EXISTS gen_object_objclass_fk CASCADE;
ALTER TABLE generic_cityobject ADD CONSTRAINT gen_object_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_building_fk | type: CONSTRAINT --
-- ALTER TABLE address_to_building DROP CONSTRAINT IF EXISTS address_to_building_fk CASCADE;
ALTER TABLE address_to_building ADD CONSTRAINT address_to_building_fk FOREIGN KEY (address_id)
REFERENCES address (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_building_fk1 | type: CONSTRAINT --
-- ALTER TABLE address_to_building DROP CONSTRAINT IF EXISTS address_to_building_fk1 CASCADE;
ALTER TABLE address_to_building ADD CONSTRAINT address_to_building_fk1 FOREIGN KEY (building_id)
REFERENCES building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_cityobject_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_parent_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_parent_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_parent_fk FOREIGN KEY (building_parent_id)
REFERENCES building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_root_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_root_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_root_fk FOREIGN KEY (building_root_id)
REFERENCES building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod0footprint_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod0footprint_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod0footprint_fk FOREIGN KEY (lod0_footprint_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod0roofprint_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod0roofprint_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod0roofprint_fk FOREIGN KEY (lod0_roofprint_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod1msrf_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod2msrf_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod3msrf_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod4msrf_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod1solid_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod2solid_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod3solid_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_lod4solid_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: building_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE building DROP CONSTRAINT IF EXISTS building_objectclass_fk CASCADE;
ALTER TABLE building ADD CONSTRAINT building_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_cityobject_fk CASCADE;
ALTER TABLE building_furniture ADD CONSTRAINT bldg_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_room_fk | type: CONSTRAINT --
-- ALTER TABLE building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_room_fk CASCADE;
ALTER TABLE building_furniture ADD CONSTRAINT bldg_furn_room_fk FOREIGN KEY (room_id)
REFERENCES room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_lod4brep_fk CASCADE;
ALTER TABLE building_furniture ADD CONSTRAINT bldg_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_lod4impl_fk CASCADE;
ALTER TABLE building_furniture ADD CONSTRAINT bldg_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE building_furniture DROP CONSTRAINT IF EXISTS bldg_furn_objclass_fk CASCADE;
ALTER TABLE building_furniture ADD CONSTRAINT bldg_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_cityobject_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_objclass_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_building_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_building_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_building_fk FOREIGN KEY (building_id)
REFERENCES building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_room_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_room_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_room_fk FOREIGN KEY (room_id)
REFERENCES room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod2brep_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod3brep_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod4brep_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod2impl_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod3impl_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bldg_inst_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE building_installation DROP CONSTRAINT IF EXISTS bldg_inst_lod4impl_fk CASCADE;
ALTER TABLE building_installation ADD CONSTRAINT bldg_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_cityobject_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_objectclass_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_address_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_address_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_address_fk FOREIGN KEY (address_id)
REFERENCES address (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_lod3msrf_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_lod4msrf_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_lod3impl_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: opening_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE opening DROP CONSTRAINT IF EXISTS opening_lod4impl_fk CASCADE;
ALTER TABLE opening ADD CONSTRAINT opening_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: open_to_them_surface_fk | type: CONSTRAINT --
-- ALTER TABLE opening_to_them_surface DROP CONSTRAINT IF EXISTS open_to_them_surface_fk CASCADE;
ALTER TABLE opening_to_them_surface ADD CONSTRAINT open_to_them_surface_fk FOREIGN KEY (opening_id)
REFERENCES opening (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: open_to_them_surface_fk1 | type: CONSTRAINT --
-- ALTER TABLE opening_to_them_surface DROP CONSTRAINT IF EXISTS open_to_them_surface_fk1 CASCADE;
ALTER TABLE opening_to_them_surface ADD CONSTRAINT open_to_them_surface_fk1 FOREIGN KEY (thematic_surface_id)
REFERENCES thematic_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE room DROP CONSTRAINT IF EXISTS room_cityobject_fk CASCADE;
ALTER TABLE room ADD CONSTRAINT room_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_building_fk | type: CONSTRAINT --
-- ALTER TABLE room DROP CONSTRAINT IF EXISTS room_building_fk CASCADE;
ALTER TABLE room ADD CONSTRAINT room_building_fk FOREIGN KEY (building_id)
REFERENCES building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE room DROP CONSTRAINT IF EXISTS room_lod4msrf_fk CASCADE;
ALTER TABLE room ADD CONSTRAINT room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE room DROP CONSTRAINT IF EXISTS room_lod4solid_fk CASCADE;
ALTER TABLE room ADD CONSTRAINT room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: room_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE room DROP CONSTRAINT IF EXISTS room_objectclass_fk CASCADE;
ALTER TABLE room ADD CONSTRAINT room_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_cityobject_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_objclass_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_building_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_building_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_building_fk FOREIGN KEY (building_id)
REFERENCES building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_room_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_room_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_room_fk FOREIGN KEY (room_id)
REFERENCES room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_bldg_inst_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_bldg_inst_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_bldg_inst_fk FOREIGN KEY (building_installation_id)
REFERENCES building_installation (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_lod2msrf_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_lod3msrf_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: them_surface_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE thematic_surface DROP CONSTRAINT IF EXISTS them_surface_lod4msrf_fk CASCADE;
ALTER TABLE thematic_surface ADD CONSTRAINT them_surface_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: texparam_geom_fk | type: CONSTRAINT --
-- ALTER TABLE textureparam DROP CONSTRAINT IF EXISTS texparam_geom_fk CASCADE;
ALTER TABLE textureparam ADD CONSTRAINT texparam_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: texparam_surface_data_fk | type: CONSTRAINT --
-- ALTER TABLE textureparam DROP CONSTRAINT IF EXISTS texparam_surface_data_fk CASCADE;
ALTER TABLE textureparam ADD CONSTRAINT texparam_surface_data_fk FOREIGN KEY (surface_data_id)
REFERENCES surface_data (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: app_to_surf_data_fk | type: CONSTRAINT --
-- ALTER TABLE appear_to_surface_data DROP CONSTRAINT IF EXISTS app_to_surf_data_fk CASCADE;
ALTER TABLE appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk FOREIGN KEY (surface_data_id)
REFERENCES surface_data (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: app_to_surf_data_fk1 | type: CONSTRAINT --
-- ALTER TABLE appear_to_surface_data DROP CONSTRAINT IF EXISTS app_to_surf_data_fk1 CASCADE;
ALTER TABLE appear_to_surface_data ADD CONSTRAINT app_to_surf_data_fk1 FOREIGN KEY (appearance_id)
REFERENCES appearance (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: breakline_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE breakline_relief DROP CONSTRAINT IF EXISTS breakline_relief_comp_fk CASCADE;
ALTER TABLE breakline_relief ADD CONSTRAINT breakline_relief_comp_fk FOREIGN KEY (id)
REFERENCES relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: breakline_rel_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE breakline_relief DROP CONSTRAINT IF EXISTS breakline_rel_objclass_fk CASCADE;
ALTER TABLE breakline_relief ADD CONSTRAINT breakline_rel_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: masspoint_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE masspoint_relief DROP CONSTRAINT IF EXISTS masspoint_relief_comp_fk CASCADE;
ALTER TABLE masspoint_relief ADD CONSTRAINT masspoint_relief_comp_fk FOREIGN KEY (id)
REFERENCES relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: masspoint_rel_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE masspoint_relief DROP CONSTRAINT IF EXISTS masspoint_rel_objclass_fk CASCADE;
ALTER TABLE masspoint_relief ADD CONSTRAINT masspoint_rel_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_comp_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE relief_component DROP CONSTRAINT IF EXISTS relief_comp_cityobject_fk CASCADE;
ALTER TABLE relief_component ADD CONSTRAINT relief_comp_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_comp_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE relief_component DROP CONSTRAINT IF EXISTS relief_comp_objclass_fk CASCADE;
ALTER TABLE relief_component ADD CONSTRAINT relief_comp_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: rel_feat_to_rel_comp_fk | type: CONSTRAINT --
-- ALTER TABLE relief_feat_to_rel_comp DROP CONSTRAINT IF EXISTS rel_feat_to_rel_comp_fk CASCADE;
ALTER TABLE relief_feat_to_rel_comp ADD CONSTRAINT rel_feat_to_rel_comp_fk FOREIGN KEY (relief_component_id)
REFERENCES relief_component (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: rel_feat_to_rel_comp_fk1 | type: CONSTRAINT --
-- ALTER TABLE relief_feat_to_rel_comp DROP CONSTRAINT IF EXISTS rel_feat_to_rel_comp_fk1 CASCADE;
ALTER TABLE relief_feat_to_rel_comp ADD CONSTRAINT rel_feat_to_rel_comp_fk1 FOREIGN KEY (relief_feature_id)
REFERENCES relief_feature (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_feat_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE relief_feature DROP CONSTRAINT IF EXISTS relief_feat_cityobject_fk CASCADE;
ALTER TABLE relief_feature ADD CONSTRAINT relief_feat_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: relief_feat_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE relief_feature DROP CONSTRAINT IF EXISTS relief_feat_objclass_fk CASCADE;
ALTER TABLE relief_feature ADD CONSTRAINT relief_feat_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tin_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE tin_relief DROP CONSTRAINT IF EXISTS tin_relief_comp_fk CASCADE;
ALTER TABLE tin_relief ADD CONSTRAINT tin_relief_comp_fk FOREIGN KEY (id)
REFERENCES relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tin_relief_geom_fk | type: CONSTRAINT --
-- ALTER TABLE tin_relief DROP CONSTRAINT IF EXISTS tin_relief_geom_fk CASCADE;
ALTER TABLE tin_relief ADD CONSTRAINT tin_relief_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tin_relief_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE tin_relief DROP CONSTRAINT IF EXISTS tin_relief_objclass_fk CASCADE;
ALTER TABLE tin_relief ADD CONSTRAINT tin_relief_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_objclass_fk CASCADE;
ALTER TABLE transportation_complex ADD CONSTRAINT tran_complex_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_cityobject_fk CASCADE;
ALTER TABLE transportation_complex ADD CONSTRAINT tran_complex_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod1msrf_fk CASCADE;
ALTER TABLE transportation_complex ADD CONSTRAINT tran_complex_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod2msrf_fk CASCADE;
ALTER TABLE transportation_complex ADD CONSTRAINT tran_complex_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod3msrf_fk CASCADE;
ALTER TABLE transportation_complex ADD CONSTRAINT tran_complex_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tran_complex_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE transportation_complex DROP CONSTRAINT IF EXISTS tran_complex_lod4msrf_fk CASCADE;
ALTER TABLE transportation_complex ADD CONSTRAINT tran_complex_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE traffic_area DROP CONSTRAINT IF EXISTS traffic_area_cityobject_fk CASCADE;
ALTER TABLE traffic_area ADD CONSTRAINT traffic_area_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE traffic_area DROP CONSTRAINT IF EXISTS traffic_area_objclass_fk CASCADE;
ALTER TABLE traffic_area ADD CONSTRAINT traffic_area_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE traffic_area DROP CONSTRAINT IF EXISTS traffic_area_lod2msrf_fk CASCADE;
ALTER TABLE traffic_area ADD CONSTRAINT traffic_area_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE traffic_area DROP CONSTRAINT IF EXISTS traffic_area_lod3msrf_fk CASCADE;
ALTER TABLE traffic_area ADD CONSTRAINT traffic_area_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE traffic_area DROP CONSTRAINT IF EXISTS traffic_area_lod4msrf_fk CASCADE;
ALTER TABLE traffic_area ADD CONSTRAINT traffic_area_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: traffic_area_trancmplx_fk | type: CONSTRAINT --
-- ALTER TABLE traffic_area DROP CONSTRAINT IF EXISTS traffic_area_trancmplx_fk CASCADE;
ALTER TABLE traffic_area ADD CONSTRAINT traffic_area_trancmplx_fk FOREIGN KEY (transportation_complex_id)
REFERENCES transportation_complex (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_cityobject_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod0msrf_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_lod0msrf_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_lod1msrf_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_lod2msrf_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_lod3msrf_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_lod4msrf_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: land_use_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE land_use DROP CONSTRAINT IF EXISTS land_use_objclass_fk CASCADE;
ALTER TABLE land_use ADD CONSTRAINT land_use_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_cityobject_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod1msrf_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod2msrf_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod3msrf_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod4msrf_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod1msolid_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod1msolid_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod1msolid_fk FOREIGN KEY (lod1_multi_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod2msolid_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod2msolid_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod2msolid_fk FOREIGN KEY (lod2_multi_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod3msolid_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod3msolid_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod3msolid_fk FOREIGN KEY (lod3_multi_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_lod4msolid_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_lod4msolid_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_lod4msolid_fk FOREIGN KEY (lod4_multi_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: plant_cover_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE plant_cover DROP CONSTRAINT IF EXISTS plant_cover_objclass_fk CASCADE;
ALTER TABLE plant_cover ADD CONSTRAINT plant_cover_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_cityobject_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod1brep_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod2brep_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod3brep_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod4brep_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod1impl_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod2impl_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod3impl_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_lod4impl_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: sol_veg_obj_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE solitary_vegetat_object DROP CONSTRAINT IF EXISTS sol_veg_obj_objclass_fk CASCADE;
ALTER TABLE solitary_vegetat_object ADD CONSTRAINT sol_veg_obj_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_cityobject_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod0msrf_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_lod0msrf_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_lod1msrf_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_lod1solid_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_lod2solid_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_lod3solid_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_lod4solid_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbody_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE waterbody DROP CONSTRAINT IF EXISTS waterbody_objclass_fk CASCADE;
ALTER TABLE waterbody ADD CONSTRAINT waterbody_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbod_to_waterbnd_fk | type: CONSTRAINT --
-- ALTER TABLE waterbod_to_waterbnd_srf DROP CONSTRAINT IF EXISTS waterbod_to_waterbnd_fk CASCADE;
ALTER TABLE waterbod_to_waterbnd_srf ADD CONSTRAINT waterbod_to_waterbnd_fk FOREIGN KEY (waterboundary_surface_id)
REFERENCES waterboundary_surface (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbod_to_waterbnd_fk1 | type: CONSTRAINT --
-- ALTER TABLE waterbod_to_waterbnd_srf DROP CONSTRAINT IF EXISTS waterbod_to_waterbnd_fk1 CASCADE;
ALTER TABLE waterbod_to_waterbnd_srf ADD CONSTRAINT waterbod_to_waterbnd_fk1 FOREIGN KEY (waterbody_id)
REFERENCES waterbody (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_cityobject_fk CASCADE;
ALTER TABLE waterboundary_surface ADD CONSTRAINT waterbnd_srf_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_objclass_fk CASCADE;
ALTER TABLE waterboundary_surface ADD CONSTRAINT waterbnd_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_lod2srf_fk | type: CONSTRAINT --
-- ALTER TABLE waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_lod2srf_fk CASCADE;
ALTER TABLE waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod2srf_fk FOREIGN KEY (lod2_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_lod3srf_fk | type: CONSTRAINT --
-- ALTER TABLE waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_lod3srf_fk CASCADE;
ALTER TABLE waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod3srf_fk FOREIGN KEY (lod3_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: waterbnd_srf_lod4srf_fk | type: CONSTRAINT --
-- ALTER TABLE waterboundary_surface DROP CONSTRAINT IF EXISTS waterbnd_srf_lod4srf_fk CASCADE;
ALTER TABLE waterboundary_surface ADD CONSTRAINT waterbnd_srf_lod4srf_fk FOREIGN KEY (lod4_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE raster_relief DROP CONSTRAINT IF EXISTS raster_relief_comp_fk CASCADE;
ALTER TABLE raster_relief ADD CONSTRAINT raster_relief_comp_fk FOREIGN KEY (id)
REFERENCES relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_coverage_fk | type: CONSTRAINT --
-- ALTER TABLE raster_relief DROP CONSTRAINT IF EXISTS raster_relief_coverage_fk CASCADE;
ALTER TABLE raster_relief ADD CONSTRAINT raster_relief_coverage_fk FOREIGN KEY (coverage_id)
REFERENCES grid_coverage (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE raster_relief DROP CONSTRAINT IF EXISTS raster_relief_objclass_fk CASCADE;
ALTER TABLE raster_relief ADD CONSTRAINT raster_relief_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_cityobject_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_parent_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_parent_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_parent_fk FOREIGN KEY (tunnel_parent_id)
REFERENCES tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_root_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_root_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_root_fk FOREIGN KEY (tunnel_root_id)
REFERENCES tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod1msrf_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod2msrf_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod3msrf_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod4msrf_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod1solid_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod2solid_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod3solid_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_lod4solid_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel DROP CONSTRAINT IF EXISTS tunnel_objectclass_fk CASCADE;
ALTER TABLE tunnel ADD CONSTRAINT tunnel_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_open_to_them_srf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_open_to_them_srf DROP CONSTRAINT IF EXISTS tun_open_to_them_srf_fk CASCADE;
ALTER TABLE tunnel_open_to_them_srf ADD CONSTRAINT tun_open_to_them_srf_fk FOREIGN KEY (tunnel_opening_id)
REFERENCES tunnel_opening (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_open_to_them_srf_fk1 | type: CONSTRAINT --
-- ALTER TABLE tunnel_open_to_them_srf DROP CONSTRAINT IF EXISTS tun_open_to_them_srf_fk1 CASCADE;
ALTER TABLE tunnel_open_to_them_srf ADD CONSTRAINT tun_open_to_them_srf_fk1 FOREIGN KEY (tunnel_thematic_surface_id)
REFERENCES tunnel_thematic_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_cityobj_fk CASCADE;
ALTER TABLE tunnel_hollow_space ADD CONSTRAINT tun_hspace_cityobj_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_tunnel_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_tunnel_fk CASCADE;
ALTER TABLE tunnel_hollow_space ADD CONSTRAINT tun_hspace_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_lod4msrf_fk CASCADE;
ALTER TABLE tunnel_hollow_space ADD CONSTRAINT tun_hspace_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_lod4solid_fk CASCADE;
ALTER TABLE tunnel_hollow_space ADD CONSTRAINT tun_hspace_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_hspace_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_hollow_space DROP CONSTRAINT IF EXISTS tun_hspace_objclass_fk CASCADE;
ALTER TABLE tunnel_hollow_space ADD CONSTRAINT tun_hspace_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_cityobj_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_cityobj_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_objclass_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_tunnel_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_tunnel_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_hspace_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_hspace_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES tunnel_hollow_space (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_tun_inst_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_tun_inst_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_tun_inst_fk FOREIGN KEY (tunnel_installation_id)
REFERENCES tunnel_installation (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_lod2msrf_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_lod3msrf_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tun_them_srf_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_thematic_surface DROP CONSTRAINT IF EXISTS tun_them_srf_lod4msrf_fk CASCADE;
ALTER TABLE tunnel_thematic_surface ADD CONSTRAINT tun_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_cityobject_fk CASCADE;
ALTER TABLE tunnel_opening ADD CONSTRAINT tunnel_open_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_objclass_fk CASCADE;
ALTER TABLE tunnel_opening ADD CONSTRAINT tunnel_open_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod3msrf_fk CASCADE;
ALTER TABLE tunnel_opening ADD CONSTRAINT tunnel_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod4msrf_fk CASCADE;
ALTER TABLE tunnel_opening ADD CONSTRAINT tunnel_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod3impl_fk CASCADE;
ALTER TABLE tunnel_opening ADD CONSTRAINT tunnel_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_open_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_opening DROP CONSTRAINT IF EXISTS tunnel_open_lod4impl_fk CASCADE;
ALTER TABLE tunnel_opening ADD CONSTRAINT tunnel_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_cityobject_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_objclass_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_tunnel_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_tunnel_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_tunnel_fk FOREIGN KEY (tunnel_id)
REFERENCES tunnel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_hspace_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_hspace_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES tunnel_hollow_space (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod2brep_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod3brep_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod4brep_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod2impl_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod3impl_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_inst_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_installation DROP CONSTRAINT IF EXISTS tunnel_inst_lod4impl_fk CASCADE;
ALTER TABLE tunnel_installation ADD CONSTRAINT tunnel_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_cityobject_fk CASCADE;
ALTER TABLE tunnel_furniture ADD CONSTRAINT tunnel_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_hspace_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_hspace_fk CASCADE;
ALTER TABLE tunnel_furniture ADD CONSTRAINT tunnel_furn_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
REFERENCES tunnel_hollow_space (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_lod4brep_fk CASCADE;
ALTER TABLE tunnel_furniture ADD CONSTRAINT tunnel_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_lod4impl_fk CASCADE;
ALTER TABLE tunnel_furniture ADD CONSTRAINT tunnel_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: tunnel_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE tunnel_furniture DROP CONSTRAINT IF EXISTS tunnel_furn_objclass_fk CASCADE;
ALTER TABLE tunnel_furniture ADD CONSTRAINT tunnel_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_cityobject_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_parent_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_parent_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_parent_fk FOREIGN KEY (bridge_parent_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_root_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_root_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_root_fk FOREIGN KEY (bridge_root_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod1msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod1msrf_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod2msrf_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod3msrf_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod4msrf_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod1solid_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod1solid_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod1solid_fk FOREIGN KEY (lod1_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod2solid_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod2solid_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod2solid_fk FOREIGN KEY (lod2_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod3solid_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod3solid_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod3solid_fk FOREIGN KEY (lod3_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_lod4solid_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge DROP CONSTRAINT IF EXISTS bridge_objectclass_fk CASCADE;
ALTER TABLE bridge ADD CONSTRAINT bridge_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_cityobject_fk CASCADE;
ALTER TABLE bridge_furniture ADD CONSTRAINT bridge_furn_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_brd_room_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_brd_room_fk CASCADE;
ALTER TABLE bridge_furniture ADD CONSTRAINT bridge_furn_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES bridge_room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_lod4brep_fk CASCADE;
ALTER TABLE bridge_furniture ADD CONSTRAINT bridge_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_lod4impl_fk CASCADE;
ALTER TABLE bridge_furniture ADD CONSTRAINT bridge_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_furn_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_furniture DROP CONSTRAINT IF EXISTS bridge_furn_objclass_fk CASCADE;
ALTER TABLE bridge_furniture ADD CONSTRAINT bridge_furn_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_cityobject_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_objclass_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_bridge_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_brd_room_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_brd_room_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES bridge_room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod2brep_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod3brep_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod4brep_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod2impl_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod3impl_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_inst_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_installation DROP CONSTRAINT IF EXISTS bridge_inst_lod4impl_fk CASCADE;
ALTER TABLE bridge_installation ADD CONSTRAINT bridge_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_cityobject_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_objclass_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_address_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_address_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_address_fk FOREIGN KEY (address_id)
REFERENCES address (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod3msrf_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod4msrf_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod3impl_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_open_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_opening DROP CONSTRAINT IF EXISTS bridge_open_lod4impl_fk CASCADE;
ALTER TABLE bridge_opening ADD CONSTRAINT bridge_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_open_to_them_srf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_open_to_them_srf DROP CONSTRAINT IF EXISTS brd_open_to_them_srf_fk CASCADE;
ALTER TABLE bridge_open_to_them_srf ADD CONSTRAINT brd_open_to_them_srf_fk FOREIGN KEY (bridge_opening_id)
REFERENCES bridge_opening (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_open_to_them_srf_fk1 | type: CONSTRAINT --
-- ALTER TABLE bridge_open_to_them_srf DROP CONSTRAINT IF EXISTS brd_open_to_them_srf_fk1 CASCADE;
ALTER TABLE bridge_open_to_them_srf ADD CONSTRAINT brd_open_to_them_srf_fk1 FOREIGN KEY (bridge_thematic_surface_id)
REFERENCES bridge_thematic_surface (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_room DROP CONSTRAINT IF EXISTS bridge_room_cityobject_fk CASCADE;
ALTER TABLE bridge_room ADD CONSTRAINT bridge_room_cityobject_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_room DROP CONSTRAINT IF EXISTS bridge_room_bridge_fk CASCADE;
ALTER TABLE bridge_room ADD CONSTRAINT bridge_room_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_room DROP CONSTRAINT IF EXISTS bridge_room_lod4msrf_fk CASCADE;
ALTER TABLE bridge_room ADD CONSTRAINT bridge_room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_lod4solid_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_room DROP CONSTRAINT IF EXISTS bridge_room_lod4solid_fk CASCADE;
ALTER TABLE bridge_room ADD CONSTRAINT bridge_room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_room_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_room DROP CONSTRAINT IF EXISTS bridge_room_objclass_fk CASCADE;
ALTER TABLE bridge_room ADD CONSTRAINT bridge_room_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_cityobj_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_cityobj_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_objclass_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_bridge_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_brd_room_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_brd_room_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_room_fk FOREIGN KEY (bridge_room_id)
REFERENCES bridge_room (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_brd_inst_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_brd_inst_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_inst_fk FOREIGN KEY (bridge_installation_id)
REFERENCES bridge_installation (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_brd_const_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_brd_const_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_brd_const_fk FOREIGN KEY (bridge_constr_element_id)
REFERENCES bridge_constr_element (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_lod2msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_lod2msrf_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_lod3msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_lod3msrf_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: brd_them_srf_lod4msrf_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_thematic_surface DROP CONSTRAINT IF EXISTS brd_them_srf_lod4msrf_fk CASCADE;
ALTER TABLE bridge_thematic_surface ADD CONSTRAINT brd_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_cityobj_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_cityobj_fk FOREIGN KEY (id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_bridge_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_bridge_fk FOREIGN KEY (bridge_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod1brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod1brep_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod1brep_fk FOREIGN KEY (lod1_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod2brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod2brep_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod2brep_fk FOREIGN KEY (lod2_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod3brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod3brep_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod3brep_fk FOREIGN KEY (lod3_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod4brep_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod4brep_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod4brep_fk FOREIGN KEY (lod4_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod1impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod1impl_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod2impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod2impl_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod3impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod3impl_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_lod4impl_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_lod4impl_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
REFERENCES implicit_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: bridge_constr_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE bridge_constr_element DROP CONSTRAINT IF EXISTS bridge_constr_objclass_fk CASCADE;
ALTER TABLE bridge_constr_element ADD CONSTRAINT bridge_constr_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_bridge_fk | type: CONSTRAINT --
-- ALTER TABLE address_to_bridge DROP CONSTRAINT IF EXISTS address_to_bridge_fk CASCADE;
ALTER TABLE address_to_bridge ADD CONSTRAINT address_to_bridge_fk FOREIGN KEY (address_id)
REFERENCES address (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: address_to_bridge_fk1 | type: CONSTRAINT --
-- ALTER TABLE address_to_bridge DROP CONSTRAINT IF EXISTS address_to_bridge_fk1 CASCADE;
ALTER TABLE address_to_bridge ADD CONSTRAINT address_to_bridge_fk1 FOREIGN KEY (bridge_id)
REFERENCES bridge (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: cityobject_objectclass_fk | type: CONSTRAINT --
-- ALTER TABLE cityobject DROP CONSTRAINT IF EXISTS cityobject_objectclass_fk CASCADE;
ALTER TABLE cityobject ADD CONSTRAINT cityobject_objectclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: appearance_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE appearance DROP CONSTRAINT IF EXISTS appearance_cityobject_fk CASCADE;
ALTER TABLE appearance ADD CONSTRAINT appearance_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: appearance_citymodel_fk | type: CONSTRAINT --
-- ALTER TABLE appearance DROP CONSTRAINT IF EXISTS appearance_citymodel_fk CASCADE;
ALTER TABLE appearance ADD CONSTRAINT appearance_citymodel_fk FOREIGN KEY (citymodel_id)
REFERENCES citymodel (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: implicit_geom_brep_fk | type: CONSTRAINT --
-- ALTER TABLE implicit_geometry DROP CONSTRAINT IF EXISTS implicit_geom_brep_fk CASCADE;
ALTER TABLE implicit_geometry ADD CONSTRAINT implicit_geom_brep_fk FOREIGN KEY (relative_brep_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_geom_parent_fk | type: CONSTRAINT --
-- ALTER TABLE surface_geometry DROP CONSTRAINT IF EXISTS surface_geom_parent_fk CASCADE;
ALTER TABLE surface_geometry ADD CONSTRAINT surface_geom_parent_fk FOREIGN KEY (parent_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_geom_root_fk | type: CONSTRAINT --
-- ALTER TABLE surface_geometry DROP CONSTRAINT IF EXISTS surface_geom_root_fk CASCADE;
ALTER TABLE surface_geometry ADD CONSTRAINT surface_geom_root_fk FOREIGN KEY (root_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_geom_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE surface_geometry DROP CONSTRAINT IF EXISTS surface_geom_cityobj_fk CASCADE;
ALTER TABLE surface_geometry ADD CONSTRAINT surface_geom_cityobj_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_data_tex_image_fk | type: CONSTRAINT --
-- ALTER TABLE surface_data DROP CONSTRAINT IF EXISTS surface_data_tex_image_fk CASCADE;
ALTER TABLE surface_data ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY (tex_image_id)
REFERENCES tex_image (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: surface_data_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE surface_data DROP CONSTRAINT IF EXISTS surface_data_objclass_fk CASCADE;
ALTER TABLE surface_data ADD CONSTRAINT surface_data_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_parent_fk | type: CONSTRAINT --
-- ALTER TABLE cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_parent_fk CASCADE;
ALTER TABLE cityobject_genericattrib ADD CONSTRAINT genericattrib_parent_fk FOREIGN KEY (parent_genattrib_id)
REFERENCES cityobject_genericattrib (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_root_fk | type: CONSTRAINT --
-- ALTER TABLE cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_root_fk CASCADE;
ALTER TABLE cityobject_genericattrib ADD CONSTRAINT genericattrib_root_fk FOREIGN KEY (root_genattrib_id)
REFERENCES cityobject_genericattrib (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_geom_fk | type: CONSTRAINT --
-- ALTER TABLE cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_geom_fk CASCADE;
ALTER TABLE cityobject_genericattrib ADD CONSTRAINT genericattrib_geom_fk FOREIGN KEY (surface_geometry_id)
REFERENCES surface_geometry (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: genericattrib_cityobj_fk | type: CONSTRAINT --
-- ALTER TABLE cityobject_genericattrib DROP CONSTRAINT IF EXISTS genericattrib_cityobj_fk CASCADE;
ALTER TABLE cityobject_genericattrib ADD CONSTRAINT genericattrib_cityobj_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: ext_ref_cityobject_fk | type: CONSTRAINT --
-- ALTER TABLE external_reference DROP CONSTRAINT IF EXISTS ext_ref_cityobject_fk CASCADE;
ALTER TABLE external_reference ADD CONSTRAINT ext_ref_cityobject_fk FOREIGN KEY (cityobject_id)
REFERENCES cityobject (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_ade_fk | type: CONSTRAINT --
-- ALTER TABLE schema DROP CONSTRAINT IF EXISTS schema_ade_fk CASCADE;
ALTER TABLE schema ADD CONSTRAINT schema_ade_fk FOREIGN KEY (ade_id)
REFERENCES ade (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_to_objectclass_fk1 | type: CONSTRAINT --
-- ALTER TABLE schema_to_objectclass DROP CONSTRAINT IF EXISTS schema_to_objectclass_fk1 CASCADE;
ALTER TABLE schema_to_objectclass ADD CONSTRAINT schema_to_objectclass_fk1 FOREIGN KEY (schema_id)
REFERENCES schema (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_to_objectclass_fk2 | type: CONSTRAINT --
-- ALTER TABLE schema_to_objectclass DROP CONSTRAINT IF EXISTS schema_to_objectclass_fk2 CASCADE;
ALTER TABLE schema_to_objectclass ADD CONSTRAINT schema_to_objectclass_fk2 FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_referencing_fk1 | type: CONSTRAINT --
-- ALTER TABLE schema_referencing DROP CONSTRAINT IF EXISTS schema_referencing_fk1 CASCADE;
ALTER TABLE schema_referencing ADD CONSTRAINT schema_referencing_fk1 FOREIGN KEY (referencing_id)
REFERENCES schema (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: schema_referencing_fk2 | type: CONSTRAINT --
-- ALTER TABLE schema_referencing DROP CONSTRAINT IF EXISTS schema_referencing_fk2 CASCADE;
ALTER TABLE schema_referencing ADD CONSTRAINT schema_referencing_fk2 FOREIGN KEY (referenced_id)
REFERENCES schema (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: aggregation_info_fk1 | type: CONSTRAINT --
-- ALTER TABLE aggregation_info DROP CONSTRAINT IF EXISTS aggregation_info_fk1 CASCADE;
ALTER TABLE aggregation_info ADD CONSTRAINT aggregation_info_fk1 FOREIGN KEY (child_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: aggregation_info_fk2 | type: CONSTRAINT --
-- ALTER TABLE aggregation_info DROP CONSTRAINT IF EXISTS aggregation_info_fk2 CASCADE;
ALTER TABLE aggregation_info ADD CONSTRAINT aggregation_info_fk2 FOREIGN KEY (parent_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --




