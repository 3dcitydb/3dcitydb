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
-- About:
-- Drops subpackages "citydb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.3     2016-03-24   update to version 3.2                       ZYao
-- 1.0.2     2015-11-05   update to version 3.1                       FKun
-- 1.0.1     2011-07-28   update to version 2.0.6                     CNag
-- 1.0.0     2011-05-16   release version                             JHer
--

SET SERVEROUTPUT ON;

DECLARE

-- functions  
  FUNCTION user_object_exists(v_object_type varchar2, v_object_name varchar2) RETURN number IS
    v_object_exists number := 0;
  BEGIN
    SELECT COUNT(*) INTO v_object_exists FROM user_objects
      WHERE object_type = UPPER(v_object_type)
        AND object_name = UPPER(v_object_name);
   
    RETURN v_object_exists;
  END; -- FUNCTION user_object_exists


-- procedures
   PROCEDURE drop_user_object_if_exists (v_object_type varchar2, v_object_name varchar2) IS
   BEGIN
     IF user_object_exists(v_object_type, v_object_name) <> 0 THEN
       EXECUTE IMMEDIATE 'DROP '|| v_object_type || ' ' || v_object_name;
       dbms_output.put_line(v_object_type || ' ' || v_object_name || ' deleted');
     END IF;
   END; -- PROCEDURE drop_user_object_if_exists

-- main

BEGIN

  dbms_output.put_line('Starting CITYDB package deletion...');

  --// drop global sequences
  drop_user_object_if_exists('Sequence', 'INDEX_TABLE_SEQ');
  
  --// drop global tables
  drop_user_object_if_exists('Table', 'INDEX_TABLE');

  --// drop global types
  drop_user_object_if_exists('Type', 'STRARRAY');
  drop_user_object_if_exists('Type', 'ID_ARRAY');
  drop_user_object_if_exists('Type', 'INDEX_OBJ');
  drop_user_object_if_exists('Type', 'DB_INFO_TABLE');
  drop_user_object_if_exists('Type', 'DB_INFO_OBJ');
  drop_user_object_if_exists('Type', 'DB_VERSION_TABLE');
  drop_user_object_if_exists('Type', 'DB_VERSION_OBJ');
   
  --// drop packages
  drop_user_object_if_exists('Package', 'citydb_util');
  drop_user_object_if_exists('Package', 'citydb_idx');
  drop_user_object_if_exists('Package', 'citydb_srs');
  drop_user_object_if_exists('Package', 'citydb_stat');
  drop_user_object_if_exists('Package', 'citydb_delete_by_lineage');
  drop_user_object_if_exists('Package', 'citydb_delete');

  dbms_output.put_line('CITYDB package deletion complete!');
  dbms_output.put_line('');

END;
/

