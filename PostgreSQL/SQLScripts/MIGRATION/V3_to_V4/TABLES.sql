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
* create tables new in v4.0.0
*
**************************************************/
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

CREATE TABLE citydb.schema_referencing(
    referencing_id INTEGER NOT NULL,
    referenced_id INTEGER NOT NULL
);

CREATE TABLE citydb.schema_to_objectclass(
    schema_id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL
);

CREATE TABLE citydb.aggregation_info(
    child_id INTEGER NOT NULL,
    parent_id INTEGER NOT NULL,
    join_table_or_column_name VARCHAR(30) NOT NULL,
    min_occurs INTEGER,
    max_occurs INTEGER,
    is_composite NUMERIC
);

/*************************************************
* alter tables that changed in v4.0.0
*
**************************************************/
ALTER TABLE citydb.objectclass
  ADD COLUMN is_ade_class NUMERIC,
  ADD COLUMN is_toplevel NUMERIC,
  ADD COLUMN tablename VARCHAR(30),
  ADD COLUMN baseclass_id INTEGER,
  ADD COLUMN ade_id INTEGER;

ALTER TABLE citydb.bridge
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.bridge_constr_element
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.bridge_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.bridge_room
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.building
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.building_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.room
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.city_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.generic_cityobject
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.land_use
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.breakline_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.masspoint_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.raster_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.tin_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.plant_cover
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.solitary_vegetat_object
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.tunnel
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.tunnel_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.tunnel_hollow_space
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.waterbody
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE citydb.relief_feature
  ADD COLUMN objectclass_id INTEGER;
  
ALTER TABLE citydb.cityobjectgroup
  ADD COLUMN objectclass_id INTEGER;  

/*************************************************
* update tables with new objectclass_id column
*
**************************************************/
UPDATE citydb.bridge b
  SET objectclass_id = (
    SELECT objectclass_id FROM cityobject co
      WHERE co.id = b.id
  );

UPDATE citydb.bridge_constr_element
  SET objectclass_id = 82;

UPDATE citydb.bridge_furniture
  SET objectclass_id = 80;

UPDATE citydb.bridge_room
  SET objectclass_id = 81;

UPDATE citydb.building b
  SET objectclass_id = (
    SELECT objectclass_id FROM cityobject co
      WHERE co.id = b.id
  );

UPDATE citydb.building_furniture
  SET objectclass_id = 40;

UPDATE citydb.room
  SET objectclass_id = 41;

UPDATE citydb.city_furniture
  SET objectclass_id = 21;

UPDATE citydb.generic_cityobject
  SET objectclass_id = 5;

UPDATE citydb.land_use
  SET objectclass_id = 4;

UPDATE citydb.breakline_relief
  SET objectclass_id = 18;

UPDATE citydb.masspoint_relief
  SET objectclass_id = 17;

UPDATE citydb.raster_relief
  SET objectclass_id = 19;

UPDATE citydb.tin_relief
  SET objectclass_id = 16;

UPDATE citydb.plant_cover
  SET objectclass_id = 8;

UPDATE citydb.solitary_vegetat_object
  SET objectclass_id = 7;

UPDATE citydb.tunnel t
  SET objectclass_id = (
    SELECT objectclass_id FROM cityobject co
      WHERE co.id = t.id
  );

UPDATE citydb.tunnel_furniture
  SET objectclass_id = 101;

UPDATE citydb.tunnel_hollow_space
  SET objectclass_id = 102;

UPDATE citydb.waterbody
  SET objectclass_id = 9;

UPDATE citydb.relief_feature rf
  SET objectclass_id = 14;
  
UPDATE citydb.cityobjectgroup
  SET objectclass_id = 23;  