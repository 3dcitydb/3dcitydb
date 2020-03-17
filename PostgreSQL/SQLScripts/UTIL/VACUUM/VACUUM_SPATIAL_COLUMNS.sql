-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2020
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

VACUUM ANALYSE breakline_relief (ridge_or_valley_lines);
VACUUM ANALYSE breakline_relief (break_lines);
VACUUM ANALYSE bridge (lod1_terrain_intersection);
VACUUM ANALYSE bridge (lod2_terrain_intersection);
VACUUM ANALYSE bridge (lod3_terrain_intersection);
VACUUM ANALYSE bridge (lod4_terrain_intersection);
VACUUM ANALYSE bridge (lod2_multi_curve);
VACUUM ANALYSE bridge (lod3_multi_curve);
VACUUM ANALYSE bridge (lod4_multi_curve);
VACUUM ANALYSE bridge_constr_element (lod1_terrain_intersection);
VACUUM ANALYSE bridge_constr_element (lod2_terrain_intersection);
VACUUM ANALYSE bridge_constr_element (lod3_terrain_intersection);
VACUUM ANALYSE bridge_constr_element (lod4_terrain_intersection);
VACUUM ANALYSE bridge_constr_element (lod1_other_geom);
VACUUM ANALYSE bridge_constr_element (lod2_other_geom);
VACUUM ANALYSE bridge_constr_element (lod3_other_geom);
VACUUM ANALYSE bridge_constr_element (lod4_other_geom);
VACUUM ANALYSE bridge_constr_element (lod1_implicit_ref_point);
VACUUM ANALYSE bridge_constr_element (lod2_implicit_ref_point);
VACUUM ANALYSE bridge_constr_element (lod3_implicit_ref_point);
VACUUM ANALYSE bridge_constr_element (lod4_implicit_ref_point);
VACUUM ANALYSE bridge_furniture (lod4_other_geom);
VACUUM ANALYSE bridge_furniture (lod4_implicit_ref_point);
VACUUM ANALYSE bridge_installation (lod2_other_geom);
VACUUM ANALYSE bridge_installation (lod3_other_geom);
VACUUM ANALYSE bridge_installation (lod4_other_geom);
VACUUM ANALYSE bridge_installation (lod2_implicit_ref_point);
VACUUM ANALYSE bridge_installation (lod3_implicit_ref_point);
VACUUM ANALYSE bridge_installation (lod4_implicit_ref_point);
VACUUM ANALYSE building (lod1_terrain_intersection);
VACUUM ANALYSE building (lod2_terrain_intersection);
VACUUM ANALYSE building (lod3_terrain_intersection);
VACUUM ANALYSE building (lod4_terrain_intersection);
VACUUM ANALYSE building (lod2_multi_curve);
VACUUM ANALYSE building (lod3_multi_curve);
VACUUM ANALYSE building (lod4_multi_curve);
VACUUM ANALYSE building_furniture (lod4_other_geom);
VACUUM ANALYSE building_furniture (lod4_implicit_ref_point);
VACUUM ANALYSE building_installation (lod2_other_geom);
VACUUM ANALYSE building_installation (lod3_other_geom);
VACUUM ANALYSE building_installation (lod4_other_geom);
VACUUM ANALYSE building_installation (lod2_implicit_ref_point);
VACUUM ANALYSE building_installation (lod3_implicit_ref_point);
VACUUM ANALYSE building_installation (lod4_implicit_ref_point);
VACUUM ANALYSE building_opening (lod3_implicit_ref_point);
VACUUM ANALYSE building_opening (lod4_implicit_ref_point);
VACUUM ANALYSE city_furniture (lod1_terrain_intersection);
VACUUM ANALYSE city_furniture (lod2_terrain_intersection);
VACUUM ANALYSE city_furniture (lod3_terrain_intersection);
VACUUM ANALYSE city_furniture (lod4_terrain_intersection);
VACUUM ANALYSE city_furniture (lod1_other_geom);
VACUUM ANALYSE city_furniture (lod2_other_geom);
VACUUM ANALYSE city_furniture (lod3_other_geom);
VACUUM ANALYSE city_furniture (lod4_other_geom);
VACUUM ANALYSE city_furniture (lod1_implicit_ref_point);
VACUUM ANALYSE city_furniture (lod2_implicit_ref_point);
VACUUM ANALYSE city_furniture (lod3_implicit_ref_point);
VACUUM ANALYSE city_furniture (lod4_implicit_ref_point);
VACUUM ANALYSE citymodel (envelope);
VACUUM ANALYSE cityobject (envelope);
VACUUM ANALYSE cityobjectgroup (other_geom);
VACUUM ANALYSE generic_cityobject (lod0_terrain_intersection);
VACUUM ANALYSE generic_cityobject (lod1_terrain_intersection);
VACUUM ANALYSE generic_cityobject (lod2_terrain_intersection);
VACUUM ANALYSE generic_cityobject (lod3_terrain_intersection);
VACUUM ANALYSE generic_cityobject (lod4_terrain_intersection);
VACUUM ANALYSE generic_cityobject (lod0_other_geom);
VACUUM ANALYSE generic_cityobject (lod1_other_geom);
VACUUM ANALYSE generic_cityobject (lod2_other_geom);
VACUUM ANALYSE generic_cityobject (lod3_other_geom);
VACUUM ANALYSE generic_cityobject (lod4_other_geom);
VACUUM ANALYSE generic_cityobject (lod0_implicit_ref_point);
VACUUM ANALYSE generic_cityobject (lod1_implicit_ref_point);
VACUUM ANALYSE generic_cityobject (lod2_implicit_ref_point);
VACUUM ANALYSE generic_cityobject (lod3_implicit_ref_point);
VACUUM ANALYSE generic_cityobject (lod4_implicit_ref_point);
VACUUM ANALYSE implicit_geometry (relative_other_geom);
VACUUM ANALYSE masspoint_relief (relief_points);
VACUUM ANALYSE opening (lod3_implicit_ref_point);
VACUUM ANALYSE opening (lod4_implicit_ref_point);
VACUUM ANALYSE relief_component (extent);
VACUUM ANALYSE solitary_vegetat_object (lod1_other_geom);
VACUUM ANALYSE solitary_vegetat_object (lod2_other_geom);
VACUUM ANALYSE solitary_vegetat_object (lod3_other_geom);
VACUUM ANALYSE solitary_vegetat_object (lod4_other_geom);
VACUUM ANALYSE solitary_vegetat_object (lod1_implicit_ref_point);
VACUUM ANALYSE solitary_vegetat_object (lod2_implicit_ref_point);
VACUUM ANALYSE solitary_vegetat_object (lod3_implicit_ref_point);
VACUUM ANALYSE solitary_vegetat_object (lod4_implicit_ref_point);
VACUUM ANALYSE surface_data (gt_reference_point);
VACUUM ANALYSE surface_geometry (geometry);
VACUUM ANALYSE surface_geometry (solid_geometry);
VACUUM ANALYSE tin_relief (stop_lines);
VACUUM ANALYSE tin_relief (break_lines);
VACUUM ANALYSE tin_relief (control_points);
VACUUM ANALYSE transportation_complex (lod0_network);
VACUUM ANALYSE tunnel (lod1_terrain_intersection);
VACUUM ANALYSE tunnel (lod2_terrain_intersection);
VACUUM ANALYSE tunnel (lod3_terrain_intersection);
VACUUM ANALYSE tunnel (lod4_terrain_intersection);
VACUUM ANALYSE tunnel (lod2_multi_curve);
VACUUM ANALYSE tunnel (lod3_multi_curve);
VACUUM ANALYSE tunnel (lod4_multi_curve);
VACUUM ANALYSE tunnel_furniture (lod4_other_geom);
VACUUM ANALYSE tunnel_furniture (lod4_implicit_ref_point);
VACUUM ANALYSE tunnel_installation (lod2_other_geom);
VACUUM ANALYSE tunnel_installation (lod3_other_geom);
VACUUM ANALYSE tunnel_installation (lod4_other_geom);
VACUUM ANALYSE tunnel_installation (lod2_implicit_ref_point);
VACUUM ANALYSE tunnel_installation (lod3_implicit_ref_point);
VACUUM ANALYSE tunnel_installation (lod4_implicit_ref_point);
VACUUM ANALYSE tunnel_opening (lod3_implicit_ref_point);
VACUUM ANALYSE tunnel_opening (lod4_implicit_ref_point);
VACUUM ANALYSE waterbody (lod0_multi_curve);
VACUUM ANALYSE waterbody (lod1_multi_curve);