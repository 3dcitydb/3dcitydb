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

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   cleanup_appearances(only_global int DEFAULT 1) RETURNS SETOF int
*   cleanup_schema() RETURNS SETOF VOID
*   delete_address(pid int) RETURNS int
*   delete_address(pids int[]) RETURNS SETOF int
*   delete_appearance(pid int, objclass_id int) RETURNS int
*   delete_appearance(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge(pid int, objclass_id int) RETURNS int
*   delete_bridge(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge_constr_element(pid int, objclass_id int) RETURNS int
*   delete_bridge_constr_element(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge_furniture(pid int, objclass_id int) RETURNS int
*   delete_bridge_furniture(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge_installation(pid int, objclass_id int) RETURNS int
*   delete_bridge_installation(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge_opening(pid int, objclass_id int) RETURNS int
*   delete_bridge_opening(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge_room(pid int, objclass_id int) RETURNS int
*   delete_bridge_room(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_bridge_them_srf(pid int, objclass_id int) RETURNS int
*   delete_bridge_them_srf(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_building(pid int, objclass_id int) RETURNS int
*   delete_buildings(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_building_furniture(pid int, objclass_id int) RETURNS int
*   delete_building_furniture(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_building_installation(pid int, objclass_id int) RETURNS int
*   delete_building_installation(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_city_furniture(pid int, objclass_id int) RETURNS int
*   delete_city_furniture(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_citymodel(pid int) RETURNS int
*   delete_citymodel(pids int[]) RETURNS SETOF int
*   delete_citymodel_with_members(pid int) RETURNS int
*   delete_citymodel_with_members(pid int[]) RETURNS SETOF int
*   delete_cityobject(pid int, objclass_id int) RETURNS int
*   delete_cityobject(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_cityobject_post(pid int, objclass_id int) RETURNS int
*   delete_cityobject_post(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_cityobjectgroup(pid int, objclass_id int) RETURNS int
*   delete_cityobjectgroup(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_cityobjectgroup_with_members(pid int) RETURNS int
*   delete_cityobjectgroup_with_members(pid int[]) RETURNS SETOF int
*   delete_external_reference(pid int) RETURNS int
*   delete_external_reference(pids int[]) RETURNS SETOF int
*   delete_grid_coverage(pid int) RETURNS int
*   delete_grid_coverage(pids int[]) RETURNS SETOF int
*   delete_genericattrib(pid int) RETURNS int
*   delete_genericattrib(pids int[]) RETURNS SETOF int
*   delete_generic_cityobject(pid int, objclass_id int) RETURNS int
*   delete_generic_cityobject(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_implicit_geometry(pid int) RETURNS int
*   delete_implicit_geometry(pids int[]) RETURNS SETOF int
*   delete_land_use(pid int, objclass_id int) RETURNS int
*   delete_land_use(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_opening(pid int, objclass_id int) RETURNS int
*   delete_opening(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_plant_cover(pid int, objclass_id int) RETURNS int
*   delete_plant_cover(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_relief_component(pid int, objclass_id int) RETURNS int
*   delete_relief_component(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_relief_component_post(pid int, objclass_id int) RETURNS int
*   delete_relief_component_post(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_relief_feature(pid int, objclass_id int) RETURNS int
*   delete_relief_feature(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_room(pid int, objclass_id int) RETURNS int
*   delete_room(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_solitary_veg_obj(pid int, objclass_id int) RETURNS int
*   delete_solitary_veg_obj(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_surface_data(pid int, objclass_id int) RETURNS int
*   delete_surface_data(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_surface_geometry(pid int) RETURNS int
*   delete_surface_geometry(pids int[]) RETURNS SETOF int
*   delete_thematic_surface(pid int, objclass_id int) RETURNS int
*   delete_thematic_surface(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_traffic_area(pid int, objclass_id int) RETURNS int
*   delete_traffic_area(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_transport_complex(pid int, objclass_id int) RETURNS int
*   delete_transport_complex(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_tunnel(pid int, objclass_id int) RETURNS int
*   delete_tunnel(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_tunnel_furniture(pid int, objclass_id int) RETURNS int
*   delete_tunnel_furniture(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_tunnel_hollow_space(pid int, objclass_id int) RETURNS int
*   delete_tunnel_hollow_space(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_tunnel_installation(pid int, objclass_id int) RETURNS int
*   delete_tunnel_installation(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_tunnel_opening(int) RETURNS int
*   delete_tunnel_opening(pids int[], objclass_ids int[]) RETURNS int
*   delete_tunnel_them_srf(pid int, objclass_id int) RETURNS int
*   delete_tunnel_them_srf(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_waterbnd_surface(pid int, objclass_id int) RETURNS int
*   delete_waterbnd_surface(pids int[], objclass_ids int[]) RETURNS SETOF int
*   delete_waterbody(pid int, objclass_id int) RETURNS int
*   delete_waterbody(pids int[], objclass_ids int[]) RETURNS SETOF int
*
******************************************************************/

/*******************
* CORE
*******************/
/*
ADDRESS
*/
CREATE OR REPLACE FUNCTION delete_address(pids integer[])
  RETURNS SETOF integer AS
$BODY$
  -- delete addresss
  DELETE FROM
      address t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
$BODY$
LANGUAGE sql STRICT;

CREATE OR REPLACE FUNCTION delete_address(pid integer)
  RETURNS integer AS
$BODY$
  -- delete addresss
  DELETE FROM
    address
  WHERE
    id = $1
  RETURNING
    id;
$BODY$
LANGUAGE sql STRICT;


/*
EXTERNAL REFERENCE
*/
CREATE OR REPLACE FUNCTION delete_external_reference(pids integer[])
  RETURNS SETOF integer AS
$BODY$
  -- delete external_references
  DELETE FROM
      external_reference t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
$BODY$
LANGUAGE sql STRICT;

CREATE OR REPLACE FUNCTION delete_external_reference(pid integer)
  RETURNS integer AS
$BODY$
  -- delete external_references
  DELETE FROM
    external_reference
  WHERE
    id = $1
  RETURNING
    id;
$BODY$
LANGUAGE sql STRICT;


/*
GENERIC ATTRIBUTES
*/
CREATE OR REPLACE FUNCTION delete_genericattrib(pids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
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

  -- delete surface_geometry(s) not being referenced any more
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_surface_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a
    LEFT JOIN
      cityobject_genericattrib n1
      ON n1.surface_geometry_id = a.a_id
    WHERE
      n1.surface_geometry_id IS NULL;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_genericattrib(pid integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  surface_geometry_ref_id int;
BEGIN
  -- delete cityobject_genericattribs
  DELETE FROM
    cityobject_genericattrib
  WHERE
    id = $1
  RETURNING
    id,
    surface_geometry_id
  INTO
    deleted_id,
    surface_geometry_ref_id;

  -- delete surface_geometry(s) not being referenced any more
  IF surface_geometry_ref_id IS NOT NULL THEN
    PERFORM
      delete_surface_geometry(a.a_id)
    FROM
      (VALUES (surface_geometry_ref_id)) a(a_id)
    LEFT JOIN
      cityobject_genericattrib n1
      ON n1.surface_geometry_id = a.a_id
    WHERE
      n1.surface_geometry_id IS NULL;
  END IF;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* APPEARANCE
*******************/
/*
TEX IMAGES
*/
CREATE OR REPLACE FUNCTION delete_tex_image(pids integer[])
  RETURNS SETOF integer AS
$BODY$
  -- delete tex_images
  DELETE FROM
      tex_image t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
$BODY$
LANGUAGE sql STRICT;

CREATE OR REPLACE FUNCTION delete_tex_image(pid integer)
  RETURNS integer AS
$BODY$
  -- delete tex_images
  DELETE FROM
    tex_image
  WHERE
    id = $1
  RETURNING
    id;
$BODY$
LANGUAGE sql STRICT;


/*
SURFACE DATA
*/
CREATE OR REPLACE FUNCTION delete_surface_data(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  tex_image_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      surface_data t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete surface_datas
  WITH delete_objects AS (
    DELETE FROM
      surface_data t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
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

  -- delete tex_image(s) not being referenced any more
  IF -1 = ALL(tex_image_ids) IS NOT NULL THEN
    DELETE FROM
      tex_image m
    USING
      (SELECT DISTINCT unnest(tex_image_ids) AS a_id) a
    LEFT JOIN
      surface_data n1
      ON n1.tex_image_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.tex_image_id IS NULL;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_surface_data(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  tex_image_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      surface_data
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete surface_datas
  DELETE FROM
    surface_data
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    tex_image_id
  INTO
    deleted_id,
    tex_image_ref_id;

  -- delete tex_image(s) not being referenced any more
  IF tex_image_ref_id IS NOT NULL THEN
    DELETE FROM
      tex_image m
    USING
      (VALUES (tex_image_ref_id)) a(a_id)
    LEFT JOIN
      surface_data n1
      ON n1.tex_image_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.tex_image_id IS NULL;
  END IF;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
APPEARANCE
*/
CREATE OR REPLACE FUNCTION delete_appearance(pids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  surface_data_ids int[] := '{}';
BEGIN
  -- delete references to surface_datas
  WITH delete_surface_data_refs AS (
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
    delete_surface_data_refs;

  -- delete surface_data(s) not being referenced any more
  IF -1 = ALL(surface_data_ids) IS NOT NULL THEN
    PERFORM
      delete_surface_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_data_ids) AS a_id) a
    LEFT JOIN
      appear_to_surface_data n1
      ON n1.surface_data_id = a.a_id
    LEFT JOIN
      textureparam n2
      ON n2.surface_data_id = a.a_id
    WHERE
      n1.surface_data_id IS NULL
      AND n2.surface_data_id IS NULL;
  END IF;

  -- delete appearances
  RETURN QUERY
    DELETE FROM
      appearance t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_appearance(pid integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  surface_data_ids int[] := '{}';
BEGIN
  -- delete references to surface_datas
  WITH delete_surface_data_refs AS (
    DELETE FROM
      appear_to_surface_data
    WHERE
      appearance_id = $1
    RETURNING
      surface_data_id
  )
  SELECT
    array_agg(surface_data_id)
  INTO
    surface_data_ids
  FROM
    delete_surface_data_refs;

  -- delete surface_data(s) not being referenced any more
  IF -1 = ALL(surface_data_ids) IS NOT NULL THEN
    PERFORM
      delete_surface_data(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(surface_data_ids) AS a_id) a
    LEFT JOIN
      appear_to_surface_data n1
      ON n1.surface_data_id = a.a_id
    LEFT JOIN
      textureparam n2
      ON n2.surface_data_id = a.a_id
    WHERE
      n1.surface_data_id IS NULL
      AND n2.surface_data_id IS NULL;
  END IF;

  -- delete appearances
  DELETE FROM
    appearance
  WHERE
    id = $1
  RETURNING
    id
  INTO
    deleted_id;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION cleanup_appearances(
  only_global int DEFAULT 1
  ) RETURNS SETOF int AS
$$
DECLARE
  deleted_id int;
  app_id int;
BEGIN
  -- global appearances are not related to a cityobject.
  -- however, we assume that all surface geometries of a cityobject
  -- have been deleted at this stage. thus, we can check and delete
  -- surface data which does not have a valid texture parameterization
  -- any more.
  PERFORM
    delete_surface_data(array_agg(s.id))
  FROM
    surface_data s 
  LEFT OUTER JOIN
    textureparam t
    ON s.id = t.surface_data_id 
  WHERE
    t.surface_data_id IS NULL;

  -- delete appearances which does not have surface data any more
  IF only_global=1 THEN
    FOR app_id IN 
      SELECT
        a.id
      FROM
        appearance a 
      LEFT OUTER JOIN
        appear_to_surface_data asd
        ON a.id=asd.appearance_id 
      WHERE
        a.cityobject_id IS NULL
        AND asd.appearance_id IS NULL
    LOOP
      DELETE FROM
        appearance
      WHERE
        id = app_id
      RETURNING
        id
      INTO
        deleted_id;

      RETURN NEXT deleted_id;
    END LOOP;
  ELSE
    FOR app_id IN 
      SELECT
        a.id
      FROM
        appearance a 
      LEFT OUTER JOIN
        appear_to_surface_data asd
        ON a.id=asd.appearance_id 
      WHERE
        asd.appearance_id IS NULL
    LOOP
      DELETE FROM
        appearance
      WHERE
        id = app_id
      RETURNING
        id
      INTO
        deleted_id;

      RETURN NEXT deleted_id;
    END LOOP;
  END IF;

  RETURN;
END; 
$$ 
LANGUAGE plpgsql STRICT;


/*********************
* GEOMETRY & RASTER
*********************/
/*
SURFACE GEOMETRY
*/
CREATE OR REPLACE FUNCTION delete_surface_geometry(pids integer[])
  RETURNS SETOF integer AS
$BODY$
  -- delete surface_geometrys
  DELETE FROM
      surface_geometry t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
$BODY$
LANGUAGE sql STRICT;

CREATE OR REPLACE FUNCTION delete_surface_geometry(pid integer)
  RETURNS integer AS
$BODY$
  -- delete surface_geometrys
  DELETE FROM
    surface_geometry
  WHERE
    id = $1
  RETURNING
    id;
$BODY$
LANGUAGE sql STRICT;


/*
IMPLICIT GEOMETRY
*/
CREATE OR REPLACE FUNCTION delete_implicit_geometry(pids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
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

  -- delete surface_geometry(s) not being referenced any more
  IF -1 = ALL(surface_geometry_ids) IS NOT NULL THEN
    DELETE FROM
      surface_geometry m
    USING
      (SELECT DISTINCT unnest(surface_geometry_ids) AS a_id) a
    LEFT JOIN
      implicit_geometry n1
      ON n1.relative_brep_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.relative_brep_id IS NULL;
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_implicit_geometry(pid integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  surface_geometry_ref_id int;
BEGIN
  -- delete implicit_geometrys
  DELETE FROM
    implicit_geometry
  WHERE
    id = $1
  RETURNING
    id,
    relative_brep_id
  INTO
    deleted_id,
    surface_geometry_ref_id;

  -- delete surface_geometry(s) not being referenced any more
  IF surface_geometry_ref_id IS NOT NULL THEN
    DELETE FROM
      surface_geometry m
    USING
      (VALUES (surface_geometry_ref_id)) a(a_id)
    LEFT JOIN
      implicit_geometry n1
      ON n1.relative_brep_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.relative_brep_id IS NULL;
  END IF;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
GRID COVERAGE
*/
CREATE OR REPLACE FUNCTION delete_grid_coverage(pids integer[])
  RETURNS SETOF integer AS
$BODY$
  -- delete grid_coverages
  DELETE FROM
      grid_coverage t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
$BODY$
LANGUAGE sql STRICT;

CREATE OR REPLACE FUNCTION delete_grid_coverage(pid integer)
  RETURNS integer AS
$BODY$
  -- delete grid_coverages
  DELETE FROM
    grid_coverage
  WHERE
    id = $1
  RETURNING
    id;
$BODY$
LANGUAGE sql STRICT;


/***********************
* CITYOBJECT INTERNALS
***********************/
CREATE OR REPLACE FUNCTION delete_cityobject_post(
    pids integer[],
    objclass_ids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  class_ids := $2;

  -- delete appearances
  PERFORM
    delete_appearance(array_agg(t.id))
  FROM
    appearance t,
    unnest($1) a(a_id)
  WHERE
    t.cityobject_id = a.a_id;

  -- delete cityobject_genericattribs
  PERFORM
    delete_genericattrib(array_agg(t.id))
  FROM
    cityobject_genericattrib t,
    unnest($1) a(a_id)
  WHERE
    t.cityobject_id = a.a_id;

  -- delete cityobjects
  RETURN QUERY
    DELETE FROM
      cityobject t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id;
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_cityobject_post(
    pid integer,
    objclass_id integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  class_id := $2;

  -- delete appearances
  PERFORM
    delete_appearance(array_agg(id))
  FROM
    appearance
  WHERE
    cityobject_id = $1;

  -- delete cityobject_genericattribs
  PERFORM
    delete_genericattrib(array_agg(id))
  FROM
    cityobject_genericattrib
  WHERE
    cityobject_id = $1;

  -- delete cityobjects
  DELETE FROM
    cityobject
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
CITY MODEL
*/
CREATE OR REPLACE FUNCTION delete_citymodel(pids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
BEGIN
  -- delete appearances
  PERFORM
    delete_appearance(array_agg(t.id))
  FROM
    appearance t,
    unnest($1) a(a_id)
  WHERE
    t.citymodel_id = a.a_id;

  -- delete citymodels
  RETURN QUERY
    DELETE FROM
      citymodel t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
    RETURNING
      id;
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_citymodel(pid integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
BEGIN
  -- delete appearances
  PERFORM
    delete_appearance(array_agg(id))
  FROM
    appearance
  WHERE
    citymodel_id = $1;

  -- delete citymodels
  DELETE FROM
    citymodel
  WHERE
    id = $1
  RETURNING
    id
  INTO
    deleted_id;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* BRIDGE
*******************/
/*
BRIDGE FURNITURE
*/
CREATE OR REPLACE FUNCTION delete_bridge_furniture(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_furniture t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridge_furnitures
  WITH delete_objects AS (
    DELETE FROM
      bridge_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_furniture n1
      ON n1.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_furniture(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_furniture
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge_furnitures
  DELETE FROM
    bridge_furniture
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    lod4_implicit_rep_id
  INTO
    deleted_id,
    implicit_geometry_ref_id;

  -- delete implicit_geometry(s) not being referenced any more
  IF implicit_geometry_ref_id IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(a.a_id)
    FROM
      (VALUES (implicit_geometry_ref_id)) a(a_id)
    LEFT JOIN
      bridge_furniture n1
      ON n1.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BRIDGE OPENING
*/
CREATE OR REPLACE FUNCTION delete_bridge_opening(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
  address_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_opening t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridge_openings
  WITH delete_objects AS (
    DELETE FROM
      bridge_opening t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      address_id
  )
  SELECT
    array_agg(id),
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id),
    array_agg(address_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    address_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_opening n1
      ON n1.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_opening n2
      ON n2.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod3_implicit_rep_id IS NULL
      AND n2.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete address(s) not being referenced any more
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      bridge_opening n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_bridge n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      address_to_building n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_opening(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
  address_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_opening
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge_openings
  DELETE FROM
    bridge_opening
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ],
    address_id
  INTO
    deleted_id,
    implicit_geometry_ids,
    address_ref_id;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_opening n1
      ON n1.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_opening n2
      ON n2.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod3_implicit_rep_id IS NULL
      AND n2.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete address(s) not being referenced any more
  IF address_ref_id IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (VALUES (address_ref_id)) a(a_id)
    LEFT JOIN
      bridge_opening n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_bridge n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      address_to_building n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BRIDGE THEMATIC SURFACE
*/
CREATE OR REPLACE FUNCTION delete_bridge_them_srf(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  bridge_opening_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_thematic_surface t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to bridge_openings
  WITH delete_bridge_opening_refs AS (
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
    delete_bridge_opening_refs;

  -- delete bridge_opening(s) not being referenced any more
  IF -1 = ALL(bridge_opening_ids) IS NOT NULL THEN
    PERFORM
      delete_bridge_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(bridge_opening_ids) AS a_id) a
    LEFT JOIN
      bridge_open_to_them_srf n1
      ON n1.bridge_opening_id = a.a_id
    WHERE
      n1.bridge_opening_id IS NULL;
  END IF;

  -- delete bridge_thematic_surfaces
  WITH delete_objects AS (
    DELETE FROM
      bridge_thematic_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_them_srf(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  bridge_opening_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_thematic_surface
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to bridge_openings
  WITH delete_bridge_opening_refs AS (
    DELETE FROM
      bridge_open_to_them_srf
    WHERE
      bridge_thematic_surface_id = $1
    RETURNING
      bridge_opening_id
  )
  SELECT
    array_agg(bridge_opening_id)
  INTO
    bridge_opening_ids
  FROM
    delete_bridge_opening_refs;

  -- delete bridge_opening(s) not being referenced any more
  IF -1 = ALL(bridge_opening_ids) IS NOT NULL THEN
    PERFORM
      delete_bridge_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(bridge_opening_ids) AS a_id) a
    LEFT JOIN
      bridge_open_to_them_srf n1
      ON n1.bridge_opening_id = a.a_id
    WHERE
      n1.bridge_opening_id IS NULL;
  END IF;

  -- delete bridge_thematic_surfaces
  DELETE FROM
    bridge_thematic_surface
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BRIDGE INSTALLATION
*/
CREATE OR REPLACE FUNCTION delete_bridge_installation(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_installation t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_installation n1
      ON n1.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_installation n2
      ON n2.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_installation n3
      ON n3.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod2_implicit_rep_id IS NULL
      AND n2.lod3_implicit_rep_id IS NULL
      AND n3.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_installation(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_installation
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_thematic_surface
  WHERE
    bridge_installation_id = $1;

  -- delete bridge_installations
  DELETE FROM
    bridge_installation
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_installation n1
      ON n1.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_installation n2
      ON n2.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_installation n3
      ON n3.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod2_implicit_rep_id IS NULL
      AND n2.lod3_implicit_rep_id IS NULL
      AND n3.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BRIDGE ROOM
*/
CREATE OR REPLACE FUNCTION delete_bridge_room(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_room t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridge_furnitures
  PERFORM
    delete_bridge_furniture(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_furniture t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_room_id = a.a_id;

  -- delete bridge_installations
  PERFORM
    delete_bridge_installation(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_installation t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_room_id = a.a_id;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_room(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_room
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge_furnitures
  PERFORM
    delete_bridge_furniture(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_furniture
  WHERE
    bridge_room_id = $1;

  -- delete bridge_installations
  PERFORM
    delete_bridge_installation(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_installation
  WHERE
    bridge_room_id = $1;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_thematic_surface
  WHERE
    bridge_room_id = $1;

  -- delete bridge_rooms
  DELETE FROM
    bridge_room
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BRIDGE CONSTRUCTION ELEMENT
*/
CREATE OR REPLACE FUNCTION delete_bridge_constr_element(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_constr_element t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_constr_element_id = a.a_id;

  -- delete bridge_constr_elements
  WITH delete_objects AS (
    DELETE FROM
      bridge_constr_element t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_constr_element(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_constr_element
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_thematic_surface
  WHERE
    bridge_constr_element_id = $1;

  -- delete bridge_constr_elements
  DELETE FROM
    bridge_constr_element
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_constr_element n1
      ON n1.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_constr_element n2
      ON n2.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_constr_element n3
      ON n3.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      bridge_constr_element n4
      ON n4.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BRIDGE
*/
CREATE OR REPLACE FUNCTION delete_bridge(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  address_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to addresss
  WITH delete_address_refs AS (
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
    delete_address_refs;

  -- delete address(s) not being referenced any more
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_bridge n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_building n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete bridge_constr_elements
  PERFORM
    delete_bridge_constr_element(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_constr_element t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  -- delete bridge_installations
  PERFORM
    delete_bridge_installation(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_installation t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  -- delete bridge_rooms
  PERFORM
    delete_bridge_room(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_room t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_id = a.a_id;

  -- delete referenced parts
  PERFORM
    delete_bridge(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    bridge t,
    unnest($1) a(a_id)
  WHERE
    t.bridge_parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete bridges
  WITH delete_objects AS (
    DELETE FROM
      bridge t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  address_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to addresss
  WITH delete_address_refs AS (
    DELETE FROM
      address_to_bridge
    WHERE
      bridge_id = $1
    RETURNING
      address_id
  )
  SELECT
    array_agg(address_id)
  INTO
    address_ids
  FROM
    delete_address_refs;

  -- delete address(s) not being referenced any more
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_bridge n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_building n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete bridge_constr_elements
  PERFORM
    delete_bridge_constr_element(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_constr_element
  WHERE
    bridge_id = $1;

  -- delete bridge_installations
  PERFORM
    delete_bridge_installation(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_installation
  WHERE
    bridge_id = $1;

  -- delete bridge_rooms
  PERFORM
    delete_bridge_room(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_room
  WHERE
    bridge_id = $1;

  -- delete bridge_thematic_surfaces
  PERFORM
    delete_bridge_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge_thematic_surface
  WHERE
    bridge_id = $1;

  --delete referenced parts
  PERFORM
    delete_bridge(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    bridge
  WHERE
    bridge_parent_id = $1
    AND id != $1;

  -- delete bridges
  DELETE FROM
    bridge
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* BUILDING
*******************/
/*
BUILDING FURNITURE
*/
CREATE OR REPLACE FUNCTION delete_bridge_furniture(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      bridge_furniture t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridge_furnitures
  WITH delete_objects AS (
    DELETE FROM
      bridge_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      bridge_furniture n1
      ON n1.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_bridge_furniture(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      bridge_furniture
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge_furnitures
  DELETE FROM
    bridge_furniture
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    lod4_implicit_rep_id
  INTO
    deleted_id,
    implicit_geometry_ref_id;

  -- delete implicit_geometry(s) not being referenced any more
  IF implicit_geometry_ref_id IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(a.a_id)
    FROM
      (VALUES (implicit_geometry_ref_id)) a(a_id)
    LEFT JOIN
      bridge_furniture n1
      ON n1.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
OPENING
*/
CREATE OR REPLACE FUNCTION delete_opening(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
  address_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      opening t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete openings
  WITH delete_objects AS (
    DELETE FROM
      opening t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id,
      address_id
  )
  SELECT
    array_agg(id),
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id),
    array_agg(address_id)
  INTO
    deleted_ids,
    implicit_geometry_ids,
    address_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      opening n1
      ON n1.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      opening n2
      ON n2.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod3_implicit_rep_id IS NULL
      AND n2.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete address(s) not being referenced any more
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      opening n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_bridge n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      address_to_building n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      bridge_opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_opening(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
  address_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      opening
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete openings
  DELETE FROM
    opening
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ],
    address_id
  INTO
    deleted_id,
    implicit_geometry_ids,
    address_ref_id;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      opening n1
      ON n1.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      opening n2
      ON n2.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod3_implicit_rep_id IS NULL
      AND n2.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete address(s) not being referenced any more
  IF address_ref_id IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (VALUES (address_ref_id)) a(a_id)
    LEFT JOIN
      opening n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_bridge n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      address_to_building n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      bridge_opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
THEMATIC SURFACE
*/
CREATE OR REPLACE FUNCTION delete_thematic_surface(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  opening_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      thematic_surface t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to openings
  WITH delete_opening_refs AS (
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
    delete_opening_refs;

  -- delete opening(s) not being referenced any more
  IF -1 = ALL(opening_ids) IS NOT NULL THEN
    PERFORM
      delete_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(opening_ids) AS a_id) a
    LEFT JOIN
      opening_to_them_surface n1
      ON n1.opening_id = a.a_id
    WHERE
      n1.opening_id IS NULL;
  END IF;

  -- delete thematic_surfaces
  WITH delete_objects AS (
    DELETE FROM
      thematic_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_thematic_surface(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  opening_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      thematic_surface
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM
      opening_to_them_surface
    WHERE
      thematic_surface_id = $1
    RETURNING
      opening_id
  )
  SELECT
    array_agg(opening_id)
  INTO
    opening_ids
  FROM
    delete_opening_refs;

  -- delete opening(s) not being referenced any more
  IF -1 = ALL(opening_ids) IS NOT NULL THEN
    PERFORM
      delete_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(opening_ids) AS a_id) a
    LEFT JOIN
      opening_to_them_surface n1
      ON n1.opening_id = a.a_id
    WHERE
      n1.opening_id IS NULL;
  END IF;

  -- delete thematic_surfaces
  DELETE FROM
    thematic_surface
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BUILDING INSTALLATION
*/
CREATE OR REPLACE FUNCTION delete_building_installation(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      building_installation t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete thematic_surfaces
  PERFORM
    delete_thematic_surface(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      building_installation n1
      ON n1.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      building_installation n2
      ON n2.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      building_installation n3
      ON n3.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod2_implicit_rep_id IS NULL
      AND n2.lod3_implicit_rep_id IS NULL
      AND n3.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_building_installation(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      building_installation
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete thematic_surfaces
  PERFORM
    delete_thematic_surface(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    thematic_surface
  WHERE
    building_installation_id = $1;

  -- delete building_installations
  DELETE FROM
    building_installation
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      building_installation n1
      ON n1.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      building_installation n2
      ON n2.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      building_installation n3
      ON n3.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod2_implicit_rep_id IS NULL
      AND n2.lod3_implicit_rep_id IS NULL
      AND n3.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
ROOM
*/
CREATE OR REPLACE FUNCTION delete_room(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      room t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete building_furnitures
  PERFORM
    delete_building_furniture(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    building_furniture t,
    unnest($1) a(a_id)
  WHERE
    t.room_id = a.a_id;

  -- delete building_installations
  PERFORM
    delete_building_installation(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    building_installation t,
    unnest($1) a(a_id)
  WHERE
    t.room_id = a.a_id;

  -- delete thematic_surfaces
  PERFORM
    delete_thematic_surface(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_room(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      room
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete building_furnitures
  PERFORM
    delete_building_furniture(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    building_furniture
  WHERE
    room_id = $1;

  -- delete building_installations
  PERFORM
    delete_building_installation(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    building_installation
  WHERE
    room_id = $1;

  -- delete thematic_surfaces
  PERFORM
    delete_thematic_surface(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    thematic_surface
  WHERE
    room_id = $1;

  -- delete rooms
  DELETE FROM
    room
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BUILDING
*/
CREATE OR REPLACE FUNCTION delete_building(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  address_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      building t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to addresss
  WITH delete_address_refs AS (
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
    delete_address_refs;

  -- delete address(s) not being referenced any more
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_building n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_bridge n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete building_installations
  PERFORM
    delete_building_installation(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    building_installation t,
    unnest($1) a(a_id)
  WHERE
    t.building_id = a.a_id;

  -- delete rooms
  PERFORM
    delete_room(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    room t,
    unnest($1) a(a_id)
  WHERE
    t.building_id = a.a_id;

  -- delete thematic_surfaces
  PERFORM
    delete_thematic_surface(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.building_id = a.a_id;

  -- delete referenced parts
  PERFORM
    delete_building(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    building t,
    unnest($1) a(a_id)
  WHERE
    t.building_parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete buildings
  WITH delete_objects AS (
    DELETE FROM
      building t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_building(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  address_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      building
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to addresss
  WITH delete_address_refs AS (
    DELETE FROM
      address_to_building
    WHERE
      building_id = $1
    RETURNING
      address_id
  )
  SELECT
    array_agg(address_id)
  INTO
    address_ids
  FROM
    delete_address_refs;

  -- delete address(s) not being referenced any more
  IF -1 = ALL(address_ids) IS NOT NULL THEN
    DELETE FROM
      address m
    USING
      (SELECT DISTINCT unnest(address_ids) AS a_id) a
    LEFT JOIN
      address_to_building n1
      ON n1.address_id = a.a_id
    LEFT JOIN
      address_to_bridge n2
      ON n2.address_id = a.a_id
    LEFT JOIN
      bridge_opening n3
      ON n3.address_id = a.a_id
    LEFT JOIN
      opening n4
      ON n4.address_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.address_id IS NULL
      AND n2.address_id IS NULL
      AND n3.address_id IS NULL
      AND n4.address_id IS NULL;
  END IF;

  -- delete building_installations
  PERFORM
    delete_building_installation(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    building_installation
  WHERE
    building_id = $1;

  -- delete rooms
  PERFORM
    delete_room(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    room
  WHERE
    building_id = $1;

  -- delete thematic_surfaces
  PERFORM
    delete_thematic_surface(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    thematic_surface
  WHERE
    building_id = $1;

  --delete referenced parts
  PERFORM
    delete_building(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    building
  WHERE
    building_parent_id = $1
    AND id != $1;

  -- delete buildings
  DELETE FROM
    building
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* CITY FURNITURE
*******************/
CREATE OR REPLACE FUNCTION delete_city_furniture(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      city_furniture t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete city_furnitures
  WITH delete_objects AS (
    DELETE FROM
      city_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      city_furniture n1
      ON n1.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      city_furniture n2
      ON n2.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      city_furniture n3
      ON n3.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      city_furniture n4
      ON n4.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_city_furniture(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      city_furniture
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete city_furnitures
  DELETE FROM
    city_furniture
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      city_furniture n1
      ON n1.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      city_furniture n2
      ON n2.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      city_furniture n3
      ON n3.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      city_furniture n4
      ON n4.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/********************
* CITYOBJECT GROUP
********************/
CREATE OR REPLACE FUNCTION delete_cityobjectgroup(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      cityobjectgroup t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete cityobjectgroups
  WITH delete_objects AS (
    DELETE FROM
      cityobjectgroup t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_cityobjectgroup(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      cityobjectgroup
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete cityobjectgroups
  DELETE FROM
    cityobjectgroup
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/**********************
* GENERIC CITYOBJECT
**********************/
CREATE OR REPLACE FUNCTION delete_generic_cityobjec(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      generic_cityobject t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete generic_cityobjects
  WITH delete_objects AS (
    DELETE FROM
      generic_cityobject t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod0_implicit_rep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod0_implicit_rep_id) ||
    array_agg(lod1_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      generic_cityobject n1
      ON n1.lod0_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n2
      ON n2.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n3
      ON n3.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n4
      ON n4.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n5
      ON n5.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod0_implicit_rep_id IS NULL
      AND n2.lod1_implicit_rep_id IS NULL
      AND n3.lod2_implicit_rep_id IS NULL
      AND n4.lod3_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_generic_cityobjec(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      generic_cityobject
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete generic_cityobjects
  DELETE FROM
    generic_cityobject
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod0_implicit_rep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      generic_cityobject n1
      ON n1.lod0_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n2
      ON n2.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n3
      ON n3.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n4
      ON n4.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      generic_cityobject n5
      ON n5.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod0_implicit_rep_id IS NULL
      AND n2.lod1_implicit_rep_id IS NULL
      AND n3.lod2_implicit_rep_id IS NULL
      AND n4.lod3_implicit_rep_id IS NULL
      AND n5.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* LAND USE
*******************/
CREATE OR REPLACE FUNCTION delete_land_use(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      land_use t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete land_uses
  WITH delete_objects AS (
    DELETE FROM
      land_use t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_land_use(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      land_use
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete land_uses
  DELETE FROM
    land_use
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* RELIEF
*******************/
/*
RELIEF COMPONENT INTERNALS
*/
CREATE OR REPLACE FUNCTION delete_relief_component_post(
    pids integer[],
    objclass_ids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  class_ids := $2;

  -- delete relief_components
  WITH delete_objects AS (
    DELETE FROM
      relief_component t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_relief_component_post(
    pid integer,
    objclass_id integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  class_id := $2;

  -- delete relief_components
  DELETE FROM
    relief_component
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
BREAKLINE RELIEF
*/
CREATE OR REPLACE FUNCTION delete_breakline_relief(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      breakline_relief t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete breakline_reliefs
  WITH delete_objects AS (
    DELETE FROM
      breakline_relief t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_breakline_relief(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      breakline_relief
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete breakline_reliefs
  DELETE FROM
    breakline_relief
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
MASSPOINT RELIEF
*/
CREATE OR REPLACE FUNCTION delete_masspoint_relief(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      masspoint_relief t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete masspoint_reliefs
  WITH delete_objects AS (
    DELETE FROM
      masspoint_relief t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_masspoint_relief(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      masspoint_relief
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete masspoint_reliefs
  DELETE FROM
    masspoint_relief
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
RASTER RELIEF
*/
CREATE OR REPLACE FUNCTION delete_raster_relief(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  grid_coverage_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      raster_relief t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete raster_reliefs
  WITH delete_objects AS (
    DELETE FROM
      raster_relief t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
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

  -- delete grid_coverage(s) not being referenced any more
  IF -1 = ALL(grid_coverage_ids) IS NOT NULL THEN
    DELETE FROM
      grid_coverage m
    USING
      (SELECT DISTINCT unnest(grid_coverage_ids) AS a_id) a
    LEFT JOIN
      raster_relief n1
      ON n1.coverage_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.coverage_id IS NULL;
  END IF;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_raster_relief(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  grid_coverage_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      raster_relief
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete raster_reliefs
  DELETE FROM
    raster_relief
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    coverage_id
  INTO
    deleted_id,
    grid_coverage_ref_id;

  -- delete grid_coverage(s) not being referenced any more
  IF grid_coverage_ref_id IS NOT NULL THEN
    DELETE FROM
      grid_coverage m
    USING
      (VALUES (grid_coverage_ref_id)) a(a_id)
    LEFT JOIN
      raster_relief n1
      ON n1.coverage_id = a.a_id
    WHERE
      m.id = a.a_id
      AND n1.coverage_id IS NULL;
  END IF;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TIN RELIEF
*/
CREATE OR REPLACE FUNCTION delete_tin_relief(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tin_relief t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete tin_reliefs
  WITH delete_objects AS (
    DELETE FROM
      tin_relief t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tin_relief(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tin_relief
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete tin_reliefs
  DELETE FROM
    tin_relief
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete relief_component
  PERFORM delete_relief_component_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
RELIEF COMPONENT ROUTER
*/
CREATE OR REPLACE FUNCTION delete_relief_component(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      relief_component t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete breakline_reliefs
  IF class_ids && ARRAY[18]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_breakline_relief($1, class_ids) AS a(a_id));
  END IF;

  -- delete masspoint_reliefs
  IF class_ids && ARRAY[17]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_masspoint_relief($1, class_ids) AS a(a_id));
  END IF;

  -- delete raster_reliefs
  IF class_ids && ARRAY[19]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_raster_relief($1, class_ids) AS a(a_id));
  END IF;

  -- delete tin_reliefs
  IF class_ids && ARRAY[16]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tin_relief($1, class_ids) AS a(a_id));
  END IF;

  IF array_length(deleted_ids, 1) IS NULL OR array_length(deleted_ids, 1) <> array_length($1, 1) THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_relief_component_post($1, class_ids) AS a(a_id));
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_relief_component(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      relief_component
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete breakline_relief
  IF class_id IN (18) THEN
    deleted_id := delete_breakline_relief($1, class_id);
  END IF;

  -- delete masspoint_relief
  IF class_id IN (17) THEN
    deleted_id := delete_masspoint_relief($1, class_id);
  END IF;

  -- delete raster_relief
  IF class_id IN (19) THEN
    deleted_id := delete_raster_relief($1, class_id);
  END IF;

  -- delete tin_relief
  IF class_id IN (16) THEN
    deleted_id := delete_tin_relief($1, class_id);
  END IF;

  IF deleted_id IS NULL THEN
    deleted_id := delete_relief_component_post($1, class_id);
  END IF;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
RELIEF FEATURE
*/
CREATE OR REPLACE FUNCTION delete_relief_feature(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  relief_component_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      relief_feature t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to relief_components
  WITH delete_relief_component_refs AS (
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
    delete_relief_component_refs;

  -- delete relief_component(s) not being referenced any more
  IF -1 = ALL(relief_component_ids) IS NOT NULL THEN
    PERFORM
      delete_relief_component(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(relief_component_ids) AS a_id) a
    LEFT JOIN
      relief_feat_to_rel_comp n1
      ON n1.relief_component_id = a.a_id
    WHERE
      n1.relief_component_id IS NULL;
  END IF;

  -- delete relief_features
  WITH delete_objects AS (
    DELETE FROM
      relief_feature t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_relief_feature(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  relief_component_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      relief_feature
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to relief_components
  WITH delete_relief_component_refs AS (
    DELETE FROM
      relief_feat_to_rel_comp
    WHERE
      relief_feature_id = $1
    RETURNING
      relief_component_id
  )
  SELECT
    array_agg(relief_component_id)
  INTO
    relief_component_ids
  FROM
    delete_relief_component_refs;

  -- delete relief_component(s) not being referenced any more
  IF -1 = ALL(relief_component_ids) IS NOT NULL THEN
    PERFORM
      delete_relief_component(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(relief_component_ids) AS a_id) a
    LEFT JOIN
      relief_feat_to_rel_comp n1
      ON n1.relief_component_id = a.a_id
    WHERE
      n1.relief_component_id IS NULL;
  END IF;

  -- delete relief_features
  DELETE FROM
    relief_feature
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* TRANSPORTATION
*******************/
/*
TRAFFIC AREA
*/
CREATE OR REPLACE FUNCTION delete_traffic_area(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      traffic_area t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete traffic_areas
  WITH delete_objects AS (
    DELETE FROM
      traffic_area t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_traffic_area(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      traffic_area
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete traffic_areas
  DELETE FROM
    traffic_area
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TRANSPORTATION COMPLEX
*/
CREATE OR REPLACE FUNCTION delete_transport_complex(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      transportation_complex t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete traffic_areas
  PERFORM
    delete_traffic_area(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_transport_complex(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      transportation_complex
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete traffic_areas
  PERFORM
    delete_traffic_area(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    traffic_area
  WHERE
    transportation_complex_id = $1;

  -- delete transportation_complexs
  DELETE FROM
    transportation_complex
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* TUNNEL
*******************/
/*
TUNNEL FRUNITURE
*/
CREATE OR REPLACE FUNCTION delete_tunnel_furniture(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tunnel_furniture t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete tunnel_furnitures
  WITH delete_objects AS (
    DELETE FROM
      tunnel_furniture t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      tunnel_furniture n1
      ON n1.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tunnel_furniture(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ref_id int;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tunnel_furniture
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete tunnel_furnitures
  DELETE FROM
    tunnel_furniture
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    lod4_implicit_rep_id
  INTO
    deleted_id,
    implicit_geometry_ref_id;

  -- delete implicit_geometry(s) not being referenced any more
  IF implicit_geometry_ref_id IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(a.a_id)
    FROM
      (VALUES (implicit_geometry_ref_id)) a(a_id)
    LEFT JOIN
      tunnel_furniture n1
      ON n1.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TUNNEL OPENING
*/
CREATE OR REPLACE FUNCTION delete_tunnel_opening(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tunnel_opening t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete tunnel_openings
  WITH delete_objects AS (
    DELETE FROM
      tunnel_opening t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      tunnel_opening n1
      ON n1.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      tunnel_opening n2
      ON n2.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod3_implicit_rep_id IS NULL
      AND n2.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tunnel_opening(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tunnel_opening
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete tunnel_openings
  DELETE FROM
    tunnel_opening
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      tunnel_opening n1
      ON n1.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      tunnel_opening n2
      ON n2.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod3_implicit_rep_id IS NULL
      AND n2.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TUNNEL THEMATIC SURFACE
*/
CREATE OR REPLACE FUNCTION delete_tunnel_them_srf(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  tunnel_opening_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tunnel_thematic_surface t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to tunnel_openings
  WITH delete_tunnel_opening_refs AS (
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
    delete_tunnel_opening_refs;

  -- delete tunnel_opening(s) not being referenced any more
  IF -1 = ALL(tunnel_opening_ids) IS NOT NULL THEN
    PERFORM
      delete_tunnel_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(tunnel_opening_ids) AS a_id) a
    LEFT JOIN
      tunnel_open_to_them_srf n1
      ON n1.tunnel_opening_id = a.a_id
    WHERE
      n1.tunnel_opening_id IS NULL;
  END IF;

  -- delete tunnel_thematic_surfaces
  WITH delete_objects AS (
    DELETE FROM
      tunnel_thematic_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tunnel_them_srf(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  tunnel_opening_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tunnel_thematic_surface
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to tunnel_openings
  WITH delete_tunnel_opening_refs AS (
    DELETE FROM
      tunnel_open_to_them_srf
    WHERE
      tunnel_thematic_surface_id = $1
    RETURNING
      tunnel_opening_id
  )
  SELECT
    array_agg(tunnel_opening_id)
  INTO
    tunnel_opening_ids
  FROM
    delete_tunnel_opening_refs;

  -- delete tunnel_opening(s) not being referenced any more
  IF -1 = ALL(tunnel_opening_ids) IS NOT NULL THEN
    PERFORM
      delete_tunnel_opening(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(tunnel_opening_ids) AS a_id) a
    LEFT JOIN
      tunnel_open_to_them_srf n1
      ON n1.tunnel_opening_id = a.a_id
    WHERE
      n1.tunnel_opening_id IS NULL;
  END IF;

  -- delete tunnel_thematic_surfaces
  DELETE FROM
    tunnel_thematic_surface
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TUNNEL INSTALLATION
*/
CREATE OR REPLACE FUNCTION delete_tunnel_installation(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tunnel_installation t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete tunnel_thematic_surfaces
  PERFORM
    delete_tunnel_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      tunnel_installation n1
      ON n1.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      tunnel_installation n2
      ON n2.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      tunnel_installation n3
      ON n3.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod2_implicit_rep_id IS NULL
      AND n2.lod3_implicit_rep_id IS NULL
      AND n3.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tunnel_installation(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tunnel_installation
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete tunnel_thematic_surfaces
  PERFORM
    delete_tunnel_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_thematic_surface
  WHERE
    tunnel_installation_id = $1;

  -- delete tunnel_installations
  DELETE FROM
    tunnel_installation
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      tunnel_installation n1
      ON n1.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      tunnel_installation n2
      ON n2.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      tunnel_installation n3
      ON n3.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod2_implicit_rep_id IS NULL
      AND n2.lod3_implicit_rep_id IS NULL
      AND n3.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TUNNEL HOLLOW SPACE
*/
CREATE OR REPLACE FUNCTION delete_tunnel_hollow_space(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tunnel_hollow_space t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete tunnel_furnitures
  PERFORM
    delete_tunnel_furniture(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    tunnel_furniture t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_hollow_space_id = a.a_id;

  -- delete tunnel_installations
  PERFORM
    delete_tunnel_installation(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    tunnel_installation t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_hollow_space_id = a.a_id;

  -- delete tunnel_thematic_surfaces
  PERFORM
    delete_tunnel_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
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
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tunnel_hollow_space(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tunnel_hollow_space
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete tunnel_furnitures
  PERFORM
    delete_tunnel_furniture(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_furniture
  WHERE
    tunnel_hollow_space_id = $1;

  -- delete tunnel_installations
  PERFORM
    delete_tunnel_installation(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_installation
  WHERE
    tunnel_hollow_space_id = $1;

  -- delete tunnel_thematic_surfaces
  PERFORM
    delete_tunnel_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_thematic_surface
  WHERE
    tunnel_hollow_space_id = $1;

  -- delete tunnel_hollow_spaces
  DELETE FROM
    tunnel_hollow_space
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
TUNNEL
*/
CREATE OR REPLACE FUNCTION delete_tunnel(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      tunnel t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete tunnel_hollow_spaces
  PERFORM
    delete_tunnel_hollow_space(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    tunnel_hollow_space t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_id = a.a_id;

  -- delete tunnel_installations
  PERFORM
    delete_tunnel_installation(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    tunnel_installation t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_id = a.a_id;

  -- delete tunnel_thematic_surfaces
  PERFORM
    delete_tunnel_them_srf(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    tunnel_thematic_surface t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_id = a.a_id;

  -- delete referenced parts
  PERFORM
    delete_tunnel(array_agg(t.id), array_agg(DISTINCT t.objectclass_id))
  FROM
    tunnel t,
    unnest($1) a(a_id)
  WHERE
    t.tunnel_parent_id = a.a_id
    AND t.id != a.a_id;

  -- delete tunnels
  WITH delete_objects AS (
    DELETE FROM
      tunnel t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_tunnel(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      tunnel
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete tunnel_hollow_spaces
  PERFORM
    delete_tunnel_hollow_space(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_hollow_space
  WHERE
    tunnel_id = $1;

  -- delete tunnel_installations
  PERFORM
    delete_tunnel_installation(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_installation
  WHERE
    tunnel_id = $1;

  -- delete tunnel_thematic_surfaces
  PERFORM
    delete_tunnel_them_srf(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel_thematic_surface
  WHERE
    tunnel_id = $1;

  --delete referenced parts
  PERFORM
    delete_tunnel(array_agg(id), array_agg(DISTINCT objectclass_id))
  FROM
    tunnel
  WHERE
    tunnel_parent_id = $1
    AND id != $1;

  -- delete tunnels
  DELETE FROM
    tunnel
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* VEGETATION
*******************/
/*
PLANT COVER
*/
CREATE OR REPLACE FUNCTION delete_plant_cover(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      plant_cover t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete plant_covers
  WITH delete_objects AS (
    DELETE FROM
      plant_cover t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_plant_cover(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      plant_cover
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete plant_covers
  DELETE FROM
    plant_cover
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
SOLITARY VEGETATION OBJECT
*/
CREATE OR REPLACE FUNCTION delete_solitary_veg_obj(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      solitary_vegetat_object t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete solitary_vegetat_objects
  WITH delete_objects AS (
    DELETE FROM
      solitary_vegetat_object t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
  )
  SELECT
    array_agg(id),
    array_agg(lod1_implicit_rep_id) ||
    array_agg(lod2_implicit_rep_id) ||
    array_agg(lod3_implicit_rep_id) ||
    array_agg(lod4_implicit_rep_id)
  INTO
    deleted_ids,
    implicit_geometry_ids
  FROM
    delete_objects;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      solitary_vegetat_object n1
      ON n1.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      solitary_vegetat_object n2
      ON n2.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      solitary_vegetat_object n3
      ON n3.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      solitary_vegetat_object n4
      ON n4.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_solitary_veg_obj(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  implicit_geometry_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      solitary_vegetat_object
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete solitary_vegetat_objects
  DELETE FROM
    solitary_vegetat_object
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id,
    ARRAY[
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    ]
  INTO
    deleted_id,
    implicit_geometry_ids;

  -- delete implicit_geometry(s) not being referenced any more
  IF -1 = ALL(implicit_geometry_ids) IS NOT NULL THEN
    PERFORM
      delete_implicit_geometry(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(implicit_geometry_ids) AS a_id) a
    LEFT JOIN
      solitary_vegetat_object n1
      ON n1.lod1_implicit_rep_id = a.a_id
    LEFT JOIN
      solitary_vegetat_object n2
      ON n2.lod2_implicit_rep_id = a.a_id
    LEFT JOIN
      solitary_vegetat_object n3
      ON n3.lod3_implicit_rep_id = a.a_id
    LEFT JOIN
      solitary_vegetat_object n4
      ON n4.lod4_implicit_rep_id = a.a_id
    WHERE
      n1.lod1_implicit_rep_id IS NULL
      AND n2.lod2_implicit_rep_id IS NULL
      AND n3.lod3_implicit_rep_id IS NULL
      AND n4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* WATER BODY
*******************/
/*
WATER BOUNDARY SURFACE
*/
CREATE OR REPLACE FUNCTION delete_waterbnd_surface(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      waterboundary_surface t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete waterboundary_surfaces
  WITH delete_objects AS (
    DELETE FROM
      waterboundary_surface t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_waterbnd_surface(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      waterboundary_surface
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete waterboundary_surfaces
  DELETE FROM
    waterboundary_surface
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*
WATER BODY
*/
CREATE OR REPLACE FUNCTION delete_waterbody(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
  waterboundary_sur_ids int[] := '{}';
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      waterbody t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete references to waterboundary_surfaces
  WITH delete_waterboundary_sur_refs AS (
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
    waterboundary_sur_ids
  FROM
    delete_waterboundary_sur_refs;

  -- delete waterboundary_surface(s) not being referenced any more
  IF -1 = ALL(waterboundary_sur_ids) IS NOT NULL THEN
    PERFORM
      delete_waterbnd_surface(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(waterboundary_sur_ids) AS a_id) a
    LEFT JOIN
      waterbod_to_waterbnd_srf n1
      ON n1.waterboundary_surface_id = a.a_id
    WHERE
      n1.waterboundary_surface_id IS NULL;
  END IF;

  -- delete waterbodys
  WITH delete_objects AS (
    DELETE FROM
      waterbody t
    USING
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id
      AND t.objectclass_id = ANY (class_ids)
    RETURNING
      id
  )
  SELECT
    array_agg(id)
  INTO
    deleted_ids
  FROM
    delete_objects;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_ids, class_ids);

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_waterbody(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  waterboundary_sur_ids int[] := '{}';
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      waterbody
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete references to waterboundary_surfaces
  WITH delete_waterboundary_sur_refs AS (
    DELETE FROM
      waterbod_to_waterbnd_srf
    WHERE
      waterbody_id = $1
    RETURNING
      waterboundary_surface_id
  )
  SELECT
    array_agg(waterboundary_surface_id)
  INTO
    waterboundary_sur_ids
  FROM
    delete_waterboundary_sur_refs;

  -- delete waterboundary_surface(s) not being referenced any more
  IF -1 = ALL(waterboundary_sur_ids) IS NOT NULL THEN
    PERFORM
      delete_waterbnd_surface(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(waterboundary_sur_ids) AS a_id) a
    LEFT JOIN
      waterbod_to_waterbnd_srf n1
      ON n1.waterboundary_surface_id = a.a_id
    WHERE
      n1.waterboundary_surface_id IS NULL;
  END IF;

  -- delete waterbodys
  DELETE FROM
    waterbody
  WHERE
    id = $1
    AND objectclass_id = class_id
  RETURNING
    id
  INTO
    deleted_id;

  -- delete cityobject
  PERFORM delete_cityobject_post(deleted_id, class_id);

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*********************
* CITYOBJECT ROUTER
*********************/
CREATE OR REPLACE FUNCTION delete_cityobject(
    pids integer[],
    objclass_ids integer[] DEFAULT '{}'::integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids INTEGER[] := '{}';
  class_ids INTEGER[];
BEGIN
  -- fetch objectclass_ids if not set
  IF array_length($2, 1) IS NULL THEN
    SELECT
      array_agg(DISTINCT t.objectclass_id)
    INTO
      class_ids
    FROM
      cityobject t,
      unnest($1) a(a_id)
    WHERE
      t.id = a.a_id;
  ELSE
    SELECT
      array_agg(DISTINCT a.a_id)
    INTO
      class_ids
    FROM
      unnest($2) AS a(a_id);
  END IF;

  IF array_length(class_ids, 1) IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NEXT NULL;
  END IF;

  -- delete bridges
  IF class_ids && ARRAY[62,63,64]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge($1, class_ids) AS a(a_id));
  END IF;

  -- delete bridge_constr_elements
  IF class_ids && ARRAY[82]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge_constr_element($1, class_ids) AS a(a_id));
  END IF;

  -- delete bridge_furnitures
  IF class_ids && ARRAY[80]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge_furniture($1, class_ids) AS a(a_id));
  END IF;

  -- delete bridge_installations
  IF class_ids && ARRAY[65,66]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge_installation($1, class_ids) AS a(a_id));
  END IF;

  -- delete bridge_openings
  IF class_ids && ARRAY[77,78,79]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge_opening($1, class_ids) AS a(a_id));
  END IF;

  -- delete bridge_rooms
  IF class_ids && ARRAY[81]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge_room($1, class_ids) AS a(a_id));
  END IF;

  -- delete bridge_thematic_surfaces
  IF class_ids && ARRAY[67,68,69,70,71,72,73,74,75,76]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_bridge_them_srf($1, class_ids) AS a(a_id));
  END IF;

  -- delete buildings
  IF class_ids && ARRAY[24,25,26]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_building($1, class_ids) AS a(a_id));
  END IF;

  -- delete building_furnitures
  IF class_ids && ARRAY[40]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_building_furniture($1, class_ids) AS a(a_id));
  END IF;

  -- delete building_installations
  IF class_ids && ARRAY[27,28]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_building_installation($1, class_ids) AS a(a_id));
  END IF;

  -- delete city_furnitures
  IF class_ids && ARRAY[21]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_city_furniture($1, class_ids) AS a(a_id));
  END IF;

  -- delete cityobjectgroups
  IF class_ids && ARRAY[23]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_cityobjectgroup($1, class_ids) AS a(a_id));
  END IF;

  -- delete generic_cityobjects
  IF class_ids && ARRAY[5]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_generic_cityobject($1, class_ids) AS a(a_id));
  END IF;

  -- delete land_uses
  IF class_ids && ARRAY[4]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_land_use($1, class_ids) AS a(a_id));
  END IF;

  -- delete openings
  IF class_ids && ARRAY[37,38,39]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_opening($1, class_ids) AS a(a_id));
  END IF;

  -- delete plant_covers
  IF class_ids && ARRAY[8]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_plant_cover($1, class_ids) AS a(a_id));
  END IF;

  -- delete relief_components
  IF class_ids && ARRAY[15,16,17,18,19]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_relief_component($1, class_ids) AS a(a_id));
  END IF;

  -- delete relief_features
  IF class_ids && ARRAY[14]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_relief_feature($1, class_ids) AS a(a_id));
  END IF;

  -- delete rooms
  IF class_ids && ARRAY[41]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_room($1, class_ids) AS a(a_id));
  END IF;

  -- delete solitary_vegetat_objects
  IF class_ids && ARRAY[7]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_solitary_veg_obj($1, class_ids) AS a(a_id));
  END IF;

  -- delete thematic_surfaces
  IF class_ids && ARRAY[29,30,31,32,33,34,35,36,60,61]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_thematic_surface($1, class_ids) AS a(a_id));
  END IF;

  -- delete traffic_areas
  IF class_ids && ARRAY[47,48]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_traffic_area($1, class_ids) AS a(a_id));
  END IF;

  -- delete transportation_complexs
  IF class_ids && ARRAY[42,43,44,45,46]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_transport_complex($1, class_ids) AS a(a_id));
  END IF;

  -- delete tunnels
  IF class_ids && ARRAY[83,84,85]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tunnel($1, class_ids) AS a(a_id));
  END IF;

  -- delete tunnel_furnitures
  IF class_ids && ARRAY[101]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tunnel_furniture($1, class_ids) AS a(a_id));
  END IF;

  -- delete tunnel_hollow_spaces
  IF class_ids && ARRAY[102]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tunnel_hollow_space($1, class_ids) AS a(a_id));
  END IF;

  -- delete tunnel_installations
  IF class_ids && ARRAY[86,87]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tunnel_installation($1, class_ids) AS a(a_id));
  END IF;

  -- delete tunnel_openings
  IF class_ids && ARRAY[98,99,100]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tunnel_opening($1, class_ids) AS a(a_id));
  END IF;

  -- delete tunnel_thematic_surfaces
  IF class_ids && ARRAY[88,89,90,91,92,93,94,95,96,97]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_tunnel_them_srf($1, class_ids) AS a(a_id));
  END IF;

  -- delete waterbodys
  IF class_ids && ARRAY[9]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_waterbody($1, class_ids) AS a(a_id));
  END IF;

  -- delete waterboundary_surfaces
  IF class_ids && ARRAY[10,11,12,13]::int[] THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_waterbnd_surface($1, class_ids) AS a(a_id));
  END IF;

  IF array_length(deleted_ids, 1) IS NULL OR array_length(deleted_ids, 1) <> array_length($1, 1) THEN
    deleted_ids := deleted_ids || (SELECT array_agg(a_id) FROM delete_cityobject_post($1, class_ids) AS a(a_id));
  END IF;

  RETURN QUERY
    SELECT unnest(deleted_ids);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_cityobject(
    pid integer,
    objclass_id integer DEFAULT 0)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  -- fetch objectclass_id if not set
  IF $2 = 0 THEN
    SELECT
      objectclass_id
    INTO
      class_id
    FROM
      cityobject
    WHERE
      id = $1;
  ELSE
    class_id := $2;
  END IF;

  IF class_id IS NULL THEN
    RAISE NOTICE 'Objectclass_id unknown! Check OBJECTCLASS table.';
    RETURN NULL;
  END IF;

  -- delete bridge
  IF class_id IN (62,63,64) THEN
    deleted_id := delete_bridge($1, class_id);
  END IF;

  -- delete bridge_constr_element
  IF class_id IN (82) THEN
    deleted_id := delete_bridge_constr_element($1, class_id);
  END IF;

  -- delete bridge_furniture
  IF class_id IN (80) THEN
    deleted_id := delete_bridge_furniture($1, class_id);
  END IF;

  -- delete bridge_installation
  IF class_id IN (65,66) THEN
    deleted_id := delete_bridge_installation($1, class_id);
  END IF;

  -- delete bridge_opening
  IF class_id IN (77,78,79) THEN
    deleted_id := delete_bridge_opening($1, class_id);
  END IF;

  -- delete bridge_room
  IF class_id IN (81) THEN
    deleted_id := delete_bridge_room($1, class_id);
  END IF;

  -- delete bridge_thematic_surface
  IF class_id IN (67,68,69,70,71,72,73,74,75,76) THEN
    deleted_id := delete_bridge_them_srf($1, class_id);
  END IF;

  -- delete building
  IF class_id IN (24,25,26) THEN
    deleted_id := delete_building($1, class_id);
  END IF;

  -- delete building_furniture
  IF class_id IN (40) THEN
    deleted_id := delete_building_furniture($1, class_id);
  END IF;

  -- delete building_installation
  IF class_id IN (27,28) THEN
    deleted_id := delete_building_installation($1, class_id);
  END IF;

  -- delete city_furniture
  IF class_id IN (21) THEN
    deleted_id := delete_city_furniture($1, class_id);
  END IF;

  -- delete cityobjectgroup
  IF class_id IN (23) THEN
    deleted_id := delete_cityobjectgroup($1, class_id);
  END IF;

  -- delete generic_cityobject
  IF class_id IN (5) THEN
    deleted_id := delete_generic_cityobject($1, class_id);
  END IF;

  -- delete land_use
  IF class_id IN (4) THEN
    deleted_id := delete_land_use($1, class_id);
  END IF;

  -- delete opening
  IF class_id IN (37,38,39) THEN
    deleted_id := delete_opening($1, class_id);
  END IF;

  -- delete plant_cover
  IF class_id IN (8) THEN
    deleted_id := delete_plant_cover($1, class_id);
  END IF;

  -- delete relief_component
  IF class_id IN (15,16,17,18,19) THEN
    deleted_id := delete_relief_component($1, class_id);
  END IF;

  -- delete relief_feature
  IF class_id IN (14) THEN
    deleted_id := delete_relief_feature($1, class_id);
  END IF;

  -- delete room
  IF class_id IN (41) THEN
    deleted_id := delete_room($1, class_id);
  END IF;

  -- delete solitary_vegetat_object
  IF class_id IN (7) THEN
    deleted_id := delete_solitary_veg_obj($1, class_id);
  END IF;

  -- delete thematic_surface
  IF class_id IN (29,30,31,32,33,34,35,36,60,61) THEN
    deleted_id := delete_thematic_surface($1, class_id);
  END IF;

  -- delete traffic_area
  IF class_id IN (47,48) THEN
    deleted_id := delete_traffic_area($1, class_id);
  END IF;

  -- delete transportation_complex
  IF class_id IN (42,43,44,45,46) THEN
    deleted_id := delete_transport_complex($1, class_id);
  END IF;

  -- delete tunnel
  IF class_id IN (83,84,85) THEN
    deleted_id := delete_tunnel($1, class_id);
  END IF;

  -- delete tunnel_furniture
  IF class_id IN (101) THEN
    deleted_id := delete_tunnel_furniture($1, class_id);
  END IF;

  -- delete tunnel_hollow_space
  IF class_id IN (102) THEN
    deleted_id := delete_tunnel_hollow_space($1, class_id);
  END IF;

  -- delete tunnel_installation
  IF class_id IN (86,87) THEN
    deleted_id := delete_tunnel_installation($1, class_id);
  END IF;

  -- delete tunnel_opening
  IF class_id IN (98,99,100) THEN
    deleted_id := delete_tunnel_opening($1, class_id);
  END IF;

  -- delete tunnel_thematic_surface
  IF class_id IN (88,89,90,91,92,93,94,95,96,97) THEN
    deleted_id := delete_tunnel_them_srf($1, class_id);
  END IF;

  -- delete waterbody
  IF class_id IN (9) THEN
    deleted_id := delete_waterbody($1, class_id);
  END IF;

  -- delete waterboundary_surface
  IF class_id IN (10,11,12,13) THEN
    deleted_id := delete_waterbnd_surface($1, class_id);
  END IF;

  IF deleted_id IS NULL THEN
    deleted_id := delete_cityobject_post($1, class_id);
  END IF;

  RETURN deleted_id;
END;
$BODY$
LANGUAGE plpgsql STRICT;


/****************************
* CITY MODEL incl. MEMBERS
****************************/
CREATE OR REPLACE FUNCTION delete_citymodel_with_members(pids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids int[] := '{}';
  cityobject_ids int[] := '{}';
BEGIN
  -- delete references to cityobjects
  WITH delete_cityobject_refs AS (
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
    delete_cityobject_refs;

  -- delete cityobject(s) not being referenced any more
  IF -1 = ALL(cityobject_ids) IS NOT NULL THEN
    PERFORM
      delete_cityobject(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(cityobject_ids) AS a_id) a
    LEFT JOIN
      cityobject_member n1
      ON n1.cityobject_id = a.a_id
    LEFT JOIN
      generalization n2
      ON n2.generalizes_to_id = a.a_id
    LEFT JOIN
      generalization n3
      ON n3.cityobject_id = a.a_id     
    LEFT JOIN
      cityobjectgroup n4
      ON n4.parent_cityobject_id = a.a_id
    LEFT JOIN
      group_to_cityobject n5
      ON n5.cityobject_id = a.a_id
    WHERE
      n1.cityobject_id IS NULL
      AND n2.generalizes_to_id IS NULL
      AND n3.cityobject_id IS NULL
      AND n4.parent_cityobject_id IS NULL
      AND n5.cityobject_id IS NULL;
  END IF;

  -- delete citymodels
  RETURN QUERY
    SELECT delete_citymodel($1);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_citymodel_with_members(pid integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  cityobject_ids int[] := '{}';
BEGIN
  -- delete references to cityobjects
  WITH delete_cityobject_refs AS (
    DELETE FROM
      cityobject_member
    WHERE
      citymodel_id = $1
    RETURNING
      cityobject_id
  )
  SELECT
    array_agg(cityobject_id)
  INTO
    cityobject_ids
  FROM
    delete_cityobject_refs;

  -- delete cityobject(s) not being referenced any more
  IF -1 = ALL(cityobject_ids) IS NOT NULL THEN
    PERFORM
      delete_cityobject(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(cityobject_ids) AS a_id) a
    LEFT JOIN
      cityobject_member n1
      ON n1.cityobject_id = a.a_id
    LEFT JOIN
      generalization n2
      ON n2.generalizes_to_id = a.a_id
    LEFT JOIN
      generalization n3
      ON n3.cityobject_id = a.a_id     
    LEFT JOIN
      cityobjectgroup n4
      ON n4.parent_cityobject_id = a.a_id
    LEFT JOIN
      group_to_cityobject n5
      ON n5.cityobject_id = a.a_id
    WHERE
      n1.cityobject_id IS NULL
      AND n2.generalizes_to_id IS NULL
      AND n3.cityobject_id IS NULL
      AND n4.parent_cityobject_id IS NULL
      AND n5.cityobject_id IS NULL;
  END IF;

  -- delete citymodels
  RETURN delete_citymodel($1);
END;
$BODY$
LANGUAGE plpgsql STRICT;


CREATE OR REPLACE FUNCTION delete_cityobjectgroup_with_members(pids integer[])
  RETURNS SETOF integer AS
$BODY$
DECLARE
  deleted_ids int[] := '{}';
  cityobject_ids int[] := '{}';
BEGIN
  -- delete references to cityobjects
  WITH delete_cityobject_refs AS (
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
    delete_cityobject_refs;

  -- delete cityobject(s) not being referenced any more
  IF -1 = ALL(cityobject_ids) IS NOT NULL THEN
    PERFORM
      delete_cityobject(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(cityobject_ids) AS a_id) a
    LEFT JOIN
      group_to_cityobject n1
      ON n1.cityobject_id = a.a_id
    LEFT JOIN
      generalization n2
      ON n2.generalizes_to_id = a.a_id
    LEFT JOIN
      generalization n3
      ON n3.cityobject_id = a.a_id
    LEFT JOIN
      cityobjectgroup n4
      ON n4.parent_cityobject_id = a.a_id
    LEFT JOIN
      cityobject_member n5
      ON n5.cityobject_id = a.a_id
    WHERE
      n1.cityobject_id IS NULL
      AND n2.generalizes_to_id IS NULL
      AND n3.cityobject_id IS NULL
      AND n4.parent_cityobject_id IS NULL
      AND n5.cityobject_id IS NULL;
  END IF;

  -- delete cityobjectgroups
  RETURN QUERY
    SELECT delete_cityobjectgroup($1);
END;
$BODY$
LANGUAGE plpgsql STRICT;

CREATE OR REPLACE FUNCTION delete_cityobjectgroup_with_members(pid integer)
  RETURNS integer AS
$BODY$
DECLARE
  deleted_id INTEGER;
  cityobject_ids int[] := '{}';
BEGIN
  -- delete references to cityobjects
  WITH delete_cityobject_refs AS (
    DELETE FROM
      group_to_cityobject
    WHERE
      cityobjectgroup_id = $1
    RETURNING
      cityobject_id
  )
  SELECT
    array_agg(cityobject_id)
  INTO
    cityobject_ids
  FROM
    delete_cityobject_refs;

  -- delete cityobject(s) not being referenced any more
  IF -1 = ALL(cityobject_ids) IS NOT NULL THEN
    PERFORM
      delete_cityobject(array_agg(a.a_id))
    FROM
      (SELECT DISTINCT unnest(cityobject_ids) AS a_id) a
    LEFT JOIN
      group_to_cityobject n1
      ON n1.cityobject_id = a.a_id
    LEFT JOIN
      generalization n2
      ON n2.generalizes_to_id = a.a_id
    LEFT JOIN
      generalization n3
      ON n3.cityobject_id = a.a_id
    LEFT JOIN
      cityobjectgroup n4
      ON n4.parent_cityobject_id = a.a_id
    LEFT JOIN
      cityobject_member n5
      ON n5.cityobject_id = a.a_id
    WHERE
      n1.cityobject_id IS NULL
      AND n2.generalizes_to_id IS NULL
      AND n3.cityobject_id IS NULL
      AND n4.parent_cityobject_id IS NULL
      AND n5.cityobject_id IS NULL;
  END IF;

  -- delete cityobjectgroups
  RETURN delete_cityobjectgroup($1);
END;
$BODY$
LANGUAGE plpgsql STRICT;


/*******************
* CLEANUP
*******************/
-- truncates all tables
CREATE OR REPLACE FUNCTION cleanup_schema() RETURNS SETOF VOID AS
$$
BEGIN
  -- clear tables
  TRUNCATE TABLE cityobject CASCADE;
  TRUNCATE TABLE tex_image CASCADE;
  TRUNCATE TABLE grid_coverage CASCADE;
  TRUNCATE TABLE address CASCADE;
  TRUNCATE TABLE citymodel CASCADE;

  -- restart sequences
  ALTER SEQUENCE address_seq RESTART;
  ALTER SEQUENCE appearance_seq RESTART;
  ALTER SEQUENCE citymodel_seq RESTART;
  ALTER SEQUENCE cityobject_genericatt_seq RESTART;
  ALTER SEQUENCE cityobject_seq RESTART;
  ALTER SEQUENCE external_ref_seq RESTART;
  ALTER SEQUENCE grid_coverage_seq RESTART;
  ALTER SEQUENCE implicit_geometry_seq RESTART;
  ALTER SEQUENCE surface_data_seq RESTART;
  ALTER SEQUENCE surface_geometry_seq RESTART;
  ALTER SEQUENCE tex_image_seq RESTART;
END; 
$$ 
LANGUAGE plpgsql;