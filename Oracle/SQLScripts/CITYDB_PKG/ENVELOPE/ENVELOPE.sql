-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2018
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

-- Automatically generated database script (Creation Date: 2018-06-15 11:18:38)
-- box2envelope
-- env_address
-- env_appearance
-- env_breakline_relief
-- env_bridge
-- env_bridge_constr_element
-- env_bridge_furniture
-- env_bridge_installation
-- env_bridge_opening
-- env_bridge_room
-- env_bridge_thematic_surface
-- env_building
-- env_building_furniture
-- env_building_installation
-- env_city_furniture
-- env_citymodel
-- env_cityobject
-- env_cityobjectgroup
-- env_generic_cityobject
-- env_implicit_geometry
-- env_land_use
-- env_masspoint_relief
-- env_opening
-- env_plant_cover
-- env_relief_component
-- env_relief_feature
-- env_room
-- env_solitary_vegetat_object
-- env_surface_data
-- env_textureparam
-- env_thematic_surface
-- env_tin_relief
-- env_traffic_area
-- env_transportation_complex
-- env_tunnel
-- env_tunnel_furniture
-- env_tunnel_hollow_space
-- env_tunnel_installation
-- env_tunnel_opening
-- env_tunnel_thematic_surface
-- env_waterbody
-- env_waterboundary_surface
-- get_envelope_cityobjects
-- get_envelope_implicit_geometry
-- update_bounds

------------------------------------------
CREATE OR REPLACE PACKAGE citydb_envelope
AS
  FUNCTION box2envelope(box SDO_GEOMETRY) RETURN SDO_GEOMETRY;
  FUNCTION env_address(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_appearance(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_breakline_relief(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge_constr_element(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge_installation(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge_opening(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge_room(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_bridge_thematic_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_building(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_building_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_building_installation(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_city_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_citymodel(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_cityobject(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_cityobjectgroup(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_generic_cityobject(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_implicit_geometry(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_land_use(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_masspoint_relief(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_opening(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_plant_cover(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_relief_component(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_relief_feature(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_room(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_solitary_vegetat_object(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_surface_data(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_textureparam(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_thematic_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tin_relief(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_traffic_area(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_transportation_complex(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tunnel(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tunnel_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tunnel_hollow_space(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tunnel_installation(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tunnel_opening(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_tunnel_thematic_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_waterbody(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION env_waterboundary_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_cityobjects(objclass_id NUMBER := 0, set_envelope int := 0, only_if_null int := 1) RETURN SDO_GEOMETRY;
  FUNCTION get_envelope_implicit_geometry(implicit_rep_id NUMBER, ref_pt SDO_GEOMETRY, transform4x4 VARCHAR2) RETURN SDO_GEOMETRY;
  FUNCTION update_bounds(old_box SDO_GEOMETRY, new_box SDO_GEOMETRY) RETURN SDO_GEOMETRY;
END citydb_envelope;
/

------------------------------------------
CREATE OR REPLACE PACKAGE BODY citydb_envelope
AS  FUNCTION box2envelope(box SDO_GEOMETRY) RETURN SDO_GEOMETRY
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

  END;
  ------------------------------------------

  FUNCTION env_address(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- multiPoint
      SELECT multi_point AS geom FROM address WHERE id = co_id  AND multi_point IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_appearance(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _SurfaceData
      SELECT c.id FROM surface_data c, appear_to_surface_data p2c WHERE c.id = surface_data_id AND p2c.appearance_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_surface_data(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_breakline_relief(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_relief_component(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- ridgeOrValleyLines
      SELECT ridge_or_valley_lines AS geom FROM breakline_relief WHERE id = co_id  AND ridge_or_valley_lines IS NOT NULL
        UNION ALL
      -- breaklines
      SELECT break_lines AS geom FROM breakline_relief WHERE id = co_id  AND break_lines IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod1Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1TerrainIntersection
      SELECT lod1_terrain_intersection AS geom FROM bridge WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod2Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiCurve
      SELECT lod2_multi_curve AS geom FROM bridge WHERE id = co_id  AND lod2_multi_curve IS NOT NULL
        UNION ALL
      -- lod2TerrainIntersection
      SELECT lod2_terrain_intersection AS geom FROM bridge WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod3Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiCurve
      SELECT lod3_multi_curve AS geom FROM bridge WHERE id = co_id  AND lod3_multi_curve IS NOT NULL
        UNION ALL
      -- lod3TerrainIntersection
      SELECT lod3_terrain_intersection AS geom FROM bridge WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiCurve
      SELECT lod4_multi_curve AS geom FROM bridge WHERE id = co_id  AND lod4_multi_curve IS NOT NULL
        UNION ALL
      -- lod4TerrainIntersection
      SELECT lod4_terrain_intersection AS geom FROM bridge WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- BridgeConstructionElement
      SELECT id FROM bridge_constr_element WHERE bridge_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_constr_element(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- BridgeInstallation
      SELECT id FROM bridge_installation WHERE bridge_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- IntBridgeInstallation
      SELECT id FROM bridge_installation WHERE bridge_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM bridge_thematic_surface WHERE bridge_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- BridgeRoom
      SELECT id FROM bridge_room WHERE bridge_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_room(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- BridgePart
      SELECT id FROM bridge WHERE bridge_parent_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- Address
      SELECT c.id FROM address c, address_to_bridge p2c WHERE c.id = address_id AND p2c.bridge_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_address(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge_constr_element(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod1Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_constr_element t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod1Geometry
      SELECT lod1_other_geom AS geom FROM bridge_constr_element WHERE id = co_id  AND lod1_other_geom IS NOT NULL
        UNION ALL
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_constr_element t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM bridge_constr_element WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_constr_element t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM bridge_constr_element WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_constr_element t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM bridge_constr_element WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod1TerrainIntersection
      SELECT lod1_terrain_intersection AS geom FROM bridge_constr_element WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod2TerrainIntersection
      SELECT lod2_terrain_intersection AS geom FROM bridge_constr_element WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod3TerrainIntersection
      SELECT lod3_terrain_intersection AS geom FROM bridge_constr_element WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod4TerrainIntersection
      SELECT lod4_terrain_intersection AS geom FROM bridge_constr_element WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod1ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM bridge_constr_element WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM bridge_constr_element WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM bridge_constr_element WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM bridge_constr_element WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM bridge_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM bridge_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge_installation(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_installation t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM bridge_installation WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_installation t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM bridge_installation WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM bridge_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM bridge_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM bridge_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM bridge_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM bridge_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM bridge_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM bridge_thematic_surface WHERE bridge_installation_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM bridge_thematic_surface WHERE bridge_installation_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge_opening(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_opening t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_opening t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM bridge_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM bridge_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- Address
      SELECT c.id FROM bridge_opening p, address c WHERE p.id = co_id AND p.address_id = c.id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_address(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge_room(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_room t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_room t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM bridge_thematic_surface WHERE bridge_room_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- BridgeFurniture
      SELECT id FROM bridge_furniture WHERE bridge_room_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_furniture(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- IntBridgeInstallation
      SELECT id FROM bridge_installation WHERE bridge_room_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_bridge_thematic_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_thematic_surface t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_thematic_surface t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, bridge_thematic_surface t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BridgeOpening
      SELECT c.id FROM bridge_opening c, bridge_open_to_them_srf p2c WHERE c.id = bridge_opening_id AND p2c.bridge_thematic_surface_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_bridge_opening(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_building(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod0FootPrint
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod0_footprint_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod0RoofEdge
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod0_roofprint_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1TerrainIntersection
      SELECT lod1_terrain_intersection AS geom FROM building WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod2Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiCurve
      SELECT lod2_multi_curve AS geom FROM building WHERE id = co_id  AND lod2_multi_curve IS NOT NULL
        UNION ALL
      -- lod2TerrainIntersection
      SELECT lod2_terrain_intersection AS geom FROM building WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod3Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiCurve
      SELECT lod3_multi_curve AS geom FROM building WHERE id = co_id  AND lod3_multi_curve IS NOT NULL
        UNION ALL
      -- lod3TerrainIntersection
      SELECT lod3_terrain_intersection AS geom FROM building WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, building t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiCurve
      SELECT lod4_multi_curve AS geom FROM building WHERE id = co_id  AND lod4_multi_curve IS NOT NULL
        UNION ALL
      -- lod4TerrainIntersection
      SELECT lod4_terrain_intersection AS geom FROM building WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- BuildingInstallation
      SELECT id FROM building_installation WHERE building_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_building_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- IntBuildingInstallation
      SELECT id FROM building_installation WHERE building_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_building_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM thematic_surface WHERE building_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- Room
      SELECT id FROM room WHERE building_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_room(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- BuildingPart
      SELECT id FROM building WHERE building_parent_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_building(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- Address
      SELECT c.id FROM address c, address_to_building p2c WHERE c.id = address_id AND p2c.building_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_address(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_building_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, building_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM building_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM building_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_building_installation(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, building_installation t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM building_installation WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, building_installation t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM building_installation WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, building_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM building_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM building_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM building_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM building_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, building_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM building_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM building_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM thematic_surface WHERE building_installation_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM thematic_surface WHERE building_installation_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_city_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod1Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, city_furniture t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod1Geometry
      SELECT lod1_other_geom AS geom FROM city_furniture WHERE id = co_id  AND lod1_other_geom IS NOT NULL
        UNION ALL
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, city_furniture t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM city_furniture WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, city_furniture t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM city_furniture WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, city_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM city_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod1TerrainIntersection
      SELECT lod1_terrain_intersection AS geom FROM city_furniture WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod2TerrainIntersection
      SELECT lod2_terrain_intersection AS geom FROM city_furniture WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod3TerrainIntersection
      SELECT lod3_terrain_intersection AS geom FROM city_furniture WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod4TerrainIntersection
      SELECT lod4_terrain_intersection AS geom FROM city_furniture WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod1ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM city_furniture WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM city_furniture WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM city_furniture WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM city_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_citymodel(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_cityobject(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- boundedBy
      SELECT envelope AS geom FROM cityobject WHERE id = co_id  AND envelope IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- Appearance
      SELECT id FROM appearance WHERE cityobject_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_appearance(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF caller <> 2 THEN
      SELECT objectclass_id INTO class_id FROM cityobject WHERE id = co_id;
      CASE
      -- land_use
      WHEN class_id = 4 THEN
        bbox := update_bounds(bbox, env_land_use(co_id, set_envelope, 1));
      -- generic_cityobject
      WHEN class_id = 5 THEN
        bbox := update_bounds(bbox, env_generic_cityobject(co_id, set_envelope, 1));
      -- solitary_vegetat_object
      WHEN class_id = 7 THEN
        bbox := update_bounds(bbox, env_solitary_vegetat_object(co_id, set_envelope, 1));
      -- plant_cover
      WHEN class_id = 8 THEN
        bbox := update_bounds(bbox, env_plant_cover(co_id, set_envelope, 1));
      -- waterbody
      WHEN class_id = 9 THEN
        bbox := update_bounds(bbox, env_waterbody(co_id, set_envelope, 1));
      -- waterboundary_surface
      WHEN class_id = 10 THEN
        bbox := update_bounds(bbox, env_waterboundary_surface(co_id, set_envelope, 1));
      -- waterboundary_surface
      WHEN class_id = 11 THEN
        bbox := update_bounds(bbox, env_waterboundary_surface(co_id, set_envelope, 1));
      -- waterboundary_surface
      WHEN class_id = 12 THEN
        bbox := update_bounds(bbox, env_waterboundary_surface(co_id, set_envelope, 1));
      -- waterboundary_surface
      WHEN class_id = 13 THEN
        bbox := update_bounds(bbox, env_waterboundary_surface(co_id, set_envelope, 1));
      -- relief_feature
      WHEN class_id = 14 THEN
        bbox := update_bounds(bbox, env_relief_feature(co_id, set_envelope, 1));
      -- relief_component
      WHEN class_id = 15 THEN
        bbox := update_bounds(bbox, env_relief_component(co_id, set_envelope, 1));
      -- tin_relief
      WHEN class_id = 16 THEN
        bbox := update_bounds(bbox, env_tin_relief(co_id, set_envelope, 0));
      -- masspoint_relief
      WHEN class_id = 17 THEN
        bbox := update_bounds(bbox, env_masspoint_relief(co_id, set_envelope, 0));
      -- breakline_relief
      WHEN class_id = 18 THEN
        bbox := update_bounds(bbox, env_breakline_relief(co_id, set_envelope, 0));
      -- raster_relief
      WHEN class_id = 19 THEN
        bbox := update_bounds(bbox, env_raster_relief(co_id, set_envelope, 0));
      -- city_furniture
      WHEN class_id = 21 THEN
        bbox := update_bounds(bbox, env_city_furniture(co_id, set_envelope, 1));
      -- cityobjectgroup
      WHEN class_id = 23 THEN
        bbox := update_bounds(bbox, env_cityobjectgroup(co_id, set_envelope, 1));
      -- building
      WHEN class_id = 24 THEN
        bbox := update_bounds(bbox, env_building(co_id, set_envelope, 1));
      -- building
      WHEN class_id = 25 THEN
        bbox := update_bounds(bbox, env_building(co_id, set_envelope, 1));
      -- building
      WHEN class_id = 26 THEN
        bbox := update_bounds(bbox, env_building(co_id, set_envelope, 1));
      -- building_installation
      WHEN class_id = 27 THEN
        bbox := update_bounds(bbox, env_building_installation(co_id, set_envelope, 1));
      -- building_installation
      WHEN class_id = 28 THEN
        bbox := update_bounds(bbox, env_building_installation(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 29 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 30 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 31 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 32 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 33 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 34 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 35 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 36 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- opening
      WHEN class_id = 37 THEN
        bbox := update_bounds(bbox, env_opening(co_id, set_envelope, 1));
      -- opening
      WHEN class_id = 38 THEN
        bbox := update_bounds(bbox, env_opening(co_id, set_envelope, 1));
      -- opening
      WHEN class_id = 39 THEN
        bbox := update_bounds(bbox, env_opening(co_id, set_envelope, 1));
      -- building_furniture
      WHEN class_id = 40 THEN
        bbox := update_bounds(bbox, env_building_furniture(co_id, set_envelope, 1));
      -- room
      WHEN class_id = 41 THEN
        bbox := update_bounds(bbox, env_room(co_id, set_envelope, 1));
      -- transportation_complex
      WHEN class_id = 42 THEN
        bbox := update_bounds(bbox, env_transportation_complex(co_id, set_envelope, 1));
      -- transportation_complex
      WHEN class_id = 43 THEN
        bbox := update_bounds(bbox, env_transportation_complex(co_id, set_envelope, 1));
      -- transportation_complex
      WHEN class_id = 44 THEN
        bbox := update_bounds(bbox, env_transportation_complex(co_id, set_envelope, 1));
      -- transportation_complex
      WHEN class_id = 45 THEN
        bbox := update_bounds(bbox, env_transportation_complex(co_id, set_envelope, 1));
      -- transportation_complex
      WHEN class_id = 46 THEN
        bbox := update_bounds(bbox, env_transportation_complex(co_id, set_envelope, 1));
      -- traffic_area
      WHEN class_id = 47 THEN
        bbox := update_bounds(bbox, env_traffic_area(co_id, set_envelope, 1));
      -- traffic_area
      WHEN class_id = 48 THEN
        bbox := update_bounds(bbox, env_traffic_area(co_id, set_envelope, 1));
      -- appearance
      WHEN class_id = 50 THEN
        bbox := update_bounds(bbox, env_appearance(co_id, set_envelope, 0));
      -- surface_data
      WHEN class_id = 51 THEN
        bbox := update_bounds(bbox, env_surface_data(co_id, set_envelope, 0));
      -- surface_data
      WHEN class_id = 52 THEN
        bbox := update_bounds(bbox, env_surface_data(co_id, set_envelope, 0));
      -- surface_data
      WHEN class_id = 53 THEN
        bbox := update_bounds(bbox, env_surface_data(co_id, set_envelope, 0));
      -- surface_data
      WHEN class_id = 54 THEN
        bbox := update_bounds(bbox, env_surface_data(co_id, set_envelope, 0));
      -- surface_data
      WHEN class_id = 55 THEN
        bbox := update_bounds(bbox, env_surface_data(co_id, set_envelope, 0));
      -- textureparam
      WHEN class_id = 56 THEN
        bbox := update_bounds(bbox, env_textureparam(co_id, set_envelope, 0));
      -- citymodel
      WHEN class_id = 57 THEN
        bbox := update_bounds(bbox, env_citymodel(co_id, set_envelope, 0));
      -- address
      WHEN class_id = 58 THEN
        bbox := update_bounds(bbox, env_address(co_id, set_envelope, 0));
      -- implicit_geometry
      WHEN class_id = 59 THEN
        bbox := update_bounds(bbox, env_implicit_geometry(co_id, set_envelope, 0));
      -- thematic_surface
      WHEN class_id = 60 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- thematic_surface
      WHEN class_id = 61 THEN
        bbox := update_bounds(bbox, env_thematic_surface(co_id, set_envelope, 1));
      -- bridge
      WHEN class_id = 62 THEN
        bbox := update_bounds(bbox, env_bridge(co_id, set_envelope, 1));
      -- bridge
      WHEN class_id = 63 THEN
        bbox := update_bounds(bbox, env_bridge(co_id, set_envelope, 1));
      -- bridge
      WHEN class_id = 64 THEN
        bbox := update_bounds(bbox, env_bridge(co_id, set_envelope, 1));
      -- bridge_installation
      WHEN class_id = 65 THEN
        bbox := update_bounds(bbox, env_bridge_installation(co_id, set_envelope, 1));
      -- bridge_installation
      WHEN class_id = 66 THEN
        bbox := update_bounds(bbox, env_bridge_installation(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 67 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 68 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 69 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 70 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 71 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 72 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 73 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 74 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 75 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_thematic_surface
      WHEN class_id = 76 THEN
        bbox := update_bounds(bbox, env_bridge_thematic_surface(co_id, set_envelope, 1));
      -- bridge_opening
      WHEN class_id = 77 THEN
        bbox := update_bounds(bbox, env_bridge_opening(co_id, set_envelope, 1));
      -- bridge_opening
      WHEN class_id = 78 THEN
        bbox := update_bounds(bbox, env_bridge_opening(co_id, set_envelope, 1));
      -- bridge_opening
      WHEN class_id = 79 THEN
        bbox := update_bounds(bbox, env_bridge_opening(co_id, set_envelope, 1));
      -- bridge_furniture
      WHEN class_id = 80 THEN
        bbox := update_bounds(bbox, env_bridge_furniture(co_id, set_envelope, 1));
      -- bridge_room
      WHEN class_id = 81 THEN
        bbox := update_bounds(bbox, env_bridge_room(co_id, set_envelope, 1));
      -- bridge_constr_element
      WHEN class_id = 82 THEN
        bbox := update_bounds(bbox, env_bridge_constr_element(co_id, set_envelope, 1));
      -- tunnel
      WHEN class_id = 83 THEN
        bbox := update_bounds(bbox, env_tunnel(co_id, set_envelope, 1));
      -- tunnel
      WHEN class_id = 84 THEN
        bbox := update_bounds(bbox, env_tunnel(co_id, set_envelope, 1));
      -- tunnel
      WHEN class_id = 85 THEN
        bbox := update_bounds(bbox, env_tunnel(co_id, set_envelope, 1));
      -- tunnel_installation
      WHEN class_id = 86 THEN
        bbox := update_bounds(bbox, env_tunnel_installation(co_id, set_envelope, 1));
      -- tunnel_installation
      WHEN class_id = 87 THEN
        bbox := update_bounds(bbox, env_tunnel_installation(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 88 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 89 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 90 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 91 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 92 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 93 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 94 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 95 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 96 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_thematic_surface
      WHEN class_id = 97 THEN
        bbox := update_bounds(bbox, env_tunnel_thematic_surface(co_id, set_envelope, 1));
      -- tunnel_opening
      WHEN class_id = 98 THEN
        bbox := update_bounds(bbox, env_tunnel_opening(co_id, set_envelope, 1));
      -- tunnel_opening
      WHEN class_id = 99 THEN
        bbox := update_bounds(bbox, env_tunnel_opening(co_id, set_envelope, 1));
      -- tunnel_opening
      WHEN class_id = 100 THEN
        bbox := update_bounds(bbox, env_tunnel_opening(co_id, set_envelope, 1));
      -- tunnel_furniture
      WHEN class_id = 101 THEN
        bbox := update_bounds(bbox, env_tunnel_furniture(co_id, set_envelope, 1));
      -- tunnel_hollow_space
      WHEN class_id = 102 THEN
        bbox := update_bounds(bbox, env_tunnel_hollow_space(co_id, set_envelope, 1));
      -- textureparam
      WHEN class_id = 103 THEN
        bbox := update_bounds(bbox, env_textureparam(co_id, set_envelope, 0));
      -- textureparam
      WHEN class_id = 104 THEN
        bbox := update_bounds(bbox, env_textureparam(co_id, set_envelope, 0));
      ELSE bbox := bbox;
      END CASE;
    END IF;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_cityobjectgroup(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, cityobjectgroup t WHERE sg.root_id = t.brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- geometry
      SELECT other_geom AS geom FROM cityobjectgroup WHERE id = co_id  AND other_geom IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _CityObject
      SELECT c.id FROM cityobject c, group_to_cityobject p2c WHERE c.id = cityobject_id AND p2c.cityobjectgroup_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_cityobject(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_generic_cityobject(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod0Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, generic_cityobject t WHERE sg.root_id = t.lod0_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod0Geometry
      SELECT lod0_other_geom AS geom FROM generic_cityobject WHERE id = co_id  AND lod0_other_geom IS NOT NULL
        UNION ALL
      -- lod1Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, generic_cityobject t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod1Geometry
      SELECT lod1_other_geom AS geom FROM generic_cityobject WHERE id = co_id  AND lod1_other_geom IS NOT NULL
        UNION ALL
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, generic_cityobject t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM generic_cityobject WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, generic_cityobject t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM generic_cityobject WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, generic_cityobject t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM generic_cityobject WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod0TerrainIntersection
      SELECT lod0_terrain_intersection AS geom FROM generic_cityobject WHERE id = co_id  AND lod0_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod1TerrainIntersection
      SELECT lod1_terrain_intersection AS geom FROM generic_cityobject WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod2TerrainIntersection
      SELECT lod2_terrain_intersection AS geom FROM generic_cityobject WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod3TerrainIntersection
      SELECT lod3_terrain_intersection AS geom FROM generic_cityobject WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod4TerrainIntersection
      SELECT lod4_terrain_intersection AS geom FROM generic_cityobject WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod0ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod0_implicit_rep_id, lod0_implicit_ref_point, lod0_implicit_transformation) AS geom FROM generic_cityobject WHERE id = co_id AND lod0_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod1ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM generic_cityobject WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM generic_cityobject WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM generic_cityobject WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM generic_cityobject WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_implicit_geometry(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_land_use(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod0MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, land_use t WHERE sg.root_id = t.lod0_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, land_use t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, land_use t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, land_use t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, land_use t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_masspoint_relief(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_relief_component(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- reliefPoints
      SELECT relief_points AS geom FROM masspoint_relief WHERE id = co_id  AND relief_points IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_opening(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, opening t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, opening t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- Address
      SELECT c.id FROM opening p, address c WHERE p.id = co_id AND p.address_id = c.id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_address(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_plant_cover(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1MultiSolid
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod1_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSolid
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod2_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSolid
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod3_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSolid
      SELECT sg.geometry AS geom FROM surface_geometry sg, plant_cover t WHERE sg.root_id = t.lod4_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_relief_component(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- extent
      SELECT extent AS geom FROM relief_component WHERE id = co_id  AND extent IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF caller <> 2 THEN
      SELECT objectclass_id INTO class_id FROM relief_component WHERE id = co_id;
      CASE
      -- tin_relief
      WHEN class_id = 16 THEN
        bbox := update_bounds(bbox, env_tin_relief(co_id, set_envelope, 1));
      -- masspoint_relief
      WHEN class_id = 17 THEN
        bbox := update_bounds(bbox, env_masspoint_relief(co_id, set_envelope, 1));
      -- breakline_relief
      WHEN class_id = 18 THEN
        bbox := update_bounds(bbox, env_breakline_relief(co_id, set_envelope, 1));
      -- raster_relief
      WHEN class_id = 19 THEN
        bbox := update_bounds(bbox, env_raster_relief(co_id, set_envelope, 1));
      ELSE bbox := bbox;
      END CASE;
    END IF;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_relief_feature(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _ReliefComponent
      SELECT c.id FROM relief_component c, relief_feat_to_rel_comp p2c WHERE c.id = relief_component_id AND p2c.relief_feature_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_relief_component(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_room(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, room t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, room t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM thematic_surface WHERE room_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- BuildingFurniture
      SELECT id FROM building_furniture WHERE room_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_building_furniture(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- IntBuildingInstallation
      SELECT id FROM building_installation WHERE room_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_building_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_solitary_vegetat_object(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod1Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, solitary_vegetat_object t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod1Geometry
      SELECT lod1_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id  AND lod1_other_geom IS NOT NULL
        UNION ALL
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, solitary_vegetat_object t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, solitary_vegetat_object t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, solitary_vegetat_object t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM solitary_vegetat_object WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod1ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM solitary_vegetat_object WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_surface_data(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- referencePoint
      SELECT gt_reference_point AS geom FROM surface_data WHERE id = co_id  AND gt_reference_point IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_textureparam(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_thematic_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, thematic_surface t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, thematic_surface t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, thematic_surface t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _Opening
      SELECT c.id FROM opening c, opening_to_them_surface p2c WHERE c.id = opening_id AND p2c.thematic_surface_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_opening(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tin_relief(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_relief_component(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- tin
      SELECT sg.geometry AS geom FROM surface_geometry sg, tin_relief t WHERE sg.root_id = t.surface_geometry_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_traffic_area(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, traffic_area t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, traffic_area t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, traffic_area t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, traffic_area t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, traffic_area t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, traffic_area t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_transportation_complex(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod0Network
      SELECT lod0_network AS geom FROM transportation_complex WHERE id = co_id  AND lod0_network IS NOT NULL
        UNION ALL
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, transportation_complex t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, transportation_complex t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, transportation_complex t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, transportation_complex t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- TrafficArea
      SELECT id FROM traffic_area WHERE transportation_complex_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_traffic_area(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- AuxiliaryTrafficArea
      SELECT id FROM traffic_area WHERE transportation_complex_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_traffic_area(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tunnel(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod1Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1TerrainIntersection
      SELECT lod1_terrain_intersection AS geom FROM tunnel WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod2Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2MultiCurve
      SELECT lod2_multi_curve AS geom FROM tunnel WHERE id = co_id  AND lod2_multi_curve IS NOT NULL
        UNION ALL
      -- lod2TerrainIntersection
      SELECT lod2_terrain_intersection AS geom FROM tunnel WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod3Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiCurve
      SELECT lod3_multi_curve AS geom FROM tunnel WHERE id = co_id  AND lod3_multi_curve IS NOT NULL
        UNION ALL
      -- lod3TerrainIntersection
      SELECT lod3_terrain_intersection AS geom FROM tunnel WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
        UNION ALL
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiCurve
      SELECT lod4_multi_curve AS geom FROM tunnel WHERE id = co_id  AND lod4_multi_curve IS NOT NULL
        UNION ALL
      -- lod4TerrainIntersection
      SELECT lod4_terrain_intersection AS geom FROM tunnel WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- TunnelInstallation
      SELECT id FROM tunnel_installation WHERE tunnel_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- IntTunnelInstallation
      SELECT id FROM tunnel_installation WHERE tunnel_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM tunnel_thematic_surface WHERE tunnel_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- HollowSpace
      SELECT id FROM tunnel_hollow_space WHERE tunnel_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_hollow_space(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- TunnelPart
      SELECT id FROM tunnel WHERE tunnel_parent_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tunnel_furniture(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM tunnel_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM tunnel_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tunnel_hollow_space(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_hollow_space t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_hollow_space t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM tunnel_thematic_surface WHERE tunnel_hollow_space_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- TunnelFurniture
      SELECT id FROM tunnel_furniture WHERE tunnel_hollow_space_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_furniture(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- IntTunnelInstallation
      SELECT id FROM tunnel_installation WHERE tunnel_hollow_space_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_installation(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tunnel_installation(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_installation t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod2Geometry
      SELECT lod2_other_geom AS geom FROM tunnel_installation WHERE id = co_id  AND lod2_other_geom IS NOT NULL
        UNION ALL
      -- lod3Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_installation t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod3Geometry
      SELECT lod3_other_geom AS geom FROM tunnel_installation WHERE id = co_id  AND lod3_other_geom IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM tunnel_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod2ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM tunnel_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM tunnel_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM tunnel_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4Geometry
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
      -- lod4Geometry
      SELECT lod4_other_geom AS geom FROM tunnel_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM tunnel_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM tunnel_thematic_surface WHERE tunnel_installation_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    OPEN nested_feat_cur FOR
      -- _BoundarySurface
      SELECT id FROM tunnel_thematic_surface WHERE tunnel_installation_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_thematic_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tunnel_opening(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_opening t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_opening t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM tunnel_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
        UNION ALL
      -- lod4ImplicitRepresentation
      SELECT get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM tunnel_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_tunnel_thematic_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_thematic_surface t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_thematic_surface t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, tunnel_thematic_surface t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _Opening
      SELECT c.id FROM tunnel_opening c, tunnel_open_to_them_srf p2c WHERE c.id = tunnel_opening_id AND p2c.tunnel_thematic_surface_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_tunnel_opening(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_waterbody(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod0MultiCurve
      SELECT lod0_multi_curve AS geom FROM waterbody WHERE id = co_id  AND lod0_multi_curve IS NOT NULL
        UNION ALL
      -- lod0MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterbody t WHERE sg.root_id = t.lod0_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1MultiCurve
      SELECT lod1_multi_curve AS geom FROM waterbody WHERE id = co_id  AND lod1_multi_curve IS NOT NULL
        UNION ALL
      -- lod1MultiSurface
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterbody t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod1Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterbody t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod2Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterbody t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterbody t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4Solid
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterbody t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    -- bbox from aggregating objects
    OPEN nested_feat_cur FOR
      -- _WaterBoundarySurface
      SELECT c.id FROM waterboundary_surface c, waterbod_to_waterbnd_srf p2c WHERE c.id = waterboundary_surface_id AND p2c.waterbody_id = co_id;
    LOOP
      FETCH nested_feat_cur INTO nested_feat_id;
      EXIT WHEN nested_feat_cur%notfound;
      bbox := update_bounds(bbox, env_waterboundary_surface(nested_feat_id, set_envelope));
    END LOOP;
    CLOSE nested_feat_cur;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION env_waterboundary_surface(co_id NUMBER, set_envelope int := 0, caller int := 0) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    class_id NUMBER;
    dummy_box SDO_GEOMETRY;
    nested_feat_cur sys_refcursor;
    nested_feat_id NUMBER;
  BEGIN
    -- bbox from parent table
    IF caller <> 1 THEN
      bbox := env_cityobject(co_id, set_envelope, 2);
    END IF;

    -- bbox from inline and referencing spatial columns
    WITH collect_geom AS (
      -- lod2Surface
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterboundary_surface t WHERE sg.root_id = t.lod2_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod3Surface
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterboundary_surface t WHERE sg.root_id = t.lod3_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
        UNION ALL
      -- lod4Surface
      SELECT sg.geometry AS geom FROM surface_geometry sg, waterboundary_surface t WHERE sg.root_id = t.lod4_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
    )
    SELECT
      box2envelope(SDO_AGGR_MBR(geom))
    INTO
      bbox
    FROM
      collect_geom;

    IF set_envelope <> 0 AND bbox IS NOT NULL THEN
      UPDATE cityobject SET envelope = bbox WHERE id = co_id;
    END IF;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION get_envelope_cityobjects(objclass_id NUMBER := 0, set_envelope int := 0, only_if_null int := 1) RETURN SDO_GEOMETRY
  IS
    bbox SDO_GEOMETRY;
    filter VARCHAR2(150);
    cityobject_cur sys_refcursor;
    cityobject_rec cityobject%rowtype;
  BEGIN
    IF only_if_null <> 0 THEN
      filter := ' WHERE envelope IS NULL';
    END IF;

    IF objclass_id <> 0 THEN
      filter := CASE WHEN filter IS NULL THEN ' WHERE ' ELSE filter || ' AND ' END;
      filter := filter || 'objectclass_id = ' || to_char(objclass_id);
    END IF;

    OPEN cityobject_cur FOR
      'SELECT * FROM cityobject' || filter;
    LOOP
      FETCH cityobject_cur INTO cityobject_rec;
      EXIT WHEN cityobject_cur%notfound;
      bbox := update_bounds(bbox, env_cityobject(cityobject_rec.id, set_envelope));
    END LOOP;
    CLOSE cityobject_cur;

    RETURN bbox;

  END;
  ------------------------------------------

  FUNCTION get_envelope_implicit_geometry(implicit_rep_id NUMBER, ref_pt SDO_GEOMETRY, transform4x4 VARCHAR2) RETURN SDO_GEOMETRY
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
      box2envelope(SDO_AGGR_MBR(geom))
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

  END;
  ------------------------------------------

  FUNCTION update_bounds(old_box SDO_GEOMETRY, new_box SDO_GEOMETRY) RETURN SDO_GEOMETRY
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
        -- forth point
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

  END;
  ------------------------------------------

END citydb_envelope;
/