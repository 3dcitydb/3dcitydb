/*****************************************************************
 * CONTENT: PL/SQL Packages CITYDB_ENVELOPE_INTERNAL, CITYDB_ENVELOPE
 *   and CITYDB_ENVELOPE_UPDATE
 *
 * CITYDB_ENVELOPE_INTERNAL: Implementation of the envelope methods
 *   (not granted by grant-access.sql)
 * CITYDB_ENVELOPE: Methods for computing feature envelopes
 *   (granted to all access modes)
 * CITYDB_ENVELOPE_UPDATE: Methods for computing feature envelopes
 *   and writing them back to the FEATURE table (granted to RU and
 *   RW access modes)
 *****************************************************************/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_envelope_internal
AUTHID DEFINER
AS
  FUNCTION get_envelope(geom SDO_GEOMETRY) RETURN SDO_GEOMETRY;
  FUNCTION get_implicit_geometry_envelope(gid NUMBER, ref_pt SDO_GEOMETRY, matrix JSON) RETURN SDO_GEOMETRY;
  FUNCTION get_feature_envelope(fid NUMBER, compute_envelope NUMBER, set_envelope NUMBER, visited_ids NUMBER_TAB) RETURN SDO_GEOMETRY;
END citydb_envelope_internal;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_envelope_internal
AS

  TYPE bounds_rec IS RECORD (
    xmin NUMBER, ymin NUMBER, zmin NUMBER,
    xmax NUMBER, ymax NUMBER, zmax NUMBER,
    srid NUMBER
  );

  PROCEDURE extend_bounds(bounds IN OUT NOCOPY bounds_rec, geom SDO_GEOMETRY)
  IS
    xmin NUMBER; ymin NUMBER; zmin NUMBER;
    xmax NUMBER; ymax NUMBER; zmax NUMBER;
  BEGIN
    IF geom IS NULL THEN
      RETURN;
    END IF;

    xmin := SDO_GEOM.SDO_MIN_MBR_ORDINATE(geom, 1);
    ymin := SDO_GEOM.SDO_MIN_MBR_ORDINATE(geom, 2);
    xmax := SDO_GEOM.SDO_MAX_MBR_ORDINATE(geom, 1);
    ymax := SDO_GEOM.SDO_MAX_MBR_ORDINATE(geom, 2);

    IF geom.get_dims() >= 3 THEN
      zmin := SDO_GEOM.SDO_MIN_MBR_ORDINATE(geom, 3);
      zmax := SDO_GEOM.SDO_MAX_MBR_ORDINATE(geom, 3);
    ELSE
      zmin := 0;
      zmax := 0;
    END IF;

    IF xmin IS NULL OR ymin IS NULL OR zmin IS NULL
       OR xmax IS NULL OR ymax IS NULL OR zmax IS NULL THEN
      RETURN;
    END IF;

    bounds.xmin := LEAST(NVL(bounds.xmin, xmin), xmin);
    bounds.ymin := LEAST(NVL(bounds.ymin, ymin), ymin);
    bounds.zmin := LEAST(NVL(bounds.zmin, zmin), zmin);
    bounds.xmax := GREATEST(NVL(bounds.xmax, xmax), xmax);
    bounds.ymax := GREATEST(NVL(bounds.ymax, ymax), ymax);
    bounds.zmax := GREATEST(NVL(bounds.zmax, zmax), zmax);

    IF bounds.srid IS NULL THEN
      bounds.srid := geom.sdo_srid;
    END IF;
  END extend_bounds;

  PROCEDURE extend_bounds(bounds IN OUT NOCOPY bounds_rec, x NUMBER, y NUMBER, z NUMBER)
  IS
  BEGIN
    IF x IS NULL OR y IS NULL OR z IS NULL THEN
      RETURN;
    END IF;

    bounds.xmin := LEAST(NVL(bounds.xmin, x), x);
    bounds.ymin := LEAST(NVL(bounds.ymin, y), y);
    bounds.zmin := LEAST(NVL(bounds.zmin, z), z);
    bounds.xmax := GREATEST(NVL(bounds.xmax, x), x);
    bounds.ymax := GREATEST(NVL(bounds.ymax, y), y);
    bounds.zmax := GREATEST(NVL(bounds.zmax, z), z);
  END extend_bounds;

  FUNCTION bounds_to_envelope(bounds bounds_rec) RETURN SDO_GEOMETRY
  IS
    srid NUMBER := bounds.srid;
  BEGIN
    IF bounds.xmin IS NULL THEN
      RETURN NULL;
    END IF;

    IF srid IS NULL THEN
      SELECT d.srid INTO srid FROM database_srs d;
    END IF;

    RETURN SDO_GEOMETRY(
      3003,
      srid,
      NULL,
      SDO_ELEM_INFO_ARRAY(1, 1003, 1),
      SDO_ORDINATE_ARRAY(
        bounds.xmin, bounds.ymin, bounds.zmin,
        bounds.xmax, bounds.ymin, bounds.zmin,
        bounds.xmax, bounds.ymax, bounds.zmax,
        bounds.xmin, bounds.ymax, bounds.zmax,
        bounds.xmin, bounds.ymin, bounds.zmin
      )
    );
  END bounds_to_envelope;

  /******************************************************************
  * Returns the envelope geometry for a given geometry
  *
  * @param geom The geometry for which the envelope is computed
  * @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
  ******************************************************************/
  FUNCTION get_envelope(geom SDO_GEOMETRY) RETURN SDO_GEOMETRY
  IS
    bounds bounds_rec;
  BEGIN
    extend_bounds(bounds, geom);
    RETURN bounds_to_envelope(bounds);
  END get_envelope;

  /******************************************************************
  * Returns the envelope geometry of a given implicit geometry
  *
  * @param gid ID of the entry in the IMPLICIT_GEOMETRY table
  * @param ref_pt Reference point provided as POINT geometry
  * @param matrix Transformation matrix represented as JSON array of double values
  * @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
  ******************************************************************/
  FUNCTION get_implicit_geometry_envelope(gid NUMBER, ref_pt SDO_GEOMETRY, matrix JSON) RETURN SDO_GEOMETRY
  IS
    box SDO_GEOMETRY;
    bounds bounds_rec;
    params NUMBER_TAB := NUMBER_TAB(
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0);
    elem JSON_ELEMENT_T;
    arr JSON_ARRAY_T;
    xmin NUMBER; ymin NUMBER; zmin NUMBER;
    xmax NUMBER; ymax NUMBER; zmax NUMBER;
    x NUMBER; y NUMBER; z NUMBER;
  BEGIN
    SELECT SDO_AGGR_MBR(gd.implicit_geometry)
    INTO box
    FROM implicit_geometry ig
    JOIN geometry_data gd ON gd.id = ig.relative_geometry_id
    WHERE ig.id = gid
      AND gd.implicit_geometry IS NOT NULL;

    IF matrix IS NOT NULL THEN
      elem := JSON_ELEMENT_T.parse(JSON_SERIALIZE(matrix));
      IF NOT elem.is_array() THEN
        RAISE_APPLICATION_ERROR(-20001, 'The transformation matrix must be a JSON array');
      END IF;

      arr := TREAT(elem AS JSON_ARRAY_T);
      IF arr.get_size() < 12 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid transformation matrix: ' || JSON_SERIALIZE(matrix) || '. 12 elements are required');
      END IF;

      FOR i IN 1..12 LOOP
        params(i) := arr.get_number(i - 1);
        IF params(i) IS NULL AND NOT arr.get(i - 1).is_null() THEN
          RAISE_APPLICATION_ERROR(-20003, 'Invalid transformation matrix: ' || JSON_SERIALIZE(matrix) || '. Element ' || (i - 1) || ' is not a number');
        END IF;
      END LOOP;
    END IF;

    IF ref_pt IS NOT NULL THEN
      params(4) := params(4) + SDO_GEOM.SDO_MIN_MBR_ORDINATE(ref_pt, 1);
      params(8) := params(8) + SDO_GEOM.SDO_MIN_MBR_ORDINATE(ref_pt, 2);
      params(12) := params(12) + SDO_GEOM.SDO_MIN_MBR_ORDINATE(ref_pt, 3);
    END IF;

    IF box IS NOT NULL THEN
      xmin := SDO_GEOM.SDO_MIN_MBR_ORDINATE(box, 1);
      ymin := SDO_GEOM.SDO_MIN_MBR_ORDINATE(box, 2);
      xmax := SDO_GEOM.SDO_MAX_MBR_ORDINATE(box, 1);
      ymax := SDO_GEOM.SDO_MAX_MBR_ORDINATE(box, 2);

      IF box.get_dims() >= 3 THEN
        zmin := SDO_GEOM.SDO_MIN_MBR_ORDINATE(box, 3);
        zmax := SDO_GEOM.SDO_MAX_MBR_ORDINATE(box, 3);
      ELSE
        zmin := 0;
        zmax := 0;
      END IF;

      FOR i IN 0..7 LOOP
        x := CASE WHEN BITAND(i, 1) = 0 THEN xmin ELSE xmax END;
        y := CASE WHEN BITAND(i, 2) = 0 THEN ymin ELSE ymax END;
        z := CASE WHEN BITAND(i, 4) = 0 THEN zmin ELSE zmax END;

        extend_bounds(bounds,
          params(1) * x + params(2) * y + params(3) * z + params(4),
          params(5) * x + params(6) * y + params(7) * z + params(8),
          params(9) * x + params(10) * y + params(11) * z + params(12));
      END LOOP;
    ELSIF ref_pt IS NOT NULL THEN
      extend_bounds(bounds, params(4), params(8), params(12));
    ELSE
      RETURN NULL;
    END IF;

    RETURN bounds_to_envelope(bounds);
  END get_implicit_geometry_envelope;

  /******************************************************************
  * Returns the envelope geometry of a given feature while tracking
  * visited feature IDs to skip cycles.
  *
  * @param fid ID of the feature for which the envelope is computed
  * @param compute_envelope If 0, returns the envelope from the ENVELOPE column unless it is NULL, in which case the envelope is computed. If 1, the envelope is always computed.
  * @param set_envelope If 1, the ENVELOPE column of the FEATURE table will be updated with the computed envelope.
  * @param visited_ids Feature IDs already visited on the current recursion path
  * @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
  ******************************************************************/
  FUNCTION get_feature_envelope(fid NUMBER, compute_envelope NUMBER, set_envelope NUMBER, visited_ids NUMBER_TAB) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    bounds bounds_rec;
    current_ids NUMBER_TAB;
  BEGIN
    IF fid MEMBER OF visited_ids THEN
      RETURN NULL;
    END IF;

    current_ids := visited_ids MULTISET UNION NUMBER_TAB(fid);

    IF compute_envelope = 0 THEN
      BEGIN
        SELECT envelope INTO bbox FROM feature WHERE id = fid;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          bbox := NULL;
      END;

      IF bbox IS NOT NULL THEN
        RETURN bbox;
      END IF;
    END IF;

    FOR rec IN (
      SELECT p.val_feature_id
      FROM property p
      WHERE p.feature_id = fid
        AND p.val_feature_id IS NOT NULL
        AND p.val_relation_type = 1
    ) LOOP
      extend_bounds(bounds, get_feature_envelope(rec.val_feature_id, compute_envelope, set_envelope, current_ids));
    END LOOP;

    SELECT SDO_AGGR_MBR(gd.geometry)
    INTO bbox
    FROM geometry_data gd
    WHERE gd.feature_id = fid
      AND gd.geometry IS NOT NULL;

    extend_bounds(bounds, bbox);

    SELECT SDO_AGGR_MBR(get_implicit_geometry_envelope(p.val_implicitgeom_id, p.val_implicitgeom_refpoint, p.val_array))
    INTO bbox
    FROM property p
    WHERE p.feature_id = fid
      AND p.val_implicitgeom_id IS NOT NULL;

    extend_bounds(bounds, bbox);

    bbox := bounds_to_envelope(bounds);

    IF set_envelope <> 0 THEN
      UPDATE feature SET envelope = bbox WHERE id = fid;
    END IF;

    RETURN bbox;
  END get_feature_envelope;

END citydb_envelope_internal;
/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_envelope
AUTHID DEFINER
AS
  FUNCTION get_feature_envelope(fid NUMBER, compute_envelope NUMBER DEFAULT 0) RETURN SDO_GEOMETRY;
END citydb_envelope;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_envelope
AS

  /******************************************************************
  * Returns the envelope geometry of a given feature
  *
  * @param fid ID of the feature for which the envelope is computed
  * @param compute_envelope If 0 (default), returns the envelope from the ENVELOPE column unless it is NULL, in which case the envelope is computed. If 1, the envelope is always computed.
  * @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
  ******************************************************************/
  FUNCTION get_feature_envelope(fid NUMBER, compute_envelope NUMBER DEFAULT 0) RETURN SDO_GEOMETRY
  IS
  BEGIN
    RETURN citydb_envelope_internal.get_feature_envelope(fid, compute_envelope, 0, NUMBER_TAB());
  END get_feature_envelope;

END citydb_envelope;
/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_envelope_update
AUTHID DEFINER
AS
  FUNCTION update_feature_envelope(fid NUMBER, compute_envelope NUMBER DEFAULT 0) RETURN SDO_GEOMETRY;
END citydb_envelope_update;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_envelope_update
AS

  /******************************************************************
  * Returns the envelope geometry of a given feature and updates the
  * ENVELOPE column of the FEATURE table with the computed envelope
  *
  * @param fid ID of the feature for which the envelope is computed
  * @param compute_envelope If 0 (default), returns the envelope from the ENVELOPE column unless it is NULL, in which case the envelope is computed. If 1, the envelope is always computed.
  * @return Envelope geometry as required by the ENVELOPE column of the FEATURE table
  ******************************************************************/
  FUNCTION update_feature_envelope(fid NUMBER, compute_envelope NUMBER DEFAULT 0) RETURN SDO_GEOMETRY
  IS
  BEGIN
    RETURN citydb_envelope_internal.get_feature_envelope(fid, compute_envelope, 1, NUMBER_TAB());
  END update_feature_envelope;

END citydb_envelope_update;
/
