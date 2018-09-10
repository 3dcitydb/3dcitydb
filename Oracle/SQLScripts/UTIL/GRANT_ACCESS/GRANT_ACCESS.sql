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

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

-- parse arguments
DEFINE USERNAME=&1;
DEFINE SCHEMA_NAME=&2;
DEFINE ACCESS_MODE=&3;

VARIABLE text VARCHAR2(10);
EXEC IF upper('&ACCESS_MODE') = 'RW' THEN :text := 'read-write'; ELSE :text := 'read-only'; END IF;

SELECT 'Granting ' || :text || ' priviliges on schema "' || upper('&SCHEMA_NAME') || '" to user "' || upper('&USERNAME') || '" ...' as message from DUAL;

DECLARE
  target_schema VARCHAR2(30) := upper('&SCHEMA_NAME');
  user_name VARCHAR2(30) := upper('&USERNAME');
  privilege_type VARCHAR(10);
BEGIN
  -- GRANT ACCESS
  -- user types
  FOR rec IN (SELECT type_name FROM all_types WHERE owner = target_schema) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.type_name||'" to "'||user_name||'"';
  END LOOP;
  
  -- packages
  FOR rec IN (SELECT object_name FROM all_objects WHERE owner = target_schema AND upper(object_type) = 'PACKAGE'
              AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE')) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.object_name||'" to "'||user_name||'"';
  END LOOP;
  
  IF upper('&ACCESS_MODE') = 'RW' THEN
    FOR rec IN (SELECT object_name FROM all_objects WHERE owner = target_schema AND upper(object_type) = 'PACKAGE'
                AND object_name IN ('CITYDB_DELETE')) LOOP
      EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.object_name||'" to "'||user_name||'"';
    END LOOP;
  END IF;

  -- tables
  FOR rec IN (SELECT table_name FROM all_tables WHERE owner = target_schema) LOOP
    IF upper('&ACCESS_MODE') = 'RW' THEN
      privilege_type := 'all';
	ELSE
	  privilege_type := 'select';
	END IF;
	
	EXECUTE IMMEDIATE 'grant '||privilege_type||' on '||target_schema||'."'||rec.table_name||'" to "'||user_name||'"';
  END LOOP;
  
  -- sequences
  IF upper('&ACCESS_MODE') = 'RW' THEN
    FOR rec IN (SELECT sequence_name FROM all_sequences WHERE sequence_owner = target_schema) LOOP
      EXECUTE IMMEDIATE 'grant all on '||target_schema||'."'||rec.sequence_name||'" to "'||user_name||'"';
    END LOOP;
  END IF;
END;
/

SELECT 'Successfully granted ' || :text || ' priviliges.' as message from DUAL;

QUIT;
/