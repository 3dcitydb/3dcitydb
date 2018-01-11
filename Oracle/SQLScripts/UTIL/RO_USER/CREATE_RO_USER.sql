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

SET SERVEROUTPUT OFF
SET FEEDBACK ON
SET VER OFF

ACCEPT RO_USERNAME PROMPT 'Please enter a username for the read-only user: '
ACCEPT RO_PASSWORD PROMPT 'Please enter a password for the read-only user: '
ACCEPT SCHEMAINPUT PROMPT 'Please enter owner of schema the user shall have access to: '

SELECT 'Creating read-only user ' || upper('&RO_USERNAME') || ' for schema ' || upper('&SCHEMAINPUT') || '...' as message from DUAL;

CREATE USER &RO_USERNAME IDENTIFIED BY &RO_PASSWORD;
GRANT CONNECT TO &RO_USERNAME;
GRANT RESOURCE TO &RO_USERNAME;
/

DECLARE
  schema_name_user VARCHAR2(30) := upper('&SCHEMAINPUT');
  read_only_user VARCHAR2(30) := upper('&RO_USERNAME');
BEGIN
  -- GRANT ACCESS

  -- user types
  FOR R IN (SELECT type_name FROM all_types WHERE owner = schema_name_user) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||schema_name_user||'.'||R.type_name||' to "'||read_only_user||'"';
  END LOOP;

  -- packages
  FOR R IN (SELECT object_name FROM all_objects WHERE owner = schema_name_user AND upper(object_type) = 'PACKAGE' 
              AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE')) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||schema_name_user||'.'||R.object_name||' to "'||read_only_user||'"';
  END LOOP;

  -- tables
  FOR R IN (SELECT table_name FROM all_tables WHERE owner = schema_name_user) LOOP
    EXECUTE IMMEDIATE 'grant select on '||schema_name_user||'.'||R.table_name||' to "'||read_only_user||'"';
  END LOOP;
  
  -- CREATE SYNONYMS

  -- user types
  FOR R IN (SELECT type_name FROM all_types WHERE owner = schema_name_user) LOOP
    EXECUTE IMMEDIATE 'create synonym '||read_only_user||'.'||R.type_name||' for "'||schema_name_user||'".'||R.type_name;
  END LOOP;

  -- packages
  FOR R IN (SELECT object_name FROM all_objects WHERE owner = schema_name_user AND upper(object_type) = 'PACKAGE' 
              AND object_name IN ('CITYDB_UTIL','CITYDB_IDX','CITYDB_SRS','CITYDB_STAT','CITYDB_ENVELOPE')) LOOP
    EXECUTE IMMEDIATE 'create synonym '||read_only_user||'.'||R.object_name||' for "'||schema_name_user||'".'||R.object_name;
  END LOOP;
END;
/

SELECT 'Read-only user ' || upper('&RO_USERNAME') || ' for schema ' || upper('&SCHEMAINPUT') || ' successfully created.' as message from DUAL;
