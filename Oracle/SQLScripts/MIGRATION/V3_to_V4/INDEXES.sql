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


/*************************************************
* remove indexes obsolete for v4.0.0
*
**************************************************/
BEGIN
  FOR rec IN (
    SELECT
      ui.index_name
    FROM
      user_indexes ui
    JOIN
      user_ind_columns uic
      ON uic.index_name = ui.index_name
    JOIN
      (SELECT
        column_name,
        table_name
      FROM
        user_ind_columns uic
      WHERE
        table_name LIKE '%_TO_%'
        AND column_position = 2
      ) pk
      ON uic.column_name = pk.column_name
      AND uic.table_name = pk.table_name
    WHERE
      ui.uniqueness = 'NONUNIQUE'
    UNION ALL
    SELECT
      index_name
    FROM
      user_indexes      
    WHERE
      (index_name LIKE '%OBJCLASS_FKX'
      OR index_name LIKE '%OBJECTCLASS_FKX')
      AND index_name <> 'CITYOBJECT_OBJECTCLASS_FKX'
  )
  LOOP
    EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
  END LOOP;
END;
/

/*************************************************
* create indexes new in v4.0.0
*
**************************************************/
CREATE INDEX SCHEMA_REFERENCING_FKX ON SCHEMA_REFERENCING (REFERENCING_ID);

CREATE INDEX SCHEMA_TO_OBJECTCLASS_FKX ON SCHEMA_TO_OBJECTCLASS (OBJECTCLASS_ID);