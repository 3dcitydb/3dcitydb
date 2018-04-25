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
* CONTENT
*
* FUNCTIONS:
*   objectclass_id_to_table_name(class_id INTEGER) RETURNS TEXT
*   table_name_to_objectclass_ids(table_name TEXT) RETURNS INTEGER[]
******************************************************************/

/*****************************************************************
* objectclass_id_to_table_name
*
* @param class_id objectclass_id identifier
*
* @RETURN TEXT name of table that stores objects referred 
*              to the given objectclass_id
******************************************************************/
CREATE OR REPLACE FUNCTION objectclass_id_to_table_name(class_id INTEGER) RETURNS TEXT AS
$$
SELECT
  tablename
FROM
  objectclass
WHERE
  id = $1;
$$
LANGUAGE sql STABLE STRICT;


/*****************************************************************
* table_name_to_objectclass_ids
*
* @param table_name name of table
*
* @RETURN INT[] array of objectclass_ids
******************************************************************/
CREATE OR REPLACE FUNCTION table_name_to_objectclass_ids(table_name TEXT) RETURNS INTEGER[] AS
$$
WITH RECURSIVE objectclass_tree (id, superclass_id) AS (
  SELECT
    id,
    superclass_id
  FROM
    objectclass
  WHERE
    tablename = lower($1)
  UNION ALL
    SELECT
      o.id,
      o.superclass_id
    FROM
      objectclass o,
      objectclass_tree t
    WHERE
      o.superclass_id = t.id
)
SELECT
  array_agg(DISTINCT id ORDER BY id)
FROM
  objectclass_tree;
$$
LANGUAGE sql STABLE STRICT;