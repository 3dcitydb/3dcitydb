-- MIGRATE_DB_V2_V3.sql
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

-- BUILDING module
DROP TABLE IF EXISTS citydb.building CASCADE;
CREATE TABLE citydb.building (
	id,
	building_parent_id,
	building_root_id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	year_of_construction,
	year_of_demolition,
	roof_type,
	roof_type_codespace,
	measured_height,
	measured_height_unit,
	storeys_above_ground,
	storeys_below_ground,
	storey_heights_above_ground,
	storey_heights_ag_unit,
	storey_heights_below_ground,
	storey_heights_bg_unit,
	lod1_terrain_intersection,
	lod2_terrain_intersection,
	lod3_terrain_intersection,
	lod4_terrain_intersection,
	lod2_multi_curve,
	lod3_multi_curve,
	lod4_multi_curve,
	lod0_footprint_id,
	lod0_roofprint_id,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	lod1_solid_id,
	lod2_solid_id,
	lod3_solid_id,
	lod4_solid_id)
  AS SELECT 
	id, 
	building_parent_id, 
	building_root_id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	year_of_construction,
	year_of_demolition,
	roof_type, 
	NULL::varchar(4000),
	measured_height, 
	NULL::varchar(4000),
	storeys_above_ground,
	storeys_below_ground,
	storey_heights_above_ground, 
	NULL::varchar(4000),
	storey_heights_below_ground, 
	NULL::varchar(4000),
	lod1_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod2_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod3_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod4_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod2_multi_curve::geometry(MULTILINESTRINGZ,:srid), 
	lod3_multi_curve::geometry(MULTILINESTRINGZ,:srid),
	lod4_multi_curve::geometry(MULTILINESTRINGZ,:srid),
	NULL::integer, 
	NULL::integer,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod1_geometry_id AND is_solid = 0) 
		THEN lod1_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod2_geometry_id AND is_solid = 0) 
		THEN lod2_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod3_geometry_id AND is_solid = 0) 
		THEN lod3_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 0) 
		THEN lod4_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod1_geometry_id AND is_solid = 1) 
		THEN lod1_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod2_geometry_id AND is_solid = 1)
		THEN lod2_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod3_geometry_id AND is_solid = 1) 
		THEN lod3_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 1) 
		THEN lod4_geometry_id ELSE NULL::integer END
    FROM public.building;

DROP TABLE IF EXISTS citydb.building_installation CASCADE;
CREATE TABLE citydb.building_installation (
	id,
	objectclass_id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	building_id,
	room_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id,
	lod2_other_geom,
	lod3_other_geom,
	lod4_other_geom,
	lod2_implicit_rep_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod2_implicit_transformation,
	lod3_implicit_transformation,
	lod4_implicit_transformation)
  AS SELECT
	id,
	CASE WHEN is_external = 1 THEN 27::integer ELSE 28::integer END,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	building_id,
	room_id,
	lod2_geometry_id,
	lod3_geometry_id,
	lod4_geometry_id,
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::integer,
	NULL::integer,
	NULL::integer,
	NULL::geometry(POINTZ,:srid),
	NULL::geometry(POINTZ,:srid),
	NULL::geometry(POINTZ,:srid),
	NULL::varchar(1000),
	NULL::varchar(1000),
	NULL::varchar(1000)
    FROM public.building_installation;

DROP TABLE IF EXISTS citydb.thematic_surface CASCADE;
CREATE TABLE citydb.thematic_surface (
	id,
	objectclass_id,
	building_id,
	room_id,
	building_installation_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id)
  AS SELECT
	id,
	CASE 
	WHEN type = 'CeilingSurface' THEN 30::integer
	WHEN type = 'InteriorWallSurface' THEN 31::integer
	WHEN type = 'FloorSurface' THEN 32::integer
	WHEN type = 'RoofSurface' THEN 33::integer
	WHEN type = 'WallSurface' THEN 34::integer
	WHEN type = 'GroundSurface' THEN 35::integer
	WHEN type = 'ClosureSurface' THEN 36::integer
	END,
	building_id,
	room_id,
	NULL::integer,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id
	FROM public.thematic_surface;

DROP TABLE IF EXISTS citydb.opening CASCADE;
CREATE TABLE citydb.opening(
	id,
	objectclass_id,
	address_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod3_implicit_transformation,
	lod4_implicit_transformation)
  AS SELECT
	id,
	CASE WHEN type = 'Window' THEN 38::integer ELSE 39::integer END,
	address_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	NULL::integer,
	NULL::integer,
	NULL::geometry(POINTZ,:srid),
	NULL::geometry(POINTZ,:srid),
	NULL::varchar(1000),
	NULL::varchar(1000)
	FROM public.opening;

DROP TABLE IF EXISTS citydb.opening_to_them_surface CASCADE;
CREATE TABLE citydb.opening_to_them_surface AS
  SELECT opening_id, thematic_surface_id
    FROM public.opening_to_them_surface;

DROP TABLE IF EXISTS citydb.room CASCADE;
CREATE TABLE citydb.room (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	building_id,
	lod4_multi_surface_id,
	lod4_solid_id)
  AS SELECT
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	building_id,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 0) 
		THEN lod4_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 1) 
		THEN lod4_geometry_id ELSE NULL::integer END
	FROM public.room;

DROP TABLE IF EXISTS citydb.building_furniture CASCADE;
CREATE TABLE citydb.building_furniture (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	room_id,
	lod4_brep_id,
	lod4_other_geom,
	lod4_implicit_rep_id,
	lod4_implicit_ref_point,
	lod4_implicit_transformation)
  AS SELECT
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	room_id,
	lod4_geometry_id,
	NULL::geometry(GEOMETRYZ,:srid),
	lod4_implicit_rep_id,
	lod4_implicit_ref_point,
	lod4_implicit_transformation
    FROM public.building_furniture;

DROP TABLE IF EXISTS citydb.address_to_building CASCADE;
CREATE TABLE citydb.address_to_building AS
  SELECT building_id, address_id
    FROM public.address_to_building;


-- CITY FURNITURE module
DROP TABLE IF EXISTS citydb.city_furniture CASCADE;
CREATE TABLE citydb.city_furniture (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	lod1_terrain_intersection,
	lod2_terrain_intersection,
	lod3_terrain_intersection,
	lod4_terrain_intersection,
	lod1_brep_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id,
	lod1_other_geom,
	lod2_other_geom,
	lod3_other_geom,
	lod4_other_geom,
	lod1_implicit_rep_id,
	lod2_implicit_rep_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod1_implicit_ref_point,
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod1_implicit_transformation,
	lod2_implicit_transformation,
	lod3_implicit_transformation,
	lod4_implicit_transformation)
  AS SELECT 
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	NULL::varchar(256),
	NULL::varchar(4000),
	lod1_terrain_intersection::geometry(MULTILINESTRINGZ,:srid), 
	lod2_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod3_terrain_intersection::geometry(MULTILINESTRINGZ,:srid), 
	lod4_terrain_intersection::geometry(MULTILINESTRINGZ,:srid), 
	lod1_geometry_id,
	lod2_geometry_id,
	lod3_geometry_id,
	lod1_geometry_id,
	NULL::geometry(GEOMETRYZ,:srid), 
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	lod1_implicit_rep_id, 
	lod2_implicit_rep_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod1_implicit_ref_point,
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod1_implicit_transformation,
	lod2_implicit_transformation,
	lod3_implicit_transformation,
	lod4_implicit_transformation
    FROM public.city_furniture;


-- TRANSPORTATION module
DROP TABLE IF EXISTS citydb.transportation_complex CASCADE;
CREATE TABLE citydb.transportation_complex (
	id,
	objectclass_id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	lod0_network,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id)
  AS SELECT
	id,
	CASE 
	WHEN type = 'Track' THEN 43::integer
	WHEN type = 'Railway' THEN 44::integer
	WHEN type = 'Road' THEN 45::integer
	WHEN type = 'Square' THEN 46::integer
	END,
	NULL::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	lod0_network,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id
	FROM public.transportation_complex;

DROP TABLE IF EXISTS citydb.traffic_area CASCADE;
CREATE TABLE citydb.traffic_area (
	id,
	objectclass_id ,
	class ,
	class_codespace ,
	function ,
	function_codespace ,
	usage ,
	usage_codespace ,
	surface_material ,
	surface_material_codespace ,
	lod2_multi_surface_id ,
	lod3_multi_surface_id ,
	lod4_multi_surface_id ,
	transportation_complex_id)
  AS SELECT
	id,
	CASE WHEN is_auxiliary = 1 THEN 48::integer ELSE 47::integer END,
	NULL::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	surface_material,
	NULL::varchar(4000),
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	transportation_complex_id
	FROM public.traffic_area;


-- VEGETATION module
DROP TABLE IF EXISTS citydb.plant_cover CASCADE;
CREATE TABLE citydb.plant_cover (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	average_height,
	average_height_unit,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	lod1_multi_solid_id,
	lod2_multi_solid_id,
	lod3_multi_solid_id,
	lod4_multi_solid_id)
  AS SELECT
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	NULL::varchar(256),
	NULL::varchar(4000),
	average_height,
	NULL::varchar(4000),
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod1_geometry_id AND is_solid = 0) 
		THEN lod1_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod2_geometry_id AND is_solid = 0) 
		THEN lod2_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod3_geometry_id AND is_solid = 0) 
		THEN lod3_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 0) 
		THEN lod4_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod1_geometry_id AND is_solid = 1) 
		THEN lod1_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod2_geometry_id AND is_solid = 1)
		THEN lod2_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod3_geometry_id AND is_solid = 1) 
		THEN lod3_geometry_id ELSE NULL::integer END,
	CASE WHEN EXISTS 
		(SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 1) 
		THEN lod4_geometry_id ELSE NULL::integer END
	FROM public.plant_cover;

DROP TABLE IF EXISTS citydb.solitary_vegetat_object CASCADE;
CREATE TABLE citydb.solitary_vegetat_object (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	species,
	species_codespace,
	height,
	height_unit,
	trunk_diameter,
	trunk_diameter_unit,
	crown_diameter,
	crown_diameter_unit,
	lod1_brep_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id,
	lod1_other_geom,
	lod2_other_geom,
	lod3_other_geom,
	lod4_other_geom,
	lod1_implicit_rep_id,
	lod2_implicit_rep_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod1_implicit_ref_point,
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod1_implicit_transformation,
	lod2_implicit_transformation,
	lod3_implicit_transformation,
	lod4_implicit_transformation)
  AS SELECT
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	NULL::varchar(256),
	NULL::varchar(4000),
	species,
	NULL::varchar(4000),
	height,
	NULL::varchar(4000),
	trunc_diameter,
	NULL::varchar(4000),
	crown_diameter,
	NULL::varchar(4000),
	lod1_geometry_id,
	lod2_geometry_id,
	lod3_geometry_id,
	lod4_geometry_id,
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	lod1_implicit_rep_id,
	lod2_implicit_rep_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod1_implicit_ref_point,
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod1_implicit_transformation,
	lod2_implicit_transformation,
	lod3_implicit_transformation,
	lod4_implicit_transformation
	FROM public.solitary_vegetat_object;

	
-- WATERBODY module
DROP TABLE IF EXISTS citydb.waterbody CASCADE;
CREATE TABLE citydb.waterbody (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	lod0_multi_curve,
	lod1_multi_curve,
	lod0_multi_surface_id,
	lod1_multi_surface_id,
	lod1_solid_id,
	lod2_solid_id,
	lod3_solid_id,
	lod4_solid_id)
  AS SELECT
  	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	lod0_multi_curve::geometry(MULTILINESTRINGZ,:srid),
	lod1_multi_curve::geometry(MULTILINESTRINGZ,:srid),
	lod0_multi_surface_id,
	lod1_multi_surface_id,
	lod1_solid_id,
	lod2_solid_id,
	lod3_solid_id,
	lod4_solid_id
	FROM public.waterbody;

DROP TABLE IF EXISTS citydb.waterboundary_surface CASCADE;
CREATE TABLE citydb.waterboundary_surface (
	id,
	objectclass_id,
	water_level,
	water_level_codespace,
	lod2_surface_id,
	lod3_surface_id,
	lod4_surface_id)
  AS SELECT
	id,
	CASE 
	WHEN type = 'WaterSurface' THEN 11::integer
	WHEN type = 'WaterGroundSurface' THEN 12::integer
	WHEN type = 'WaterClosureSurface' THEN 13::integer
	END,
	water_level,
	NULL::varchar(4000),
	lod2_surface_id,
	lod3_surface_id,
	lod4_surface_id
  FROM public.waterboundary_surface;

DROP TABLE IF EXISTS citydb.waterbod_to_waterbnd_srf CASCADE;
CREATE TABLE citydb.waterbod_to_waterbnd_srf AS
  SELECT waterboundary_surface_id, waterbody_id
    FROM public.waterbod_to_waterbnd_srf;


-- LAND USE module
DROP TABLE IF EXISTS citydb.land_use CASCADE;
CREATE TABLE citydb.land_use (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	lod0_multi_surface_id,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id)
  AS SELECT
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	lod0_multi_surface_id,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id
	FROM public.land_use;


-- RELIEF module
DROP TABLE IF EXISTS citydb.relief_feature CASCADE;
CREATE TABLE citydb.relief_feature AS 
  SELECT id, lod
    FROM public.relief_feature;

DROP TABLE IF EXISTS citydb.relief_component CASCADE;
CREATE TABLE citydb.relief_component(
	id,
	objectclass_id,
	lod,
	extent)
  AS SELECT 
	id,
	CASE 
	WHEN EXISTS (SELECT 1 FROM public.tin_relief tr WHERE tr.id = id) THEN 16::integer
	WHEN EXISTS (SELECT 1 FROM public.masspoint_relief mpr WHERE mpr.id = id) THEN 17::integer
	WHEN EXISTS (SELECT 1 FROM public.breakline_relief blr WHERE blr.id = id) THEN 18::integer
	WHEN EXISTS (SELECT 1 FROM public.raster_relief rr WHERE rr.id = id) THEN 19::integer
	END,
	lod,
	extent::geometry(POLYGON,:srid)
	FROM public.relief_component;

DROP TABLE IF EXISTS citydb.relief_feat_to_rel_comp CASCADE;
CREATE TABLE citydb.relief_feat_to_rel_comp AS
  SELECT relief_component_id, relief_feature_id
    FROM public.relief_feat_to_rel_comp;

DROP TABLE IF EXISTS citydb.tin_relief CASCADE;
CREATE TABLE citydb.tin_relief (
	id,
	max_length,
	max_length_unit,
	stop_lines,
	break_lines,
	control_points,
	surface_geometry_id)
  AS SELECT
  	id,
	max_length,
	NULL::varchar(4000),
	stop_lines::geometry(MULTILINESTRINGZ,:srid),
	break_lines::geometry(MULTILINESTRINGZ,:srid),
	control_points,
	surface_geometry_id
	FROM public.tin_relief;

DROP TABLE IF EXISTS citydb.masspoint_relief CASCADE;
CREATE TABLE citydb.masspoint_relief AS
  SELECT id, relief_points
    FROM public.masspoint_relief;

DROP TABLE IF EXISTS citydb.breakline_relief CASCADE;
CREATE TABLE citydb.breakline_relief AS
  SELECT 
	id,
	ridge_or_valley_lines::geometry(MULTILINESTRINGZ,:srid),
	break_lines::geometry(MULTILINESTRINGZ,:srid)
	FROM public.breakline_relief;

-- no mapping for raster_relief table
DROP TABLE IF EXISTS citydb.raster_relief CASCADE;
CREATE TABLE citydb.raster_relief(
	id INTEGER NOT NULL,
	raster_uri VARCHAR(4000),
	coverage_id INTEGER,
	CONSTRAINT raster_relief_pk PRIMARY KEY (id)
);


-- CITYOBJECTGROUP module
DROP TABLE IF EXISTS citydb.cityobjectgroup CASCADE;
CREATE TABLE citydb.cityobjectgroup (
	id, 
	class,
	class_codespace,
	function, 
	function_codespace,
	usage,
	usage_codespace,
	brep_id,
	other_geom,
	parent_cityobject_id)
  AS SELECT 
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	surface_geometry_id,
	geometry::geometry(GEOMETRYZ,:srid),
	parent_cityobject_id
    FROM public.cityobjectgroup;

DROP TABLE IF EXISTS citydb.group_to_cityobject CASCADE;
CREATE TABLE citydb.group_to_cityobject AS
  SELECT cityobject_id, cityobjectgroup_id, role
    FROM public.group_to_cityobject;


-- GENERICS module
DROP TABLE IF EXISTS citydb.generic_cityobject CASCADE;
CREATE TABLE citydb.generic_cityobject (
	id,
	class,
	class_codespace,
	function,
	function_codespace,
	usage,
	usage_codespace,
	lod0_terrain_intersection,
	lod1_terrain_intersection,
	lod2_terrain_intersection,
	lod3_terrain_intersection,
	lod4_terrain_intersection,
	lod0_brep_id,
	lod1_brep_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id,
	lod0_other_geom,
	lod1_other_geom,
	lod2_other_geom,
	lod3_other_geom,
	lod4_other_geom,
	lod0_implicit_rep_id,
	lod1_implicit_rep_id,
	lod2_implicit_rep_id,
	lod3_implicit_rep_id,
	lod4_implicit_rep_id,
	lod0_implicit_ref_point,
	lod1_implicit_ref_point,
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod0_implicit_transformation,
	lod1_implicit_transformation,
	lod2_implicit_transformation,
	lod3_implicit_transformation,
	lod4_implicit_transformation)
  AS SELECT
	id,
	replace(class, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(function, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	replace(usage, ' ', '--/\--')::varchar(256),
	NULL::varchar(4000),
	lod0_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod1_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod2_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod3_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod4_terrain_intersection::geometry(MULTILINESTRINGZ,:srid),
	lod0_geometry_id,
	lod1_geometry_id,
	lod2_geometry_id,
	lod3_geometry_id,
	lod4_geometry_id,
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	NULL::geometry(GEOMETRYZ,:srid),
	lod0_implicit_rep_id,
	lod1_implicit_rep_id, 
	lod2_implicit_rep_id,
	lod3_implicit_rep_id, 
	lod4_implicit_rep_id,
	lod0_implicit_ref_point,
	lod1_implicit_ref_point, 
	lod2_implicit_ref_point,
	lod3_implicit_ref_point,
	lod4_implicit_ref_point,
	lod0_implicit_transformation,
	lod1_implicit_transformation,
	lod2_implicit_transformation, 
	lod3_implicit_transformation,
	lod4_implicit_transformation
	FROM public.generic_cityobject;

DROP TABLE IF EXISTS citydb.cityobject_genericattrib CASCADE;
CREATE TABLE citydb.cityobject_genericattrib (
	id,
	parent_genattrib_id,
	root_genattrib_id,
	attrname,
	datatype,
	strval,
	intval,
	realval,
	urival,
	dateval,
	unit,
	genattribset_codespace,
	blobval,
	geomval,
	surface_geometry_id,
	cityobject_id)
  AS SELECT
	id,
	NULL::integer,
	id,
	attrname,
	datatype,
	strval,
	intval,
	realval,
	urival,
	dateval::timestamp with time zone,
	NULL::varchar(4000),
	NULL::varchar(4000),
	blobval,
	geomval,
	surface_geometry_id,
	cityobject_id
	FROM public.cityobject_genericattrib;


-- APPEARANCE module
DROP TABLE IF EXISTS citydb.appearance CASCADE;
CREATE TABLE citydb.appearance AS
  SELECT id, gmlid,	name, name_codespace, description, theme, citymodel_id, cityobject_id
    FROM public.appearance;

DROP TABLE IF EXISTS citydb.surface_data CASCADE;
CREATE TABLE citydb.surface_data (
	id,
	gmlid,
	name,
	name_codespace,
	description,
	is_front,
	objectclass_id,
	x3d_shininess,
	x3d_transparency,
	x3d_ambient_intensity,
	x3d_specular_color,
	x3d_diffuse_color,
	x3d_emissive_color,
	x3d_is_smooth,
	tex_image_id,
	tex_texture_type,
	tex_wrap_mode,
	tex_border_color,
	gt_prefer_worldfile,
	gt_orientation,
	gt_reference_point)
  AS SELECT
	id,
	gmlid,
	name,
	name_codespace,
	description,
	is_front,
	CASE 
	WHEN type = 'X3DMaterial' THEN 53::integer
	WHEN type = 'ParameterizedTexture' THEN 54::integer
	WHEN type = 'GeoreferencedTexture' THEN 55::integer
	END,
	x3d_shininess,
	x3d_transparency,
	x3d_ambient_intensity,
	x3d_specular_color,
	x3d_diffuse_color,
	x3d_emissive_color,
	x3d_is_smooth,
	NULL::integer,
	tex_texture_type,
	tex_wrap_mode,
	tex_border_color,
	gt_prefer_worldfile,
	gt_orientation,
	gt_reference_point
	FROM public.surface_data;

DROP TABLE IF EXISTS citydb.appear_to_surface_data CASCADE;
CREATE TABLE citydb.appear_to_surface_data AS 
  SELECT surface_data_id, appearance_id
    FROM public.appear_to_surface_data;

DROP TABLE IF EXISTS citydb.textureparam CASCADE;
CREATE TABLE citydb.textureparam (
	surface_geometry_id, 
	is_texture_parametrization, 
	world_to_texture,
	texture_coordinates,
	surface_data_id)
  AS SELECT 
	surface_geometry_id, 
	is_texture_parametrization, 
	world_to_texture,
	geodb_pkg.texCoordsToGeom(texture_coordinates)::geometry(POLYGON),
	surface_data_id
    FROM public.textureparam;

-- create reference between surface_data and tex_image
SELECT geodb_pkg.migrate_tex_image(min(id)) FROM public.surface_data GROUP BY tex_image_uri;


-- CORE module
DROP TABLE IF EXISTS citydb.citymodel CASCADE;
CREATE TABLE citydb.citymodel (
	id,
	gmlid,
	name,
	name_codespace,
	description,
	envelope,
	creation_date,
	termination_date,
	last_modification_date,
	updating_person,
	reason_for_update,
	lineage)
  AS SELECT
  	id,
	gmlid,
	name,
	name_codespace,
	description,
	envelope,
	creation_date::timestamp with time zone,
	termination_date::timestamp with time zone,
	last_modification_date::timestamp with time zone,
	updating_person,
	reason_for_update,
	lineage
	FROM public.citymodel;

DROP TABLE IF EXISTS citydb.cityobject CASCADE;
CREATE TABLE citydb.cityobject (
	id,
	objectclass_id,
	gmlid,
	name,
	name_codespace,
	description,
	envelope,
	creation_date,
	termination_date,
	relative_to_terrain,
	relative_to_water,
	last_modification_date,
	updating_person,
	reason_for_update,
	lineage,
	xml_source)
  AS SELECT
	co.id,
	co.class_id,
	co.gmlid,
	mco.co_name,
	mco.co_name_codespace,
	mco.co_description,
	co.envelope,
	co.creation_date::timestamp with time zone,
	co.termination_date::timestamp with time zone,
	NULL::varchar(256),
	NULL::varchar(256),
	co.last_modification_date::timestamp with time zone,
	co.updating_person,
	co.reason_for_update,
	co.lineage,
	co.xml_source
	FROM public.cityobject co, geodb_pkg.migrate_cityobject(co.id, co.class_id) mco
	WHERE co.id = mco.co_id;

DROP TABLE IF EXISTS citydb.cityobject_member CASCADE;
CREATE TABLE citydb.cityobject_member AS
  SELECT citymodel_id, cityobject_id 
    FROM public.cityobject_member;

DROP TABLE IF EXISTS citydb.generalization CASCADE;
CREATE TABLE citydb.generalization AS
  SELECT cityobject_id,	generalizes_to_id
    FROM public.generalization;

DROP TABLE IF EXISTS citydb.surface_geometry CASCADE;
CREATE TABLE citydb.surface_geometry (
	id,
	gmlid,
	parent_id,
	root_id,
	is_solid,
	is_composite,
	is_triangulated,
	is_xlink,
	is_reverse,
	geometry,
	solid_geometry,
	implicit_geometry,
	cityobject_id)
  AS SELECT
	id,
	gmlid,
	parent_id,
	root_id,
	is_solid,
	is_composite,
	is_triangulated,
	is_xlink,
	is_reverse,
	geometry,
	NULL::geometry(POLYHEDRALSURFACEZ,:srid),
	NULL::geometry(POLYGONZ),
	NULL::integer
	FROM public.surface_geometry;

-- constructing 3D geometry
WITH get_solids AS (
  SELECT root_id FROM citydb.surface_geometry WHERE is_solid = 1
)
UPDATE citydb.surface_geometry SET solid_geometry = 
  (SELECT ST_GeomFromText(replace(ST_AsText(ST_Collect(sg.geometry)), 'MULTIPOLYGON','POLYHEDRALSURFACE'))
     FROM citydb.surface_geometry sg, get_solids gs WHERE sg.root_id = gs.root_id);

DROP TABLE IF EXISTS citydb.implicit_geometry CASCADE;
CREATE TABLE citydb.implicit_geometry (
	id,
	mime_type,
	reference_to_library,
	library_object,
	relative_brep_id,
	relative_other_geom)
  AS SELECT
	id,
	mime_type,
	reference_to_library,
	library_object bytea,
	relative_geometry_id,
	NULL::geometry(GEOMETRYZ)
	FROM public.implicit_geometry;

DROP TABLE IF EXISTS citydb.external_reference CASCADE;
CREATE TABLE citydb.external_reference AS
  SELECT id, infosys, name,	uri, cityobject_id
    FROM public.external_reference;

DROP TABLE IF EXISTS citydb.address CASCADE;
CREATE TABLE citydb.address AS
  SELECT id, street, house_number, po_box, zip_code, city, state, country, multi_point, xal_source
    FROM public.address;


-- metadata table
DROP TABLE IF EXISTS citydb.database_srs CASCADE;
CREATE TABLE citydb.database_srs AS
  SELECT srid, gml_srs_name
    FROM public.database_srs;


-- create reference between cityobject and surface_geometry table

-- BUILDING module
WITH building_ref AS (
  SELECT 
	id, ARRAY[
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	lod1_solid_id,
	lod2_solid_id,
	lod3_solid_id,
	lod4_solid_id] AS arr
	FROM citydb.building
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM building_ref ref WHERE root_id = ANY (ref.arr);

WITH building_installation_ref AS (
  SELECT 
	id, ARRAY[
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id] AS arr
	FROM citydb.building_installation
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM building_installation_ref ref WHERE root_id = ANY (ref.arr);

WITH thematic_surface_ref AS (
  SELECT 
	id, ARRAY[
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id] AS arr
	FROM citydb.thematic_surface
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM thematic_surface_ref ref WHERE root_id = ANY (ref.arr);

WITH opening_ref AS (
  SELECT 
	id, ARRAY[
	lod3_multi_surface_id,
	lod4_multi_surface_id] AS arr
	FROM citydb.opening
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM opening_ref ref WHERE root_id = ANY (ref.arr);

WITH room_ref AS (
  SELECT 
	id, ARRAY[
	lod4_multi_surface_id,
	lod4_solid_id] AS arr
	FROM citydb.room
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM room_ref ref WHERE root_id = ANY (ref.arr);

WITH building_furniture_ref AS (
  SELECT 
	id,
	lod4_brep_id
	FROM citydb.building_furniture
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM building_furniture_ref ref WHERE root_id = ref.lod4_brep_id;


-- CITY FURNITURE module
WITH city_furniture_ref AS (
  SELECT 
	id, ARRAY[
	lod1_brep_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id] AS arr
	FROM citydb.city_furniture
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM city_furniture_ref ref WHERE root_id = ANY (ref.arr);


-- TRANSPORTATION module
WITH transportation_complex_ref AS (
  SELECT 
	id, ARRAY[
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id] AS arr
	FROM citydb.transportation_complex
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM transportation_complex_ref ref WHERE root_id = ANY (ref.arr);

WITH traffic_area_ref AS (
  SELECT 
	id, ARRAY[
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id] AS arr
	FROM citydb.traffic_area
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM traffic_area_ref ref WHERE root_id = ANY (ref.arr);


-- VEGETATION module
WITH plant_cover_ref AS (
  SELECT 
	id, ARRAY[
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id,
	lod1_multi_solid_id,
	lod2_multi_solid_id,
	lod3_multi_solid_id,
	lod4_multi_solid_id] AS arr
	FROM citydb.plant_cover
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM plant_cover_ref ref WHERE root_id = ANY (ref.arr);

WITH solitary_vegetat_object_ref AS (
  SELECT 
	id, ARRAY[
	lod1_brep_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id] AS arr
	FROM citydb.solitary_vegetat_object
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM solitary_vegetat_object_ref ref WHERE root_id = ANY (ref.arr);


-- WATERBODY module
WITH waterbody_ref AS (
  SELECT 
	id, ARRAY[
	lod0_multi_surface_id,
	lod1_multi_surface_id,
	lod1_solid_id,
	lod2_solid_id,
	lod3_solid_id,
	lod4_solid_id] AS arr
	FROM citydb.waterbody
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM waterbody_ref ref WHERE root_id = ANY (ref.arr);

WITH waterboundary_surface_ref AS (
  SELECT 
	id, ARRAY[
	lod2_surface_id,
	lod3_surface_id,
	lod4_surface_id] AS arr
	FROM citydb.waterboundary_surface
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM waterboundary_surface_ref ref WHERE root_id = ANY (ref.arr);


-- LAND USE module
WITH land_use_ref AS (
  SELECT 
	id, ARRAY[
	lod0_multi_surface_id,
	lod1_multi_surface_id,
	lod2_multi_surface_id,
	lod3_multi_surface_id,
	lod4_multi_surface_id] AS arr
	FROM citydb.land_use
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM land_use_ref ref WHERE root_id = ANY (ref.arr);


-- RELIEF module
WITH tin_relief_ref AS (
  SELECT 
	id,
	surface_geometry_id
	FROM citydb.tin_relief
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM tin_relief_ref ref WHERE root_id = ref.surface_geometry_id;


-- CITYOBJECTGROUP module
WITH cityobjectgroup_ref AS (
  SELECT 
	id,
	brep_id
	FROM citydb.cityobjectgroup
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM cityobjectgroup_ref ref WHERE root_id = ref.brep_id;


-- GENERICS module
WITH generic_cityobject_ref AS (
  SELECT 
	id, ARRAY[
	lod0_brep_id,
	lod1_brep_id,
	lod2_brep_id,
	lod3_brep_id,
	lod4_brep_id] AS arr
	FROM citydb.generic_cityobject
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM generic_cityobject_ref ref WHERE root_id = ANY (ref.arr);

WITH cityobject_genericattrib_ref AS (
  SELECT 
	cityobject_id,
	surface_geometry_id
	FROM citydb.cityobject_genericattrib
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.cityobject_id
  FROM cityobject_genericattrib_ref ref WHERE root_id = ref.surface_geometry_id;


-- update sequences
SELECT setval('citydb.address_seq', max(id)) FROM address;
SELECT setval('citydb.appearance_seq', max(id)) FROM appearance;
SELECT setval('citydb.citymodel_seq', max(id)) FROM citymodel;
SELECT setval('citydb.cityobject_genericatt_seq', max(id)) FROM cityobject_genericattrib;
SELECT setval('citydb.cityobject_seq', max(id)) FROM cityobject;
SELECT setval('citydb.external_ref_seq', max(id)) FROM external_reference;
SELECT setval('citydb.implicit_geometry_seq', max(id)) FROM implicit_geometry;
SELECT setval('citydb.surface_data_seq', max(id)) FROM surface_data;
SELECT setval('citydb.surface_geometry_seq', max(id)) FROM surface_geometry;