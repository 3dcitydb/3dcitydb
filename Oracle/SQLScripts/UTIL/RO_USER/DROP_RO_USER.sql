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

ACCEPT RO_USERNAME PROMPT 'Please enter the name of read-only user: '
ACCEPT SCHEMAINPUT PROMPT 'Please enter name of schema the user has access to: '

SELECT 'Revoking user priviliges ...' as message from DUAL;

DECLARE
  schema_name_user VARCHAR2(30) := upper('&SCHEMAINPUT');
  read_only_user VARCHAR2(30) := upper('&RO_USERNAME');
BEGIN
  -- DROP SYNONYMS

  -- packages
  FOR R IN (SELECT object_name FROM all_objects WHERE owner = schema_name_user AND upper(object_type) = 'PACKAGE' 
              AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE','VCDB_UTIL','VCDB_LOD_TEST','VCDB_APP_TEST','VCDB_FOOTPRINT')) LOOP
    EXECUTE IMMEDIATE 'drop synonym '||read_only_user||'.'||R.object_name;
  END LOOP;

  -- user types
  FOR R IN (SELECT type_name FROM all_types WHERE owner = schema_name_user) LOOP
    EXECUTE IMMEDIATE 'drop synonym '||read_only_user||'.'||R.type_name;
  END LOOP;


  -- REVOKE PRIVILEGES

  -- user types
  FOR R IN (SELECT type_name FROM all_types WHERE owner = schema_name_user) LOOP
    EXECUTE IMMEDIATE 'revoke execute on '||schema_name_user||'.'||R.type_name||' from "'||read_only_user||'"';
  END LOOP;

  -- packages
  FOR R IN (SELECT object_name FROM all_objects WHERE owner = schema_name_user AND upper(object_type) = 'PACKAGE' 
              AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE','VCDB_UTIL','VCDB_LOD_TEST','VCDB_APP_TEST','VCDB_FOOTPRINT')) LOOP
    EXECUTE IMMEDIATE 'revoke execute on '||schema_name_user||'.'||R.object_name||' from "'||read_only_user||'"';
  END LOOP;

  -- tables
  FOR R IN (SELECT table_name FROM all_tables WHERE owner = schema_name_user) LOOP
    EXECUTE IMMEDIATE 'revoke select on '||schema_name_user||'.'||R.table_name||' from "'||read_only_user||'"';
  END LOOP; 
END;
/

REVOKE RESOURCE FROM &RO_USERNAME;
REVOKE CONNECT FROM &RO_USERNAME;
DROP USER &RO_USERNAME CASCADE;

SELECT 'Read-only user ' || upper('&RO_USERNAME') || ' for schema ' || upper('&SCHEMAINPUT') || ' successfully removed.' as message from DUAL;