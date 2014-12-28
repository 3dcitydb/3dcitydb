-- INDEXES_V3.sql
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

DROP INDEX IF EXISTS citydb.cityobject_member_fkx;
CREATE INDEX cityobject_member_fkx ON citydb.cityobject_member
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.cityobject_member_fkx1;
CREATE INDEX cityobject_member_fkx1 ON citydb.cityobject_member
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.general_cityobject_fkx;
CREATE INDEX general_cityobject_fkx ON citydb.generalization
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.general_generalizes_to_fkx;
CREATE INDEX general_generalizes_to_fkx ON citydb.generalization
	USING btree
	(
	  generalizes_to_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.group_brep_fkx;
CREATE INDEX group_brep_fkx ON citydb.cityobjectgroup
	USING btree
	(
	  brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.group_xgeom_spx;
CREATE INDEX group_xgeom_spx ON citydb.cityobjectgroup
	USING gist
	(
	  other_geom
	);

DROP INDEX IF EXISTS citydb.group_parent_cityobj_fkx;
CREATE INDEX group_parent_cityobj_fkx ON citydb.cityobjectgroup
	USING btree
	(
	  parent_cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.group_to_cityobject_fkx;
CREATE INDEX group_to_cityobject_fkx ON citydb.group_to_cityobject
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.group_to_cityobject_fkx1;
CREATE INDEX group_to_cityobject_fkx1 ON citydb.group_to_cityobject
	USING btree
	(
	  cityobjectgroup_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.objectclass_superclass_fkx;
CREATE INDEX objectclass_superclass_fkx ON citydb.objectclass
	USING btree
	(
	  superclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod1terr_spx;
CREATE INDEX city_furn_lod1terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod1_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.city_furn_lod2terr_spx;
CREATE INDEX city_furn_lod2terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod2_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.city_furn_lod3terr_spx;
CREATE INDEX city_furn_lod3terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod3_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.city_furn_lod4terr_spx;
CREATE INDEX city_furn_lod4terr_spx ON citydb.city_furniture
	USING gist
	(
	  lod4_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.city_furn_lod1brep_fkx;
CREATE INDEX city_furn_lod1brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod2brep_fkx;
CREATE INDEX city_furn_lod2brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod3brep_fkx;
CREATE INDEX city_furn_lod3brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod4brep_fkx;
CREATE INDEX city_furn_lod4brep_fkx ON citydb.city_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod1xgeom_spx;
CREATE INDEX city_furn_lod1xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod1_other_geom
	);

DROP INDEX IF EXISTS citydb.city_furn_lod2xgeom_spx;
CREATE INDEX city_furn_lod2xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.city_furn_lod3xgeom_spx;
CREATE INDEX city_furn_lod3xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.city_furn_lod4xgeom_spx;
CREATE INDEX city_furn_lod4xgeom_spx ON citydb.city_furniture
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.city_furn_lod1impl_fkx;
CREATE INDEX city_furn_lod1impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod2impl_fkx;
CREATE INDEX city_furn_lod2impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod3impl_fkx;
CREATE INDEX city_furn_lod3impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod4impl_fkx;
CREATE INDEX city_furn_lod4impl_fkx ON citydb.city_furniture
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.city_furn_lod1refpnt_spx;
CREATE INDEX city_furn_lod1refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod1_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.city_furn_lod2refpnt_spx;
CREATE INDEX city_furn_lod2refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.city_furn_lod3refpnt_spx;
CREATE INDEX city_furn_lod3refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.city_furn_lod4refpnt_spx;
CREATE INDEX city_furn_lod4refpnt_spx ON citydb.city_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.gen_object_lod0terr_spx;
CREATE INDEX gen_object_lod0terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod0_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.gen_object_lod1terr_spx;
CREATE INDEX gen_object_lod1terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod1_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.gen_object_lod2terr_spx;
CREATE INDEX gen_object_lod2terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod2_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.gen_object_lod3terr_spx;
CREATE INDEX gen_object_lod3terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod3_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.gen_object_lod4terr_spx;
CREATE INDEX gen_object_lod4terr_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod4_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.gen_object_lod0brep_fkx;
CREATE INDEX gen_object_lod0brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod0_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod1brep_fkx;
CREATE INDEX gen_object_lod1brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod2brep_fkx;
CREATE INDEX gen_object_lod2brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod3brep_fkx;
CREATE INDEX gen_object_lod3brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod4brep_fkx;
CREATE INDEX gen_object_lod4brep_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod0xgeom_spx;
CREATE INDEX gen_object_lod0xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod0_other_geom
	);

DROP INDEX IF EXISTS citydb.gen_object_lod1xgeom_spx;
CREATE INDEX gen_object_lod1xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod1_other_geom
	);

DROP INDEX IF EXISTS citydb.gen_object_lod2xgeom_spx;
CREATE INDEX gen_object_lod2xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.gen_object_lod3xgeom_spx;
CREATE INDEX gen_object_lod3xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.gen_object_lod4xgeom_spx;
CREATE INDEX gen_object_lod4xgeom_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.gen_object_lod0impl_fkx;
CREATE INDEX gen_object_lod0impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod0_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod1impl_fkx;
CREATE INDEX gen_object_lod1impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod2impl_fkx;
CREATE INDEX gen_object_lod2impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod3impl_fkx;
CREATE INDEX gen_object_lod3impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod4impl_fkx;
CREATE INDEX gen_object_lod4impl_fkx ON citydb.generic_cityobject
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.gen_object_lod0refpnt_spx;
CREATE INDEX gen_object_lod0refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod0_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.gen_object_lod1refpnt_spx;
CREATE INDEX gen_object_lod1refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod1_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.gen_object_lod2refpnt_spx;
CREATE INDEX gen_object_lod2refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.gen_object_lod3refpnt_spx;
CREATE INDEX gen_object_lod3refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.gen_object_lod4refpnt_spx;
CREATE INDEX gen_object_lod4refpnt_spx ON citydb.generic_cityobject
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.address_to_building_fkx;
CREATE INDEX address_to_building_fkx ON citydb.address_to_building
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.address_to_building_fkx1;
CREATE INDEX address_to_building_fkx1 ON citydb.address_to_building
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_parent_fkx;
CREATE INDEX building_parent_fkx ON citydb.building
	USING btree
	(
	  building_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_root_fkx;
CREATE INDEX building_root_fkx ON citydb.building
	USING btree
	(
	  building_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod1terr_spx;
CREATE INDEX building_lod1terr_spx ON citydb.building
	USING gist
	(
	  lod1_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.building_lod2terr_spx;
CREATE INDEX building_lod2terr_spx ON citydb.building
	USING gist
	(
	  lod2_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.building_lod3terr_spx;
CREATE INDEX building_lod3terr_spx ON citydb.building
	USING gist
	(
	  lod3_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.building_lod4terr_spx;
CREATE INDEX building_lod4terr_spx ON citydb.building
	USING gist
	(
	  lod4_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.building_lod2curve_spx;
CREATE INDEX building_lod2curve_spx ON citydb.building
	USING gist
	(
	  lod2_multi_curve
	);

DROP INDEX IF EXISTS citydb.building_lod3curve_spx;
CREATE INDEX building_lod3curve_spx ON citydb.building
	USING gist
	(
	  lod3_multi_curve
	);

DROP INDEX IF EXISTS citydb.building_lod4curve_spx;
CREATE INDEX building_lod4curve_spx ON citydb.building
	USING gist
	(
	  lod4_multi_curve
	);

DROP INDEX IF EXISTS citydb.building_lod0footprint_fkx;
CREATE INDEX building_lod0footprint_fkx ON citydb.building
	USING btree
	(
	  lod0_footprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod0roofprint_fkx;
CREATE INDEX building_lod0roofprint_fkx ON citydb.building
	USING btree
	(
	  lod0_roofprint_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod1msrf_fkx;
CREATE INDEX building_lod1msrf_fkx ON citydb.building
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod2msrf_fkx;
CREATE INDEX building_lod2msrf_fkx ON citydb.building
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod3msrf_fkx;
CREATE INDEX building_lod3msrf_fkx ON citydb.building
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod4msrf_fkx;
CREATE INDEX building_lod4msrf_fkx ON citydb.building
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod1solid_fkx;
CREATE INDEX building_lod1solid_fkx ON citydb.building
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod2solid_fkx;
CREATE INDEX building_lod2solid_fkx ON citydb.building
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod3solid_fkx;
CREATE INDEX building_lod3solid_fkx ON citydb.building
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.building_lod4solid_fkx;
CREATE INDEX building_lod4solid_fkx ON citydb.building
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_furn_room_fkx;
CREATE INDEX bldg_furn_room_fkx ON citydb.building_furniture
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_furn_lod4brep_fkx;
CREATE INDEX bldg_furn_lod4brep_fkx ON citydb.building_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_furn_lod4xgeom_spx;
CREATE INDEX bldg_furn_lod4xgeom_spx ON citydb.building_furniture
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.bldg_furn_lod4impl_fkx;
CREATE INDEX bldg_furn_lod4impl_fkx ON citydb.building_furniture
	USING btree
	(
	  lod4_implicit_rep_id
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_furn_lod4refpt_spx;
CREATE INDEX bldg_furn_lod4refpt_spx ON citydb.building_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bldg_inst_objclass_fkx;
CREATE INDEX bldg_inst_objclass_fkx ON citydb.building_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

DROP INDEX IF EXISTS citydb.bldg_inst_building_fkx;
CREATE INDEX bldg_inst_building_fkx ON citydb.building_installation
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_room_fkx;
CREATE INDEX bldg_inst_room_fkx ON citydb.building_installation
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod2brep_fkx;
CREATE INDEX bldg_inst_lod2brep_fkx ON citydb.building_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod3brep_fkx;
CREATE INDEX bldg_inst_lod3brep_fkx ON citydb.building_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod4brep_fkx;
CREATE INDEX bldg_inst_lod4brep_fkx ON citydb.building_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod2xgeom_spx;
CREATE INDEX bldg_inst_lod2xgeom_spx ON citydb.building_installation
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.bldg_inst_lod3xgeom_spx;
CREATE INDEX bldg_inst_lod3xgeom_spx ON citydb.building_installation
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.bldg_inst_lod4xgeom_spx;
CREATE INDEX bldg_inst_lod4xgeom_spx ON citydb.building_installation
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.bldg_inst_lod2impl_fkx;
CREATE INDEX bldg_inst_lod2impl_fkx ON citydb.building_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod3impl_fkx;
CREATE INDEX bldg_inst_lod3impl_fkx ON citydb.building_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod4impl_fkx;
CREATE INDEX bldg_inst_lod4impl_fkx ON citydb.building_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bldg_inst_lod2refpt_spx;
CREATE INDEX bldg_inst_lod2refpt_spx ON citydb.building_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bldg_inst_lod3refpt_spx;
CREATE INDEX bldg_inst_lod3refpt_spx ON citydb.building_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bldg_inst_lod4refpt_spx;
CREATE INDEX bldg_inst_lod4refpt_spx ON citydb.building_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.opening_objectclass_fkx;
CREATE INDEX opening_objectclass_fkx ON citydb.opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.opening_address_fkx;
CREATE INDEX opening_address_fkx ON citydb.opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.opening_lod3msrf_fkx;
CREATE INDEX opening_lod3msrf_fkx ON citydb.opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.opening_lod4msrf_fkx;
CREATE INDEX opening_lod4msrf_fkx ON citydb.opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.opening_lod3impl_fkx;
CREATE INDEX opening_lod3impl_fkx ON citydb.opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.opening_lod4impl_fkx;
CREATE INDEX opening_lod4impl_fkx ON citydb.opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.opening_lod3refpt_spx;
CREATE INDEX opening_lod3refpt_spx ON citydb.opening
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.opening_lod4refpt_spx;
CREATE INDEX opening_lod4refpt_spx ON citydb.opening
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.open_to_them_surface_fkx;
CREATE INDEX open_to_them_surface_fkx ON citydb.opening_to_them_surface
	USING btree
	(
	  opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.open_to_them_surface_fkx1;
CREATE INDEX open_to_them_surface_fkx1 ON citydb.opening_to_them_surface
	USING btree
	(
	  thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.room_building_fkx;
CREATE INDEX room_building_fkx ON citydb.room
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.room_lod4msrf_fkx;
CREATE INDEX room_lod4msrf_fkx ON citydb.room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.room_lod4solid_fkx;
CREATE INDEX room_lod4solid_fkx ON citydb.room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_objclass_fkx;
CREATE INDEX them_surface_objclass_fkx ON citydb.thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_building_fkx;
CREATE INDEX them_surface_building_fkx ON citydb.thematic_surface
	USING btree
	(
	  building_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_room_fkx;
CREATE INDEX them_surface_room_fkx ON citydb.thematic_surface
	USING btree
	(
	  room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_bldg_inst_fkx;
CREATE INDEX them_surface_bldg_inst_fkx ON citydb.thematic_surface
	USING btree
	(
	  building_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_lod2msrf_fkx;
CREATE INDEX them_surface_lod2msrf_fkx ON citydb.thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_lod3msrf_fkx;
CREATE INDEX them_surface_lod3msrf_fkx ON citydb.thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.them_surface_lod4msrf_fkx;
CREATE INDEX them_surface_lod4msrf_fkx ON citydb.thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.texparam_geom_fkx;
CREATE INDEX texparam_geom_fkx ON citydb.textureparam
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.texparam_surface_data_fkx;
CREATE INDEX texparam_surface_data_fkx ON citydb.textureparam
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.app_to_surf_data_fkx;
CREATE INDEX app_to_surf_data_fkx ON citydb.appear_to_surface_data
	USING btree
	(
	  surface_data_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.app_to_surf_data_fkx1;
CREATE INDEX app_to_surf_data_fkx1 ON citydb.appear_to_surface_data
	USING btree
	(
	  appearance_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.breakline_ridge_spx;
CREATE INDEX breakline_ridge_spx ON citydb.breakline_relief
	USING gist
	(
	  ridge_or_valley_lines
	);

DROP INDEX IF EXISTS citydb.breakline_break_spx;
CREATE INDEX breakline_break_spx ON citydb.breakline_relief
	USING gist
	(
	  break_lines
	);

DROP INDEX IF EXISTS citydb.masspoint_relief_spx;
CREATE INDEX masspoint_relief_spx ON citydb.masspoint_relief
	USING gist
	(
	  relief_points
	);

DROP INDEX IF EXISTS citydb.relief_comp_objclass_fkx;
CREATE INDEX relief_comp_objclass_fkx ON citydb.relief_component
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.relief_comp_extent_spx;
CREATE INDEX relief_comp_extent_spx ON citydb.relief_component
	USING gist
	(
	  extent
	);

DROP INDEX IF EXISTS citydb.rel_feat_to_rel_comp_fkx;
CREATE INDEX rel_feat_to_rel_comp_fkx ON citydb.relief_feat_to_rel_comp
	USING btree
	(
	  relief_component_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.rel_feat_to_rel_comp_fkx1;
CREATE INDEX rel_feat_to_rel_comp_fkx1 ON citydb.relief_feat_to_rel_comp
	USING btree
	(
	  relief_feature_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tin_relief_geom_fkx;
CREATE INDEX tin_relief_geom_fkx ON citydb.tin_relief
	USING btree
	(
	  surface_geometry_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tin_relief_stop_spx;
CREATE INDEX tin_relief_stop_spx ON citydb.tin_relief
	USING gist
	(
	  stop_lines
	);

DROP INDEX IF EXISTS citydb.tin_relief_break_spx;
CREATE INDEX tin_relief_break_spx ON citydb.tin_relief
	USING gist
	(
	  break_lines
	);

DROP INDEX IF EXISTS citydb.tin_relief_crtlpts_spx;
CREATE INDEX tin_relief_crtlpts_spx ON citydb.tin_relief
	USING gist
	(
	  control_points
	);

DROP INDEX IF EXISTS citydb.tran_complex_objclass_fkx;
CREATE INDEX tran_complex_objclass_fkx ON citydb.transportation_complex
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tran_complex_lod0net_spx;
CREATE INDEX tran_complex_lod0net_spx ON citydb.transportation_complex
	USING gist
	(
	  lod0_network
	);

DROP INDEX IF EXISTS citydb.tran_complex_lod1msrf_fkx;
CREATE INDEX tran_complex_lod1msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tran_complex_lod2msrf_fkx;
CREATE INDEX tran_complex_lod2msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tran_complex_lod3msrf_fkx;
CREATE INDEX tran_complex_lod3msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tran_complex_lod4msrf_fkx;
CREATE INDEX tran_complex_lod4msrf_fkx ON citydb.transportation_complex
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.traffic_area_objclass_fkx;
CREATE INDEX traffic_area_objclass_fkx ON citydb.traffic_area
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

DROP INDEX IF EXISTS citydb.traffic_area_lod2msrf_fkx;
CREATE INDEX traffic_area_lod2msrf_fkx ON citydb.traffic_area
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.traffic_area_lod3msrf_fkx;
CREATE INDEX traffic_area_lod3msrf_fkx ON citydb.traffic_area
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.traffic_area_lod4msrf_fkx;
CREATE INDEX traffic_area_lod4msrf_fkx ON citydb.traffic_area
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.traffic_area_trancmplx_fkx;
CREATE INDEX traffic_area_trancmplx_fkx ON citydb.traffic_area
	USING btree
	(
	  transportation_complex_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.land_use_lod0msrf_fkx;
CREATE INDEX land_use_lod0msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.land_use_lod1msrf_fkx;
CREATE INDEX land_use_lod1msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.land_use_lod2msrf_fkx;
CREATE INDEX land_use_lod2msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.land_use_lod3msrf_fkx;
CREATE INDEX land_use_lod3msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.land_use_lod4msrf_fkx;
CREATE INDEX land_use_lod4msrf_fkx ON citydb.land_use
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod1msrf_fkx;
CREATE INDEX plant_cover_lod1msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod2msrf_fkx;
CREATE INDEX plant_cover_lod2msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod3msrf_fkx;
CREATE INDEX plant_cover_lod3msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod4msrf_fkx;
CREATE INDEX plant_cover_lod4msrf_fkx ON citydb.plant_cover
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod1msolid_fkx;
CREATE INDEX plant_cover_lod1msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod1_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod2msolid_fkx;
CREATE INDEX plant_cover_lod2msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod2_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod3msolid_fkx;
CREATE INDEX plant_cover_lod3msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod3_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.plant_cover_lod4msolid_fkx;
CREATE INDEX plant_cover_lod4msolid_fkx ON citydb.plant_cover
	USING btree
	(
	  lod4_multi_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1brep_fkx;
CREATE INDEX sol_veg_obj_lod1brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2brep_fkx;
CREATE INDEX sol_veg_obj_lod2brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3brep_fkx;
CREATE INDEX sol_veg_obj_lod3brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4brep_fkx;
CREATE INDEX sol_veg_obj_lod4brep_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1xgeom_spx;
CREATE INDEX sol_veg_obj_lod1xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod1_other_geom
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2xgeom_spx;
CREATE INDEX sol_veg_obj_lod2xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3xgeom_spx;
CREATE INDEX sol_veg_obj_lod3xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4xgeom_spx;
CREATE INDEX sol_veg_obj_lod4xgeom_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1impl_fkx;
CREATE INDEX sol_veg_obj_lod1impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2impl_fkx;
CREATE INDEX sol_veg_obj_lod2impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3impl_fkx;
CREATE INDEX sol_veg_obj_lod3impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4impl_fkx;
CREATE INDEX sol_veg_obj_lod4impl_fkx ON citydb.solitary_vegetat_object
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod1refpt_spx;
CREATE INDEX sol_veg_obj_lod1refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod1_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod2refpt_spx;
CREATE INDEX sol_veg_obj_lod2refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod3refpt_spx;
CREATE INDEX sol_veg_obj_lod3refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.sol_veg_obj_lod4refpt_spx;
CREATE INDEX sol_veg_obj_lod4refpt_spx ON citydb.solitary_vegetat_object
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.waterbody_lod0curve_spx;
CREATE INDEX waterbody_lod0curve_spx ON citydb.waterbody
	USING gist
	(
	  lod0_multi_curve
	);

DROP INDEX IF EXISTS citydb.waterbody_lod1curve_spx;
CREATE INDEX waterbody_lod1curve_spx ON citydb.waterbody
	USING gist
	(
	  lod1_multi_curve
	);

DROP INDEX IF EXISTS citydb.waterbody_lod0msrf_fkx;
CREATE INDEX waterbody_lod0msrf_fkx ON citydb.waterbody
	USING btree
	(
	  lod0_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbody_lod1msrf_fkx;
CREATE INDEX waterbody_lod1msrf_fkx ON citydb.waterbody
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbody_lod1solid_fkx;
CREATE INDEX waterbody_lod1solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbody_lod2solid_fkx;
CREATE INDEX waterbody_lod2solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbody_lod3solid_fkx;
CREATE INDEX waterbody_lod3solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbody_lod4solid_fkx;
CREATE INDEX waterbody_lod4solid_fkx ON citydb.waterbody
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbod_to_waterbnd_fkx;
CREATE INDEX waterbod_to_waterbnd_fkx ON citydb.waterbod_to_waterbnd_srf
	USING btree
	(
	  waterboundary_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbod_to_waterbnd_fkx1;
CREATE INDEX waterbod_to_waterbnd_fkx1 ON citydb.waterbod_to_waterbnd_srf
	USING btree
	(
	  waterbody_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbnd_srf_objclass_fkx;
CREATE INDEX waterbnd_srf_objclass_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbnd_srf_lod2srf_fkx;
CREATE INDEX waterbnd_srf_lod2srf_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  lod2_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbnd_srf_lod3srf_fkx;
CREATE INDEX waterbnd_srf_lod3srf_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  lod3_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.waterbnd_srf_lod4srf_fkx;
CREATE INDEX waterbnd_srf_lod4srf_fkx ON citydb.waterboundary_surface
	USING btree
	(
	  lod4_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.raster_relief_coverage_fkx;
CREATE INDEX raster_relief_coverage_fkx ON citydb.raster_relief
	USING btree
	(
	  coverage_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_parent_fkx;
CREATE INDEX tunnel_parent_fkx ON citydb.tunnel
	USING btree
	(
	  tunnel_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_root_fkx;
CREATE INDEX tunnel_root_fkx ON citydb.tunnel
	USING btree
	(
	  tunnel_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod1terr_spx;
CREATE INDEX tunnel_lod1terr_spx ON citydb.tunnel
	USING gist
	(
	  lod1_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.tunnel_lod2terr_spx;
CREATE INDEX tunnel_lod2terr_spx ON citydb.tunnel
	USING gist
	(
	  lod2_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.tunnel_lod3terr_spx;
CREATE INDEX tunnel_lod3terr_spx ON citydb.tunnel
	USING gist
	(
	  lod3_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.tunnel_lod4terr_spx;
CREATE INDEX tunnel_lod4terr_spx ON citydb.tunnel
	USING gist
	(
	  lod4_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.tunnel_lod2curve_spx;
CREATE INDEX tunnel_lod2curve_spx ON citydb.tunnel
	USING gist
	(
	  lod2_multi_curve
	);

DROP INDEX IF EXISTS citydb.tunnel_lod3curve_spx;
CREATE INDEX tunnel_lod3curve_spx ON citydb.tunnel
	USING gist
	(
	  lod3_multi_curve
	);

DROP INDEX IF EXISTS citydb.tunnel_lod4curve_spx;
CREATE INDEX tunnel_lod4curve_spx ON citydb.tunnel
	USING gist
	(
	  lod4_multi_curve
	);

DROP INDEX IF EXISTS citydb.tunnel_lod1msrf_fkx;
CREATE INDEX tunnel_lod1msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod2msrf_fkx;
CREATE INDEX tunnel_lod2msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod3msrf_fkx;
CREATE INDEX tunnel_lod3msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod4msrf_fkx;
CREATE INDEX tunnel_lod4msrf_fkx ON citydb.tunnel
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod1solid_fkx;
CREATE INDEX tunnel_lod1solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod2solid_fkx;
CREATE INDEX tunnel_lod2solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod3solid_fkx;
CREATE INDEX tunnel_lod3solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_lod4solid_fkx;
CREATE INDEX tunnel_lod4solid_fkx ON citydb.tunnel
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_open_to_them_srf_fkx;
CREATE INDEX tun_open_to_them_srf_fkx ON citydb.tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_open_to_them_srf_fkx1;
CREATE INDEX tun_open_to_them_srf_fkx1 ON citydb.tunnel_open_to_them_srf
	USING btree
	(
	  tunnel_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_hspace_tunnel_fkx;
CREATE INDEX tun_hspace_tunnel_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_hspace_lod4msrf_fkx;
CREATE INDEX tun_hspace_lod4msrf_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_hspace_lod4solid_fkx;
CREATE INDEX tun_hspace_lod4solid_fkx ON citydb.tunnel_hollow_space
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_objclass_fkx;
CREATE INDEX tun_them_srf_objclass_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_tunnel_fkx;
CREATE INDEX tun_them_srf_tunnel_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_hspace_fkx;
CREATE INDEX tun_them_srf_hspace_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_tun_inst_fkx;
CREATE INDEX tun_them_srf_tun_inst_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  tunnel_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_lod2msrf_fkx;
CREATE INDEX tun_them_srf_lod2msrf_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_lod3msrf_fkx;
CREATE INDEX tun_them_srf_lod3msrf_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tun_them_srf_lod4msrf_fkx;
CREATE INDEX tun_them_srf_lod4msrf_fkx ON citydb.tunnel_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_open_objclass_fkx;
CREATE INDEX tunnel_open_objclass_fkx ON citydb.tunnel_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_open_lod3msrf_fkx;
CREATE INDEX tunnel_open_lod3msrf_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_open_lod4msrf_fkx;
CREATE INDEX tunnel_open_lod4msrf_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_open_lod3impl_fkx;
CREATE INDEX tunnel_open_lod3impl_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_open_lod4impl_fkx;
CREATE INDEX tunnel_open_lod4impl_fkx ON citydb.tunnel_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_open_lod3refpt_spx;
CREATE INDEX tunnel_open_lod3refpt_spx ON citydb.tunnel_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.tunnel_open_lod4refpt_spx;
CREATE INDEX tunnel_open_lod4refpt_spx ON citydb.tunnel_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_objclass_fk;
CREATE INDEX tunnel_inst_objclass_fk ON citydb.tunnel_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_tunnel_fkx;
CREATE INDEX tunnel_inst_tunnel_fkx ON citydb.tunnel_installation
	USING btree
	(
	  tunnel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_hspace_fkx;
CREATE INDEX tunnel_inst_hspace_fkx ON citydb.tunnel_installation
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod2brep_fkx;
CREATE INDEX tunnel_inst_lod2brep_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod3brep_fkx;
CREATE INDEX tunnel_inst_lod3brep_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod4brep_fkx;
CREATE INDEX tunnel_inst_lod4brep_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod2xgeom_spx;
CREATE INDEX tunnel_inst_lod2xgeom_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod3xgeom_spx;
CREATE INDEX tunnel_inst_lod3xgeom_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod4xgeom_spx;
CREATE INDEX tunnel_inst_lod4xgeom_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod2impl_fkx;
CREATE INDEX tunnel_inst_lod2impl_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod3impl_fkx;
CREATE INDEX tunnel_inst_lod3impl_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod4impl_fkx;
CREATE INDEX tunnel_inst_lod4impl_fkx ON citydb.tunnel_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod2refpt_spx;
CREATE INDEX tunnel_inst_lod2refpt_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod3refpt_spx;
CREATE INDEX tunnel_inst_lod3refpt_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.tunnel_inst_lod4refpt_spx;
CREATE INDEX tunnel_inst_lod4refpt_spx ON citydb.tunnel_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.tunnel_furn_hspace_fkx;
CREATE INDEX tunnel_furn_hspace_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  tunnel_hollow_space_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_furn_lod4brep_fkx;
CREATE INDEX tunnel_furn_lod4brep_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_furn_lod4xgeom_spx;
CREATE INDEX tunnel_furn_lod4xgeom_spx ON citydb.tunnel_furniture
	USING btree
	(
	  lod4_other_geom ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_furn_lod4impl_fkx;
CREATE INDEX tunnel_furn_lod4impl_fkx ON citydb.tunnel_furniture
	USING btree
	(
	  lod4_implicit_rep_id
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.tunnel_furn_lod4refpt_spx;
CREATE INDEX tunnel_furn_lod4refpt_spx ON citydb.tunnel_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_parent_fkx;
CREATE INDEX bridge_parent_fkx ON citydb.bridge
	USING btree
	(
	  bridge_parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_root_fkx;
CREATE INDEX bridge_root_fkx ON citydb.bridge
	USING btree
	(
	  bridge_root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod1terr_spx;
CREATE INDEX bridge_lod1terr_spx ON citydb.bridge
	USING gist
	(
	  lod1_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_lod2terr_spx;
CREATE INDEX bridge_lod2terr_spx ON citydb.bridge
	USING gist
	(
	  lod2_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_lod3terr_spx;
CREATE INDEX bridge_lod3terr_spx ON citydb.bridge
	USING gist
	(
	  lod3_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_lod4terr_spx;
CREATE INDEX bridge_lod4terr_spx ON citydb.bridge
	USING gist
	(
	  lod4_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_lod2curve_spx;
CREATE INDEX bridge_lod2curve_spx ON citydb.bridge
	USING gist
	(
	  lod2_multi_curve
	);

DROP INDEX IF EXISTS citydb.bridge_lod3curve_spx;
CREATE INDEX bridge_lod3curve_spx ON citydb.bridge
	USING gist
	(
	  lod3_multi_curve
	);

DROP INDEX IF EXISTS citydb.bridge_lod4curve_spx;
CREATE INDEX bridge_lod4curve_spx ON citydb.bridge
	USING gist
	(
	  lod4_multi_curve
	);

DROP INDEX IF EXISTS citydb.bridge_lod1msrf_fkx;
CREATE INDEX bridge_lod1msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod1_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod2msrf_fkx;
CREATE INDEX bridge_lod2msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod3msrf_fkx;
CREATE INDEX bridge_lod3msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod4msrf_fkx;
CREATE INDEX bridge_lod4msrf_fkx ON citydb.bridge
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod1solid_fkx;
CREATE INDEX bridge_lod1solid_fkx ON citydb.bridge
	USING btree
	(
	  lod1_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod2solid_fkx;
CREATE INDEX bridge_lod2solid_fkx ON citydb.bridge
	USING btree
	(
	  lod2_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod3solid_fkx;
CREATE INDEX bridge_lod3solid_fkx ON citydb.bridge
	USING btree
	(
	  lod3_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_lod4solid_fkx;
CREATE INDEX bridge_lod4solid_fkx ON citydb.bridge
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_furn_brd_room_fkx;
CREATE INDEX bridge_furn_brd_room_fkx ON citydb.bridge_furniture
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_furn_lod4brep_fkx;
CREATE INDEX bridge_furn_lod4brep_fkx ON citydb.bridge_furniture
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_furn_lod4xgeom_spx;
CREATE INDEX bridge_furn_lod4xgeom_spx ON citydb.bridge_furniture
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_furn_lod4impl_fkx;
CREATE INDEX bridge_furn_lod4impl_fkx ON citydb.bridge_furniture
	USING btree
	(
	  lod4_implicit_rep_id
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_furn_lod4refpt_spx;
CREATE INDEX bridge_furn_lod4refpt_spx ON citydb.bridge_furniture
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_inst_objclass_fkx;
CREATE INDEX bridge_inst_objclass_fkx ON citydb.bridge_installation
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

DROP INDEX IF EXISTS citydb.bridge_inst_bridge_fkx;
CREATE INDEX bridge_inst_bridge_fkx ON citydb.bridge_installation
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_brd_room_fkx;
CREATE INDEX bridge_inst_brd_room_fkx ON citydb.bridge_installation
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod2brep_fkx;
CREATE INDEX bridge_inst_lod2brep_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod3brep_fkx;
CREATE INDEX bridge_inst_lod3brep_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod4brep_fkx;
CREATE INDEX bridge_inst_lod4brep_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod2xgeom_spx;
CREATE INDEX bridge_inst_lod2xgeom_spx ON citydb.bridge_installation
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_inst_lod3xgeom_spx;
CREATE INDEX bridge_inst_lod3xgeom_spx ON citydb.bridge_installation
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_inst_lod4xgeom_spx;
CREATE INDEX bridge_inst_lod4xgeom_spx ON citydb.bridge_installation
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_inst_lod2impl_fkx;
CREATE INDEX bridge_inst_lod2impl_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod3impl_fkx;
CREATE INDEX bridge_inst_lod3impl_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod4impl_fkx;
CREATE INDEX bridge_inst_lod4impl_fkx ON citydb.bridge_installation
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_inst_lod2refpt_spx;
CREATE INDEX bridge_inst_lod2refpt_spx ON citydb.bridge_installation
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_inst_lod3refpt_spx;
CREATE INDEX bridge_inst_lod3refpt_spx ON citydb.bridge_installation
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_inst_lod4refpt_spx;
CREATE INDEX bridge_inst_lod4refpt_spx ON citydb.bridge_installation
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_open_objclass_fkx;
CREATE INDEX bridge_open_objclass_fkx ON citydb.bridge_opening
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_open_address_fkx;
CREATE INDEX bridge_open_address_fkx ON citydb.bridge_opening
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_open_lod3msrf_fkx;
CREATE INDEX bridge_open_lod3msrf_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_open_lod4msrf_fkx;
CREATE INDEX bridge_open_lod4msrf_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_open_lod3impl_fkx;
CREATE INDEX bridge_open_lod3impl_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_open_lod4impl_fkx;
CREATE INDEX bridge_open_lod4impl_fkx ON citydb.bridge_opening
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_open_lod3refpt_spx;
CREATE INDEX bridge_open_lod3refpt_spx ON citydb.bridge_opening
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_open_lod4refpt_spx;
CREATE INDEX bridge_open_lod4refpt_spx ON citydb.bridge_opening
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.brd_open_to_them_srf_fkx;
CREATE INDEX brd_open_to_them_srf_fkx ON citydb.bridge_open_to_them_srf
	USING btree
	(
	  bridge_opening_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_open_to_them_srf_fkx1;
CREATE INDEX brd_open_to_them_srf_fkx1 ON citydb.bridge_open_to_them_srf
	USING btree
	(
	  bridge_thematic_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_room_bridge_fkx;
CREATE INDEX bridge_room_bridge_fkx ON citydb.bridge_room
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_room_lod4msrf_fkx;
CREATE INDEX bridge_room_lod4msrf_fkx ON citydb.bridge_room
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_room_lod4solid_fkx;
CREATE INDEX bridge_room_lod4solid_fkx ON citydb.bridge_room
	USING btree
	(
	  lod4_solid_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_objclass_fkx;
CREATE INDEX brd_them_srf_objclass_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_bridge_fkx;
CREATE INDEX brd_them_srf_bridge_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_brd_room_fkx;
CREATE INDEX brd_them_srf_brd_room_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_room_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_brd_inst_fkx;
CREATE INDEX brd_them_srf_brd_inst_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_installation_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_brd_const_fkx;
CREATE INDEX brd_them_srf_brd_const_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  bridge_constr_element_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_lod2msrf_fkx;
CREATE INDEX brd_them_srf_lod2msrf_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  lod2_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_lod3msrf_fkx;
CREATE INDEX brd_them_srf_lod3msrf_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  lod3_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.brd_them_srf_lod4msrf_fkx;
CREATE INDEX brd_them_srf_lod4msrf_fkx ON citydb.bridge_thematic_surface
	USING btree
	(
	  lod4_multi_surface_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_bridge_fkx;
CREATE INDEX bridge_constr_bridge_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod1terr_spx;
CREATE INDEX bridge_constr_lod1terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod1_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_constr_lod2terr_spx;
CREATE INDEX bridge_constr_lod2terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod2_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_constr_lod3terr_spx;
CREATE INDEX bridge_constr_lod3terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod3_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_constr_lod4terr_spx;
CREATE INDEX bridge_constr_lod4terr_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod4_terrain_intersection
	);

DROP INDEX IF EXISTS citydb.bridge_constr_lod1brep_fkx;
CREATE INDEX bridge_constr_lod1brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod1_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod2brep_fkx;
CREATE INDEX bridge_constr_lod2brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod2_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod3brep_fkx;
CREATE INDEX bridge_constr_lod3brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod3_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod4brep_fkx;
CREATE INDEX bridge_constr_lod4brep_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod4_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_const_lod1xgeom_spx;
CREATE INDEX bridge_const_lod1xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod1_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_const_lod2xgeom_spx;
CREATE INDEX bridge_const_lod2xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod2_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_const_lod3xgeom_spx;
CREATE INDEX bridge_const_lod3xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod3_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_const_lod4xgeom_spx;
CREATE INDEX bridge_const_lod4xgeom_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod4_other_geom
	);

DROP INDEX IF EXISTS citydb.bridge_constr_lod1impl_fkx;
CREATE INDEX bridge_constr_lod1impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod1_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod2impl_fkx;
CREATE INDEX bridge_constr_lod2impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod2_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod3impl_fkx;
CREATE INDEX bridge_constr_lod3impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod3_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_constr_lod4impl_fkx;
CREATE INDEX bridge_constr_lod4impl_fkx ON citydb.bridge_constr_element
	USING btree
	(
	  lod4_implicit_rep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.bridge_const_lod1refpt_spx;
CREATE INDEX bridge_const_lod1refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod1_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_const_lod2refpt_spx;
CREATE INDEX bridge_const_lod2refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod2_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_const_lod3refpt_spx;
CREATE INDEX bridge_const_lod3refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod3_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.bridge_const_lod4refpt_spx;
CREATE INDEX bridge_const_lod4refpt_spx ON citydb.bridge_constr_element
	USING gist
	(
	  lod4_implicit_ref_point
	);

DROP INDEX IF EXISTS citydb.address_to_bridge_fkx;
CREATE INDEX address_to_bridge_fkx ON citydb.address_to_bridge
	USING btree
	(
	  address_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.address_to_bridge_fkx1;
CREATE INDEX address_to_bridge_fkx1 ON citydb.address_to_bridge
	USING btree
	(
	  bridge_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.cityobject_inx;
CREATE INDEX cityobject_inx ON citydb.cityobject
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.cityobject_objectclass_fkx;
CREATE INDEX cityobject_objectclass_fkx ON citydb.cityobject
	USING btree
	(
	  objectclass_id
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.cityobject_envelope_spx;
CREATE INDEX cityobject_envelope_spx ON citydb.cityobject
	USING gist
	(
	  envelope
	);

DROP INDEX IF EXISTS citydb.appearance_inx;
CREATE INDEX appearance_inx ON citydb.appearance
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.appearance_theme_inx;
CREATE INDEX appearance_theme_inx ON citydb.appearance
	USING btree
	(
	  theme ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.appearance_citymodel_fkx;
CREATE INDEX appearance_citymodel_fkx ON citydb.appearance
	USING btree
	(
	  citymodel_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.appearance_cityobject_fkx;
CREATE INDEX appearance_cityobject_fkx ON citydb.appearance
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.implicit_geom_ref2lib_inx;
CREATE INDEX implicit_geom_ref2lib_inx ON citydb.implicit_geometry
	USING btree
	(
	  reference_to_library ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.implicit_geom_brep_fkx;
CREATE INDEX implicit_geom_brep_fkx ON citydb.implicit_geometry
	USING btree
	(
	  relative_brep_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.surface_geom_inx;
CREATE INDEX surface_geom_inx ON citydb.surface_geometry
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.surface_geom_parent_fkx;
CREATE INDEX surface_geom_parent_fkx ON citydb.surface_geometry
	USING btree
	(
	  parent_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.surface_geom_root_fkx;
CREATE INDEX surface_geom_root_fkx ON citydb.surface_geometry
	USING btree
	(
	  root_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.surface_geom_spx;
CREATE INDEX surface_geom_spx ON citydb.surface_geometry
	USING gist
	(
	  geometry
	);

DROP INDEX IF EXISTS citydb.surface_geom_solid_spx;
CREATE INDEX surface_geom_solid_spx ON citydb.surface_geometry
	USING gist
	(
	  solid_geometry
	);

DROP INDEX IF EXISTS citydb.surface_geom_cityobj_fkx;
CREATE INDEX surface_geom_cityobj_fkx ON citydb.surface_geometry
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.surface_data_inx;
CREATE INDEX surface_data_inx ON citydb.surface_data
	USING btree
	(
	  gmlid
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.surface_data_spx;
CREATE INDEX surface_data_spx ON citydb.surface_data
	USING gist
	(
	  gt_reference_point
	);

DROP INDEX IF EXISTS citydb.surface_data_objclass_fkx;
CREATE INDEX surface_data_objclass_fkx ON citydb.surface_data
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	);

DROP INDEX IF EXISTS citydb.surface_data_tex_image_fkx;
CREATE INDEX surface_data_tex_image_fkx ON citydb.surface_data
	USING btree
	(
	  tex_image_id ASC NULLS LAST
	);

DROP INDEX IF EXISTS citydb.citymodel_envelope_spx;
CREATE INDEX citymodel_envelope_spx ON citydb.citymodel
	USING gist
	(
	  envelope
	);

DROP INDEX IF EXISTS citydb.genericattrib_parent_fkx;
CREATE INDEX genericattrib_parent_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  parent_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.genericattrib_root_fkx;
CREATE INDEX genericattrib_root_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  root_genattrib_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.genericattrib_geom_fkx;
CREATE INDEX genericattrib_geom_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  surface_geometry_id
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.genericattrib_cityobj_fkx;
CREATE INDEX genericattrib_cityobj_fkx ON citydb.cityobject_genericattrib
	USING btree
	(
	  cityobject_id
	)	WITH (FILLFACTOR = 90);

DROP INDEX IF EXISTS citydb.ext_ref_cityobject_fkx;
CREATE INDEX ext_ref_cityobject_fkx ON citydb.external_reference
	USING btree
	(
	  cityobject_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);