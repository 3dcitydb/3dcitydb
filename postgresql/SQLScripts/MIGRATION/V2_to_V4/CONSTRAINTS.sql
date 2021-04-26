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

--// PRIMARY KEYS, DEFAULTs and CHECKs
ALTER TABLE citydb.address
  ADD CONSTRAINT address_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.address_seq'::regclass);

ALTER TABLE citydb.address_to_bridge
  ADD CONSTRAINT address_to_bridge_pk PRIMARY KEY (bridge_id,address_id);

ALTER TABLE citydb.address_to_building
  ADD CONSTRAINT address_to_building_pk PRIMARY KEY (building_id,address_id);

ALTER TABLE citydb.appear_to_surface_data
  ADD CONSTRAINT appear_to_surface_data_pk PRIMARY KEY (surface_data_id,appearance_id);

ALTER TABLE citydb.appearance
  ADD CONSTRAINT appearance_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.appearance_seq'::regclass);

ALTER TABLE citydb.breakline_relief
  ADD CONSTRAINT breakline_relief_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge
  ADD CONSTRAINT bridge_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge_constr_element
  ADD CONSTRAINT bridge_constr_element_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge_furniture
  ADD CONSTRAINT bridge_furniture_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge_installation
  ADD CONSTRAINT bridge_installation_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge_open_to_them_srf
  ADD CONSTRAINT bridge_open_to_them_srf_pk PRIMARY KEY (bridge_opening_id,bridge_thematic_surface_id);

ALTER TABLE citydb.bridge_opening
  ADD CONSTRAINT bridge_opening_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge_room
  ADD CONSTRAINT bridge_room_pk PRIMARY KEY (id);

ALTER TABLE citydb.bridge_thematic_surface
  ADD CONSTRAINT bridge_thematic_surface_pk PRIMARY KEY (id);

ALTER TABLE citydb.building
  ADD CONSTRAINT building_pk PRIMARY KEY (id);

ALTER TABLE citydb.building_furniture
  ADD CONSTRAINT building_furniture_pk PRIMARY KEY (id);

ALTER TABLE citydb.building_installation
  ADD CONSTRAINT building_installation_pk PRIMARY KEY (id);

ALTER TABLE citydb.city_furniture
  ADD CONSTRAINT city_furniture_pk PRIMARY KEY (id);

ALTER TABLE citydb.citymodel
  ADD CONSTRAINT citymodel_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.citymodel_seq'::regclass);

ALTER TABLE citydb.cityobject
  ADD CONSTRAINT cityobject_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.cityobject_seq'::regclass);

ALTER TABLE citydb.cityobject_genericattrib
  ADD CONSTRAINT cityobj_genericattrib_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.cityobject_genericatt_seq'::regclass);

ALTER TABLE citydb.cityobject_member
  ADD CONSTRAINT cityobject_member_pk PRIMARY KEY (citymodel_id,cityobject_id);

ALTER TABLE citydb.cityobjectgroup
  ADD CONSTRAINT cityobjectgroup_pk PRIMARY KEY (id);

ALTER TABLE citydb.database_srs
  ADD CONSTRAINT database_srs_pk PRIMARY KEY (srid);

ALTER TABLE citydb.external_reference
  ADD CONSTRAINT external_reference_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.external_ref_seq'::regclass);

ALTER TABLE citydb.generalization
  ADD CONSTRAINT generalization_pk PRIMARY KEY (cityobject_id,generalizes_to_id);

ALTER TABLE citydb.generic_cityobject
  ADD CONSTRAINT generic_cityobject_pk PRIMARY KEY (id);

ALTER TABLE citydb.grid_coverage
  ADD CONSTRAINT grid_coverage_pk PRIMARY KEY (id);

ALTER TABLE citydb.group_to_cityobject
  ADD CONSTRAINT group_to_cityobject_pk PRIMARY KEY (cityobject_id,cityobjectgroup_id);

ALTER TABLE citydb.implicit_geometry
  ADD CONSTRAINT implicit_geometry_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.implicit_geometry_seq'::regclass);
  
ALTER TABLE citydb.land_use
  ADD CONSTRAINT land_use_pk PRIMARY KEY (id);

ALTER TABLE citydb.masspoint_relief
  ADD CONSTRAINT masspoint_relief_pk PRIMARY KEY (id);

ALTER TABLE citydb.objectclass
  ADD CONSTRAINT objectclass_pk PRIMARY KEY (id);

ALTER TABLE citydb.opening
  ADD CONSTRAINT opening_pk PRIMARY KEY (id);

ALTER TABLE citydb.opening_to_them_surface
  ADD CONSTRAINT opening_to_them_surface_pk PRIMARY KEY (opening_id,thematic_surface_id);

ALTER TABLE citydb.plant_cover
  ADD CONSTRAINT plant_cover_pk PRIMARY KEY (id);

ALTER TABLE citydb.raster_relief
  ADD CONSTRAINT raster_relief_pk PRIMARY KEY (id);

ALTER TABLE citydb.relief_component
  ADD CONSTRAINT relief_component_pk PRIMARY KEY (id),
  ADD CONSTRAINT relief_comp_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)));

ALTER TABLE citydb.relief_feat_to_rel_comp
  ADD CONSTRAINT relief_feat_to_rel_comp_pk PRIMARY KEY (relief_component_id,relief_feature_id);

ALTER TABLE citydb.relief_feature
  ADD CONSTRAINT relief_feature_pk PRIMARY KEY (id),
  ADD CONSTRAINT relief_feat_lod_chk CHECK (((lod >= (0)::numeric) AND (lod < (5)::numeric)));

ALTER TABLE citydb.room
  ADD CONSTRAINT room_pk PRIMARY KEY (id);

ALTER TABLE citydb.solitary_vegetat_object
  ADD CONSTRAINT solitary_veg_object_pk PRIMARY KEY (id);

ALTER TABLE citydb.surface_data
  ADD CONSTRAINT surface_data_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.surface_data_seq'::regclass);

ALTER TABLE citydb.surface_geometry
  ADD CONSTRAINT surface_geometry_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.surface_geometry_seq'::regclass);

ALTER TABLE citydb.tex_image
  ADD CONSTRAINT tex_image_pk PRIMARY KEY (id),
  ALTER COLUMN id SET DEFAULT nextval('citydb.tex_image_seq'::regclass);

ALTER TABLE citydb.textureparam
  ADD CONSTRAINT textureparam_pk PRIMARY KEY (surface_geometry_id,surface_data_id);

ALTER TABLE citydb.thematic_surface
  ADD CONSTRAINT thematic_surface_pk PRIMARY KEY (id);

ALTER TABLE citydb.tin_relief
  ADD CONSTRAINT tin_relief_pk PRIMARY KEY (id);

ALTER TABLE citydb.transportation_complex
  ADD CONSTRAINT transportation_complex_pk PRIMARY KEY (id);

ALTER TABLE citydb.traffic_area
  ADD CONSTRAINT traffic_area_pk PRIMARY KEY (id);

ALTER TABLE citydb.tunnel
  ADD CONSTRAINT tunnel_pk PRIMARY KEY (id);

ALTER TABLE citydb.tunnel_furniture
  ADD CONSTRAINT tunnel_furniture_pk PRIMARY KEY (id);

ALTER TABLE citydb.tunnel_hollow_space
  ADD CONSTRAINT tunnel_hollow_space_pk PRIMARY KEY (id);

ALTER TABLE citydb.tunnel_installation
  ADD CONSTRAINT tunnel_installation_pk PRIMARY KEY (id);

ALTER TABLE citydb.tunnel_open_to_them_srf
  ADD CONSTRAINT tunnel_open_to_them_srf_pk PRIMARY KEY (tunnel_opening_id,tunnel_thematic_surface_id);

ALTER TABLE citydb.tunnel_opening
  ADD CONSTRAINT tunnel_opening_pk PRIMARY KEY (id);

ALTER TABLE citydb.tunnel_thematic_surface
  ADD CONSTRAINT tunnel_thematic_surface_pk PRIMARY KEY (id);

ALTER TABLE citydb.waterbod_to_waterbnd_srf
  ADD CONSTRAINT waterbod_to_waterbnd_pk PRIMARY KEY (waterboundary_surface_id,waterbody_id);

ALTER TABLE citydb.waterbody
  ADD CONSTRAINT waterbody_pk PRIMARY KEY (id);

ALTER TABLE citydb.waterboundary_surface
  ADD CONSTRAINT waterboundary_surface_pk PRIMARY KEY (id);


ALTER TABLE citydb.ade
  ADD CONSTRAINT ade_pk PRIMARY KEY (id);

ALTER TABLE citydb.schema
  ADD CONSTRAINT schema_pk PRIMARY KEY (id);

ALTER TABLE citydb.schema_referencing
  ADD CONSTRAINT schema_referencing_pk PRIMARY KEY (referenced_id,referencing_id);

ALTER TABLE citydb.schema_to_objectclass
  ADD CONSTRAINT schema_to_objectclass_pk PRIMARY KEY (schema_id,objectclass_id);

ALTER TABLE citydb.aggregation_info
  ADD CONSTRAINT aggregation_info_pk PRIMARY KEY (child_id,parent_id,join_table_or_column_name);
  

--// FOREIGN KEYS
ALTER TABLE citydb.address_to_bridge 
  ADD CONSTRAINT address_to_bridge_fk FOREIGN KEY (address_id)
    REFERENCES citydb.address (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT address_to_bridge_fk1 FOREIGN KEY (bridge_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.address_to_building
  ADD CONSTRAINT address_to_building_fk FOREIGN KEY (address_id)
    REFERENCES citydb.address (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT address_to_building_fk1 FOREIGN KEY (building_id)
    REFERENCES citydb.building (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.appear_to_surface_data
  ADD CONSTRAINT app_to_surf_data_fk FOREIGN KEY (surface_data_id)
    REFERENCES citydb.surface_data (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT app_to_surf_data_fk1 FOREIGN KEY (appearance_id)
    REFERENCES citydb.appearance (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.appearance
  ADD CONSTRAINT appearance_cityobject_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT appearance_citymodel_fk FOREIGN KEY (citymodel_id)
    REFERENCES citydb.citymodel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.breakline_relief
  ADD CONSTRAINT breakline_relief_comp_fk FOREIGN KEY (id)
    REFERENCES citydb.relief_component (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge
  ADD CONSTRAINT bridge_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_parent_fk FOREIGN KEY (bridge_parent_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_root_fk FOREIGN KEY (bridge_root_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod1solid_fk FOREIGN KEY (lod1_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod2solid_fk FOREIGN KEY (lod2_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod3solid_fk FOREIGN KEY (lod3_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_constr_element 
  ADD CONSTRAINT bridge_constr_cityobj_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_bridge_fk FOREIGN KEY (bridge_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod1brep_fk FOREIGN KEY (lod1_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_constr_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_furniture
  ADD CONSTRAINT bridge_furn_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_furn_brd_room_fk FOREIGN KEY (bridge_room_id)
    REFERENCES citydb.bridge_room (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_installation 
  ADD CONSTRAINT bridge_inst_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_bridge_fk FOREIGN KEY (bridge_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_brd_room_fk FOREIGN KEY (bridge_room_id)
    REFERENCES citydb.bridge_room (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_open_to_them_srf 
  ADD CONSTRAINT brd_open_to_them_srf_fk FOREIGN KEY (bridge_opening_id)
    REFERENCES citydb.bridge_opening (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT brd_open_to_them_srf_fk1 FOREIGN KEY (bridge_thematic_surface_id)
    REFERENCES citydb.bridge_thematic_surface (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_opening 
  ADD CONSTRAINT bridge_open_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_open_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_open_address_fk FOREIGN KEY (address_id)
    REFERENCES citydb.address (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_room 
  ADD CONSTRAINT bridge_room_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_room_bridge_fk FOREIGN KEY (bridge_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bridge_room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_thematic_surface 
  ADD CONSTRAINT brd_them_srf_cityobj_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_bridge_fk FOREIGN KEY (bridge_id)
    REFERENCES citydb.bridge (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_brd_room_fk FOREIGN KEY (bridge_room_id)
    REFERENCES citydb.bridge_room (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_brd_inst_fk FOREIGN KEY (bridge_installation_id)
    REFERENCES citydb.bridge_installation (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_brd_const_fk FOREIGN KEY (bridge_constr_element_id)
    REFERENCES citydb.bridge_constr_element (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT brd_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.building
  ADD CONSTRAINT building_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_parent_fk FOREIGN KEY (building_parent_id)
    REFERENCES citydb.building (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_root_fk FOREIGN KEY (building_root_id)
    REFERENCES citydb.building (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod0footprint_fk FOREIGN KEY (lod0_footprint_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod0roofprint_fk FOREIGN KEY (lod0_roofprint_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod1solid_fk FOREIGN KEY (lod1_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod2solid_fk FOREIGN KEY (lod2_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod3solid_fk FOREIGN KEY (lod3_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT building_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.building_furniture
  ADD CONSTRAINT bldg_furn_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_furn_room_fk FOREIGN KEY (room_id)
    REFERENCES citydb.room (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.building_installation
  ADD CONSTRAINT bldg_inst_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_building_fk FOREIGN KEY (building_id)
    REFERENCES citydb.building (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_room_fk FOREIGN KEY (room_id)
    REFERENCES citydb.room (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT bldg_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.city_furniture
  ADD CONSTRAINT city_furn_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod1brep_fk FOREIGN KEY (lod1_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT city_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.cityobject
  ADD CONSTRAINT cityobject_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.cityobject_genericattrib
  ADD CONSTRAINT genericattrib_parent_fk FOREIGN KEY (parent_genattrib_id)
    REFERENCES citydb.cityobject_genericattrib (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT genericattrib_root_fk FOREIGN KEY (root_genattrib_id)
    REFERENCES citydb.cityobject_genericattrib (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT genericattrib_geom_fk FOREIGN KEY (surface_geometry_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT genericattrib_cityobj_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.cityobject_member
  ADD CONSTRAINT cityobject_member_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT cityobject_member_fk1 FOREIGN KEY (citymodel_id)
    REFERENCES citydb.citymodel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.cityobjectgroup
  ADD CONSTRAINT group_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT group_brep_fk FOREIGN KEY (brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT group_parent_cityobj_fk FOREIGN KEY (parent_cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.external_reference
  ADD CONSTRAINT ext_ref_cityobject_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.generalization
  ADD CONSTRAINT general_cityobject_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT general_generalizes_to_fk FOREIGN KEY (generalizes_to_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.generic_cityobject
  ADD CONSTRAINT gen_object_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod0brep_fk FOREIGN KEY (lod0_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod1brep_fk FOREIGN KEY (lod1_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod0impl_fk FOREIGN KEY (lod0_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT gen_object_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.group_to_cityobject
  ADD CONSTRAINT group_to_cityobject_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT group_to_cityobject_fk1 FOREIGN KEY (cityobjectgroup_id)
    REFERENCES citydb.cityobjectgroup (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.implicit_geometry
  ADD CONSTRAINT implicit_geom_brep_fk FOREIGN KEY (relative_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;
  
ALTER TABLE citydb.land_use
  ADD CONSTRAINT land_use_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT land_use_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT land_use_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT land_use_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT land_use_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT land_use_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.masspoint_relief
  ADD CONSTRAINT masspoint_relief_comp_fk FOREIGN KEY (id)
    REFERENCES citydb.relief_component (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.objectclass 
  ADD CONSTRAINT objectclass_superclass_fk FOREIGN KEY (superclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.opening
  ADD CONSTRAINT opening_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT opening_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT opening_address_fk FOREIGN KEY (address_id)
    REFERENCES citydb.address (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT opening_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT opening_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT opening_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT opening_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.opening_to_them_surface
  ADD CONSTRAINT open_to_them_surface_fk FOREIGN KEY (opening_id)
    REFERENCES citydb.opening (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT open_to_them_surface_fk1 FOREIGN KEY (thematic_surface_id)
    REFERENCES citydb.thematic_surface (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.plant_cover
  ADD CONSTRAINT plant_cover_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod1msolid_fk FOREIGN KEY (lod1_multi_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod2msolid_fk FOREIGN KEY (lod2_multi_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod3msolid_fk FOREIGN KEY (lod3_multi_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT plant_cover_lod4msolid_fk FOREIGN KEY (lod4_multi_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.raster_relief 
  ADD CONSTRAINT raster_relief_comp_fk FOREIGN KEY (id)
    REFERENCES citydb.relief_component (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT raster_relief_coverage_fk FOREIGN KEY (coverage_id)
    REFERENCES citydb.grid_coverage (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.relief_component
  ADD CONSTRAINT relief_comp_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT relief_comp_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.relief_feat_to_rel_comp
  ADD CONSTRAINT rel_feat_to_rel_comp_fk FOREIGN KEY (relief_component_id)
    REFERENCES citydb.relief_component (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT rel_feat_to_rel_comp_fk1 FOREIGN KEY (relief_feature_id)
    REFERENCES citydb.relief_feature (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.relief_feature
  ADD CONSTRAINT relief_feat_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.room
  ADD CONSTRAINT room_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT room_building_fk FOREIGN KEY (building_id)
    REFERENCES citydb.building (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT room_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT room_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.solitary_vegetat_object
  ADD CONSTRAINT sol_veg_obj_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod1brep_fk FOREIGN KEY (lod1_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod1impl_fk FOREIGN KEY (lod1_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT sol_veg_obj_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.surface_data
  ADD CONSTRAINT surface_data_tex_image_fk FOREIGN KEY (tex_image_id)
    REFERENCES citydb.tex_image (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT surface_data_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.surface_geometry
  ADD CONSTRAINT surface_geom_parent_fk FOREIGN KEY (parent_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT surface_geom_root_fk FOREIGN KEY (root_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT surface_geom_cityobj_fk FOREIGN KEY (cityobject_id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.textureparam
  ADD CONSTRAINT texparam_geom_fk FOREIGN KEY (surface_geometry_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT texparam_surface_data_fk FOREIGN KEY (surface_data_id)
    REFERENCES citydb.surface_data (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.thematic_surface
  ADD CONSTRAINT them_surface_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_building_fk FOREIGN KEY (building_id)
    REFERENCES citydb.building (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_room_fk FOREIGN KEY (room_id)
    REFERENCES citydb.room (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_bldg_inst_fk FOREIGN KEY (building_installation_id)
    REFERENCES citydb.building_installation (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT them_surface_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tin_relief
  ADD CONSTRAINT tin_relief_comp_fk FOREIGN KEY (id)
    REFERENCES citydb.relief_component (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tin_relief_geom_fk FOREIGN KEY (surface_geometry_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.transportation_complex
  ADD CONSTRAINT tran_complex_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tran_complex_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tran_complex_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tran_complex_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tran_complex_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tran_complex_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.traffic_area
  ADD CONSTRAINT traffic_area_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT traffic_area_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT traffic_area_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT traffic_area_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT traffic_area_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT traffic_area_trancmplx_fk FOREIGN KEY (transportation_complex_id)
    REFERENCES citydb.transportation_complex (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel 
  ADD CONSTRAINT tunnel_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_parent_fk FOREIGN KEY (tunnel_parent_id)
    REFERENCES citydb.tunnel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_root_fk FOREIGN KEY (tunnel_root_id)
    REFERENCES citydb.tunnel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod1solid_fk FOREIGN KEY (lod1_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod2solid_fk FOREIGN KEY (lod2_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod3solid_fk FOREIGN KEY (lod3_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_furniture 
  ADD CONSTRAINT tunnel_furn_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_furn_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
    REFERENCES citydb.tunnel_hollow_space (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_furn_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_furn_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_hollow_space 
  ADD CONSTRAINT tun_hspace_cityobj_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_hspace_tunnel_fk FOREIGN KEY (tunnel_id)
    REFERENCES citydb.tunnel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_hspace_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_hspace_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_installation 
  ADD CONSTRAINT tunnel_inst_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_tunnel_fk FOREIGN KEY (tunnel_id)
    REFERENCES citydb.tunnel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
    REFERENCES citydb.tunnel_hollow_space (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_lod2brep_fk FOREIGN KEY (lod2_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_lod3brep_fk FOREIGN KEY (lod3_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_lod4brep_fk FOREIGN KEY (lod4_brep_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_lod2impl_fk FOREIGN KEY (lod2_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_inst_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_open_to_them_srf 
  ADD CONSTRAINT tun_open_to_them_srf_fk FOREIGN KEY (tunnel_opening_id)
    REFERENCES citydb.tunnel_opening (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT tun_open_to_them_srf_fk1 FOREIGN KEY (tunnel_thematic_surface_id)
    REFERENCES citydb.tunnel_thematic_surface (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_opening 
  ADD CONSTRAINT tunnel_open_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_open_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_open_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_open_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_open_lod3impl_fk FOREIGN KEY (lod3_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tunnel_open_lod4impl_fk FOREIGN KEY (lod4_implicit_rep_id)
    REFERENCES citydb.implicit_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_thematic_surface 
  ADD CONSTRAINT tun_them_srf_cityobj_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_tunnel_fk FOREIGN KEY (tunnel_id)
    REFERENCES citydb.tunnel (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_hspace_fk FOREIGN KEY (tunnel_hollow_space_id)
    REFERENCES citydb.tunnel_hollow_space (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_tun_inst_fk FOREIGN KEY (tunnel_installation_id)
    REFERENCES citydb.tunnel_installation (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_lod2msrf_fk FOREIGN KEY (lod2_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_lod3msrf_fk FOREIGN KEY (lod3_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT tun_them_srf_lod4msrf_fk FOREIGN KEY (lod4_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.waterbod_to_waterbnd_srf
  ADD CONSTRAINT waterbod_to_waterbnd_fk FOREIGN KEY (waterboundary_surface_id)
    REFERENCES citydb.waterboundary_surface (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT waterbod_to_waterbnd_fk1 FOREIGN KEY (waterbody_id)
    REFERENCES citydb.waterbody (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.waterbody
  ADD CONSTRAINT waterbody_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbody_lod0msrf_fk FOREIGN KEY (lod0_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbody_lod1msrf_fk FOREIGN KEY (lod1_multi_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbody_lod1solid_fk FOREIGN KEY (lod1_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbody_lod2solid_fk FOREIGN KEY (lod2_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbody_lod3solid_fk FOREIGN KEY (lod3_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbody_lod4solid_fk FOREIGN KEY (lod4_solid_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.waterboundary_surface
  ADD CONSTRAINT waterbnd_srf_cityobject_fk FOREIGN KEY (id)
    REFERENCES citydb.cityobject (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbnd_srf_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbnd_srf_lod2srf_fk FOREIGN KEY (lod2_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbnd_srf_lod3srf_fk FOREIGN KEY (lod3_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT waterbnd_srf_lod4srf_fk FOREIGN KEY (lod4_surface_id)
    REFERENCES citydb.surface_geometry (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

/*************************************************
* create foreign keys new in v4.0.0
*
**************************************************/ 
ALTER TABLE citydb.objectclass
  ADD CONSTRAINT objectclass_baseclass_fk FOREIGN KEY (baseclass_id)
    REFERENCES objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY (ade_id)
    REFERENCES citydb.ade (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema
  ADD CONSTRAINT schema_ade_fk FOREIGN KEY (ade_id)
    REFERENCES citydb.ade (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_to_objectclass
  ADD CONSTRAINT schema_to_objectclass_fk1 FOREIGN KEY (schema_id)
    REFERENCES citydb.schema (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT schema_to_objectclass_fk2 FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_referencing
  ADD CONSTRAINT schema_referencing_fk1 FOREIGN KEY (referencing_id)
    REFERENCES citydb.schema (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT schema_referencing_fk2 FOREIGN KEY (referenced_id)
    REFERENCES citydb.schema (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.aggregation_info
  ADD CONSTRAINT aggregation_info_fk1 FOREIGN KEY (child_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT aggregation_info_fk2 FOREIGN KEY (parent_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.bridge
  ADD CONSTRAINT bridge_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_constr_element
  ADD CONSTRAINT bridge_constr_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_furniture
  ADD CONSTRAINT bridge_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.bridge_room
  ADD CONSTRAINT bridge_room_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.building
  ADD CONSTRAINT building_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.building_furniture
  ADD CONSTRAINT bldg_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.room
  ADD CONSTRAINT room_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.city_furniture
  ADD CONSTRAINT city_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.generic_cityobject
  ADD CONSTRAINT gen_object_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.land_use
  ADD CONSTRAINT land_use_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE relief_feature
  ADD CONSTRAINT relief_feat_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.breakline_relief
  ADD CONSTRAINT breakline_rel_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.masspoint_relief
  ADD CONSTRAINT masspoint_rel_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.raster_relief
  ADD CONSTRAINT raster_relief_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tin_relief
  ADD CONSTRAINT tin_relief_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.plant_cover
  ADD CONSTRAINT plant_cover_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.solitary_vegetat_object
  ADD CONSTRAINT sol_veg_obj_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel
  ADD CONSTRAINT tunnel_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_furniture
  ADD CONSTRAINT tunnel_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.tunnel_hollow_space
  ADD CONSTRAINT tun_hspace_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.waterbody
  ADD CONSTRAINT waterbody_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE cityobjectgroup
  ADD CONSTRAINT group_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

/*************************************************
* create not null constraints
*
**************************************************/
ALTER TABLE citydb.cityobject_genericattrib
  ALTER COLUMN attrname SET NOT NULL;

DO
$$
DECLARE
  tab TEXT;
BEGIN
  FOR tab IN (
    SELECT
      a.attrelid::regclass::text
    FROM
      pg_attribute a,
      pg_class c,
      pg_namespace n
    WHERE
      a.attrelid = c.oid
      AND c.relnamespace = n.oid
      AND c.relkind = 'r'
      AND n.nspname = 'citydb'
      AND a.attname = 'objectclass_id'
  )
  LOOP
    EXECUTE format('ALTER TABLE citydb.%I ALTER COLUMN objectclass_id SET NOT NULL', tab);
  END LOOP;
END;
$$
LANGUAGE plpgsql;