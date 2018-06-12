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

-- Automatically generated database script (Creation Date: 2018-06-12 10:26:21)
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
-- env_raster_relief
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
-- set_envelope_cityobjects_if_null

------------------------------------------
CREATE OR REPLACE FUNCTION citydb.box2envelope(box BOX3D) RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  db_srid INTEGER;
BEGIN
  -- get reference system of input geometry
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
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_address(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
BEGIN
  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox1 FROM (
    -- multiPoint
    SELECT multi_point AS geom FROM citydb.address WHERE id = co_id  AND multi_point IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_appearance(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
BEGIN
  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox1 FROM (
    -- _SurfaceData
    SELECT citydb.env_surface_data(id, set_envelope) AS geom FROM citydb.surface_data c, citydb.appear_to_surface_data p2c WHERE c.id = surface_data_id AND p2c.appearance_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_breakline_relief(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_relief_component(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- ridgeOrValleyLines
    SELECT ridge_or_valley_lines AS geom FROM citydb.breakline_relief WHERE id = co_id  AND ridge_or_valley_lines IS NOT NULL
      UNION ALL
    -- breaklines
    SELECT break_lines AS geom FROM citydb.breakline_relief WHERE id = co_id  AND break_lines IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod1Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1TerrainIntersection
    SELECT lod1_terrain_intersection AS geom FROM citydb.bridge WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod2Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiCurve
    SELECT lod2_multi_curve AS geom FROM citydb.bridge WHERE id = co_id  AND lod2_multi_curve IS NOT NULL
      UNION ALL
    -- lod2TerrainIntersection
    SELECT lod2_terrain_intersection AS geom FROM citydb.bridge WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod3Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiCurve
    SELECT lod3_multi_curve AS geom FROM citydb.bridge WHERE id = co_id  AND lod3_multi_curve IS NOT NULL
      UNION ALL
    -- lod3TerrainIntersection
    SELECT lod3_terrain_intersection AS geom FROM citydb.bridge WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiCurve
    SELECT lod4_multi_curve AS geom FROM citydb.bridge WHERE id = co_id  AND lod4_multi_curve IS NOT NULL
      UNION ALL
    -- lod4TerrainIntersection
    SELECT lod4_terrain_intersection AS geom FROM citydb.bridge WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- BridgeConstructionElement
    SELECT citydb.env_bridge_constr_element(id, set_envelope) AS geom FROM citydb.bridge_constr_element WHERE bridge_id = co_id
      UNION ALL
    -- BridgeInstallation
    SELECT citydb.env_bridge_installation(id, set_envelope) AS geom FROM citydb.bridge_installation WHERE bridge_id = co_id
      UNION ALL
    -- IntBridgeInstallation
    SELECT citydb.env_bridge_installation(id, set_envelope) AS geom FROM citydb.bridge_installation WHERE bridge_id = co_id
      UNION ALL
    -- _BoundarySurface
    SELECT citydb.env_bridge_thematic_surface(id, set_envelope) AS geom FROM citydb.bridge_thematic_surface WHERE bridge_id = co_id
      UNION ALL
    -- BridgeRoom
    SELECT citydb.env_bridge_room(id, set_envelope) AS geom FROM citydb.bridge_room WHERE bridge_id = co_id
      UNION ALL
    -- BridgePart
    SELECT citydb.env_bridge(id, set_envelope) AS geom FROM citydb.bridge WHERE bridge_parent_id = co_id
      UNION ALL
    -- Address
    SELECT citydb.env_address(id, set_envelope) AS geom FROM citydb.address c, citydb.address_to_bridge p2c WHERE c.id = address_id AND p2c.bridge_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge_constr_element(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod1Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_constr_element t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1Geometry
    SELECT lod1_other_geom AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod1_other_geom IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_constr_element t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_constr_element t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_constr_element t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod1TerrainIntersection
    SELECT lod1_terrain_intersection AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod2TerrainIntersection
    SELECT lod2_terrain_intersection AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod3TerrainIntersection
    SELECT lod3_terrain_intersection AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod4TerrainIntersection
    SELECT lod4_terrain_intersection AS geom FROM citydb.bridge_constr_element WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod1ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM citydb.bridge_constr_element WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.bridge_constr_element WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.bridge_constr_element WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.bridge_constr_element WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge_furniture(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.bridge_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.bridge_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge_installation(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_installation t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.bridge_installation WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_installation t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.bridge_installation WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.bridge_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.bridge_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.bridge_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.bridge_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.bridge_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.bridge_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BoundarySurface
    SELECT citydb.env_bridge_thematic_surface(id, set_envelope) AS geom FROM citydb.bridge_thematic_surface WHERE bridge_installation_id = co_id
      UNION ALL
    -- _BoundarySurface
    SELECT citydb.env_bridge_thematic_surface(id, set_envelope) AS geom FROM citydb.bridge_thematic_surface WHERE bridge_installation_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge_opening(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_opening t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_opening t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.bridge_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.bridge_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- Address
    SELECT citydb.env_address(c.id, set_envelope) AS geom FROM citydb.bridge_opening p, address c WHERE p.id = co_id AND p.address_id = c.id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge_room(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_room t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_room t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BoundarySurface
    SELECT citydb.env_bridge_thematic_surface(id, set_envelope) AS geom FROM citydb.bridge_thematic_surface WHERE bridge_room_id = co_id
      UNION ALL
    -- BridgeFurniture
    SELECT citydb.env_bridge_furniture(id, set_envelope) AS geom FROM citydb.bridge_furniture WHERE bridge_room_id = co_id
      UNION ALL
    -- IntBridgeInstallation
    SELECT citydb.env_bridge_installation(id, set_envelope) AS geom FROM citydb.bridge_installation WHERE bridge_room_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_bridge_thematic_surface(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_thematic_surface t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_thematic_surface t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.bridge_thematic_surface t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BridgeOpening
    SELECT citydb.env_bridge_opening(id, set_envelope) AS geom FROM citydb.bridge_opening c, citydb.bridge_open_to_them_srf p2c WHERE c.id = bridge_opening_id AND p2c.bridge_thematic_surface_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_building(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod0FootPrint
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod0_footprint_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod0RoofEdge
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod0_roofprint_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1TerrainIntersection
    SELECT lod1_terrain_intersection AS geom FROM citydb.building WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod2Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiCurve
    SELECT lod2_multi_curve AS geom FROM citydb.building WHERE id = co_id  AND lod2_multi_curve IS NOT NULL
      UNION ALL
    -- lod2TerrainIntersection
    SELECT lod2_terrain_intersection AS geom FROM citydb.building WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod3Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiCurve
    SELECT lod3_multi_curve AS geom FROM citydb.building WHERE id = co_id  AND lod3_multi_curve IS NOT NULL
      UNION ALL
    -- lod3TerrainIntersection
    SELECT lod3_terrain_intersection AS geom FROM citydb.building WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiCurve
    SELECT lod4_multi_curve AS geom FROM citydb.building WHERE id = co_id  AND lod4_multi_curve IS NOT NULL
      UNION ALL
    -- lod4TerrainIntersection
    SELECT lod4_terrain_intersection AS geom FROM citydb.building WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- BuildingInstallation
    SELECT citydb.env_building_installation(id, set_envelope) AS geom FROM citydb.building_installation WHERE building_id = co_id
      UNION ALL
    -- IntBuildingInstallation
    SELECT citydb.env_building_installation(id, set_envelope) AS geom FROM citydb.building_installation WHERE building_id = co_id
      UNION ALL
    -- _BoundarySurface
    SELECT citydb.env_thematic_surface(id, set_envelope) AS geom FROM citydb.thematic_surface WHERE building_id = co_id
      UNION ALL
    -- Room
    SELECT citydb.env_room(id, set_envelope) AS geom FROM citydb.room WHERE building_id = co_id
      UNION ALL
    -- BuildingPart
    SELECT citydb.env_building(id, set_envelope) AS geom FROM citydb.building WHERE building_parent_id = co_id
      UNION ALL
    -- Address
    SELECT citydb.env_address(id, set_envelope) AS geom FROM citydb.address c, citydb.address_to_building p2c WHERE c.id = address_id AND p2c.building_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_building_furniture(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.building_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.building_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_building_installation(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building_installation t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.building_installation WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building_installation t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.building_installation WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.building_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.building_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.building_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.building_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.building_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.building_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.building_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BoundarySurface
    SELECT citydb.env_thematic_surface(id, set_envelope) AS geom FROM citydb.thematic_surface WHERE building_installation_id = co_id
      UNION ALL
    -- _BoundarySurface
    SELECT citydb.env_thematic_surface(id, set_envelope) AS geom FROM citydb.thematic_surface WHERE building_installation_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_city_furniture(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod1Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.city_furniture t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1Geometry
    SELECT lod1_other_geom AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod1_other_geom IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.city_furniture t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.city_furniture t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.city_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod1TerrainIntersection
    SELECT lod1_terrain_intersection AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod2TerrainIntersection
    SELECT lod2_terrain_intersection AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod3TerrainIntersection
    SELECT lod3_terrain_intersection AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod4TerrainIntersection
    SELECT lod4_terrain_intersection AS geom FROM citydb.city_furniture WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod1ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM citydb.city_furniture WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.city_furniture WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.city_furniture WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.city_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_citymodel(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
BEGIN
  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_cityobject(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox1 FROM (
    -- boundedBy
    SELECT envelope AS geom FROM citydb.cityobject WHERE id = co_id  AND envelope IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- Appearance
    SELECT citydb.env_appearance(id, set_envelope) AS geom FROM citydb.appearance WHERE cityobject_id = co_id
  ) g;

  IF caller <> 2 THEN
    SELECT objectclass_id INTO class_id FROM citydb.cityobject WHERE id = co_id;
    CASE
      -- land_use
      WHEN class_id = 4 THEN
        bbox3 := citydb.env_land_use(co_id, set_envelope, 1);
      -- generic_cityobject
      WHEN class_id = 5 THEN
        bbox3 := citydb.env_generic_cityobject(co_id, set_envelope, 1);
      -- solitary_vegetat_object
      WHEN class_id = 7 THEN
        bbox3 := citydb.env_solitary_vegetat_object(co_id, set_envelope, 1);
      -- plant_cover
      WHEN class_id = 8 THEN
        bbox3 := citydb.env_plant_cover(co_id, set_envelope, 1);
      -- waterbody
      WHEN class_id = 9 THEN
        bbox3 := citydb.env_waterbody(co_id, set_envelope, 1);
      -- waterboundary_surface
      WHEN class_id = 10 THEN
        bbox3 := citydb.env_waterboundary_surface(co_id, set_envelope, 1);
      -- waterboundary_surface
      WHEN class_id = 11 THEN
        bbox3 := citydb.env_waterboundary_surface(co_id, set_envelope, 1);
      -- waterboundary_surface
      WHEN class_id = 12 THEN
        bbox3 := citydb.env_waterboundary_surface(co_id, set_envelope, 1);
      -- waterboundary_surface
      WHEN class_id = 13 THEN
        bbox3 := citydb.env_waterboundary_surface(co_id, set_envelope, 1);
      -- relief_feature
      WHEN class_id = 14 THEN
        bbox3 := citydb.env_relief_feature(co_id, set_envelope, 1);
      -- relief_component
      WHEN class_id = 15 THEN
        bbox3 := citydb.env_relief_component(co_id, set_envelope, 1);
      -- tin_relief
      WHEN class_id = 16 THEN
        bbox3 := citydb.env_tin_relief(co_id, set_envelope, 0);
      -- masspoint_relief
      WHEN class_id = 17 THEN
        bbox3 := citydb.env_masspoint_relief(co_id, set_envelope, 0);
      -- breakline_relief
      WHEN class_id = 18 THEN
        bbox3 := citydb.env_breakline_relief(co_id, set_envelope, 0);
      -- raster_relief
      WHEN class_id = 19 THEN
        bbox3 := citydb.env_raster_relief(co_id, set_envelope, 0);
      -- city_furniture
      WHEN class_id = 21 THEN
        bbox3 := citydb.env_city_furniture(co_id, set_envelope, 1);
      -- cityobjectgroup
      WHEN class_id = 23 THEN
        bbox3 := citydb.env_cityobjectgroup(co_id, set_envelope, 1);
      -- building
      WHEN class_id = 24 THEN
        bbox3 := citydb.env_building(co_id, set_envelope, 1);
      -- building
      WHEN class_id = 25 THEN
        bbox3 := citydb.env_building(co_id, set_envelope, 1);
      -- building
      WHEN class_id = 26 THEN
        bbox3 := citydb.env_building(co_id, set_envelope, 1);
      -- building_installation
      WHEN class_id = 27 THEN
        bbox3 := citydb.env_building_installation(co_id, set_envelope, 1);
      -- building_installation
      WHEN class_id = 28 THEN
        bbox3 := citydb.env_building_installation(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 29 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 30 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 31 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 32 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 33 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 34 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 35 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 36 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- opening
      WHEN class_id = 37 THEN
        bbox3 := citydb.env_opening(co_id, set_envelope, 1);
      -- opening
      WHEN class_id = 38 THEN
        bbox3 := citydb.env_opening(co_id, set_envelope, 1);
      -- opening
      WHEN class_id = 39 THEN
        bbox3 := citydb.env_opening(co_id, set_envelope, 1);
      -- building_furniture
      WHEN class_id = 40 THEN
        bbox3 := citydb.env_building_furniture(co_id, set_envelope, 1);
      -- room
      WHEN class_id = 41 THEN
        bbox3 := citydb.env_room(co_id, set_envelope, 1);
      -- transportation_complex
      WHEN class_id = 42 THEN
        bbox3 := citydb.env_transportation_complex(co_id, set_envelope, 1);
      -- transportation_complex
      WHEN class_id = 43 THEN
        bbox3 := citydb.env_transportation_complex(co_id, set_envelope, 1);
      -- transportation_complex
      WHEN class_id = 44 THEN
        bbox3 := citydb.env_transportation_complex(co_id, set_envelope, 1);
      -- transportation_complex
      WHEN class_id = 45 THEN
        bbox3 := citydb.env_transportation_complex(co_id, set_envelope, 1);
      -- transportation_complex
      WHEN class_id = 46 THEN
        bbox3 := citydb.env_transportation_complex(co_id, set_envelope, 1);
      -- traffic_area
      WHEN class_id = 47 THEN
        bbox3 := citydb.env_traffic_area(co_id, set_envelope, 1);
      -- traffic_area
      WHEN class_id = 48 THEN
        bbox3 := citydb.env_traffic_area(co_id, set_envelope, 1);
      -- appearance
      WHEN class_id = 50 THEN
        bbox3 := citydb.env_appearance(co_id, set_envelope, 0);
      -- surface_data
      WHEN class_id = 51 THEN
        bbox3 := citydb.env_surface_data(co_id, set_envelope, 0);
      -- surface_data
      WHEN class_id = 52 THEN
        bbox3 := citydb.env_surface_data(co_id, set_envelope, 0);
      -- surface_data
      WHEN class_id = 53 THEN
        bbox3 := citydb.env_surface_data(co_id, set_envelope, 0);
      -- surface_data
      WHEN class_id = 54 THEN
        bbox3 := citydb.env_surface_data(co_id, set_envelope, 0);
      -- surface_data
      WHEN class_id = 55 THEN
        bbox3 := citydb.env_surface_data(co_id, set_envelope, 0);
      -- textureparam
      WHEN class_id = 56 THEN
        bbox3 := citydb.env_textureparam(co_id, set_envelope, 0);
      -- citymodel
      WHEN class_id = 57 THEN
        bbox3 := citydb.env_citymodel(co_id, set_envelope, 0);
      -- address
      WHEN class_id = 58 THEN
        bbox3 := citydb.env_address(co_id, set_envelope, 0);
      -- implicit_geometry
      WHEN class_id = 59 THEN
        bbox3 := citydb.env_implicit_geometry(co_id, set_envelope, 0);
      -- thematic_surface
      WHEN class_id = 60 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- thematic_surface
      WHEN class_id = 61 THEN
        bbox3 := citydb.env_thematic_surface(co_id, set_envelope, 1);
      -- bridge
      WHEN class_id = 62 THEN
        bbox3 := citydb.env_bridge(co_id, set_envelope, 1);
      -- bridge
      WHEN class_id = 63 THEN
        bbox3 := citydb.env_bridge(co_id, set_envelope, 1);
      -- bridge
      WHEN class_id = 64 THEN
        bbox3 := citydb.env_bridge(co_id, set_envelope, 1);
      -- bridge_installation
      WHEN class_id = 65 THEN
        bbox3 := citydb.env_bridge_installation(co_id, set_envelope, 1);
      -- bridge_installation
      WHEN class_id = 66 THEN
        bbox3 := citydb.env_bridge_installation(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 67 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 68 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 69 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 70 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 71 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 72 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 73 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 74 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 75 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_thematic_surface
      WHEN class_id = 76 THEN
        bbox3 := citydb.env_bridge_thematic_surface(co_id, set_envelope, 1);
      -- bridge_opening
      WHEN class_id = 77 THEN
        bbox3 := citydb.env_bridge_opening(co_id, set_envelope, 1);
      -- bridge_opening
      WHEN class_id = 78 THEN
        bbox3 := citydb.env_bridge_opening(co_id, set_envelope, 1);
      -- bridge_opening
      WHEN class_id = 79 THEN
        bbox3 := citydb.env_bridge_opening(co_id, set_envelope, 1);
      -- bridge_furniture
      WHEN class_id = 80 THEN
        bbox3 := citydb.env_bridge_furniture(co_id, set_envelope, 1);
      -- bridge_room
      WHEN class_id = 81 THEN
        bbox3 := citydb.env_bridge_room(co_id, set_envelope, 1);
      -- bridge_constr_element
      WHEN class_id = 82 THEN
        bbox3 := citydb.env_bridge_constr_element(co_id, set_envelope, 1);
      -- tunnel
      WHEN class_id = 83 THEN
        bbox3 := citydb.env_tunnel(co_id, set_envelope, 1);
      -- tunnel
      WHEN class_id = 84 THEN
        bbox3 := citydb.env_tunnel(co_id, set_envelope, 1);
      -- tunnel
      WHEN class_id = 85 THEN
        bbox3 := citydb.env_tunnel(co_id, set_envelope, 1);
      -- tunnel_installation
      WHEN class_id = 86 THEN
        bbox3 := citydb.env_tunnel_installation(co_id, set_envelope, 1);
      -- tunnel_installation
      WHEN class_id = 87 THEN
        bbox3 := citydb.env_tunnel_installation(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 88 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 89 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 90 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 91 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 92 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 93 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 94 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 95 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 96 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_thematic_surface
      WHEN class_id = 97 THEN
        bbox3 := citydb.env_tunnel_thematic_surface(co_id, set_envelope, 1);
      -- tunnel_opening
      WHEN class_id = 98 THEN
        bbox3 := citydb.env_tunnel_opening(co_id, set_envelope, 1);
      -- tunnel_opening
      WHEN class_id = 99 THEN
        bbox3 := citydb.env_tunnel_opening(co_id, set_envelope, 1);
      -- tunnel_opening
      WHEN class_id = 100 THEN
        bbox3 := citydb.env_tunnel_opening(co_id, set_envelope, 1);
      -- tunnel_furniture
      WHEN class_id = 101 THEN
        bbox3 := citydb.env_tunnel_furniture(co_id, set_envelope, 1);
      -- tunnel_hollow_space
      WHEN class_id = 102 THEN
        bbox3 := citydb.env_tunnel_hollow_space(co_id, set_envelope, 1);
      -- textureparam
      WHEN class_id = 103 THEN
        bbox3 := citydb.env_textureparam(co_id, set_envelope, 0);
      -- textureparam
      WHEN class_id = 104 THEN
        bbox3 := citydb.env_textureparam(co_id, set_envelope, 0);
    ELSE
    END CASE;
  END IF;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_cityobjectgroup(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.cityobjectgroup t WHERE sg.root_id = t.brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- geometry
    SELECT other_geom AS geom FROM citydb.cityobjectgroup WHERE id = co_id  AND other_geom IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _CityObject
    SELECT citydb.env_cityobject(id, set_envelope) AS geom FROM citydb.cityobject c, citydb.group_to_cityobject p2c WHERE c.id = cityobject_id AND p2c.cityobjectgroup_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_generic_cityobject(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod0Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.generic_cityobject t WHERE sg.root_id = t.lod0_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod0Geometry
    SELECT lod0_other_geom AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod0_other_geom IS NOT NULL
      UNION ALL
    -- lod1Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.generic_cityobject t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1Geometry
    SELECT lod1_other_geom AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod1_other_geom IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.generic_cityobject t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.generic_cityobject t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.generic_cityobject t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod0TerrainIntersection
    SELECT lod0_terrain_intersection AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod0_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod1TerrainIntersection
    SELECT lod1_terrain_intersection AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod2TerrainIntersection
    SELECT lod2_terrain_intersection AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod3TerrainIntersection
    SELECT lod3_terrain_intersection AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod4TerrainIntersection
    SELECT lod4_terrain_intersection AS geom FROM citydb.generic_cityobject WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod0ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod0_implicit_rep_id, lod0_implicit_ref_point, lod0_implicit_transformation) AS geom FROM citydb.generic_cityobject WHERE id = co_id AND lod0_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod1ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM citydb.generic_cityobject WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.generic_cityobject WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.generic_cityobject WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.generic_cityobject WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_implicit_geometry(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
BEGIN
  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_land_use(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod0MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.land_use t WHERE sg.root_id = t.lod0_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.land_use t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.land_use t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.land_use t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.land_use t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_masspoint_relief(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_relief_component(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- reliefPoints
    SELECT relief_points AS geom FROM citydb.masspoint_relief WHERE id = co_id  AND relief_points IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_opening(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.opening t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.opening t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- Address
    SELECT citydb.env_address(c.id, set_envelope) AS geom FROM citydb.opening p, address c WHERE p.id = co_id AND p.address_id = c.id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_plant_cover(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1MultiSolid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod1_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSolid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod2_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSolid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod3_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSolid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.plant_cover t WHERE sg.root_id = t.lod4_multi_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_raster_relief(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_relief_component(co_id, set_envelope, 2);
  END IF;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_relief_component(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- extent
    SELECT extent AS geom FROM citydb.relief_component WHERE id = co_id  AND extent IS NOT NULL
  ) g;

  IF caller <> 2 THEN
    SELECT objectclass_id INTO class_id FROM citydb.cityobject WHERE id = co_id;
    CASE
      -- tin_relief
      WHEN class_id = 16 THEN
        bbox3 := citydb.env_tin_relief(co_id, set_envelope, 1);
      -- masspoint_relief
      WHEN class_id = 17 THEN
        bbox3 := citydb.env_masspoint_relief(co_id, set_envelope, 1);
      -- breakline_relief
      WHEN class_id = 18 THEN
        bbox3 := citydb.env_breakline_relief(co_id, set_envelope, 1);
      -- raster_relief
      WHEN class_id = 19 THEN
        bbox3 := citydb.env_raster_relief(co_id, set_envelope, 1);
    ELSE
    END CASE;
  END IF;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_relief_feature(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- _ReliefComponent
    SELECT citydb.env_relief_component(id, set_envelope) AS geom FROM citydb.relief_component c, citydb.relief_feat_to_rel_comp p2c WHERE c.id = relief_component_id AND p2c.relief_feature_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_room(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.room t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.room t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BoundarySurface
    SELECT citydb.env_thematic_surface(id, set_envelope) AS geom FROM citydb.thematic_surface WHERE room_id = co_id
      UNION ALL
    -- BuildingFurniture
    SELECT citydb.env_building_furniture(id, set_envelope) AS geom FROM citydb.building_furniture WHERE room_id = co_id
      UNION ALL
    -- IntBuildingInstallation
    SELECT citydb.env_building_installation(id, set_envelope) AS geom FROM citydb.building_installation WHERE room_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_solitary_vegetat_object(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod1Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.solitary_vegetat_object t WHERE sg.root_id = t.lod1_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1Geometry
    SELECT lod1_other_geom AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id  AND lod1_other_geom IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.solitary_vegetat_object t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.solitary_vegetat_object t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.solitary_vegetat_object t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod1ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod1_implicit_rep_id, lod1_implicit_ref_point, lod1_implicit_transformation) AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id AND lod1_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.solitary_vegetat_object WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_surface_data(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox1 FROM (
    -- referencePoint
    SELECT gt_reference_point AS geom FROM citydb.surface_data WHERE id = co_id  AND gt_reference_point IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_textureparam(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
BEGIN
  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_thematic_surface(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.thematic_surface t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.thematic_surface t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.thematic_surface t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _Opening
    SELECT citydb.env_opening(id, set_envelope) AS geom FROM citydb.opening c, citydb.opening_to_them_surface p2c WHERE c.id = opening_id AND p2c.thematic_surface_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tin_relief(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_relief_component(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- tin
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tin_relief t WHERE sg.root_id = t.surface_geometry_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_traffic_area(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.traffic_area t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.traffic_area t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.traffic_area t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.traffic_area t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.traffic_area t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.traffic_area t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_transportation_complex(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod0Network
    SELECT lod0_network AS geom FROM citydb.transportation_complex WHERE id = co_id  AND lod0_network IS NOT NULL
      UNION ALL
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.transportation_complex t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.transportation_complex t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.transportation_complex t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.transportation_complex t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- TrafficArea
    SELECT citydb.env_traffic_area(id, set_envelope) AS geom FROM citydb.traffic_area WHERE transportation_complex_id = co_id
      UNION ALL
    -- AuxiliaryTrafficArea
    SELECT citydb.env_traffic_area(id, set_envelope) AS geom FROM citydb.traffic_area WHERE transportation_complex_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tunnel(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod1Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1TerrainIntersection
    SELECT lod1_terrain_intersection AS geom FROM citydb.tunnel WHERE id = co_id  AND lod1_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod2Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2MultiCurve
    SELECT lod2_multi_curve AS geom FROM citydb.tunnel WHERE id = co_id  AND lod2_multi_curve IS NOT NULL
      UNION ALL
    -- lod2TerrainIntersection
    SELECT lod2_terrain_intersection AS geom FROM citydb.tunnel WHERE id = co_id  AND lod2_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod3Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiCurve
    SELECT lod3_multi_curve AS geom FROM citydb.tunnel WHERE id = co_id  AND lod3_multi_curve IS NOT NULL
      UNION ALL
    -- lod3TerrainIntersection
    SELECT lod3_terrain_intersection AS geom FROM citydb.tunnel WHERE id = co_id  AND lod3_terrain_intersection IS NOT NULL
      UNION ALL
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiCurve
    SELECT lod4_multi_curve AS geom FROM citydb.tunnel WHERE id = co_id  AND lod4_multi_curve IS NOT NULL
      UNION ALL
    -- lod4TerrainIntersection
    SELECT lod4_terrain_intersection AS geom FROM citydb.tunnel WHERE id = co_id  AND lod4_terrain_intersection IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- TunnelInstallation
    SELECT citydb.env_tunnel_installation(id, set_envelope) AS geom FROM citydb.tunnel_installation WHERE tunnel_id = co_id
      UNION ALL
    -- IntTunnelInstallation
    SELECT citydb.env_tunnel_installation(id, set_envelope) AS geom FROM citydb.tunnel_installation WHERE tunnel_id = co_id
      UNION ALL
    -- _BoundarySurface
    SELECT citydb.env_tunnel_thematic_surface(id, set_envelope) AS geom FROM citydb.tunnel_thematic_surface WHERE tunnel_id = co_id
      UNION ALL
    -- HollowSpace
    SELECT citydb.env_tunnel_hollow_space(id, set_envelope) AS geom FROM citydb.tunnel_hollow_space WHERE tunnel_id = co_id
      UNION ALL
    -- TunnelPart
    SELECT citydb.env_tunnel(id, set_envelope) AS geom FROM citydb.tunnel WHERE tunnel_parent_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tunnel_furniture(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_furniture t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.tunnel_furniture WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.tunnel_furniture WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tunnel_hollow_space(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_hollow_space t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_hollow_space t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BoundarySurface
    SELECT citydb.env_tunnel_thematic_surface(id, set_envelope) AS geom FROM citydb.tunnel_thematic_surface WHERE tunnel_hollow_space_id = co_id
      UNION ALL
    -- TunnelFurniture
    SELECT citydb.env_tunnel_furniture(id, set_envelope) AS geom FROM citydb.tunnel_furniture WHERE tunnel_hollow_space_id = co_id
      UNION ALL
    -- IntTunnelInstallation
    SELECT citydb.env_tunnel_installation(id, set_envelope) AS geom FROM citydb.tunnel_installation WHERE tunnel_hollow_space_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tunnel_installation(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_installation t WHERE sg.root_id = t.lod2_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Geometry
    SELECT lod2_other_geom AS geom FROM citydb.tunnel_installation WHERE id = co_id  AND lod2_other_geom IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_installation t WHERE sg.root_id = t.lod3_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Geometry
    SELECT lod3_other_geom AS geom FROM citydb.tunnel_installation WHERE id = co_id  AND lod3_other_geom IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.tunnel_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod2ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod2_implicit_rep_id, lod2_implicit_ref_point, lod2_implicit_transformation) AS geom FROM citydb.tunnel_installation WHERE id = co_id AND lod2_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.tunnel_installation WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.tunnel_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_installation t WHERE sg.root_id = t.lod4_brep_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Geometry
    SELECT lod4_other_geom AS geom FROM citydb.tunnel_installation WHERE id = co_id  AND lod4_other_geom IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.tunnel_installation WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _BoundarySurface
    SELECT citydb.env_tunnel_thematic_surface(id, set_envelope) AS geom FROM citydb.tunnel_thematic_surface WHERE tunnel_installation_id = co_id
      UNION ALL
    -- _BoundarySurface
    SELECT citydb.env_tunnel_thematic_surface(id, set_envelope) AS geom FROM citydb.tunnel_thematic_surface WHERE tunnel_installation_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tunnel_opening(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_opening t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_opening t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod3_implicit_rep_id, lod3_implicit_ref_point, lod3_implicit_transformation) AS geom FROM citydb.tunnel_opening WHERE id = co_id AND lod3_implicit_rep_id IS NOT NULL
      UNION ALL
    -- lod4ImplicitRepresentation
    SELECT citydb.get_envelope_implicit_geometry(lod4_implicit_rep_id, lod4_implicit_ref_point, lod4_implicit_transformation) AS geom FROM citydb.tunnel_opening WHERE id = co_id AND lod4_implicit_rep_id IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_tunnel_thematic_surface(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
  bbox4 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_thematic_surface t WHERE sg.root_id = t.lod2_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_thematic_surface t WHERE sg.root_id = t.lod3_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.tunnel_thematic_surface t WHERE sg.root_id = t.lod4_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _Opening
    SELECT citydb.env_tunnel_opening(id, set_envelope) AS geom FROM citydb.tunnel_opening c, citydb.tunnel_open_to_them_srf p2c WHERE c.id = tunnel_opening_id AND p2c.tunnel_thematic_surface_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_waterbody(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod0MultiCurve
    SELECT lod0_multi_curve AS geom FROM citydb.waterbody WHERE id = co_id  AND lod0_multi_curve IS NOT NULL
      UNION ALL
    -- lod0MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterbody t WHERE sg.root_id = t.lod0_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1MultiCurve
    SELECT lod1_multi_curve AS geom FROM citydb.waterbody WHERE id = co_id  AND lod1_multi_curve IS NOT NULL
      UNION ALL
    -- lod1MultiSurface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterbody t WHERE sg.root_id = t.lod1_multi_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod1Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterbody t WHERE sg.root_id = t.lod1_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod2Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterbody t WHERE sg.root_id = t.lod2_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterbody t WHERE sg.root_id = t.lod3_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Solid
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterbody t WHERE sg.root_id = t.lod4_solid_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- bbox from aggregating objects
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox3 FROM (
    -- _WaterBoundarySurface
    SELECT citydb.env_waterboundary_surface(id, set_envelope) AS geom FROM citydb.waterboundary_surface c, citydb.waterbod_to_waterbnd_srf p2c WHERE c.id = waterboundary_surface_id AND p2c.waterbody_id = co_id
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2, bbox3]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.env_waterboundary_surface(co_id INTEGER, set_envelope INTEGER DEFAULT 0, caller INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  class_id INTEGER DEFAULT 0;
  bbox0 GEOMETRY;
  bbox1 GEOMETRY;
  bbox2 GEOMETRY;
  bbox3 GEOMETRY;
BEGIN
  -- bbox from parent table
  IF caller <> 1 THEN
    bbox1 := citydb.env_cityobject(co_id, set_envelope, 2);
  END IF;

  -- bbox from inline and referencing spatial columns
  SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox2 FROM (
    -- lod2Surface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterboundary_surface t WHERE sg.root_id = t.lod2_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod3Surface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterboundary_surface t WHERE sg.root_id = t.lod3_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
      UNION ALL
    -- lod4Surface
    SELECT sg.geometry AS geom FROM citydb.surface_geometry sg, citydb.waterboundary_surface t WHERE sg.root_id = t.lod4_surface_id AND t.id = co_id AND sg.geometry IS NOT NULL
  ) g;

  -- assemble all bboxes
  bbox0 := citydb.box2envelope(ST_Union(ARRAY[bbox0, bbox1, bbox2]));

  IF set_envelope <> 0 AND bbox0 IS NOT NULL THEN
    UPDATE cityobject SET envelope = bbox0 WHERE id = co_id;
  END IF;

  RETURN bbox0;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.get_envelope_cityobjects(objclass_id INTEGER DEFAULT 0, set_envelope INTEGER DEFAULT 0, only_if_null INTEGER DEFAULT 1) RETURNS GEOMETRY AS
$body$
DECLARE
  bbox GEOMETRY;
BEGIN
  IF set_envelope = 1 AND only_if_null <> 0 THEN
    RETURN set_envelope_cityobjects_if_null(objclass_id);
  END IF;

  IF objclass_id <> 0 THEN
    SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox FROM (
      SELECT citydb.env_cityobject(id, 1) AS geom
        FROM citydb.cityobject WHERE objectclass_id = objclass_id
    ) g;
  ELSE
    SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox FROM (
      SELECT citydb.env_cityobject(id, 1) AS geom
        FROM citydb.cityobject
    ) g;
  END IF;

  RETURN bbox;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION citydb.get_envelope_implicit_geometry(implicit_rep_id INTEGER, ref_pt GEOMETRY, transform4x4 VARCHAR) RETURNS GEOMETRY AS
$body$
DECLARE
  envelope GEOMETRY;
  params DOUBLE PRECISION[ ] := '{}';
BEGIN
  -- calculate bounding box for implicit geometry

  SELECT box2envelope(ST_3DExtent(geom)) INTO envelope FROM (
    -- relative other geometry

    SELECT relative_other_geom AS geom 
      FROM citydb.implicit_geometry
        WHERE id = implicit_rep_id
          AND relative_other_geom IS NOT NULL
    UNION ALL
    -- relative brep geometry
    SELECT sg.implicit_geometry AS geom
      FROM citydb.surface_geometry sg, citydb.implicit_geometry ig
        WHERE sg.root_id = ig.relative_brep_id 
          AND ig.id = implicit_rep_id 
          AND sg.implicit_geometry IS NOT NULL
  ) g;

  IF transform4x4 IS NOT NULL THEN
    -- -- extract parameters of transformation matrix
    params := string_to_array(transform4x4, ' ')::float8[];

    IF array_length(params, 1) < 12 THEN
      RAISE EXCEPTION 'Malformed transformation matrix: %', transform4x4 USING HINT = '16 values are required';
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
    -- perform affine transformation against given transformation matrix
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

CREATE OR REPLACE FUNCTION citydb.set_envelope_cityobjects_if_null(objclass_id INTEGER DEFAULT 0) RETURNS GEOMETRY AS
$body$
DECLARE
  bbox GEOMETRY;
BEGIN
  IF objclass_id <> 0 THEN
    SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox FROM (
      SELECT citydb.env_cityobject(id, 1) AS geom
        FROM citydb.cityobject WHERE envelope IS NULL AND objectclass_id = objclass_id
    ) g;
  ELSE
    SELECT citydb.box2envelope(ST_3DExtent(geom)) INTO bbox FROM (
      SELECT citydb.env_cityobject(id, 1) AS geom
        FROM citydb.cityobject WHERE envelope IS NULL
    ) g;
  END IF;

  RETURN bbox;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------
