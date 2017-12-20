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
  '3.3.1'::text AS version, 
  3 AS major_version, 
  3 AS minor_version, 
  1 AS minor_revision;
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
SELECT CASE 
  WHEN $1 = 4 THEN 'land_use'
  WHEN $1 = 5 THEN 'generic_cityobject'
  WHEN $1 = 7 THEN 'solitary_vegetat_object'
  WHEN $1 = 8 THEN 'plant_cover'
  WHEN $1 = 9 THEN 'waterbody'
  WHEN $1 = 11 OR 
       $1 = 12 OR 
       $1 = 13 THEN 'waterboundary_surface'
  WHEN $1 = 14 THEN 'relief_feature'
  WHEN $1 = 16 OR 
       $1 = 17 OR 
       $1 = 18 OR 
       $1 = 19 THEN 'relief_component'
  WHEN $1 = 21 THEN 'city_furniture'
  WHEN $1 = 23 THEN 'cityobjectgroup'
  WHEN $1 = 25 OR 
       $1 = 26 THEN 'building'
  WHEN $1 = 27 OR 
       $1 = 28 THEN 'building_installation'
  WHEN $1 = 30 OR 
       $1 = 31 OR 
       $1 = 32 OR 
       $1 = 33 OR 
       $1 = 34 OR 
       $1 = 35 OR
       $1 = 36 OR
       $1 = 60 OR
       $1 = 61 THEN 'thematic_surface'
  WHEN $1 = 38 OR 
       $1 = 39 THEN 'opening'
  WHEN $1 = 40 THEN 'building_furniture'
  WHEN $1 = 41 THEN 'room'
  WHEN $1 = 43 OR 
       $1 = 44 OR 
       $1 = 45 OR 
       $1 = 46 THEN 'transportation_complex'
  WHEN $1 = 47 OR 
       $1 = 48 THEN 'traffic_area'
  WHEN $1 = 57 THEN 'citymodel'
  WHEN $1 = 63 OR
       $1 = 64 THEN 'bridge'
  WHEN $1 = 65 OR
       $1 = 66 THEN 'bridge_installation'
  WHEN $1 = 68 OR 
       $1 = 69 OR 
       $1 = 70 OR 
       $1 = 71 OR 
       $1 = 72 OR
       $1 = 73 OR
       $1 = 74 OR
       $1 = 75 OR
       $1 = 76 THEN 'bridge_thematic_surface'
  WHEN $1 = 78 OR 
       $1 = 79 THEN 'bridge_opening'		 
  WHEN $1 = 80 THEN 'bridge_furniture'
  WHEN $1 = 81 THEN 'bridge_room'
  WHEN $1 = 82 THEN 'bridge_constr_element'
  WHEN $1 = 84 OR
       $1 = 85 THEN 'tunnel'
  WHEN $1 = 86 OR
       $1 = 87 THEN 'tunnel_installation'
  WHEN $1 = 88 OR 
       $1 = 89 OR 
       $1 = 90 OR 
       $1 = 91 OR 
       $1 = 92 OR
       $1 = 93 OR
       $1 = 94 OR
       $1 = 95 OR
       $1 = 96 THEN 'tunnel_thematic_surface'
  WHEN $1 = 99 OR 
       $1 = 100 THEN 'tunnel_opening'		 
  WHEN $1 = 101 THEN 'tunnel_furniture'
  WHEN $1 = 102 THEN 'tunnel_hollow_space'
  ELSE
    'Unknown table'
  END;
$$
LANGUAGE sql IMMUTABLE STRICT;
