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

/*************************************************
* create citydb schema
*
**************************************************/
DROP SCHEMA IF EXISTS citydb CASCADE;
CREATE SCHEMA citydb;


/*************************************************
* create sequences
*
**************************************************/
DROP SEQUENCE IF EXISTS citydb.address_seq;
CREATE SEQUENCE citydb.address_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.appearance_seq;
CREATE SEQUENCE citydb.appearance_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.citymodel_seq;
CREATE SEQUENCE citydb.citymodel_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.cityobject_seq;
CREATE SEQUENCE citydb.cityobject_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.cityobject_genericatt_seq;
CREATE SEQUENCE citydb.cityobject_genericatt_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.external_ref_seq;
CREATE SEQUENCE citydb.external_ref_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.grid_coverage_seq;
CREATE SEQUENCE citydb.grid_coverage_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.implicit_geometry_seq;
CREATE SEQUENCE citydb.implicit_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.surface_data_seq;
CREATE SEQUENCE citydb.surface_data_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.surface_geometry_seq;
CREATE SEQUENCE citydb.surface_geometry_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.tex_image_seq;
CREATE SEQUENCE citydb.tex_image_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;


/*************************************************
* create objectclass table
*
**************************************************/
DROP TABLE IF EXISTS citydb.objectclass CASCADE;
CREATE TABLE citydb.objectclass(
	id integer NOT NULL,
	classname character varying(256),
	superclass_id integer
);


/*************************************************
* create tables new in v3.0.0
*
**************************************************/
-- BRIDGE module
DROP TABLE IF EXISTS citydb.bridge CASCADE;
CREATE TABLE citydb.bridge(
	id INTEGER NOT NULL,
	bridge_parent_id INTEGER,
	bridge_root_id INTEGER,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	year_of_construction DATE,
	year_of_demolition DATE,
	is_movable numeric,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod2_multi_curve geometry(MULTILINESTRINGZ,:srid),
	lod3_multi_curve geometry(MULTILINESTRINGZ,:srid),
	lod4_multi_curve geometry(MULTILINESTRINGZ,:srid),
	lod1_multi_surface_id INTEGER,
	lod2_multi_surface_id INTEGER,
	lod3_multi_surface_id INTEGER,
	lod4_multi_surface_id INTEGER,
	lod1_solid_id INTEGER,
	lod2_solid_id INTEGER,
	lod3_solid_id INTEGER,
	lod4_solid_id INTEGER
);

DROP TABLE IF EXISTS citydb.bridge_constr_element CASCADE;
CREATE TABLE citydb.bridge_constr_element(
	id INTEGER NOT NULL,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	bridge_id INTEGER,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod1_brep_id INTEGER,
	lod2_brep_id INTEGER,
	lod3_brep_id INTEGER,
	lod4_brep_id INTEGER,
	lod1_other_geom geometry(GEOMETRYZ,:srid),
	lod2_other_geom geometry(GEOMETRYZ,:srid),
	lod3_other_geom geometry(GEOMETRYZ,:srid),
	lod4_other_geom geometry(GEOMETRYZ,:srid),
	lod1_implicit_rep_id INTEGER,
	lod2_implicit_rep_id INTEGER,
	lod3_implicit_rep_id INTEGER,
	lod4_implicit_rep_id INTEGER,
	lod1_implicit_ref_point geometry(POINTZ,:srid),
	lod2_implicit_ref_point geometry(POINTZ,:srid),
	lod3_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod1_implicit_transformation VARCHAR(1000),
	lod2_implicit_transformation VARCHAR(1000),
	lod3_implicit_transformation VARCHAR(1000),
	lod4_implicit_transformation VARCHAR(1000)
);

DROP TABLE IF EXISTS citydb.bridge_installation CASCADE;
CREATE TABLE citydb.bridge_installation(
	id INTEGER NOT NULL,
	objectclass_id INTEGER,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	bridge_id INTEGER,
	bridge_room_id INTEGER,
	lod2_brep_id INTEGER,
	lod3_brep_id INTEGER,
	lod4_brep_id INTEGER,
	lod2_other_geom geometry(GEOMETRYZ,:srid),
	lod3_other_geom geometry(GEOMETRYZ,:srid),
	lod4_other_geom geometry(GEOMETRYZ,:srid),
	lod2_implicit_rep_id INTEGER,
	lod3_implicit_rep_id INTEGER,
	lod4_implicit_rep_id INTEGER,
	lod2_implicit_ref_point geometry(POINTZ,:srid),
	lod3_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod2_implicit_transformation VARCHAR(1000),
	lod3_implicit_transformation VARCHAR(1000),
	lod4_implicit_transformation VARCHAR(1000)
);

DROP TABLE IF EXISTS citydb.bridge_thematic_surface CASCADE;
CREATE TABLE citydb.bridge_thematic_surface(
	id INTEGER NOT NULL,
	objectclass_id INTEGER,
	bridge_id INTEGER,
	bridge_room_id INTEGER,
	bridge_installation_id INTEGER,
	bridge_constr_element_id INTEGER,
	lod2_multi_surface_id INTEGER,
	lod3_multi_surface_id INTEGER,
	lod4_multi_surface_id INTEGER
);

DROP TABLE IF EXISTS citydb.bridge_opening CASCADE;
CREATE TABLE citydb.bridge_opening(
	id INTEGER NOT NULL,
	objectclass_id INTEGER,
	address_id INTEGER,
	lod3_multi_surface_id INTEGER,
	lod4_multi_surface_id INTEGER,
	lod3_implicit_rep_id INTEGER,
	lod4_implicit_rep_id INTEGER,
	lod3_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod3_implicit_transformation VARCHAR(1000),
	lod4_implicit_transformation VARCHAR(1000)
);

DROP TABLE IF EXISTS citydb.bridge_open_to_them_srf CASCADE;
CREATE TABLE citydb.bridge_open_to_them_srf(
	bridge_opening_id INTEGER NOT NULL,
	bridge_thematic_surface_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS citydb.bridge_room CASCADE;
CREATE TABLE citydb.bridge_room(
	id INTEGER NOT NULL,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	bridge_id INTEGER NOT NULL,
	lod4_multi_surface_id INTEGER,
	lod4_solid_id INTEGER
);

DROP TABLE IF EXISTS citydb.bridge_furniture CASCADE;
CREATE TABLE citydb.bridge_furniture(
	id INTEGER NOT NULL,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	bridge_room_id INTEGER NOT NULL,
	lod4_brep_id INTEGER,
	lod4_other_geom geometry(GEOMETRYZ,:srid),
	lod4_implicit_rep_id INTEGER,
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_transformation VARCHAR(1000)
);

DROP TABLE IF EXISTS citydb.address_to_bridge CASCADE;
CREATE TABLE citydb.address_to_bridge(
	bridge_id INTEGER NOT NULL,
	address_id INTEGER NOT NULL
);


-- TUNNEL module
DROP TABLE IF EXISTS citydb.tunnel CASCADE;
CREATE TABLE citydb.tunnel(
	id INTEGER NOT NULL,
	tunnel_parent_id INTEGER,
	tunnel_root_id INTEGER,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	year_of_construction DATE,
	year_of_demolition DATE,
	lod1_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod2_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod3_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod4_terrain_intersection geometry(MULTILINESTRINGZ,:srid),
	lod2_multi_curve geometry(MULTILINESTRINGZ,:srid),
	lod3_multi_curve geometry(MULTILINESTRINGZ,:srid),
	lod4_multi_curve geometry(MULTILINESTRINGZ,:srid),
	lod1_multi_surface_id INTEGER,
	lod2_multi_surface_id INTEGER,
	lod3_multi_surface_id INTEGER,
	lod4_multi_surface_id INTEGER,
	lod1_solid_id INTEGER,
	lod2_solid_id INTEGER,
	lod3_solid_id INTEGER,
	lod4_solid_id INTEGER
);

DROP TABLE IF EXISTS citydb.tunnel_installation CASCADE;
CREATE TABLE citydb.tunnel_installation(
	id INTEGER NOT NULL,
	objectclass_id INTEGER,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	tunnel_id INTEGER,
	tunnel_hollow_space_id INTEGER,
	lod2_brep_id INTEGER,
	lod3_brep_id INTEGER,
	lod4_brep_id INTEGER,
	lod2_other_geom geometry(GEOMETRYZ,:srid),
	lod3_other_geom geometry(GEOMETRYZ,:srid),
	lod4_other_geom geometry(GEOMETRYZ,:srid),
	lod2_implicit_rep_id INTEGER,
	lod3_implicit_rep_id INTEGER,
	lod4_implicit_rep_id INTEGER,
	lod2_implicit_ref_point geometry(POINTZ,:srid),
	lod3_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod2_implicit_transformation VARCHAR(1000),
	lod3_implicit_transformation VARCHAR(1000),
	lod4_implicit_transformation VARCHAR(1000)
);

DROP TABLE IF EXISTS citydb.tunnel_thematic_surface CASCADE;
CREATE TABLE citydb.tunnel_thematic_surface(
	id INTEGER NOT NULL,
	objectclass_id INTEGER,
	tunnel_id INTEGER,
	tunnel_hollow_space_id INTEGER,
	tunnel_installation_id INTEGER,
	lod2_multi_surface_id INTEGER,
	lod3_multi_surface_id INTEGER,
	lod4_multi_surface_id INTEGER
);

DROP TABLE IF EXISTS citydb.tunnel_opening CASCADE;
CREATE TABLE citydb.tunnel_opening(
	id INTEGER NOT NULL,
	objectclass_id INTEGER,
	lod3_multi_surface_id INTEGER,
	lod4_multi_surface_id INTEGER,
	lod3_implicit_rep_id INTEGER,
	lod4_implicit_rep_id INTEGER,
	lod3_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod3_implicit_transformation VARCHAR(1000),
	lod4_implicit_transformation VARCHAR(1000)
);

DROP TABLE IF EXISTS citydb.tunnel_open_to_them_srf CASCADE;
CREATE TABLE citydb.tunnel_open_to_them_srf(
	tunnel_opening_id INTEGER NOT NULL,
	tunnel_thematic_surface_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS citydb.tunnel_hollow_space CASCADE;
CREATE TABLE citydb.tunnel_hollow_space(
	id INTEGER NOT NULL,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	tunnel_id INTEGER NOT NULL,
	lod4_multi_surface_id INTEGER,
	lod4_solid_id INTEGER
);

DROP TABLE IF EXISTS citydb.tunnel_furniture CASCADE;
CREATE TABLE citydb.tunnel_furniture(
	id INTEGER NOT NULL,
	class VARCHAR(256),
	class_codespace VARCHAR(4000),
	function VARCHAR(1000),
	function_codespace VARCHAR(4000),
	usage VARCHAR(1000),
	usage_codespace VARCHAR(4000),
	tunnel_hollow_space_id INTEGER NOT NULL,
	lod4_brep_id INTEGER,
	lod4_other_geom geometry(GEOMETRYZ,:srid),
	lod4_implicit_rep_id INTEGER,
	lod4_implicit_ref_point geometry(POINTZ,:srid),
	lod4_implicit_transformation VARCHAR(1000)
);

-- global table for raster data
DROP TABLE IF EXISTS citydb.grid_coverage CASCADE;
CREATE TABLE citydb.grid_coverage(
	id INTEGER NOT NULL DEFAULT nextval('citydb.grid_coverage_seq'::regclass),
	rasterproperty RASTER
);