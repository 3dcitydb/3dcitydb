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

-- parse arguments
DEFINE SRSNO=&1;
DEFINE GMLSRSNAME=&2;
DEFINE VERSIONING=&3;
DEFINE DBVERSION=&4;

VARIABLE SRID NUMBER;
VARIABLE BATCHFILE VARCHAR2(50);

WHENEVER SQLERROR CONTINUE;

BEGIN
  SELECT SRID INTO :SRID FROM MDSYS.CS_SRS WHERE SRID=&SRSNO;

  IF (:SRID = &SRSNO) THEN
    IF NOT (upper('&DBVERSION')='L' or upper('&DBVERSION')='S') THEN
      :BATCHFILE := 'UTIL/HINTS/HINT_ON_MISTYPED_DBVERSION';
    ELSE
      :BATCHFILE := 'CREATE_DB2';
    END IF;
  ELSE 
    :BATCHFILE := 'UTIL/HINTS/HINT_ON_MISSING_SRS';
  END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      :BATCHFILE := 'UTIL/HINTS/HINT_ON_MISSING_SRS';
END;
/

-- Transfer the value from the bind variable to the substitution variable
column script new_value BATCHFILE2 print
select :BATCHFILE script from dual;

START &BATCHFILE2 &SRSNO &GMLSRSNAME &VERSIONING &DBVERSION

QUIT;
/
