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

VARIABLE MESSAGE VARCHAR2(100);

SELECT 'Granting read-only priviliges on schema "' || upper('&SCHEMA_NAME') || '" to user "' || upper('&RO_USERNAME') || '" ...' as message from DUAL;

DECLARE
  target_schema VARCHAR2(30) := upper('&SCHEMA_NAME');
  ro_user VARCHAR2(30) := upper('&RO_USERNAME');
  owner_list dbms_sql.varchar2_table;
BEGIN
  -- check whether ro_user already has a grant to a 3DCityDB schema
  SELECT DISTINCT OWNER BULK COLLECT INTO owner_list 
    FROM dba_tab_privs 
	  WHERE grantee = ro_user
	  AND table_name = 'DATABASE_SRS';
		
  IF owner_list.COUNT > 0 THEN
	dbms_output.put_line('Error: "'||ro_user||'" already is granted access to the following schemas:');
	FOR i IN 1..owner_list.COUNT LOOP
	  dbms_output.put_line(owner_list(i));
	END LOOP;
	  
	dbms_output.put_line(chr(10));
	dbms_output.put_line('Remove these grants first.');	
    :MESSAGE := 'Failed to grant read-only priviliges.';
  ELSE
    -- GRANT ACCESS
    -- user types
    FOR rec IN (SELECT type_name FROM all_types WHERE owner = target_schema) LOOP
      EXECUTE IMMEDIATE 'grant execute on '||target_schema||'.'||rec.type_name||' to "'||ro_user||'"';
    END LOOP;
  
    -- packages
    FOR rec IN (SELECT object_name FROM all_objects WHERE owner = target_schema AND upper(object_type) = 'PACKAGE' 
                AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE')) LOOP
      EXECUTE IMMEDIATE 'grant execute on '||target_schema||'.'||rec.object_name||' to "'||ro_user||'"';
    END LOOP;

    -- tables
    FOR rec IN (SELECT table_name FROM all_tables WHERE owner = target_schema) LOOP
      EXECUTE IMMEDIATE 'grant select on '||target_schema||'.'||rec.table_name||' to "'||ro_user||'"';
    END LOOP;
  
    -- CREATE SYNONYMS  
    -- user types
    FOR rec IN (SELECT type_name FROM all_types WHERE owner = target_schema) LOOP
      EXECUTE IMMEDIATE 'create or replace synonym '||ro_user||'.'||rec.type_name||' for "'||target_schema||'".'||rec.type_name;
    END LOOP;

    -- packages
    FOR rec IN (SELECT object_name FROM all_objects WHERE owner = target_schema AND upper(object_type) = 'PACKAGE' 
                AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE')) LOOP
      EXECUTE IMMEDIATE 'create or replace synonym '||ro_user||'.'||rec.object_name||' for "'||target_schema||'".'||rec.object_name;
    END LOOP;
  
    :MESSAGE := 'Read-only priviliges successfully granted.';
  END IF;
END;
/

print MESSAGE;

QUIT;
/
