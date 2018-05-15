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

-- Automatically generated 3DcityDB-delete-functions (Creation Date: 2018-05-12 10:20:09)
-- del_address
-- del_appearance
-- del_breakline_relief
-- del_bridge
-- del_bridge_constr_element
-- del_bridge_furniture
-- del_bridge_installation
-- del_bridge_opening
-- del_bridge_room
-- del_bridge_thematic_surface
-- del_building
-- del_building_furniture
-- del_building_installation
-- del_city_furniture
-- del_citymodel
-- del_cityobject
-- del_cityobject_genericattrib
-- del_cityobjectgroup
-- cleanup_global_appearances
-- del_cityobject_by_lineage
-- del_external_reference
-- del_generic_cityobject
-- del_grid_coverage
-- del_implicit_geometry
-- del_land_use
-- del_masspoint_relief
-- del_opening
-- del_plant_cover
-- del_raster_relief
-- del_relief_component
-- del_relief_feature
-- del_room
-- del_solitary_vegetat_object
-- del_surface_data
-- del_surface_geometry
-- del_tex_image
-- del_thematic_surface
-- del_tin_relief
-- del_traffic_area
-- del_transportation_complex
-- del_tunnel
-- del_tunnel_furniture
-- del_tunnel_hollow_space
-- del_tunnel_installation
-- del_tunnel_opening
-- del_tunnel_thematic_surface
-- del_waterbody
-- del_waterboundary_surface
------------------------------------------

------------------------------------------

CREATE OR REPLACE FUNCTION del_address(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete addresss
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_appearance(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_data_ids int[] := '{}';
BEGIN
  -- delete references to surface_datas
  WITH del_surface_data_refs AS (
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
    del_surface_data_refs;

  -- delete surface_data(s)
  IF -1 = ALL(surface_data_ids) IS NOT NULL THEN
    PERFORM
      del_surface_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_data_ids) AS a_id) a
    LEFT JOIN
      appear_to_surface_data n1
      ON n1.surface_data_id  = a.a_id
    WHERE n1.surface_data_id IS NULL;
  END IF;

  -- delete appearances
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_breakline_relief(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete breakline_reliefs
  WITH delete_objects AS (
    DELETE FROM
      breakline_relief t
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

  IF $2 <> 1 THEN
    -- delete relief_component
    PERFORM del_relief_component(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  address_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete referenced parts
  PERFORM
    del_bridge(array_agg(t.id))
  FROM
    bridge t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete referenced parts
  PERFORM
    del_bridge(array_agg(t.id))
  FROM
    bridge t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_root_id = a.a_id
    AND t.id != a.a_id;

  -- delete references to addresss
  WITH del_address_refs AS (
    DELETE FROM
      address_to_bridge t
    USING
      unnest($1) a(a_id)
    WHERE
      t.bridge_id = a.a_id
    RETURNING
      t.address_id
  )
  SELECT
    array_agg(address_id)
  INTO
    address_ids
  FROM
    del_address_refs;

  -- delete address(s)
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    PERFORM
      del_address(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_bridge n1
      ON n1.address_id  = a.a_id
    LEFT JOIN
      address_to_building n2
      ON n2.address_id  = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id  = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id  = a.a_id
    WHERE n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  --delete bridge_constr_elements
  PERFORM
    del_bridge_constr_element(array_agg(t.id))
  FROM
    bridge_constr_element t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  --delete bridge_installations
  PERFORM
    del_bridge_installation(array_agg(t.id))
  FROM
    bridge_installation t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  --delete bridge_rooms
  PERFORM
    del_bridge_room(array_agg(t.id))
  FROM
    bridge_room t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  --delete bridge_thematic_surfaces
  PERFORM
    del_bridge_thematic_surface(array_agg(t.id))
  FROM
    bridge_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  -- delete bridges
  WITH delete_objects AS (
    DELETE FROM
      bridge t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id,
      lod1_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod1_solid_id) ||
    array_agg(lod2_solid_id) ||
    array_agg(lod3_solid_id) ||
    array_agg(lod4_solid_id) ||
    array_agg(lod1_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge_constr_element(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete bridge_constr_elements
  WITH delete_objects AS (
    DELETE FROM
      bridge_constr_element t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod1_implicit_rep_id,
      lod1_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod2_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod1_implicit_rep_id),
    array_agg(lod1_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id) ||
    array_agg(lod2_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge_furniture(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete bridge_furnitures
  WITH delete_objects AS (
    DELETE FROM
      bridge_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_implicit_rep_id,
      lod4_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id),
    array_agg(lod4_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge_installation(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete bridge_thematic_surfaces
  PERFORM
    del_bridge_thematic_surface(array_agg(t.id))
  FROM
    bridge_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_installation_id = a.a_id;

  -- delete bridge_installations
  WITH delete_objects AS (
    DELETE FROM
      bridge_installation t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id),
    array_agg(lod2_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge_opening(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
  address_ids int[] := '{}';
BEGIN
  -- delete bridge_openings
  WITH delete_objects AS (
    DELETE FROM
      bridge_opening t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      address_id
  )
  SELECT
    array_agg(id),
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id),
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id),
    array_agg(address_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids,
    address_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  -- delete address(s)
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    PERFORM
      del_address(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_bridge n1
      ON n1.address_id  = a.a_id
    LEFT JOIN
      address_to_building n2
      ON n2.address_id  = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id  = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id  = a.a_id
    WHERE n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge_room(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete bridge_furnitures
  PERFORM
    del_bridge_furniture(array_agg(t.id))
  FROM
    bridge_furniture t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_room_id = a.a_id;

  --delete bridge_installations
  PERFORM
    del_bridge_installation(array_agg(t.id))
  FROM
    bridge_installation t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_room_id = a.a_id;

  --delete bridge_thematic_surfaces
  PERFORM
    del_bridge_thematic_surface(array_agg(t.id))
  FROM
    bridge_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_room_id = a.a_id;

  -- delete bridge_rooms
  WITH delete_objects AS (
    DELETE FROM
      bridge_room t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_multi_surface_id,
      lod4_solid_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod4_solid_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_bridge_thematic_surface(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  bridge_opening_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete references to bridge_openings
  WITH del_bridge_opening_refs AS (
    DELETE FROM
      bridge_open_to_them_srf t
    USING
      unnest($1) a(a_id)
    WHERE
      t.bridge_thematic_surface_id = a.a_id
    RETURNING
      t.bridge_opening_id
  )
  SELECT
    array_agg(bridge_opening_id)
  INTO
    bridge_opening_ids
  FROM
    del_bridge_opening_refs;

  -- delete bridge_opening(s)
  IF -1 = ALL(bridge_opening_ids) IS NOT NULL THEN
    PERFORM
      del_bridge_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(bridge_opening_ids) AS a_id) a;
  END IF;

  -- delete bridge_thematic_surfaces
  WITH delete_objects AS (
    DELETE FROM
      bridge_thematic_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_building(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  address_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete referenced parts
  PERFORM
    del_building(array_agg(t.id))
  FROM
    building t,
    unnest($1) a(a_id)
  WHERE
    t.building_parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete referenced parts
  PERFORM
    del_building(array_agg(t.id))
  FROM
    building t,
    unnest($1) a(a_id)
  WHERE
    t.building_root_id = a.a_id
    AND t.id != a.a_id;

  -- delete references to addresss
  WITH del_address_refs AS (
    DELETE FROM
      address_to_building t
    USING
      unnest($1) a(a_id)
    WHERE
      t.building_id = a.a_id
    RETURNING
      t.address_id
  )
  SELECT
    array_agg(address_id)
  INTO
    address_ids
  FROM
    del_address_refs;

  -- delete address(s)
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    PERFORM
      del_address(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_bridge n1
      ON n1.address_id  = a.a_id
    LEFT JOIN
      address_to_building n2
      ON n2.address_id  = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id  = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id  = a.a_id
    WHERE n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  --delete building_installations
  PERFORM
    del_building_installation(array_agg(t.id))
  FROM
    building_installation t,
    unnest($1) a(a_id)
  WHERE
    t.building_id = a.a_id;

  --delete rooms
  PERFORM
    del_room(array_agg(t.id))
  FROM
    room t,
    unnest($1) a(a_id)
  WHERE
    t.building_id = a.a_id;

  --delete thematic_surfaces
  PERFORM
    del_thematic_surface(array_agg(t.id))
  FROM
    thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.building_id = a.a_id;

  -- delete buildings
  WITH delete_objects AS (
    DELETE FROM
      building t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod0_roofprint_id,
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id,
      lod0_footprint_id
  )
  SELECT
    array_agg(id),
    array_agg(lod0_roofprint_id) ||
    array_agg(lod1_multi_surface_id) ||
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod1_solid_id) ||
    array_agg(lod2_solid_id) ||
    array_agg(lod3_solid_id) ||
    array_agg(lod4_solid_id) ||
    array_agg(lod0_footprint_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_building_furniture(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete building_furnitures
  WITH delete_objects AS (
    DELETE FROM
      building_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_implicit_rep_id,
      lod4_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id),
    array_agg(lod4_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_building_installation(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete thematic_surfaces
  PERFORM
    del_thematic_surface(array_agg(t.id))
  FROM
    thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.building_installation_id = a.a_id;

  -- delete building_installations
  WITH delete_objects AS (
    DELETE FROM
      building_installation t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id),
    array_agg(lod2_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_city_furniture(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete city_furnitures
  WITH delete_objects AS (
    DELETE FROM
      city_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod1_implicit_rep_id,
      lod1_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod2_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod1_implicit_rep_id),
    array_agg(lod1_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id) ||
    array_agg(lod2_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_citymodel(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  cityobject_ids int[] := '{}';
BEGIN
  --delete appearances
  PERFORM
    del_appearance(array_agg(t.id))
  FROM
    appearance t,
    unnest($1) a(a_id)
  WHERE
    t.citymodel_id = a.a_id;

  -- delete references to cityobjects
  WITH del_cityobject_refs AS (
    DELETE FROM
      cityobject_member t
    USING
      unnest($1) a(a_id)
    WHERE
      t.citymodel_id = a.a_id
    RETURNING
      t.cityobject_id
  )
  SELECT
    array_agg(cityobject_id)
  INTO
    cityobject_ids
  FROM
    del_cityobject_refs;

  -- delete cityobject(s)
  IF -1 = ALL(cityobject_ids) IS NOT NULL THEN
    PERFORM
      del_cityobject(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(cityobject_ids) AS a_id) a
    LEFT JOIN
      cityobject_member n1
      ON n1.cityobject_id  = a.a_id
    LEFT JOIN
      cityobjectgroup n2
      ON n2.parent_cityobject_id  = a.a_id
    LEFT JOIN
      group_to_cityobject n3
      ON n3.cityobject_id  = a.a_id
    WHERE n1.cityobject_id IS NULL
      AND n2.parent_cityobject_id IS NULL
      AND n3.cityobject_id IS NULL;
  END IF;

  -- delete citymodels
  WITH delete_objects AS (
    DELETE FROM
      citymodel t
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_cityobject(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  --delete appearances
  PERFORM
    del_appearance(array_agg(t.id))
  FROM
    appearance t,
    unnest($1) a(a_id)
  WHERE
    t.cityobject_id = a.a_id;

  --delete cityobject_genericattribs
  PERFORM
    del_cityobject_genericattrib(array_agg(t.id))
  FROM
    cityobject_genericattrib t,
    unnest($1) a(a_id)
  WHERE
    t.cityobject_id = a.a_id;

  --delete external_references
  PERFORM
    del_external_reference(array_agg(t.id))
  FROM
    external_reference t,
    unnest($1) a(a_id)
  WHERE
    t.cityobject_id = a.a_id;

  IF $2 <> 2 THEN
    FOREACH object_id IN ARRAY $1
    LOOP
      EXECUTE format('SELECT objectclass_id FROM cityobject WHERE id = %L', object_id) INTO objectclass_id;

      -- delete land_use
      IF objectclass_id = 4 THEN
        PERFORM del_land_use(array_agg(object_id), 1);
      END IF;

      -- delete generic_cityobject
      IF objectclass_id = 5 THEN
        PERFORM del_generic_cityobject(array_agg(object_id), 1);
      END IF;

      -- delete solitary_vegetat_object
      IF objectclass_id = 7 THEN
        PERFORM del_solitary_vegetat_object(array_agg(object_id), 1);
      END IF;

      -- delete plant_cover
      IF objectclass_id = 8 THEN
        PERFORM del_plant_cover(array_agg(object_id), 1);
      END IF;

      -- delete waterbody
      IF objectclass_id = 9 THEN
        PERFORM del_waterbody(array_agg(object_id), 1);
      END IF;

      -- delete waterboundary_surface
      IF objectclass_id = 10 THEN
        PERFORM del_waterboundary_surface(array_agg(object_id), 1);
      END IF;

      -- delete waterboundary_surface
      IF objectclass_id = 11 THEN
        PERFORM del_waterboundary_surface(array_agg(object_id), 1);
      END IF;

      -- delete waterboundary_surface
      IF objectclass_id = 12 THEN
        PERFORM del_waterboundary_surface(array_agg(object_id), 1);
      END IF;

      -- delete waterboundary_surface
      IF objectclass_id = 13 THEN
        PERFORM del_waterboundary_surface(array_agg(object_id), 1);
      END IF;

      -- delete relief_feature
      IF objectclass_id = 14 THEN
        PERFORM del_relief_feature(array_agg(object_id), 1);
      END IF;

      -- delete relief_component
      IF objectclass_id = 15 THEN
        PERFORM del_relief_component(array_agg(object_id), 1);
      END IF;

      -- delete tin_relief
      IF objectclass_id = 16 THEN
        PERFORM del_tin_relief(array_agg(object_id), 0);
      END IF;

      -- delete masspoint_relief
      IF objectclass_id = 17 THEN
        PERFORM del_masspoint_relief(array_agg(object_id), 0);
      END IF;

      -- delete breakline_relief
      IF objectclass_id = 18 THEN
        PERFORM del_breakline_relief(array_agg(object_id), 0);
      END IF;

      -- delete raster_relief
      IF objectclass_id = 19 THEN
        PERFORM del_raster_relief(array_agg(object_id), 0);
      END IF;

      -- delete city_furniture
      IF objectclass_id = 21 THEN
        PERFORM del_city_furniture(array_agg(object_id), 1);
      END IF;

      -- delete cityobjectgroup
      IF objectclass_id = 23 THEN
        PERFORM del_cityobjectgroup(array_agg(object_id), 1);
      END IF;

      -- delete building
      IF objectclass_id = 24 THEN
        PERFORM del_building(array_agg(object_id), 1);
      END IF;

      -- delete building
      IF objectclass_id = 25 THEN
        PERFORM del_building(array_agg(object_id), 1);
      END IF;

      -- delete building
      IF objectclass_id = 26 THEN
        PERFORM del_building(array_agg(object_id), 1);
      END IF;

      -- delete building_installation
      IF objectclass_id = 27 THEN
        PERFORM del_building_installation(array_agg(object_id), 1);
      END IF;

      -- delete building_installation
      IF objectclass_id = 28 THEN
        PERFORM del_building_installation(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 29 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 30 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 31 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 32 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 33 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 34 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 35 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 36 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete opening
      IF objectclass_id = 37 THEN
        PERFORM del_opening(array_agg(object_id), 1);
      END IF;

      -- delete opening
      IF objectclass_id = 38 THEN
        PERFORM del_opening(array_agg(object_id), 1);
      END IF;

      -- delete opening
      IF objectclass_id = 39 THEN
        PERFORM del_opening(array_agg(object_id), 1);
      END IF;

      -- delete building_furniture
      IF objectclass_id = 40 THEN
        PERFORM del_building_furniture(array_agg(object_id), 1);
      END IF;

      -- delete room
      IF objectclass_id = 41 THEN
        PERFORM del_room(array_agg(object_id), 1);
      END IF;

      -- delete transportation_complex
      IF objectclass_id = 42 THEN
        PERFORM del_transportation_complex(array_agg(object_id), 1);
      END IF;

      -- delete transportation_complex
      IF objectclass_id = 43 THEN
        PERFORM del_transportation_complex(array_agg(object_id), 1);
      END IF;

      -- delete transportation_complex
      IF objectclass_id = 44 THEN
        PERFORM del_transportation_complex(array_agg(object_id), 1);
      END IF;

      -- delete transportation_complex
      IF objectclass_id = 45 THEN
        PERFORM del_transportation_complex(array_agg(object_id), 1);
      END IF;

      -- delete transportation_complex
      IF objectclass_id = 46 THEN
        PERFORM del_transportation_complex(array_agg(object_id), 1);
      END IF;

      -- delete traffic_area
      IF objectclass_id = 47 THEN
        PERFORM del_traffic_area(array_agg(object_id), 1);
      END IF;

      -- delete traffic_area
      IF objectclass_id = 48 THEN
        PERFORM del_traffic_area(array_agg(object_id), 1);
      END IF;

      -- delete appearance
      IF objectclass_id = 50 THEN
        PERFORM del_appearance(array_agg(object_id), 0);
      END IF;

      -- delete surface_data
      IF objectclass_id = 51 THEN
        PERFORM del_surface_data(array_agg(object_id), 0);
      END IF;

      -- delete surface_data
      IF objectclass_id = 52 THEN
        PERFORM del_surface_data(array_agg(object_id), 0);
      END IF;

      -- delete surface_data
      IF objectclass_id = 53 THEN
        PERFORM del_surface_data(array_agg(object_id), 0);
      END IF;

      -- delete surface_data
      IF objectclass_id = 54 THEN
        PERFORM del_surface_data(array_agg(object_id), 0);
      END IF;

      -- delete surface_data
      IF objectclass_id = 55 THEN
        PERFORM del_surface_data(array_agg(object_id), 0);
      END IF;

      -- delete citymodel
      IF objectclass_id = 57 THEN
        PERFORM del_citymodel(array_agg(object_id), 0);
      END IF;

      -- delete address
      IF objectclass_id = 58 THEN
        PERFORM del_address(array_agg(object_id), 0);
      END IF;

      -- delete implicit_geometry
      IF objectclass_id = 59 THEN
        PERFORM del_implicit_geometry(array_agg(object_id), 0);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 60 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete thematic_surface
      IF objectclass_id = 61 THEN
        PERFORM del_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge
      IF objectclass_id = 62 THEN
        PERFORM del_bridge(array_agg(object_id), 1);
      END IF;

      -- delete bridge
      IF objectclass_id = 63 THEN
        PERFORM del_bridge(array_agg(object_id), 1);
      END IF;

      -- delete bridge
      IF objectclass_id = 64 THEN
        PERFORM del_bridge(array_agg(object_id), 1);
      END IF;

      -- delete bridge_installation
      IF objectclass_id = 65 THEN
        PERFORM del_bridge_installation(array_agg(object_id), 1);
      END IF;

      -- delete bridge_installation
      IF objectclass_id = 66 THEN
        PERFORM del_bridge_installation(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 67 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 68 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 69 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 70 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 71 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 72 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 73 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 74 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 75 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_thematic_surface
      IF objectclass_id = 76 THEN
        PERFORM del_bridge_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete bridge_opening
      IF objectclass_id = 77 THEN
        PERFORM del_bridge_opening(array_agg(object_id), 1);
      END IF;

      -- delete bridge_opening
      IF objectclass_id = 78 THEN
        PERFORM del_bridge_opening(array_agg(object_id), 1);
      END IF;

      -- delete bridge_opening
      IF objectclass_id = 79 THEN
        PERFORM del_bridge_opening(array_agg(object_id), 1);
      END IF;

      -- delete bridge_furniture
      IF objectclass_id = 80 THEN
        PERFORM del_bridge_furniture(array_agg(object_id), 1);
      END IF;

      -- delete bridge_room
      IF objectclass_id = 81 THEN
        PERFORM del_bridge_room(array_agg(object_id), 1);
      END IF;

      -- delete bridge_constr_element
      IF objectclass_id = 82 THEN
        PERFORM del_bridge_constr_element(array_agg(object_id), 1);
      END IF;

      -- delete tunnel
      IF objectclass_id = 83 THEN
        PERFORM del_tunnel(array_agg(object_id), 1);
      END IF;

      -- delete tunnel
      IF objectclass_id = 84 THEN
        PERFORM del_tunnel(array_agg(object_id), 1);
      END IF;

      -- delete tunnel
      IF objectclass_id = 85 THEN
        PERFORM del_tunnel(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_installation
      IF objectclass_id = 86 THEN
        PERFORM del_tunnel_installation(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_installation
      IF objectclass_id = 87 THEN
        PERFORM del_tunnel_installation(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 88 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 89 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 90 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 91 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 92 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 93 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 94 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 95 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 96 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_thematic_surface
      IF objectclass_id = 97 THEN
        PERFORM del_tunnel_thematic_surface(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_opening
      IF objectclass_id = 98 THEN
        PERFORM del_tunnel_opening(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_opening
      IF objectclass_id = 99 THEN
        PERFORM del_tunnel_opening(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_opening
      IF objectclass_id = 100 THEN
        PERFORM del_tunnel_opening(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_furniture
      IF objectclass_id = 101 THEN
        PERFORM del_tunnel_furniture(array_agg(object_id), 1);
      END IF;

      -- delete tunnel_hollow_space
      IF objectclass_id = 102 THEN
        PERFORM del_tunnel_hollow_space(array_agg(object_id), 1);
      END IF;
    END LOOP;
  END IF;

  -- delete cityobjects
  WITH delete_objects AS (
    DELETE FROM
      cityobject t
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_cityobject_genericattrib(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete cityobject_genericattribs
  WITH delete_objects AS (
    DELETE FROM
      cityobject_genericattrib t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      surface_geometry_id
  )
  SELECT
    array_agg(id),
    array_agg(surface_geometry_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_cityobjectgroup(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  cityobject_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete references to cityobjects
  WITH del_cityobject_refs AS (
    DELETE FROM
      group_to_cityobject t
    USING
      unnest($1) a(a_id)
    WHERE
      t.cityobjectgroup_id = a.a_id
    RETURNING
      t.cityobject_id
  )
  SELECT
    array_agg(cityobject_id)
  INTO
    cityobject_ids
  FROM
    del_cityobject_refs;

  -- delete cityobject(s)
  IF -1 = ALL(cityobject_ids) IS NOT NULL THEN
    PERFORM
      del_cityobject(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(cityobject_ids) AS a_id) a
    LEFT JOIN
      cityobject_member n1
      ON n1.cityobject_id  = a.a_id
    LEFT JOIN
      cityobjectgroup n2
      ON n2.parent_cityobject_id  = a.a_id
    LEFT JOIN
      group_to_cityobject n3
      ON n3.cityobject_id  = a.a_id
    WHERE n1.cityobject_id IS NULL
      AND n2.parent_cityobject_id IS NULL
      AND n3.cityobject_id IS NULL;
  END IF;

  -- delete cityobjectgroups
  WITH delete_objects AS (
    DELETE FROM
      cityobjectgroup t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      brep_id
  )
  SELECT
    array_agg(id),
    array_agg(brep_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION cleanup_global_appearances() RETURNS SETOF int AS
$body$
-- Function for cleaning up global appearance
DECLARE
  deleted_id int;
  app_id int;
BEGIN
  PERFORM del_surface_data(array_agg(s.id))
    FROM surface_data s 
    LEFT OUTER JOIN textureparam t ON s.id = t.surface_data_id
    WHERE t.surface_data_id IS NULL;

    FOR app_id IN
      SELECT a.id FROM appearance a
        LEFT OUTER JOIN appear_to_surface_data asd ON a.id=asd.appearance_id
          WHERE a.cityobject_id IS NULL AND asd.appearance_id IS NULL
    LOOP
      DELETE FROM appearance WHERE id = app_id RETURNING id INTO deleted_id;
      RETURN NEXT deleted_id;
    END LOOP;

  RETURN;
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_cityobject_by_lineage(lineage_value TEXT, objectclass_id INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
-- Function for deleting cityobjects by lineage value
DECLARE
  deleted_ids int[] := '{}';
BEGIN
  IF $2 = 0 THEN
    SELECT array_agg(c.id) FROM
      cityobject c
    INTO
      deleted_ids
    WHERE
      c.lineage = $1;
  ELSE
    SELECT array_agg(c.id) FROM
      cityobject c
    INTO
      deleted_ids
    WHERE
      c.lineage = $1 AND c.objectclass_id = $2;
  END IF;

  IF -1 = ALL(deleted_ids) IS NOT NULL THEN
    PERFORM del_cityobject(deleted_ids);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_external_reference(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete external_references
  WITH delete_objects AS (
    DELETE FROM
      external_reference t
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_generic_cityobject(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete generic_cityobjects
  WITH delete_objects AS (
    DELETE FROM
      generic_cityobject t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod0_implicit_rep_id,
      lod0_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod1_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod0_implicit_rep_id),
    array_agg(lod0_brep_id) ||
    array_agg(lod2_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id) ||
    array_agg(lod1_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_grid_coverage(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete grid_coverages
  WITH delete_objects AS (
    DELETE FROM
      grid_coverage t
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_implicit_geometry(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete implicit_geometrys
  WITH delete_objects AS (
    DELETE FROM
      implicit_geometry t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      relative_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(relative_brep_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_land_use(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete land_uses
  WITH delete_objects AS (
    DELETE FROM
      land_use t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod1_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod2_multi_surface_id,
      lod0_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod0_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_masspoint_relief(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete masspoint_reliefs
  WITH delete_objects AS (
    DELETE FROM
      masspoint_relief t
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

  IF $2 <> 1 THEN
    -- delete relief_component
    PERFORM del_relief_component(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_opening(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
  address_ids int[] := '{}';
BEGIN
  -- delete openings
  WITH delete_objects AS (
    DELETE FROM
      opening t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      address_id
  )
  SELECT
    array_agg(id),
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id),
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id),
    array_agg(address_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids,
    address_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  -- delete address(s)
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    PERFORM
      del_address(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_bridge n1
      ON n1.address_id  = a.a_id
    LEFT JOIN
      address_to_building n2
      ON n2.address_id  = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id  = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id  = a.a_id
    WHERE n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_plant_cover(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete plant_covers
  WITH delete_objects AS (
    DELETE FROM
      plant_cover t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod1_multi_solid_id,
      lod2_multi_solid_id,
      lod3_multi_solid_id,
      lod4_multi_solid_id,
      lod1_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod1_multi_solid_id) ||
    array_agg(lod2_multi_solid_id) ||
    array_agg(lod3_multi_solid_id) ||
    array_agg(lod4_multi_solid_id) ||
    array_agg(lod1_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_raster_relief(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  grid_coverage_ids int[] := '{}';
BEGIN
  -- delete raster_reliefs
  WITH delete_objects AS (
    DELETE FROM
      raster_relief t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      coverage_id
  )
  SELECT
    array_agg(id),
    array_agg(coverage_id)
  INTO
    deleted_ids,
    grid_coverage_ids
  FROM
    delete_objects;

  -- delete grid_coverage(s)
  IF -1 = ALL(grid_coverage_ids) IS NOT NULL THEN
    PERFORM
      del_grid_coverage(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(grid_coverage_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete relief_component
    PERFORM del_relief_component(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_relief_component(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  IF $2 <> 2 THEN
    FOREACH object_id IN ARRAY $1
    LOOP
      EXECUTE format('SELECT objectclass_id FROM relief_component WHERE id = %L', object_id) INTO objectclass_id;

      -- delete tin_relief
      IF objectclass_id = 16 THEN
        PERFORM del_tin_relief(array_agg(object_id), 1);
      END IF;

      -- delete masspoint_relief
      IF objectclass_id = 17 THEN
        PERFORM del_masspoint_relief(array_agg(object_id), 1);
      END IF;

      -- delete breakline_relief
      IF objectclass_id = 18 THEN
        PERFORM del_breakline_relief(array_agg(object_id), 1);
      END IF;

      -- delete raster_relief
      IF objectclass_id = 19 THEN
        PERFORM del_raster_relief(array_agg(object_id), 1);
      END IF;
    END LOOP;
  END IF;

  -- delete relief_components
  WITH delete_objects AS (
    DELETE FROM
      relief_component t
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

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_relief_feature(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  relief_component_ids int[] := '{}';
BEGIN
  -- delete references to relief_components
  WITH del_relief_component_refs AS (
    DELETE FROM
      relief_feat_to_rel_comp t
    USING
      unnest($1) a(a_id)
    WHERE
      t.relief_feature_id = a.a_id
    RETURNING
      t.relief_component_id
  )
  SELECT
    array_agg(relief_component_id)
  INTO
    relief_component_ids
  FROM
    del_relief_component_refs;

  -- delete relief_component(s)
  IF -1 = ALL(relief_component_ids) IS NOT NULL THEN
    PERFORM
      del_relief_component(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(relief_component_ids) AS a_id) a
    LEFT JOIN
      relief_feat_to_rel_comp n1
      ON n1.relief_component_id  = a.a_id
    WHERE n1.relief_component_id IS NULL;
  END IF;

  -- delete relief_features
  WITH delete_objects AS (
    DELETE FROM
      relief_feature t
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

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_room(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete building_furnitures
  PERFORM
    del_building_furniture(array_agg(t.id))
  FROM
    building_furniture t,
    unnest($1) a(a_id)
  WHERE
    t.room_id = a.a_id;

  --delete building_installations
  PERFORM
    del_building_installation(array_agg(t.id))
  FROM
    building_installation t,
    unnest($1) a(a_id)
  WHERE
    t.room_id = a.a_id;

  --delete thematic_surfaces
  PERFORM
    del_thematic_surface(array_agg(t.id))
  FROM
    thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.room_id = a.a_id;

  -- delete rooms
  WITH delete_objects AS (
    DELETE FROM
      room t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_multi_surface_id,
      lod4_solid_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod4_solid_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_solitary_vegetat_object(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete solitary_vegetat_objects
  WITH delete_objects AS (
    DELETE FROM
      solitary_vegetat_object t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod1_implicit_rep_id,
      lod1_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod2_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod1_implicit_rep_id),
    array_agg(lod1_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id) ||
    array_agg(lod2_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_surface_data(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  tex_image_ids int[] := '{}';
BEGIN
  -- delete surface_datas
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

  -- delete tex_image(s)
  IF -1 = ALL(tex_image_ids) IS NOT NULL THEN
    PERFORM
      del_tex_image(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(tex_image_ids) AS a_id) a
    LEFT JOIN
      surface_data n1
      ON n1.tex_image_id  = a.a_id
    WHERE n1.tex_image_id IS NULL;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_surface_geometry(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete referenced parts
  PERFORM
    del_surface_geometry(array_agg(t.id))
  FROM
    surface_geometry t,
    unnest($1) a(a_id)
  WHERE
    t.parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete referenced parts
  PERFORM
    del_surface_geometry(array_agg(t.id))
  FROM
    surface_geometry t,
    unnest($1) a(a_id)
  WHERE
    t.root_id = a.a_id
    AND t.id != a.a_id;

  -- delete surface_geometrys
  WITH delete_objects AS (
    DELETE FROM
      surface_geometry t
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_tex_image(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
BEGIN
  -- delete tex_images
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
------------------------------------------

CREATE OR REPLACE FUNCTION del_thematic_surface(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  opening_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete references to openings
  WITH del_opening_refs AS (
    DELETE FROM
      opening_to_them_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.thematic_surface_id = a.a_id
    RETURNING
      t.opening_id
  )
  SELECT
    array_agg(opening_id)
  INTO
    opening_ids
  FROM
    del_opening_refs;

  -- delete opening(s)
  IF -1 = ALL(opening_ids) IS NOT NULL THEN
    PERFORM
      del_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(opening_ids) AS a_id) a;
  END IF;

  -- delete thematic_surfaces
  WITH delete_objects AS (
    DELETE FROM
      thematic_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tin_relief(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete tin_reliefs
  WITH delete_objects AS (
    DELETE FROM
      tin_relief t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      surface_geometry_id
  )
  SELECT
    array_agg(id),
    array_agg(surface_geometry_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete relief_component
    PERFORM del_relief_component(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_traffic_area(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete traffic_areas
  WITH delete_objects AS (
    DELETE FROM
      traffic_area t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_transportation_complex(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete traffic_areas
  PERFORM
    del_traffic_area(array_agg(t.id))
  FROM
    traffic_area t,
    unnest($1) a(a_id)
  WHERE
    t.transportation_complex_id = a.a_id;

  -- delete transportation_complexs
  WITH delete_objects AS (
    DELETE FROM
      transportation_complex t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_multi_surface_id) ||
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tunnel(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete referenced parts
  PERFORM
    del_tunnel(array_agg(t.id))
  FROM
    tunnel t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete referenced parts
  PERFORM
    del_tunnel(array_agg(t.id))
  FROM
    tunnel t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_root_id = a.a_id
    AND t.id != a.a_id;

  --delete tunnel_hollow_spaces
  PERFORM
    del_tunnel_hollow_space(array_agg(t.id))
  FROM
    tunnel_hollow_space t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_id = a.a_id;

  --delete tunnel_installations
  PERFORM
    del_tunnel_installation(array_agg(t.id))
  FROM
    tunnel_installation t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_id = a.a_id;

  --delete tunnel_thematic_surfaces
  PERFORM
    del_tunnel_thematic_surface(array_agg(t.id))
  FROM
    tunnel_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_id = a.a_id;

  -- delete tunnels
  WITH delete_objects AS (
    DELETE FROM
      tunnel t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id,
      lod1_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod1_solid_id) ||
    array_agg(lod2_solid_id) ||
    array_agg(lod3_solid_id) ||
    array_agg(lod4_solid_id) ||
    array_agg(lod1_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tunnel_furniture(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete tunnel_furnitures
  WITH delete_objects AS (
    DELETE FROM
      tunnel_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_implicit_rep_id,
      lod4_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id),
    array_agg(lod4_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tunnel_hollow_space(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete tunnel_furnitures
  PERFORM
    del_tunnel_furniture(array_agg(t.id))
  FROM
    tunnel_furniture t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_hollow_space_id = a.a_id;

  --delete tunnel_installations
  PERFORM
    del_tunnel_installation(array_agg(t.id))
  FROM
    tunnel_installation t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_hollow_space_id = a.a_id;

  --delete tunnel_thematic_surfaces
  PERFORM
    del_tunnel_thematic_surface(array_agg(t.id))
  FROM
    tunnel_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_hollow_space_id = a.a_id;

  -- delete tunnel_hollow_spaces
  WITH delete_objects AS (
    DELETE FROM
      tunnel_hollow_space t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_multi_surface_id,
      lod4_solid_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_multi_surface_id) ||
    array_agg(lod4_solid_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tunnel_installation(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  --delete tunnel_thematic_surfaces
  PERFORM
    del_tunnel_thematic_surface(array_agg(t.id))
  FROM
    tunnel_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_installation_id = a.a_id;

  -- delete tunnel_installations
  WITH delete_objects AS (
    DELETE FROM
      tunnel_installation t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod4_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id),
    array_agg(lod2_brep_id) ||
    array_agg(lod3_brep_id) ||
    array_agg(lod4_brep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tunnel_opening(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  implicit_geometry_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete tunnel_openings
  WITH delete_objects AS (
    DELETE FROM
      tunnel_opening t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id),
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s)
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_furniture n5
      ON n5.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n6
      ON n6.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n7
      ON n7.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_installation n8
      ON n8.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n9
      ON n9.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      bridge_opening n10
      ON n10.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_furniture n11
      ON n11.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n12
      ON n12.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n13
      ON n13.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      building_installation n14
      ON n14.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n15
      ON n15.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n16
      ON n16.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n17
      ON n17.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      city_furniture n18
      ON n18.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n19
      ON n19.lod0_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n20
      ON n20.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n21
      ON n21.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n22
      ON n22.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      generic_cityobject n23
      ON n23.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n24
      ON n24.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      opening n25
      ON n25.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n26
      ON n26.lod1_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n27
      ON n27.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n28
      ON n28.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      solitary_vegetat_object n29
      ON n29.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_furniture n30
      ON n30.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n31
      ON n31.lod2_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n32
      ON n32.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_installation n33
      ON n33.lod4_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n34
      ON n34.lod3_implicit_rep_id  = a.a_id
    LEFT JOIN
      tunnel_opening n35
      ON n35.lod4_implicit_rep_id  = a.a_id
    WHERE n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL
      AND n6.lod2_implicit_rep_id IS NULL
      AND n7.lod3_implicit_rep_id IS NULL
      AND n8.lod4_implicit_rep_id IS NULL
      AND n9.lod3_implicit_rep_id IS NULL
      AND n10.lod4_implicit_rep_id IS NULL
      AND n11.lod4_implicit_rep_id IS NULL
      AND n12.lod2_implicit_rep_id IS NULL
      AND n13.lod3_implicit_rep_id IS NULL
      AND n14.lod4_implicit_rep_id IS NULL
      AND n15.lod1_implicit_rep_id IS NULL
      AND n16.lod2_implicit_rep_id IS NULL
      AND n17.lod3_implicit_rep_id IS NULL
      AND n18.lod4_implicit_rep_id IS NULL
      AND n19.lod0_implicit_rep_id IS NULL
      AND n20.lod1_implicit_rep_id IS NULL
      AND n21.lod2_implicit_rep_id IS NULL
      AND n22.lod3_implicit_rep_id IS NULL
      AND n23.lod4_implicit_rep_id IS NULL
      AND n24.lod3_implicit_rep_id IS NULL
      AND n25.lod4_implicit_rep_id IS NULL
      AND n26.lod1_implicit_rep_id IS NULL
      AND n27.lod2_implicit_rep_id IS NULL
      AND n28.lod3_implicit_rep_id IS NULL
      AND n29.lod4_implicit_rep_id IS NULL
      AND n30.lod4_implicit_rep_id IS NULL
      AND n31.lod2_implicit_rep_id IS NULL
      AND n32.lod3_implicit_rep_id IS NULL
      AND n33.lod4_implicit_rep_id IS NULL
      AND n34.lod3_implicit_rep_id IS NULL
      AND n35.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_tunnel_thematic_surface(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  tunnel_opening_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete references to tunnel_openings
  WITH del_tunnel_opening_refs AS (
    DELETE FROM
      tunnel_open_to_them_srf t
    USING
      unnest($1) a(a_id)
    WHERE
      t.tunnel_thematic_surface_id = a.a_id
    RETURNING
      t.tunnel_opening_id
  )
  SELECT
    array_agg(tunnel_opening_id)
  INTO
    tunnel_opening_ids
  FROM
    del_tunnel_opening_refs;

  -- delete tunnel_opening(s)
  IF -1 = ALL(tunnel_opening_ids) IS NOT NULL THEN
    PERFORM
      del_tunnel_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(tunnel_opening_ids) AS a_id) a;
  END IF;

  -- delete tunnel_thematic_surfaces
  WITH delete_objects AS (
    DELETE FROM
      tunnel_thematic_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_multi_surface_id) ||
    array_agg(lod3_multi_surface_id) ||
    array_agg(lod4_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_waterbody(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  waterboundary_surface_ids int[] := '{}';
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete references to waterboundary_surfaces
  WITH del_waterboundary_surface_refs AS (
    DELETE FROM
      waterbod_to_waterbnd_srf t
    USING
      unnest($1) a(a_id)
    WHERE
      t.waterbody_id = a.a_id
    RETURNING
      t.waterboundary_surface_id
  )
  SELECT
    array_agg(waterboundary_surface_id)
  INTO
    waterboundary_surface_ids
  FROM
    del_waterboundary_surface_refs;

  -- delete waterboundary_surface(s)
  IF -1 = ALL(waterboundary_surface_ids) IS NOT NULL THEN
    PERFORM
      del_waterboundary_surface(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(waterboundary_surface_ids) AS a_id) a;
  END IF;

  -- delete waterbodys
  WITH delete_objects AS (
    DELETE FROM
      waterbody t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod1_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id,
      lod0_multi_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_multi_surface_id) ||
    array_agg(lod1_solid_id) ||
    array_agg(lod2_solid_id) ||
    array_agg(lod3_solid_id) ||
    array_agg(lod4_solid_id) ||
    array_agg(lod0_multi_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------

CREATE OR REPLACE FUNCTION del_waterboundary_surface(int[], caller INTEGER DEFAULT 0) RETURNS SETOF int AS
$body$
DECLARE
  deleted_ids int[] := '{}';
  object_id integer;
  objectclass_id integer;
  surface_geometry_ids int[] := '{}';
BEGIN
  -- delete waterboundary_surfaces
  WITH delete_objects AS (
    DELETE FROM
      waterboundary_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id,
      lod2_surface_id,
      lod3_surface_id,
      lod4_surface_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_surface_id) ||
    array_agg(lod3_surface_id) ||
    array_agg(lod4_surface_id)
  INTO
    deleted_ids,
    surface_geometry_ids
  FROM
    delete_objects;

  -- delete surface_geometry(s)
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      del_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a;
  END IF;

  IF $2 <> 1 THEN
    -- delete cityobject
    PERFORM del_cityobject(deleted_ids, 2);
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$body$
LANGUAGE plpgsql STRICT;
------------------------------------------


