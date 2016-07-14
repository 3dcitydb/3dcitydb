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
-- 1.0.0     2015-01-22   release version                             AM
--                                                                    FKun
--

SET SERVEROUTPUT ON;
ACCEPT SCHEMAINPUT PROMPT 'Enter the user name of 3DCityDB v3.1 instance : '

DECLARE
    schema_name_user VARCHAR2(30) := upper('&SCHEMAINPUT');
BEGIN
	FOR R IN (SELECT table_name FROM user_tables) LOOP
		EXECUTE IMMEDIATE 'grant select on '||R.table_name||' to "'||schema_name_user||'"';
		dbms_output.put_line('grant select on '||R.table_name||' to "'||schema_name_user||'"');
	END LOOP;
END;
/