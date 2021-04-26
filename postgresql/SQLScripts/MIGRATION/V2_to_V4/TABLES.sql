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

/*************************************************
* migrate tables from public to citydb schema
*
**************************************************/
-- BUILDING module
DROP TABLE IF EXISTS citydb.building CASCADE;
CREATE TABLE citydb.building (
    id,
    objectclass_id,
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
    b.id,
    co.class_id,
    building_parent_id,
    building_root_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
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
    FROM public.building b
    JOIN public.cityobject co ON co.id = b.id;

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
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
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
    objectclass_id,
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
    r.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    building_id,
    CASE WHEN EXISTS
        (SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 0)
        THEN lod4_geometry_id ELSE NULL::integer END,
    CASE WHEN EXISTS
        (SELECT 1 FROM public.surface_geometry sg WHERE sg.id = lod4_geometry_id AND is_solid = 1)
        THEN lod4_geometry_id ELSE NULL::integer END
    FROM public.room r
    JOIN public.cityobject co ON co.id = r.id;

DROP TABLE IF EXISTS citydb.building_furniture CASCADE;
CREATE TABLE citydb.building_furniture (
    id,
    objectclass_id,
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
    b.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    room_id,
    lod4_geometry_id,
    NULL::geometry(GEOMETRYZ,:srid),
    lod4_implicit_rep_id,
    lod4_implicit_ref_point,
    lod4_implicit_transformation
    FROM public.building_furniture b
    JOIN public.cityobject co ON co.id = b.id;

DROP TABLE IF EXISTS citydb.address_to_building CASCADE;
CREATE TABLE citydb.address_to_building AS
  SELECT building_id, address_id
    FROM public.address_to_building;


-- CITY FURNITURE module
DROP TABLE IF EXISTS citydb.city_furniture CASCADE;
CREATE TABLE citydb.city_furniture (
    id,
    objectclass_id,
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
    c.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    NULL::varchar(1000),
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
    FROM public.city_furniture c
    JOIN public.cityobject co ON co.id = c.id;


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
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
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
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
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
    objectclass_id,
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
    p.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    NULL::varchar(1000),
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
    FROM public.plant_cover p
    JOIN public.cityobject co ON co.id = p.id;

DROP TABLE IF EXISTS citydb.solitary_vegetat_object CASCADE;
CREATE TABLE citydb.solitary_vegetat_object (
    id,
    objectclass_id,
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
    s.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    NULL::varchar(1000),
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
    FROM public.solitary_vegetat_object s
    JOIN public.cityobject co ON co.id = s.id;


-- WATERBODY module
DROP TABLE IF EXISTS citydb.waterbody CASCADE;
CREATE TABLE citydb.waterbody (
    id,
    objectclass_id,
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
    w.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    lod0_multi_curve::geometry(MULTILINESTRINGZ,:srid),
    lod1_multi_curve::geometry(MULTILINESTRINGZ,:srid),
    lod0_multi_surface_id,
    lod1_multi_surface_id,
    lod1_solid_id,
    lod2_solid_id,
    lod3_solid_id,
    lod4_solid_id
    FROM public.waterbody w
    JOIN public.cityobject co ON co.id = w.id;

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
    objectclass_id,
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
    l.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    lod0_multi_surface_id,
    lod1_multi_surface_id,
    lod2_multi_surface_id,
    lod3_multi_surface_id,
    lod4_multi_surface_id
    FROM public.land_use l
    JOIN public.cityobject co ON co.id = l.id;


-- RELIEF module
DROP TABLE IF EXISTS citydb.relief_feature CASCADE;
CREATE TABLE citydb.relief_feature AS
  SELECT
    rf.id,
    co.class_id AS objectclass_id,
    lod
    FROM public.relief_feature rf
    JOIN public.cityobject co ON co.id = rf.id;

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
    objectclass_id,
    max_length,
    max_length_unit,
    stop_lines,
    break_lines,
    control_points,
    surface_geometry_id)
  AS SELECT
    t.id,
    co.class_id,
    max_length,
    NULL::varchar(4000),
    stop_lines::geometry(MULTILINESTRINGZ,:srid),
    break_lines::geometry(MULTILINESTRINGZ,:srid),
    control_points,
    surface_geometry_id
    FROM public.tin_relief t
    JOIN public.cityobject co ON co.id = t.id;

DROP TABLE IF EXISTS citydb.masspoint_relief CASCADE;
CREATE TABLE citydb.masspoint_relief (
    id,
    objectclass_id,
    relief_points)
  AS SELECT
    m.id, 
    co.class_id,
    relief_points
    FROM public.masspoint_relief m
    JOIN public.cityobject co ON co.id = m.id;

DROP TABLE IF EXISTS citydb.breakline_relief CASCADE;
CREATE TABLE citydb.breakline_relief (
    id,
    objectclass_id,
    ridge_or_valley_lines,
    break_lines)
  AS SELECT
    b.id,
    co.class_id,
    ridge_or_valley_lines::geometry(MULTILINESTRINGZ,:srid),
    break_lines::geometry(MULTILINESTRINGZ,:srid)
    FROM public.breakline_relief b
    JOIN public.cityobject co ON co.id = b.id;

-- no mapping for raster_relief table
DROP TABLE IF EXISTS citydb.raster_relief CASCADE;
CREATE TABLE citydb.raster_relief(
    id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL,
    raster_uri VARCHAR(4000),
    coverage_id INTEGER
);


-- CITYOBJECTGROUP module
DROP TABLE IF EXISTS citydb.cityobjectgroup CASCADE;
CREATE TABLE citydb.cityobjectgroup (
    id,
    objectclass_id,
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
    c.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    surface_geometry_id,
    geometry::geometry(GEOMETRYZ,:srid),
    parent_cityobject_id
    FROM public.cityobjectgroup c
    JOIN public.cityobject co ON co.id = c.id;

DROP TABLE IF EXISTS citydb.group_to_cityobject CASCADE;
CREATE TABLE citydb.group_to_cityobject AS
  SELECT cityobject_id, cityobjectgroup_id, role
    FROM public.group_to_cityobject;


-- GENERICS module
DROP TABLE IF EXISTS citydb.generic_cityobject CASCADE;
CREATE TABLE citydb.generic_cityobject (
    id,
    objectclass_id,
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
    g.id,
    co.class_id,
    replace(trim(class), ' ', '--/\--')::varchar(256),
    NULL::varchar(4000),
    replace(trim(function), ' ', '--/\--')::varchar(1000),
    NULL::varchar(4000),
    replace(trim(usage), ' ', '--/\--')::varchar(1000),
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
    FROM public.generic_cityobject g
    JOIN public.cityobject co ON co.id = g.id;

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
    datatype::integer,
    strval,
    intval::integer,
    realval::double precision,
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
  SELECT id, gmlid, gmlid_codespace, name, name_codespace, description, theme, citymodel_id, cityobject_id
    FROM public.appearance;

DROP TABLE IF EXISTS citydb.surface_data CASCADE;
CREATE TABLE citydb.surface_data (
    id,
    gmlid,
    gmlid_codespace,
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
    gmlid_codespace,
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

-- new additional table for textures
SELECT geodb_pkg.migrate_tex_image(:'texop');

-- CORE module
DROP TABLE IF EXISTS citydb.citymodel CASCADE;
CREATE TABLE citydb.citymodel (
    id,
    gmlid,
    gmlid_codespace,
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
    gmlid_codespace,
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
    gmlid_codespace,
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
    co.gmlid_codespace,
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
  SELECT cityobject_id, generalizes_to_id
    FROM public.generalization;

DROP TABLE IF EXISTS citydb.surface_geometry CASCADE;
CREATE TABLE citydb.surface_geometry (
    id,
    gmlid,
    gmlid_codespace,
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
    gmlid_codespace,
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
  SELECT sg.root_id AS solid_geom_id, ST_SetSRID(ST_GeomFromText(replace(ST_AsText(ST_Collect(sg.geometry)), 'MULTIPOLYGON','POLYHEDRALSURFACE')),:srid) AS solid_geom
    FROM surface_geometry sg, (SELECT root_id FROM surface_geometry WHERE is_solid = 1) solids
    WHERE sg.root_id = solids.root_id AND sg.geometry IS NOT NULL
    GROUP BY sg.root_id
)
UPDATE citydb.surface_geometry SET solid_geometry = gs.solid_geom
  FROM get_solids gs WHERE id = gs.solid_geom_id;

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
  SELECT id, infosys, name, uri, cityobject_id
    FROM public.external_reference;

DROP TABLE IF EXISTS citydb.address CASCADE;
CREATE TABLE citydb.address (
    id,
    gmlid,
    gmlid_codespace,
    street,
    house_number,
    po_box,
    zip_code,
    city,
    state,
    country,
    multi_point,
    xal_source)
  AS SELECT
    id,
    ('ID_'||id)::varchar(256),
    NULL::varchar(1000),
    street,
    house_number,
    po_box,
    zip_code,
    city,
    state,
    country,
    multi_point,
    xal_source
    FROM public.address;


-- metadata table
DROP TABLE IF EXISTS citydb.database_srs CASCADE;
CREATE TABLE citydb.database_srs AS
  SELECT srid, gml_srs_name
    FROM public.database_srs;


-- create reference between cityobject and surface_geometry table

-- BUILDING module
WITH building_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id]) geom_id
      FROM citydb.building) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM building_ref ref WHERE root_id = ref.geom_id;

WITH building_installation_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id]) geom_id
      FROM citydb.building_installation) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM building_installation_ref ref WHERE root_id = ref.geom_id;

WITH thematic_surface_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id]) geom_id
      FROM citydb.thematic_surface) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM thematic_surface_ref ref WHERE root_id = ref.geom_id;

WITH opening_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod3_multi_surface_id,
      lod4_multi_surface_id]) geom_id
      FROM citydb.opening) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM opening_ref ref WHERE root_id = ref.geom_id;

WITH room_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod4_multi_surface_id,
      lod4_solid_id]) geom_id
      FROM citydb.room) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM room_ref ref WHERE root_id = ref.geom_id;

WITH building_furniture_ref AS (
  SELECT
    id,
    lod4_brep_id
    FROM citydb.building_furniture
    WHERE lod4_brep_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM building_furniture_ref ref WHERE root_id = ref.lod4_brep_id;


-- CITY FURNITURE module
WITH city_furniture_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id]) geom_id
      FROM citydb.city_furniture) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM city_furniture_ref ref WHERE root_id = ref.geom_id;


-- TRANSPORTATION module
WITH transportation_complex_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id]) geom_id
      FROM citydb.transportation_complex) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM transportation_complex_ref ref WHERE root_id = ref.geom_id;

WITH traffic_area_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id]) geom_id
      FROM citydb.traffic_area) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM traffic_area_ref ref WHERE root_id = ref.geom_id;


-- VEGETATION module
WITH plant_cover_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod1_multi_solid_id,
      lod2_multi_solid_id,
      lod3_multi_solid_id,
      lod4_multi_solid_id]) geom_id
      FROM citydb.plant_cover) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM plant_cover_ref ref WHERE root_id = ref.geom_id;

WITH solitary_vegetat_object_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id]) geom_id
      FROM citydb.solitary_vegetat_object) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM solitary_vegetat_object_ref ref WHERE root_id = ref.geom_id;


-- WATERBODY module
WITH waterbody_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod0_multi_surface_id,
      lod1_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id]) geom_id
      FROM citydb.waterbody) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM waterbody_ref ref WHERE root_id = ref.geom_id;

WITH waterboundary_surface_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod2_surface_id,
      lod3_surface_id,
      lod4_surface_id]) geom_id
      FROM citydb.waterboundary_surface) geom_ref
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM waterboundary_surface_ref ref WHERE root_id = ref.geom_id;


-- LAND USE module
WITH land_use_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod0_multi_surface_id,
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id]) geom_id
      FROM citydb.land_use) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM land_use_ref ref WHERE root_id = ref.geom_id;


-- RELIEF module
WITH tin_relief_ref AS (
  SELECT
    id,
    surface_geometry_id
    FROM citydb.tin_relief
    WHERE surface_geometry_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM tin_relief_ref ref WHERE root_id = ref.surface_geometry_id;


-- CITYOBJECTGROUP module
WITH cityobjectgroup_ref AS (
  SELECT
    id,
    brep_id
    FROM citydb.cityobjectgroup
    WHERE brep_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM cityobjectgroup_ref ref WHERE root_id = ref.brep_id;


-- GENERICS module
WITH generic_cityobject_ref AS (
  SELECT geom_ref.id, geom_ref.geom_id FROM (
    SELECT id, unnest(ARRAY[
      lod0_brep_id,
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id]) geom_id
      FROM citydb.generic_cityobject) geom_ref
    WHERE geom_ref.geom_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.id
  FROM generic_cityobject_ref ref WHERE root_id = ref.geom_id;

WITH cityobject_genericattrib_ref AS (
  SELECT
    cityobject_id,
    surface_geometry_id
    FROM citydb.cityobject_genericattrib
    WHERE surface_geometry_id IS NOT NULL
)
UPDATE citydb.surface_geometry SET cityobject_id = ref.cityobject_id
  FROM cityobject_genericattrib_ref ref WHERE root_id = ref.surface_geometry_id;


-- transfer implicit geometry to implicit_geometry column in surface_geometry column with SRID = 0
WITH impl_geom AS (
  SELECT id, geometry FROM citydb.surface_geometry WHERE cityobject_id IS NULL
)
UPDATE citydb.surface_geometry sg SET geometry = NULL, implicit_geometry = ST_SetSRID(impl_geom.geometry, 0)
  FROM impl_geom WHERE sg.id = impl_geom.id;


/*************************************************
* create tables new in v3.0.0
*
**************************************************/
-- BRIDGE module
DROP TABLE IF EXISTS citydb.bridge CASCADE;
CREATE TABLE citydb.bridge(
    id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL,
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
    is_movable NUMERIC,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
    class VARCHAR(256),
    class_codespace VARCHAR(4000),
    function VARCHAR(1000),
    function_codespace VARCHAR(4000),
    usage VARCHAR(1000),
    usage_codespace VARCHAR(4000),
    bridge_id INTEGER,
    lod4_multi_surface_id INTEGER,
    lod4_solid_id INTEGER
);

DROP TABLE IF EXISTS citydb.bridge_furniture CASCADE;
CREATE TABLE citydb.bridge_furniture(
    id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL,
    class VARCHAR(256),
    class_codespace VARCHAR(4000),
    function VARCHAR(1000),
    function_codespace VARCHAR(4000),
    usage VARCHAR(1000),
    usage_codespace VARCHAR(4000),
    bridge_room_id INTEGER,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
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
    objectclass_id INTEGER NOT NULL,
    class VARCHAR(256),
    class_codespace VARCHAR(4000),
    function VARCHAR(1000),
    function_codespace VARCHAR(4000),
    usage VARCHAR(1000),
    usage_codespace VARCHAR(4000),
    tunnel_id INTEGER,
    lod4_multi_surface_id INTEGER,
    lod4_solid_id INTEGER
);

DROP TABLE IF EXISTS citydb.tunnel_furniture CASCADE;
CREATE TABLE citydb.tunnel_furniture(
    id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL,
    class VARCHAR(256),
    class_codespace VARCHAR(4000),
    function VARCHAR(1000),
    function_codespace VARCHAR(4000),
    usage VARCHAR(1000),
    usage_codespace VARCHAR(4000),
    tunnel_hollow_space_id INTEGER,
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


/*************************************************
* create objectclass table
*
**************************************************/
DROP TABLE IF EXISTS citydb.objectclass CASCADE;
CREATE TABLE citydb.objectclass(
    id INTEGER NOT NULL,
    is_ade_class NUMERIC,
    is_toplevel NUMERIC,
    classname VARCHAR(256),
    tablename VARCHAR(30),
    superclass_id INTEGER,
    baseclass_id INTEGER,
    ade_id INTEGER
);


/*************************************************
* create tables new in v4.0.0
*
**************************************************/
DROP TABLE IF EXISTS citydb.ade CASCADE;
CREATE TABLE citydb.ade(
    id INTEGER NOT NULL DEFAULT nextval('ade_seq'::regclass),
    adeid VARCHAR(256) NOT NULL,
    name VARCHAR(1000) NOT NULL,
    description VARCHAR(4000),
    version VARCHAR(50),
    db_prefix VARCHAR(10) NOT NULL,
    xml_schemamapping_file TEXT,
    drop_db_script TEXT,
    creation_date TIMESTAMP WITH TIME ZONE,
    creation_person VARCHAR(256)
);

DROP TABLE IF EXISTS citydb.schema CASCADE;
CREATE TABLE citydb.schema(
    id INTEGER NOT NULL DEFAULT nextval('schema_seq'::regclass),
    is_ade_root NUMERIC NOT NULL,
    citygml_version VARCHAR(50) NOT NULL,
    xml_namespace_uri VARCHAR(4000) NOT NULL,
    xml_namespace_prefix VARCHAR(50) NOT NULL,
    xml_schema_location VARCHAR(4000),
    xml_schemafile BYTEA,
    xml_schemafile_type VARCHAR(256),
    ade_id INTEGER
);

DROP TABLE IF EXISTS citydb.schema_referencing CASCADE;
CREATE TABLE citydb.schema_referencing(
    referencing_id INTEGER NOT NULL,
    referenced_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS citydb.schema_to_objectclass CASCADE;
CREATE TABLE citydb.schema_to_objectclass(
    schema_id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS citydb.aggregation_info CASCADE;
CREATE TABLE citydb.aggregation_info(
    child_id INTEGER NOT NULL,
    parent_id INTEGER NOT NULL,
    join_table_or_column_name VARCHAR(30) NOT NULL,
    min_occurs INTEGER,
    max_occurs INTEGER,
    is_composite NUMERIC
);


/*************************************************
* update sequences
*
**************************************************/
SELECT setval('citydb.address_seq', max(id)) FROM citydb.address;
SELECT setval('citydb.appearance_seq', max(id)) FROM citydb.appearance;
SELECT setval('citydb.citymodel_seq', max(id)) FROM citydb.citymodel;
SELECT setval('citydb.cityobject_genericatt_seq', max(id)) FROM citydb.cityobject_genericattrib;
SELECT setval('citydb.cityobject_seq', max(id)) FROM citydb.cityobject;
SELECT setval('citydb.external_ref_seq', max(id)) FROM citydb.external_reference;
SELECT setval('citydb.implicit_geometry_seq', max(id)) FROM citydb.implicit_geometry;
SELECT setval('citydb.surface_data_seq', max(id)) FROM citydb.surface_data;
SELECT setval('citydb.surface_geometry_seq', max(id)) FROM citydb.surface_geometry;
SELECT setval('citydb.tex_image_seq', max(id)) FROM citydb.tex_image;