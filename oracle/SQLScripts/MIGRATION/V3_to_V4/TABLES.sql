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
CREATE TABLE ADE 
(
  ID NUMBER NOT NULL 
, ADEID VARCHAR2(256) NOT NULL 
, NAME VARCHAR2(1000) NOT NULL 
, DESCRIPTION VARCHAR2(4000) 
, VERSION VARCHAR2(50) 
, DB_PREFIX VARCHAR2(10) NOT NULL 
, XML_SCHEMAMAPPING_FILE CLOB 
, DROP_DB_SCRIPT CLOB 
, CREATION_DATE TIMESTAMP WITH TIME ZONE 
, CREATION_PERSON VARCHAR2(256)
);

CREATE TABLE SCHEMA 
(
  ID NUMBER NOT NULL 
, IS_ADE_ROOT NUMBER(1, 0) NOT NULL 
, CITYGML_VERSION VARCHAR2(50) NOT NULL 
, XML_NAMESPACE_URI VARCHAR2(4000) NOT NULL 
, XML_NAMESPACE_PREFIX VARCHAR2(50) NOT NULL 
, XML_SCHEMA_LOCATION VARCHAR2(4000) 
, XML_SCHEMAFILE BLOB 
, XML_SCHEMAFILE_TYPE VARCHAR2(256) 
, ADE_ID NUMBER 
);

CREATE TABLE SCHEMA_REFERENCING 
(
  REFERENCING_ID NUMBER NOT NULL 
, REFERENCED_ID NUMBER NOT NULL 
);

CREATE TABLE SCHEMA_TO_OBJECTCLASS 
(
  SCHEMA_ID NUMBER NOT NULL 
, OBJECTCLASS_ID NUMBER NOT NULL 
);

CREATE TABLE AGGREGATION_INFO 
(
  CHILD_ID NUMBER NOT NULL 
, PARENT_ID NUMBER NOT NULL 
, JOIN_TABLE_OR_COLUMN_NAME VARCHAR2(30) NOT NULL 
, MIN_OCCURS NUMBER 
, MAX_OCCURS NUMBER 
, IS_COMPOSITE NUMBER(1, 0) 
);

/*************************************************
* alter tables that changed in v4.0.0
*
**************************************************/
ALTER TABLE OBJECTCLASS ADD (
  IS_ADE_CLASS NUMBER(1, 0),
  IS_TOPLEVEL NUMBER(1, 0),
  TABLENAME VARCHAR2(30),
  BASECLASS_ID NUMBER,
  ADE_ID NUMBER
);

ALTER TABLE BRIDGE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE BRIDGE_CONSTR_ELEMENT
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE BRIDGE_FURNITURE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE BRIDGE_ROOM
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE BUILDING
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE BUILDING_FURNITURE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE ROOM
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE CITY_FURNITURE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE GENERIC_CITYOBJECT
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE LAND_USE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE BREAKLINE_RELIEF
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE MASSPOINT_RELIEF
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE TIN_RELIEF
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE PLANT_COVER
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE SOLITARY_VEGETAT_OBJECT
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE TUNNEL
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE TUNNEL_FURNITURE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE TUNNEL_HOLLOW_SPACE
  ADD OBJECTCLASS_ID NUMBER;

ALTER TABLE WATERBODY
  ADD OBJECTCLASS_ID NUMBER;
  
ALTER TABLE CITYOBJECTGROUP
  ADD OBJECTCLASS_ID NUMBER;
  
ALTER TABLE RELIEF_FEATURE
  ADD OBJECTCLASS_ID NUMBER;

/*************************************************
* alter tables that changed in v4.3
*
**************************************************/
ALTER TABLE IMPLICIT_GEOMETRY ADD (GMLID VARCHAR2(256), GMLID_CODESPACE VARCHAR2(1000));

UPDATE IMPLICIT_GEOMETRY ig
  SET (GMLID, GMLID_CODESPACE) = (
    SELECT GMLID, GMLID_CODESPACE FROM SURFACE_GEOMETRY sg
      WHERE ig.RELATIVE_BREP_ID = sg.ID);
  
/*************************************************
* update tables that changed between 3.0 and 3.1
*
**************************************************/
DECLARE
  major NUMBER;
  minor NUMBER;
BEGIN
  SELECT major_version, minor_version INTO major, minor FROM TABLE(citydb_util.citydb_version);

  IF major = 3 AND minor = 0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE CITYOBJECT
      ADD GMLID_CODESPACE VARCHAR2(1000)';

    EXECUTE IMMEDIATE 'ALTER TABLE APPEARANCE
      ADD GMLID_CODESPACE VARCHAR2(1000)';

    EXECUTE IMMEDIATE 'ALTER TABLE SURFACE_GEOMETRY
      ADD GMLID_CODESPACE VARCHAR2(1000)';

    EXECUTE IMMEDIATE 'ALTER TABLE SURFACE_DATA
      ADD GMLID_CODESPACE VARCHAR2(1000)';

    EXECUTE IMMEDIATE 'ALTER TABLE CITYMODEL
      ADD GMLID_CODESPACE VARCHAR2(1000)';

    EXECUTE IMMEDIATE 'ALTER TABLE ADDRESS
      ADD (GMLID VARCHAR(256),
           GMLID_CODESPACE VARCHAR2(1000))';
  END IF;

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
END;
/
  
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

UPDATE cityobjectgroup
  SET objectclass_id = 23;  
  
UPDATE relief_feature
  SET objectclass_id = 14;  
