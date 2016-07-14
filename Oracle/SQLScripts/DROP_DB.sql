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
-------------------------------------------------------------------------------
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2015-03-05   added support for Oracle Locator            ZYao
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
-- 2.0.2     2008-06-28   disable versioning before dropping          TKol
-- 2.0.1     2008-06-28   also drop planning manager tables           TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ASta
--                                                                    ALor
--
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

prompt
prompt DROP_DB procedure will be started
accept DBVERSION CHAR DEFAULT 'S' PROMPT 'Which database license are you using? (Oracle Spatial(S)/Oracle Locator(L), default is S): '
prompt

VARIABLE BATCHFILE VARCHAR2(50);

BEGIN
  IF NOT (upper('&DBVERSION')='L' or upper('&DBVERSION')='S') THEN
  	:BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISTYPED_DBVERSION';	
  ELSE 
  	:BATCHFILE := 'DROP_DB2';
  END IF;  
END;
/

-- Transfer the value from the bind variable to the substitution variable
column mc new_value BATCHFILE2 print
select :BATCHFILE mc from dual;

@@&BATCHFILE2
