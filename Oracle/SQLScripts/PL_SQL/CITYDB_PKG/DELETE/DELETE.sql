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

CREATE OR REPLACE PACKAGE citydb_delete
AS
  FUNCTION cleanup_appearances(only_global int :=1) RETURN ID_ARRAY;
  PROCEDURE cleanup_schema;
  FUNCTION delete_address(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_address(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_appearance(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_appearance(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_bridge(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_bridge_constr_element(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge_constr_element(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_bridge_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_bridge_installation(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge_installation(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_bridge_opening(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge_opening(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_bridge_room(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge_room(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_bridge_them_srf(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_bridge_them_srf(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_building(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_building(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_building_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_building_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_building_installation(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_building_installation(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_city_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_city_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_citymodel(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_citymodel(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_citymodel_with_members(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_citymodel_with_members(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_cityobject(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_cityobject(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_cityobject_post(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_cityobject_post(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_cityobjectgroup(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_cityobjectgroup(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_group_with_members(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_group_with_members(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_external_reference(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_external_reference(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_genericattrib(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_genericattrib(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_generic_cityobject(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_generic_cityobject(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_implicit_geometry(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_implicit_geometry(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_land_use(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_land_use(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_opening(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_opening(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_plant_cover(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_plant_cover(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_relief_component(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_relief_component(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_relief_component_post(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_relief_component_post(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_relief_feature(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_relief_feature(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_room(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_room(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_solitary_veg_obj(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_solitary_veg_obj(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_surface_data(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_surface_data(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_surface_geometry(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_surface_geometry(pids ID_ARRAY) RETURN ID_ARRAY;
  FUNCTION delete_thematic_surface(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_thematic_surface(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_traffic_area(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_traffic_area(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_transport_complex(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_transport_complex(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_tunnel(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_tunnel(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_tunnel_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_tunnel_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_tunnel_hollow_space(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_tunnel_hollow_space(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_tunnel_installation(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_tunnel_installation(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_tunnel_opening(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_tunnel_opening(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_tunnel_them_srf(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_tunnel_them_srf(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_waterbnd_surface(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_waterbnd_surface(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;
  FUNCTION delete_waterbody(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER;
  FUNCTION delete_waterbody(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY;

END citydb_delete;
/

CREATE OR REPLACE PACKAGE BODY citydb_delete
AS

  /*******************
  * CORE
  *******************/
  /*
  ADDRESS
  */
  FUNCTION delete_address(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete addresses
    DELETE FROM
      address t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_address(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
  BEGIN
    -- delete address
    DELETE FROM
      address
    WHERE
      id = pid
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;


  /*
  EXTERNAL REFERENCE
  */
  FUNCTION delete_external_reference(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete external_references
    DELETE FROM
      external_reference t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_external_reference(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
  BEGIN
    -- delete external_reference
    DELETE FROM
      external_reference
    WHERE
      id = pid
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;

  /*
  GENERIC ATTRIBUTES
  */
  FUNCTION delete_genericattrib(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    surface_geom_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete cityobject_genericattribs
    DELETE FROM
      cityobject_genericattrib t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id,
      surface_geometry_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geom_ids;

    -- delete surface_geometry not being referenced any more
    IF surface_geom_ids IS NOT EMPTY THEN
      DELETE FROM
        surface_geometry m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(surface_geom_ids) a
        LEFT JOIN
          cityobject_genericattrib n1
          ON n1.surface_geometry_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.surface_geometry_id IS NULL
      );
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_genericattrib(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    surface_geometry_ref_id NUMBER;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- delete cityobject_genericattrib
    DELETE FROM
      cityobject_genericattrib
    WHERE
      id = pid
    RETURNING
      id,
      surface_geometry_id
    INTO
      deleted_id,
      surface_geometry_ref_id;

    -- delete surface_geometry not being referenced any more
    IF surface_geometry_ref_id IS NOT NULL THEN
      DELETE FROM
        surface_geometry m
      WHERE EXISTS (
        SELECT
          1
        FROM
          TABLE(ID_ARRAY(surface_geometry_ref_id)) a
        LEFT JOIN
          cityobject_genericattrib n1
          ON n1.surface_geometry_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.surface_geometry_id IS NULL
      );
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * APPEARANCE
  *******************/
  /*
  TEX IMAGES
  */
  FUNCTION delete_tex_image(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete tex_images
    DELETE FROM
      tex_image t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tex_image(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
  BEGIN
    -- delete tex_image
    DELETE FROM
      tex_image
    WHERE
      id = pid
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;


  /*
  SURFACE DATA
  */
  FUNCTION delete_surface_data(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    tex_image_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        surface_data t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete surface_data
    DELETE FROM
      surface_data t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      tex_image_id
    BULK COLLECT INTO
      deleted_ids,
      tex_image_ids;

    -- delete tex_image(s) not being referenced any more
    IF tex_image_ids IS NOT EMPTY THEN
      DELETE FROM
        tex_image m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(tex_image_ids) a
        LEFT JOIN
          surface_data n1
          ON n1.tex_image_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.tex_image_id IS NULL
      );
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_surface_data(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    tex_image_ref_id NUMBER;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        surface_data
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete surface_data
    DELETE FROM
      surface_data
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      tex_image_id
    INTO
      deleted_id,
      tex_image_ref_id;

    -- delete tex_image not being referenced any more
    IF tex_image_ref_id IS NOT NULL THEN
      DELETE FROM
        tex_image m
      WHERE EXISTS (
        SELECT
          1
        FROM
          TABLE(ID_ARRAY(tex_image_ref_id)) a
        LEFT JOIN
          surface_data n1
          ON n1.tex_image_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.tex_image_id IS NULL
      );
    END IF;

    RETURN deleted_id;
  END;


  /*
  APPEARANCE
  */
  FUNCTION delete_appearance(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    surface_data_ids ID_ARRAY;
    surface_data_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete references to surface_data
    DELETE FROM
      appear_to_surface_data t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.appearance_id
    )
    RETURNING
      surface_data_id
    BULK COLLECT INTO
      surface_data_ids;

    -- delete surface_data(s) not being referenced any more
    IF surface_data_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        surface_data_pids
      FROM
        TABLE(surface_data_ids) a
      LEFT JOIN
        appear_to_surface_data n1
        ON n1.surface_data_id = a.COLUMN_VALUE
      LEFT JOIN
        textureparam n2
        ON n2.surface_data_id = a.COLUMN_VALUE
      WHERE
        n1.surface_data_id IS NULL
        AND n2.surface_data_id IS NULL;

      IF surface_data_pids IS NOT EMPTY THEN
        dummy_ids := delete_surface_data(surface_data_pids);
      END IF;
    END IF;

    -- delete appearances
    DELETE FROM
      appearance t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_appearance(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    surface_data_ids ID_ARRAY;
    surface_data_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete references to surface_data
    DELETE FROM
      appear_to_surface_data
    WHERE
      appearance_id = pid
    RETURNING
      surface_data_id
    BULK COLLECT INTO
      surface_data_ids;

    -- delete surface_data(s) not being referenced any more
    IF surface_data_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        surface_data_pids
      FROM
        TABLE(surface_data_ids) a
      LEFT JOIN
        appear_to_surface_data n1
        ON n1.surface_data_id = a.COLUMN_VALUE
      LEFT JOIN
        textureparam n2
        ON n2.surface_data_id = a.COLUMN_VALUE
      WHERE
        n1.surface_data_id IS NULL
        AND n2.surface_data_id IS NULL;

      IF surface_data_pids IS NOT EMPTY THEN
        dummy_ids := delete_surface_data(surface_data_pids);
      END IF;
    END IF;

    -- delete appearance
    DELETE FROM
      appearance
    WHERE
      id = pid
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;

  FUNCTION cleanup_appearances(only_global int := 1) RETURN id_array
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    surface_data_ids ID_ARRAY;
    appearance_ids ID_ARRAY;
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- global appearances are not related to a cityobject.
    -- however, we assume that all surface geometries of a cityobject
    -- have been deleted at this stage. thus, we can check and delete
    -- surface data which does not have a valid texture parameterization
    -- any more.
    SELECT
      s.id
    BULK COLLECT INTO
      surface_data_ids
    FROM 
      surface_data s
    LEFT OUTER JOIN
      textureparam t
      ON s.id=t.surface_data_id
    WHERE t.surface_data_id IS NULL;

    IF surface_data_ids IS NOT EMPTY THEN
      dummy_ids := delete_surface_data(surface_data_ids);
    END IF;

    -- delete appearances which does not have surface data any more
    IF only_global = 1 THEN
      SELECT
        a.id
      BULK COLLECT INTO
        appearance_ids
      FROM
        appearance a
      LEFT OUTER JOIN
        appear_to_surface_data asd
        ON a.id=asd.appearance_id
      WHERE
        a.cityobject_id IS NULL
        AND asd.appearance_id IS NULL;
    ELSE
      SELECT
        a.id
      BULK COLLECT INTO
        appearance_ids
      FROM
        appearance a
      LEFT OUTER JOIN
        appear_to_surface_data asd
        ON a.id=asd.appearance_id
      WHERE
        asd.appearance_id IS NULL;
    END IF;

    IF appearance_ids IS NOT EMPTY THEN
      deleted_ids := delete_appearance(appearance_ids);
    END IF;

    RETURN deleted_ids;
  END;

  /************
  * GEOMETRY
  ************/
  /*
  SURFACE GEOMETRY
  */
  FUNCTION delete_surface_geometry(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete surface_geometry
    DELETE FROM
      surface_geometry t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_surface_geometry(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
  BEGIN
    -- delete surface_geometry
    DELETE FROM
      surface_geometry
    WHERE
      id = pid
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;


  /*
  IMPLICIT GEOMETRY
  */
  FUNCTION delete_implicit_geometry(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    surface_geom_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete implicit_geometry
    DELETE FROM
      implicit_geometry t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id,
      relative_brep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geom_ids;

    -- delete surface_geometry not being referenced any more
    IF surface_geom_ids IS NOT EMPTY THEN
      DELETE FROM
        surface_geometry m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(surface_geom_ids) a
        LEFT JOIN
          implicit_geometry n1
          ON n1.relative_brep_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.relative_brep_id IS NULL
      );
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_implicit_geometry(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    surface_geometry_ref_id NUMBER;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- delete implicit_geometry
    DELETE FROM
      implicit_geometry
    WHERE
     id = pid
    RETURNING
      id,
      relative_brep_id
    INTO
      deleted_id,
      surface_geometry_ref_id;

    -- delete surface_geometry not being referenced any more
    IF surface_geometry_ref_id IS NOT NULL THEN
      DELETE FROM
        surface_geometry m
      WHERE EXISTS (
        SELECT
          1
        FROM
          TABLE(ID_ARRAY(surface_geometry_ref_id)) a
        LEFT JOIN
          implicit_geometry n1
          ON n1.relative_brep_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.relative_brep_id IS NULL
      );
    END IF;

    RETURN deleted_id;
  END;


  /***********************
  * CITYOBJECT INTERNALS
  ***********************/
  FUNCTION delete_cityobject_post(pids ID_ARRAY, objclass_ids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    class_ids := objclass_ids;

    -- delete appearances
    SELECT
      t.id
    BULK COLLECT INTO
      child_ids
    FROM
      appearance t,
      TABLE(pids) a
    WHERE
      t.cityobject_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_appearance(child_ids);
    END IF;

    -- delete cityobject_genericattribs
    SELECT
      t.id
    BULK COLLECT INTO
      child_ids
    FROM
      cityobject_genericattrib t,
      TABLE(pids) a
    WHERE
      t.cityobject_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_genericattrib(child_ids);
    END IF;

    -- delete cityobjects
    DELETE FROM
      cityobject t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_cityobject_post(pid NUMBER, objclass_id NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    class_id := objclass_id;

    -- delete appearances
    SELECT
      id
    BULK COLLECT INTO
      child_ids
    FROM
      appearance
    WHERE
      cityobject_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_appearance(child_ids);
    END IF;

    -- delete cityobject_genericattribs
    SELECT
      id
    BULK COLLECT INTO
      child_ids
    FROM
      cityobject_genericattrib
    WHERE
      cityobject_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_genericattrib(child_ids);
    END IF;

    -- delete cityobject
    DELETE FROM
      cityobject
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;


  /*
  CITY MODEL
  */
  FUNCTION delete_citymodel(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    child_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete appearances
    SELECT
      t.id
    BULK COLLECT INTO
      child_ids
    FROM
      appearance t,
      TABLE(pids) a
    WHERE
      t.citymodel_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_appearance(child_ids);
    END IF;

    -- delete citymodels
    DELETE FROM
      citymodel t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;
  END;

  FUNCTION delete_citymodel(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    child_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete appearances
    SELECT
      id
    BULK COLLECT INTO
      child_ids
    FROM
      appearance
    WHERE
      citymodel_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_appearance(child_ids);
    END IF;

    -- delete citymodel
    DELETE FROM
      citymodel
    WHERE
      id = pid
    RETURNING
      id
    INTO
      deleted_id;

    RETURN deleted_id;
  END;


  /*******************
  * BRIDGE
  *******************/
  /*
  BRIDGE FURNITURE
  */
  FUNCTION delete_bridge_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge_furniture t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_furnitures
    DELETE FROM
      bridge_furniture t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_furniture n1
        ON n1.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ref_id NUMBER;
    implicit_geometry_pid NUMBER;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge_furniture
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_furniture
    DELETE FROM
      bridge_furniture
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      lod4_implicit_rep_id
    INTO
      deleted_id,
      implicit_geometry_ref_id;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ref_id IS NOT NULL THEN
      SELECT
        a.COLUMN_VALUE
      INTO
        implicit_geometry_pid
      FROM
        TABLE(ID_ARRAY(implicit_geometry_ref_id)) a
      LEFT JOIN
        bridge_furniture n1
        ON n1.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pid IS NOT NULL THEN
        dummy_id := delete_implicit_geometry(implicit_geometry_pid);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BRIDGE OPENING
  */
  FUNCTION delete_bridge_opening(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    address_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge_opening t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_openings
    DELETE FROM
      bridge_opening t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      address_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      address_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;

    -- delete address(es) not being referenced any more
    IF address_ids IS NOT EMPTY THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(address_ids) a
        LEFT JOIN
          bridge_opening n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_bridge n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_building n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_opening n1
        ON n1.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n2
        ON n2.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod3_implicit_rep_id IS NULL
        AND n2.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge_opening(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    address_ref_id NUMBER;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge_opening
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_opening
    DELETE FROM
      bridge_opening
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      address_id,
      ID_ARRAY(
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      address_ref_id,
      implicit_geometry_ids;

    -- delete address not being referenced any more
    IF address_ref_id IS NOT NULL THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT
          1
        FROM
          TABLE(ID_ARRAY(address_ref_id)) a
        LEFT JOIN
          bridge_opening n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_bridge n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_building n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_opening n1
        ON n1.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n2
        ON n2.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod3_implicit_rep_id IS NULL
        AND n2.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BRIDGE THEMATIC SURFACE
  */
  FUNCTION delete_bridge_them_srf(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    bridge_opening_ids ID_ARRAY;
    bridge_opening_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge_thematic_surface t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to bridge_openings
    DELETE FROM
      bridge_open_to_them_srf t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.bridge_thematic_surface_id
    )
    RETURNING
      bridge_opening_id
    BULK COLLECT INTO
      bridge_opening_ids;

    -- delete bridge_opening(s) not being referenced any more
    IF bridge_opening_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        bridge_opening_pids
      FROM
        TABLE(bridge_opening_ids) a
      LEFT JOIN
        bridge_open_to_them_srf n1
        ON n1.bridge_opening_id = a.COLUMN_VALUE
      WHERE
        n1.bridge_opening_id IS NULL;

      IF bridge_opening_pids IS NOT EMPTY THEN
        dummy_ids := delete_bridge_opening(bridge_opening_pids);
      END IF;
    END IF;

    -- delete bridge_thematic_surfaces
    DELETE FROM
      bridge_thematic_surface t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge_them_srf(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    bridge_opening_ids ID_ARRAY;
    bridge_opening_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge_thematic_surface
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to bridge_openings
    DELETE FROM
      bridge_open_to_them_srf
    WHERE
      bridge_thematic_surface_id = pid
    RETURNING
      bridge_opening_id
    BULK COLLECT INTO
      bridge_opening_ids;

    -- delete bridge_opening(s) not being referenced any more
    IF bridge_opening_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        bridge_opening_pids
      FROM
        TABLE(bridge_opening_ids) a
      LEFT JOIN
        bridge_open_to_them_srf n1
        ON n1.bridge_opening_id = a.COLUMN_VALUE
      WHERE
        n1.bridge_opening_id IS NULL;

      IF bridge_opening_pids IS NOT EMPTY THEN
        dummy_ids := delete_bridge_opening(bridge_opening_pids);
      END IF;
    END IF;

    -- delete bridge_thematic_surface
    DELETE FROM
      bridge_thematic_surface
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BRIDGE INSTALLATION
  */
  FUNCTION delete_bridge_installation(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge_installation t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_installation_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_installations
    DELETE FROM
      bridge_installation t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_installation n1
        ON n1.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n2
        ON n2.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n3
        ON n3.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod2_implicit_rep_id IS NULL
        AND n2.lod3_implicit_rep_id IS NULL
        AND n3.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge_installation(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge_installation
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface
    WHERE
      bridge_installation_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_installation
    DELETE FROM
      bridge_installation
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_installation n1
        ON n1.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n2
        ON n2.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n3
        ON n3.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod2_implicit_rep_id IS NULL
        AND n2.lod3_implicit_rep_id IS NULL
        AND n3.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BRIDGE ROOM
  */
  FUNCTION delete_bridge_room(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge_room t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_furnitures
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_furniture t,
      TABLE(pids) a
    WHERE
      t.bridge_room_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_furniture(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_installations
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_installation t,
      TABLE(pids) a
    WHERE
      t.bridge_room_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_room_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_rooms
    DELETE FROM
      bridge_room t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge_room(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge_room
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_furnitures
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_furniture
    WHERE
      bridge_room_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_furniture(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_installations
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_installation
    WHERE
      bridge_room_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface
    WHERE
      bridge_room_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_room
    DELETE FROM
      bridge_room
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BRIDGE CONSTRUCTION ELEMENT
  */
  FUNCTION delete_bridge_constr_element(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_ids4 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge_constr_element t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_constr_element_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_constr_elements
    DELETE FROM
      bridge_constr_element t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3,
      implicit_geometry_ids4;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids4;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod1_implicit_rep_id IS NULL
        AND n2.lod2_implicit_rep_id IS NULL
        AND n3.lod3_implicit_rep_id IS NULL
        AND n4.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge_constr_element(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge_constr_element
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface
    WHERE
      bridge_constr_element_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_constr_element
    DELETE FROM
      bridge_constr_element
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod1_implicit_rep_id IS NULL
        AND n2.lod2_implicit_rep_id IS NULL
        AND n3.lod3_implicit_rep_id IS NULL
        AND n4.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BRIDGE
  */
  FUNCTION delete_bridge(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    address_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    part_ids ID_ARRAY;
    part_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        bridge t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to addresses
    DELETE FROM
      address_to_bridge t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.bridge_id
    )
    RETURNING
      ADDRESS_ID
    BULK COLLECT INTO
      address_ids;

    -- delete address(es) not being referenced any more
    IF address_ids IS NOT EMPTY THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(address_ids) a
        LEFT JOIN
          address_to_bridge n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_building n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          bridge_opening n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete bridge_constr_elements
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_constr_element t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_constr_element(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_installations
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_installation t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_rooms
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_room t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_room(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete referenced parts
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      part_ids,
      part_class_ids
    FROM
      bridge t,
      TABLE(pids) a
    WHERE
      t.bridge_parent_id = a.COLUMN_VALUE
      AND t.id != a.COLUMN_VALUE;

    IF part_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge(part_ids, SET(part_class_ids));
    END IF;

    -- delete bridges
    DELETE FROM
      bridge t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_bridge(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    address_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    part_ids ID_ARRAY;
    part_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        bridge
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to addresses
    DELETE FROM
      address_to_bridge
    WHERE
      bridge_id = pid
    RETURNING
      address_id
    BULK COLLECT INTO
      address_ids;

    -- delete address(es) not being referenced any more
    IF address_ids IS NOT EMPTY THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(address_ids) a
        LEFT JOIN
          address_to_bridge n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_building n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          bridge_opening n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete bridge_constr_elements
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_constr_element
    WHERE
      bridge_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_constr_element(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_installations
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_installation
    WHERE
      bridge_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_rooms
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_room
    WHERE
      bridge_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_room(child_ids, SET(child_class_ids));
    END IF;

    -- delete bridge_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      bridge_thematic_surface
    WHERE
      bridge_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete referenced parts
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      part_ids,
      part_class_ids
    FROM
      bridge
    WHERE
      bridge_parent_id = pid
      AND id != pid;

    IF part_ids IS NOT EMPTY THEN
      dummy_ids := delete_bridge(part_ids, SET(part_class_ids));
    END IF;

    -- delete bridge
    DELETE FROM
      bridge
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * BUILDING
  *******************/
  /*
  BUILDING FURNITURE
  */
  FUNCTION delete_building_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        building_furniture t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete building_furnitures
    DELETE FROM
      building_furniture t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        building_furniture n1
        ON n1.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_building_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ref_id NUMBER;
    implicit_geometry_pid NUMBER;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        building_furniture
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete building_furniture
    DELETE FROM
      building_furniture
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      lod4_implicit_rep_id
    INTO
      deleted_id,
      implicit_geometry_ref_id;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ref_id IS NOT NULL THEN
      SELECT
        a.COLUMN_VALUE
      INTO
        implicit_geometry_pid
      FROM
        TABLE(ID_ARRAY(implicit_geometry_ref_id)) a
      LEFT JOIN
        building_furniture n1
        ON n1.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pid IS NOT NULL THEN
        dummy_id := delete_implicit_geometry(implicit_geometry_pid);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  OPENING
  */
  FUNCTION delete_opening(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    address_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        opening t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete openings
    DELETE FROM
      opening t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      address_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      address_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;

    -- delete address(es) not being referenced any more
    IF address_ids IS NOT EMPTY THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(address_ids) a
        LEFT JOIN
          opening n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_bridge n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_building n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          bridge_opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        opening n1
        ON n1.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        opening n2
        ON n2.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod3_implicit_rep_id IS NULL
        AND n2.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_opening(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    address_ref_id NUMBER;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        opening
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete opening
    DELETE FROM
      opening
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      address_id,
      ID_ARRAY(
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      address_ref_id,
      implicit_geometry_ids;

    -- delete address not being referenced any more
    IF address_ref_id IS NOT NULL THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT
          1
        FROM
          TABLE(ID_ARRAY(address_ref_id)) a
        LEFT JOIN
          opening n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_bridge n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_building n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          bridge_opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        opening n1
        ON n1.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        opening n2
        ON n2.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod3_implicit_rep_id IS NULL
        AND n2.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  THEMATIC SURFACE
  */
  FUNCTION delete_thematic_surface(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    opening_ids ID_ARRAY;
    opening_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        thematic_surface t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to openings
    DELETE FROM
      opening_to_them_surface t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.thematic_surface_id
    )
    RETURNING
      opening_id
    BULK COLLECT INTO
      opening_ids;

    -- delete opening(s) not being referenced any more
    IF opening_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        opening_pids
      FROM
        TABLE(opening_ids) a
      LEFT JOIN
        opening_to_them_surface n1
        ON n1.opening_id = a.COLUMN_VALUE
      WHERE
        n1.opening_id IS NULL;

      IF opening_pids IS NOT EMPTY THEN
        dummy_ids := delete_opening(opening_pids);
      END IF;
    END IF;

    -- delete thematic_surfaces
    DELETE FROM
      thematic_surface t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_thematic_surface(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    opening_ids ID_ARRAY;
    opening_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        thematic_surface
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to openings
    DELETE FROM
      opening_to_them_surface
    WHERE
      thematic_surface_id = pid
    RETURNING
      opening_id
    BULK COLLECT INTO
      opening_ids;

    -- delete opening(s) not being referenced any more
    IF opening_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        opening_pids
      FROM
        TABLE(opening_ids) a
      LEFT JOIN
        opening_to_them_surface n1
        ON n1.opening_id = a.COLUMN_VALUE
      WHERE
        n1.opening_id IS NULL;

      IF opening_pids IS NOT EMPTY THEN
        dummy_ids := delete_opening(opening_pids);
      END IF;
    END IF;

    -- delete thematic_surface
    DELETE FROM
      thematic_surface
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BUILDING INSTALLATION
  */
  FUNCTION delete_building_installation(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        building_installation t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      thematic_surface t,
      TABLE(pids) a
    WHERE
      t.building_installation_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_thematic_surface(child_ids, SET(child_class_ids));
    END IF;

    -- delete building_installations
    DELETE FROM
      building_installation t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        building_installation n1
        ON n1.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n2
        ON n2.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n3
        ON n3.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod2_implicit_rep_id IS NULL
        AND n2.lod3_implicit_rep_id IS NULL
        AND n3.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_building_installation(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        building_installation
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      thematic_surface
    WHERE
      building_installation_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_thematic_surface(child_ids, SET(child_class_ids));
    END IF;

    -- delete building_installation
    DELETE FROM
      building_installation
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        building_installation n1
        ON n1.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n2
        ON n2.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n3
        ON n3.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod2_implicit_rep_id IS NULL
        AND n2.lod3_implicit_rep_id IS NULL
        AND n3.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  ROOM
  */
  FUNCTION delete_room(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        room t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete building_furnitures
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      building_furniture t,
      TABLE(pids) a
    WHERE
      t.room_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_building_furniture(child_ids, SET(child_class_ids));
    END IF;

    -- delete building_installations
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      building_installation t,
      TABLE(pids) a
    WHERE
      t.room_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_building_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      thematic_surface t,
      TABLE(pids) a
    WHERE
      t.room_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_thematic_surface(child_ids, SET(child_class_ids));
    END IF;

    -- delete rooms
    DELETE FROM
      room t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_room(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        room
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete building_furnitures
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      building_furniture
    WHERE
      room_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_building_furniture(child_ids, SET(child_class_ids));
    END IF;

    -- delete building_installations
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      building_installation
    WHERE
      room_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_building_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      thematic_surface
    WHERE
      room_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_thematic_surface(child_ids, SET(child_class_ids));
    END IF;

    -- delete room
    DELETE FROM
      room
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BUILDING
  */
  FUNCTION delete_building(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    address_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    part_ids ID_ARRAY;
    part_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        building t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to addresses
    DELETE FROM
      address_to_building t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.building_id
    )
    RETURNING
      ADDRESS_ID
    BULK COLLECT INTO
      address_ids;

    -- delete address(es) not being referenced any more
    IF address_ids IS NOT EMPTY THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(address_ids) a
        LEFT JOIN
          address_to_building n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_bridge n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          bridge_opening n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete building_installations
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      building_installation t,
      TABLE(pids) a
    WHERE
      t.building_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_building_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete rooms
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      room t,
      TABLE(pids) a
    WHERE
      t.building_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_room(child_ids, SET(child_class_ids));
    END IF;

    -- delete thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      thematic_surface t,
      TABLE(pids) a
    WHERE
      t.building_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_thematic_surface(child_ids, SET(child_class_ids));
    END IF;

    -- delete referenced parts
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      part_ids,
      part_class_ids
    FROM
      building t,
      TABLE(pids) a
    WHERE
      t.building_parent_id = a.COLUMN_VALUE
      AND t.id != a.COLUMN_VALUE;

    IF part_ids IS NOT EMPTY THEN
      dummy_ids := delete_building(part_ids, SET(part_class_ids));
    END IF;

    -- delete buildings
    DELETE FROM
      building t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_building(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    address_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    part_ids ID_ARRAY;
    part_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        building
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to addresses
    DELETE FROM
      address_to_building
    WHERE
      building_id = pid
    RETURNING
      address_id
    BULK COLLECT INTO
      address_ids;

    -- delete address(es) not being referenced any more
    IF address_ids IS NOT EMPTY THEN
      DELETE FROM
        address m
      WHERE EXISTS (
        SELECT DISTINCT
          a.COLUMN_VALUE
        FROM
          TABLE(address_ids) a
        LEFT JOIN
          address_to_building n1
          ON n1.address_id = a.COLUMN_VALUE
        LEFT JOIN
          address_to_bridge n2
          ON n2.address_id = a.COLUMN_VALUE
        LEFT JOIN
          bridge_opening n3
          ON n3.address_id = a.COLUMN_VALUE
        LEFT JOIN
          opening n4
          ON n4.address_id = a.COLUMN_VALUE
        WHERE
          m.id = a.COLUMN_VALUE
          AND n1.address_id IS NULL
          AND n2.address_id IS NULL
          AND n3.address_id IS NULL
          AND n4.address_id IS NULL
      );
    END IF;

    -- delete building_installations
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      building_installation
    WHERE
      building_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_building_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete rooms
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      room
    WHERE
      building_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_room(child_ids, SET(child_class_ids));
    END IF;

    -- delete thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      thematic_surface
    WHERE
      building_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_thematic_surface(child_ids, SET(child_class_ids));
    END IF;

    -- delete referenced parts
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      part_ids,
      part_class_ids
    FROM
      building
    WHERE
      building_parent_id = pid
      AND id != pid;

    IF part_ids IS NOT EMPTY THEN
      dummy_ids := delete_building(part_ids, SET(part_class_ids));
    END IF;

    -- delete building
    DELETE FROM
      building
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * CITY FURNITURE
  *******************/
  FUNCTION delete_city_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_ids4 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        city_furniture t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete city_furnitures
    DELETE FROM
      city_furniture t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3,
      implicit_geometry_ids4;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids4;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        city_furniture n1
        ON n1.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n2
        ON n2.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n3
        ON n3.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n4
        ON n4.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod1_implicit_rep_id IS NULL
        AND n2.lod2_implicit_rep_id IS NULL
        AND n3.lod3_implicit_rep_id IS NULL
        AND n4.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_city_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        city_furniture
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete city_furniture
    DELETE FROM
      city_furniture
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        city_furniture n1
        ON n1.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n2
        ON n2.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n3
        ON n3.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n4
        ON n4.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod1_implicit_rep_id IS NULL
        AND n2.lod2_implicit_rep_id IS NULL
        AND n3.lod3_implicit_rep_id IS NULL
        AND n4.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /********************
  * CITYOBJECT GROUP
  ********************/
  FUNCTION delete_cityobjectgroup(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        cityobjectgroup t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete cityobjectgroups
    DELETE FROM
      cityobjectgroup t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_cityobjectgroup(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        cityobjectgroup
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete cityobjectgroup
    DELETE FROM
      cityobjectgroup
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /**********************
  * GENERIC CITYOBJECT
  **********************/
  FUNCTION delete_generic_cityobject(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_ids4 ID_ARRAY;
    implicit_geometry_ids5 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        generic_cityobject t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete generic_cityobjects
    DELETE FROM
      generic_cityobject t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod0_implicit_rep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3,
      implicit_geometry_ids4,
      implicit_geometry_ids5;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids4;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids5;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        generic_cityobject n1
        ON n1.lod0_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n2
        ON n2.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n3
        ON n3.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n4
        ON n4.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n5
        ON n5.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod0_implicit_rep_id IS NULL
        AND n2.lod1_implicit_rep_id IS NULL
        AND n3.lod2_implicit_rep_id IS NULL
        AND n4.lod3_implicit_rep_id IS NULL
        AND n5.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_generic_cityobject(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        generic_cityobject
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete generic_cityobject
    DELETE FROM
      generic_cityobject
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod0_implicit_rep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        generic_cityobject n1
        ON n1.lod0_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n2
        ON n2.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n3
        ON n3.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n4
        ON n4.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n5
        ON n5.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod0_implicit_rep_id IS NULL
        AND n2.lod1_implicit_rep_id IS NULL
        AND n3.lod2_implicit_rep_id IS NULL
        AND n4.lod3_implicit_rep_id IS NULL
        AND n5.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * LAND USE
  *******************/
  FUNCTION delete_land_use(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        land_use t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete land_uses
    DELETE FROM
      land_use t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_land_use(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        land_use
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete land_use
    DELETE FROM
      land_use
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * RELIEF
  *******************/
  /*
  RELIEF COMPONENT INTERNALS
  */
  FUNCTION delete_relief_component_post(pids ID_ARRAY, objclass_ids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    class_ids := objclass_ids;

    -- delete relief_components
    DELETE FROM
      relief_component t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_relief_component_post(pid NUMBER, objclass_id NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    class_id := objclass_id;

    -- delete relief_component
    DELETE FROM
      relief_component
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  BREAKLINE RELIEF
  */
  FUNCTION delete_breakline_relief(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        breakline_relief t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete breakline_reliefs
    DELETE FROM
      breakline_relief t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete relief_components
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_relief_component_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_breakline_relief(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        breakline_relief
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete breakline_relief
    DELETE FROM
      breakline_relief
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete relief_component
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_relief_component_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  MASSPOINT RELIEF
  */
  FUNCTION delete_masspoint_relief(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        masspoint_relief t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete masspoint_reliefs
    DELETE FROM
      masspoint_relief t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete relief_components
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_relief_component_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_masspoint_relief(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        masspoint_relief
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete masspoint_relief
    DELETE FROM
      masspoint_relief
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete relief_component
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_relief_component_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TIN RELIEF
  */
  FUNCTION delete_tin_relief(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tin_relief t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tin_reliefs
    DELETE FROM
      tin_relief t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete relief_components
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_relief_component_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tin_relief(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tin_relief
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tin_relief
    DELETE FROM
      tin_relief
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete relief_component
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_relief_component_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  RELIEF COMPONENT ROUTER
  */
  FUNCTION delete_relief_component(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        relief_component t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete breakline_reliefs
    IF class_ids MULTISET INTERSECT ID_ARRAY(18) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_breakline_relief(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete masspoint_reliefs
    IF class_ids MULTISET INTERSECT ID_ARRAY(17) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_masspoint_relief(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete raster_reliefs
    IF class_ids MULTISET INTERSECT ID_ARRAY(19) IS NOT EMPTY THEN
      deleted_ids := NULL;
    END IF;

    -- delete tin_reliefs
    IF class_ids MULTISET INTERSECT ID_ARRAY(16) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tin_relief(pids, class_ids), ID_ARRAY());
    END IF;

    IF pids.count <> deleted_ids.count THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_relief_component_post(pids, class_ids), ID_ARRAY());
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_relief_component(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        relief_component
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete breakline_relief
    IF class_id IN (18) THEN
      deleted_id := delete_breakline_relief(pid, class_id);
    END IF;

    -- delete masspoint_relief
    IF class_id IN (17) THEN
      deleted_id := delete_masspoint_relief(pid, class_id);
    END IF;

    -- delete raster_relief
    IF class_id IN (19) THEN
      deleted_id := NULL;
    END IF;

    -- delete tin_relief
    IF class_id IN (16) THEN
      deleted_id := delete_tin_relief(pid, class_id);
    END IF;

    IF deleted_id IS NULL THEN
      deleted_id := delete_relief_component_post(pid, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  RELIEF FEATURE
  */
  FUNCTION delete_relief_feature(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    relief_component_ids ID_ARRAY;
    relief_component_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        relief_feature t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to relief_components
    DELETE FROM
      relief_feat_to_rel_comp t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.relief_feature_id
    )
    RETURNING
      relief_component_id
    BULK COLLECT INTO
      relief_component_ids;

    -- delete relief_component(s) not being referenced any more
    IF relief_component_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        relief_component_pids
      FROM
        TABLE(relief_component_ids) a
      LEFT JOIN
        relief_feat_to_rel_comp n1
        ON n1.relief_component_id = a.COLUMN_VALUE
      WHERE
        n1.relief_component_id IS NULL;

      IF relief_component_pids IS NOT EMPTY THEN
        dummy_ids := delete_relief_component(relief_component_pids);
      END IF;
    END IF;

    -- delete relief_features
    DELETE FROM
      relief_feature t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_relief_feature(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    relief_component_ids ID_ARRAY;
    relief_component_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        relief_feature
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to relief_components
    DELETE FROM
      relief_feat_to_rel_comp
    WHERE
      relief_feature_id = pid
    RETURNING
      relief_component_id
    BULK COLLECT INTO
      relief_component_ids;

    -- delete relief_component(s) not being referenced any more
    IF relief_component_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        relief_component_pids
      FROM
        TABLE(relief_component_ids) a
      LEFT JOIN
        relief_feat_to_rel_comp n1
        ON n1.relief_component_id = a.COLUMN_VALUE
      WHERE
        n1.relief_component_id IS NULL;

      IF relief_component_pids IS NOT EMPTY THEN
        dummy_ids := delete_relief_component(relief_component_pids);
      END IF;
    END IF;

    -- delete relief_feature
    DELETE FROM
      relief_feature
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * TRANSPORTATION
  *******************/
  /*
  TRAFFIC AREA
  */
  FUNCTION delete_traffic_area(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        traffic_area t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete traffic_areas
    DELETE FROM
      traffic_area t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_traffic_area(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        traffic_area
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete traffic_area
    DELETE FROM
      traffic_area
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TRANSPORTATION COMPLEX
  */
  FUNCTION delete_transport_complex(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        transportation_complex t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete traffic_areas
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      traffic_area t,
      TABLE(pids) a
    WHERE
      t.transportation_complex_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_traffic_area(child_ids, SET(child_class_ids));
    END IF;

    -- delete transportation_complexes
    DELETE FROM
      transportation_complex t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_transport_complex(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        transportation_complex
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete traffic_areas
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      traffic_area
    WHERE
      transportation_complex_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_traffic_area(child_ids, SET(child_class_ids));
    END IF;

    -- delete transportation_complex
    DELETE FROM
      transportation_complex
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * TUNNEL
  *******************/
  /*
  TUNNEL FRUNITURE
  */
  FUNCTION delete_tunnel_furniture(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tunnel_furniture t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_furnitures
    DELETE FROM
      tunnel_furniture t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        tunnel_furniture n1
        ON n1.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tunnel_furniture(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ref_id NUMBER;
    implicit_geometry_pid NUMBER;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tunnel_furniture
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_furniture
    DELETE FROM
      tunnel_furniture
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      lod4_implicit_rep_id
    INTO
      deleted_id,
      implicit_geometry_ref_id;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ref_id IS NOT NULL THEN
      SELECT
        a.COLUMN_VALUE
      INTO
        implicit_geometry_pid
      FROM
        TABLE(ID_ARRAY(implicit_geometry_ref_id)) a
      LEFT JOIN
        tunnel_furniture n1
        ON n1.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pid IS NOT NULL THEN
        dummy_id := delete_implicit_geometry(implicit_geometry_pid);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TUNNEL OPENING
  */
  FUNCTION delete_tunnel_opening(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tunnel_opening t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_openings
    DELETE FROM
      tunnel_opening t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        tunnel_opening n1
        ON n1.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n2
        ON n2.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod3_implicit_rep_id IS NULL
        AND n2.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tunnel_opening(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tunnel_opening
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_opening
    DELETE FROM
      tunnel_opening
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        tunnel_opening n1
        ON n1.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n2
        ON n2.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod3_implicit_rep_id IS NULL
        AND n2.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TUNNEL THEMATIC SURFACE
  */
  FUNCTION delete_tunnel_them_srf(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    tunnel_opening_ids ID_ARRAY;
    tunnel_opening_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tunnel_thematic_surface t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to tunnel_openings
    DELETE FROM
      tunnel_open_to_them_srf t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.tunnel_thematic_surface_id
    )
    RETURNING
      tunnel_opening_id
    BULK COLLECT INTO
      tunnel_opening_ids;

    -- delete tunnel_opening(s) not being referenced any more
    IF tunnel_opening_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        tunnel_opening_pids
      FROM
        TABLE(tunnel_opening_ids) a
      LEFT JOIN
        tunnel_open_to_them_srf n1
        ON n1.tunnel_opening_id = a.COLUMN_VALUE
      WHERE
        n1.tunnel_opening_id IS NULL;

      IF tunnel_opening_pids IS NOT EMPTY THEN
        dummy_ids := delete_tunnel_opening(tunnel_opening_pids);
      END IF;
    END IF;

    -- delete tunnel_thematic_surfaces
    DELETE FROM
      tunnel_thematic_surface t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tunnel_them_srf(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    tunnel_opening_ids ID_ARRAY;
    tunnel_opening_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tunnel_thematic_surface
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to tunnel_openings
    DELETE FROM
      tunnel_open_to_them_srf
    WHERE
      tunnel_thematic_surface_id = pid
    RETURNING
      tunnel_opening_id
    BULK COLLECT INTO
      tunnel_opening_ids;

    -- delete tunnel_opening(s) not being referenced any more
    IF tunnel_opening_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        tunnel_opening_pids
      FROM
        TABLE(tunnel_opening_ids) a
      LEFT JOIN
        tunnel_open_to_them_srf n1
        ON n1.tunnel_opening_id = a.COLUMN_VALUE
      WHERE
        n1.tunnel_opening_id IS NULL;

      IF tunnel_opening_pids IS NOT EMPTY THEN
        dummy_ids := delete_tunnel_opening(tunnel_opening_pids);
      END IF;
    END IF;

    -- delete tunnel_thematic_surface
    DELETE FROM
      tunnel_thematic_surface
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TUNNEL INSTALLATION
  */
  FUNCTION delete_tunnel_installation(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tunnel_installation t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.tunnel_installation_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_installations
    DELETE FROM
      tunnel_installation t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        tunnel_installation n1
        ON n1.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n2
        ON n2.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n3
        ON n3.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod2_implicit_rep_id IS NULL
        AND n2.lod3_implicit_rep_id IS NULL
        AND n3.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tunnel_installation(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tunnel_installation
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_thematic_surface
    WHERE
      tunnel_installation_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_installation
    DELETE FROM
      tunnel_installation
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        tunnel_installation n1
        ON n1.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n2
        ON n2.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n3
        ON n3.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod2_implicit_rep_id IS NULL
        AND n2.lod3_implicit_rep_id IS NULL
        AND n3.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TUNNEL HOLLOW SPACE
  */
  FUNCTION delete_tunnel_hollow_space(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tunnel_hollow_space t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_furnitures
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_furniture t,
      TABLE(pids) a
    WHERE
      t.tunnel_hollow_space_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_furniture(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_installations
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_installation t,
      TABLE(pids) a
    WHERE
      t.tunnel_hollow_space_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.tunnel_hollow_space_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_hollow_spaces
    DELETE FROM
      tunnel_hollow_space t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tunnel_hollow_space(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tunnel_hollow_space
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_furnitures
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_furniture
    WHERE
      tunnel_hollow_space_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_furniture(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_installations
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_installation
    WHERE
      tunnel_hollow_space_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_thematic_surface
    WHERE
      tunnel_hollow_space_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_hollow_space
    DELETE FROM
      tunnel_hollow_space
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  TUNNEL
  */
  FUNCTION delete_tunnel(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    part_ids ID_ARRAY;
    part_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        tunnel t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_hollow_spaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_hollow_space t,
      TABLE(pids) a
    WHERE
      t.tunnel_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_hollow_space(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_installations
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_installation t,
      TABLE(pids) a
    WHERE
      t.tunnel_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_thematic_surfaces
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.tunnel_id = a.COLUMN_VALUE;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete referenced parts
    SELECT
      t.id,
      t.objectclass_id
    BULK COLLECT INTO
      part_ids,
      part_class_ids
    FROM
      tunnel t,
      TABLE(pids) a
    WHERE
      t.tunnel_parent_id = a.COLUMN_VALUE
      AND t.id != a.COLUMN_VALUE;

    IF part_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel(part_ids, SET(part_class_ids));
    END IF;

    -- delete tunnels
    DELETE FROM
      tunnel t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_tunnel(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    child_ids ID_ARRAY;
    child_class_ids ID_ARRAY;
    part_ids ID_ARRAY;
    part_class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        tunnel
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete tunnel_hollow_spaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_hollow_space
    WHERE
      tunnel_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_hollow_space(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_installations
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_installation
    WHERE
      tunnel_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_installation(child_ids, SET(child_class_ids));
    END IF;

    -- delete tunnel_thematic_surfaces
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      child_ids,
      child_class_ids
    FROM
      tunnel_thematic_surface
    WHERE
      tunnel_id = pid;

    IF child_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel_them_srf(child_ids, SET(child_class_ids));
    END IF;

    -- delete referenced parts
    SELECT
      id,
      objectclass_id
    BULK COLLECT INTO
      part_ids,
      part_class_ids
    FROM
      tunnel
    WHERE
      tunnel_parent_id = pid
      AND id != pid;

    IF part_ids IS NOT EMPTY THEN
      dummy_ids := delete_tunnel(part_ids, SET(part_class_ids));
    END IF;

    -- delete tunnel
    DELETE FROM
      tunnel
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * VEGETATION
  *******************/
  /*
  PLANT COVER
  */
  FUNCTION delete_plant_cover(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        plant_cover t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete plant_covers
    DELETE FROM
      plant_cover t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_plant_cover(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        plant_cover
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete plant_cover
    DELETE FROM
      plant_cover
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  SOLITARY VEGETATION OBJECT
  */
  FUNCTION delete_solitary_veg_obj(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    implicit_geometry_ids ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids1 ID_ARRAY;
    implicit_geometry_ids2 ID_ARRAY;
    implicit_geometry_ids3 ID_ARRAY;
    implicit_geometry_ids4 ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        solitary_vegetat_object t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete solitary_vegetat_objects
    DELETE FROM
      solitary_vegetat_object t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      implicit_geometry_ids1,
      implicit_geometry_ids2,
      implicit_geometry_ids3,
      implicit_geometry_ids4;

    -- collect all implicit_geo ids into one nested table
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids1;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids2;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids3;
    implicit_geometry_ids := implicit_geometry_ids MULTISET UNION ALL implicit_geometry_ids4;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        solitary_vegetat_object n1
        ON n1.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n2
        ON n2.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n3
        ON n3.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n4
        ON n4.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod1_implicit_rep_id IS NULL
        AND n2.lod2_implicit_rep_id IS NULL
        AND n3.lod3_implicit_rep_id IS NULL
        AND n4.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_solitary_veg_obj(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    implicit_geometry_ids ID_ARRAY;
    implicit_geometry_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        solitary_vegetat_object
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete solitary_vegetat_object
    DELETE FROM
      solitary_vegetat_object
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id,
      ID_ARRAY(
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
      )
    INTO
      deleted_id,
      implicit_geometry_ids;

    -- delete implicit_geometry not being referenced any more
    IF implicit_geometry_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        implicit_geometry_pids
      FROM
        TABLE(implicit_geometry_ids) a
      LEFT JOIN
        solitary_vegetat_object n1
        ON n1.lod1_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n2
        ON n2.lod2_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n3
        ON n3.lod3_implicit_rep_id = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n4
        ON n4.lod4_implicit_rep_id = a.COLUMN_VALUE
      WHERE
        n1.lod1_implicit_rep_id IS NULL
        AND n2.lod2_implicit_rep_id IS NULL
        AND n3.lod3_implicit_rep_id IS NULL
        AND n4.lod4_implicit_rep_id IS NULL;

      IF implicit_geometry_pids IS NOT EMPTY THEN
        dummy_ids := delete_implicit_geometry(implicit_geometry_pids);
      END IF;
    END IF;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*******************
  * WATER BODY
  *******************/
  /*
  WATER BOUNDARY SURFACE
  */
  FUNCTION delete_waterbnd_surface(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        waterboundary_surface t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete waterboundary_surfaces
    DELETE FROM
      waterboundary_surface t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_waterbnd_surface(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        waterboundary_surface
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete waterboundary_surface
    DELETE FROM
      waterboundary_surface
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*
  WATER BODY
  */
  FUNCTION delete_waterbody(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
    waterboundary_srf_ids ID_ARRAY;
    waterboundary_srf_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        waterbody t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to waterboundary_surfaces
    DELETE FROM
      waterbod_to_waterbnd_srf t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.waterbody_id
    )
    RETURNING
      waterboundary_surface_id
    BULK COLLECT INTO
      waterboundary_srf_ids;

    -- delete waterboundary_surface(s) not being referenced any more
    IF waterboundary_srf_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        waterboundary_srf_pids
      FROM
        TABLE(waterboundary_srf_ids) a
      LEFT JOIN
        waterbod_to_waterbnd_srf n1
        ON n1.waterboundary_surface_id = a.COLUMN_VALUE
      WHERE
        n1.waterboundary_surface_id IS NULL;

      IF waterboundary_srf_pids IS NOT EMPTY THEN
        dummy_ids := delete_waterbnd_surface(waterboundary_srf_pids);
      END IF;
    END IF;

    -- delete waterbodys
    DELETE FROM
      waterbody t
    WHERE EXISTS (
      SELECT
        a.COLUMN_VALUE
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.id
      )
      AND t.objectclass_id MEMBER OF class_ids
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    -- delete cityobjects
    IF deleted_ids IS NOT EMPTY THEN
      dummy_ids := delete_cityobject_post(deleted_ids, class_ids);
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_waterbody(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
    waterboundary_srf_ids ID_ARRAY;
    waterboundary_srf_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
    dummy_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        waterbody
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete references to waterboundary_surfaces
    DELETE FROM
      waterbod_to_waterbnd_srf
    WHERE
      waterbody_id = pid
    RETURNING
      waterboundary_surface_id
    BULK COLLECT INTO
      waterboundary_srf_ids;

    -- delete waterboundary_surface(s) not being referenced any more
    IF waterboundary_srf_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        waterboundary_srf_pids
      FROM
        TABLE(waterboundary_srf_ids) a
      LEFT JOIN
        waterbod_to_waterbnd_srf n1
        ON n1.waterboundary_surface_id = a.COLUMN_VALUE
      WHERE
        n1.waterboundary_surface_id IS NULL;

      IF waterboundary_srf_pids IS NOT EMPTY THEN
        dummy_ids := delete_waterbnd_surface(waterboundary_srf_pids);
      END IF;
    END IF;

    -- delete waterbody
    DELETE FROM
      waterbody
    WHERE
      id = pid
      AND objectclass_id = class_id
    RETURNING
      id
    INTO
      deleted_id;

    -- delete cityobject
    IF deleted_id IS NOT NULL THEN
      dummy_id := delete_cityobject_post(deleted_id, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /*********************
  * CITYOBJECT ROUTER
  *********************/
  FUNCTION delete_cityobject(pids ID_ARRAY, objclass_ids ID_ARRAY := ID_ARRAY()) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    class_ids ID_ARRAY;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_ids IS EMPTY THEN
      SELECT
        DISTINCT t.objectclass_id
      BULK COLLECT INTO
        class_ids
      FROM
        cityobject t,
        TABLE(pids) a
      WHERE
        t.id = a.COLUMN_VALUE;
    ELSE
      class_ids := SET(objclass_ids);
    END IF;

    IF class_ids IS EMPTY THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridges
    IF class_ids MULTISET INTERSECT ID_ARRAY(62,63,64) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete bridge_constr_elements
    IF class_ids MULTISET INTERSECT ID_ARRAY(82) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge_constr_element(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete bridge_furnitures
    IF class_ids MULTISET INTERSECT ID_ARRAY(80) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge_furniture(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete bridge_installations
    IF class_ids MULTISET INTERSECT ID_ARRAY(65,66) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge_installation(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete bridge_openings
    IF class_ids MULTISET INTERSECT ID_ARRAY(77,78,79) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge_opening(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete bridge_rooms
    IF class_ids MULTISET INTERSECT ID_ARRAY(81) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge_room(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete bridge_thematic_surfaces
    IF class_ids MULTISET INTERSECT ID_ARRAY(67,68,69,70,71,72,73,74,75,76) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_bridge_them_srf(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete buildings
    IF class_ids MULTISET INTERSECT ID_ARRAY(24,25,26) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_building(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete building_furnitures
    IF class_ids MULTISET INTERSECT ID_ARRAY(40) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_building_furniture(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete building_installations
    IF class_ids MULTISET INTERSECT ID_ARRAY(27,28) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_building_installation(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete city_furnitures
    IF class_ids MULTISET INTERSECT ID_ARRAY(21) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_city_furniture(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete cityobjectgroups
    IF class_ids MULTISET INTERSECT ID_ARRAY(23) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_cityobjectgroup(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete generic_cityobjects
    IF class_ids MULTISET INTERSECT ID_ARRAY(5) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_generic_cityobject(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete land_uses
    IF class_ids MULTISET INTERSECT ID_ARRAY(4) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_land_use(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete openings
    IF class_ids MULTISET INTERSECT ID_ARRAY(37,38,39) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_opening(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete plant_covers
    IF class_ids MULTISET INTERSECT ID_ARRAY(8) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_plant_cover(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete relief_components
    IF class_ids MULTISET INTERSECT ID_ARRAY(15,16,17,18,19) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_relief_component(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete relief_features
    IF class_ids MULTISET INTERSECT ID_ARRAY(14) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_relief_feature(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete rooms
    IF class_ids MULTISET INTERSECT ID_ARRAY(41) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_room(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete solitary_vegetat_objects
    IF class_ids MULTISET INTERSECT ID_ARRAY(7) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_solitary_veg_obj(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete thematic_surfaces
    IF class_ids MULTISET INTERSECT ID_ARRAY(29,30,31,32,33,34,35,36,60,61) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_thematic_surface(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete traffic_areas
    IF class_ids MULTISET INTERSECT ID_ARRAY(47,48) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_traffic_area(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete transportation_complexes
    IF class_ids MULTISET INTERSECT ID_ARRAY(42,43,44,45,46) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_transport_complex(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete tunnels
    IF class_ids MULTISET INTERSECT ID_ARRAY(83,84,85) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tunnel(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete tunnel_furnitures
    IF class_ids MULTISET INTERSECT ID_ARRAY(101) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tunnel_furniture(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete tunnel_hollow_spaces
    IF class_ids MULTISET INTERSECT ID_ARRAY(102) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tunnel_hollow_space(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete tunnel_installations
    IF class_ids MULTISET INTERSECT ID_ARRAY(86,87) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tunnel_installation(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete tunnel_openings
    IF class_ids MULTISET INTERSECT ID_ARRAY(98,99,100) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tunnel_opening(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete tunnel_thematic_surfaces
    IF class_ids MULTISET INTERSECT ID_ARRAY(88,89,90,91,92,93,94,95,96,97) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_tunnel_them_srf(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete waterbodys
    IF class_ids MULTISET INTERSECT ID_ARRAY(9) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_waterbody(pids, class_ids), ID_ARRAY());
    END IF;

    -- delete waterboundary_surfaces
    IF class_ids MULTISET INTERSECT ID_ARRAY(10,11,12,13) IS NOT EMPTY THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_waterbnd_surface(pids, class_ids), ID_ARRAY());
    END IF;

    IF pids.count <> deleted_ids.count THEN
      deleted_ids := deleted_ids MULTISET UNION ALL COALESCE(delete_cityobject_post(pids, class_ids), ID_ARRAY());
    END IF;

    RETURN deleted_ids;
  END;

  FUNCTION delete_cityobject(pid NUMBER, objclass_id NUMBER := 0) RETURN NUMBER
  IS
    deleted_id NUMBER;
    class_id NUMBER;
  BEGIN
    -- fetch objectclass_id if not set
    IF objclass_id = 0 THEN
      SELECT
        objectclass_id
      INTO
        class_id
      FROM
        cityobject
      WHERE
        id = pid;
    ELSE
      class_id := objclass_id;
    END IF;

    IF class_id IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Objectclass_id unknown! Check OBJECTCLASS table.');
      RETURN NULL;
    END IF;

    -- delete bridge
    IF class_id IN (62,63,64) THEN
      deleted_id := delete_bridge(pid, class_id);
    END IF;

    -- delete bridge_constr_element
    IF class_id IN (82) THEN
      deleted_id := delete_bridge_constr_element(pid, class_id);
    END IF;

    -- delete bridge_furniture
    IF class_id IN (80) THEN
      deleted_id := delete_bridge_furniture(pid, class_id);
    END IF;

    -- delete bridge_installation
    IF class_id IN (65,66) THEN
      deleted_id := delete_bridge_installation(pid, class_id);
    END IF;

    -- delete bridge_opening
    IF class_id IN (77,78,79) THEN
      deleted_id := delete_bridge_opening(pid, class_id);
    END IF;

    -- delete bridge_room
    IF class_id IN (81) THEN
      deleted_id := delete_bridge_room(pid, class_id);
    END IF;

    -- delete bridge_thematic_surface
    IF class_id IN (67,68,69,70,71,72,73,74,75,76) THEN
      deleted_id := delete_bridge_them_srf(pid, class_id);
    END IF;

    -- delete building
    IF class_id IN (24,25,26) THEN
      deleted_id := delete_building(pid, class_id);
    END IF;

    -- delete building_furniture
    IF class_id IN (40) THEN
      deleted_id := delete_building_furniture(pid, class_id);
    END IF;

    -- delete building_installation
    IF class_id IN (27,28) THEN
      deleted_id := delete_building_installation(pid, class_id);
    END IF;

    -- delete city_furniture
    IF class_id IN (21) THEN
      deleted_id := delete_city_furniture(pid, class_id);
    END IF;

    -- delete cityobjectgroup
    IF class_id IN (23) THEN
      deleted_id := delete_cityobjectgroup(pid, class_id);
    END IF;

    -- delete generic_cityobject
    IF class_id IN (5) THEN
      deleted_id := delete_generic_cityobject(pid, class_id);
    END IF;

    -- delete land_use
    IF class_id IN (4) THEN
      deleted_id := delete_land_use(pid, class_id);
    END IF;

    -- delete opening
    IF class_id IN (37,38,39) THEN
      deleted_id := delete_opening(pid, class_id);
    END IF;

    -- delete plant_cover
    IF class_id IN (8) THEN
      deleted_id := delete_plant_cover(pid, class_id);
    END IF;

    -- delete relief_component
    IF class_id IN (15,16,17,18,19) THEN
      deleted_id := delete_relief_component(pid, class_id);
    END IF;

    -- delete relief_feature
    IF class_id IN (14) THEN
      deleted_id := delete_relief_feature(pid, class_id);
    END IF;

    -- delete room
    IF class_id IN (41) THEN
      deleted_id := delete_room(pid, class_id);
    END IF;

    -- delete solitary_vegetat_object
    IF class_id IN (7) THEN
      deleted_id := delete_solitary_veg_obj(pid, class_id);
    END IF;

    -- delete thematic_surface
    IF class_id IN (29,30,31,32,33,34,35,36,60,61) THEN
      deleted_id := delete_thematic_surface(pid, class_id);
    END IF;

    -- delete traffic_area
    IF class_id IN (47,48) THEN
      deleted_id := delete_traffic_area(pid, class_id);
    END IF;

    -- delete transportation_complex
    IF class_id IN (42,43,44,45,46) THEN
      deleted_id := delete_transport_complex(pid, class_id);
    END IF;

    -- delete tunnel
    IF class_id IN (83,84,85) THEN
      deleted_id := delete_tunnel(pid, class_id);
    END IF;

    -- delete tunnel_furniture
    IF class_id IN (101) THEN
      deleted_id := delete_tunnel_furniture(pid, class_id);
    END IF;

    -- delete tunnel_hollow_space
    IF class_id IN (102) THEN
      deleted_id := delete_tunnel_hollow_space(pid, class_id);
    END IF;

    -- delete tunnel_installation
    IF class_id IN (86,87) THEN
      deleted_id := delete_tunnel_installation(pid, class_id);
    END IF;

    -- delete tunnel_opening
    IF class_id IN (98,99,100) THEN
      deleted_id := delete_tunnel_opening(pid, class_id);
    END IF;

    -- delete tunnel_thematic_surface
    IF class_id IN (88,89,90,91,92,93,94,95,96,97) THEN
      deleted_id := delete_tunnel_them_srf(pid, class_id);
    END IF;

    -- delete waterbody
    IF class_id IN (9) THEN
      deleted_id := delete_waterbody(pid, class_id);
    END IF;

    -- delete waterboundary_surface
    IF class_id IN (10,11,12,13) THEN
      deleted_id := delete_waterbnd_surface(pid, class_id);
    END IF;

    IF deleted_id IS NULL THEN
      deleted_id := delete_cityobject_post(pid, class_id);
    END IF;

    RETURN deleted_id;
  END;


  /****************************
  * CITY MODEL incl. MEMBERS
  ****************************/
  FUNCTION delete_citymodel_with_members(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    cityobject_ids ID_ARRAY;
    cityobject_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete references to cityobjects
    DELETE FROM
      cityobject_member
    WHERE
      citymodel_id = pid
    RETURNING
      cityobject_id
    BULK COLLECT INTO
      cityobject_ids;

    -- delete cityobject(s) not being referenced any more
    IF cityobject_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        cityobject_pids
      FROM
        TABLE(cityobject_ids) a
      LEFT JOIN
        cityobject_member n1
        ON n1.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        cityobjectgroup n2
        ON n2.parent_cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n3
        ON n3.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n4
        ON n4.generalizes_to_id = a.COLUMN_VALUE
      LEFT JOIN
        group_to_cityobject n5
        ON n5.cityobject_id = a.COLUMN_VALUE
      WHERE
        n1.cityobject_id IS NULL
        AND n2.parent_cityobject_id IS NULL
        AND n3.cityobject_id IS NULL
        AND n4.generalizes_to_id IS NULL
        AND n5.cityobject_id IS NULL;

      IF cityobject_pids IS NOT EMPTY THEN
        dummy_ids := delete_cityobject(cityobject_pids);
      END IF;
    END IF;

    -- delete citymodel
    RETURN delete_citymodel(pid);
  END;

  FUNCTION delete_citymodel_with_members(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY;
    cityobject_ids ID_ARRAY;
    cityobject_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete references to cityobjects
    DELETE FROM
      cityobject_member t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.citymodel_id
    )
    RETURNING
      cityobject_id
    BULK COLLECT INTO
      cityobject_ids;

    -- delete cityobject(s) not being referenced any more
    IF cityobject_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        cityobject_pids
      FROM
        TABLE(cityobject_ids) a
      LEFT JOIN
        cityobject_member n1
        ON n1.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        cityobjectgroup n2
        ON n2.parent_cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n3
        ON n3.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n4
        ON n4.generalizes_to_id = a.COLUMN_VALUE
      LEFT JOIN
        group_to_cityobject n5
        ON n5.cityobject_id = a.COLUMN_VALUE
      WHERE
        n1.cityobject_id IS NULL
        AND n2.parent_cityobject_id IS NULL
        AND n3.cityobject_id IS NULL
        AND n4.generalizes_to_id IS NULL
        AND n5.cityobject_id IS NULL;

      IF cityobject_pids IS NOT EMPTY THEN
        dummy_ids := delete_cityobject(cityobject_pids);
      END IF;
    END IF;

    -- delete citymodels
    RETURN delete_citymodel(pids);
  END;


  /***********************************
  * CITY OBJECT GROUP incl. MEMBERS
  ***********************************/
  FUNCTION delete_group_with_members(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    cityobject_ids ID_ARRAY;
    cityobject_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete references to cityobjects
    DELETE FROM
      group_to_cityobject
    WHERE
      cityobjectgroup_id = pid
    RETURNING
      cityobject_id
    BULK COLLECT INTO
      cityobject_ids;

    -- delete cityobject(s) not being referenced any more
    IF cityobject_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        cityobject_pids
      FROM
        TABLE(cityobject_ids) a
      LEFT JOIN
        group_to_cityobject n1
        ON n1.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        cityobjectgroup n2
        ON n2.parent_cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        cityobject_member n3
        ON n3.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n4
        ON n4.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n5
        ON n5.generalizes_to_id = a.COLUMN_VALUE
      WHERE
        n1.cityobject_id IS NULL
        AND n2.parent_cityobject_id IS NULL
        AND n3.cityobject_id IS NULL
        AND n4.cityobject_id IS NULL
        AND n5.generalizes_to_id IS NULL;

      IF cityobject_pids IS NOT EMPTY THEN
        dummy_ids := delete_cityobject(cityobject_pids);
      END IF;
    END IF;

    -- delete cityobjectgroup
    RETURN delete_cityobjectgroup(pid);
  END;

  FUNCTION delete_group_with_members(pids ID_ARRAY) RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY;
    cityobject_ids ID_ARRAY;
    cityobject_pids ID_ARRAY;
    dummy_ids ID_ARRAY;
  BEGIN
    -- delete references to cityobjects
    DELETE FROM
      group_to_cityobject t
    WHERE EXISTS (
      SELECT
        1
      FROM
        TABLE(pids) a
      WHERE
        a.COLUMN_VALUE = t.cityobjectgroup_id
    )
    RETURNING
      cityobject_id
    BULK COLLECT INTO
      cityobject_ids;

    -- delete cityobject(s) not being referenced any more
    IF cityobject_ids IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        cityobject_pids
      FROM
        TABLE(cityobject_ids) a
      LEFT JOIN
        group_to_cityobject n1
        ON n1.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        cityobjectgroup n2
        ON n2.parent_cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        cityobject_member n3
        ON n3.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n4
        ON n4.cityobject_id = a.COLUMN_VALUE
      LEFT JOIN
        generalization n5
        ON n5.generalizes_to_id = a.COLUMN_VALUE
      WHERE
        n1.cityobject_id IS NULL
        AND n2.parent_cityobject_id IS NULL
        AND n3.cityobject_id IS NULL
        AND n4.cityobject_id IS NULL
        AND n5.generalizes_to_id IS NULL;

      IF cityobject_pids IS NOT EMPTY THEN
        dummy_ids := delete_cityobject(cityobject_pids);
      END IF;
    END IF;

    -- delete cityobjectgroups
    RETURN delete_cityobjectgroup(pids);
  END;


  /*******************
  * CLEANUP
  *******************/
  -- truncates all tables and reset sequences
  PROCEDURE cleanup_schema
  IS
    dummy_str STRARRAY;
    seq_value NUMBER;
    dummy_id NUMBER;
  BEGIN
    -- disable spatial indexes
    dummy_str := citydb_idx.drop_spatial_indexes(USER);

    -- clear tables
    EXECUTE IMMEDIATE 'TRUNCATE TABLE address_to_building';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE address_to_bridge';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE address';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE opening_to_them_surface';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE opening';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE thematic_surface';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE building_installation';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE building_furniture';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE room';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE building';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_open_to_them_srf';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_opening';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_thematic_surface';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_constr_element';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_installation';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_furniture';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge_room';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bridge';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel_open_to_them_srf';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel_opening';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel_thematic_surface';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel_installation';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel_furniture';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel_hollow_space';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tunnel';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE city_furniture';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE cityobjectgroup';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE group_to_cityobject';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE generic_cityobject';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE land_use';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE breakline_relief';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE masspoint_relief';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tin_relief';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE relief_feat_to_rel_comp';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE relief_component';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE relief_feature';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE plant_cover';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE solitary_vegetat_object';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE traffic_area';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE transportation_complex';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE waterbod_to_waterbnd_srf';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE waterboundary_surface';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE waterbody';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE textureparam';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE appear_to_surface_data';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE surface_data';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tex_image';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE appearance';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE implicit_geomtery';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE surface_geometry';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE cityobject_genericattrib';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE external_reference';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE generalization';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE cityobject_member';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE cityobject';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE citymodel';

    -- reset sequences
    SELECT address_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT address_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE address_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := address_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE address_seq INCREMENT BY 1';

    SELECT appearance_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT appearance_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE appearance_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := appearance_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE appearance_seq INCREMENT BY 1';

    SELECT citymodel_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT citymodel_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE citymodel_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := citymodel_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE citymodel_seq INCREMENT BY 1';

    SELECT cityobject_genericatt_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT cityobject_genericatt_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE cityobject_genericatt_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := cityobject_genericatt_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE cityobject_genericatt_seq INCREMENT BY 1';

    SELECT cityobject_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT cityobject_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE cityobject_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := cityobject_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE cityobject_seq INCREMENT BY 1';

    SELECT external_ref_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT external_ref_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE external_ref_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := external_ref_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE external_ref_seq INCREMENT BY 1';

    SELECT implicit_geometry_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT implicit_geometry_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE implicit_geometry_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := implicit_geometry_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE implicit_geometry_seq INCREMENT BY 1';

    SELECT surface_data_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT surface_data_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE surface_data_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := surface_data_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE surface_data_seq INCREMENT BY 1';

    SELECT surface_geometry_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT surface_geometry_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE surface_geometry_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := surface_geometry_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE surface_geometry_seq INCREMENT BY 1';

    SELECT tex_image_seq.nextval INTO seq_value FROM dual;
    IF (seq_value = 1) THEN
      SELECT tex_image_seq.nextval INTO seq_value FROM dual;
    END IF;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE tex_image_seq INCREMENT BY ' || (seq_value-1)*-1;
    dummy_id := tex_image_seq.nextval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE tex_image_seq INCREMENT BY 1';

    -- recreate spatial indexes
    dummy_str := citydb_idx.create_spatial_indexes(USER);
  END;


END citydb_delete;
/