-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
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

CREATE OR REPLACE PACKAGE citydb_envelope
AS
  FUNCTION box2envelope(box SDO_GEOMETRY) RETURN SDO_GEOMETRY;
  FUNCTION update_bounds(old_box SDO_GEOMETRY, new_box SDO_GEOMETRY) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_implicit_geometry(implicit_rep_id NUMBER, ref_pt SDO_GEOMETRY, transform4x4 VARCHAR2) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge_const_elem(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge_furniture(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge_inst(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge_opening(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge_them_srf(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_bridge_room(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_building(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_building_furn(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_building_inst(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_city_furniture(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_cityobjectgroup(co_id NUMBER, set_envelope int := 0, calc_member_envelopes int := 1) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_land_use(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_generic_cityobj(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_opening(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_plant_cover(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_relief_feature(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_relief_component(co_id NUMBER, objclass_id NUMBER, set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_room(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_solitary_veg_obj(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_thematic_surface(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_trans_complex(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_traffic_area(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_tunnel(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_tunnel_furniture(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_tunnel_inst(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_tunnel_opening(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_tunnel_them_srf(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_tunnel_hspace(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_waterbody(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_waterbnd_surface(co_id NUMBER,  set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_cityobject(co_id NUMBER, objclass_id NUMBER, set_envelope int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_cityobjects(objclass_id NUMBER := 0, set_envelope int := 0, only_if_null int := 1) RETURN SDO_GEOMETRY;
END citydb_envelope;
/

CREATE OR REPLACE PACKAGE BODY citydb_envelope
AS
  TYPE ref_cursor IS REF CURSOR;

  /*****************************************************************
  * box2envelope
  *
  * returns the envelope of a given land use
  *
  * @param        @description
  * box           optimized box consisting only of two 3D point
  *
  * @return
  * 3D envelope as diagonal cutting plane inside the given 3D bounding box
  * consisting of 5 points (GTYPE:3003, ETYPE:1003)
  ******************************************************************/
  FUNCTION box2envelope(
    box SDO_GEOMETRY
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    db_srid NUMBER;
  BEGIN
    IF box IS NULL THEN
      RETURN NULL;
    ELSE
      -- get reference system of input geometry
      IF box.sdo_srid IS NULL THEN
        SELECT
          srid
        INTO
          db_srid
        FROM
          database_srs;
      ELSE
        db_srid := box.sdo_srid;
      END IF;

      bbox := MDSYS.SDO_GEOMETRY(
                3003,
                db_srid,
                NULL,
                MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1),
                MDSYS.SDO_ORDINATE_ARRAY(
                  SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,1),SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,2),SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,3),
                  SDO_GEOM.SDO_MAX_MBR_ORDINATE(box,1),SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,2),SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,3),
                  SDO_GEOM.SDO_MAX_MBR_ORDINATE(box,1),SDO_GEOM.SDO_MAX_MBR_ORDINATE(box,2),SDO_GEOM.SDO_MAX_MBR_ORDINATE(box,3),
                  SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,1),SDO_GEOM.SDO_MAX_MBR_ORDINATE(box,2),SDO_GEOM.SDO_MAX_MBR_ORDINATE(box,3),
                  SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,1),SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,2),SDO_GEOM.SDO_MIN_MBR_ORDINATE(box,3)
                )
              );
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "citydb_envelope.box2envelope": ' || SQLERRM);
  END;


  /*****************************************************************
  * update_bounds
  *
  * creates a new 3D envelope based on the two input geometries
  *
  * @param        @description
  * old_box       an existing envelope
  * new_box       a new envelope to merge with existing envelope
  *               if bounds lie outside of first input parameter
  *
  * @return
  * 3D envelope as diagonal cutting plane inside the 3D bounding box formed by
  * the two input envelopes consisting of 5 points (GTYPE:3003, ETYPE:1003)
  ******************************************************************/
  FUNCTION update_bounds(
    old_box SDO_GEOMETRY,
    new_box SDO_GEOMETRY
    ) RETURN SDO_GEOMETRY
  IS
    updated_box SDO_GEOMETRY;
    db_srid NUMBER;
  BEGIN
    IF old_box IS NULL AND new_box IS NULL THEN
      RETURN NULL;
    ELSE
      IF old_box IS NULL THEN
        RETURN new_box;
      END IF;

      IF new_box IS NULL THEN
        RETURN old_box;
      END IF;

      -- get reference system of input geometry
      IF old_box.sdo_srid IS NULL THEN
        SELECT srid INTO db_srid FROM database_srs;
      ELSE
        db_srid := old_box.sdo_srid;
      END IF;

      updated_box := MDSYS.SDO_GEOMETRY(3003,db_srid,NULL,MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1),MDSYS.SDO_ORDINATE_ARRAY(
        -- first point
        CASE WHEN old_box.sdo_ordinates(1) < new_box.sdo_ordinates(1) THEN old_box.sdo_ordinates(1) ELSE new_box.sdo_ordinates(1) END,
        CASE WHEN old_box.sdo_ordinates(2) < new_box.sdo_ordinates(2) THEN old_box.sdo_ordinates(2) ELSE new_box.sdo_ordinates(2) END,
        CASE WHEN old_box.sdo_ordinates(3) < new_box.sdo_ordinates(3) THEN old_box.sdo_ordinates(3) ELSE new_box.sdo_ordinates(3) END,
        -- second point
        CASE WHEN old_box.sdo_ordinates(4) > new_box.sdo_ordinates(4) THEN old_box.sdo_ordinates(4) ELSE new_box.sdo_ordinates(4) END,
        CASE WHEN old_box.sdo_ordinates(5) < new_box.sdo_ordinates(5) THEN old_box.sdo_ordinates(5) ELSE new_box.sdo_ordinates(5) END,
        CASE WHEN old_box.sdo_ordinates(6) < new_box.sdo_ordinates(6) THEN old_box.sdo_ordinates(6) ELSE new_box.sdo_ordinates(6) END,
        -- third point
        CASE WHEN old_box.sdo_ordinates(7) > new_box.sdo_ordinates(7) THEN old_box.sdo_ordinates(7) ELSE new_box.sdo_ordinates(7) END,
        CASE WHEN old_box.sdo_ordinates(8) > new_box.sdo_ordinates(8) THEN old_box.sdo_ordinates(8) ELSE new_box.sdo_ordinates(8) END,
        CASE WHEN old_box.sdo_ordinates(9) > new_box.sdo_ordinates(9) THEN old_box.sdo_ordinates(9) ELSE new_box.sdo_ordinates(9) END,
        -- fourth point
        CASE WHEN old_box.sdo_ordinates(10) < new_box.sdo_ordinates(10) THEN old_box.sdo_ordinates(10) ELSE new_box.sdo_ordinates(10) END,
        CASE WHEN old_box.sdo_ordinates(11) > new_box.sdo_ordinates(11) THEN old_box.sdo_ordinates(11) ELSE new_box.sdo_ordinates(11) END,
        CASE WHEN old_box.sdo_ordinates(12) > new_box.sdo_ordinates(12) THEN old_box.sdo_ordinates(12) ELSE new_box.sdo_ordinates(12) END,
        -- fifth point
        CASE WHEN old_box.sdo_ordinates(13) < new_box.sdo_ordinates(13) THEN old_box.sdo_ordinates(13) ELSE new_box.sdo_ordinates(13) END,
        CASE WHEN old_box.sdo_ordinates(14) < new_box.sdo_ordinates(14) THEN old_box.sdo_ordinates(14) ELSE new_box.sdo_ordinates(14) END,
        CASE WHEN old_box.sdo_ordinates(15) < new_box.sdo_ordinates(15) THEN old_box.sdo_ordinates(15) ELSE new_box.sdo_ordinates(15) END
        ));
    END IF;

    RETURN updated_box;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "citydb_envelope.update_bounds": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_implicit_geometry
  *
  * returns the envelope of a given implicit geometry
  *
  * @param            @description
  * implicit_rep_id   identifier of implicit geometry
  * ref_pt            reference point to place geometry
  * transform4x4      transformation to apply against geometry
  *
  * @return
  * 3D envelope as diagonal cutting plane consisting of 5 points
  ******************************************************************/
  FUNCTION get_envelope_implicit_geometry(
    implicit_rep_id NUMBER,
    ref_pt SDO_GEOMETRY,
    transform4x4 VARCHAR2
  ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    params ID_ARRAY;
    matrix_ex EXCEPTION;
  BEGIN
    -- calculate bounding box for implicit geometry
    WITH collect_geom AS (
      -- relative other geometry
      SELECT
        relative_other_geom AS geom
      FROM
        implicit_geometry
      WHERE
        id = implicit_rep_id
        AND relative_other_geom IS NOT NULL
      UNION ALL
      -- relative brep geometry
      SELECT
        sg.implicit_geometry AS geom
      FROM
        surface_geometry sg,
        implicit_geometry ig 
      WHERE
        sg.root_id = ig.relative_brep_id
        AND ig.id = implicit_rep_id
        AND sg.implicit_geometry IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF transform4x4 IS NOT NULL THEN
      -- extract parameters of transformation matrix
      params := citydb_util.string2id_array(transform4x4, ' ');
      
      IF params.count < 12 THEN
        RAISE matrix_ex;
      END IF;
    ELSE
      params := ID_ARRAY(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1);
    END IF;
    
    IF ref_pt IS NOT NULL THEN
      params(4) := params(4) + ref_pt.sdo_point.x;
      params(8) := params(8) + ref_pt.sdo_point.y;
      params(12) := params(12) + ref_pt.sdo_point.z;
    END IF;
      
    IF bbox IS NOT NULL THEN
      bbox := citydb_util.st_affine(
        bbox,
        params(1), params(2), params(3),
        params(5), params(6), params(7),
        params(9), params(10), params(11),
        params(4), params(8), params(12));
    END IF;
    
    RETURN bbox;

    EXCEPTION
      WHEN matrix_ex THEN
        dbms_output.put_line('Malformed transformation matrix: ' || transform4x4 || '. 16 values are required.');
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_implicit_geometry": ' || SQLERRM);
  END;


  /*
    PRIVATE FUNCTIONS (part of get_envelope API)
  */
  /*****************************************************************
  * get_envelope_land_use
  *
  * returns the envelope of a given land use
  *
  * @param        @description
  * co_id         identifier for land use
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of land use
  ******************************************************************/
  FUNCTION get_envelope_land_use(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_land_use": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_generic_cityobj
  *
  * returns the envelope of a given generic city object
  *
  * @param        @description
  * co_id         identifier for generic city object
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of generic city object
  ******************************************************************/
  FUNCTION get_envelope_generic_cityobj(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod0_implicit_rep_id, lod0_implicit_ref_point, lod0_implicit_transformation) AS geom 
          FROM generic_cityobject WHERE id = co_id AND lod0_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod1 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom 
          FROM generic_cityobject WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod2 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM generic_cityobject WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM generic_cityobject WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM generic_cityobject WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_generic_cityobj": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_solitary_veg_obj
  *
  * returns the envelope of a given solitary vegetation object
  *
  * @param        @description
  * co_id         identifier for solitary vegetation object
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of solitary vegetation object
  ******************************************************************/
  FUNCTION get_envelope_solitary_veg_obj(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom 
          FROM solitary_vegetat_object WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod2 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM solitary_vegetat_object WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM solitary_vegetat_object WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM solitary_vegetat_object WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_solitary_veg_obj": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_plant_cover
  *
  * returns the envelope of a given plant cover
  *
  * @param        @description
  * co_id         identifier for plant cover
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of plant cover
  ******************************************************************/
  FUNCTION get_envelope_plant_cover(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_plant_cover": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_waterbody
  *
  * returns the envelope of a given water body
  *
  * @param        @description
  * co_id         identifier for water body
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of water body
  ******************************************************************/
  FUNCTION get_envelope_waterbody(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- water boundary surfaces
      OPEN nested_feat_cur FOR
        SELECT
          id
        FROM
          waterboundary_surface wbs,
          waterbod_to_waterbnd_srf wb2wbs
        WHERE
          wbs.id = wb2wbs.waterboundary_surface_id
          AND wb2wbs.waterbody_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_waterbnd_surface(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- water body
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_waterbnd_surface(
              wbs.id, 0
            )
          ))
        )
      INTO
        bbox
      FROM
        waterboundary_surface wbs,
        waterbod_to_waterbnd_srf wb2wbs
      WHERE
        wbs.id = wb2wbs.waterboundary_surface_id
        AND wb2wbs.waterbody_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_waterbody": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_waterbnd_surface
  *
  * returns the envelope of a given water boundary surface
  *
  * @param        @description
  * co_id         identifier for water boundary surface
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of water boundary surface
  ******************************************************************/
  FUNCTION get_envelope_waterbnd_surface(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
       dbms_output.put_line('An error occurred when executing function "get_envelope_waterbnd_surface": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_relief_feature
  *
  * returns the envelope of a given relief feature
  *
  * @param        @description
  * co_id         identifier for relief feature
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of relief feature
  ******************************************************************/
  FUNCTION get_envelope_relief_feature(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    relief_component_cur ref_cursor;
    relief_component_rec relief_component%rowtype;
  BEGIN
    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      -- relief components
      OPEN relief_component_cur FOR
        SELECT
          rc.*
        FROM
          relief_component rc,
          relief_feat_to_rel_comp rf2rc 
        WHERE
          rc.id = rf2rc.relief_component_id
          AND rf2rc.relief_feature_id = co_id;
      LOOP
        FETCH relief_component_cur INTO relief_component_rec;
        EXIT WHEN relief_component_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_relief_component(relief_component_rec.id, relief_component_rec.objectclass_id, set_envelope));
      END LOOP;
      CLOSE relief_component_cur;

      -- relief feature
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_relief_component(
              rc.id, rc.objectclass_id, 0
            )
          ))
        )
      INTO
        bbox
      FROM
        relief_component rc,
        relief_feat_to_rel_comp rf2rc 
      WHERE
        rc.id = rf2rc.relief_component_id
        AND rf2rc.relief_feature_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_relief_feature": ' || SQLERRM);
        RETURN NULL;
  END;


  /*****************************************************************
  * get_envelope_relief_component
  *
  * returns the envelope of a given relief component
  *
  * @param        @description
  * co_id         identifier for relief component
  * objclass_id   objectclass of city object
  * set_envelope  if 1 (default = 0) the envelope column is updated

  *
  * @return
  * aggregated envelope geometry of relief component
  ******************************************************************/
  FUNCTION get_envelope_relief_component(
    co_id NUMBER,
    objclass_id NUMBER,
    set_envelope int := 0

    ) RETURN SDO_GEOMETRY
  IS
    class_id NUMBER;
    bbox SDO_GEOMETRY;
    grid_id NUMBER;
  BEGIN
    -- fetching class_id if it is NULL
    IF objclass_id IS NULL THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        cityobject
      WHERE
        id = co_id;
    ELSE
      class_id := objclass_id;
    END IF;

    CASE 
      WHEN class_id = 16 THEN 
        BEGIN
          -- get spatial extent of TIN relief
          SELECT
            citydb_envelope.box2envelope(SDO_AGGR_MBR(sg.geometry))
          INTO
            bbox
          FROM
            surface_geometry sg,
            tin_relief tin
          WHERE
            tin.surface_geometry_id = sg.root_id
            AND tin.id = co_id
            AND sg.geometry IS NOT NULL;

          EXCEPTION
            WHEN OTHERS THEN
              bbox := NULL;
        END;
      WHEN class_id = 17 THEN
        BEGIN
          -- get spatial extent of masspoint relief
          SELECT
            citydb_envelope.box2envelope(SDO_AGGR_MBR(relief_points))
          INTO
            bbox
          FROM
            masspoint_relief
          WHERE
            id = co_id;

          EXCEPTION
            WHEN OTHERS THEN
              bbox := NULL;
        END;
      WHEN class_id = 18 THEN
        BEGIN
          -- get spatial extent of breakline relief taking a union of ridge, valley and break lines
          SELECT
            citydb_envelope.box2envelope(SDO_AGGR_MBR(
              SDO_GEOM.SDO_UNION(
                SDO_AGGR_MBR(ridge_or_valley_lines),
                SDO_AGGR_MBR(break_lines),
                0.001
              )
            ))
          INTO
            bbox
          FROM
            breakline_relief
          WHERE
            id = co_id;

          EXCEPTION
            WHEN OTHERS THEN
              bbox := NULL;
        END;
      WHEN class_id = 19 THEN
        BEGIN
          -- get spatial extent of raster relief
          SELECT
            gc.id,
            citydb_envelope.box2envelope(SDO_AGGR_MBR(
              gc.rasterproperty.spatialExtent
            ))
          INTO
            grid_id,
            bbox
          FROM
            grid_coverage gc,
            raster_relief rast 
          WHERE
            rast.coverage_id = gc.id
            AND rast.id = co_id;

          EXCEPTION
            WHEN OTHERS THEN
              BEGIN
                -- generate spatial extent of raster relief
                UPDATE
                  grid_coverage gc
                SET
                  gc.rasterproperty.spatialExtent = sdo_geor.generateSpatialExtent(gc.rasterproperty) 
                WHERE
                  gc.id = grid_id;

                SELECT
                  citydb_envelope.box2envelope(SDO_AGGR_MBR(gc.rasterproperty.spatialExtent))
                INTO
                  bbox
                FROM
                  grid_coverage gc
                WHERE
                  id = grid_id;

                EXCEPTION
                  WHEN OTHERS THEN
                    bbox := NULL;
              END;
        END;
      END CASE;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      -- update envelope column of cityobject table
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_relief_component": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_city_furniture
  *
  * returns the envelope of a given generic city object
  *
  * @param        @description
  * co_id         identifier for city furniture
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of city furniture
  ******************************************************************/
  FUNCTION get_envelope_city_furniture(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom 
          FROM city_furniture WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod2 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM city_furniture WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM city_furniture WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM city_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_city_furniture": ' || SQLERRM);
  END;


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
  *
  * @return
  * aggregated envelope geometry of city object group
  ******************************************************************/
  FUNCTION get_envelope_cityobjectgroup(
    co_id NUMBER,
    set_envelope int := 0,
    calc_member_envelopes int := 1
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    cityobject_cur ref_cursor;
    cityobject_rec cityobject%rowtype;
    parent_id NUMBER;
    dummy_box SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- cityobjectgroup geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- other geometry
        SELECT other_geom AS geom FROM cityobjectgroup WHERE id = co_id AND other_geom IS NOT NULL  
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF calc_member_envelopes <> 0 THEN
      IF set_envelope <> 0 THEN
        OPEN cityobject_cur FOR
          SELECT
            co.*
          FROM
            cityobject co,
            group_to_cityobject g2co 
          WHERE
            co.id = g2co.cityobject_id
            AND g2co.cityobjectgroup_id = co_id;
        LOOP
          FETCH cityobject_cur INTO cityobject_rec;
          EXIT WHEN cityobject_cur%notfound;
          bbox := update_bounds(bbox, get_envelope_cityobject(cityobject_rec.id, cityobject_rec.objectclass_id, set_envelope));
        END LOOP;
        CLOSE cityobject_cur;
      ELSE
        SELECT
          citydb_envelope.update_bounds(
            bbox,
            citydb_envelope.box2envelope(SDO_AGGR_MBR(
              citydb_envelope.get_envelope_cityobject(
                co.id, co.objectclass_id, 0
              )
            ))
          )
        INTO
          bbox
        FROM
          cityobject co,
          group_to_cityobject g2co 
        WHERE
          co.id = g2co.cityobject_id
          AND g2co.cityobjectgroup_id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(co.envelope))
        )
      INTO
        bbox
      FROM
        cityobject co,
        group_to_cityobject g2co 
      WHERE
        co.id = g2co.cityobject_id
        AND g2co.cityobjectgroup_id = co_id;
    END IF;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;

      -- group parent  
      SELECT
        parent_cityobject_id
      INTO
        parent_id
      FROM
        cityobjectgroup
      WHERE
        id = co_id;
		   
      dummy_box := get_envelope_cityobjectgroup(parent_id, set_envelope, calc_member_envelopes);
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_cityobjectgroup": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_building
  *
  * returns the envelope of a given building
  *
  * @param        @description
  * co_id         identifier for building
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of building
  ******************************************************************/
  FUNCTION get_envelope_building(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- update building part envelopes
      OPEN nested_feat_cur FOR
        SELECT id FROM building WHERE building_root_id = co_id AND building_parent_id IS NOT NULL;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_building(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- thematic surface envelopes
      OPEN nested_feat_cur FOR
        SELECT id FROM thematic_surface WHERE building_id = co_id AND objectclass_id IN (33, 34, 35, 36, 60, 61);
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_thematic_surface(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- outer building installation
      OPEN nested_feat_cur FOR
        SELECT id FROM building_installation WHERE building_id = co_id AND objectclass_id = 27;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_building_inst(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- building
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;

      -- interior rooms
      OPEN nested_feat_cur FOR
        SELECT id FROM room WHERE building_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_room(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;

      -- interior thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM thematic_surface WHERE building_id = co_id AND objectclass_id IN (30, 31, 32);
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_thematic_surface(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;

      -- interior building installations
      OPEN nested_feat_cur FOR
        SELECT id FROM building_installation WHERE building_id = co_id AND objectclass_id = 28;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_building_inst(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;
    ELSE
      WITH collect_geom AS (
        -- building part geometry
          SELECT citydb_envelope.get_envelope_building(id, 0) AS geom
            FROM building WHERE building_root_id = co_id AND building_parent_id IS NOT NULL
        UNION ALL
        -- building thematic surface geometry
          SELECT citydb_envelope.get_envelope_thematic_surface(id, 0) AS geom 
            FROM thematic_surface WHERE building_id = co_id AND objectclass_id IN (33, 34, 35, 36, 60, 61)
        UNION ALL
        -- building installation geometry
          SELECT citydb_envelope.get_envelope_building_inst(id, 0) AS geom 
            FROM building_installation WHERE building_id = co_id AND objectclass_id = 27
      )
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
        )
      INTO
        bbox
      FROM
        collect_geom;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_building": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_building_inst
  *
  * returns the envelope of a given building installation
  *
  * @param        @description
  * co_id         identifier for building installation
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of building installation
  ******************************************************************/
  FUNCTION get_envelope_building_inst(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM building_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM building_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM building_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM thematic_surface WHERE building_installation_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_thematic_surface(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- building installation
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_thematic_surface(id, 0)
          ))
        )
      INTO
        bbox
      FROM
        thematic_surface
      WHERE
        building_installation_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_building_inst": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_thematic_surface
  *
  * returns the envelope of a given thematic surface
  *
  * @param        @description
  * co_id         identifier for thematic surface
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of thematic surface
  ******************************************************************/
  FUNCTION get_envelope_thematic_surface(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- openings
      OPEN nested_feat_cur FOR
        SELECT
          id
        FROM
          opening o,
          opening_to_them_surface o2ts
        WHERE
          o.id = o2ts.opening_id
          AND o2ts.thematic_surface_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_opening(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- thematic surface
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_opening(o.id, 0)
          ))
        )
      INTO
        bbox
      FROM
        opening o,
        opening_to_them_surface o2ts
      WHERE
        o.id = o2ts.opening_id
        AND o2ts.thematic_surface_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_thematic_surface": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_opening
  *
  * returns the envelope of a given opening
  *
  * @param        @description
  * co_id         identifier for opening
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of opening
  ******************************************************************/
  FUNCTION get_envelope_opening(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- opening geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_opening": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_building_furn
  *
  * returns the envelope of a given building furniture
  *
  * @param        @description
  * co_id         identifier for building furniture
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of building furniture
  ******************************************************************/
  FUNCTION get_envelope_building_furn(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- building furniture geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- lod4 other geometry
        SELECT lod4_other_geom AS geom FROM building_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM building_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_building_furn": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_room
  *
  * returns the envelope of a given room
  *
  * @param        @description
  * co_id         identifier for room
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of room
  ******************************************************************/
  FUNCTION get_envelope_room(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM thematic_surface WHERE room_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_thematic_surface(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- room installation
      OPEN nested_feat_cur FOR
        SELECT id FROM building_installation WHERE room_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_building_inst(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- building furniture
      OPEN nested_feat_cur FOR
        SELECT id FROM building_furniture WHERE room_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_building_furn(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- room
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      WITH collect_geom AS (
        -- interior thematic surface geometry
          SELECT citydb_envelope.get_envelope_thematic_surface(id, 0) AS geom 
            FROM thematic_surface WHERE room_id = co_id
        UNION ALL
        -- room installation geometry
          SELECT citydb_envelope.get_envelope_building_inst(id, 0) AS geom 
            FROM building_installation WHERE room_id = co_id
        UNION ALL
        -- building furniture geometry
          SELECT citydb_envelope.get_envelope_building_furn(id, 0) AS geom
            FROM building_furniture WHERE room_id = co_id
      )
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
        )
      INTO
        bbox
      FROM
        collect_geom;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_room": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_trans_complex
  *
  * returns the envelope of a given transportation complex
  *
  * @param        @description
  * co_id         identifier for transportation complex
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of transportation complex
  ******************************************************************/
  FUNCTION get_envelope_trans_complex(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    WITH collect_geom AS (
      -- lod0 road network geometry of transportation complex
        SELECT lod0_network AS geom FROM transportation_complex WHERE id = co_id AND lod0_network IS NOT NULL
      UNION ALL
      -- transportation complex geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 THEN
      -- traffic areas
      OPEN nested_feat_cur FOR
        SELECT id FROM traffic_area WHERE transportation_complex_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_traffic_area(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- transportation complex
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_traffic_area(id, 0)
          ))
        )
      INTO
        bbox
      FROM
        traffic_area
      WHERE
        transportation_complex_id = co_id;

    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_trans_complex": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_traffic_area
  *
  * returns the envelope of a given traffic area
  *
  * @param        @description
  * co_id         identifier for traffic area
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of traffic area
  ******************************************************************/
  FUNCTION get_envelope_traffic_area(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_traffic_area": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge
  *
  * returns the envelope of a given bridge
  *
  * @param        @description
  * co_id         identifier for bridge
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of bridge
  ******************************************************************/
  FUNCTION get_envelope_bridge(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- update bridge part envelopes
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge WHERE bridge_root_id = co_id AND bridge_parent_id IS NOT NULL;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- thematic surface envelopes
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_thematic_surface WHERE bridge_id = co_id AND objectclass_id IN (71, 72, 73, 74, 75, 76);
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- outer bridge installation
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_installation WHERE bridge_id = co_id AND objectclass_id = 65;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_inst(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge construction element
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_constr_element WHERE bridge_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_const_elem(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;

      -- interior bridge_rooms
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_room WHERE bridge_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_bridge_room(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;

      -- interior thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_thematic_surface WHERE bridge_id = co_id AND objectclass_id IN (68, 69, 70);
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_bridge_them_srf(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;

      -- interior bridge installations
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_installation WHERE bridge_id = co_id AND objectclass_id = 66;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_bridge_inst(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;
    ELSE
      WITH collect_geom AS (
        -- bridge part geometry
          SELECT citydb_envelope.get_envelope_bridge(id, 0) AS geom
            FROM bridge WHERE bridge_root_id = co_id AND bridge_parent_id IS NOT NULL
        UNION ALL
        -- bridge thematic surface geometry
          SELECT citydb_envelope.get_envelope_bridge_them_srf(id, 0) AS geom 
            FROM bridge_thematic_surface WHERE bridge_id = co_id AND objectclass_id IN (71, 72, 73, 74, 75, 76)
        UNION ALL
        -- bridge installation geometry
          SELECT citydb_envelope.get_envelope_bridge_inst(id, 0) AS geom 
            FROM bridge_installation WHERE bridge_id = co_id AND objectclass_id = 66
        UNION ALL
        -- bridge construction element geometry
          SELECT citydb_envelope.get_envelope_bridge_const_elem(id, 0) AS geom 
            FROM bridge_installation WHERE bridge_id = co_id
      )
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
        )
      INTO
        bbox
      FROM
        collect_geom;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge_inst
  *
  * returns the envelope of a given bridge installation
  *
  * @param        @description
  * co_id         identifier for bridge installation
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of bridge installation
  ******************************************************************/
  FUNCTION get_envelope_bridge_inst(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM bridge_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM bridge_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM bridge_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_thematic_surface WHERE bridge_installation_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge installation
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      -- thematic surface geometry
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_bridge_them_srf(id, 0)
          ))
        )
      INTO
        bbox
      FROM
        bridge_thematic_surface
      WHERE
        bridge_installation_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge_inst": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge_them_srf
  *
  * returns the envelope of a given thematic surface
  *
  * @param        @description
  * co_id         identifier for thematic surface
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of thematic surface
  ******************************************************************/
  FUNCTION get_envelope_bridge_them_srf(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- bridge_openings
      OPEN nested_feat_cur FOR
        SELECT
          id
        FROM
          bridge_opening o,
          bridge_open_to_them_srf o2ts
        WHERE
          o.id = o2ts.bridge_opening_id
          AND o2ts.bridge_thematic_surface_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_opening(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- thematic surface
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_bridge_opening(o.id, 0)
          ))
        )
      INTO
        bbox
      FROM
        bridge_opening o,
        bridge_open_to_them_srf o2ts
      WHERE
        o.id = o2ts.bridge_opening_id
        AND o2ts.bridge_thematic_surface_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge_them_srf": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge_opening
  *
  * returns the envelope of a given bridge opening
  *
  * @param        @description
  * co_id         identifier for bridge opening
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of bridge opening
  ******************************************************************/
  FUNCTION get_envelope_bridge_opening(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- bridge opening geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM bridge_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM bridge_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge_opening": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge_furniture
  *
  * returns the envelope of a given bridge furniture
  *
  * @param        @description
  * co_id         identifier for bridge furniture
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of bridge furniture
  ******************************************************************/
  FUNCTION get_envelope_bridge_furniture(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- bridge furniture geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- lod4 other geometry
        SELECT lod4_other_geom AS geom FROM bridge_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM bridge_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge_furniture": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge_room
  *
  * returns the envelope of a given bridge room
  *
  * @param        @description
  * co_id         identifier for bridge room
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of bridge room
  ******************************************************************/
  FUNCTION get_envelope_bridge_room(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_thematic_surface WHERE bridge_room_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge_room installation
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_installation WHERE bridge_room_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_inst(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge furniture
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_furniture WHERE bridge_room_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_furniture(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge_room
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      WITH collect_geom AS (
        -- interior thematic surface geometry
          SELECT citydb_envelope.get_envelope_bridge_them_srf(id, 0) AS geom 
            FROM bridge_thematic_surface WHERE bridge_room_id = co_id
        UNION ALL
        -- bridge_room installation geometry
          SELECT citydb_envelope.get_envelope_bridge_inst(id, 0) AS geom 
            FROM bridge_installation WHERE bridge_room_id = co_id
        UNION ALL
        -- bridge furniture geometry
          SELECT citydb_envelope.get_envelope_bridge_furniture(id, 0) AS geom
            FROM bridge_furniture WHERE bridge_room_id = co_id
      )
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
        )
      INTO
        bbox
      FROM
        collect_geom;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge_room": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_bridge_const_elem
  *
  * returns the envelope of a given bridge construction element
  *
  * @param        @description
  * co_id         identifier for bridge construction element
  * set_envelope  if 1 (default = 0) the envelope column is updated

  *
  * @return
  * aggregated envelope geometry of bridge construction element
  ******************************************************************/
  FUNCTION get_envelope_bridge_const_elem(
    co_id NUMBER,
    set_envelope int := 0

    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom 
          FROM bridge_constr_element WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod2 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM bridge_constr_element WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM bridge_constr_element WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM bridge_constr_element WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM bridge_thematic_surface WHERE bridge_constr_element_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_bridge_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- bridge construction element
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      -- thematic surface geometry
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_bridge_them_srf(id, 0)
          ))
        )
      INTO
        bbox
      FROM
        bridge_thematic_surface
      WHERE
        bridge_constr_element_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_bridge_const_elem": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_tunnel
  *
  * returns the envelope of a given tunnel
  *
  * @param        @description
  * co_id         identifier for tunnel
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of tunnel
  ******************************************************************/
  FUNCTION get_envelope_tunnel(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- update tunnel part envelopes
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel WHERE tunnel_root_id = co_id AND tunnel_parent_id IS NOT NULL;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- thematic surface envelopes
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_thematic_surface WHERE tunnel_id = co_id AND objectclass_id IN (92, 93, 94, 95, 96, 97);
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- outer tunnel installation
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_installation WHERE tunnel_id = co_id AND objectclass_id = 86;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_inst(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- tunnel
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;

      -- interior hollow spaces
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_hollow_space WHERE tunnel_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_tunnel_hspace(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;

      -- interior thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_thematic_surface WHERE tunnel_id = co_id AND objectclass_id IN (89, 90, 91);
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_tunnel_them_srf(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;

      -- interior tunnel installations
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_installation WHERE tunnel_id = co_id AND objectclass_id = 87;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        dummy_box := get_envelope_tunnel_inst(nested_feat_id, set_envelope);
      END LOOP;
      CLOSE nested_feat_cur;
    ELSE
      WITH collect_geom AS (
        -- tunnel part geometry
          SELECT citydb_envelope.get_envelope_tunnel(id, 0) AS geom
            FROM tunnel WHERE tunnel_root_id = co_id AND tunnel_parent_id IS NOT NULL
        UNION ALL
        -- tunnel thematic surface geometry
          SELECT citydb_envelope.get_envelope_tunnel_them_srf(id, 0) AS geom 
            FROM tunnel_thematic_surface WHERE tunnel_id = co_id AND objectclass_id IN (92, 93, 94, 95, 96, 97)
        UNION ALL
        -- tunnel installation geometry
          SELECT citydb_envelope.get_envelope_tunnel_inst(id, 0) AS geom 
            FROM tunnel_installation WHERE tunnel_id = co_id AND objectclass_id = 86
      )
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
        )
      INTO
        bbox
      FROM
        collect_geom;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_tunnel": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_tunnel_inst
  *
  * returns the envelope of a given tunnel installation
  *
  * @param        @description
  * co_id         identifier for tunnel installation
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of tunnel installation
  ******************************************************************/
  FUNCTION get_envelope_tunnel_inst(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
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
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom 
          FROM tunnel_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM tunnel_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM tunnel_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_thematic_surface WHERE tunnel_installation_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- tunnel installation
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      -- thematic surface geometry
      SELECT
        citydb_envelope.update_bounds(
        bbox,
        citydb_envelope.box2envelope(SDO_AGGR_MBR(
          citydb_envelope.get_envelope_tunnel_them_srf(id, 0)
          ))
        )
      INTO
        bbox
      FROM
        tunnel_thematic_surface
      WHERE
        tunnel_installation_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_tunnel_inst": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_tunnel_them_srf
  *
  * returns the envelope of a given thematic surface
  *
  * @param        @description
  * co_id         identifier for thematic surface
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of thematic surface
  ******************************************************************/
  FUNCTION get_envelope_tunnel_them_srf(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
 
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- tunnel_openings
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_opening o, tunnel_open_to_them_srf o2ts
                                  WHERE o.id = o2ts.tunnel_opening_id AND o2ts.tunnel_thematic_surface_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_opening(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- thematic surface
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(
            citydb_envelope.get_envelope_tunnel_opening(o.id, 0)
          ))
        )
      INTO
        bbox
      FROM
        tunnel_opening o,
        tunnel_open_to_them_srf o2ts
      WHERE
        o.id = o2ts.tunnel_opening_id
        AND o2ts.tunnel_thematic_surface_id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_tunnel_them_srf": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_tunnel_opening
  *
  * returns the envelope of a given tunnel opening
  *
  * @param        @description
  * co_id         identifier for tunnel opening
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of tunnel opening
  ******************************************************************/
  FUNCTION get_envelope_tunnel_opening(
    co_id NUMBER,
    set_envelope int := 0

    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- tunnel opening geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- lod3 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom 
          FROM tunnel_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM tunnel_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_tunnel_opening": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_tunnel_furniture
  *
  * returns the envelope of a given tunnel furniture
  *
  * @param        @description
  * co_id         identifier for tunnel furniture
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of tunnel furniture
  ******************************************************************/
  FUNCTION get_envelope_tunnel_furniture(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
  BEGIN
    WITH collect_geom AS (
      -- tunnel furniture geometry
        SELECT geometry AS geom FROM surface_geometry WHERE cityobject_id = co_id AND geometry IS NOT NULL
      UNION ALL
      -- lod4 other geometry
        SELECT lod4_other_geom AS geom FROM tunnel_furniture WHERE id = co_id AND lod4_other_geom IS NOT NULL
      UNION ALL
      -- lod4 implicit geometry
        SELECT citydb_envelope.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom 
          FROM tunnel_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE
        cityobject
      SET
        envelope = bbox
      WHERE
        id = co_id;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_tunnel_furniture": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_tunnel_hspace
  *
  * returns the envelope of a given tunnel hollow space
  *
  * @param        @description
  * co_id         identifier for tunnel hollow space
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of tunnel hollow space
  ******************************************************************/
  FUNCTION get_envelope_tunnel_hspace(
    co_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    SELECT
      citydb_envelope.box2envelope(SDO_AGGR_MBR(geometry))
    INTO
      bbox
    FROM
      surface_geometry
    WHERE
      cityobject_id = co_id
      AND geometry IS NOT NULL;

    IF set_envelope <> 0 THEN
      -- thematic surfaces
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_thematic_surface WHERE tunnel_hollow_space_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_them_srf(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- hollow space installation
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_installation WHERE tunnel_hollow_space_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_inst(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- tunnel furniture
      OPEN nested_feat_cur FOR
        SELECT id FROM tunnel_furniture WHERE tunnel_hollow_space_id = co_id;
      LOOP
        FETCH nested_feat_cur INTO nested_feat_id;
        EXIT WHEN nested_feat_cur%notfound;
        bbox := update_bounds(bbox, get_envelope_tunnel_furniture(nested_feat_id, set_envelope));
      END LOOP;
      CLOSE nested_feat_cur;

      -- hollow space
      IF bbox IS NOT NULL THEN
        UPDATE
          cityobject
        SET
          envelope = bbox
        WHERE
          id = co_id;
      END IF;
    ELSE
      WITH collect_geom AS (
        -- interior thematic surface geometry
          SELECT citydb_envelope.get_envelope_tunnel_them_srf(id, 0) AS geom 
            FROM tunnel_thematic_surface WHERE tunnel_hollow_space_id = co_id
        UNION ALL
        -- hollow space installation geometry
          SELECT citydb_envelope.get_envelope_tunnel_inst(id, 0) AS geom 
            FROM tunnel_installation WHERE tunnel_hollow_space_id = co_id
        UNION ALL
        -- tunnel furniture geometry
          SELECT citydb_envelope.get_envelope_tunnel_furniture(id, 0) AS geom
            FROM tunnel_furniture WHERE tunnel_hollow_space_id = co_id
      )
      SELECT
        citydb_envelope.update_bounds(
          bbox,
          citydb_envelope.box2envelope(SDO_AGGR_MBR(geom))
        )
      INTO
        bbox
      FROM
        collect_geom;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_tunnel_hspace": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_cityobject
  *
  * RETURN the envelope of a given city object
  *
  * @param        @description
  * co_id         identifier for city object
  * objclass_id   objectclass of city object
  * set_envelope  if 1 (default = 0) the envelope column is updated
  *
  * @return
  * aggregated envelope geometry of city object
  ******************************************************************/
  FUNCTION get_envelope_cityobject(
    co_id NUMBER, 
    objclass_id NUMBER,
    set_envelope int := 0
    ) RETURN SDO_GEOMETRY
  IS
    class_id NUMBER := 0;
    bbox SDO_GEOMETRY;
    db_srid NUMBER;
  BEGIN
    -- fetching class_id if it is NULL
    IF objclass_id IS NULL OR objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        cityobject
      WHERE
        id = co_id;
    ELSE
      class_id := objclass_id;
    END IF;

    CASE
      WHEN class_id = 4 THEN bbox := get_envelope_land_use(co_id, set_envelope);
      WHEN class_id = 5 THEN bbox := get_envelope_generic_cityobj(co_id, set_envelope);
      WHEN class_id = 7 THEN bbox := get_envelope_solitary_veg_obj(co_id, set_envelope);
      WHEN class_id = 8 THEN bbox := get_envelope_plant_cover(co_id, set_envelope);
      WHEN class_id = 9 THEN bbox := get_envelope_waterbody(co_id, set_envelope);
      WHEN class_id = 11 OR
           class_id = 12 OR
           class_id = 13 THEN bbox := get_envelope_waterbnd_surface(co_id, set_envelope);
      WHEN class_id = 14 THEN bbox := get_envelope_relief_feature(co_id, set_envelope);
      WHEN class_id = 16 OR
           class_id = 17 OR
           class_id = 18 OR
           class_id = 19 THEN bbox := get_envelope_relief_component(co_id, class_id);
      WHEN class_id = 21 THEN bbox := get_envelope_city_furniture(co_id, set_envelope);
      WHEN class_id = 23 THEN bbox := get_envelope_cityobjectgroup(co_id, set_envelope, 1);
      WHEN class_id = 25 OR
           class_id = 26 THEN bbox := get_envelope_building(co_id, set_envelope);
      WHEN class_id = 27 OR
           class_id = 28 THEN bbox := get_envelope_building_inst(co_id, set_envelope);
      WHEN class_id = 30 OR
           class_id = 31 OR
           class_id = 32 OR
           class_id = 33 OR
           class_id = 34 OR
           class_id = 35 OR
           class_id = 36 OR
           class_id = 60 OR
           class_id = 61 THEN bbox := get_envelope_thematic_surface(co_id, set_envelope);
      WHEN class_id = 38 OR
           class_id = 39 THEN bbox := get_envelope_opening(co_id, set_envelope);
      WHEN class_id = 40 THEN bbox := get_envelope_building_furn(co_id, set_envelope);
      WHEN class_id = 41 THEN bbox := get_envelope_room(co_id, set_envelope);
      WHEN class_id = 43 OR
           class_id = 44 OR
           class_id = 45 OR
           class_id = 46 THEN bbox := get_envelope_trans_complex(co_id, set_envelope);
      WHEN class_id = 47 OR
           class_id = 48 THEN bbox := get_envelope_traffic_area(co_id, set_envelope);
      WHEN class_id = 63 OR
           class_id = 64 THEN bbox := get_envelope_bridge(co_id, set_envelope);
      WHEN class_id = 65 OR
           class_id = 66 THEN bbox := get_envelope_bridge_inst(co_id, set_envelope);
      WHEN class_id = 68 OR
           class_id = 69 OR
           class_id = 70 OR
           class_id = 71 OR
           class_id = 72 OR
           class_id = 73 OR
           class_id = 74 OR
           class_id = 75 OR
           class_id = 76 THEN bbox := get_envelope_bridge_them_srf(co_id, set_envelope);
      WHEN class_id = 78 OR
           class_id = 79 THEN bbox := get_envelope_bridge_opening(co_id, set_envelope);
      WHEN class_id = 80 THEN bbox := get_envelope_bridge_furniture(co_id, set_envelope);
      WHEN class_id = 81 THEN bbox := get_envelope_bridge_room(co_id, set_envelope);
      WHEN class_id = 82 THEN bbox := get_envelope_bridge_const_elem(co_id, set_envelope);
      WHEN class_id = 84 OR
           class_id = 85 THEN bbox := get_envelope_tunnel(co_id, set_envelope);
      WHEN class_id = 86 OR
           class_id = 87 THEN bbox := get_envelope_tunnel_inst(co_id, set_envelope);
      WHEN class_id = 89 OR
           class_id = 90 OR
           class_id = 91 OR
           class_id = 92 OR
           class_id = 93 OR
           class_id = 94 OR
           class_id = 95 OR
           class_id = 96 OR
           class_id = 97 THEN bbox := get_envelope_tunnel_them_srf(co_id, set_envelope);
      WHEN class_id = 99 OR
           class_id = 100 THEN bbox := get_envelope_tunnel_opening(co_id, set_envelope);
      WHEN class_id = 101 THEN bbox := get_envelope_tunnel_furniture(co_id, set_envelope);
      WHEN class_id = 102 THEN bbox := get_envelope_tunnel_hspace(co_id, set_envelope);
    ELSE
      dbms_output.put_line('Can not get envelope of object with ID ' || to_char(co_id) || ' and objectclass_id ' || to_char(class_id) || '.');
    END CASE;

    RETURN bbox;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "get_envelope_cityobject": ' || SQLERRM);
  END;


  /*****************************************************************
  * get_envelope_cityobjects
  *
  * updates envelopes for all city objects of a given objectclass
  *
  * @param        @description
  * objclass_id   if 0 functions runs against every city object
  * set_envelope  if 1 (default = 0) the envelope column is updated
  * only_if_null  if 1 (default) only empty rows of envelope column are updated
  ******************************************************************/
  FUNCTION get_envelope_cityobjects(
    objclass_id NUMBER := 0,
    set_envelope int := 0,
    only_if_null int := 1
    ) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    filter VARCHAR2(150) := '';
    group_filter VARCHAR2(150) := '';
    cityobject_cur ref_cursor;
    cityobject_rec cityobject%rowtype;
    nested_feat_cur ref_cursor;
    nested_feat_id NUMBER;
  BEGIN
    IF only_if_null <> 0 THEN
      filter := ' WHERE envelope IS NULL';
    END IF;

    IF objclass_id <> 0 THEN
      filter := CASE WHEN filter IS NULL THEN ' WHERE ' ELSE filter || ' AND ' END;
      filter := filter || 'objectclass_id = ' || to_char(objclass_id);

      IF set_envelope <> 0 THEN
        OPEN cityobject_cur FOR
          'SELECT * FROM cityobject' || filter;
        LOOP
          FETCH cityobject_cur INTO cityobject_rec;
          EXIT WHEN cityobject_cur%notfound;
          bbox := citydb_envelope.update_bounds(bbox, get_envelope_cityobject(cityobject_rec.id, cityobject_rec.objectclass_id, set_envelope));
        END LOOP;
        CLOSE cityobject_cur;
      ELSE
        EXECUTE IMMEDIATE
          'SELECT citydb_envelope.box2envelope('
          || 'SDO_AGGR_MBR(citydb_envelope.get_envelope_cityobject(id, objectclass_id, 0))'
          || ') FROM cityobject' || filter
          INTO bbox;
      END IF;
    ELSE
      group_filter := CASE WHEN filter IS NULL THEN ' WHERE ' ELSE filter || ' AND ' END;
      group_filter := group_filter || 'objectclass_id = 23';

      filter := CASE WHEN filter IS NULL THEN ' WHERE ' ELSE filter || ' AND ' END;
      filter := filter || 'objectclass_id IN (4, 5, 7, 8, 9, 14, 21, 25, 26, 42, 43, 44, 45, 46, 63, 64, 84, 85)';

      IF set_envelope <> 0 THEN
        -- first: update envelope for each top-level feature not being group
        OPEN cityobject_cur FOR
          'SELECT * FROM cityobject' || filter;
        LOOP
          FETCH cityobject_cur INTO cityobject_rec;
          EXIT WHEN cityobject_cur%notfound;
          bbox := citydb_envelope.update_bounds(bbox, get_envelope_cityobject(cityobject_rec.id, cityobject_rec.objectclass_id, set_envelope));
        END LOOP;
        CLOSE cityobject_cur;

        -- second: work on city object groups
        OPEN nested_feat_cur FOR
          'SELECT id FROM cityobject' || group_filter;
        LOOP
          FETCH nested_feat_cur INTO nested_feat_id;
          EXIT WHEN nested_feat_cur%notfound;
          bbox := citydb_envelope.update_bounds(bbox, get_envelope_cityobjectgroup(nested_feat_id, set_envelope, 0));
        END LOOP;
        CLOSE nested_feat_cur;

        -- third: work on remaining nested features not being groups
        OPEN cityobject_cur FOR
          'SELECT * FROM cityobject WHERE envelope IS NULL AND objectclass_id <> 23';
        LOOP
          FETCH cityobject_cur INTO cityobject_rec;
          EXIT WHEN cityobject_cur%notfound;
          bbox := citydb_envelope.update_bounds(bbox, get_envelope_cityobject(cityobject_rec.id, cityobject_rec.objectclass_id, set_envelope));
        END LOOP;
        CLOSE cityobject_cur;
      ELSE
        EXECUTE IMMEDIATE
          'WITH collect_geom AS (
             -- top-level feature geometry
               SELECT citydb_envelope.get_envelope_cityobject(id, objectclass_id, 0) AS geom
                 FROM cityobject' || filter || '
             UNION ALL
             -- cityobject group
               SELECT citydb_envelope.get_envelope_cityobjectgroup(id, 0, 0) AS geom
                 FROM cityobject' || group_filter || '
             UNION ALL
             -- remaining nested features
               SELECT citydb_envelope.get_envelope_cityobject(id, objectclass_id, 0) AS geom
                 FROM cityobject WHERE envelope IS NULL AND objectclass_id <> 23
           )
           SELECT citydb_envelope.box2envelope(SDO_AGGR_MBR(geom)) AS envelope3d FROM collect_geom'
           INTO bbox;
      END IF;
    END IF;

    RETURN bbox;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('An error occurred when executing function "citydb_envelope.get_envelope_cityobjects": ' || SQLERRM);
  END;

END citydb_envelope;
/