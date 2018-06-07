-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2018
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

/*************************************************
* create foreign keys new in v4.0.0
*
**************************************************/ 
ALTER TABLE citydb.objectclass
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
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_to_objectclass
  ADD CONSTRAINT schema_to_objectclass_fk2 FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_referencing
  ADD CONSTRAINT schema_referencing_fk1 FOREIGN KEY (referencing_id)
    REFERENCES citydb.schema (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.schema_referencing
  ADD CONSTRAINT schema_referencing_fk2 FOREIGN KEY (referenced_id)
    REFERENCES citydb.schema (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.aggregation_info
  ADD CONSTRAINT aggregation_info_fk1 FOREIGN KEY (child_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.aggregation_info
  ADD CONSTRAINT aggregation_info_fk2 FOREIGN KEY (parent_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE citydb.bridge
  ADD CONSTRAINT bridge_objclass_fk FOREIGN KEY (objectclass_id)
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
  ADD CONSTRAINT building_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.building_furniture
  ADD CONSTRAINT bldg_furn_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.room
  ADD CONSTRAINT room_objclass_fk FOREIGN KEY (objectclass_id)
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

ALTER TABLE citydb.breakline_relief
  ADD CONSTRAINT breakline_relief_objclass_fk FOREIGN KEY (objectclass_id)
    REFERENCES citydb.objectclass (id) MATCH FULL
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE citydb.masspoint_relief
  ADD CONSTRAINT masspoint_relief_objclass_fk FOREIGN KEY (objectclass_id)
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
  ADD CONSTRAINT tunnel_objclass_fk FOREIGN KEY (objectclass_id)
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

/*************************************************
* drop not null constraints obsolete in v4.0.0
*
**************************************************/
ALTER TABLE citydb.bridge_room ALTER COLUMN bridge_id DROP NOT NULL;
ALTER TABLE citydb.room ALTER COLUMN building_id DROP NOT NULL;
ALTER TABLE citydb.tunnel_hollow_space ALTER COLUMN tunnel_id DROP NOT NULL;
ALTER TABLE citydb.bridge_furniture ALTER COLUMN bridge_room_id DROP NOT NULL;
ALTER TABLE citydb.building_furniture ALTER COLUMN room_id DROP NOT NULL;
ALTER TABLE citydb.tunnel_furniture ALTER COLUMN tunnel_hollow_space_id DROP NOT NULL;
ALTER TABLE citydb.traffic_area ALTER COLUMN transportation_complex_id DROP NOT NULL;

/*************************************************
* create not null constraints new in v4.0.0
*
**************************************************/
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
