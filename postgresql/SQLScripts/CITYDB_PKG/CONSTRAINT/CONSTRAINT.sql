-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
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
*   set_enabled_fkey(fkey_trigger_oid OID, enable BOOLEAN DEFAULT TRUE) RETURNS SETOF VOID
*   set_enabled_geom_fkeys(enable BOOLEAN DEFAULT TRUE, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   set_enabled_schema_fkeys(enable BOOLEAN DEFAULT TRUE, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   set_fkey_delete_rule(fkey_name TEXT, table_name TEXT, column_name TEXT, ref_table TEXT, ref_column TEXT, 
*     on_delete_param CHAR DEFAULT 'a', schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   set_schema_fkeys_delete_rule(on_delete_param CHAR DEFAULT 'a', schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
******************************************************************/

/******************************************************************
* set_fkey_delete_rule
*
* Removes a constraint to add it again with given ON DELETE parameter
*
* @param fkey_name name of the foreign key that is updated 
* @param table_name defines the table to which the constraint belongs to
* @param column_name defines the column the constraint is relying on
* @param ref_table name of referenced table
* @param ref_column name of referencing column of referenced table
* @param delete_param whether NO ACTION, RESTIRCT, CASCADE or SET NULL
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.set_fkey_delete_rule(
  fkey_name TEXT,
  table_name TEXT,
  column_name TEXT,
  ref_table TEXT,
  ref_column TEXT,
  on_delete_param CHAR DEFAULT 'a',
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  delete_param VARCHAR(9);
BEGIN
  CASE on_delete_param
    WHEN 'r' THEN delete_param := 'RESTRICT';
    WHEN 'c' THEN delete_param := 'CASCADE';
    WHEN 'n' THEN delete_param := 'SET NULL';
    ELSE delete_param := 'NO ACTION';
  END CASE;

  EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I, ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES %I.%I (%I) MATCH FULL
                    ON UPDATE CASCADE ON DELETE ' || delete_param, $7, $2, $1, $1, $3, $7, $4, $5);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Error on constraint %: %', fkey_name, SQLERRM;
END;
$$
LANGUAGE plpgsql STRICT;

/******************************************************************
* set_schema_fkeys_delete_rule
*
* calls set_fkey_delete_rule for updating all the constraints
* in the specified schema where options for on_delete_param are:
* a = NO ACTION
* r = RESTRICT
* c = CASCADE
* n = SET NULL
*
* @param on_delete_param default is 'a' = NO ACTION
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.set_schema_fkeys_delete_rule(
  on_delete_param CHAR DEFAULT 'a',
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
SELECT
  citydb_pkg.set_fkey_delete_rule(
    c.conname,
    c.conrelid::regclass::text,
    a.attname,
    t.relname,
    a_ref.attname,
    $1,
    n.nspname
  )
FROM pg_constraint c
JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY (c.conkey)
JOIN pg_attribute a_ref ON a_ref.attrelid = c.confrelid AND a_ref.attnum = ANY (c.confkey)
JOIN pg_class t ON t.oid = a_ref.attrelid
JOIN pg_namespace n ON n.oid = c.connamespace
  WHERE n.nspname = $2
    AND c.contype = 'f';
$$
LANGUAGE sql STRICT;

/******************************************************************
* set_enabled_fkey
*
* Enables or disables a given foreign key constraint
* Note: Takes only effect in susequent sessions!
* (requires superuser privilege to execute)
*
* @param fkey_trigger_oid internal OID of foreign key trigger
* @param enable boolean flag to toggle constraint
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.set_enabled_fkey(
  fkey_trigger_oid OID,
  enable BOOLEAN DEFAULT TRUE
  ) RETURNS SETOF VOID AS
$$
DECLARE
  tgstatus char(1);
BEGIN
  IF $2 THEN
    tgstatus := 'O';
  ELSE
    tgstatus := 'D';
  END IF;

  UPDATE
    pg_trigger
  SET
    tgenabled = tgstatus
  WHERE
    oid = $1;
END;
$$
LANGUAGE plpgsql STRICT;

/******************************************************************
* set_enabled_geom_fkeys
*
* enables/disables references to SURFACE_GEOMETRY table
* (requires superuser privilege to execute)
*
* @param enable boolean flag to toggle constraint
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.set_enabled_geom_fkeys(
  enable BOOLEAN DEFAULT TRUE,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
SELECT
  citydb_pkg.set_enabled_fkey(
    t.oid,
    $1
  )
FROM
  pg_constraint c
JOIN
  pg_trigger t
  ON t.tgconstraint = c.oid
WHERE
  c.contype = 'f'
  AND c.confrelid = (lower($2) || '.surface_geometry')::regclass::oid
  AND c.confdeltype <> 'c'
$$
LANGUAGE sql STRICT;

/******************************************************************
* set_enabled_geom_fkeys
*
* enables/disables all foreign keys in a given schema
* (requires superuser privilege to execute)
*
* @param enable boolean flag to toggle constraint
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.set_enabled_schema_fkeys(
  enable BOOLEAN DEFAULT TRUE,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
SELECT
  citydb_pkg.set_enabled_fkey(
    t.oid,
    $1
  )
FROM
  pg_constraint c
JOIN
  pg_namespace n
  ON n.oid = c.connamespace
JOIN
  pg_trigger t
  ON t.tgconstraint = c.oid
WHERE
  c.contype = 'f'
  AND c.confdeltype <> 'c'
  AND n.nspname = $2;
$$
LANGUAGE sql STRICT;