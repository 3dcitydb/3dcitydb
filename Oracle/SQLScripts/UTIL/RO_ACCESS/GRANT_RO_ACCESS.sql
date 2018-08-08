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
DEFINE RO_USERNAME=&1;
DEFINE SCHEMA_NAME=&2;

SELECT 'Granting read-only priviliges on schema "' || upper('&SCHEMA_NAME') || '" to user "' || upper('&RO_USERNAME') || '" ...' as message from DUAL;

DECLARE
  target_schema VARCHAR2(30) := upper('&SCHEMA_NAME');
  ro_user VARCHAR2(30) := upper('&RO_USERNAME');
BEGIN
  -- GRANT ACCESS
  -- user types
  FOR rec IN (SELECT type_name FROM all_types WHERE owner = target_schema) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.type_name||'" to "'||ro_user||'"';
  END LOOP;
  
  -- packages
  FOR rec IN (SELECT object_name FROM all_objects WHERE owner = target_schema AND upper(object_type) = 'PACKAGE' 
              AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE')) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.object_name||'" to "'||ro_user||'"';
  END LOOP;

  -- tables
  FOR rec IN (SELECT table_name FROM all_tables WHERE owner = target_schema) LOOP
    EXECUTE IMMEDIATE 'grant select on '||target_schema||'."'||rec.table_name||'" to "'||ro_user||'"';
  END LOOP;
END;
/

SELECT 'Read-only priviliges successfully granted.' as message from DUAL;

QUIT;
/
