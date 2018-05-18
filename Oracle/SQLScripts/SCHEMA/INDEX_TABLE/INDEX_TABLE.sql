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

/******************************************************************
* INDEX_TABLE that holds INDEX_OBJ instances
* 
******************************************************************/
CREATE TABLE INDEX_TABLE (
  ID NUMBER PRIMARY KEY,
  obj INDEX_OBJ
);

CREATE SEQUENCE INDEX_TABLE_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1;

/******************************************************************
* Populate INDEX_TABLE with INDEX_OBJ instances
* 
******************************************************************/
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('CITYOBJECT_ENVELOPE_SPX', 'CITYOBJECT', 'ENVELOPE', 'PARALLEL'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('SURFACE_GEOM_SPX', 'SURFACE_GEOMETRY', 'GEOMETRY', 'PARALLEL'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_spatial_3d('SURFACE_GEOM_SOLID_SPX', 'SURFACE_GEOMETRY', 'SOLID_GEOMETRY', 'PARAMETERS (''sdo_indx_dims=3'') PARALLEL'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('CITYOBJECT_INX', 'CITYOBJECT', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('CITYOBJECT_LINEAGE_INX', 'CITYOBJECT', 'LINEAGE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('SURFACE_GEOM_INX', 'SURFACE_GEOMETRY', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('APPEARANCE_INX', 'APPEARANCE', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('APPEARANCE_THEME_INX', 'APPEARANCE', 'THEME'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('SURFACE_DATA_INX', 'SURFACE_DATA', 'GMLID, GMLID_CODESPACE'));
INSERT INTO index_table (id, obj) VALUES (INDEX_TABLE_SEQ.nextval, INDEX_OBJ.construct_normal('ADDRESS_INX', 'ADDRESS', 'GMLID, GMLID_CODESPACE'));

COMMIT;

