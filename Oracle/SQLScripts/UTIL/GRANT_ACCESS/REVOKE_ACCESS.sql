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

SELECT 'Revoking access priviliges on schema "' || upper('&SCHEMA_NAME') || '" from "' || upper('&USERNAME') || '" ...' as message from DUAL;

DECLARE
  target_schema VARCHAR2(30) := upper('&SCHEMA_NAME');
  user_name VARCHAR2(30) := upper('&USERNAME');
BEGIN
  -- REVOKE ACCESS
  FOR rec IN (SELECT table_name, privilege FROM dba_tab_privs WHERE grantee = user_name AND owner = target_schema) LOOP
    EXECUTE IMMEDIATE 'revoke '||rec.privilege||' on '||target_schema||'."'||rec.table_name||'" from "'||user_name||'"';
  END LOOP;
END;
/

SELECT 'Access priviliges successfully revoked.' as message from DUAL;

QUIT;
/