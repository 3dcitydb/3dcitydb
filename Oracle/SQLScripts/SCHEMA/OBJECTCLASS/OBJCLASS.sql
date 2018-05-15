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


/*****************************************************************
* PACKAGE citydb_objclass
* 
* utility methods for retrieving objclass names and IDs
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_objclass
AS
  FUNCTION objectclass_id_to_table_name(class_id NUMBER) RETURN VARCHAR2;
  FUNCTION table_name_to_objectclass_ids(table_name VARCHAR2) RETURN ID_ARRAY;

END citydb_objclass;
/

CREATE OR REPLACE PACKAGE BODY citydb_objclass
AS
  
  /*****************************************************************
  * objectclass_id_to_table_name
  *
  * @param class_id objectclass_id identifier
  * @return VARCHAR2 name of table that stores objects referred 
  *                  to the given objectclass_id
  ******************************************************************/
  FUNCTION objectclass_id_to_table_name(class_id NUMBER) RETURN VARCHAR2
  IS
    table_name VARCHAR2(30) := '';
  BEGIN
    SELECT
      tablename
    INTO
      table_name
    FROM
      objectclass
    WHERE
      id = class_id;

    RETURN table_name;
  END;


  /*****************************************************************
  * table_name_to_objectclass_ids
  *
  * @param table_name name of table
  * @return ID_ARRAY array of objectclass_ids
  ******************************************************************/
  FUNCTION table_name_to_objectclass_ids(table_name VARCHAR2) RETURN ID_ARRAY
  IS
    objclass_ids ID_ARRAY;
  BEGIN
    SELECT DISTINCT
      id
    BULK COLLECT INTO
      objclass_ids
    FROM
      objectclass
    START WITH
      tablename = lower(table_name)
    CONNECT BY PRIOR
      id = superclass_id
    ORDER BY
      id;

    RETURN objclass_ids;
  END;

END citydb_objclass;
/