-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
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
* TYPE:
*   INDEX_OBJ
*
* TABLE:
*   INDEX_TABLE
*
* FUNCTIONS:
*   construct_spatial_3d(ind_name TEXT, tab_name TEXT, att_name TEXT, crs INTEGER DEFAULT 0)
*     RETURNS citydb_pkg.INDEX_OBJ
*   construct_spatial_2d(ind_name TEXT, tab_name TEXT, att_name TEXT, crs INTEGER DEFAULT 0)
*     RETURNS citydb_pkg.INDEX_OBJ
*   construct_normal(ind_name TEXT, tab_name TEXT, att_name TEXT, crs INTEGER DEFAULT 0)
*     RETURNS citydb_pkg.INDEX_OBJ
*   create_index(idx citydb_pkg.INDEX_OBJ, schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
*   create_indexes(type INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   create_normal_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   create_spatial_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   drop_index(idx citydb_pkg.INDEX_OBJ, schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
*   drop_indexes(type INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   drop_normal_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   drop_spatial_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   index_status(idx citydb_pkg.INDEX_OBJ, schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
*   index_status(table_name TEXT, column_name TEXT, schema_name TEXT) RETURNS TEXT
*   status_normal_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[]
*   status_spatial_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[]
******************************************************************/

/*****************************************************************
* TYPE INDEX_OBJ
* 
* global type to store information relevant to indexes
******************************************************************/
DROP TYPE IF EXISTS citydb_pkg.INDEX_OBJ CASCADE;
CREATE TYPE citydb_pkg.INDEX_OBJ AS (
  index_name        TEXT,
  table_name        TEXT,
  attribute_name    TEXT,
  type              NUMERIC(1),
  srid              INTEGER,
  is_3d             NUMERIC(1, 0)
); 

/******************************************************************
* constructors for INDEX_OBJ instances
* 
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.construct_spatial_3d(
  ind_name TEXT,
  tab_name TEXT,
  att_name TEXT,
  crs INTEGER DEFAULT 0
  ) RETURNS citydb_pkg.INDEX_OBJ AS $$
DECLARE
  idx citydb_pkg.INDEX_OBJ;
BEGIN
  idx.index_name := ind_name;
  idx.table_name := tab_name;
  idx.attribute_name := att_name;
  idx.type := 1;
  idx.srid := crs;
  idx.is_3d := 1;

  RETURN idx;
END; 
$$
LANGUAGE 'plpgsql' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION citydb_pkg.construct_spatial_2d(
  ind_name TEXT,
  tab_name TEXT,
  att_name TEXT,
  crs INTEGER DEFAULT 0
  ) RETURNS citydb_pkg.INDEX_OBJ AS $$
DECLARE
  idx citydb_pkg.INDEX_OBJ;
BEGIN
  idx.index_name := ind_name;   
  idx.table_name := tab_name;
  idx.attribute_name := att_name;
  idx.type := 1;
  idx.srid := crs;
  idx.is_3d := 0;

  RETURN idx;
END; 
$$
LANGUAGE 'plpgsql' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION citydb_pkg.construct_normal(
  ind_name TEXT,
  tab_name TEXT,
  att_name TEXT,
  crs INTEGER DEFAULT 0
  ) RETURNS citydb_pkg.INDEX_OBJ AS $$
DECLARE
  idx citydb_pkg.INDEX_OBJ;
BEGIN
  idx.index_name := ind_name;
  idx.table_name := tab_name;
  idx.attribute_name := att_name;
  idx.type := 0;
  idx.srid := crs;
  idx.is_3d := 0;

  RETURN idx;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE STRICT;


/******************************************************************
* INDEX_TABLE that holds INDEX_OBJ instances
* 
******************************************************************/
DROP TABLE IF EXISTS citydb_pkg.INDEX_TABLE;
CREATE TABLE citydb_pkg.INDEX_TABLE (
  ID          SERIAL PRIMARY KEY,
  obj         citydb_pkg.INDEX_OBJ
);


/******************************************************************
* Populate INDEX_TABLE with INDEX_OBJ instances
* 
******************************************************************/
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_spatial_2d('cityobject_envelope_spx', 'cityobject', 'envelope'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_spatial_2d('surface_geom_spx', 'surface_geometry', 'geometry'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_spatial_2d('surface_geom_solid_spx', 'surface_geometry', 'solid_geometry'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('cityobject_inx', 'cityobject', 'gmlid, gmlid_codespace'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('cityobject_lineage_inx', 'cityobject', 'lineage'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('surface_geom_inx', 'surface_geometry', 'gmlid, gmlid_codespace'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('appearance_inx', 'appearance', 'gmlid, gmlid_codespace'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('appearance_theme_inx', 'appearance', 'theme'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('surface_data_inx', 'surface_data', 'gmlid, gmlid_codespace'));
INSERT INTO citydb_pkg.index_table (obj) VALUES (citydb_pkg.construct_normal('address_inx', 'address', 'gmlid, gmlid_codespace'));


/*****************************************************************
* index_status
* 
* @param idx index to retrieve status from
* @param schema_name target schema to retrieve index status from
* @return TEXT string representation of status, may include
*                  'DROPPED', 'VALID', 'INVALID', 'FAILED'
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.index_status(
  idx citydb_pkg.INDEX_OBJ,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS $$
DECLARE
  is_valid BOOLEAN;
  status TEXT;
BEGIN
  EXECUTE 'SELECT DISTINCT pgi.indisvalid FROM pg_index pgi
             JOIN pg_stat_user_indexes pgsui ON pgsui.relid=pgi.indrelid
             JOIN pg_attribute pga ON pga.attrelid=pgi.indexrelid
               WHERE pgsui.schemaname=$1 AND pgsui.indexrelname=$2' 
               INTO is_valid USING schema_name, idx.index_name;

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
CREATE OR REPLACE FUNCTION citydb_pkg.index_status(
  table_name TEXT,
  column_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
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
* @param schema_name target schema where to create index
* @return TEXT sql error code and message, 0 for no errors
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.create_index(
  idx citydb_pkg.INDEX_OBJ, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS $$
DECLARE
  create_ddl TEXT;
  SPATIAL CONSTANT NUMERIC(1) := 1;
BEGIN
  IF citydb_pkg.index_status(idx, schema_name) <> 'VALID' THEN
    PERFORM citydb_pkg.drop_index(idx, schema_name);

    BEGIN
      IF idx.type = SPATIAL THEN
        IF idx.is_3d = 1 THEN
          EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I gist_geometry_ops_nd)',
                            idx.index_name, schema_name, idx.table_name, idx.attribute_name);
        ELSE
          EXECUTE format('CREATE INDEX %I ON %I.%I USING GIST (%I gist_geometry_ops_2d)',
                            idx.index_name, schema_name, idx.table_name, idx.attribute_name);
        END IF;
      ELSE
        EXECUTE format('CREATE INDEX %I ON %I.%I USING BTREE (%I)',
                          idx.index_name, schema_name, idx.table_name, idx.attribute_name);
      END IF;

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
* @param schema_name target schema where to drop index
* @return TEXT sql error code and message, 0 for no errors
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.drop_index(
	idx citydb_pkg.INDEX_OBJ,
	schema_name TEXT DEFAULT 'citydb'
	) RETURNS TEXT AS $$
DECLARE
  index_name TEXT;
BEGIN
  IF citydb_pkg.index_status(idx, schema_name) <> 'DROPPED' THEN
    BEGIN
      EXECUTE format('DROP INDEX IF EXISTS %I.%I', schema_name, idx.index_name);

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
CREATE OR REPLACE FUNCTION citydb_pkg.create_indexes(
  idx_type INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  sql_error_msg TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM citydb_pkg.index_table LOOP
    IF (rec.obj).type = idx_type THEN
      sql_error_msg := citydb_pkg.create_index(rec.obj, schema_name);
      log := array_append(log, citydb_pkg.index_status(rec.obj, schema_name) || ':' || (rec.obj).index_name || ':' || schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name || ':' || sql_error_msg);
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
CREATE OR REPLACE FUNCTION citydb_pkg.drop_indexes(
  idx_type INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  sql_error_msg TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM citydb_pkg.index_table LOOP
    IF (rec.obj).type = idx_type THEN
      sql_error_msg := citydb_pkg.drop_index(rec.obj, schema_name);
      log := array_append(log, citydb_pkg.index_status(rec.obj, schema_name) || ':' || (rec.obj).index_name || ':' || schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name || ':' || sql_error_msg);
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
CREATE OR REPLACE FUNCTION citydb_pkg.status_spatial_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  status TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM citydb_pkg.index_table LOOP
    IF (rec.obj).type = 1 THEN
      status := citydb_pkg.index_status(rec.obj, schema_name);
      log := array_append(log, status || ':' || (rec.obj).index_name || ':' || schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name);
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
CREATE OR REPLACE FUNCTION citydb_pkg.status_normal_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[] AS $$
DECLARE
  log text[] := '{}';
  status TEXT;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM citydb_pkg.index_table LOOP
    IF (rec.obj).type = 0 THEN
      status := citydb_pkg.index_status(rec.obj, schema_name);
      log := array_append(log, status || ':' || (rec.obj).index_name || ':' || schema_name || ':' || (rec.obj).table_name || ':' || (rec.obj).attribute_name);
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
CREATE OR REPLACE FUNCTION citydb_pkg.create_spatial_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[] AS $$
BEGIN
  RETURN citydb_pkg.create_indexes(1, schema_name);
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
CREATE OR REPLACE FUNCTION citydb_pkg.drop_spatial_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[] AS $$
BEGIN
  RETURN citydb_pkg.drop_indexes(1, schema_name);
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
CREATE OR REPLACE FUNCTION citydb_pkg.create_normal_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[] AS $$
BEGIN
  RETURN citydb_pkg.create_indexes(0, schema_name);
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
CREATE OR REPLACE FUNCTION citydb_pkg.drop_normal_indexes(schema_name TEXT DEFAULT 'citydb') RETURNS text[] AS $$
BEGIN
  RETURN citydb_pkg.drop_indexes(0, schema_name);
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
* @return INDEX_OBJ
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_index(
  tab_name TEXT, 
  column_name TEXT
  ) RETURNS citydb_pkg.INDEX_OBJ AS $$
DECLARE
  idx citydb_pkg.INDEX_OBJ;
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM citydb_pkg.index_table LOOP
    IF (rec.obj).table_name = tab_name AND (rec.obj).attribute_name = column_name THEN
      idx := rec.obj;
    END IF;
  END LOOP;

  RETURN idx;
END;
$$
LANGUAGE plpgsql;