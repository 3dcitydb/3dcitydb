-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
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

SET SERVEROUTPUT ON

SELECT 'Starting 3D City Database upgrade...' as message from DUAL;

--// drop indexes to be replaced
DROP INDEX CITYMODEL_INX;
DROP INDEX CITYOBJECT_INX;
DROP INDEX APPEARANCE_INX;
DROP INDEX SURFACE_GEOM_INX;
DROP INDEX SURFACE_DATA_INX;

--// add columns new in v3.1
ALTER TABLE CITYMODEL
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE CITYOBJECT
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE APPEARANCE
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE SURFACE_DATA
  ADD GMLID_CODESPACE VARCHAR2(1000);
  
ALTER TABLE SURFACE_GEOMETRY
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE ADDRESS
  ADD (GMLID VARCHAR2(256),
       GMLID_CODESPACE VARCHAR2(1000));

--// fill gmlid column in address table
UPDATE ADDRESS SET GMLID = ('ID_'||ID);

--// create new indexes
CREATE INDEX CITYMODEL_INX ON CITYMODEL (GMLID, GMLID_CODESPACE);
CREATE INDEX CITYOBJECT_INX ON CITYOBJECT (GMLID, GMLID_CODESPACE);
CREATE INDEX CITYOBJECT_LINEAGE_INX ON CITYOBJECT (LINEAGE);
CREATE INDEX APPEARANCE_INX ON APPEARANCE (GMLID, GMLID_CODESPACE);
CREATE INDEX SURFACE_GEOM_INX ON SURFACE_GEOMETRY (GMLID, GMLID_CODESPACE);
CREATE INDEX SURFACE_DATA_INX ON SURFACE_DATA (GMLID, GMLID_CODESPACE);
CREATE INDEX ADDRESS_INX ON ADDRESS (GMLID, GMLID_CODESPACE);

--// get SRID for spatial index
VARIABLE SRID NUMBER;
BEGIN
  SELECT SRID INTO :SRID FROM DATABASE_SRS;
END;
/

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='ADDRESS' AND COLUMN_NAME='MULTI_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('ADDRESS','MULTI_POINT', MDSYS.SDO_DIM_ARRAY(
           MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
           MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),
           MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)), :SRID);

CREATE INDEX ADDRESS_POINT_SPX ON ADDRESS (MULTI_POINT) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

--// drop old versions of CITYDB_PKG
@DROP_CITYDB_PKG.sql

--// contents of @@../../CREATE_CITYDB_PKG.sql
SELECT 'Installing CITYDB packages...' as message from DUAL;
@@../../PL_SQL/CITYDB_PKG/UTIL/UTIL.sql;
@@../../PL_SQL/CITYDB_PKG/INDEX/IDX.sql;
@@../../PL_SQL/CITYDB_PKG/SRS/SRS.sql;
@@../../PL_SQL/CITYDB_PKG/STATISTICS/STAT.sql;
@@../../PL_SQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql;
@@../../PL_SQL/CITYDB_PKG/DELETE/DELETE.sql;
@@../../PL_SQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql;
SELECT 'CITYDB package installed.' as message from DUAL;

--// Alter constraint: Fix foreign key bug.
ALTER TABLE BRIDGE_THEMATIC_SURFACE
DROP CONSTRAINT BRD_THEM_SRF_BRD_CONST_FK;

ALTER TABLE BRIDGE_THEMATIC_SURFACE
ADD CONSTRAINT BRD_THEM_SRF_BRD_CONST_FK FOREIGN KEY
(
  BRIDGE_CONSTR_ELEMENT_ID  
)
REFERENCES BRIDGE_CONSTR_ELEMENT
(
  ID 
)
ENABLE;

SELECT '3D City Database upgrade complete!' as message from DUAL;
