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
*   get_short_name(table_name TEXT, schema_name TEXT) RETURNS TEXT
*   min(a NUMERIC, b NUMERIC) RETURNS NUMERIC
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


/*****************************************************************
* get_short_name
*
* @param table_name name of table that needs to be shortened
* @param schema_name name of schema to query short name
*
* @RETURN INTEGER SET list of sequence values from given sequence
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_short_name(
  table_name TEXT,
  schema_name TEXT
  ) RETURNS TEXT AS
$$
-- TODO: query a table that stores the short version of a table (maybe objectclass?)
SELECT substr($1, 1, 17);
$$
LANGUAGE sql STABLE STRICT;


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
* cleanup_schema
*
* @param schema_name name of schema to be cleaned up
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID AS
$$
DECLARE
  tab TEXT;
  seq TEXT;
BEGIN
  -- truncate tables
  FOR tab IN
    WITH RECURSIVE table_dependency(table_oid) AS (
      SELECT DISTINCT ON (c.conrelid)
        c.conrelid AS table_oid,
        1 AS depth
      FROM
        pg_constraint c
      JOIN
        pg_namespace n
        ON n.oid = c.connamespace
      WHERE
        n.nspname = 'citydb'
        AND c.conrelid <> 'database_srs'::regclass::oid
        AND c.conrelid <> 'objectclass'::regclass::oid
        AND c.conrelid <> 'schema_to_objectclass'::regclass::oid
        AND c.conrelid <> 'schema'::regclass::oid
        AND c.conrelid <> 'schema_referencing'::regclass::oid
        AND c.conrelid <> 'ade'::regclass::oid
        AND c.contype = 'f'
        AND c.conrelid <> c.confrelid
      UNION ALL
        SELECT DISTINCT ON (c.conrelid)
          c.conrelid AS table_oid,
          d.depth + 1 AS depth
        FROM
          pg_constraint c
        JOIN
          pg_namespace n
          ON n.oid = c.connamespace
        JOIN table_dependency d
          ON d.table_oid = c.confrelid
        WHERE
          n.nspname = 'citydb'
          AND c.conrelid <> 'database_srs'::regclass::oid
          AND c.conrelid <> 'objectclass'::regclass::oid
          AND c.conrelid <> 'schema_to_objectclass'::regclass::oid
          AND c.conrelid <> 'schema'::regclass::oid
          AND c.conrelid <> 'schema_referencing'::regclass::oid
          AND c.conrelid <> 'ade'::regclass::oid
          AND c.contype = 'f'
          AND d.table_oid <> c.conrelid
    )
    SELECT
      table_oid::regclass::text AS table_name,
      max(depth) AS rel_depth
    FROM
      table_dependency
    GROUP BY
      table_oid
    ORDER BY
      rel_depth DESC
  LOOP
    EXECUTE format('TRUNCATE TABLE %I.%I CASCADE', schema_name, tab);
  END LOOP;

  -- reset sequences
  FOR seq IN
    SELECT
      c.relname
    FROM
      pg_class c,
      pg_namespace n
    WHERE
      c.relnamespace = n.oid
      AND n.nspname = $1
      AND relkind = 'S'
  LOOP
    EXECUTE format('ALTER SEQUENCE %I.%I RESTART', schema_name, seq);
  END LOOP;
END;
$$
LANGUAGE plpgsql STRICT;