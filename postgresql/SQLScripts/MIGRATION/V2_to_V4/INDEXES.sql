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

-- object: cityobject_member_fkx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_member_fkx CASCADE;
CREATE INDEX cityobject_member_fkx ON cityobject_member
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: cityobject_member_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_member_fkx1 CASCADE;
CREATE INDEX cityobject_member_fkx1 ON cityobject_member
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: general_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS general_cityobject_fkx CASCADE;
CREATE INDEX general_cityobject_fkx ON generalization
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: general_generalizes_to_fkx | type: INDEX --
-- DROP INDEX IF EXISTS general_generalizes_to_fkx CASCADE;
CREATE INDEX general_generalizes_to_fkx ON generalization
	USING btree
	(
	  generalizes_to_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: group_brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_brep_fkx CASCADE;
CREATE INDEX group_brep_fkx ON cityobjectgroup
	USING btree
	(
	  brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: group_xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS group_xgeom_spx CASCADE;
CREATE INDEX group_xgeom_spx ON cityobjectgroup
	USING gist
	(
	  other_geom
	);

-- object: group_parent_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_parent_cityobj_fkx CASCADE;
CREATE INDEX group_parent_cityobj_fkx ON cityobjectgroup
	USING btree
	(
	  parent_cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: group_to_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_to_cityobject_fkx CASCADE;
CREATE INDEX group_to_cityobject_fkx ON group_to_cityobject
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: group_to_cityobject_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS group_to_cityobject_fkx1 CASCADE;
CREATE INDEX group_to_cityobject_fkx1 ON group_to_cityobject
	USING btree
	(
	  cityobjectgroup_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: objectclass_superclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS objectclass_superclass_fkx CASCADE;
CREATE INDEX objectclass_superclass_fkx ON objectclass
	USING btree
	(
	  superclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1terr_spx CASCADE;
CREATE INDEX city_furn_lod1terr_spx ON city_furniture
	USING gist
	(
	  lod1_terrain_intersection
	);

-- object: city_furn_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2terr_spx CASCADE;
CREATE INDEX city_furn_lod2terr_spx ON city_furniture
	USING gist
	(
	  lod2_terrain_intersection
	);

-- object: city_furn_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3terr_spx CASCADE;
CREATE INDEX city_furn_lod3terr_spx ON city_furniture
	USING gist
	(
	  lod3_terrain_intersection
	);

-- object: city_furn_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4terr_spx CASCADE;
CREATE INDEX city_furn_lod4terr_spx ON city_furniture
	USING gist
	(
	  lod4_terrain_intersection
	);

-- object: city_furn_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1brep_fkx CASCADE;
CREATE INDEX city_furn_lod1brep_fkx ON city_furniture
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2brep_fkx CASCADE;
CREATE INDEX city_furn_lod2brep_fkx ON city_furniture
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3brep_fkx CASCADE;
CREATE INDEX city_furn_lod3brep_fkx ON city_furniture
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4brep_fkx CASCADE;
CREATE INDEX city_furn_lod4brep_fkx ON city_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1xgeom_spx CASCADE;
CREATE INDEX city_furn_lod1xgeom_spx ON city_furniture
	USING gist
	(
	  lod1_other_geom
	);

-- object: city_furn_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2xgeom_spx CASCADE;
CREATE INDEX city_furn_lod2xgeom_spx ON city_furniture
	USING gist
	(
	  lod2_other_geom
	);

-- object: city_furn_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3xgeom_spx CASCADE;
CREATE INDEX city_furn_lod3xgeom_spx ON city_furniture
	USING gist
	(
	  lod3_other_geom
	);

-- object: city_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4xgeom_spx CASCADE;
CREATE INDEX city_furn_lod4xgeom_spx ON city_furniture
	USING gist
	(
	  lod4_other_geom
	);

-- object: city_furn_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1impl_fkx CASCADE;
CREATE INDEX city_furn_lod1impl_fkx ON city_furniture
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2impl_fkx CASCADE;
CREATE INDEX city_furn_lod2impl_fkx ON city_furniture
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3impl_fkx CASCADE;
CREATE INDEX city_furn_lod3impl_fkx ON city_furniture
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4impl_fkx CASCADE;
CREATE INDEX city_furn_lod4impl_fkx ON city_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_lod1refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod1refpnt_spx CASCADE;
CREATE INDEX city_furn_lod1refpnt_spx ON city_furniture
	USING gist
	(
	  lod1_implicit_ref_point
	);

-- object: city_furn_lod2refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod2refpnt_spx CASCADE;
CREATE INDEX city_furn_lod2refpnt_spx ON city_furniture
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: city_furn_lod3refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod3refpnt_spx CASCADE;
CREATE INDEX city_furn_lod3refpnt_spx ON city_furniture
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: city_furn_lod4refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_lod4refpnt_spx CASCADE;
CREATE INDEX city_furn_lod4refpnt_spx ON city_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: gen_object_lod0terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0terr_spx CASCADE;
CREATE INDEX gen_object_lod0terr_spx ON generic_cityobject
	USING gist
	(
	  lod0_terrain_intersection
	);

-- object: gen_object_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1terr_spx CASCADE;
CREATE INDEX gen_object_lod1terr_spx ON generic_cityobject
	USING gist
	(
	  lod1_terrain_intersection
	);

-- object: gen_object_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2terr_spx CASCADE;
CREATE INDEX gen_object_lod2terr_spx ON generic_cityobject
	USING gist
	(
	  lod2_terrain_intersection
	);

-- object: gen_object_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3terr_spx CASCADE;
CREATE INDEX gen_object_lod3terr_spx ON generic_cityobject
	USING gist
	(
	  lod3_terrain_intersection
	);

-- object: gen_object_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4terr_spx CASCADE;
CREATE INDEX gen_object_lod4terr_spx ON generic_cityobject
	USING gist
	(
	  lod4_terrain_intersection
	);

-- object: gen_object_lod0brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0brep_fkx CASCADE;
CREATE INDEX gen_object_lod0brep_fkx ON generic_cityobject
	USING btree
	(
	  lod0_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1brep_fkx CASCADE;
CREATE INDEX gen_object_lod1brep_fkx ON generic_cityobject
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2brep_fkx CASCADE;
CREATE INDEX gen_object_lod2brep_fkx ON generic_cityobject
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3brep_fkx CASCADE;
CREATE INDEX gen_object_lod3brep_fkx ON generic_cityobject
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4brep_fkx CASCADE;
CREATE INDEX gen_object_lod4brep_fkx ON generic_cityobject
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod0xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0xgeom_spx CASCADE;
CREATE INDEX gen_object_lod0xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod0_other_geom
	);

-- object: gen_object_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1xgeom_spx CASCADE;
CREATE INDEX gen_object_lod1xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod1_other_geom
	);

-- object: gen_object_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2xgeom_spx CASCADE;
CREATE INDEX gen_object_lod2xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod2_other_geom
	);

-- object: gen_object_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3xgeom_spx CASCADE;
CREATE INDEX gen_object_lod3xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod3_other_geom
	);

-- object: gen_object_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4xgeom_spx CASCADE;
CREATE INDEX gen_object_lod4xgeom_spx ON generic_cityobject
	USING gist
	(
	  lod4_other_geom
	);

-- object: gen_object_lod0impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0impl_fkx CASCADE;
CREATE INDEX gen_object_lod0impl_fkx ON generic_cityobject
	USING btree
	(
	  lod0_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1impl_fkx CASCADE;
CREATE INDEX gen_object_lod1impl_fkx ON generic_cityobject
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2impl_fkx CASCADE;
CREATE INDEX gen_object_lod2impl_fkx ON generic_cityobject
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3impl_fkx CASCADE;
CREATE INDEX gen_object_lod3impl_fkx ON generic_cityobject
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4impl_fkx CASCADE;
CREATE INDEX gen_object_lod4impl_fkx ON generic_cityobject
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_lod0refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod0refpnt_spx CASCADE;
CREATE INDEX gen_object_lod0refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod0_implicit_ref_point
	);

-- object: gen_object_lod1refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod1refpnt_spx CASCADE;
CREATE INDEX gen_object_lod1refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod1_implicit_ref_point
	);

-- object: gen_object_lod2refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod2refpnt_spx CASCADE;
CREATE INDEX gen_object_lod2refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: gen_object_lod3refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod3refpnt_spx CASCADE;
CREATE INDEX gen_object_lod3refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: gen_object_lod4refpnt_spx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_lod4refpnt_spx CASCADE;
CREATE INDEX gen_object_lod4refpnt_spx ON generic_cityobject
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: address_to_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS address_to_building_fkx CASCADE;
CREATE INDEX address_to_building_fkx ON address_to_building
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: address_to_building_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS address_to_building_fkx1 CASCADE;
CREATE INDEX address_to_building_fkx1 ON address_to_building
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_parent_fkx CASCADE;
CREATE INDEX building_parent_fkx ON building
	USING btree
	(
	  building_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_root_fkx CASCADE;
CREATE INDEX building_root_fkx ON building
	USING btree
	(
	  building_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod1terr_spx CASCADE;
CREATE INDEX building_lod1terr_spx ON building
	USING gist
	(
	  lod1_terrain_intersection
	);

-- object: building_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2terr_spx CASCADE;
CREATE INDEX building_lod2terr_spx ON building
	USING gist
	(
	  lod2_terrain_intersection
	);

-- object: building_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3terr_spx CASCADE;
CREATE INDEX building_lod3terr_spx ON building
	USING gist
	(
	  lod3_terrain_intersection
	);

-- object: building_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4terr_spx CASCADE;
CREATE INDEX building_lod4terr_spx ON building
	USING gist
	(
	  lod4_terrain_intersection
	);

-- object: building_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2curve_spx CASCADE;
CREATE INDEX building_lod2curve_spx ON building
	USING gist
	(
	  lod2_multi_curve
	);

-- object: building_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3curve_spx CASCADE;
CREATE INDEX building_lod3curve_spx ON building
	USING gist
	(
	  lod3_multi_curve
	);

-- object: building_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4curve_spx CASCADE;
CREATE INDEX building_lod4curve_spx ON building
	USING gist
	(
	  lod4_multi_curve
	);

-- object: building_lod0footprint_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod0footprint_fkx CASCADE;
CREATE INDEX building_lod0footprint_fkx ON building
	USING btree
	(
	  lod0_footprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod0roofprint_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod0roofprint_fkx CASCADE;
CREATE INDEX building_lod0roofprint_fkx ON building
	USING btree
	(
	  lod0_roofprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod1msrf_fkx CASCADE;
CREATE INDEX building_lod1msrf_fkx ON building
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2msrf_fkx CASCADE;
CREATE INDEX building_lod2msrf_fkx ON building
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3msrf_fkx CASCADE;
CREATE INDEX building_lod3msrf_fkx ON building
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4msrf_fkx CASCADE;
CREATE INDEX building_lod4msrf_fkx ON building
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod1solid_fkx CASCADE;
CREATE INDEX building_lod1solid_fkx ON building
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod2solid_fkx CASCADE;
CREATE INDEX building_lod2solid_fkx ON building
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod3solid_fkx CASCADE;
CREATE INDEX building_lod3solid_fkx ON building
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_lod4solid_fkx CASCADE;
CREATE INDEX building_lod4solid_fkx ON building
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_furn_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_room_fkx CASCADE;
CREATE INDEX bldg_furn_room_fkx ON building_furniture
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4brep_fkx CASCADE;
CREATE INDEX bldg_furn_lod4brep_fkx ON building_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4xgeom_spx CASCADE;
CREATE INDEX bldg_furn_lod4xgeom_spx ON building_furniture
	USING gist
	(
	  lod4_other_geom
	);

-- object: bldg_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4impl_fkx CASCADE;
CREATE INDEX bldg_furn_lod4impl_fkx ON building_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_lod4refpt_spx CASCADE;
CREATE INDEX bldg_furn_lod4refpt_spx ON building_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: bldg_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_objclass_fkx CASCADE;
CREATE INDEX bldg_inst_objclass_fkx ON building_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

-- object: bldg_inst_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_building_fkx CASCADE;
CREATE INDEX bldg_inst_building_fkx ON building_installation
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_room_fkx CASCADE;
CREATE INDEX bldg_inst_room_fkx ON building_installation
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod2brep_fkx ON building_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod3brep_fkx ON building_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4brep_fkx CASCADE;
CREATE INDEX bldg_inst_lod4brep_fkx ON building_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod2xgeom_spx ON building_installation
	USING gist
	(
	  lod2_other_geom
	);

-- object: bldg_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod3xgeom_spx ON building_installation
	USING gist
	(
	  lod3_other_geom
	);

-- object: bldg_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4xgeom_spx CASCADE;
CREATE INDEX bldg_inst_lod4xgeom_spx ON building_installation
	USING gist
	(
	  lod4_other_geom
	);

-- object: bldg_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod2impl_fkx ON building_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod3impl_fkx ON building_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4impl_fkx CASCADE;
CREATE INDEX bldg_inst_lod4impl_fkx ON building_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod2refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod2refpt_spx ON building_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: bldg_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod3refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod3refpt_spx ON building_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: bldg_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_inst_lod4refpt_spx CASCADE;
CREATE INDEX bldg_inst_lod4refpt_spx ON building_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: opening_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_objectclass_fkx CASCADE;
CREATE INDEX opening_objectclass_fkx ON opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: opening_address_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_address_fkx CASCADE;
CREATE INDEX opening_address_fkx ON opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: opening_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod3msrf_fkx CASCADE;
CREATE INDEX opening_lod3msrf_fkx ON opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: opening_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod4msrf_fkx CASCADE;
CREATE INDEX opening_lod4msrf_fkx ON opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: opening_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod3impl_fkx CASCADE;
CREATE INDEX opening_lod3impl_fkx ON opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: opening_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod4impl_fkx CASCADE;
CREATE INDEX opening_lod4impl_fkx ON opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: opening_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod3refpt_spx CASCADE;
CREATE INDEX opening_lod3refpt_spx ON opening
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: opening_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS opening_lod4refpt_spx CASCADE;
CREATE INDEX opening_lod4refpt_spx ON opening
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: open_to_them_surface_fkx | type: INDEX --
-- DROP INDEX IF EXISTS open_to_them_surface_fkx CASCADE;
CREATE INDEX open_to_them_surface_fkx ON opening_to_them_surface
	USING btree
	(
	  opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: open_to_them_surface_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS open_to_them_surface_fkx1 CASCADE;
CREATE INDEX open_to_them_surface_fkx1 ON opening_to_them_surface
	USING btree
	(
	  thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: room_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_building_fkx CASCADE;
CREATE INDEX room_building_fkx ON room
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: room_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_lod4msrf_fkx CASCADE;
CREATE INDEX room_lod4msrf_fkx ON room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: room_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_lod4solid_fkx CASCADE;
CREATE INDEX room_lod4solid_fkx ON room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_objclass_fkx CASCADE;
CREATE INDEX them_surface_objclass_fkx ON thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_building_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_building_fkx CASCADE;
CREATE INDEX them_surface_building_fkx ON thematic_surface
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_room_fkx CASCADE;
CREATE INDEX them_surface_room_fkx ON thematic_surface
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_bldg_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_bldg_inst_fkx CASCADE;
CREATE INDEX them_surface_bldg_inst_fkx ON thematic_surface
	USING btree
	(
	  building_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_lod2msrf_fkx CASCADE;
CREATE INDEX them_surface_lod2msrf_fkx ON thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_lod3msrf_fkx CASCADE;
CREATE INDEX them_surface_lod3msrf_fkx ON thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: them_surface_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS them_surface_lod4msrf_fkx CASCADE;
CREATE INDEX them_surface_lod4msrf_fkx ON thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: texparam_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS texparam_geom_fkx CASCADE;
CREATE INDEX texparam_geom_fkx ON textureparam
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: texparam_surface_data_fkx | type: INDEX --
-- DROP INDEX IF EXISTS texparam_surface_data_fkx CASCADE;
CREATE INDEX texparam_surface_data_fkx ON textureparam
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: app_to_surf_data_fkx | type: INDEX --
-- DROP INDEX IF EXISTS app_to_surf_data_fkx CASCADE;
CREATE INDEX app_to_surf_data_fkx ON appear_to_surface_data
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: app_to_surf_data_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS app_to_surf_data_fkx1 CASCADE;
CREATE INDEX app_to_surf_data_fkx1 ON appear_to_surface_data
	USING btree
	(
	  appearance_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: breakline_ridge_spx | type: INDEX --
-- DROP INDEX IF EXISTS breakline_ridge_spx CASCADE;
CREATE INDEX breakline_ridge_spx ON breakline_relief
	USING gist
	(
	  ridge_or_valley_lines
	);

-- object: breakline_break_spx | type: INDEX --
-- DROP INDEX IF EXISTS breakline_break_spx CASCADE;
CREATE INDEX breakline_break_spx ON breakline_relief
	USING gist
	(
	  break_lines
	);

-- object: masspoint_relief_spx | type: INDEX --
-- DROP INDEX IF EXISTS masspoint_relief_spx CASCADE;
CREATE INDEX masspoint_relief_spx ON masspoint_relief
	USING gist
	(
	  relief_points
	);

-- object: relief_comp_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS relief_comp_objclass_fkx CASCADE;
CREATE INDEX relief_comp_objclass_fkx ON relief_component
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: relief_comp_extent_spx | type: INDEX --
-- DROP INDEX IF EXISTS relief_comp_extent_spx CASCADE;
CREATE INDEX relief_comp_extent_spx ON relief_component
	USING gist
	(
	  extent
	);

-- object: rel_feat_to_rel_comp_fkx | type: INDEX --
-- DROP INDEX IF EXISTS rel_feat_to_rel_comp_fkx CASCADE;
CREATE INDEX rel_feat_to_rel_comp_fkx ON relief_feat_to_rel_comp
	USING btree
	(
	  relief_component_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: rel_feat_to_rel_comp_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS rel_feat_to_rel_comp_fkx1 CASCADE;
CREATE INDEX rel_feat_to_rel_comp_fkx1 ON relief_feat_to_rel_comp
	USING btree
	(
	  relief_feature_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tin_relief_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_geom_fkx CASCADE;
CREATE INDEX tin_relief_geom_fkx ON tin_relief
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tin_relief_stop_spx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_stop_spx CASCADE;
CREATE INDEX tin_relief_stop_spx ON tin_relief
	USING gist
	(
	  stop_lines
	);

-- object: tin_relief_break_spx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_break_spx CASCADE;
CREATE INDEX tin_relief_break_spx ON tin_relief
	USING gist
	(
	  break_lines
	);

-- object: tin_relief_crtlpts_spx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_crtlpts_spx CASCADE;
CREATE INDEX tin_relief_crtlpts_spx ON tin_relief
	USING gist
	(
	  control_points
	);

-- object: tran_complex_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_objclass_fkx CASCADE;
CREATE INDEX tran_complex_objclass_fkx ON transportation_complex
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tran_complex_lod0net_spx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod0net_spx CASCADE;
CREATE INDEX tran_complex_lod0net_spx ON transportation_complex
	USING gist
	(
	  lod0_network
	);

-- object: tran_complex_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod1msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod1msrf_fkx ON transportation_complex
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tran_complex_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod2msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod2msrf_fkx ON transportation_complex
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tran_complex_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod3msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod3msrf_fkx ON transportation_complex
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tran_complex_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tran_complex_lod4msrf_fkx CASCADE;
CREATE INDEX tran_complex_lod4msrf_fkx ON transportation_complex
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: traffic_area_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_objclass_fkx CASCADE;
CREATE INDEX traffic_area_objclass_fkx ON traffic_area
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

-- object: traffic_area_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_lod2msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod2msrf_fkx ON traffic_area
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: traffic_area_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_lod3msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod3msrf_fkx ON traffic_area
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: traffic_area_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_lod4msrf_fkx CASCADE;
CREATE INDEX traffic_area_lod4msrf_fkx ON traffic_area
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: traffic_area_trancmplx_fkx | type: INDEX --
-- DROP INDEX IF EXISTS traffic_area_trancmplx_fkx CASCADE;
CREATE INDEX traffic_area_trancmplx_fkx ON traffic_area
	USING btree
	(
	  transportation_complex_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: land_use_lod0msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod0msrf_fkx CASCADE;
CREATE INDEX land_use_lod0msrf_fkx ON land_use
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: land_use_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod1msrf_fkx CASCADE;
CREATE INDEX land_use_lod1msrf_fkx ON land_use
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: land_use_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod2msrf_fkx CASCADE;
CREATE INDEX land_use_lod2msrf_fkx ON land_use
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: land_use_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod3msrf_fkx CASCADE;
CREATE INDEX land_use_lod3msrf_fkx ON land_use
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: land_use_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_lod4msrf_fkx CASCADE;
CREATE INDEX land_use_lod4msrf_fkx ON land_use
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod1msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod1msrf_fkx ON plant_cover
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod2msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod2msrf_fkx ON plant_cover
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod3msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod3msrf_fkx ON plant_cover
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod4msrf_fkx CASCADE;
CREATE INDEX plant_cover_lod4msrf_fkx ON plant_cover
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod1msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod1msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod1msolid_fkx ON plant_cover
	USING btree
	(
	  lod1_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod2msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod2msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod2msolid_fkx ON plant_cover
	USING btree
	(
	  lod2_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod3msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod3msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod3msolid_fkx ON plant_cover
	USING btree
	(
	  lod3_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_lod4msolid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_lod4msolid_fkx CASCADE;
CREATE INDEX plant_cover_lod4msolid_fkx ON plant_cover
	USING btree
	(
	  lod4_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod1brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod2brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod3brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4brep_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod4brep_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod1xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod1_other_geom
	);

-- object: sol_veg_obj_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod2xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod2_other_geom
	);

-- object: sol_veg_obj_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod3xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod3_other_geom
	);

-- object: sol_veg_obj_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4xgeom_spx CASCADE;
CREATE INDEX sol_veg_obj_lod4xgeom_spx ON solitary_vegetat_object
	USING gist
	(
	  lod4_other_geom
	);

-- object: sol_veg_obj_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod1impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod2impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod3impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4impl_fkx CASCADE;
CREATE INDEX sol_veg_obj_lod4impl_fkx ON solitary_vegetat_object
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_lod1refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod1refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod1refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod1_implicit_ref_point
	);

-- object: sol_veg_obj_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod2refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod2refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: sol_veg_obj_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod3refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod3refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: sol_veg_obj_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_lod4refpt_spx CASCADE;
CREATE INDEX sol_veg_obj_lod4refpt_spx ON solitary_vegetat_object
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: waterbody_lod0curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod0curve_spx CASCADE;
CREATE INDEX waterbody_lod0curve_spx ON waterbody
	USING gist
	(
	  lod0_multi_curve
	);

-- object: waterbody_lod1curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod1curve_spx CASCADE;
CREATE INDEX waterbody_lod1curve_spx ON waterbody
	USING gist
	(
	  lod1_multi_curve
	);

-- object: waterbody_lod0msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod0msrf_fkx CASCADE;
CREATE INDEX waterbody_lod0msrf_fkx ON waterbody
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbody_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod1msrf_fkx CASCADE;
CREATE INDEX waterbody_lod1msrf_fkx ON waterbody
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbody_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod1solid_fkx CASCADE;
CREATE INDEX waterbody_lod1solid_fkx ON waterbody
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbody_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod2solid_fkx CASCADE;
CREATE INDEX waterbody_lod2solid_fkx ON waterbody
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbody_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod3solid_fkx CASCADE;
CREATE INDEX waterbody_lod3solid_fkx ON waterbody
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbody_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_lod4solid_fkx CASCADE;
CREATE INDEX waterbody_lod4solid_fkx ON waterbody
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbod_to_waterbnd_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbod_to_waterbnd_fkx CASCADE;
CREATE INDEX waterbod_to_waterbnd_fkx ON waterbod_to_waterbnd_srf
	USING btree
	(
	  waterboundary_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbod_to_waterbnd_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS waterbod_to_waterbnd_fkx1 CASCADE;
CREATE INDEX waterbod_to_waterbnd_fkx1 ON waterbod_to_waterbnd_srf
	USING btree
	(
	  waterbody_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbnd_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_objclass_fkx CASCADE;
CREATE INDEX waterbnd_srf_objclass_fkx ON waterboundary_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbnd_srf_lod2srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_lod2srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod2srf_fkx ON waterboundary_surface
	USING btree
	(
	  lod2_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbnd_srf_lod3srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_lod3srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod3srf_fkx ON waterboundary_surface
	USING btree
	(
	  lod3_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbnd_srf_lod4srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbnd_srf_lod4srf_fkx CASCADE;
CREATE INDEX waterbnd_srf_lod4srf_fkx ON waterboundary_surface
	USING btree
	(
	  lod4_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: raster_relief_coverage_fkx | type: INDEX --
-- DROP INDEX IF EXISTS raster_relief_coverage_fkx CASCADE;
CREATE INDEX raster_relief_coverage_fkx ON raster_relief
	USING btree
	(
	  coverage_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_parent_fkx CASCADE;
CREATE INDEX tunnel_parent_fkx ON tunnel
	USING btree
	(
	  tunnel_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_root_fkx CASCADE;
CREATE INDEX tunnel_root_fkx ON tunnel
	USING btree
	(
	  tunnel_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod1terr_spx CASCADE;
CREATE INDEX tunnel_lod1terr_spx ON tunnel
	USING gist
	(
	  lod1_terrain_intersection
	);

-- object: tunnel_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2terr_spx CASCADE;
CREATE INDEX tunnel_lod2terr_spx ON tunnel
	USING gist
	(
	  lod2_terrain_intersection
	);

-- object: tunnel_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3terr_spx CASCADE;
CREATE INDEX tunnel_lod3terr_spx ON tunnel
	USING gist
	(
	  lod3_terrain_intersection
	);

-- object: tunnel_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4terr_spx CASCADE;
CREATE INDEX tunnel_lod4terr_spx ON tunnel
	USING gist
	(
	  lod4_terrain_intersection
	);

-- object: tunnel_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2curve_spx CASCADE;
CREATE INDEX tunnel_lod2curve_spx ON tunnel
	USING gist
	(
	  lod2_multi_curve
	);

-- object: tunnel_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3curve_spx CASCADE;
CREATE INDEX tunnel_lod3curve_spx ON tunnel
	USING gist
	(
	  lod3_multi_curve
	);

-- object: tunnel_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4curve_spx CASCADE;
CREATE INDEX tunnel_lod4curve_spx ON tunnel
	USING gist
	(
	  lod4_multi_curve
	);

-- object: tunnel_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod1msrf_fkx CASCADE;
CREATE INDEX tunnel_lod1msrf_fkx ON tunnel
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2msrf_fkx CASCADE;
CREATE INDEX tunnel_lod2msrf_fkx ON tunnel
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3msrf_fkx CASCADE;
CREATE INDEX tunnel_lod3msrf_fkx ON tunnel
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4msrf_fkx CASCADE;
CREATE INDEX tunnel_lod4msrf_fkx ON tunnel
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod1solid_fkx CASCADE;
CREATE INDEX tunnel_lod1solid_fkx ON tunnel
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod2solid_fkx CASCADE;
CREATE INDEX tunnel_lod2solid_fkx ON tunnel
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod3solid_fkx CASCADE;
CREATE INDEX tunnel_lod3solid_fkx ON tunnel
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_lod4solid_fkx CASCADE;
CREATE INDEX tunnel_lod4solid_fkx ON tunnel
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_open_to_them_srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_open_to_them_srf_fkx CASCADE;
CREATE INDEX tun_open_to_them_srf_fkx ON tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_open_to_them_srf_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS tun_open_to_them_srf_fkx1 CASCADE;
CREATE INDEX tun_open_to_them_srf_fkx1 ON tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_hspace_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_tunnel_fkx CASCADE;
CREATE INDEX tun_hspace_tunnel_fkx ON tunnel_hollow_space
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_hspace_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_lod4msrf_fkx CASCADE;
CREATE INDEX tun_hspace_lod4msrf_fkx ON tunnel_hollow_space
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_hspace_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_lod4solid_fkx CASCADE;
CREATE INDEX tun_hspace_lod4solid_fkx ON tunnel_hollow_space
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_objclass_fkx CASCADE;
CREATE INDEX tun_them_srf_objclass_fkx ON tunnel_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_tunnel_fkx CASCADE;
CREATE INDEX tun_them_srf_tunnel_fkx ON tunnel_thematic_surface
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_hspace_fkx CASCADE;
CREATE INDEX tun_them_srf_hspace_fkx ON tunnel_thematic_surface
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_tun_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_tun_inst_fkx CASCADE;
CREATE INDEX tun_them_srf_tun_inst_fkx ON tunnel_thematic_surface
	USING btree
	(
	  tunnel_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_lod2msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod2msrf_fkx ON tunnel_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_lod3msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod3msrf_fkx ON tunnel_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_them_srf_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_them_srf_lod4msrf_fkx CASCADE;
CREATE INDEX tun_them_srf_lod4msrf_fkx ON tunnel_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_open_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_objclass_fkx CASCADE;
CREATE INDEX tunnel_open_objclass_fkx ON tunnel_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_open_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod3msrf_fkx CASCADE;
CREATE INDEX tunnel_open_lod3msrf_fkx ON tunnel_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_open_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod4msrf_fkx CASCADE;
CREATE INDEX tunnel_open_lod4msrf_fkx ON tunnel_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_open_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod3impl_fkx CASCADE;
CREATE INDEX tunnel_open_lod3impl_fkx ON tunnel_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_open_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_open_lod4impl_fkx ON tunnel_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_open_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod3refpt_spx CASCADE;
CREATE INDEX tunnel_open_lod3refpt_spx ON tunnel_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: tunnel_open_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_open_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_open_lod4refpt_spx ON tunnel_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: tunnel_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_objclass_fkx CASCADE;
CREATE INDEX tunnel_inst_objclass_fkx ON tunnel_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

-- object: tunnel_inst_tunnel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_tunnel_fkx CASCADE;
CREATE INDEX tunnel_inst_tunnel_fkx ON tunnel_installation
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_hspace_fkx CASCADE;
CREATE INDEX tunnel_inst_hspace_fkx ON tunnel_installation
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod2brep_fkx ON tunnel_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod3brep_fkx ON tunnel_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4brep_fkx CASCADE;
CREATE INDEX tunnel_inst_lod4brep_fkx ON tunnel_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod2xgeom_spx ON tunnel_installation
	USING gist
	(
	  lod2_other_geom
	);

-- object: tunnel_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod3xgeom_spx ON tunnel_installation
	USING gist
	(
	  lod3_other_geom
	);

-- object: tunnel_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4xgeom_spx CASCADE;
CREATE INDEX tunnel_inst_lod4xgeom_spx ON tunnel_installation
	USING gist
	(
	  lod4_other_geom
	);

-- object: tunnel_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod2impl_fkx ON tunnel_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod3impl_fkx ON tunnel_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_inst_lod4impl_fkx ON tunnel_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod2refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod2refpt_spx ON tunnel_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: tunnel_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod3refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod3refpt_spx ON tunnel_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: tunnel_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_inst_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_inst_lod4refpt_spx ON tunnel_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: tunnel_furn_hspace_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_hspace_fkx CASCADE;
CREATE INDEX tunnel_furn_hspace_fkx ON tunnel_furniture
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4brep_fkx CASCADE;
CREATE INDEX tunnel_furn_lod4brep_fkx ON tunnel_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4xgeom_spx CASCADE;
CREATE INDEX tunnel_furn_lod4xgeom_spx ON tunnel_furniture
	USING gist
	(
	  lod4_other_geom
	);

-- object: tunnel_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4impl_fkx CASCADE;
CREATE INDEX tunnel_furn_lod4impl_fkx ON tunnel_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_lod4refpt_spx CASCADE;
CREATE INDEX tunnel_furn_lod4refpt_spx ON tunnel_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: bridge_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_parent_fkx CASCADE;
CREATE INDEX bridge_parent_fkx ON bridge
	USING btree
	(
	  bridge_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_root_fkx CASCADE;
CREATE INDEX bridge_root_fkx ON bridge
	USING btree
	(
	  bridge_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod1terr_spx CASCADE;
CREATE INDEX bridge_lod1terr_spx ON bridge
	USING gist
	(
	  lod1_terrain_intersection
	);

-- object: bridge_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2terr_spx CASCADE;
CREATE INDEX bridge_lod2terr_spx ON bridge
	USING gist
	(
	  lod2_terrain_intersection
	);

-- object: bridge_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3terr_spx CASCADE;
CREATE INDEX bridge_lod3terr_spx ON bridge
	USING gist
	(
	  lod3_terrain_intersection
	);

-- object: bridge_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4terr_spx CASCADE;
CREATE INDEX bridge_lod4terr_spx ON bridge
	USING gist
	(
	  lod4_terrain_intersection
	);

-- object: bridge_lod2curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2curve_spx CASCADE;
CREATE INDEX bridge_lod2curve_spx ON bridge
	USING gist
	(
	  lod2_multi_curve
	);

-- object: bridge_lod3curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3curve_spx CASCADE;
CREATE INDEX bridge_lod3curve_spx ON bridge
	USING gist
	(
	  lod3_multi_curve
	);

-- object: bridge_lod4curve_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4curve_spx CASCADE;
CREATE INDEX bridge_lod4curve_spx ON bridge
	USING gist
	(
	  lod4_multi_curve
	);

-- object: bridge_lod1msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod1msrf_fkx CASCADE;
CREATE INDEX bridge_lod1msrf_fkx ON bridge
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2msrf_fkx CASCADE;
CREATE INDEX bridge_lod2msrf_fkx ON bridge
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3msrf_fkx CASCADE;
CREATE INDEX bridge_lod3msrf_fkx ON bridge
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_lod4msrf_fkx ON bridge
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod1solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod1solid_fkx CASCADE;
CREATE INDEX bridge_lod1solid_fkx ON bridge
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod2solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod2solid_fkx CASCADE;
CREATE INDEX bridge_lod2solid_fkx ON bridge
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod3solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod3solid_fkx CASCADE;
CREATE INDEX bridge_lod3solid_fkx ON bridge
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_lod4solid_fkx CASCADE;
CREATE INDEX bridge_lod4solid_fkx ON bridge
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_furn_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_brd_room_fkx CASCADE;
CREATE INDEX bridge_furn_brd_room_fkx ON bridge_furniture
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_furn_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4brep_fkx CASCADE;
CREATE INDEX bridge_furn_lod4brep_fkx ON bridge_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_furn_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_furn_lod4xgeom_spx ON bridge_furniture
	USING gist
	(
	  lod4_other_geom
	);

-- object: bridge_furn_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4impl_fkx CASCADE;
CREATE INDEX bridge_furn_lod4impl_fkx ON bridge_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_furn_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_lod4refpt_spx CASCADE;
CREATE INDEX bridge_furn_lod4refpt_spx ON bridge_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: bridge_inst_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_objclass_fkx CASCADE;
CREATE INDEX bridge_inst_objclass_fkx ON bridge_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

-- object: bridge_inst_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_bridge_fkx CASCADE;
CREATE INDEX bridge_inst_bridge_fkx ON bridge_installation
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_brd_room_fkx CASCADE;
CREATE INDEX bridge_inst_brd_room_fkx ON bridge_installation
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod2brep_fkx ON bridge_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod3brep_fkx ON bridge_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4brep_fkx CASCADE;
CREATE INDEX bridge_inst_lod4brep_fkx ON bridge_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod2xgeom_spx ON bridge_installation
	USING gist
	(
	  lod2_other_geom
	);

-- object: bridge_inst_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod3xgeom_spx ON bridge_installation
	USING gist
	(
	  lod3_other_geom
	);

-- object: bridge_inst_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_inst_lod4xgeom_spx ON bridge_installation
	USING gist
	(
	  lod4_other_geom
	);

-- object: bridge_inst_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod2impl_fkx ON bridge_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod3impl_fkx ON bridge_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4impl_fkx CASCADE;
CREATE INDEX bridge_inst_lod4impl_fkx ON bridge_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_inst_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod2refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod2refpt_spx ON bridge_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: bridge_inst_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod3refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod3refpt_spx ON bridge_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: bridge_inst_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_inst_lod4refpt_spx CASCADE;
CREATE INDEX bridge_inst_lod4refpt_spx ON bridge_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: bridge_open_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_objclass_fkx CASCADE;
CREATE INDEX bridge_open_objclass_fkx ON bridge_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_open_address_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_address_fkx CASCADE;
CREATE INDEX bridge_open_address_fkx ON bridge_opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_open_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod3msrf_fkx CASCADE;
CREATE INDEX bridge_open_lod3msrf_fkx ON bridge_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_open_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_open_lod4msrf_fkx ON bridge_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_open_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod3impl_fkx CASCADE;
CREATE INDEX bridge_open_lod3impl_fkx ON bridge_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_open_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod4impl_fkx CASCADE;
CREATE INDEX bridge_open_lod4impl_fkx ON bridge_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_open_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod3refpt_spx CASCADE;
CREATE INDEX bridge_open_lod3refpt_spx ON bridge_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: bridge_open_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_open_lod4refpt_spx CASCADE;
CREATE INDEX bridge_open_lod4refpt_spx ON bridge_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: brd_open_to_them_srf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_open_to_them_srf_fkx CASCADE;
CREATE INDEX brd_open_to_them_srf_fkx ON bridge_open_to_them_srf
	USING btree
	(
	  bridge_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_open_to_them_srf_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS brd_open_to_them_srf_fkx1 CASCADE;
CREATE INDEX brd_open_to_them_srf_fkx1 ON bridge_open_to_them_srf
	USING btree
	(
	  bridge_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_room_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_bridge_fkx CASCADE;
CREATE INDEX bridge_room_bridge_fkx ON bridge_room
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_room_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_lod4msrf_fkx CASCADE;
CREATE INDEX bridge_room_lod4msrf_fkx ON bridge_room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_room_lod4solid_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_lod4solid_fkx CASCADE;
CREATE INDEX bridge_room_lod4solid_fkx ON bridge_room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_objclass_fkx CASCADE;
CREATE INDEX brd_them_srf_objclass_fkx ON bridge_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_bridge_fkx CASCADE;
CREATE INDEX brd_them_srf_bridge_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_brd_room_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_brd_room_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_room_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_brd_inst_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_brd_inst_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_inst_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_brd_const_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_brd_const_fkx CASCADE;
CREATE INDEX brd_them_srf_brd_const_fkx ON bridge_thematic_surface
	USING btree
	(
	  bridge_constr_element_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_lod2msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_lod2msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod2msrf_fkx ON bridge_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_lod3msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_lod3msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod3msrf_fkx ON bridge_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: brd_them_srf_lod4msrf_fkx | type: INDEX --
-- DROP INDEX IF EXISTS brd_them_srf_lod4msrf_fkx CASCADE;
CREATE INDEX brd_them_srf_lod4msrf_fkx ON bridge_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_bridge_fkx CASCADE;
CREATE INDEX bridge_constr_bridge_fkx ON bridge_constr_element
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod1terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod1terr_spx CASCADE;
CREATE INDEX bridge_constr_lod1terr_spx ON bridge_constr_element
	USING gist
	(
	  lod1_terrain_intersection
	);

-- object: bridge_constr_lod2terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod2terr_spx CASCADE;
CREATE INDEX bridge_constr_lod2terr_spx ON bridge_constr_element
	USING gist
	(
	  lod2_terrain_intersection
	);

-- object: bridge_constr_lod3terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod3terr_spx CASCADE;
CREATE INDEX bridge_constr_lod3terr_spx ON bridge_constr_element
	USING gist
	(
	  lod3_terrain_intersection
	);

-- object: bridge_constr_lod4terr_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod4terr_spx CASCADE;
CREATE INDEX bridge_constr_lod4terr_spx ON bridge_constr_element
	USING gist
	(
	  lod4_terrain_intersection
	);

-- object: bridge_constr_lod1brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod1brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod1brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod2brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod2brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod2brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod3brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod3brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod3brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod4brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod4brep_fkx CASCADE;
CREATE INDEX bridge_constr_lod4brep_fkx ON bridge_constr_element
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_const_lod1xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod1xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod1xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod1_other_geom
	);

-- object: bridge_const_lod2xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod2xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod2xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod2_other_geom
	);

-- object: bridge_const_lod3xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod3xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod3xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod3_other_geom
	);

-- object: bridge_const_lod4xgeom_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod4xgeom_spx CASCADE;
CREATE INDEX bridge_const_lod4xgeom_spx ON bridge_constr_element
	USING gist
	(
	  lod4_other_geom
	);

-- object: bridge_constr_lod1impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod1impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod1impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod2impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod2impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod2impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod3impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod3impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod3impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_lod4impl_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_lod4impl_fkx CASCADE;
CREATE INDEX bridge_constr_lod4impl_fkx ON bridge_constr_element
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_const_lod1refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod1refpt_spx CASCADE;
CREATE INDEX bridge_const_lod1refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod1_implicit_ref_point
	);

-- object: bridge_const_lod2refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod2refpt_spx CASCADE;
CREATE INDEX bridge_const_lod2refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod2_implicit_ref_point
	);

-- object: bridge_const_lod3refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod3refpt_spx CASCADE;
CREATE INDEX bridge_const_lod3refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod3_implicit_ref_point
	);

-- object: bridge_const_lod4refpt_spx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_const_lod4refpt_spx CASCADE;
CREATE INDEX bridge_const_lod4refpt_spx ON bridge_constr_element
	USING gist
	(
	  lod4_implicit_ref_point
	);

-- object: address_to_bridge_fkx | type: INDEX --
-- DROP INDEX IF EXISTS address_to_bridge_fkx CASCADE;
CREATE INDEX address_to_bridge_fkx ON address_to_bridge
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: address_to_bridge_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS address_to_bridge_fkx1 CASCADE;
CREATE INDEX address_to_bridge_fkx1 ON address_to_bridge
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: cityobject_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_inx CASCADE;
CREATE INDEX cityobject_inx ON cityobject
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);

-- object: cityobject_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_objectclass_fkx CASCADE;
CREATE INDEX cityobject_objectclass_fkx ON cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: cityobject_envelope_spx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_envelope_spx CASCADE;
CREATE INDEX cityobject_envelope_spx ON cityobject
	USING gist
	(
	  envelope
	);

-- object: appearance_inx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_inx CASCADE;
CREATE INDEX appearance_inx ON appearance
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);

-- object: appearance_theme_inx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_theme_inx CASCADE;
CREATE INDEX appearance_theme_inx ON appearance
	USING btree
	(
	  theme ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: appearance_citymodel_fkx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_citymodel_fkx CASCADE;
CREATE INDEX appearance_citymodel_fkx ON appearance
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: appearance_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS appearance_cityobject_fkx CASCADE;
CREATE INDEX appearance_cityobject_fkx ON appearance
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: implicit_geom_ref2lib_inx | type: INDEX --
-- DROP INDEX IF EXISTS implicit_geom_ref2lib_inx CASCADE;
CREATE INDEX implicit_geom_ref2lib_inx ON implicit_geometry
	USING btree
	(
	  reference_to_library ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: implicit_geom_brep_fkx | type: INDEX --
-- DROP INDEX IF EXISTS implicit_geom_brep_fkx CASCADE;
CREATE INDEX implicit_geom_brep_fkx ON implicit_geometry
	USING btree
	(
	  relative_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: surface_geom_inx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_inx CASCADE;
CREATE INDEX surface_geom_inx ON surface_geometry
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);

-- object: surface_geom_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_parent_fkx CASCADE;
CREATE INDEX surface_geom_parent_fkx ON surface_geometry
	USING btree
	(
	  parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: surface_geom_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_root_fkx CASCADE;
CREATE INDEX surface_geom_root_fkx ON surface_geometry
	USING btree
	(
	  root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: surface_geom_spx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_spx CASCADE;
CREATE INDEX surface_geom_spx ON surface_geometry
	USING gist
	(
	  geometry
	);

-- object: surface_geom_solid_spx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_solid_spx CASCADE;
CREATE INDEX surface_geom_solid_spx ON surface_geometry
	USING gist
	(
	  solid_geometry
	);

-- object: surface_geom_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_geom_cityobj_fkx CASCADE;
CREATE INDEX surface_geom_cityobj_fkx ON surface_geometry
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: surface_data_inx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_inx CASCADE;
CREATE INDEX surface_data_inx ON surface_data
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	)	WITH (FILLFACTOR = 90);

-- object: surface_data_spx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_spx CASCADE;
CREATE INDEX surface_data_spx ON surface_data
	USING gist
	(
	  gt_reference_point
	);

-- object: surface_data_tex_image_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_tex_image_fkx CASCADE;
CREATE INDEX surface_data_tex_image_fkx ON surface_data
	USING btree
	(
	  tex_image_id ASC NULLS LAST
	);

-- object: citymodel_inx | type: INDEX --
-- DROP INDEX IF EXISTS citymodel_inx CASCADE;
CREATE INDEX citymodel_inx ON citymodel
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	);

-- object: genericattrib_parent_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_parent_fkx CASCADE;
CREATE INDEX genericattrib_parent_fkx ON cityobject_genericattrib
	USING btree
	(
	  parent_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: genericattrib_root_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_root_fkx CASCADE;
CREATE INDEX genericattrib_root_fkx ON cityobject_genericattrib
	USING btree
	(
	  root_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: genericattrib_geom_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_geom_fkx CASCADE;
CREATE INDEX genericattrib_geom_fkx ON cityobject_genericattrib
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: genericattrib_cityobj_fkx | type: INDEX --
-- DROP INDEX IF EXISTS genericattrib_cityobj_fkx CASCADE;
CREATE INDEX genericattrib_cityobj_fkx ON cityobject_genericattrib
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: ext_ref_cityobject_fkx | type: INDEX --
-- DROP INDEX IF EXISTS ext_ref_cityobject_fkx CASCADE;
CREATE INDEX ext_ref_cityobject_fkx ON external_reference
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: grid_coverage_raster_spx | type: INDEX --
-- DROP INDEX IF EXISTS grid_coverage_raster_spx CASCADE;
CREATE INDEX grid_coverage_raster_spx ON grid_coverage
	USING gist
	(
	  (ST_ConvexHull(rasterproperty))
	);

-- object: cityobject_lineage_inx | type: INDEX --
-- DROP INDEX IF EXISTS cityobject_lineage_inx CASCADE;
CREATE INDEX cityobject_lineage_inx ON cityobject
	USING btree
	(
	  lineage ASC NULLS LAST
	);

-- object: citymodel_envelope_spx | type: INDEX --
-- DROP INDEX IF EXISTS citymodel_envelope_spx CASCADE;
CREATE INDEX citymodel_envelope_spx ON citymodel
	USING gist
	(
	  envelope
	);

-- object: address_inx | type: INDEX --
-- DROP INDEX IF EXISTS address_inx CASCADE;
CREATE INDEX address_inx ON address
	USING btree
	(
	  gmlid ASC NULLS LAST,
	  gmlid_codespace
	);

-- object: address_point_spx | type: INDEX --
-- DROP INDEX IF EXISTS address_point_spx CASCADE;
CREATE INDEX address_point_spx ON address
	USING gist
	(
	  multi_point
	);

-- object: schema_to_objectclass_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS schema_to_objectclass_fkx1 CASCADE;
CREATE INDEX schema_to_objectclass_fkx1 ON schema_to_objectclass
	USING btree
	(
	  schema_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: schema_to_objectclass_fkx2 | type: INDEX --
-- DROP INDEX IF EXISTS schema_to_objectclass_fkx2 CASCADE;
CREATE INDEX schema_to_objectclass_fkx2 ON schema_to_objectclass
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: objectclass_baseclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS objectclass_baseclass_fkx CASCADE;
CREATE INDEX objectclass_baseclass_fkx ON objectclass
	USING btree
	(
	  baseclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: schema_referencing_fkx1 | type: INDEX --
-- DROP INDEX IF EXISTS schema_referencing_fkx1 CASCADE;
CREATE INDEX schema_referencing_fkx1 ON schema_referencing
	USING btree
	(
	  referenced_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: schema_referencing_fkx2 | type: INDEX --
-- DROP INDEX IF EXISTS schema_referencing_fkx2 CASCADE;
CREATE INDEX schema_referencing_fkx2 ON schema_referencing
	USING btree
	(
	  referencing_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: breakline_rel_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS breakline_rel_objclass_fkx CASCADE;
CREATE INDEX breakline_rel_objclass_fkx ON breakline_relief
	USING btree
	(
	  objectclass_id
	)	WITH (FILLFACTOR = 90);

-- object: bridge_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_objectclass_fkx CASCADE;
CREATE INDEX bridge_objectclass_fkx ON bridge
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_constr_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_constr_objclass_fkx CASCADE;
CREATE INDEX bridge_constr_objclass_fkx ON bridge_constr_element
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_furn_objclass_fkx CASCADE;
CREATE INDEX bridge_furn_objclass_fkx ON bridge_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bridge_room_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bridge_room_objclass_fkx CASCADE;
CREATE INDEX bridge_room_objclass_fkx ON bridge_room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: building_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS building_objectclass_fkx CASCADE;
CREATE INDEX building_objectclass_fkx ON building
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: bldg_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS bldg_furn_objclass_fkx CASCADE;
CREATE INDEX bldg_furn_objclass_fkx ON building_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: city_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS city_furn_objclass_fkx CASCADE;
CREATE INDEX city_furn_objclass_fkx ON city_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: group_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS group_objectclass_fkx CASCADE;
CREATE INDEX group_objectclass_fkx ON cityobjectgroup
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: gen_object_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS gen_object_objclass_fkx CASCADE;
CREATE INDEX gen_object_objclass_fkx ON generic_cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: land_use_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS land_use_objclass_fkx CASCADE;
CREATE INDEX land_use_objclass_fkx ON land_use
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: masspoint_rel_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS masspoint_rel_objclass_fkx CASCADE;
CREATE INDEX masspoint_rel_objclass_fkx ON masspoint_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: plant_cover_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS plant_cover_objclass_fkx CASCADE;
CREATE INDEX plant_cover_objclass_fkx ON plant_cover
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: raster_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS raster_relief_objclass_fkx CASCADE;
CREATE INDEX raster_relief_objclass_fkx ON raster_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: relief_feat_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS relief_feat_objclass_fkx CASCADE;
CREATE INDEX relief_feat_objclass_fkx ON relief_feature
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: room_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS room_objectclass_fkx CASCADE;
CREATE INDEX room_objectclass_fkx ON room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: sol_veg_obj_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS sol_veg_obj_objclass_fkx CASCADE;
CREATE INDEX sol_veg_obj_objclass_fkx ON solitary_vegetat_object
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tin_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tin_relief_objclass_fkx CASCADE;
CREATE INDEX tin_relief_objclass_fkx ON tin_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_objectclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_objectclass_fkx CASCADE;
CREATE INDEX tunnel_objectclass_fkx ON tunnel
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tunnel_furn_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tunnel_furn_objclass_fkx CASCADE;
CREATE INDEX tunnel_furn_objclass_fkx ON tunnel_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: tun_hspace_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS tun_hspace_objclass_fkx CASCADE;
CREATE INDEX tun_hspace_objclass_fkx ON tunnel_hollow_space
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: waterbody_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS waterbody_objclass_fkx CASCADE;
CREATE INDEX waterbody_objclass_fkx ON waterbody
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

-- object: surface_data_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS surface_data_objclass_fkx CASCADE;
CREATE INDEX surface_data_objclass_fkx ON surface_data
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

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