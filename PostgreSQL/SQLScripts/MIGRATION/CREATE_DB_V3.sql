-- CREATE_DB_V3.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2014-12-28   release version                             FKun
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
	superclass_id integer,
	CONSTRAINT objectclass_pk PRIMARY KEY (id)
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
	lod4_solid_id INTEGER,
	CONSTRAINT bridge_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT bridge_constr_element_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT bridge_installation_pk PRIMARY KEY (id)
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
	lod4_multi_surface_id INTEGER,
	CONSTRAINT bridge_thematic_surface_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT bridge_opening_pk PRIMARY KEY (id)
);

DROP TABLE IF EXISTS citydb.bridge_open_to_them_srf CASCADE;
CREATE TABLE citydb.bridge_open_to_them_srf(
	bridge_opening_id INTEGER NOT NULL,
	bridge_thematic_surface_id INTEGER NOT NULL,
	CONSTRAINT bridge_open_to_them_srf_pk PRIMARY KEY (bridge_opening_id,bridge_thematic_surface_id)

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
	lod4_solid_id INTEGER,
	CONSTRAINT bridge_room_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT bridge_furniture_pk PRIMARY KEY (id)
);

DROP TABLE IF EXISTS citydb.address_to_bridge CASCADE;
CREATE TABLE citydb.address_to_bridge(
	bridge_id INTEGER,
	address_id INTEGER,
	CONSTRAINT address_to_bridge_pk PRIMARY KEY (bridge_id,address_id)
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
	lod4_solid_id INTEGER,
	CONSTRAINT tunnel_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT tunnel_installation_pk PRIMARY KEY (id)
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
	lod4_multi_surface_id INTEGER,
	CONSTRAINT tunnel_thematic_surface_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT tunnel_opening_pk PRIMARY KEY (id)
);

DROP TABLE IF EXISTS citydb.tunnel_open_to_them_srf CASCADE;
CREATE TABLE citydb.tunnel_open_to_them_srf(
	tunnel_opening_id INTEGER NOT NULL,
	tunnel_thematic_surface_id INTEGER NOT NULL,
	CONSTRAINT tunnel_open_to_them_srf_pk PRIMARY KEY (tunnel_opening_id,tunnel_thematic_surface_id)
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
	lod4_solid_id INTEGER,
	CONSTRAINT tunnel_hollow_space_pk PRIMARY KEY (id)
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
	lod4_implicit_transformation VARCHAR(1000),
	CONSTRAINT tunnel_furniture_pk PRIMARY KEY (id)
);


-- additional table for textures
DROP TABLE IF EXISTS citydb.tex_image CASCADE;
CREATE TABLE citydb.tex_image(
	id INTEGER NOT NULL DEFAULT nextval('citydb.tex_image_seq'::regclass),
	tex_image_uri VARCHAR(4000),
	tex_image_data BYTEA,
	tex_mime_type VARCHAR(256),
	tex_mime_type_codespace VARCHAR(4000),
	CONSTRAINT tex_image_pk PRIMARY KEY (id)
);


-- global table for raster data
DROP TABLE IF EXISTS citydb.grid_coverage CASCADE;
CREATE TABLE citydb.grid_coverage(
	id INTEGER NOT NULL DEFAULT nextval('citydb.grid_coverage_seq'::regclass),
	rasterproperty RASTER,
	CONSTRAINT grid_coverage_pk PRIMARY KEY (id)
);