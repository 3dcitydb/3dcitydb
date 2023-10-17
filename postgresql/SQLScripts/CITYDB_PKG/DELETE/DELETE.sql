/*****************************************************************
* CONTENT
*
* FUNCTIONS:
* cleanup_schema(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF void
* delete_feature(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_feature(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_property(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_property(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_geometry_data(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_geometry_data(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_implicit_geometry(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_implicit_geometry(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_appearance(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_appearance(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_surface_data(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_surface_data(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_tex_image(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_tex_image(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
* delete_address(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT
* delete_address(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT
******************************************************************/

/******************************************************************
* truncates all data tables
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF void AS
$body$
DECLARE
rec RECORD;
BEGIN
FOR rec IN
SELECT table_name FROM information_schema.tables where table_schema = schema_name
        AND table_name <> 'ade'
        AND table_name <> 'datatype'
        AND table_name <> 'database_srs'
        AND table_name <> 'aggregation_info'
        AND table_name <> 'codelist'
        AND table_name <> 'codelist_entry'
        AND table_name <> 'namespace'
        AND table_name <> 'objectclass'
  LOOP
    EXECUTE format('TRUNCATE TABLE %I.%I CASCADE', schema_name, rec.table_name);
END LOOP;

FOR rec IN
SELECT sequence_name FROM information_schema.sequences where sequence_schema = schema_name
        AND sequence_name <> 'ade_seq'
  LOOP
    EXECUTE format('ALTER SEQUENCE %I.%I RESTART', schema_name, rec.sequence_name);
END LOOP;
END;
$body$
LANGUAGE plpgsql;

/******************************************************************
* delete from FEATURE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_feature(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  EXECUTE format('SELECT
    citydb_pkg.delete_property(array_agg(p.id), $1)
  FROM
    %I.property p,
    unnest($2) a(a_id)
  WHERE
    p.feature_id = a.a_id', schema_name) USING schema_name, pid_array;

  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.feature f
    USING
      unnest($1) a(a_id)
    WHERE
      f.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  FROM
    delete_objects', schema_name) INTO deleted_ids USING pid_array;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from FEATURE table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_feature(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_feature(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  feature_ids bigint[] := '{}';
  geometry_ids bigint[] := '{}';
  implicit_geometry_ids bigint[] := '{}';
  appearance_ids bigint[] := '{}';
  address_ids bigint[] := '{}';
BEGIN
  EXECUTE format('WITH child_refs AS (
    DELETE FROM
      %I.property p
    USING
      unnest($1) a(a_id)
    WHERE
      p.root_id = a.a_id
    RETURNING
      p.id,
      p.val_feature_id,
      p.val_geometry_id,
      p.val_implicitgeom_id,
      p.val_appearance_id,
      p.val_address_id
  )
  SELECT
    array_agg(id),
    array_agg(val_feature_id),
    array_agg(val_geometry_id),
    array_agg(val_implicitgeom_id),
    array_agg(val_appearance_id),
    array_agg(val_address_id)
  FROM
    child_refs', schema_name) INTO deleted_ids, feature_ids, geometry_ids, implicit_geometry_ids, appearance_ids, address_ids USING pid_array;

  IF -1 = ALL(feature_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_feature(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a
    LEFT JOIN
      %I.property p
      ON p.val_feature_id  = a.a_id
    WHERE p.val_feature_id IS NULL AND (p.VAL_REFERENCE_TYPE IS NULL OR p.VAL_REFERENCE_TYPE <> 2)', schema_name) USING schema_name, feature_ids;
  END IF;

  IF -1 = ALL(geometry_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_geometry_data(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a') USING schema_name, geometry_ids;
  END IF;

  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_implicit_geometry(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a') USING schema_name, implicit_geometry_ids;
  END IF;

  IF -1 = ALL(appearance_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_appearance(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a') USING schema_name, appearance_ids;
  END IF;

  IF -1 = ALL(address_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_address(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a') USING schema_name, address_ids;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_property(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_geometry_data(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.geometry_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  FROM
    delete_objects', schema_name) INTO deleted_ids USING pid_array;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_geometry_data(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_geometry_data(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  relative_geometry_ids bigint[] := '{}';
BEGIN
  EXECUTE format('SELECT
    citydb_pkg.delete_appearance(array_agg(t.id), $1)
  FROM
    %I.appearance t,
    unnest($2) a(a_id)
  WHERE
    t.implicit_geometry_id = a.a_id', schema_name) USING schema_name, pid_array;

  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.implicit_geometry t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      relative_geometry_id
  )
  SELECT
    array_agg(id),
    array_agg(relative_geometry_id)
  FROM
    delete_objects', schema_name) INTO deleted_ids, relative_geometry_ids USING pid_array;

  IF -1 = ALL(relative_geometry_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_geometry_data(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a') USING schema_name, relative_geometry_ids;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_implicit_geometry(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  surface_data_ids bigint[] := '{}';
BEGIN
  EXECUTE format('WITH surface_data_refs AS (
    DELETE FROM
      %I.appear_to_surface_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.appearance_id = a.a_id
    RETURNING
      t.surface_data_id
  )
  SELECT
    array_agg(surface_data_id)
  FROM
    surface_data_refs', schema_name) INTO surface_data_ids USING pid_array;

  IF -1 = ALL(surface_data_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_surface_data(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a
    LEFT JOIN
      %I.appear_to_surface_data a2sd
      ON a2sd.surface_data_id  = a.a_id
    WHERE a2sd.surface_data_id IS NULL', schema_name) using schema_name, surface_data_ids;
  END IF;

  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.appearance t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  FROM
    delete_objects', schema_name) INTO deleted_ids USING pid_array;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_appearance(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  tex_image_ids bigint[] := '{}';
BEGIN
  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.surface_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      tex_image_id
  )
  SELECT
    array_agg(id),
    array_agg(tex_image_id)
  FROM
    delete_objects', schema_name) INTO deleted_ids, tex_image_ids USING pid_array;

  IF -1 = ALL(tex_image_ids) IS NOT NULL THEN
    EXECUTE format('SELECT
      citydb_pkg.delete_tex_image(array_agg(a.a_id), $1)
    FROM
      (SELECT DISTINCT unnest($2) AS a_id) a
    LEFT JOIN
      %I.surface_data sd
      ON sd.tex_image_id  = a.a_id
    WHERE sd.tex_image_id IS NULL', schema_name) USING schema_name, tex_image_ids;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_surface_data(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.tex_image t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  FROM
    delete_objects', schema_name) INTO deleted_ids USING pid_array;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.delete_tex_image(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(pid_array bigint[], schema_name TEXT DEFAULT 'citydb') RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  EXECUTE format('WITH delete_objects AS (
    DELETE FROM
      %I.address t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  FROM
    delete_objects', schema_name) INTO deleted_ids USING pid_array;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(pid bigint, schema_name TEXT DEFAULT 'citydb') RETURNS BIGINT AS
$body$
DECLARE
  deleted_id bigint;
BEGIN
  deleted_id := citydb_pkg.del_address(ARRAY[pid], schema_name);
  RETURN deleted_id;
END;
$body$
LANGUAGE plpgsql STRICT;


