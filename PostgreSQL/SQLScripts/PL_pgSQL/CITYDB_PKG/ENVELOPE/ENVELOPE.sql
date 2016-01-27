-- ENVELOPE.sql
--
-- Authors:     Felix Kunde <felix-kunde@gmx.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
--                             Technische Universitaet Muenchen, Germany
--                             http://www.gis.bv.tum.de
--
-------------------------------------------------------------------------------
-- About:
-- This script provides functions to calculate an object's envelope 
-- (a diagonal cutting plane inside a 3D bounding box) and to store
-- the result in the ENVELOPE column of CITYOBJECT.
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                                 | Author
-- 1.3.0     2016-01-27   removed most of dynamic SQL code              FKun
-- 1.2.0     2015-11-11   added set_envelope parameter for functions    CNag
-- 1.1.0     2015-11-04   added set_envelope procedures                 FKun
-- 1.0.0     2015-07-21   release version 3DCityDB v3.1                 FKun
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   box2envelope(box BOX3D, VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY AS;
*   get_envelope_bridge(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_bridge_const_elem(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_bridge_furniture(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_bridge_inst(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_bridge_opening(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_bridge_them_srf(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_bridge_room(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_building(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_building_furn(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_building_inst(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_city_furniture(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_cityobjectgroup(co_id INTEGER, set_envelope INTEGER DEFAULT 0, calc_member_envelopes INTEGER DEFAULT 1, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_land_use(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_generic_cityobj(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_opening(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_plant_cover(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_relief_feature(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_relief_component(co_id NUMBER, objclass_id INTEGER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_room(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_solitary_veg_obj(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_thematic_surface(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_trans_complex(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_traffic_area(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_tunnel(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_tunnel_furniture(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_tunnel_inst(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_tunnel_opening(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_tunnel_them_srf(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_tunnel_hspace(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_waterbody(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_waterbnd_surface(co_id NUMBER, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_cityobject(co_id INTEGER, objclass_id INTEGER DEFAULT 0, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
*   get_envelope_cityobjects(objclass_id INTEGER, only_if_null INTEGER DEFAULT 1, set_envelope INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'citydb') RETURNS GEOMETRY;
******************************************************************/

/*****************************************************************
* citydb_pkg.box2envelope
*
* returns the envelope of a given land use
*
* @param        @description
* box           box3d consisting only of two 3D point
* schema_name       name of schema
*
* @return
* 3D envelope as diagonal cutting plane inside the given 3D bounding box
* consisting of 5 points (POLYGON Z)
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.box2envelope(
  box BOX3D, 
  schema_name VARCHAR DEFAULT 'citydb'
) RETURNS GEOMETRY AS
$$
DECLARE
  envelope GEOMETRY;
  db_srid INTEGER;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  IF box IS NULL THEN
    RETURN NULL;
  ELSE
    -- get reference system of input geometry
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
  END IF;

  RETURN envelope;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.box2envelope": %', SQLERRM;
END;
$$
LANGUAGE plpgsql STABLE;


/*****************************************************************
* get_envelope_implicit_geometry
*
* returns the envelope of a given implicit geometry
*
* @param            @description
* implicit_rep_id   identifier of implicit geometry
* ref_pt            reference point to place geometry
* transform4x4      transformation to apply against geometry
* schema_name       name of schema
*
* @return
* 3D envelope as diagonal cutting plane consisting of 5 points
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_implicit_geometry(
  implicit_rep_id INTEGER,
  ref_pt GEOMETRY,
  transform4x4 VARCHAR,
  schema_name VARCHAR DEFAULT 'citydb'
) RETURNS GEOMETRY AS
$$
DECLARE
  envelope GEOMETRY;
  params DOUBLE PRECISION[ ] := '{}';
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  -- calculate bounding box for implicit geometry
  WITH collect_geom AS (
    -- relative other geometry
    SELECT relative_other_geom AS geom 
      FROM implicit_geometry 
        WHERE id = implicit_rep_id 
          AND relative_other_geom IS NOT NULL
    UNION ALL
    -- relative brep geometry
    SELECT sg.implicit_geometry AS geom 
      FROM surface_geometry sg, implicit_geometry ig 
        WHERE sg.root_id = ig.relative_brep_id 
          AND ig.id = implicit_rep_id 
          AND sg.implicit_geometry IS NOT NULL
  ) 
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO envelope FROM collect_geom;

  IF transform4x4 IS NOT NULL THEN
    -- extract parameters of transformation matrix
    params := string_to_array(transform4x4, ' ')::float8[];

    IF array_length(params, 1) < 12 THEN
      RAISE EXCEPTION 'Malformed transformation matrix: %', transform4x4 USING HINT = '16 values are required';
    ELSE
      IF envelope IS NOT NULL THEN
        -- perform affine transformation against given transformation matrix
        envelope := ST_Affine(envelope, 
          params[1], params[2], params[3],
          params[5], params[6], params[7],
          params[9], params[10], params[11],
          params[4], params[8], params[12]);
      END IF;
    END IF;
  END IF;

  IF envelope IS NOT NULL AND ref_pt IS NOT NULL THEN
    -- perform translation to reference point
    envelope := ST_Translate(envelope, ST_X(ref_pt), ST_Y(ref_pt), ST_Z(ref_pt));
  END IF;

  RETURN envelope;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_implicit_geometry": %', SQLERRM;
END;
$$
LANGUAGE plpgsql STABLE;


/*****************************************************************
* get_envelope_land_use
*
* returns the envelope of a given land use
*
* @param        @description
* co_id         identifier for land use
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of land use
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_land_use(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  SELECT citydb_pkg.box2envelope(ST_3DExtent(geometry)) INTO bbox
    FROM surface_geometry
     WHERE cityobject_id = co_id
       AND geometry IS NOT NULL;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_land_use": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_generic_cityobj
*
* returns the envelope of a given generic city object
*
* @param        @description
* co_id         identifier for generic city object
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of generic city object
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_generic_cityobj(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- generic cityobject geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod0 other geometry
      SELECT lod0_other_geom AS geom FROM generic_cityobject WHERE id = co_id AND lod0_other_geom IS NOT NULL
    UNION ALL
    -- lod1 other geometry
      SELECT lod1_other_geom AS geom FROM generic_cityobject WHERE id = co_id AND lod1_other_geom IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM generic_cityobject WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM generic_cityobject WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM generic_cityobject WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod0 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod0_implicit_rep_id, lod0_implicit_ref_point, lod0_implicit_transformation, schema_name) AS geom 
        FROM generic_cityobject WHERE id = co_id AND lod0_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod1 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation, schema_name) AS geom 
        FROM generic_cityobject WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM generic_cityobject WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM generic_cityobject WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM generic_cityobject WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_generic_cityobj": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_solitary_veg_obj
*
* returns the envelope of a given solitary vegetation object
*
* @param        @description
* co_id         identifier for solitary vegetation object
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of solitary vegetation object
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_solitary_veg_obj(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- solitary vegetation object geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod1 other geometry
      SELECT lod1_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod1_other_geom IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod1 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation, schema_name) AS geom 
        FROM solitary_vegetat_object WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM solitary_vegetat_object WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM solitary_vegetat_object WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM solitary_vegetat_object WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_solitary_veg_obj": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_plant_cover
*
* returns the envelope of a given plant cover
*
* @param        @description
* co_id         identifier for plant cover
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of plant cover
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_plant_cover(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  SELECT citydb_pkg.box2envelope(ST_3DExtent(geometry)) INTO bbox
    FROM surface_geometry
      WHERE cityobject_id = co_id 
        AND geometry IS NOT NULL;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_plant_cover": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_waterbody
*
* returns the envelope of a given water body
*
* @param        @description
* co_id         identifier for water body
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of water body
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_waterbody(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- waterbody geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- water boundary surface geometry
      SELECT citydb_pkg.get_envelope_waterbnd_surface(wbs.id, set_envelope, schema_name) AS geom
        FROM waterboundary_surface wbs, waterbod_to_waterbnd_srf wb2wbs
          WHERE wbs.id = wb2wbs.waterboundary_surface_id 
            AND wb2wbs.waterbody_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_waterbody": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_waterbnd_surface
*
* returns the envelope of a given water boundary surface
*
* @param        @description
* co_id         identifier for water boundary surface
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of water boundary surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_waterbnd_surface(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  SELECT citydb_pkg.box2envelope(ST_3DExtent(geometry)) INTO bbox
    FROM surface_geometry
      WHERE cityobject_id = co_id
        AND geometry IS NOT NULL;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
       RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_waterbnd_surface": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_relief_feature
*
* returns the envelope of a given relief feature
*
* @param        @description
* co_id         identifier for relief feature
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of relief feature
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_relief_feature(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  -- try to generate envelope from relief components
  WITH collect_geom AS (
    SELECT citydb_pkg.get_envelope_relief_component(rc.id, rc.objectclass_id, set_envelope, schema_name) AS geom 
      FROM relief_component rc, relief_feat_to_rel_comp rf2rc 
        WHERE rc.id = rf2rc.relief_component_id AND rf2rc.relief_feature_id = co_id
    )
    SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occured when executing function "citydb_pkg.get_envelope_relief_feature": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_relief_component
*
* returns the envelope of a given relief component
*
* @param        @description
* co_id         identifier for relief component
* objclass_id   objectclass of city object
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of relief component
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_relief_component(
  co_id INTEGER,
  objclass_id INTEGER DEFAULT 0,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  class_id INTEGER;
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  -- fetching class_id if it is NULL
  IF objclass_id = 0 THEN
    SELECT objectclass_id INTO class_id FROM cityobject WHERE id = co_id;
  ELSE
    class_id := objclass_id;
  END IF;

  CASE
    -- get spatial extent of TIN relief
    WHEN class_id = 16 THEN 
      SELECT citydb_pkg.box2envelope(ST_3DExtent(sg.geometry)) INTO bbox
        FROM surface_geometry sg, tin_relief tin
          WHERE tin.surface_geometry_id = sg.root_id 
            AND tin.id = co_id 
            AND sg.geometry IS NOT NULL;
    -- get spatial extent of masspoint relief
    WHEN class_id = 17 THEN
      SELECT citydb_pkg.box2envelope(ST_3DExtent(relief_points)) INTO bbox
        FROM masspoint_relief 
          WHERE id = co_id;
    -- get spatial extent of breakline relief taking a union of ridge, valley and break lines
    WHEN class_id = 18 THEN
      SELECT citydb_pkg.box2envelope(ST_3DExtent(ST_Collect(ridge_or_valley_lines, break_lines))) INTO bbox
        FROM breakline_relief
          WHERE id = co_id;
    -- get spatial extent of raster relief
    WHEN class_id = 19 THEN
      SELECT citydb_pkg.box2envelope(Box3D(rasterproperty)) INTO bbox
        FROM grid_coverage grid, raster_relief rast 
          WHERE rast.coverage_id = grid.id 
            AND rast.id = co_id;
  END CASE;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occured when executing function "citydb_pkg.get_envelope_relief_component": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_city_furniture
*
* returns the envelope of a given generic city object
*
* @param        @description
* co_id         identifier for city furniture
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of city furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_city_furniture(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- city furniture geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod1 other geometry
      SELECT lod1_other_geom AS geom FROM city_furniture WHERE id = co_id AND lod1_other_geom IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM city_furniture WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM city_furniture WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM city_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod1 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation, schema_name) AS geom 
        FROM city_furniture WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM city_furniture WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM city_furniture WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM city_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_city_furniture": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_cityobjectgroup
*
* returns the envelope of a given city object group
*
* @param                  @description
* co_id                   identifier for city object group
* set_envelope            if 1 (default = 0) the envelope column is updated
* calc_member_envelopes   if 1 (default) the envelope of group members is calculated 
*                         otherwise it is taken from the ENVELOPE column
* schema_name             name of schema
*
* @return
* aggregated envelope geometry of city object group
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobjectgroup(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  calc_member_envelopes INTEGER DEFAULT 1,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  IF calc_member_envelopes <> 0 THEN
    WITH collect_geom AS (
      -- cityobjectgroup geometry
        SELECT geometry AS geom FROM surface_geometry 
          WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- other geometry
        SELECT other_geom AS geom FROM cityobjectgroup 
          WHERE id = co_id AND other_geom IS NOT NULL
      UNION ALL
      -- group member geometry
        SELECT citydb_pkg.get_envelope_cityobject(co.id, co.objectclass_id, set_envelope, schema_name) AS geom
          FROM cityobject co, group_to_cityobject g2co 
            WHERE co.id = g2co.cityobject_id 
              AND g2co.cityobjectgroup_id = co_id
    )
    SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;
  ELSE
    WITH collect_geom AS (
      -- cityobjectgroup geometry
        SELECT geometry AS geom FROM surface_geometry 
          WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- other geometry
        SELECT other_geom AS geom FROM cityobjectgroup 
          WHERE id = co_id AND other_geom IS NOT NULL
      UNION ALL
      -- group member envelopes
        SELECT co.envelope AS geom
          FROM cityobject co, group_to_cityobject g2co 
            WHERE co.id = g2co.cityobject_id 
              AND g2co.cityobjectgroup_id = co_id
    )
    SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;
  END IF;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;

    -- group parent 
    PERFORM citydb_pkg.get_envelope_cityobject(co.id, co.objectclass_id, set_envelope, schema_name)
      FROM cityobject co, cityobjectgroup g
        WHERE co.id = g.parent_cityobject_id 
          AND g.id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "get_envelope_cityobjectgroup": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_building
*
* returns the envelope of a given building
*
* @param        @description
* co_id         identifier for building
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of building
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_building(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- building geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- building part geometry
      SELECT citydb_pkg.get_envelope_building(id, set_envelope, schema_name) AS geom
        FROM building WHERE building_root_id = co_id AND building_parent_id IS NOT NULL
    UNION ALL
    -- building thematic surface geometry
      SELECT citydb_pkg.get_envelope_thematic_surface(id, set_envelope, schema_name) AS geom
        FROM thematic_surface WHERE building_id = co_id AND objectclass_id IN (33, 34, 35, 36, 60, 61)
    UNION ALL
    -- building installation geometry
      SELECT citydb_pkg.get_envelope_building_inst(id, set_envelope, schema_name) AS geom
        FROM building_installation WHERE building_id = co_id AND objectclass_id = 27
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 THEN
    -- building
    IF bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    -- interior rooms
    PERFORM citydb_pkg.get_envelope_room(id, set_envelope, schema_name)
      FROM room 
        WHERE building_id = co_id;

    -- interior thematic surfaces
    PERFORM citydb_pkg.get_envelope_thematic_surface(id, set_envelope, schema_name)
      FROM thematic_surface 
        WHERE building_id = co_id 
          AND objectclass_id IN (30, 31, 32);

    -- interior building installations
    PERFORM citydb_pkg.get_envelope_building_inst(id, set_envelope, schema_name)
      FROM building_installation 
        WHERE building_id = co_id 
          AND objectclass_id = 28;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_building": %', SQLERRM;

END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_building_inst
*
* returns the envelope of a given building installation
*
* @param        @description
* co_id         identifier for building installation
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of building installation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_building_inst(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- building installation geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM building_installation WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM building_installation WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM building_installation WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM building_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM building_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM building_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    UNION ALL
    -- thematic surface geometry
      SELECT citydb_pkg.get_envelope_thematic_surface(id, set_envelope, schema_name) AS geom
        FROM thematic_surface WHERE building_installation_id = co_id 
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_building_inst": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_thematic_surface
*
* returns the envelope of a given thematic surface
*
* @param        @description
* co_id         identifier for thematic surface
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of thematic surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_thematic_surface(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);
 
  WITH collect_geom AS(
    -- thematic surface geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- opening geometry
      SELECT citydb_pkg.get_envelope_opening(o.id, set_envelope, schema_name) AS geom
        FROM opening o, opening_to_them_surface o2ts 
          WHERE o2ts.thematic_surface_id = co_id 
            AND o.id = o2ts.opening_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_thematic_surface": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_opening
*
* returns the envelope of a given opening
*
* @param        @description
* co_id         identifier for opening
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of opening
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_opening(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- opening geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;
    
  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_opening": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_building_furn
*
* returns the envelope of a given building furniture
*
* @param        @description
* co_id         identifier for building furniture
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of building furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_building_furn(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- building furniture geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM building_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM building_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_building_furn": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_room
*
* returns the envelope of a given room
*
* @param        @description
* co_id         identifier for room
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of room
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_room(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- room geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- interior thematic surface geometry
      SELECT citydb_pkg.get_envelope_thematic_surface(id, set_envelope, schema_name) AS geom
        FROM thematic_surface WHERE room_id = co_id
    UNION ALL
    -- room installation geometry
      SELECT citydb_pkg.get_envelope_building_inst(id, set_envelope, schema_name) AS geom
        FROM building_installation WHERE room_id = co_id
    UNION ALL
    -- building furniture geometry
      SELECT citydb_pkg.get_envelope_building_furn(id, set_envelope, schema_name) AS geom
        FROM building_furniture WHERE room_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;    

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_room": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_trans_complex
*
* returns the envelope of a given transportation complex
*
* @param        @description
* co_id         identifier for transportation complex
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of transportation complex
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_trans_complex(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- lod0 road network geometry of transportation complex
      SELECT lod0_network AS geom FROM transportation_complex WHERE id = co_id AND lod0_network IS NOT NULL
    UNION ALL
    -- transportation complex geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- traffic area geometry
      SELECT citydb_pkg.get_envelope_traffic_area(id, set_envelope, schema_name) AS geom
        FROM traffic_area WHERE transportation_complex_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_trans_complex": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_traffic_area
*
* returns the envelope of a given traffic area
*
* @param        @description
* co_id         identifier for traffic area
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of traffic area
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_traffic_area(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  SELECT citydb_pkg.box2envelope(ST_3DExtent(geometry)) INTO bbox 
    FROM surface_geometry
      WHERE cityobject_id = co_id 
        AND geometry IS NOT NULL;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_traffic_area": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge
*
* returns the envelope of a given bridge
*
* @param        @description
* co_id         identifier for bridge
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- bridge geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- bridge part geometry
      SELECT citydb_pkg.get_envelope_bridge(id, set_envelope, schema_name) AS geom
        FROM bridge WHERE bridge_root_id = co_id AND bridge_parent_id IS NOT NULL
    UNION ALL
    -- bridge thematic surface geometry
      SELECT citydb_pkg.get_envelope_bridge_them_srf(id, set_envelope, schema_name) AS geom
        FROM bridge_thematic_surface WHERE bridge_id = co_id AND objectclass_id IN (71, 72, 73, 74, 75, 76)
    UNION ALL
    -- bridge installation geometry
      SELECT citydb_pkg.get_envelope_bridge_inst(id, set_envelope, schema_name) AS geom
        FROM bridge_installation WHERE bridge_id = co_id AND objectclass_id = 65
    UNION ALL
    -- bridge construction element geometry
      SELECT citydb_pkg.get_envelope_bridge_const_elem(id, set_envelope, schema_name) AS geom
        FROM bridge_constr_element WHERE bridge_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 THEN
    -- bridge
    IF bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    -- interior bridge rooms
    PERFORM citydb_pkg.get_envelope_bridge_room(id, set_envelope, schema_name)
      FROM bridge_room 
        WHERE bridge_id = co_id;

    -- interior thematic surfaces
    PERFORM citydb_pkg.get_envelope_bridge_them_srf(id, set_envelope, schema_name)
      FROM bridge_thematic_surface 
        WHERE bridge_id = co_id 
          AND objectclass_id IN (68, 69, 70);

    -- interior bridge installations
    PERFORM citydb_pkg.get_envelope_bridge_inst(id, set_envelope, schema_name)
      FROM bridge_installation 
        WHERE bridge_id = co_id 
          AND objectclass_id = 66;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge_inst
*
* returns the envelope of a given bridge installation
*
* @param        @description
* co_id         identifier for bridge installation
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge installation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge_inst(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- bridge installation geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM bridge_installation WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM bridge_installation WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM bridge_installation WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM bridge_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM bridge_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM bridge_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    UNION ALL
    -- thematic surface geometry
      SELECT citydb_pkg.get_envelope_bridge_them_srf(id, set_envelope, schema_name) AS geom
        FROM bridge_thematic_surface WHERE bridge_installation_id = co_id 
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge_inst": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge_them_srf
*
* returns the envelope of a given bridge thematic surface
*
* @param        @description
* co_id         identifier for bridge thematic surface
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge thematic surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge_them_srf(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS(
    -- thematic surface geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- opening geometry
      SELECT citydb_pkg.get_envelope_bridge_opening(o.id, set_envelope, schema_name) AS geom
        FROM bridge_opening o, bridge_open_to_them_srf o2ts 
          WHERE o2ts.bridge_thematic_surface_id = co_id 
            AND o.id = o2ts.bridge_opening_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN 
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge_them_srf": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge_opening
*
* returns the envelope of a given bridge opening
*
* @param        @description
* co_id         identifier for bridge opening
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge opening
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge_opening(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- opening geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM bridge_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM bridge_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge_opening": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge_furniture
*
* returns the envelope of a given bridge furniture
*
* @param        @description
* co_id         identifier for bridge furniture
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge_furniture(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- bridge furniture geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM bridge_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM bridge_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom; 

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge_furniture": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge_room
*
* returns the envelope of a given bridge room
*
* @param        @description
* co_id         identifier for bridge room
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge room
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge_room(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);
 
  WITH collect_geom AS (
    -- room geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- interior thematic surface geometry
      SELECT citydb_pkg.get_envelope_bridge_them_srf(id, set_envelope, schema_name) AS geom
        FROM bridge_thematic_surface WHERE bridge_room_id = co_id
    UNION ALL
    -- bridge room installation geometry
      SELECT citydb_pkg.get_envelope_bridge_inst(id, set_envelope, schema_name) AS geom
        FROM bridge_installation WHERE bridge_room_id = co_id
    UNION ALL
    -- bridge furniture geometry
      SELECT citydb_pkg.get_envelope_bridge_furniture(id, set_envelope, schema_name) AS geom
        FROM bridge_furniture WHERE bridge_room_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge_room": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_bridge_const_elem
*
* returns the envelope of a given bridge construction element
*
* @param        @description
* co_id         identifier for bridge construction element
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of bridge construction element
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_bridge_const_elem(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- bridge construction element geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod1 other geometry
      SELECT lod1_other_geom AS geom FROM bridge_constr_element WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM bridge_constr_element WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM bridge_constr_element WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM bridge_constr_element WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod1 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation, schema_name) AS geom 
        FROM bridge_constr_element WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM bridge_constr_element WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM bridge_constr_element WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM bridge_constr_element WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    UNION ALL
    -- thematic surface geometry
      SELECT citydb_pkg.get_envelope_bridge_them_srf(id, set_envelope, schema_name) AS geom
        FROM bridge_thematic_surface WHERE bridge_constr_element_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_bridge_const_elem": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_tunnel
*
* returns the envelope of a given tunnel
*
* @param        @description
* co_id         identifier for tunnel
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of tunnel
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_tunnel(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- tunnel geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- tunnel part geometry
      SELECT citydb_pkg.get_envelope_tunnel(id, set_envelope, schema_name) AS geom
        FROM tunnel WHERE tunnel_root_id = co_id AND tunnel_parent_id IS NOT NULL
    UNION ALL
    -- tunnel thematic surface geometry
      SELECT citydb_pkg.get_envelope_tunnel_them_srf(id, set_envelope, schema_name) AS geom
        FROM tunnel_thematic_surface WHERE tunnel_id = co_id AND objectclass_id IN (92, 93, 94, 95, 96, 97)
    UNION ALL
    -- tunnel installation geometry
      SELECT citydb_pkg.get_envelope_tunnel_inst(id, set_envelope, schema_name) AS geom
        FROM tunnel_installation WHERE tunnel_id = co_id AND objectclass_id = 86
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 THEN
    -- tunnel
    IF bbox IS NOT NULL THEN  
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    -- interior hollow spaces
    PERFORM citydb_pkg.get_envelope_tunnel_hspace(id, set_envelope, schema_name) 
      FROM tunnel_hollow_space 
        WHERE tunnel_id = co_id;

    -- interior thematic surfaces
    PERFORM citydb_pkg.get_envelope_tunnel_them_srf(id, set_envelope, schema_name)
      FROM tunnel_thematic_surface 
        WHERE tunnel_id = co_id
          AND objectclass_id IN (89, 90, 91);

    -- interior tunnel installations
    PERFORM citydb_pkg.get_envelope_tunnel_inst(id, set_envelope, schema_name)
      FROM tunnel_installation 
        WHERE tunnel_id = co_id
          AND objectclass_id = 87;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_tunnel": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_tunnel_inst
*
* returns the envelope of a given tunnel installation
*
* @param        @description
* co_id         identifier for tunnel installation
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of tunnel installation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_tunnel_inst(
  co_id INTEGER,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- tunnel installation geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod2 other geometry
      SELECT lod2_other_geom AS geom FROM tunnel_installation WHERE id = co_id AND lod2_other_geom IS NOT NULL
    UNION ALL
    -- lod3 other geometry
      SELECT lod3_other_geom AS geom FROM tunnel_installation WHERE id = co_id AND lod3_other_geom IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM tunnel_installation WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod2 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation, schema_name) AS geom 
        FROM tunnel_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM tunnel_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM tunnel_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    UNION ALL
    -- thematic surface geometry
      SELECT citydb_pkg.get_envelope_tunnel_them_srf(id, set_envelope, schema_name) AS geom
        FROM tunnel_thematic_surface WHERE tunnel_installation_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_tunnel_inst": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_tunnel_them_srf
*
* returns the envelope of a given tunnel thematic surface
*
* @param        @description
* co_id         identifier for tunnel thematic surface
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of tunnel thematic surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_tunnel_them_srf(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS(
    -- thematic surface geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- opening geometry
      SELECT citydb_pkg.get_envelope_tunnel_opening(o.id, set_envelope, schema_name) AS geom
        FROM tunnel_opening o, tunnel_open_to_them_srf o2ts 
          WHERE o2ts.tunnel_thematic_surface_id = co_id 
            AND o.id = o2ts.tunnel_opening_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_tunnel_them_srf": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_tunnel_opening
*
* returns the envelope of a given tunnel opening
*
* @param        @description
* co_id         identifier for tunnel opening
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of tunnel opening
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_tunnel_opening(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- opening geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod3 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation, schema_name) AS geom 
        FROM tunnel_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM tunnel_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_tunnel_opening": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_tunnel_furniture
*
* returns the envelope of a given tunnel furniture
*
* @param        @description
* co_id         identifier for tunnel furniture
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of tunnel furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_tunnel_furniture(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- tunnel furniture geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- lod4 other geometry
      SELECT lod4_other_geom AS geom FROM tunnel_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
    UNION ALL
    -- lod4 implicit geometry
      SELECT citydb_pkg.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation, schema_name) AS geom 
        FROM tunnel_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_tunnel_furniture": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_tunnel_hspace
*
* returns the envelope of a given tunnel hollow space
*
* @param        @description
* co_id         identifier for tunnel hollow space
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of tunnel hollow space
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_tunnel_hspace(
  co_id INTEGER, 
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  WITH collect_geom AS (
    -- hollow space geometry
      SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    UNION ALL
    -- interior thematic surface geometry
      SELECT citydb_pkg.get_envelope_tunnel_them_srf(id, set_envelope, schema_name) AS geom
        FROM tunnel_thematic_surface WHERE tunnel_hollow_space_id = co_id
    UNION ALL
    -- interior tunnel installation geometry
      SELECT citydb_pkg.get_envelope_tunnel_inst(id, set_envelope, schema_name) AS geom
        FROM tunnel_installation WHERE tunnel_hollow_space_id = co_id
    UNION ALL
    -- tunnel furniture geometry
      SELECT citydb_pkg.get_envelope_tunnel_furniture(id, set_envelope, schema_name) AS geom
        FROM tunnel_furniture WHERE tunnel_hollow_space_id = co_id
  )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) INTO bbox FROM collect_geom;

  IF set_envelope <> 0 AND bbox IS NOT NULL THEN 
    UPDATE cityobject SET envelope = bbox WHERE id = co_id;
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_tunnel_hspace": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_cityobject
*
* RETURN the envelope of a given city object
*
* @param        @description
* co_id         identifier for city object
* objclass_id   objectclass of city object
* set_envelope  if 1 (default = 0) the envelope column is updated
* schema_name   name of schema
*
* @return
* aggregated envelope geometry of city object
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobject(
  co_id INTEGER,
  objclass_id INTEGER DEFAULT 0,
  set_envelope INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  class_id INTEGER := 0;
  envelope GEOMETRY;
  db_srid INTEGER;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);

  -- fetching class_id if it is NULL
  IF objclass_id IS NULL OR objclass_id = 0 THEN
    SELECT objectclass_id INTO class_id 
      FROM cityobject 
        WHERE id = co_id;
  ELSE
    class_id := objclass_id;
  END IF;

  CASE
    WHEN class_id = 4 THEN envelope := citydb_pkg.get_envelope_land_use(co_id, set_envelope, schema_name);
    WHEN class_id = 5 THEN envelope := citydb_pkg.get_envelope_generic_cityobj(co_id, set_envelope, schema_name);
    WHEN class_id = 7 THEN envelope := citydb_pkg.get_envelope_solitary_veg_obj(co_id, set_envelope, schema_name);
    WHEN class_id = 8 THEN envelope := citydb_pkg.get_envelope_plant_cover(co_id, set_envelope, schema_name);
    WHEN class_id = 9 THEN envelope := citydb_pkg.get_envelope_waterbody(co_id, set_envelope, schema_name);
    WHEN class_id = 11 OR
         class_id = 12 OR
         class_id = 13 THEN envelope := citydb_pkg.get_envelope_waterbnd_surface(co_id, set_envelope, schema_name);
    WHEN class_id = 14 THEN envelope := citydb_pkg.get_envelope_relief_feature(co_id, set_envelope, schema_name);
    WHEN class_id = 16 OR
         class_id = 17 OR
         class_id = 18 OR
         class_id = 19 THEN envelope := citydb_pkg.get_envelope_relief_component(co_id, class_id, set_envelope, schema_name);
    WHEN class_id = 21 THEN envelope := citydb_pkg.get_envelope_city_furniture(co_id, set_envelope, schema_name);
    WHEN class_id = 23 THEN envelope := citydb_pkg.get_envelope_cityobjectgroup(co_id, set_envelope, 1, schema_name);
    WHEN class_id = 25 OR
         class_id = 26 THEN envelope := citydb_pkg.get_envelope_building(co_id, set_envelope, schema_name);
    WHEN class_id = 27 OR
         class_id = 28 THEN envelope := citydb_pkg.get_envelope_building_inst(co_id, set_envelope, schema_name);
    WHEN class_id = 30 OR
         class_id = 31 OR
         class_id = 32 OR
         class_id = 33 OR
         class_id = 34 OR
         class_id = 35 OR
         class_id = 36 OR
         class_id = 60 OR
         class_id = 61 THEN envelope := citydb_pkg.get_envelope_thematic_surface(co_id, set_envelope, schema_name);
    WHEN class_id = 38 OR
         class_id = 39 THEN envelope := citydb_pkg.get_envelope_opening(co_id, set_envelope, schema_name);
    WHEN class_id = 40 THEN envelope := citydb_pkg.get_envelope_building_furn(co_id, set_envelope, schema_name);
    WHEN class_id = 41 THEN envelope := citydb_pkg.get_envelope_room(co_id, set_envelope, schema_name);
    WHEN class_id = 43 OR
         class_id = 44 OR
         class_id = 45 OR
         class_id = 46 THEN envelope := citydb_pkg.get_envelope_trans_complex(co_id, set_envelope, schema_name);
    WHEN class_id = 47 OR
         class_id = 48 THEN envelope := citydb_pkg.get_envelope_traffic_area(co_id, set_envelope, schema_name);
    WHEN class_id = 63 OR
         class_id = 64 THEN envelope := citydb_pkg.get_envelope_bridge(co_id, set_envelope, schema_name);
    WHEN class_id = 65 OR
         class_id = 66 THEN envelope := citydb_pkg.get_envelope_bridge_inst(co_id, set_envelope, schema_name);
    WHEN class_id = 68 OR
         class_id = 69 OR
         class_id = 70 OR
         class_id = 71 OR
         class_id = 72 OR
         class_id = 73 OR
         class_id = 74 OR
         class_id = 75 OR
         class_id = 76 THEN envelope := citydb_pkg.get_envelope_bridge_them_srf(co_id, set_envelope, schema_name);
    WHEN class_id = 78 OR
         class_id = 79 THEN envelope := citydb_pkg.get_envelope_bridge_opening(co_id, set_envelope, schema_name);
    WHEN class_id = 80 THEN envelope := citydb_pkg.get_envelope_bridge_furniture(co_id, set_envelope, schema_name);
    WHEN class_id = 81 THEN envelope := citydb_pkg.get_envelope_bridge_room(co_id, set_envelope, schema_name);
    WHEN class_id = 82 THEN envelope := citydb_pkg.get_envelope_bridge_const_elem(co_id, set_envelope, schema_name);
    WHEN class_id = 84 OR
         class_id = 85 THEN envelope := citydb_pkg.get_envelope_tunnel(co_id, set_envelope, schema_name);
    WHEN class_id = 86 OR
         class_id = 87 THEN envelope := citydb_pkg.get_envelope_tunnel_inst(co_id, set_envelope, schema_name);
    WHEN class_id = 89 OR
         class_id = 90 OR
         class_id = 91 OR
         class_id = 92 OR
         class_id = 93 OR
         class_id = 94 OR
         class_id = 95 OR
         class_id = 96 OR
         class_id = 97 THEN envelope := citydb_pkg.get_envelope_tunnel_them_srf(co_id, set_envelope, schema_name);
    WHEN class_id = 99 OR
         class_id = 100 THEN envelope := citydb_pkg.get_envelope_tunnel_opening(co_id, set_envelope, schema_name);
    WHEN class_id = 101 THEN envelope := citydb_pkg.get_envelope_tunnel_furniture(co_id, set_envelope, schema_name);
    WHEN class_id = 102 THEN envelope := citydb_pkg.get_envelope_tunnel_hspace(co_id, set_envelope, schema_name);
  ELSE
    RAISE NOTICE 'Can not get envelope of object with ID % and objectclass_id %.', co_id, class_id;
  END CASE;

  RETURN envelope;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_cityobject": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_envelope_cityobjects
*
* creates envelopes for all city objects of a given objectclass
*
* @param        @description
* objclass_id   if 0 functions runs against every city object
* set_envelope  if 1 (default = 0) the envelope column is updated
* only_if_null  if 1 (default) only empty rows of envelope column are updated
* schema_name   name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobjects(
  objclass_id INTEGER DEFAULT 0,
  set_envelope INTEGER DEFAULT 0,
  only_if_null INTEGER DEFAULT 1,
  schema_name VARCHAR DEFAULT 'citydb'
  ) RETURNS GEOMETRY AS
$$
DECLARE
  filter TEXT := '';
  group_filter TEXT := '';
  bbox GEOMETRY;
BEGIN
  -- update search_path
  PERFORM set_config('search_path', schema_name || ',public', true);
  
  IF only_if_null <> 0 THEN
    filter := ' WHERE envelope IS NULL';
  END IF;

  IF objclass_id <> 0 THEN
    filter := CASE WHEN filter = '' THEN ' WHERE ' ELSE filter || ' AND ' END;
    filter := filter || 'objectclass_id = $1';

    EXECUTE
      'WITH collect_geom AS (
         -- cityobject geometry
          SELECT citydb_pkg.get_envelope_cityobject(id, objectclass_id, $2, $3) AS geom
            FROM cityobject' || filter || '
       )
       SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) FROM collect_geom' 
       INTO bbox USING objclass_id, set_envelope, schema_name;      
  ELSE
    group_filter := CASE WHEN filter = '' THEN ' WHERE ' ELSE filter || ' AND ' END;
    group_filter := group_filter || 'objectclass_id = 23';

    filter := CASE WHEN filter = '' THEN ' WHERE ' ELSE filter || ' AND ' END;
    filter := filter || 'objectclass_id IN (4, 5, 7, 8, 9, 14, 21, 25, 26, 42, 43, 44, 45, 46, 63, 64, 84, 85)';

    -- first: work on top-level features not being groups
    EXECUTE
      'WITH collect_geom AS (
         -- top-level feature geometry
           SELECT citydb_pkg.get_envelope_cityobject(id, objectclass_id, $1, $2) AS geom
             FROM cityobject' || filter || '
       )
       SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) FROM collect_geom'
       INTO bbox USING set_envelope, schema_name;

    -- second: work on city object groups
    EXECUTE
      'WITH collect_geom AS (
         -- cityobject group
           SELECT citydb_pkg.get_envelope_cityobjectgroup(id, $1, 0, $2) AS geom
             FROM cityobject' || group_filter || '
         -- current envelope
         UNION ALL
           SELECT $3 AS geom
       )
       SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) FROM collect_geom'
       INTO bbox USING set_envelope, schema_name, bbox;


    -- third: work on remaining nested features not being groups
    EXECUTE
      'WITH collect_geom AS (
         -- nested feature geometry
           SELECT citydb_pkg.get_envelope_cityobject(id, objectclass_id, $1, $2) AS geom
             FROM cityobject WHERE envelope IS NULL AND objectclass_id <> 23
         -- current envelope
         UNION ALL
           SELECT $3 AS geom
       )
       SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) FROM collect_geom'
       INTO bbox USING set_envelope, schema_name, bbox;   
  END IF;

  RETURN bbox;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_cityobjects": %', SQLERRM;
END;
$$
LANGUAGE plpgsql;