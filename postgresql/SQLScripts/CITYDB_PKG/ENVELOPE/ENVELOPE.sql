/*****************************************************************
* CONTENT
*
* FUNCTIONS:
* get_feature_envelope(fid BIGINT, set_envelope INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY
* box2envelope(box BOX3D, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY
* update_bounds(old_bbox GEOMETRY, new_bbox GEOMETRY, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY
* calc_implicit_geometry_envelope(gid BIGINT, ref_pt GEOMETRY, matrix VARCHAR, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY
******************************************************************/

/*****************************************************************
* returns the envelope geometry of a given feature
* if the parameter set_envelope = 1 (default = 0), the ENVELOPE column of the FEATURE table will be updated
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_feature_envelope(fid BIGINT, set_envelope INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
DECLARE
  bbox GEOMETRY;
  bbox_tmp GEOMETRY;
  rec RECORD;
BEGIN
  EXECUTE format('set search_path to %I', schema_name);

  FOR rec IN
    SELECT
      p.val_feature_id
    FROM
      property p
    WHERE
      p.id = fid AND p.val_feature_id IS NOT NULL AND p.val_reference_type <> 2
  LOOP
    bbox_tmp := citydb_pkg.get_feature_envelope(rec.id::bigint, set_envelope, schema_name);
    bbox := citydb_pkg.update_bounds(bbox, bbox_tmp, schema_name);
  END LOOP;    

  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom), schema_name) INTO bbox_tmp FROM (
    SELECT
      gd.geometry AS geom
    FROM
      geometry_data gd, property p
    WHERE gd.id = p.val_geometry_id AND p.feature_id = fid AND gd.geometry IS NOT NULL
    UNION ALL
    SELECT
      citydb_pkg.calc_implicit_geometry_envelope(val_implicitgeom_id, val_implicitgeom_refpoint, val_array, schema_name) AS geom
    FROM
      property p
    WHERE p.feature_id = fid AND p.val_implicitgeom_id IS NOT NULL
  ) g;
  bbox := citydb_pkg.update_bounds(bbox, bbox_tmp, schema_name);

  IF set_envelope <> 0 THEN
    UPDATE feature SET envelope = bbox WHERE id = fid;
  END IF;
  
  RETURN bbox;
END;
$body$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* returns the envelope geometry of a given
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.box2envelope(box BOX3D, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  db_srid INTEGER;
BEGIN
  EXECUTE format('set search_path to %I', schema_name);

  IF ST_SRID(box) = 0 THEN
    SELECT srid INTO db_srid FROM database_srs;
  ELSE
    db_srid := ST_SRID(box);
  END IF;

  SELECT ST_SetSRID(ST_MakePolygon(ST_MakeLine(
    ARRAY[
      ST_MakePoint(ST_XMin(box), ST_YMin(box), ST_ZMin(box)),
      ST_MakePoint(ST_XMax(box), ST_YMin(box), ST_ZMin(box)),
      ST_MakePoint(ST_XMax(box), ST_YMax(box), ST_ZMax(box)),
      ST_MakePoint(ST_XMin(box), ST_YMax(box), ST_ZMax(box)),
      ST_MakePoint(ST_XMin(box), ST_YMin(box), ST_ZMin(box))
    ]
  )), db_srid) INTO envelope;

  RETURN envelope;
END;
$body$
LANGUAGE plpgsql STABLE STRICT;

/*****************************************************************
* returns the envelope geometry of two bounding boxes
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.update_bounds(old_bbox GEOMETRY, new_bbox GEOMETRY, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
BEGIN
  EXECUTE format('set search_path to %I', schema_name);

  IF old_bbox IS NULL AND new_bbox IS NULL THEN
    RETURN NULL;
  ELSE
    IF old_bbox IS NULL THEN
      RETURN new_bbox;
    END IF;

    IF new_bbox IS NULL THEN
      RETURN old_bbox;
    END IF;

    RETURN citydb_pkg.box2envelope(ST_3DExtent(ST_Collect(old_bbox, new_bbox)), schema_name);
  END IF;
END;
$body$
LANGUAGE plpgsql STABLE;

/*****************************************************************
* returns the envelope geometry of a given implicit geometry
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.calc_implicit_geometry_envelope(gid BIGINT, ref_pt GEOMETRY, matrix JSON, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  params DOUBLE PRECISION[ ] := '{}';
BEGIN
  EXECUTE format('set search_path to %I', schema_name);

  SELECT ST_3DExtent(gd.implicit_geometry) INTO envelope
    FROM geometry_data gd, implicit_geometry ig
      WHERE gd.id = ig.relative_geometry_id
        AND ig.id = gid
        AND gd.implicit_geometry IS NOT NULL;

  IF matrix IS NOT NULL THEN
    params := ARRAY(SELECT json_array_elements_text(matrix):float8[];
    IF array_length(params, 1) < 12 THEN
      RAISE EXCEPTION 'Malformed transformation matrix: %', matrix USING HINT = '16 values are required';
    END IF;
  ELSE
    params := '{
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1}';
  END IF;

  IF ref_pt IS NOT NULL THEN
    params[4] := params[4] + ST_X(ref_pt);
    params[8] := params[8] + ST_Y(ref_pt);
    params[12] := params[12] + ST_Z(ref_pt);
  END IF;

  IF envelope IS NOT NULL THEN
    envelope := ST_Affine(envelope,
      params[1], params[2], params[3],
      params[5], params[6], params[7],
      params[9], params[10], params[11],
      params[4], params[8], params[12]);
  END IF;

  RETURN envelope;
END;
$body$
LANGUAGE plpgsql STABLE;
------------------------------------------