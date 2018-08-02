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
DO
$$
DECLARE
  idx TEXT;
BEGIN
  FOR idx IN (
    SELECT
      c.relname::text
    FROM
      pg_class c,
      pg_index i,
      pg_namespace n
    WHERE
      c.oid = i.indexrelid
      AND c.relnamespace = n.oid
      AND c.relkind = 'i'
      AND n.nspname = 'citydb'
      AND (c.relname LIKE '%objclass_fkx'
       OR c.relname LIKE '%objectclass_fkx'
       OR c.relname LIKE '%\_to\_%')
      AND c.relname <> 'cityobject_objectclass_fkx'
      AND i.indkey[0] > 1
  )
  LOOP
    EXECUTE format('DROP INDEX citydb.%I', idx);
  END LOOP;
END;
$$
LANGUAGE plpgsql;

/*************************************************
* create indexes new in v4.0.0
*
**************************************************/
CREATE INDEX schema_referencing_fkx ON schema_referencing
  USING btree (referencing_id ASC NULLS LAST) WITH (FILLFACTOR = 90);

CREATE INDEX schema_to_objectclass_fkx ON schema_to_objectclass
  USING btree (objectclass_id ASC NULLS LAST) WITH (FILLFACTOR = 90);