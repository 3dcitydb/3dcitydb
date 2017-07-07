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

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

prompt
prompt
accept SRSNO NUMBER DEFAULT 0 PROMPT 'Please enter EPSG code of CRS to be used: '
accept VERTNO NUMBER DEFAULT 0 PROMPT 'Please enter EPSG code of the height system (use 0 if unknown or a 3D CRS is used): '
accept VERSIONING CHAR DEFAULT 'no' PROMPT 'Shall versioning be enabled (yes/no, default is no): '
accept DBVERSION CHAR DEFAULT 'S' PROMPT 'Which database license are you using? (Oracle Spatial(S)/Oracle Locator(L), default is S): '
prompt
prompt

VARIABLE SRID NUMBER;
VARIABLE CS_NAME VARCHAR2(256);
VARIABLE BATCHFILE VARCHAR2(50);

WHENEVER SQLERROR CONTINUE;

BEGIN 
  SELECT SRID,CS_NAME INTO :SRID,:CS_NAME FROM MDSYS.CS_SRS
  WHERE SRID=&SRSNO;

  IF (:SRID = &SRSNO) THEN
    IF NOT (upper('&DBVERSION')='L' or upper('&DBVERSION')='S') THEN
      :BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISTYPED_DBVERSION';
    ELSE
      :BATCHFILE := 'CREATE_DB2';
    END IF;
  ELSE 
  	:BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISSING_SRS';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      :BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISSING_SRS';
END;
/

-- set GMLSRSNAME variable
COLUMN gsn new_value GMLSRSNAME print
SELECT CASE
  WHEN &VERTNO = 0 THEN 'urn:ogc:def:crs,crs:EPSG::' || &SRSNO
  ELSE 'urn:ogc:def:crs,crs:EPSG::' || &SRSNO || ',crs:EPSG::' || &VERTNO
  END gsn FROM dual;

-- transfer the value from the bind variable to the substitution variable
COLUMN mc new_value BATCHFILE2 print
SELECT :BATCHFILE mc FROM dual;

START &BATCHFILE2