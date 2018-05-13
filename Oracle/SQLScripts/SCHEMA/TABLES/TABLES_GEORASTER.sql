-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
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

@@TABLES.sql

CREATE TABLE RASTER_RELIEF 
(
  ID NUMBER NOT NULL 
, OBJECTCLASS_ID NUMBER 
, URI VARCHAR2(4000) 
, COVERAGE_ID NUMBER 
, CONSTRAINT RASTER_RELIEF_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);
	
CREATE TABLE GRID_COVERAGE
(
  ID NUMBER NOT NULL 
, RASTERPROPERTY MDSYS.SDO_GEORASTER NOT NULL 
, CONSTRAINT GRID_COVERAGE_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);
	
CREATE TABLE GRID_COVERAGE_RDT 
(
  RASTERID NUMBER 
, PYRAMIDLEVEL NUMBER 
, BANDBLOCKNUMBER NUMBER 
, ROWBLOCKNUMBER NUMBER 
, COLUMNBLOCKNUMBER NUMBER 
, BLOCKMBR MDSYS.SDO_GEOMETRY 
, RASTERBLOCK BLOB 
, CONSTRAINT GRID_COVERAGE_RDT_PK PRIMARY KEY 
  (
	RASTERID 
  , PYRAMIDLEVEL 
  , BANDBLOCKNUMBER 
  , ROWBLOCKNUMBER 
  , COLUMNBLOCKNUMBER 
  )
  ENABLE 
) 
LOB (RASTERBLOCK) STORE AS SECUREFILE 
( 
  ENABLE STORAGE IN ROW 
  CACHE  
);