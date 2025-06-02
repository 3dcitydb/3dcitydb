/*****************************************************************
* Returns the envelope geometry of a given feature
*
* @param compute_envelope If 0 (default), returns the envelope from the ENVELOPE column unless it is NULL, in which case the envelope is computed. If 1, the envelope is always computed.
* @param set_envelope If 1 (default = 0), the ENVELOPE column of the FEATURE table will be updated with the computed envelope.
* @param schema_name Name of schema
* @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_feature_envelope(
  fid BIGINT,
  compute_envelope INTEGER DEFAULT 0,
  set_envelope INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
DECLARE
  bbox GEOMETRY;
  bbox_tmp GEOMETRY;
  rec RECORD;
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);
  
  IF compute_envelope = 0 THEN
    SELECT envelope INTO bbox FROM feature WHERE id = fid;
	IF bbox IS NOT NULL THEN
	  RETURN bbox;
	END IF;
  END IF;

  FOR rec IN
    SELECT
      p.val_feature_id
    FROM
      property p
    WHERE
      p.feature_id = fid
	  AND p.val_feature_id IS NOT NULL
	  AND p.val_relation_type = 1
  LOOP
    bbox_tmp := citydb_pkg.get_feature_envelope(rec.val_feature_id, compute_envelope, set_envelope, schema_name);
    bbox := citydb_pkg.get_envelope(bbox, bbox_tmp, schema_name);
  END LOOP;    

  SELECT citydb_pkg.get_envelope(ST_Collect(geom), schema_name) INTO bbox_tmp FROM (
    SELECT
      gd.geometry AS geom
    FROM
      geometry_data gd
    WHERE
	  gd.feature_id = fid
	  AND gd.geometry IS NOT NULL
    UNION ALL
    SELECT
      citydb_pkg.get_implicit_geometry_envelope(p.val_implicitgeom_id,
	    p.val_implicitgeom_refpoint, p.val_array, schema_name) AS geom
    FROM
      property p
    WHERE
	  p.feature_id = fid
	  AND p.val_implicitgeom_id IS NOT NULL
  ) g;
  
  bbox := citydb_pkg.get_envelope(bbox, bbox_tmp, schema_name);

  IF set_envelope <> 0 THEN
    UPDATE feature SET envelope = bbox WHERE id = fid;
  END IF;
  
  RETURN bbox;
END;
$body$
LANGUAGE plpgsql;

/*****************************************************************
* Returns the envelope geometry of a given implicit geometry
*
* @param gid ID of the entry in the IMPLICIT_GEOMETRY table
* @param ref_pt Reference point provided as POINT geometry
* @param matrix Transformation matrix represented as JSON array of double values
* @param schema_name Name of schema
* @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_implicit_geometry_envelope(
  gid BIGINT,
  ref_pt GEOMETRY,
  matrix JSON,
  schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  params DOUBLE PRECISION[] := '{}';
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  SELECT
    citydb_pkg.get_envelope(gd.implicit_geometry, schema_name) INTO envelope
  FROM
    implicit_geometry ig, geometry_data gd
  WHERE
    ig.id = gid
    AND gd.id = ig.relative_geometry_id
    AND gd.implicit_geometry IS NOT NULL;

  IF matrix IS NOT NULL THEN
    params := ARRAY(SELECT json_array_elements_text(matrix))::float8[];
    IF array_length(params, 1) < 12 THEN
      RAISE EXCEPTION 'Invalid transformation matrix: %', matrix USING HINT = '12 elements are required';
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
    RETURN ST_Affine(envelope,
      params[1], params[2], params[3],
      params[5], params[6], params[7],
      params[9], params[10], params[11],
      params[4], params[8], params[12]);
  ELSIF ref_pt IS NOT NULL THEN
    RETURN citydb_pkg.get_envelope(ST_MakePoint(params[4], params[8], params[12]), schema_name);
  ELSE
    RETURN NULL;
  END IF;
END;
$body$
LANGUAGE plpgsql;

/*****************************************************************
* Returns the envelope geometry for a given geometry
*
* @param geom The GEOMETRY for which the envelope is computed
* @param schema_name Name of schema
* @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope(geom GEOMETRY, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
BEGIN
  RETURN citydb_pkg.get_envelope(ST_3DExtent(geom), schema_name);
END;
$body$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* Returns the envelope geometry for a given box3d
*
* @param bbox The BOX3D geometry for which the envelope is computed
* @param schema_name Name of schema
* @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope(bbox BOX3D, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  db_srid INTEGER;
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  IF ST_SRID(bbox) = 0 THEN
    SELECT srid INTO db_srid FROM database_srs;
  ELSE
    db_srid := ST_SRID(bbox);
  END IF;

  SELECT ST_SetSRID(ST_MakePolygon(ST_MakeLine(
    ARRAY[
      ST_MakePoint(ST_XMin(bbox), ST_YMin(bbox), ST_ZMin(bbox)),
      ST_MakePoint(ST_XMax(bbox), ST_YMin(bbox), ST_ZMin(bbox)),
      ST_MakePoint(ST_XMax(bbox), ST_YMax(bbox), ST_ZMax(bbox)),
      ST_MakePoint(ST_XMin(bbox), ST_YMax(bbox), ST_ZMax(bbox)),
      ST_MakePoint(ST_XMin(bbox), ST_YMin(bbox), ST_ZMin(bbox))
    ]
  )), db_srid) INTO envelope;

  RETURN envelope;
END;
$body$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* Returns the envelope geometry of two geometries
*
* @param geom1, geom2 The input geometries for which the envelope is computed
* @param schema_name Name of schema
* @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope(geom1 GEOMETRY, geom2 GEOMETRY, schema_name TEXT DEFAULT 'citydb') RETURNS GEOMETRY AS
$body$
BEGIN
  EXECUTE format('set search_path to %I, public', schema_name);

  IF geom1 IS NOT NULL AND geom2 IS NOT NULL THEN
    RETURN citydb_pkg.get_envelope(ST_Collect(geom1, geom2), schema_name);
  ELSIF geom1 IS NOT NULL THEN
    RETURN citydb_pkg.get_envelope(geom1);
  ELSIF geom2 IS NOT NULL THEN
    RETURN citydb_pkg.get_envelope(geom2);
  ELSE
    RETURN NULL;
  END IF;
END;
$body$
LANGUAGE plpgsql;