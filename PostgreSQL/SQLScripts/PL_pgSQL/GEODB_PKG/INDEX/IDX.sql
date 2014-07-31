-- IDX.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates utility methods for creating/droping spatial/normal indexes.
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                       | Author
-- 2.0.0     2014-07-30   new version for 3DCityDB V3         FKun
-- 1.0.0     2013-02-22   PostGIS version                     CNag
--                                                            FKun

/*****************************************************************
* CONTENT
*
* TYPE:
*   INDEX_OBJ
*
* TABLE:
*   INDEX_TABLE
*
* FUNCTIONS:
*   construct_spatial_3d(ind_name TEXT, tab_name TEXT, att_name TEXT, crs INTEGER DEFAULT 0, tab_schema_name TEXT DEFAULT 'public')
*     RETURNS geodb_pkg.INDEX_OBJ
*   construct_spatial_2d(ind_name TEXT, tab_name TEXT, att_name TEXT, crs INTEGER DEFAULT 0, tab_schema_name TEXT DEFAULT 'public')
*     RETURNS geodb_pkg.INDEX_OBJ
*   construct_normal(ind_name TEXT, tab_name TEXT, att_name TEXT, crs INTEGER DEFAULT 0, tab_schema_name TEXT DEFAULT 'public')
*     RETURNS geodb_pkg.INDEX_OBJ
*   create_index(idx geodb_pkg.INDEX_OBJ, params TEXT DEFAULT '') RETURNS TEXT
*   create_indexes(type INTEGER) RETURNS text[]
*   create_normal_indexes() RETURNS text[]
*   create_spatial_indexes() RETURNS text[]
*   drop_index(idx geodb_pkg.INDEX_OBJ) RETURNS TEXT
*   drop_indexes(type INTEGER) RETURNS text[]
*   drop_normal_indexes() RETURNS text[]
*   drop_spatial_indexes() RETURNS text[]
*   index_status(idx geodb_pkg.INDEX_OBJ) RETURNS TEXT
*   index_status(table_name TEXT, column_name TEXT, schema_name TEXT) RETURNS TEXT
*   status_normal_indexes() RETURNS text[]
*   status_spatial_indexes() RETURNS text[]
******************************************************************/

/*****************************************************************
* TYPE INDEX_OBJ
* 
* global type to store information relevant to indexes
******************************************************************/
DROP TYPE IF EXISTS geodb_pkg.INDEX_OBJ CASCADE;
CREATE TYPE geodb_pkg.INDEX_OBJ AS (
  index_name        TEXT,
  table_name        TEXT,
  attribute_name    TEXT,
  type              NUMERIC(1),
  srid              INTEGER,
  is_3d             NUMERIC(1, 0),
  schema_name       TEXT
); 

/******************************************************************
* constructors for INDEX_OBJ instances
* 
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.construct_spatial_3d(
  ind_name TEXT,
  tab_name TEXT,
  att_name TEXT,
  crs INTEGER DEFAULT 0,
  tab_schema_name TEXT DEFAULT 'public'
  ) RETURNS geodb_pkg.INDEX_OBJ AS $$
DECLARE
  idx geodb_pkg.INDEX_OBJ;
BEGIN
  idx.index_name := ind_name;
  idx.table_name := tab_name;
  idx.attribute_name := att_name;
  idx.type := 1;
  idx.srid := crs;
  idx.is_3d := 1;
  idx.schema_name := tab_schema_name;

  RETURN idx;
END; 
$$
LANGUAGE 'plpgsql' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION geodb_pkg.construct_spatial_2d(
  ind_name TEXT,
  tab_name TEXT,
  att_name TEXT,
  crs INTEGER DEFAULT 0,
  tab_schema_name TEXT DEFAULT 'public'
  ) RETURNS geodb_pkg.INDEX_OBJ AS $$
DECLARE
  idx geodb_pkg.INDEX_OBJ;
BEGIN
  idx.index_name := ind_name;   
  idx.table_name := tab_name;
  idx.attribute_name := att_name;
  idx.type := 1;
  idx.srid := crs;
  idx.is_3d := 0;
  idx.schema_name := tab_schema_name;

  RETURN idx;
END; 
$$
LANGUAGE 'plpgsql' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION geodb_pkg.construct_normal(
  ind_name TEXT,
  tab_name TEXT,
  att_name TEXT,
  crs INTEGER DEFAULT 0,
  tab_schema_name TEXT DEFAULT 'public'
  ) RETURNS geodb_pkg.INDEX_OBJ AS $$
DECLARE
  idx geodb_pkg.INDEX_OBJ;
BEGIN
  idx.index_name := ind_name;
  idx.table_name := tab_name;
  idx.attribute_name := att_name;
  idx.type := 0;
  idx.srid := crs;
  idx.is_3d := 0;
  idx.schema_name := tab_schema_name;

  RETURN idx;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE STRICT;


/******************************************************************
* INDEX_TABLE that holds INDEX_OBJ instances
* 
******************************************************************/
DROP TABLE IF EXISTS geodb_pkg.INDEX_TABLE;
CREATE TABLE geodb_pkg.INDEX_TABLE (
  ID          SERIAL PRIMARY KEY,
  obj         geodb_pkg.INDEX_OBJ,
  schemaname  TEXT
);

/******************************************************************
* Populate INDEX_TABLE with INDEX_OBJ instances
* 
******************************************************************/
INSERT INTO geodb_pkg.index_table (obj, schemaname) VALUES (geodb_pkg.construct_spatial_3d('cityobject_envelope_spx', 'cityobject', 'envelope'), 'public');
INSERT INTO geodb_pkg.index_table (obj, schemaname) VALUES (geodb_pkg.construct_spatial_3d('surface_geom_spx', 'surface_geometry', 'geometry'), 'public');
INSERT INTO geodb_pkg.index_table (obj, schemaname) VALUES (geodb_pkg.construct_normal('cityobject_inx', 'cityobject', 'gmlid'), 'public');
INSERT INTO geodb_pkg.index_table (obj, schemaname) VALUES (geodb_pkg.construct_normal('surface_geom_inx', 'surface_geometry', 'gmlid'), 'public');
INSERT INTO geodb_pkg.index_table (obj, schemaname) VALUES (geodb_pkg.construct_normal('appearance_inx', 'appearance', 'gmlid'), 'public');
INSERT INTO geodb_pkg.index_table (obj, schemaname) VALUES (geodb_pkg.construct_normal('surface_data_inx', 'surface_data', 'gmlid'), 'public');

CREATE INDEX index_table_schema_idx ON geodb_pkg.index_table (schemaname);


/*****************************************************************
* index_status
* 
* @param idx index to retrieve status from
* @return TEXT string representation of status, may include
*                  'DROPPED', 'VALID', 'INVALID', 'FAILED'
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.index_status(idx geodb_pkg.INDEX_OBJ) RETURNS TEXT AS $$
DECLARE
  is_valid BOOLEAN;
  status TEXT;
BEGIN
  EXECUTE 'SELECT DISTINCT pgi.indisvalid FROM pg_index pgi
             JOIN pg_stat_user_indexes pgsui ON pgsui.relid=pgi.indrelid
             JOIN pg_attribute pga ON pga.attrelid=pgi.indexrelid
               WHERE pgsui.schemaname=$1 AND pgsui.indexrelname=$2' 
               INTO is_valid USING idx.schema_name, idx.index_name;

  IF is_valid is null THEN
    status := 'DROPPED';
  ELSIF is_valid = true THEN
    status := 'VALID';
  ELSE
    status := 'INVALID';
  END IF;

  RETURN status;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'FAILED';
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* index_status
* 
* @param table_name table_name of index to retrieve status from
* @param column_name column_name of index to retrieve status from
* @param schema_name schema_name of index to retrieve status from
* @return TEXT string representation of status, may include
*                  'DROPPED', 'VALID', 'INVALID', 'FAILED'
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.index_status(
  table_name TEXT,
  column_name TEXT,
  schema_name TEXT DEFAULT 'public'
  ) RETURNS TEXT AS $$
DECLARE
  is_valid BOOLEAN;
  status TEXT;
BEGIN   
  EXECUTE 'SELECT DISTINCT pgi.indisvalid FROM pg_index pgi
             JOIN pg_stat_user_indexes pgsui ON pgsui.relid=pgi.indrelid
             JOIN pg_attribute pga ON pga.attrelid=pgi.indexrelid
             WHERE pgsui.schemaname=$1 AND pgsui.relname=$2 AND pga.attname=$3' 
             INTO is_valid USING lower(schema_name), lower(table_name), lower(column_name);

  IF is_valid is null THEN
    status := 'DROPPED';
  ELSIF is_valid = true THEN
    status := 'VALID';
  ELSE
    status := 'INVALID';
  END IF;

  RETURN status;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'FAILED';
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* create_index
* 
* @param idx index to create
* @param params additional parameters for the index to be created
* @return TEXT sql error code and message, 0 for no errors
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.create_index(
  idx geodb_pkg.INDEX_OBJ, 
  params TEXT DEFAULT ''
  ) RETURNS TEXT AS $$
DECLARE
  create_ddl TEXT;
  SPATIAL CONSTANT NUMERIC(1) := 1;
BEGIN
  IF geodb_pkg.index_status(idx) <> 'VALID' THEN
    PERFORM geodb_pkg.drop_index(idx);

    BEGIN
      IF idx.type = SPATIAL THEN
        create_ddl := 'CREATE INDEX ' || idx.index_name || ' ON ' || idx.schema_name || '.' || idx.table_name || ' USING GIST (' || idx.attribute_name || ' gist_geometry_ops_nd)';
      ELSE
        create_ddl := 'CREATE INDEX ' || idx.index_name || ' ON ' || idx.schema_name || '.' || idx.table_name || '(' || idx.attribute_name || ')';
      END IF;

      IF params <> '' THEN
        create_ddl := create_ddl || ' ' || params;
      END IF;

      EXECUTE create_ddl;

      EXCEPTION
        WHEN OTHERS THEN
          RETURN SQLSTATE || ' - ' || SQLERRM;
    END;
  END IF;

  RETURN '0';
END;
$$
LANGUAGE plpgsql;


/****************************************************************
* drop_index
* 
* @param idx index to drop
* @param is_versioned TRUE IF database table is version-enabled
* @return TEXT sql error code and message, 0 for no errors
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.drop_index(idx geodb_pkg.INDEX_OBJ) RETURNS TEXT AS $$
DECLARE
  index_name TEXT;
BEGIN
  IF geodb_pkg.index_status(idx) <> 'DROPPED' THEN
    BEGIN
      EXECUTE 'DROP INDEX IF EXISTS ' || idx.schema_name || '.' || idx.index_name;

      EXCEPTION
        WHEN OTHERS THEN
          RETURN SQLSTATE || ' - ' || SQLERRM;
    END;
  END IF;

  RETURN '0';
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* create_indexes
* private convenience method for invoking create_index on indexes 
* of same index type
* 
* @param idx_type type of index, e.g. 1 for spatial, 0 for normal
* @param schema_name target schema for indexes to be created
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.create_indexes(
  idx_type INTEGER, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  sql_error_msg TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM geodb_pkg.index_table WHERE schemaname = $2 LOOP
    IF (rec.obj).type = $1 THEN
      sql_error_msg := geodb_pkg.create_index(rec.obj);
      log := array_append(log, geodb_pkg.index_status(rec.obj) || ':' || (rec.obj).index_name || ':' || (rec.obj).schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name || ':' || sql_error_msg);
    END IF;
  END LOOP;

  RETURN log;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* drop_indexes
* private convenience method for invoking drop_index on indexes 
* of same index type
* 
* @param idx_type type of index, e.g. 1 for spatial, 0 for normal
* @param schema_name target schema for indexes to be dropped
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.drop_indexes(
  idx_type INTEGER, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  sql_error_msg TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM geodb_pkg.index_table WHERE schemaname = $2 LOOP
    IF (rec.obj).type = $1 THEN
      sql_error_msg := geodb_pkg.drop_index(rec.obj);
      log := array_append(log, geodb_pkg.index_status(rec.obj) || ':' || (rec.obj).index_name || ':' || (rec.obj).schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name || ':' || sql_error_msg);
    END IF;
  END LOOP;

  RETURN log;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* status_spatial_indexes
* 
* @param schema_name target schema of indexes to retrieve status from
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.status_spatial_indexes(schema_name TEXT DEFAULT 'public') RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  status TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM geodb_pkg.index_table WHERE schemaname = $1 LOOP
    IF (rec.obj).type = 1 THEN
      status := geodb_pkg.index_status(rec.obj);
      log := array_append(log, status || ':' || (rec.obj).index_name || ':' || (rec.obj).schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name);
    END IF;
  END LOOP;   

  RETURN log;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* status_normal_indexes
* 
* @param schema_name target schema of indexes to retrieve status from
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.status_normal_indexes(schema_name TEXT DEFAULT 'public') RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  status TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM geodb_pkg.index_table WHERE schemaname = $1 LOOP
    IF (rec.obj).type = 0 THEN
      status := geodb_pkg.index_status(rec.obj);
      log := array_append(log, status || ':' || (rec.obj).index_name || ':' || (rec.obj).schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name);
    END IF;
  END LOOP;

  RETURN log;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* create_spatial_indexes
* convenience method for invoking create_index on all spatial indexes 
* 
* @param schema_name target schema for indexes to be created
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.create_spatial_indexes(schema_name TEXT DEFAULT 'public') RETURNS text[] AS $$
BEGIN
  RETURN geodb_pkg.create_indexes(1, $1);
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* drop_spatial_indexes
* convenience method for invoking drop_index on all spatial indexes 
* 
* @param schema_name target schema for indexes to be dropped
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.drop_spatial_indexes(schema_name TEXT DEFAULT 'public') RETURNS text[] AS $$
BEGIN
  RETURN geodb_pkg.drop_indexes(1, $1);
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* create_normal_indexes
* convenience method for invoking create_index on all normal indexes 
* 
* @param schema_name target schema for indexes to be created
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.create_normal_indexes(schema_name TEXT  DEFAULT 'public') RETURNS text[] AS $$
BEGIN
  RETURN geodb_pkg.create_indexes(0, $1);
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* drop_normal_indexes
* convenience method for invoking drop_index on all normal indexes 
* 
* @param schema_name target schema for indexes to be dropped
* @return ARRAY array of log message strings
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.drop_normal_indexes(schema_name TEXT DEFAULT 'public') RETURNS text[] AS $$
BEGIN
  RETURN geodb_pkg.drop_indexes(0, $1);
END; 
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_index
* convenience method for getting an index object 
* given the schema.table and column it indexes
* 
* @param tab_name
* @param column_name
* @param tab_schema_name
* @return INDEX_OBJ
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.get_index(
  tab_name TEXT, 
  column_name TEXT,
  tab_schema_name TEXT DEFAULT 'public'
  ) RETURNS geodb_pkg.INDEX_OBJ AS $$
DECLARE
  idx geodb_pkg.INDEX_OBJ;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM geodb_pkg.index_table WHERE schemaname = $3 LOOP
    IF (rec.obj).table_name = $1 AND (rec.obj).attribute_name = $2 AND (rec.obj).schema_name = $3 THEN
      idx := rec.obj;
    END IF;
  END LOOP;

  RETURN idx;
END;
$$
LANGUAGE plpgsql;