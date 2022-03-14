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
* create indexes new in v4.0.0
*
**************************************************/
CREATE INDEX breakline_rel_objclass_fkx ON breakline_relief
	USING btree
	(
	  objectclass_id
	)	WITH (FILLFACTOR = 90);

CREATE INDEX bridge_objectclass_fkx ON bridge
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX bridge_constr_objclass_fkx ON bridge_constr_element
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
	
CREATE INDEX bridge_furn_objclass_fkx ON bridge_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX bridge_room_objclass_fkx ON bridge_room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
	
CREATE INDEX building_objectclass_fkx ON building
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
	
CREATE INDEX bldg_furn_objclass_fkx ON building_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX city_furn_objclass_fkx ON city_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	

CREATE INDEX group_objectclass_fkx ON cityobjectgroup
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX gen_object_objclass_fkx ON generic_cityobject
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX land_use_objclass_fkx ON land_use
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX masspoint_rel_objclass_fkx ON masspoint_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX objectclass_baseclass_fkx ON objectclass
	USING btree
	(
	  baseclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX plant_cover_objclass_fkx ON plant_cover
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX raster_relief_objclass_fkx ON raster_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX relief_feat_objclass_fkx ON relief_feature
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX ROOM_OBJECTCLASS_FKX ON room
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX schema_referencing_fkx1 ON schema_referencing
	USING btree
	(
	  referenced_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
	
CREATE INDEX schema_referencing_fkx2 ON schema_referencing
	USING btree
	(
	  referencing_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	

CREATE INDEX schema_to_objectclass_fkx1 ON schema_to_objectclass
	USING btree
	(
	  schema_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);
	
CREATE INDEX schema_to_objectclass_fkx2 ON schema_to_objectclass
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX sol_veg_obj_objclass_fkx ON solitary_vegetat_object
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX tin_relief_objclass_fkx ON tin_relief
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX tunnel_objectclass_fkx ON tunnel
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX tunnel_furn_objclass_fkx ON tunnel_furniture
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX tun_hspace_objclass_fkx ON tunnel_hollow_space
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);	
	
CREATE INDEX waterbody_objclass_fkx ON waterbody
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX cityobj_creation_date_inx ON cityobject
	USING btree
	(
	  creation_date
	)	WITH (FILLFACTOR = 90);

CREATE INDEX cityobj_term_date_inx ON cityobject
	USING btree
	(
	  termination_date
	)	WITH (FILLFACTOR = 90);

CREATE INDEX cityobj_last_mod_date_inx ON cityobject
	USING btree
	(
	  last_modification_date
	)	WITH (FILLFACTOR = 90);

CREATE INDEX implicit_geom_inx ON implicit_geometry
  USING btree
  (
    gmlid ASC NULLS LAST,
    gmlid_codespace
  )	WITH (FILLFACTOR = 90);