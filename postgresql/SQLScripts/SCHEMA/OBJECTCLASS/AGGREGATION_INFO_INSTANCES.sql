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

DELETE FROM aggregation_info;

--cityobject & citymodel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (3,57,0,NULL,0,'cityobject_member');

--external_reference & cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (110,3,0,NULL,1,'cityobject_id');

--surface_geometry & surface_geometry
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,108,0,NULL,1,'root_id');

--surface_geometry & surface_geometry
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,108,0,NULL,1,'parent_id');

--surface_geometry & implicit_geometry
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,59,0,1,1,'relative_brep_id');

--appearance & citymodel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (50,57,0,NULL,1,'citymodel_id');

--appearance & cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (50,3,0,NULL,1,'cityobject_id');

--surface_data & appearance
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (51,50,0,NULL,0,'appear_to_surface_data');

--tex_image & surface_data
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (109,51,0,1,0,'tex_image_id');

--cityobject & cityobjectgroup
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (3,23,0,NULL,0,'group_to_cityobject');

--surface_geometry & cityobjectgroup
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,23,0,1,1,'brep_id');

--implicit_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,21,0,1,0,'lod1_implicit_rep_id');

--implicit_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,21,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,21,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,21,0,1,0,'lod4_implicit_rep_id');

--surface_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,21,0,1,1, 'lod1_brep_id');

--surface_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,21,0,1,1, 'lod2_brep_id');

--surface_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,21,0,1,1, 'lod3_brep_id');

--surface_geometry & city_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,21,0,1,1, 'lod4_brep_id');

--cityobject_genericattrib & cityobject_genericattrib
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (112,113,0,NULL,1, 'parent_genattrib_id');

--cityobject_genericattrib & cityobject_genericattrib
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (112,113,0,NULL,1, 'root_genattrib_id');

--cityobject_genericattrib & cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (112,3,0,NULL,1,'cityobject_id');

--surface_geometry & cityobject_genericattrib
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,112,0,1,1,'surface_geometry_id');

--surface_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,5,0,1,1,'lod0_brep_id');

--surface_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,5,0,1,1,'lod1_brep_id');

--surface_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,5,0,1,1,'lod2_brep_id');

--surface_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,5,0,1,1,'lod3_brep_id');

--surface_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,5,0,1,1,'lod4_brep_id');

--implicit_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,5,0,1,0,'lod0_implicit_rep_id');

--implicit_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,5,0,1,0,'lod1_implicit_rep_id');

--implicit_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,5,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,5,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & generic_cityobject
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,5,0,1,0,'lod4_implicit_rep_id');

--surface_geometry & land_use
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,4,0,1,1,'lod0_multi_surface_id');

--surface_geometry & land_use
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,4,0,1,1,'lod1_multi_surface_id');

INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,4,0,1,1,'lod2_multi_surface_id');

INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,4,0,1,1,'lod3_multi_surface_id');

INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,4,0,1,1,'lod4_multi_surface_id');

--relief_component & relief_feature
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (15,14,0,NULL,0,'relief_feat_to_rel_comp');

--surface_geometry & tin_relief
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,16,0,1,1,'surface_geometry_id');

--grid_coverage & raster_relief
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (111,19,0,1,1,'coverage_id');

--traffic_area & transportation_complex
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (47,42,0,NULL,1,'transportation_complex_id');

--surface_geometry & traffic_area
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,47,0,1,1,'lod2_multi_surface_id');

--surface_geometry & traffic_area
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,47,0,1,1,'lod3_multi_surface_id');

--surface_geometry & traffic_area
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,47,0,1,1,'lod4_multi_surface_id');

--surface_geometry & transportation_complex
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,42,0,1,1,'lod1_multi_surface_id');

--surface_geometry & transportation_complex
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,42,0,1,1,'lod2_multi_surface_id');

--surface_geometry & transportation_complex
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,42,0,1,1,'lod3_multi_surface_id');

--surface_geometry & transportation_complex
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,42,0,1,1,'lod4_multi_surface_id');

--surface_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,7,0,1,1,'lod1_brep_id');

--surface_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,7,0,1,1,'lod2_brep_id');

--surface_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,7,0,1,1,'lod3_brep_id');

--surface_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,7,0,1,1,'lod4_brep_id');

--implicit_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,7,0,1,0,'lod1_implicit_rep_id');

--implicit_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,7,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,7,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & solitary_vegetat_object
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,7,0,1,0,'lod4_implicit_rep_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod1_multi_surface_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod2_multi_surface_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod3_multi_surface_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod4_multi_surface_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod1_multi_solid_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod2_multi_solid_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod3_multi_solid_id');

--surface_geometry & plant_cover
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,8,0,1,1,'lod4_multi_solid_id');

--waterboundary_surface & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (10,9,0,NULL,0,'waterbod_to_waterbnd_srf');

--surface_geometry & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,9,0,1,1,'lod0_multi_surface_id');

--surface_geometry & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,9,0,1,1,'lod1_multi_surface_id');

--surface_geometry & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,9,0,1,1,'lod1_solid_id');

--surface_geometry & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,9,0,1,1,'lod2_solid_id');

--surface_geometry & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,9,0,1,1,'lod3_solid_id');

--surface_geometry & waterbody
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,9,0,1,1,'lod4_solid_id');

--surface_geometry & waterboundary_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,10,0,1,1,'lod2_surface_id');

--surface_geometry & waterboundary_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,10,0,1,1,'lod3_surface_id');

--surface_geometry & waterboundary_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,10,0,1,1,'lod4_surface_id');

--address & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (58,62,0,NULL,0,'address_to_bridge');

--address & bridge_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (58,77,0,1,0,'address_id');

--bridge & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (63,62,0,NULL,1,'bridge_parent_id');

--bridge & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (63,64,0,NULL,1,'bridge_root_id');

--bridge_constr_element & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (82,62,0,NULL,1,'bridge_id');

--bridge_furniture & bridge_room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (80,81,0,NULL,1,'bridge_room_id');

--bridge_installation & bridge_room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (66,81,0,NULL,1,'bridge_room_id');

--bridge_installation & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (65,62,0,NULL,1,'bridge_id');

--bridge_opening & bridge_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (77,67,0,NULL,1,'bridge_open_to_them_srf');

--bridge_room & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (81,62,0,NULL,1,'bridge_id');

--bridge_thematic_surface & bridge_room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (67,81,0,NULL,1,'bridge_room_id');

--bridge_thematic_surface & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (67,62,0,NULL,1,'bridge_id');

--bridge_thematic_surface & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (67,65,0,NULL,1,'bridge_installation_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod1_multi_surface_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod2_multi_surface_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod3_multi_surface_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod4_multi_surface_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod1_solid_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod2_solid_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod3_solid_id');

--surface_geometry & bridge
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,62,0,1,1,'lod4_solid_id');

--surface_geometry & bridge_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,80,0,1,1,'lod4_brep_id');

--surface_geometry & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,65,0,1,1,'lod2_brep_id');

--surface_geometry & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,65,0,1,1,'lod3_brep_id');

--surface_geometry & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,65,0,1,1,'lod4_brep_id');

--surface_geometry & (int)bridge_installation 
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,66,0,1,1,'lod4_brep_id');

--surface_geometry & bridge_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,77,0,1,1,'lod3_multi_surface_id');

--surface_geometry & bridge_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,77,0,1,1,'lod4_multi_surface_id');

--surface_geometry & bridge_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,67,0,1,1,'lod2_multi_surface_id');

--surface_geometry & bridge_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,67,0,1,1,'lod3_multi_surface_id');

--surface_geometry & bridge_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,67,0,1,1,'lod4_multi_surface_id');

--surface_geometry & bridge_room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,81,0,1,1,'lod4_multi_surface_id');

--surface_geometry & bridge_room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,81,0,1,1,'lod4_solid_id');

--surface_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,82,0,1,1,'lod1_brep_id');

--surface_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,82,0,1,1,'lod2_brep_id');

--surface_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,82,0,1,1,'lod3_brep_id');

--surface_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,82,0,1,1,'lod4_brep_id');

--implicit_geometry & bridge_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,80,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,65,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,65,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,65,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & (int)bridge_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,66,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & bridge_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,77,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & bridge_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,77,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,82,0,1,0,'lod1_implicit_rep_id');

--implicit_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,82,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,82,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & bridge_constr_element
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,82,0,1,0,'lod4_implicit_rep_id');

--address & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (58,24,0,NULL,0,'address_to_building');

--address & opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (58,37,0,1,0,'address_id');

--building & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (25,24,0,NULL,1,'building_parent_id');

--building & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (25,26,0,NULL,1,'building_root_id');

--building_furniture & room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (40,41,0,NULL,1,'room_id');

--building_installation & room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (28,41,0,NULL,1,'room_id');

--building_installation & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (27,24,0,NULL,1,'building_id');

--opening & thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (37,29,0,NULL,1,'opening_to_them_surface');		
			
--room & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (41,24,0,NULL,1,'building_id');	
			
--thematic_surface & room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (29,41,0,NULL,1,'room_id');

--thematic_surface & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (29,27,0,NULL,1,'building_installation_id');

--thematic_surface & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (29,24,0,NULL,1,'building_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod0_footprint_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod0_roofprint_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod1_multi_surface_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod2_multi_surface_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod3_multi_surface_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod4_multi_surface_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod1_solid_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod2_solid_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod3_solid_id');

--surface_geometry & building
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,24,0,1,1,'lod4_solid_id');

--surface_geometry & building_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,40,0,1,1,'lod4_brep_id');

--surface_geometry & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,27,0,1,1,'lod2_brep_id');

--surface_geometry & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,27,0,1,1,'lod3_brep_id');

--surface_geometry & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,27,0,1,1,'lod4_brep_id');

--surface_geometry & (int)building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,28,0,1,1,'lod4_brep_id');

--surface_geometry & opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,37,0,1,1,'lod3_multi_surface_id');

--surface_geometry & opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,37,0,1,1,'lod4_multi_surface_id');

--surface_geometry & thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,29,0,1,1,'lod2_multi_surface_id');

--surface_geometry & thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,29,0,1,1,'lod3_multi_surface_id');

--surface_geometry & thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,29,0,1,1,'lod4_multi_surface_id');

--surface_geometry & room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,41,0,1,1,'lod4_multi_surface_id');

--surface_geometry & room
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,41,0,1,1,'lod4_solid_id');

--implicit_geometry & building_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,40,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,27,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,27,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,27,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & (int)building_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,28,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,37,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,37,0,1,0,'lod4_implicit_rep_id');

--tunnel & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (84,83,0,NULL,1,'tunnel_parent_id');

--tunnel & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (84,85,0,NULL,1,'tunnel_root_id');

--tunnel_furniture & tunnel_hollow_space
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (101,102,0,NULL,1,'tunnel_hollow_space_id');

--tunnel_installation & tunnel_hollow_space
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (87,102,0,NULL,1,'tunnel_hollow_space_id');

--tunnel_installation & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (86,83,0,NULL,1,'tunnel_id');

--tunnel_opening & tunnel_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (98,88,0,NULL,1,'tunnel_open_to_them_srf');

--tunnel_hollow_space & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (102,83,0,NULL,1,'tunnel_id');

--tunnel_thematic_surface & tunnel_hollow_space
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (88,102,0,NULL,1,'tunnel_hollow_space_id');

--tunnel_thematic_surface & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (88,83,0,NULL,1,'tunnel_id');

--tunnel_thematic_surface & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (88,86,0,NULL,1,'tunnel_installation_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod1_multi_surface_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod2_multi_surface_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod3_multi_surface_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod4_multi_surface_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod1_solid_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod2_solid_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod3_solid_id');

--surface_geometry & tunnel
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,83,0,1,1,'lod4_solid_id');

--surface_geometry & tunnel_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,101,0,1,1,'lod4_brep_id');

--surface_geometry & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,86,0,1,1,'lod2_brep_id');

--surface_geometry & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,86,0,1,1,'lod3_brep_id');

--surface_geometry & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,86,0,1,1,'lod4_brep_id');

--surface_geometry & (int)tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,87,0,1,1,'lod4_brep_id');

--surface_geometry & tunnel_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,98,0,1,1,'lod3_multi_surface_id');

--surface_geometry & tunnel_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,98,0,1,1,'lod4_multi_surface_id');

--surface_geometry & tunnel_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,88,0,1,1,'lod2_multi_surface_id');

--surface_geometry & tunnel_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,88,0,1,1,'lod3_multi_surface_id');

--surface_geometry & tunnel_thematic_surface
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,88,0,1,1,'lod4_multi_surface_id');

--surface_geometry & tunnel_hollow_space
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,102,0,1,1,'lod4_multi_surface_id');

--surface_geometry & tunnel_hollow_space
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (106,102,0,1,1,'lod4_solid_id');

--implicit_geometry & tunnel_furniture
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,101,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,86,0,1,0,'lod2_implicit_rep_id');

--implicit_geometry & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,86,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,86,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & (int)tunnel_installation
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,87,0,1,0,'lod4_implicit_rep_id');

--implicit_geometry & tunnel_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,98,0,1,0,'lod3_implicit_rep_id');

--implicit_geometry & tunnel_opening
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (59,98,0,1,0,'lod4_implicit_rep_id');
