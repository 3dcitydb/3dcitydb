/*****************************************************************
* CONTENT
*
* FUNCTIONS:
* cleanup_schema(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF void
* delete_feature(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_feature(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_feature(pid bigint) RETURNS BIGINT
* delete_feature(pid bigint, schema_name TEXT) RETURNS BIGINT
* terminate_feature(pid_array bigint[], metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS SETOF BIGINT
* terminate_feature(pid_array bigint[], schema_name TEXT, metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS SETOF BIGINT
* terminate_feature(pid bigint, metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS BIGINT
* terminate_feature(pid bigint, schema_name TEXT, metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS BIGINT
* delete_property_row(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_property(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_property(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_property(pid bigint) RETURNS BIGINT
* delete_property(pid bigint, schema_name TEXT) RETURNS BIGINT
* delete_geometry_data(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_geometry_data(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_geometry_data(pid bigint) RETURNS BIGINT
* delete_geometry_data(pid bigint, schema_name TEXT) RETURNS BIGINT
* delete_implicit_geometry(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_implicit_geometry(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_implicit_geometry(pid bigint) RETURNS BIGINT
* delete_implicit_geometry(pid bigint, schema_name TEXT) RETURNS BIGINT
* delete_appearance(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_appearance(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_appearance(pid bigint) RETURNS BIGINT
* delete_appearance(pid bigint, schema_name TEXT) RETURNS BIGINT
* delete_surface_data(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_surface_data(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_surface_data(pid bigint) RETURNS BIGINT
* delete_surface_data(pid bigint, schema_name TEXT) RETURNS BIGINT
* delete_tex_image(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_tex_image(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_tex_image(pid bigint) RETURNS BIGINT
* delete_tex_image(pid bigint, schema_name TEXT) RETURNS BIGINT
* delete_address(pid_array bigint[]) RETURNS SETOF BIGINT
* delete_address(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT
* delete_address(pid bigint) RETURNS BIGINT
* delete_address(pid bigint, schema_name TEXT) RETURNS BIGINT
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
CREATE OR REPLACE FUNCTION citydb_pkg.delete_feature(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  PERFORM
    citydb_pkg.delete_property_row(array_agg(p.id))
  FROM
    property p,
    unnest($1) a(a_id)
  WHERE
    p.feature_id = a.a_id;

  WITH delete_objects AS (
    DELETE FROM
      feature f
    USING
      unnest($1) a(a_id)
    WHERE
      f.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from FEATURE table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_feature(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_feature($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from FEATURE table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_feature(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_feature(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from FEATURE table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_feature(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_feature(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* terminate feature based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.terminate_feature(pid_array bigint[], metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS SETOF BIGINT AS
$body$
DECLARE
  terminated_ids bigint[] := '{}';
  child_feature_ids bigint[] := '{}';
BEGIN
  WITH terminated_objects AS (
    UPDATE
      feature f
    SET
      termination_date = COALESCE((metadata->>'termination_date')::timestamp with time zone, now()),
      last_modification_date = COALESCE((metadata->>'last_modification_date')::timestamp with time zone, now()),
      reason_for_update = COALESCE(metadata->>'reason_for_update', f.reason_for_update),
      updating_person = COALESCE(metadata->>'updating_person', USER),
      lineage = COALESCE(metadata->>'lineage', f.lineage)
    FROM
      unnest($1) a(a_id)
    WHERE
      f.id = a.a_id
    RETURNING
      f.id
  )
  SELECT
    array_agg(id)
  INTO
    terminated_ids
  FROM
    terminated_objects;

  if cascade THEN
    SELECT
      array_agg(val_feature_id)
    INTO
      child_feature_ids
    FROM
      property p, unnest(terminated_ids) a(a_id)
    WHERE
      p.feature_id = a.a_id AND val_relation_type = 1;

    IF -1 = ALL(child_feature_ids) IS NOT NULL THEN
      PERFORM
        citydb_pkg.terminate_feature(array_agg(a.a_id), metadata, cascade)
      FROM
        (SELECT DISTINCT unnest(child_feature_ids) AS a_id) a
      WHERE NOT EXISTS
      (
        SELECT
          1
        FROM
          property p
        INNER JOIN
          feature f
          ON f.id = p.feature_id
        WHERE p.val_feature_id = a.a_id AND f.termination_date IS NULL AND p.val_relation_type = 1
      );
    END IF;
  END IF;

  RETURN QUERY
    SELECT unnest(terminated_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* terminate features based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.terminate_feature(pid_array bigint[], schema_name TEXT, metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.terminate_feature(pid_array, metadata, cascade);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* terminate a feature based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.terminate_feature(pid bigint, metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.terminate_feature(ARRAY[pid], metadata, cascade);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* terminate a feature based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.terminate_feature(pid bigint, schema_name TEXT, metadata JSON DEFAULT '{}', cascade BOOLEAN DEFAULT TRUE) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.terminate_feature(ARRAY[pid], metadata, cascade);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete single row from PROPERTY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property_row(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  feature_ids bigint[] := '{}';
  geometry_ids bigint[] := '{}';
  implicit_geometry_ids bigint[] := '{}';
  appearance_ids bigint[] := '{}';
  address_ids bigint[] := '{}';
BEGIN
  WITH property_ids AS (
    DELETE FROM
      property p
    USING
      unnest($1) a(a_id)
    WHERE
      p.id = a.a_id
    RETURNING
      p.id,
      p.val_feature_id,
      p.val_relation_type,
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
  INTO
    deleted_ids,
    feature_ids,
    geometry_ids,
    implicit_geometry_ids,
    appearance_ids,
    address_ids
  FROM
    property_ids
  WHERE
    val_feature_id IS NULL OR val_relation_type = 1;

  IF -1 = ALL(feature_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_feature(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(feature_ids) AS a_id) a
    LEFT JOIN
      property p
      ON p.val_feature_id = a.a_id
    WHERE p.val_feature_id IS NULL OR p.val_relation_type IS NULL OR p.val_relation_type = 0;
  END IF;

  IF -1 = ALL(geometry_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_geometry_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(geometry_ids) AS a_id) a;
  END IF;

  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      property p
      ON p.val_implicitgeom_id = a.a_id
    WHERE p.val_implicitgeom_id IS NULL;
  END IF;

  IF -1 = ALL(appearance_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_appearance(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(appearance_ids) AS a_id) a;
  END IF;

  IF -1 = ALL(address_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_address(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(address_ids) AS a_id) a;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  property_ids bigint[] := '{}';
BEGIN
  WITH RECURSIVE child_refs AS (
    SELECT
      p.id
    FROM
      property p,
      unnest($1) a(a_id)
    WHERE
      p.id = a.a_id
    UNION ALL
    SELECT
      p.id
    FROM
      property p,
      child_refs c
    WHERE
      p.parent_id = c.id
  )
  SELECT
    array_agg(id)
  INTO
    property_ids
  FROM
    child_refs;

  RETURN QUERY
    SELECT citydb_pkg.delete_property_row(property_ids)
    INTERSECT
    SELECT unnest($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_property($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_property(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from PROPERTY table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_property(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_property(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_geometry_data(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      geometry_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_geometry_data(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_geometry_data($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_geometry_data(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_geometry_data(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from GEOMETRY_DATA table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_geometry_data(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_geometry_data(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  relative_geometry_ids bigint[] := '{}';
BEGIN
  PERFORM
    citydb_pkg.delete_appearance(array_agg(t.id))
  FROM
    appearance t,
    unnest($1) a(a_id)
  WHERE
    t.implicit_geometry_id = a.a_id;

  WITH delete_objects AS (
    DELETE FROM
      implicit_geometry t
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
  INTO
    deleted_ids,
    relative_geometry_ids
  FROM
    delete_objects;

  IF -1 = ALL(relative_geometry_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_geometry_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(relative_geometry_ids) AS a_id) a;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_implicit_geometry($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_implicit_geometry(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from IMPLICIT_GEOMETRY table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_implicit_geometry(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  surface_data_ids bigint[] := '{}';
BEGIN
  WITH surface_data_refs AS (
    DELETE FROM
      appear_to_surface_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.appearance_id = a.a_id
    RETURNING
      t.surface_data_id
  )
  SELECT
    array_agg(surface_data_id)
  INTO
    surface_data_ids
  FROM
    surface_data_refs;

  IF -1 = ALL(surface_data_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_surface_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_data_ids) AS a_id) a
    LEFT JOIN
      appear_to_surface_data atsd
      ON atsd.surface_data_id  = a.a_id
    WHERE atsd.surface_data_id IS NULL;
  END IF;

  WITH delete_objects AS (
    DELETE FROM
      appearance t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_appearance($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_appearance(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from APPEARANCE table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_appearance(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
  tex_image_ids bigint[] := '{}';
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      surface_data t
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
  INTO
    deleted_ids,
    tex_image_ids
  FROM
    delete_objects;

  IF -1 = ALL(tex_image_ids) IS NOT NULL THEN
    PERFORM
      citydb_pkg.delete_tex_image(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(tex_image_ids) AS a_id) a
    LEFT JOIN
      surface_data sd
      ON sd.tex_image_id  = a.a_id
    WHERE sd.tex_image_id IS NULL;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_surface_data($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_surface_data(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from SURFACE_DATA table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_surface_data(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      tex_image t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_tex_image($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.delete_tex_image(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from TEX_IMAGE table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.delete_tex_image(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(pid_array bigint[]) RETURNS SETOF BIGINT AS
$body$
DECLARE
  deleted_ids bigint[] := '{}';
BEGIN
  WITH delete_objects AS (
    DELETE FROM
      address t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id array and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(pid_array bigint[], schema_name TEXT) RETURNS SETOF BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN QUERY
    SELECT citydb_pkg.delete_address($1);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(pid bigint) RETURNS BIGINT AS
$body$
BEGIN
  RETURN citydb_pkg.del_address(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;

/******************************************************************
* delete from ADDRESS table based on an id and schema name
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(pid bigint, schema_name TEXT) RETURNS BIGINT AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  RETURN citydb_pkg.del_address(ARRAY[pid]);
END;
$body$
LANGUAGE plpgsql STRICT;