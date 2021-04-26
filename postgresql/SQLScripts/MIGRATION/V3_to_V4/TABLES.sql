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
* create tables new in v4.0.0
*
**************************************************/
CREATE TABLE ade(
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

CREATE TABLE schema(
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

CREATE TABLE schema_referencing(
    referencing_id INTEGER NOT NULL,
    referenced_id INTEGER NOT NULL
);

CREATE TABLE schema_to_objectclass(
    schema_id INTEGER NOT NULL,
    objectclass_id INTEGER NOT NULL
);

CREATE TABLE aggregation_info(
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
ALTER TABLE objectclass
  ADD COLUMN is_ade_class NUMERIC,
  ADD COLUMN is_toplevel NUMERIC,
  ADD COLUMN tablename VARCHAR(30),
  ADD COLUMN baseclass_id INTEGER,
  ADD COLUMN ade_id INTEGER;

ALTER TABLE bridge
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE bridge_constr_element
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE bridge_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE bridge_room
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE building
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE building_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE room
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE city_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE generic_cityobject
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE land_use
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE breakline_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE masspoint_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE raster_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE tin_relief
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE plant_cover
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE solitary_vegetat_object
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE tunnel
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE tunnel_furniture
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE tunnel_hollow_space
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE waterbody
  ADD COLUMN objectclass_id INTEGER;

ALTER TABLE relief_feature
  ADD COLUMN objectclass_id INTEGER;
  
ALTER TABLE cityobjectgroup
  ADD COLUMN objectclass_id INTEGER;

/*************************************************
* update tables that changed between 3.0 and 3.1
*
**************************************************/
DO $$
DECLARE
  major INTEGER;
  minor INTEGER;
BEGIN
  SELECT major_version, minor_version INTO major, minor FROM citydb_pkg.citydb_version();

  IF major = 3 AND minor = 0 THEN
    ALTER TABLE cityobject
      ADD COLUMN gmlid_codespace VARCHAR(1000);

    ALTER TABLE appearance
      ADD COLUMN gmlid_codespace VARCHAR(1000);

    ALTER TABLE surface_geometry
      ADD COLUMN gmlid_codespace VARCHAR(1000);

    ALTER TABLE surface_data
      ADD COLUMN gmlid_codespace VARCHAR(1000);

    ALTER TABLE citymodel
      ADD COLUMN gmlid_codespace VARCHAR(1000);

    ALTER TABLE address
      ADD COLUMN gmlid VARCHAR(256),
      ADD COLUMN gmlid_codespace VARCHAR(1000);
  END IF;

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
END
$$;

/*************************************************
* update tables with new objectclass_id column
*
**************************************************/
UPDATE bridge b
  SET objectclass_id = (
    SELECT objectclass_id FROM cityobject co
      WHERE co.id = b.id
  );

UPDATE bridge_constr_element
  SET objectclass_id = 82;

UPDATE bridge_furniture
  SET objectclass_id = 80;

UPDATE bridge_room
  SET objectclass_id = 81;

UPDATE building b
  SET objectclass_id = (
    SELECT objectclass_id FROM cityobject co
      WHERE co.id = b.id
  );

UPDATE building_furniture
  SET objectclass_id = 40;

UPDATE room
  SET objectclass_id = 41;

UPDATE city_furniture
  SET objectclass_id = 21;

UPDATE generic_cityobject
  SET objectclass_id = 5;

UPDATE land_use
  SET objectclass_id = 4;

UPDATE breakline_relief
  SET objectclass_id = 18;

UPDATE masspoint_relief
  SET objectclass_id = 17;

UPDATE raster_relief
  SET objectclass_id = 19;

UPDATE tin_relief
  SET objectclass_id = 16;

UPDATE plant_cover
  SET objectclass_id = 8;

UPDATE solitary_vegetat_object
  SET objectclass_id = 7;

UPDATE tunnel t
  SET objectclass_id = (
    SELECT objectclass_id FROM cityobject co
      WHERE co.id = t.id
  );

UPDATE tunnel_furniture
  SET objectclass_id = 101;

UPDATE tunnel_hollow_space
  SET objectclass_id = 102;

UPDATE waterbody
  SET objectclass_id = 9;

UPDATE relief_feature rf
  SET objectclass_id = 14;
  
UPDATE cityobjectgroup
  SET objectclass_id = 23;  