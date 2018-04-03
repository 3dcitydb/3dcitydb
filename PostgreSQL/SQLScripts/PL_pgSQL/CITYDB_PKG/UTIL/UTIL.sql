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
*   citydb_version( 
*     OUT version TEXT, 
*     OUT major_version INTEGER, 
*     OUT minor_version INTEGER, 
*     OUT minor_revision INTEGER
*     ) RETURNS RECORD
*   db_info(
*     schema_name TEXT DEFAULT 'citydb',
*     OUT schema_srid INTEGER,
*     OUT schema_gml_srs_name TEXT,
*     OUT versioning TEXT
*     ) RETURNS RECORD
*   db_metadata(
*     schema_name TEXT DEFAULT 'citydb',
*     OUT schema_srid INTEGER, 
*     OUT schema_gml_srs_name TEXT, 
*     OUT coord_ref_sys_name TEXT, 
*     OUT coord_ref_sys_kind TEXT,
*     OUT wktext TEXT,  
*     OUT versioning TEXT
*     ) RETURNS RECORD
*   get_seq_values(seq_name TEXT, seq_count INTEGER) RETURNS SETOF INTEGER
*   min(a NUMERIC, b NUMERIC) RETURNS NUMERIC
*   objectclass_id_to_table_name(class_id INTEGER) RETURNS TEXT
*   table_name_to_objectclass_ids(table_name TEXT) RETURNS INTEGER[]
*   update_schema_constraints(on_delete_param TEXT DEFAULT 'CASCADE', schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   update_table_constraint(fkey_name TEXT, table_name TEXT, column_name TEXT, ref_table TEXT, ref_column TEXT, 
*     delete_param TEXT, deferrable_param TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   versioning_db(schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
*   versioning_table(table_name TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
******************************************************************/

/*****************************************************************
* citydb_version
*
* @RETURN RECORD with columns
*   version - version of 3DCityDB as string
*   major_version - major version number of 3DCityDB instance
*   minor_version - minor version number of 3DCityDB instance
*   minor_revision - minor revision number of 3DCityDB instance
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.citydb_version( 
  OUT version TEXT, 
  OUT major_version INTEGER, 
  OUT minor_version INTEGER, 
  OUT minor_revision INTEGER
  ) RETURNS RECORD AS 
$$
SELECT 
  '4.0.0'::text AS version, 
  4 AS major_version, 
  0 AS minor_version, 
  0 AS minor_revision;
$$
LANGUAGE sql IMMUTABLE;


/*****************************************************************
* versioning_table
*
* @param table_name name of table
* @param schema_name name of schema of target table
*
* @RETURN TEXT 'ON' for version-enabled, 'OFF' otherwise
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.versioning_table(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS 
$$
SELECT 'OFF'::text;
$$
LANGUAGE sql IMMUTABLE;


/*****************************************************************
* versioning_db
*
* @param schema_name name of schema
*
* @RETURN TEXT 'ON' for version-enabled, 'OFF' for version-disabled
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.versioning_db(schema_name TEXT DEFAULT 'citydb') RETURNS TEXT AS 
$$
SELECT 'OFF'::text;
$$
LANGUAGE sql IMMUTABLE;


/*****************************************************************
* db_info
*
* @param schema_name name of database schema
*
* @RETURN RECORD with columns
*    SCHEMA_SRID, SCHEMA_GML_SRS_NAME, VERSIONING
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_info(
  schema_name TEXT DEFAULT 'citydb',
  OUT schema_srid INTEGER, 
  OUT schema_gml_srs_name TEXT,
  OUT versioning TEXT
  ) RETURNS RECORD AS 
$$
BEGIN
  EXECUTE format(
    'SELECT 
       srid, gml_srs_name, citydb_pkg.versioning_db($1)
     FROM
       %I.database_srs', schema_name)
    USING schema_name
    INTO schema_srid, schema_gml_srs_name, versioning;
END;
$$
LANGUAGE plpgsql STABLE;


/******************************************************************
* db_metadata
*
* @param schema_name name of database schema
*
* @RETURN RECORD with columns
*    SCHEMA_SRID, SCHEMA_GML_SRS_NAME,
*    COORD_REF_SYS_NAME, COORD_REF_SYS_KIND, VERSIONING
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata(
  schema_name TEXT DEFAULT 'citydb',
  OUT schema_srid INTEGER, 
  OUT schema_gml_srs_name TEXT, 
  OUT coord_ref_sys_name TEXT, 
  OUT coord_ref_sys_kind TEXT,
  OUT wktext TEXT,  
  OUT versioning TEXT
  ) RETURNS RECORD AS 
$$
BEGIN
  EXECUTE format(
    'SELECT 
       d.srid,
       d.gml_srs_name,
       split_part(s.srtext, ''"'', 2),
       split_part(s.srtext, ''['', 1),
       s.srtext,
       citydb_pkg.versioning_db($1) AS versioning
     FROM 
       %I.database_srs d,
       spatial_ref_sys s 
     WHERE
       d.srid = s.srid', schema_name)
    USING schema_name
    INTO schema_srid, schema_gml_srs_name, coord_ref_sys_name, coord_ref_sys_kind, wktext, versioning;
END;
$$
LANGUAGE plpgsql STABLE;


/******************************************************************
* min
*
* @param a first NUMERIC value
* @param b second NUMERIC value
*
* @RETURN NUMERIC the smaller of the two input NUMERIC values                
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.min(
  a NUMERIC, 
  b NUMERIC
  ) RETURNS NUMERIC AS 
$$
SELECT LEAST($1,$2);
$$
LANGUAGE sql IMMUTABLE;


/******************************************************************
* update_table_constraint
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
CREATE OR REPLACE FUNCTION citydb_pkg.update_table_constraint(
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

  EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I, ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES %I.%I (%I)
                    ON UPDATE CASCADE ON DELETE ' || delete_param, $7, $2, $1, $1, $3, $7, $4, $5);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Error on constraint %: %', fkey_name, SQLERRM;
END;
$$
LANGUAGE plpgsql STRICT;


/******************************************************************
* update_schema_constraints
*
* calls update_table_constraint for updating all the constraints
* in the specified schema where options for on_delete_param are:
* a = NO ACTION
* r = RESTRICT
* c = CASCADE
* n = SET NULL
*
* @param on_delete_param default is 'a' = NO ACTION
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.update_schema_constraints(
  on_delete_param CHAR DEFAULT 'a',
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
SELECT
  citydb_pkg.update_table_constraint(
    c.conname,
    c.conrelid::regclass::text,
    a.attname,
    t.relname,
    a_ref.attname,
    $1,
    n.nspname)
FROM pg_constraint c
JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY (c.conkey)
JOIN pg_attribute a_ref ON a_ref.attrelid = c.confrelid AND a_ref.attnum = ANY (c.confkey)
JOIN pg_class t ON t.oid = a_ref.attrelid
JOIN pg_namespace n ON n.oid = c.connamespace
  WHERE n.nspname = $2
    AND c.contype = 'f';
$$
LANGUAGE sql STRICT;


/*****************************************************************
* get_sequence_values
*
* @param seq_name name of the sequence
* @param count number of values to be queried from the sequence
* @param schema_name name of schema of target sequence
*
* @RETURN INTEGER SET list of sequence values from given sequence
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_seq_values(
  seq_name TEXT,
  seq_count INTEGER
  ) RETURNS SETOF INTEGER AS 
$$
SELECT nextval($1)::int FROM generate_series(1, $2);
$$
LANGUAGE sql STRICT;


/*****************************************************************
* objectclass_id_to_table_name
*
* @param class_id objectclass_id identifier
*
* @RETURN TEXT name of table that stores objects referred 
*              to the given objectclass_id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_id_to_table_name(class_id INTEGER) RETURNS TEXT AS
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
CREATE OR REPLACE FUNCTION citydb_pkg.table_name_to_objectclass_ids(table_name TEXT) RETURNS INTEGER[] AS
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