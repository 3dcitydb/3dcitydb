-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2019
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
* create primary keys new in v4.0.0
*
**************************************************/
ALTER TABLE ade
  ADD CONSTRAINT ade_pk PRIMARY KEY (id);

ALTER TABLE schema
  ADD CONSTRAINT schema_pk PRIMARY KEY (id);

ALTER TABLE schema_referencing
  ADD CONSTRAINT schema_referencing_pk PRIMARY KEY (referencing_id,referenced_id);

ALTER TABLE schema_to_objectclass
  ADD CONSTRAINT schema_to_objectclass_pk PRIMARY KEY (schema_id,objectclass_id);

ALTER TABLE aggregation_info
  ADD CONSTRAINT aggregation_info_pk PRIMARY KEY (child_id,parent_id,join_table_or_column_name);

/*************************************************
* create foreign keys new in v4.0.0
*
**************************************************/ 
ALTER TABLE objectclass
  ADD CONSTRAINT objectclass_ade_fk FOREIGN KEY (ade_id)
    REFERENCES ade (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE schema
  ADD CONSTRAINT schema_ade_fk FOREIGN KEY (ade_id)
    REFERENCES ade (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE schema_to_objectclass
  ADD CONSTRAINT schema_to_objectclass_fk1 FOREIGN KEY (schema_id)
    REFERENCES schema (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE schema_to_objectclass
  ADD CONSTRAINT schema_to_objectclass_fk2 FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE schema_referencing
  ADD CONSTRAINT schema_referencing_fk1 FOREIGN KEY (referencing_id)
    REFERENCES schema (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE schema_referencing
  ADD CONSTRAINT schema_referencing_fk2 FOREIGN KEY (referenced_id)
    REFERENCES schema (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE aggregation_info
  ADD CONSTRAINT aggregation_info_fk1 FOREIGN KEY (child_id)
    REFERENCES objectclass (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE aggregation_info
  ADD CONSTRAINT aggregation_info_fk2 FOREIGN KEY (parent_id)
    REFERENCES objectclass (id)
    ON DELETE CASCADE ENABLE;

ALTER TABLE bridge
  ADD CONSTRAINT bridge_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE bridge_constr_element
  ADD CONSTRAINT bridge_constr_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE bridge_furniture
  ADD CONSTRAINT bridge_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE bridge_room
  ADD CONSTRAINT bridge_room_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE building
  ADD CONSTRAINT building_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE building_furniture
  ADD CONSTRAINT bldg_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE room
  ADD CONSTRAINT room_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE city_furniture
  ADD CONSTRAINT city_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE generic_cityobject
  ADD CONSTRAINT gen_object_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE land_use
  ADD CONSTRAINT land_use_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE breakline_relief
  ADD CONSTRAINT breakline_relief_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE masspoint_relief
  ADD CONSTRAINT masspoint_relief_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE tin_relief
  ADD CONSTRAINT tin_relief_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE plant_cover
  ADD CONSTRAINT plant_cover_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE solitary_vegetat_object
  ADD CONSTRAINT sol_veg_obj_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE tunnel
  ADD CONSTRAINT tunnel_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE tunnel_furniture
  ADD CONSTRAINT tunnel_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE tunnel_hollow_space
  ADD CONSTRAINT tun_hspace_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE waterbody
  ADD CONSTRAINT waterbody_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);

ALTER TABLE objectclass
  ADD CONSTRAINT objectclass_baseclass_fk FOREIGN KEY (baseclass_id)
    REFERENCES objectclass (id) ON DELETE CASCADE ENABLE;   
    
ALTER TABLE cityobjectgroup
  ADD CONSTRAINT group_objectclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);  
    
ALTER TABLE relief_feature
  ADD CONSTRAINT relief_feat_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES objectclass (id);      
    
/*************************************************
* update delete rule for some foreign keys
*
**************************************************/
BEGIN
  citydb_constraint.set_fkey_delete_rule('address_to_bridge_fk', 'address_to_bridge', 'address_id', 'address', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('address_to_building_fk', 'address_to_building', 'address_id', 'address', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('appear_to_surface_data_fk', 'appear_to_surface_data', 'surface_data_id', 'surface_data', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('brd_open_to_them_srf_fk', 'bridge_open_to_them_srf', 'bridge_opening_id', 'bridge_opening', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('cityobject_member_fk', 'cityobject_member', 'cityobject_id', 'cityobject', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('group_to_cityobject_fk', 'group_to_cityobject', 'cityobject_id', 'cityobject', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('open_to_them_surface_fk', 'opening_to_them_surface', 'opening_id', 'opening', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('rel_feat_to_rel_comp_fk', 'relief_feat_to_rel_comp', 'relief_component_id', 'relief_component', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('texparam_geom_fk', 'textureparam', 'surface_geometry_id', 'surface_geometry', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('texparam_surface_data_fk', 'textureparam', 'surface_data_id', 'surface_data', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('tun_open_to_them_srf_fk', 'tunnel_open_to_them_srf', 'tunnel_opening_id', 'tunnel_opening', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('waterbod_to_waterbnd_fk', 'waterbod_to_waterbnd_srf', 'waterboundary_surface_id', 'waterboundary_surface', 'id', 'c', USER);
  citydb_constraint.set_fkey_delete_rule('objectclass_superclass_fk', 'objectclass', 'superclass_id', 'objectclass', 'id', 'c', USER);
END;
/

/*************************************************
* NULL constraints obsolete in v4.0.0
*
**************************************************/
ALTER TABLE bridge_room MODIFY bridge_id NULL;
ALTER TABLE room MODIFY building_id NULL;
ALTER TABLE tunnel_hollow_space MODIFY tunnel_id NULL;
ALTER TABLE bridge_furniture MODIFY bridge_room_id NULL;
ALTER TABLE building_furniture MODIFY room_id NULL;
ALTER TABLE tunnel_furniture MODIFY tunnel_hollow_space_id NULL;
ALTER TABLE traffic_area MODIFY transportation_complex_id NULL;
ALTER TABLE cityobject_genericattrib MODIFY cityobject_id NULL;
ALTER TABLE external_reference MODIFY cityobject_id NULL;

/*************************************************
* create not null constraints new in v4.0.0
*
**************************************************/
BEGIN
  FOR rec IN (
    SELECT
      ucc.table_name
    FROM
      user_cons_columns ucc
    JOIN
      user_tab_columns utc
      ON utc.table_name = ucc.table_name
     AND utc.column_name = ucc.column_name
    JOIN
      user_constraints uc
      ON uc.constraint_name = ucc.constraint_name
     AND uc.table_name = ucc.table_name
    WHERE
      uc.constraint_type = 'R'
      AND ucc.column_name = 'OBJECTCLASS_ID'
      AND utc.nullable = 'Y'
  )
  LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE ' || rec.table_name || ' MODIFY OBJECTCLASS_ID NOT NULL';
  END LOOP;
END;
/

/*************************************************
* bugfixes to some constraints in v3.x.0
*
**************************************************/
ALTER TABLE BRIDGE_CONSTR_ELEMENT DROP CONSTRAINT BRIDGE_CONSTR_LOD3IMPL_FK;
ALTER TABLE BRIDGE_CONSTR_ELEMENT 
  ADD CONSTRAINT BRIDGE_CONSTR_LOD3IMPL_FK FOREIGN KEY (LOD3_IMPLICIT_REP_ID) 
    REFERENCES IMPLICIT_GEOMETRY (ID);
    
ALTER TABLE BRIDGE_CONSTR_ELEMENT DROP CONSTRAINT BRIDGE_CONSTR_LOD4BREP_FK;
ALTER TABLE BRIDGE_CONSTR_ELEMENT 
  ADD CONSTRAINT BRIDGE_CONSTR_LOD4BREP_FK FOREIGN KEY (LOD4_BREP_ID) 
    REFERENCES SURFACE_GEOMETRY (ID);    

ALTER TABLE TUNNEL_FURNITURE DROP CONSTRAINT TUNNEL_FURN_HSPACE_FK;
ALTER TABLE TUNNEL_FURNITURE 
  ADD CONSTRAINT TUNNEL_FURN_HSPACE_FK FOREIGN KEY (TUNNEL_HOLLOW_SPACE_ID) 
    REFERENCES TUNNEL_HOLLOW_SPACE (ID);   
    
ALTER TABLE TUNNEL_OPEN_TO_THEM_SRF DROP CONSTRAINT TUN_OPEN_TO_THEM_SRF_FK1;
ALTER TABLE TUNNEL_OPEN_TO_THEM_SRF 
  ADD CONSTRAINT TUN_OPEN_TO_THEM_SRF_FK1 FOREIGN KEY (TUNNEL_THEMATIC_SURFACE_ID) 
    REFERENCES TUNNEL_THEMATIC_SURFACE (ID);      