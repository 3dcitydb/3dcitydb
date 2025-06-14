/*****************************************************************
* citydb_version
*
* @return RECORD with columns
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
  '@versionString@'::text AS version,
  @majorVersion@::int AS major_version,
  @minorVersion@::int AS minor_version,
  @minorRevision@::int AS minor_revision;
$$
LANGUAGE sql IMMUTABLE;

/******************************************************************
* db_metadata
*
* @param schema_name Name of database schema
* @return RECORD with columns
*    srid, srs_name,
*    coord_ref_sys_name, coord_ref_sys_kind, wktext
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata(
  schema_name TEXT DEFAULT 'citydb',
  OUT srid INTEGER,
  OUT srs_name TEXT,
  OUT coord_ref_sys_name TEXT, 
  OUT coord_ref_sys_kind TEXT,
  OUT wktext TEXT
  ) RETURNS RECORD AS 
$$
BEGIN
  EXECUTE format(
    'SELECT 
       d.srid,
       d.srs_name,
       split_part(s.srtext, ''"'', 2),
       split_part(s.srtext, ''['', 1),
       s.srtext
     FROM 
       %I.database_srs d,
       spatial_ref_sys s 
     WHERE
       d.srid = s.srid', schema_name)
    INTO srid, srs_name, coord_ref_sys_name, coord_ref_sys_kind, wktext;
END;
$$
LANGUAGE plpgsql STABLE;

/*****************************************************************
* get_seq_values
*
* @param seq_name Name of the sequence including a schema prefix
* @param count Number of values to be queried from the sequence
* @return List of sequence values from given sequence
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_seq_values(
  seq_name TEXT,
  seq_count BIGINT
  ) RETURNS SETOF BIGINT AS
$$
SELECT nextval($1)::bigint FROM generate_series(1, $2);
$$
LANGUAGE sql STRICT;

/*****************************************************************
* get_child_objectclass_ids
*
* @param class_id Identifier for object class
* @param skip_abstract Set to 1 if abstract classes shall be skipped, 0 if not
* @param schema_name Name of schema
* @return The IDs of all transitive subclasses of the given object class
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_child_objectclass_ids(
  class_id INTEGER,
  skip_abstract INTEGER DEFAULT 0,	
  schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER AS
$$
DECLARE
  where_clause TEXT := '';
BEGIN
  IF skip_abstract <> 0 THEN
    where_clause = 'WHERE h.is_abstract <> 1';
  END IF;
  
  RETURN QUERY EXECUTE format('
    WITH RECURSIVE class_hierarchy AS (
      SELECT
        o.id,
		o.is_abstract
      FROM
        %I.objectclass o
      WHERE
        o.id = %L
      UNION ALL
      SELECT
        p.id,
		p.is_abstract
      FROM
        %I.objectclass p
        INNER JOIN class_hierarchy h ON h.id = p.superclass_id
    )
    SELECT
      h.id
    FROM
      class_hierarchy h ' || where_clause,
	schema_name, class_id, schema_name);
END;
$$
LANGUAGE plpgsql STABLE STRICT;