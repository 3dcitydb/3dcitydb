/*****************************************************************
* CONTENT
*
* FUNCTIONS:
* citydb.get_feature_envelope(fid BIGINT, set_envelope INTEGER DEFAULT 0) RETURNS GEOMETRY
* citydb.box2envelope(box BOX3D) RETURNS GEOMETRY
* citydb.update_bounds(old_bbox GEOMETRY, new_bbox GEOMETRY) RETURNS GEOMETRY
* citydb.calc_implicit_geometry_envelope(gid BIGINT, ref_pt GEOMETRY, matrix VARCHAR) RETURNS GEOMETRY
******************************************************************/

/*****************************************************************
* returns the envelope geometry of a given feature
* if the parameter set_envelope = 1 (default = 0), the ENVELOPE column of the FEATURE table will be updated
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.get_feature_envelope(fid BIGINT, set_envelope INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  bbox GEOMETRY;
  bbox_tmp GEOMETRY;
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT
      p.val_feature_id
    FROM
      citydb.property p
    WHERE
      p.id = fid AND p.val_feature_id IS NOT NULL AND p.val_reference_type <> 2
  LOOP
    bbox_tmp := citydb.get_feature_envelope(rec.id::bigint, set_envelope);
    bbox := citydb.update_bounds(bbox, bbox_tmp);    
  END LOOP;    

  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox_tmp FROM (
    SELECT
      gd.geometry AS geom
    FROM
      citydb.geometry_data gd, citydb.property p
    WHERE gd.id = p.val_geometry_id AND p.feature_id = fid AND gd.geometry IS NOT NULL
    UNION ALL
    SELECT
      citydb.calc_implicit_geometry_envelope(val_implicitgeom_id, val_implicitgeom_refpoint, val_implicitgeom_transform) AS geom
    FROM
      citydb.property p
    WHERE p.feature_id = fid AND p.val_implicitgeom_id IS NOT NULL
  ) g;
  bbox := citydb.update_bounds(bbox, bbox_tmp);

  IF set_envelope <> 0 THEN
    UPDATE citydb.feature SET envelope = bbox WHERE id = fid;
  END IF;
  
  RETURN bbox;
END;
$body$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* returns the envelope geometry of a given
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.box2envelope(box BOX3D) RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  db_srid INTEGER;
BEGIN
  IF ST_SRID(box) = 0 THEN
    SELECT srid INTO db_srid FROM citydb.database_srs;
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
CREATE OR REPLACE FUNCTION citydb.update_bounds(old_bbox GEOMETRY, new_bbox GEOMETRY) RETURNS GEOMETRY AS
$body$
BEGIN
  IF old_bbox IS NULL AND new_bbox IS NULL THEN
    RETURN NULL;
  ELSE
    IF old_bbox IS NULL THEN
      RETURN new_bbox;
    END IF;

    IF new_bbox IS NULL THEN
      RETURN old_bbox;
    END IF;

    RETURN citydb.box2envelope(ST_3DExtent(ST_Collect(old_bbox, new_bbox)));
  END IF;
END;
$body$
LANGUAGE plpgsql STABLE;

/*****************************************************************
* returns the envelope geometry of a given implicit geometry
******************************************************************/
CREATE OR REPLACE FUNCTION citydb.calc_implicit_geometry_envelope(gid BIGINT, ref_pt GEOMETRY, matrix VARCHAR) RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  params DOUBLE PRECISION[ ] := '{}';
BEGIN
  SELECT ST_3DExtent(gd.implicit_geometry) INTO envelope
    FROM citydb.geometry_data gd, citydb.implicit_geometry ig
      WHERE gd.id = ig.relative_geometry_id
        AND ig.id = gid
        AND gd.implicit_geometry IS NOT NULL;

  IF matrix IS NOT NULL THEN
    params := string_to_array(matrix, ' ')::float8[];
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