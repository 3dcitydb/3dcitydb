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

-- Automatically generated database script (Creation Date: 2018-05-25 11:52:28)
-- cleanup_global_appearances
-- cleanup_schema
-- del_address
-- del_addresss
-- del_appearance
-- del_appearances
-- del_breakline_relief
-- del_breakline_reliefs
-- del_bridge
-- del_bridge_constr_element
-- del_bridge_constr_elements
-- del_bridge_furniture
-- del_bridge_furnitures
-- del_bridge_installation
-- del_bridge_installations
-- del_bridge_opening
-- del_bridge_openings
-- del_bridge_room
-- del_bridge_rooms
-- del_bridge_thematic_surface
-- del_bridge_thematic_surfaces
-- del_bridges
-- del_building
-- del_building_furniture
-- del_building_furnitures
-- del_building_installation
-- del_building_installations
-- del_buildings
-- del_city_furniture
-- del_city_furnitures
-- del_citymodel
-- del_citymodels
-- del_cityobject
-- del_cityobject_genericattrib
-- del_cityobject_genericattribs
-- del_cityobjectgroup
-- del_cityobjectgroups
-- del_cityobjects
-- del_cityobjects_by_lineage
-- del_external_reference
-- del_external_references
-- del_generic_cityobject
-- del_generic_cityobjects
-- del_grid_coverage
-- del_grid_coverages
-- del_implicit_geometry
-- del_implicit_geometrys
-- del_land_use
-- del_land_uses
-- del_masspoint_relief
-- del_masspoint_reliefs
-- del_opening
-- del_openings
-- del_plant_cover
-- del_plant_covers
-- del_raster_relief
-- del_raster_reliefs
-- del_relief_component
-- del_relief_components
-- del_relief_feature
-- del_relief_features
-- del_room
-- del_rooms
-- del_solitary_vegetat_object
-- del_solitary_vegetat_objects
-- del_surface_data
-- del_surface_datas
-- del_surface_geometry
-- del_surface_geometrys
-- del_tex_image
-- del_tex_images
-- del_thematic_surface
-- del_thematic_surfaces
-- del_tin_relief
-- del_tin_reliefs
-- del_traffic_area
-- del_traffic_areas
-- del_transportation_complex
-- del_transportation_complexs
-- del_tunnel
-- del_tunnel_furniture
-- del_tunnel_furnitures
-- del_tunnel_hollow_space
-- del_tunnel_hollow_spaces
-- del_tunnel_installation
-- del_tunnel_installations
-- del_tunnel_opening
-- del_tunnel_openings
-- del_tunnel_thematic_surface
-- del_tunnel_thematic_surfaces
-- del_tunnels
-- del_waterbody
-- del_waterbodys
-- del_waterboundary_surface
-- del_waterboundary_surfaces

------------------------------------------
CREATE OR REPLACE PACKAGE citydb_delete
AS
  FUNCTION cleanup_global_appearances RETURN ID_ARRAY;
  PROCEDURE cleanup_schema;
  FUNCTION del_address(pid NUMBER) RETURN NUMBER;
  FUNCTION del_addresss(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_appearance(pid NUMBER) RETURN NUMBER;
  FUNCTION del_appearances(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_breakline_relief(pid NUMBER) RETURN NUMBER;
  FUNCTION del_breakline_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridge(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_constr_element(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_constr_elements(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridge_furniture(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridge_installation(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_installations(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridge_opening(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_openings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridge_room(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_rooms(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridge_thematic_surface(pid NUMBER) RETURN NUMBER;
  FUNCTION del_bridge_thematic_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_bridges(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_building(pid NUMBER) RETURN NUMBER;
  FUNCTION del_building_furniture(pid NUMBER) RETURN NUMBER;
  FUNCTION del_building_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_building_installation(pid NUMBER) RETURN NUMBER;
  FUNCTION del_building_installations(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_buildings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_city_furniture(pid NUMBER) RETURN NUMBER;
  FUNCTION del_city_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_citymodel(pid NUMBER) RETURN NUMBER;
  FUNCTION del_citymodels(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_cityobject(pid NUMBER) RETURN NUMBER;
  FUNCTION del_cityobject_genericattrib(pid NUMBER) RETURN NUMBER;
  FUNCTION del_cityobject_genericattribs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_cityobjectgroup(pid NUMBER) RETURN NUMBER;
  FUNCTION del_cityobjectgroups(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_cityobjects(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_cityobjects_by_lineage(lineage_value varchar2, objectclass_id int := 0) RETURN ID_ARRAY;
  FUNCTION del_external_reference(pid NUMBER) RETURN NUMBER;
  FUNCTION del_external_references(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_generic_cityobject(pid NUMBER) RETURN NUMBER;
  FUNCTION del_generic_cityobjects(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_grid_coverage(pid NUMBER) RETURN NUMBER;
  FUNCTION del_grid_coverages(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_implicit_geometry(pid NUMBER) RETURN NUMBER;
  FUNCTION del_implicit_geometrys(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_land_use(pid NUMBER) RETURN NUMBER;
  FUNCTION del_land_uses(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_masspoint_relief(pid NUMBER) RETURN NUMBER;
  FUNCTION del_masspoint_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_opening(pid NUMBER) RETURN NUMBER;
  FUNCTION del_openings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_plant_cover(pid NUMBER) RETURN NUMBER;
  FUNCTION del_plant_covers(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_raster_relief(pid NUMBER) RETURN NUMBER;
  FUNCTION del_raster_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_relief_component(pid NUMBER) RETURN NUMBER;
  FUNCTION del_relief_components(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_relief_feature(pid NUMBER) RETURN NUMBER;
  FUNCTION del_relief_features(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_room(pid NUMBER) RETURN NUMBER;
  FUNCTION del_rooms(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_solitary_vegetat_object(pid NUMBER) RETURN NUMBER;
  FUNCTION del_solitary_vegetat_objects(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_surface_data(pid NUMBER) RETURN NUMBER;
  FUNCTION del_surface_datas(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_surface_geometry(pid NUMBER) RETURN NUMBER;
  FUNCTION del_surface_geometrys(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tex_image(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tex_images(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_thematic_surface(pid NUMBER) RETURN NUMBER;
  FUNCTION del_thematic_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tin_relief(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tin_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_traffic_area(pid NUMBER) RETURN NUMBER;
  FUNCTION del_traffic_areas(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_transportation_complex(pid NUMBER) RETURN NUMBER;
  FUNCTION del_transportation_complexs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tunnel(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tunnel_furniture(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tunnel_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tunnel_hollow_space(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tunnel_hollow_spaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tunnel_installation(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tunnel_installations(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tunnel_opening(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tunnel_openings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tunnel_thematic_surface(pid NUMBER) RETURN NUMBER;
  FUNCTION del_tunnel_thematic_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_tunnels(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_waterbody(pid NUMBER) RETURN NUMBER;
  FUNCTION del_waterbodys(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
  FUNCTION del_waterboundary_surface(pid NUMBER) RETURN NUMBER;
  FUNCTION del_waterboundary_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY;
END citydb_delete;
/

------------------------------------------
CREATE OR REPLACE PACKAGE BODY citydb_delete
AS 
  FUNCTION cleanup_global_appearances RETURN ID_ARRAY
  IS
    deleted_ids ID_ARRAY := ID_ARRAY();
    surface_data_ids ID_ARRAY;
    appearance_ids ID_ARRAY;
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    SELECT
      s.id
    BULK COLLECT INTO
      surface_data_ids
    FROM
      surface_data s
    LEFT OUTER JOIN
      textureparam t 
      ON s.id=t.surface_data_id
    WHERE
      t.surface_data_id IS NULL;

    IF surface_data_ids IS NOT EMPTY THEN
      dummy_ids := del_surface_datas(surface_data_ids);
    END IF;

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

    IF appearance_ids IS NOT EMPTY THEN
      deleted_ids := del_appearances(appearance_ids);
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  PROCEDURE cleanup_schema
  IS
    dummy_str strarray;
    seq_value number;
  BEGIN

    dummy_str := citydb_idx.drop_spatial_indexes();

    for uc in (
      select constraint_name, table_name from user_constraints
    )
    LOOP
      execute immediate 'alter table '||uc.table_name||' disable constraint '||uc.constraint_name||'';
    END loop;

    for ut in (
      select table_name FROM user_tables
      WHERE table_name NOT IN ('DATABASE_SRS', 'OBJECTCLASS', 'INDEX_TABLE', 'ADE', 'SCHEMA', 'SCHEMA_TO_OBJECTCLASS', 'SCHEMA_REFERENCING', 'AGGREGATION_INFO')
      AND table_name NOT LIKE '%\_AUX' ESCAPE '\'
      AND table_name NOT LIKE '%TMP\_%' ESCAPE '\'
      AND table_name NOT LIKE '%MDRT%'
      AND table_name NOT LIKE '%MDXT%'
      AND table_name NOT LIKE '%MDNT%'
    )
    LOOP
      execute immediate 'truncate table '||ut.table_name||'';
    END loop;

    for uc in (
      select constraint_name, table_name from user_constraints
    )
    LOOP
      execute immediate 'alter table '||uc.table_name||' enable constraint '||uc.constraint_name||'';
    END loop;

    for us in (
      select sequence_name from user_sequences
      WHERE sequence_name NOT IN ('INDEX_TABLE_SEQ', 'ADE_SEQ', 'SCHEMA_SEQ')
      AND sequence_name NOT LIKE '%\_AUX' ESCAPE '\'
      AND sequence_name NOT LIKE '%TMP\_%' ESCAPE '\'
      AND sequence_name NOT LIKE '%MDRS%'
      AND sequence_name NOT LIKE '%MDXS%'
      AND sequence_name NOT LIKE '%MDNS%'
    )
    LOOP
      execute immediate 'select ' || us.sequence_name || '.nextval from dual' into seq_value;
      if (seq_value = 1) then
        execute immediate 'select ' || us.sequence_name || '.nextval from dual' into seq_value;
      end if;
      execute immediate 'alter sequence ' || us.sequence_name || ' increment by ' || (seq_value-1)*-1;
      execute immediate 'select ' || us.sequence_name || '.nextval from dual' into seq_value;
      execute immediate 'alter sequence ' || us.sequence_name || ' increment by 1';
    END LOOP;

    dummy_str := citydb_idx.create_spatial_indexes();

    EXCEPTION
      WHEN others THEN
        dbms_output.put_line('cleanup_schema: ' || SQLERRM);
  END;
  ------------------------------------------

  FUNCTION del_address(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_addresss(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_addresss(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete addresss
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_appearance(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_appearances(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_appearances(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_data_ids0 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete references to surface_datas
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
      surface_data_ids0;

    -- delete surface_data(s)
    IF surface_data_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(surface_data_ids0) a
      LEFT JOIN
        appear_to_surface_data n1
        ON n1.surface_data_id  = a.COLUMN_VALUE
      WHERE n1.surface_data_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_surface_datas(object_ids);
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_breakline_relief(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_breakline_reliefs(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_breakline_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    IF caller <> 1 THEN
      -- delete relief_component
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_relief_components(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridge(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridges(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_constr_element(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridge_constr_elements(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_constr_elements(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids8 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids9 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      implicit_geometry_ids6,
      implicit_geometry_ids7,
      implicit_geometry_ids8,
      implicit_geometry_ids9;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids7;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids8;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids9;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids5 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids5) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridge_furniture(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridge_furnitures(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids2 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids3 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod4_brep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      implicit_geometry_ids3;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids2 := implicit_geometry_ids2 MULTISET UNION ALL implicit_geometry_ids3;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids2 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids2) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridge_installation(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridge_installations(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_installations(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete bridge_thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_installation_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      implicit_geometry_ids5,
      implicit_geometry_ids6,
      implicit_geometry_ids7;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids5;
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids7;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids4 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids4) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridge_opening(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridge_openings(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_openings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    address_ids0 ID_ARRAY := ID_ARRAY();
    address_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      address_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      address_ids1,
      surface_geometry_ids3,
      surface_geometry_ids4,
      implicit_geometry_ids6,
      implicit_geometry_ids7;

    -- collect all addressids into one nested table
    address_ids0 := address_ids0 MULTISET UNION ALL address_ids1;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids2 := surface_geometry_ids2 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids2 := surface_geometry_ids2 MULTISET UNION ALL surface_geometry_ids4;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids7;

    -- delete address(s)
    IF address_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(address_ids0) a
      LEFT JOIN
        address_to_bridge n1
        ON n1.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        address_to_building n2
        ON n2.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n3
        ON n3.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n4
        ON n4.address_id  = a.COLUMN_VALUE
      WHERE n1.address_id IS NULL
        AND n2.address_id IS NULL
        AND n3.address_id IS NULL
        AND n4.address_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_addresss(object_ids);
      END IF;
    END IF;

    -- delete surface_geometry(s)
    IF surface_geometry_ids2 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids2);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids5 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids5) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridge_room(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridge_rooms(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_rooms(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete bridge_furnitures
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_furniture t,
      TABLE(pids) a
    WHERE
      t.bridge_room_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_furnitures(object_ids);
    END IF;

    --delete bridge_installations
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_installation t,
      TABLE(pids) a
    WHERE
      t.bridge_room_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_installations(object_ids);
    END IF;

    --delete bridge_thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_room_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod4_multi_surface_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridge_thematic_surface(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_bridge_thematic_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    bridge_opening_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
  BEGIN
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
      bridge_opening_ids0;

    -- delete bridge_opening(s)
    IF bridge_opening_ids0 IS NOT EMPTY THEN
      dummy_ids := del_bridge_openings(bridge_opening_ids0);
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
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids4;

    -- delete surface_geometry(s)
    IF surface_geometry_ids1 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids1);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_bridges(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    address_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids6 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids7 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids8 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids9 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge t,
      TABLE(pids) a
    WHERE
      t.bridge_parent_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridges(object_ids);
    END IF;

    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge t,
      TABLE(pids) a
    WHERE
      t.bridge_root_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridges(object_ids);
    END IF;

    -- delete references to addresss
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
      address_id
    BULK COLLECT INTO
      address_ids0;

    -- delete address(s)
    IF address_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(address_ids0) a
      LEFT JOIN
        address_to_bridge n1
        ON n1.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        address_to_building n2
        ON n2.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n3
        ON n3.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n4
        ON n4.address_id  = a.COLUMN_VALUE
      WHERE n1.address_id IS NULL
        AND n2.address_id IS NULL
        AND n3.address_id IS NULL
        AND n4.address_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_addresss(object_ids);
      END IF;
    END IF;

    --delete bridge_constr_elements
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_constr_element t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_constr_elements(object_ids);
    END IF;

    --delete bridge_installations
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_installation t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_installations(object_ids);
    END IF;

    --delete bridge_rooms
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_room t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_rooms(object_ids);
    END IF;

    --delete bridge_thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      bridge_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.bridge_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_bridge_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod1_multi_surface_id,
      lod1_solid_id,
      lod2_multi_surface_id,
      lod2_solid_id,
      lod3_multi_surface_id,
      lod3_solid_id,
      lod4_multi_surface_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5,
      surface_geometry_ids6,
      surface_geometry_ids7,
      surface_geometry_ids8,
      surface_geometry_ids9;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids5;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids6;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids7;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids8;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids9;

    -- delete surface_geometry(s)
    IF surface_geometry_ids1 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids1);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_building(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_buildings(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_building_furniture(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_building_furnitures(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_building_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids2 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids3 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod4_brep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      implicit_geometry_ids3;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids2 := implicit_geometry_ids2 MULTISET UNION ALL implicit_geometry_ids3;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids2 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids2) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_building_installation(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_building_installations(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_building_installations(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      thematic_surface t,
      TABLE(pids) a
    WHERE
      t.building_installation_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      implicit_geometry_ids5,
      implicit_geometry_ids6,
      implicit_geometry_ids7;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids5;
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids7;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids4 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids4) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_buildings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    address_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids6 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids7 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids8 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids9 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids10 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids11 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      building t,
      TABLE(pids) a
    WHERE
      t.building_parent_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_buildings(object_ids);
    END IF;

    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      building t,
      TABLE(pids) a
    WHERE
      t.building_root_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_buildings(object_ids);
    END IF;

    -- delete references to addresss
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
      address_id
    BULK COLLECT INTO
      address_ids0;

    -- delete address(s)
    IF address_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(address_ids0) a
      LEFT JOIN
        address_to_bridge n1
        ON n1.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        address_to_building n2
        ON n2.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n3
        ON n3.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n4
        ON n4.address_id  = a.COLUMN_VALUE
      WHERE n1.address_id IS NULL
        AND n2.address_id IS NULL
        AND n3.address_id IS NULL
        AND n4.address_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_addresss(object_ids);
      END IF;
    END IF;

    --delete building_installations
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      building_installation t,
      TABLE(pids) a
    WHERE
      t.building_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_building_installations(object_ids);
    END IF;

    --delete rooms
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      room t,
      TABLE(pids) a
    WHERE
      t.building_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_rooms(object_ids);
    END IF;

    --delete thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      thematic_surface t,
      TABLE(pids) a
    WHERE
      t.building_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod0_footprint_id,
      lod0_roofprint_id,
      lod1_multi_surface_id,
      lod1_solid_id,
      lod2_multi_surface_id,
      lod2_solid_id,
      lod3_multi_surface_id,
      lod3_solid_id,
      lod4_multi_surface_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5,
      surface_geometry_ids6,
      surface_geometry_ids7,
      surface_geometry_ids8,
      surface_geometry_ids9,
      surface_geometry_ids10,
      surface_geometry_ids11;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids5;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids6;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids7;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids8;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids9;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids10;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids11;

    -- delete surface_geometry(s)
    IF surface_geometry_ids1 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids1);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_city_furniture(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_city_furnitures(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_city_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids8 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids9 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      implicit_geometry_ids6,
      implicit_geometry_ids7,
      implicit_geometry_ids8,
      implicit_geometry_ids9;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids7;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids8;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids9;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids5 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids5) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_citymodel(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_citymodels(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_citymodels(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    cityobject_ids0 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete appearances
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      appearance t,
      TABLE(pids) a
    WHERE
      t.citymodel_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_appearances(object_ids);
    END IF;

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
      cityobject_ids0;

    -- delete cityobject(s)
    IF cityobject_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(cityobject_ids0) a
      LEFT JOIN
        cityobjectgroup n1
        ON n1.parent_cityobject_id  = a.COLUMN_VALUE
      LEFT JOIN
        cityobject_member n2
        ON n2.cityobject_id  = a.COLUMN_VALUE
      LEFT JOIN
        group_to_cityobject n3
        ON n3.cityobject_id  = a.COLUMN_VALUE
      WHERE n1.parent_cityobject_id IS NULL
        AND n2.cityobject_id IS NULL
        AND n3.cityobject_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(object_ids);
      END IF;
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_cityobject(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_cityobjects(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_cityobject_genericattrib(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_cityobject_genericattribs(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_cityobject_genericattribs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      cityobject_genericattrib t,
      TABLE(pids) a
    WHERE
      t.parent_genattrib_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_cityobject_genericattribs(object_ids);
    END IF;

    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      cityobject_genericattrib t,
      TABLE(pids) a
    WHERE
      t.root_genattrib_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_cityobject_genericattribs(object_ids);
    END IF;

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
      surface_geometry_ids1;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_cityobjectgroup(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_cityobjectgroups(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_cityobjectgroups(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    cityobject_ids0 ID_ARRAY := ID_ARRAY();
    cityobject_ids1 ID_ARRAY := ID_ARRAY();
    cityobject_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
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
      cityobject_ids0;

    -- delete cityobject(s)
    IF cityobject_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(cityobject_ids0) a
      LEFT JOIN
        cityobjectgroup n1
        ON n1.parent_cityobject_id  = a.COLUMN_VALUE
      LEFT JOIN
        cityobject_member n2
        ON n2.cityobject_id  = a.COLUMN_VALUE
      LEFT JOIN
        group_to_cityobject n3
        ON n3.cityobject_id  = a.COLUMN_VALUE
      WHERE n1.parent_cityobject_id IS NULL
        AND n2.cityobject_id IS NULL
        AND n3.cityobject_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(object_ids);
      END IF;
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
    RETURNING
      id,
      parent_cityobject_id,
      brep_id
    BULK COLLECT INTO
      deleted_ids,
      cityobject_ids2,
      surface_geometry_ids4;

    -- collect all cityobjectids into one nested table
    cityobject_ids1 := cityobject_ids1 MULTISET UNION ALL cityobject_ids2;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids3 := surface_geometry_ids3 MULTISET UNION ALL surface_geometry_ids4;

    -- delete cityobject(s)
    IF cityobject_ids1 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(cityobject_ids1) a
      LEFT JOIN
        cityobjectgroup n1
        ON n1.parent_cityobject_id  = a.COLUMN_VALUE
      LEFT JOIN
        cityobject_member n2
        ON n2.cityobject_id  = a.COLUMN_VALUE
      LEFT JOIN
        group_to_cityobject n3
        ON n3.cityobject_id  = a.COLUMN_VALUE
      WHERE n1.parent_cityobject_id IS NULL
        AND n2.cityobject_id IS NULL
        AND n3.cityobject_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(object_ids);
      END IF;
    END IF;

    -- delete surface_geometry(s)
    IF surface_geometry_ids3 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids3);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_cityobjects(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete appearances
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      appearance t,
      TABLE(pids) a
    WHERE
      t.cityobject_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_appearances(object_ids);
    END IF;

    --delete cityobject_genericattribs
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      cityobject_genericattrib t,
      TABLE(pids) a
    WHERE
      t.cityobject_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_cityobject_genericattribs(object_ids);
    END IF;

    --delete external_references
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      external_reference t,
      TABLE(pids) a
    WHERE
      t.cityobject_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_external_references(object_ids);
    END IF;

    IF caller <> 2 THEN
      FOR i in 1..pids.count
      LOOP
        object_id := pids(i);
        EXECUTE IMMEDIATE 'SELECT objectclass_id FROM cityobject WHERE id = :1' INTO objectclass_id USING object_id;

          -- delete land_use
          IF objectclass_id = 4 THEN
            dummy_ids := del_land_uses(ID_ARRAY(object_id), 1);
          END IF;

          -- delete generic_cityobject
          IF objectclass_id = 5 THEN
            dummy_ids := del_generic_cityobjects(ID_ARRAY(object_id), 1);
          END IF;

          -- delete solitary_vegetat_object
          IF objectclass_id = 7 THEN
            dummy_ids := del_solitary_vegetat_objects(ID_ARRAY(object_id), 1);
          END IF;

          -- delete plant_cover
          IF objectclass_id = 8 THEN
            dummy_ids := del_plant_covers(ID_ARRAY(object_id), 1);
          END IF;

          -- delete waterbody
          IF objectclass_id = 9 THEN
            dummy_ids := del_waterbodys(ID_ARRAY(object_id), 1);
          END IF;

          -- delete waterboundary_surface
          IF objectclass_id = 10 THEN
            dummy_ids := del_waterboundary_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete waterboundary_surface
          IF objectclass_id = 11 THEN
            dummy_ids := del_waterboundary_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete waterboundary_surface
          IF objectclass_id = 12 THEN
            dummy_ids := del_waterboundary_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete waterboundary_surface
          IF objectclass_id = 13 THEN
            dummy_ids := del_waterboundary_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete relief_feature
          IF objectclass_id = 14 THEN
            dummy_ids := del_relief_features(ID_ARRAY(object_id), 1);
          END IF;

          -- delete relief_component
          IF objectclass_id = 15 THEN
            dummy_ids := del_relief_components(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tin_relief
          IF objectclass_id = 16 THEN
            dummy_ids := del_tin_reliefs(ID_ARRAY(object_id), 0);
          END IF;

          -- delete masspoint_relief
          IF objectclass_id = 17 THEN
            dummy_ids := del_masspoint_reliefs(ID_ARRAY(object_id), 0);
          END IF;

          -- delete breakline_relief
          IF objectclass_id = 18 THEN
            dummy_ids := del_breakline_reliefs(ID_ARRAY(object_id), 0);
          END IF;

          -- delete raster_relief
          IF objectclass_id = 19 THEN
            dummy_ids := del_raster_reliefs(ID_ARRAY(object_id), 0);
          END IF;

          -- delete city_furniture
          IF objectclass_id = 21 THEN
            dummy_ids := del_city_furnitures(ID_ARRAY(object_id), 1);
          END IF;

          -- delete cityobjectgroup
          IF objectclass_id = 23 THEN
            dummy_ids := del_cityobjectgroups(ID_ARRAY(object_id), 1);
          END IF;

          -- delete building
          IF objectclass_id = 24 THEN
            dummy_ids := del_buildings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete building
          IF objectclass_id = 25 THEN
            dummy_ids := del_buildings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete building
          IF objectclass_id = 26 THEN
            dummy_ids := del_buildings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete building_installation
          IF objectclass_id = 27 THEN
            dummy_ids := del_building_installations(ID_ARRAY(object_id), 1);
          END IF;

          -- delete building_installation
          IF objectclass_id = 28 THEN
            dummy_ids := del_building_installations(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 29 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 30 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 31 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 32 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 33 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 34 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 35 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 36 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete opening
          IF objectclass_id = 37 THEN
            dummy_ids := del_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete opening
          IF objectclass_id = 38 THEN
            dummy_ids := del_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete opening
          IF objectclass_id = 39 THEN
            dummy_ids := del_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete building_furniture
          IF objectclass_id = 40 THEN
            dummy_ids := del_building_furnitures(ID_ARRAY(object_id), 1);
          END IF;

          -- delete room
          IF objectclass_id = 41 THEN
            dummy_ids := del_rooms(ID_ARRAY(object_id), 1);
          END IF;

          -- delete transportation_complex
          IF objectclass_id = 42 THEN
            dummy_ids := del_transportation_complexs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete transportation_complex
          IF objectclass_id = 43 THEN
            dummy_ids := del_transportation_complexs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete transportation_complex
          IF objectclass_id = 44 THEN
            dummy_ids := del_transportation_complexs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete transportation_complex
          IF objectclass_id = 45 THEN
            dummy_ids := del_transportation_complexs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete transportation_complex
          IF objectclass_id = 46 THEN
            dummy_ids := del_transportation_complexs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete traffic_area
          IF objectclass_id = 47 THEN
            dummy_ids := del_traffic_areas(ID_ARRAY(object_id), 1);
          END IF;

          -- delete traffic_area
          IF objectclass_id = 48 THEN
            dummy_ids := del_traffic_areas(ID_ARRAY(object_id), 1);
          END IF;

          -- delete appearance
          IF objectclass_id = 50 THEN
            dummy_ids := del_appearances(ID_ARRAY(object_id), 0);
          END IF;

          -- delete surface_data
          IF objectclass_id = 51 THEN
            dummy_ids := del_surface_datas(ID_ARRAY(object_id), 0);
          END IF;

          -- delete surface_data
          IF objectclass_id = 52 THEN
            dummy_ids := del_surface_datas(ID_ARRAY(object_id), 0);
          END IF;

          -- delete surface_data
          IF objectclass_id = 53 THEN
            dummy_ids := del_surface_datas(ID_ARRAY(object_id), 0);
          END IF;

          -- delete surface_data
          IF objectclass_id = 54 THEN
            dummy_ids := del_surface_datas(ID_ARRAY(object_id), 0);
          END IF;

          -- delete surface_data
          IF objectclass_id = 55 THEN
            dummy_ids := del_surface_datas(ID_ARRAY(object_id), 0);
          END IF;

          -- delete citymodel
          IF objectclass_id = 57 THEN
            dummy_ids := del_citymodels(ID_ARRAY(object_id), 0);
          END IF;

          -- delete address
          IF objectclass_id = 58 THEN
            dummy_ids := del_addresss(ID_ARRAY(object_id), 0);
          END IF;

          -- delete implicit_geometry
          IF objectclass_id = 59 THEN
            dummy_ids := del_implicit_geometrys(ID_ARRAY(object_id), 0);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 60 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete thematic_surface
          IF objectclass_id = 61 THEN
            dummy_ids := del_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge
          IF objectclass_id = 62 THEN
            dummy_ids := del_bridges(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge
          IF objectclass_id = 63 THEN
            dummy_ids := del_bridges(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge
          IF objectclass_id = 64 THEN
            dummy_ids := del_bridges(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_installation
          IF objectclass_id = 65 THEN
            dummy_ids := del_bridge_installations(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_installation
          IF objectclass_id = 66 THEN
            dummy_ids := del_bridge_installations(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 67 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 68 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 69 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 70 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 71 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 72 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 73 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 74 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 75 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_thematic_surface
          IF objectclass_id = 76 THEN
            dummy_ids := del_bridge_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_opening
          IF objectclass_id = 77 THEN
            dummy_ids := del_bridge_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_opening
          IF objectclass_id = 78 THEN
            dummy_ids := del_bridge_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_opening
          IF objectclass_id = 79 THEN
            dummy_ids := del_bridge_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_furniture
          IF objectclass_id = 80 THEN
            dummy_ids := del_bridge_furnitures(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_room
          IF objectclass_id = 81 THEN
            dummy_ids := del_bridge_rooms(ID_ARRAY(object_id), 1);
          END IF;

          -- delete bridge_constr_element
          IF objectclass_id = 82 THEN
            dummy_ids := del_bridge_constr_elements(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel
          IF objectclass_id = 83 THEN
            dummy_ids := del_tunnels(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel
          IF objectclass_id = 84 THEN
            dummy_ids := del_tunnels(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel
          IF objectclass_id = 85 THEN
            dummy_ids := del_tunnels(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_installation
          IF objectclass_id = 86 THEN
            dummy_ids := del_tunnel_installations(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_installation
          IF objectclass_id = 87 THEN
            dummy_ids := del_tunnel_installations(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 88 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 89 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 90 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 91 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 92 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 93 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 94 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 95 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 96 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_thematic_surface
          IF objectclass_id = 97 THEN
            dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_opening
          IF objectclass_id = 98 THEN
            dummy_ids := del_tunnel_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_opening
          IF objectclass_id = 99 THEN
            dummy_ids := del_tunnel_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_opening
          IF objectclass_id = 100 THEN
            dummy_ids := del_tunnel_openings(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_furniture
          IF objectclass_id = 101 THEN
            dummy_ids := del_tunnel_furnitures(ID_ARRAY(object_id), 1);
          END IF;

          -- delete tunnel_hollow_space
          IF objectclass_id = 102 THEN
            dummy_ids := del_tunnel_hollow_spaces(ID_ARRAY(object_id), 1);
          END IF;
      END LOOP;
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
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_cityobjects_by_lineage(lineage_value varchar2, objectclass_id int := 0) RETURN ID_ARRAY
  IS
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
  BEGIN
    IF objectclass_id = 0 THEN
      SELECT
        c.id
      BULK COLLECT INTO
        deleted_ids
      FROM
        cityobject c
      WHERE
        c.lineage = lineage_value;
    ELSE
      SELECT
        c.id
      BULK COLLECT INTO
        deleted_ids
      FROM
        cityobject c
      WHERE
        c.lineage = lineage_value AND c.objectclass_id = objectclass_id;
    END IF;

    IF deleted_ids IS NOT EMPTY THEN
      FOR i in 1..deleted_ids.count
      LOOP
        dummy_ids := del_cityobjects(ID_ARRAY(deleted_ids(i)), 1);
      END LOOP;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_external_reference(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_external_references(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_external_references(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_generic_cityobject(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_generic_cityobjects(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_generic_cityobjects(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids8 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids9 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids10 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids11 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod0_brep_id,
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod0_implicit_rep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5,
      implicit_geometry_ids7,
      implicit_geometry_ids8,
      implicit_geometry_ids9,
      implicit_geometry_ids10,
      implicit_geometry_ids11;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids5;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids6 := implicit_geometry_ids6 MULTISET UNION ALL implicit_geometry_ids7;
    implicit_geometry_ids6 := implicit_geometry_ids6 MULTISET UNION ALL implicit_geometry_ids8;
    implicit_geometry_ids6 := implicit_geometry_ids6 MULTISET UNION ALL implicit_geometry_ids9;
    implicit_geometry_ids6 := implicit_geometry_ids6 MULTISET UNION ALL implicit_geometry_ids10;
    implicit_geometry_ids6 := implicit_geometry_ids6 MULTISET UNION ALL implicit_geometry_ids11;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids6 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids6) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_grid_coverage(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_grid_coverages(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_grid_coverages(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete grid_coverages
    DELETE FROM
      grid_coverage t
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_implicit_geometry(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_implicit_geometrys(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_implicit_geometrys(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete implicit_geometrys
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
      surface_geometry_ids1;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_land_use(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_land_uses(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_land_uses(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod0_multi_surface_id,
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids5;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_masspoint_relief(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_masspoint_reliefs(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_masspoint_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    IF caller <> 1 THEN
      -- delete relief_component
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_relief_components(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_opening(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_openings(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_openings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    address_ids0 ID_ARRAY := ID_ARRAY();
    address_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      address_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      address_ids1,
      surface_geometry_ids3,
      surface_geometry_ids4,
      implicit_geometry_ids6,
      implicit_geometry_ids7;

    -- collect all addressids into one nested table
    address_ids0 := address_ids0 MULTISET UNION ALL address_ids1;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids2 := surface_geometry_ids2 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids2 := surface_geometry_ids2 MULTISET UNION ALL surface_geometry_ids4;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids7;

    -- delete address(s)
    IF address_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(address_ids0) a
      LEFT JOIN
        address_to_bridge n1
        ON n1.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        address_to_building n2
        ON n2.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n3
        ON n3.address_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n4
        ON n4.address_id  = a.COLUMN_VALUE
      WHERE n1.address_id IS NULL
        AND n2.address_id IS NULL
        AND n3.address_id IS NULL
        AND n4.address_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_addresss(object_ids);
      END IF;
    END IF;

    -- delete surface_geometry(s)
    IF surface_geometry_ids2 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids2);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids5 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids5) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_plant_cover(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_plant_covers(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_plant_covers(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids6 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids7 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids8 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod1_multi_solid_id,
      lod1_multi_surface_id,
      lod2_multi_solid_id,
      lod2_multi_surface_id,
      lod3_multi_solid_id,
      lod3_multi_surface_id,
      lod4_multi_solid_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5,
      surface_geometry_ids6,
      surface_geometry_ids7,
      surface_geometry_ids8;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids5;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids6;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids7;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids8;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_raster_relief(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_raster_reliefs(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_raster_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    grid_coverage_ids0 ID_ARRAY := ID_ARRAY();
    grid_coverage_ids1 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete raster_reliefs
    DELETE FROM
      raster_relief t
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
      coverage_id
    BULK COLLECT INTO
      deleted_ids,
      grid_coverage_ids1;

    -- collect all grid_coverageids into one nested table
    grid_coverage_ids0 := grid_coverage_ids0 MULTISET UNION ALL grid_coverage_ids1;

    -- delete grid_coverage(s)
    IF grid_coverage_ids0 IS NOT EMPTY THEN
      dummy_ids := del_grid_coverages(grid_coverage_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete relief_component
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_relief_components(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_relief_component(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_relief_components(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_relief_components(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    IF caller <> 2 THEN
      FOR i in 1..pids.count
      LOOP
        object_id := pids(i);
        EXECUTE IMMEDIATE 'SELECT objectclass_id FROM relief_component WHERE id = :1' INTO objectclass_id USING object_id;

          -- delete tin_relief
          IF objectclass_id = 16 THEN
            dummy_ids := del_tin_reliefs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete masspoint_relief
          IF objectclass_id = 17 THEN
            dummy_ids := del_masspoint_reliefs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete breakline_relief
          IF objectclass_id = 18 THEN
            dummy_ids := del_breakline_reliefs(ID_ARRAY(object_id), 1);
          END IF;

          -- delete raster_relief
          IF objectclass_id = 19 THEN
            dummy_ids := del_raster_reliefs(ID_ARRAY(object_id), 1);
          END IF;
      END LOOP;
    END IF;
  
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
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_relief_feature(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_relief_features(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_relief_features(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    relief_component_ids0 ID_ARRAY := ID_ARRAY();
  BEGIN
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
      relief_component_ids0;

    -- delete relief_component(s)
    IF relief_component_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(relief_component_ids0) a
      LEFT JOIN
        relief_feat_to_rel_comp n1
        ON n1.relief_component_id  = a.COLUMN_VALUE
      WHERE n1.relief_component_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_relief_components(object_ids);
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
    RETURNING
      id
    BULK COLLECT INTO
      deleted_ids;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_room(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_rooms(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_rooms(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete building_furnitures
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      building_furniture t,
      TABLE(pids) a
    WHERE
      t.room_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_building_furnitures(object_ids);
    END IF;

    --delete building_installations
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      building_installation t,
      TABLE(pids) a
    WHERE
      t.room_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_building_installations(object_ids);
    END IF;

    --delete thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      thematic_surface t,
      TABLE(pids) a
    WHERE
      t.room_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod4_multi_surface_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_solitary_vegetat_object(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_solitary_vegetat_objects(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_solitary_vegetat_objects(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids8 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids9 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod1_brep_id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod1_implicit_rep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      implicit_geometry_ids6,
      implicit_geometry_ids7,
      implicit_geometry_ids8,
      implicit_geometry_ids9;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids7;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids8;
    implicit_geometry_ids5 := implicit_geometry_ids5 MULTISET UNION ALL implicit_geometry_ids9;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids5 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids5) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_surface_data(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_surface_datas(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_surface_datas(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    tex_image_ids0 ID_ARRAY := ID_ARRAY();
    tex_image_ids1 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete surface_datas
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
    RETURNING
      id,
      tex_image_id
    BULK COLLECT INTO
      deleted_ids,
      tex_image_ids1;

    -- collect all tex_imageids into one nested table
    tex_image_ids0 := tex_image_ids0 MULTISET UNION ALL tex_image_ids1;

    -- delete tex_image(s)
    IF tex_image_ids0 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(tex_image_ids0) a
      LEFT JOIN
        surface_data n1
        ON n1.tex_image_id  = a.COLUMN_VALUE
      WHERE n1.tex_image_id IS NULL;

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_tex_images(object_ids);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_surface_geometry(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_surface_geometrys(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_surface_geometrys(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      surface_geometry t,
      TABLE(pids) a
    WHERE
      t.parent_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(object_ids);
    END IF;

    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      surface_geometry t,
      TABLE(pids) a
    WHERE
      t.root_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(object_ids);
    END IF;

    -- delete surface_geometrys
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tex_image(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tex_images(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tex_images(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
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

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_thematic_surface(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_thematic_surfaces(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_thematic_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    opening_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
  BEGIN
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
      opening_ids0;

    -- delete opening(s)
    IF opening_ids0 IS NOT EMPTY THEN
      dummy_ids := del_openings(opening_ids0);
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
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids4;

    -- delete surface_geometry(s)
    IF surface_geometry_ids1 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids1);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tin_relief(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tin_reliefs(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tin_reliefs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      surface_geometry_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete relief_component
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_relief_components(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_traffic_area(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_traffic_areas(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_traffic_areas(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_transportation_complex(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_transportation_complexs(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_transportation_complexs(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete traffic_areas
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      traffic_area t,
      TABLE(pids) a
    WHERE
      t.transportation_complex_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_traffic_areas(object_ids);
    END IF;

    -- delete transportation_complexs
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
    RETURNING
      id,
      lod1_multi_surface_id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tunnel(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tunnels(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_furniture(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tunnel_furnitures(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_furnitures(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids2 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids3 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod4_brep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      implicit_geometry_ids3;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids2 := implicit_geometry_ids2 MULTISET UNION ALL implicit_geometry_ids3;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids2 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids2) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_hollow_space(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tunnel_hollow_spaces(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_hollow_spaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete tunnel_furnitures
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_furniture t,
      TABLE(pids) a
    WHERE
      t.tunnel_hollow_space_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_furnitures(object_ids);
    END IF;

    --delete tunnel_installations
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_installation t,
      TABLE(pids) a
    WHERE
      t.tunnel_hollow_space_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_installations(object_ids);
    END IF;

    --delete tunnel_thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.tunnel_hollow_space_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod4_multi_surface_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_installation(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tunnel_installations(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_installations(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids6 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids7 ID_ARRAY := ID_ARRAY();
  BEGIN
    --delete tunnel_thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.tunnel_installation_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod2_brep_id,
      lod3_brep_id,
      lod4_brep_id,
      lod2_implicit_rep_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      implicit_geometry_ids5,
      implicit_geometry_ids6,
      implicit_geometry_ids7;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids5;
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids6;
    implicit_geometry_ids4 := implicit_geometry_ids4 MULTISET UNION ALL implicit_geometry_ids7;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids4 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids4) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_opening(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tunnel_openings(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_openings(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids3 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids4 ID_ARRAY := ID_ARRAY();
    implicit_geometry_ids5 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod3_multi_surface_id,
      lod4_multi_surface_id,
      lod3_implicit_rep_id,
      lod4_implicit_rep_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      implicit_geometry_ids4,
      implicit_geometry_ids5;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;

    -- collect all implicit_geometryids into one nested table
    implicit_geometry_ids3 := implicit_geometry_ids3 MULTISET UNION ALL implicit_geometry_ids4;
    implicit_geometry_ids3 := implicit_geometry_ids3 MULTISET UNION ALL implicit_geometry_ids5;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    -- delete implicit_geometry(s)
    IF implicit_geometry_ids3 IS NOT EMPTY THEN
      SELECT DISTINCT
        a.COLUMN_VALUE
      BULK COLLECT INTO
        object_ids
      FROM
        TABLE(implicit_geometry_ids3) a
      LEFT JOIN
        bridge_constr_element n1
        ON n1.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n2
        ON n2.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n3
        ON n3.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_constr_element n4
        ON n4.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_furniture n5
        ON n5.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n6
        ON n6.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n7
        ON n7.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_installation n8
        ON n8.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n9
        ON n9.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        bridge_opening n10
        ON n10.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_furniture n11
        ON n11.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n12
        ON n12.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n13
        ON n13.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        building_installation n14
        ON n14.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n15
        ON n15.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n16
        ON n16.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n17
        ON n17.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        city_furniture n18
        ON n18.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n19
        ON n19.lod0_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n20
        ON n20.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n21
        ON n21.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n22
        ON n22.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        generic_cityobject n23
        ON n23.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n24
        ON n24.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        opening n25
        ON n25.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n26
        ON n26.lod1_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n27
        ON n27.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n28
        ON n28.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        solitary_vegetat_object n29
        ON n29.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_furniture n30
        ON n30.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n31
        ON n31.lod2_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n32
        ON n32.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_installation n33
        ON n33.lod4_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n34
        ON n34.lod3_implicit_rep_id  = a.COLUMN_VALUE
      LEFT JOIN
        tunnel_opening n35
        ON n35.lod4_implicit_rep_id  = a.COLUMN_VALUE
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

      IF object_ids IS NOT EMPTY THEN
        dummy_ids := del_implicit_geometrys(object_ids);
      END IF;
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_thematic_surface(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_tunnel_thematic_surfaces(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_tunnel_thematic_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    tunnel_opening_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
  BEGIN
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
      tunnel_opening_ids0;

    -- delete tunnel_opening(s)
    IF tunnel_opening_ids0 IS NOT EMPTY THEN
      dummy_ids := del_tunnel_openings(tunnel_opening_ids0);
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
    RETURNING
      id,
      lod2_multi_surface_id,
      lod3_multi_surface_id,
      lod4_multi_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids4;

    -- delete surface_geometry(s)
    IF surface_geometry_ids1 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids1);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_tunnels(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids6 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids7 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids8 ID_ARRAY := ID_ARRAY();
  BEGIN
    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel t,
      TABLE(pids) a
    WHERE
      t.tunnel_parent_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnels(object_ids);
    END IF;

    -- delete referenced parts
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel t,
      TABLE(pids) a
    WHERE
      t.tunnel_root_id = a.COLUMN_VALUE
      AND t.id <> a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnels(object_ids);
    END IF;

    --delete tunnel_hollow_spaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_hollow_space t,
      TABLE(pids) a
    WHERE
      t.tunnel_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_hollow_spaces(object_ids);
    END IF;

    --delete tunnel_installations
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_installation t,
      TABLE(pids) a
    WHERE
      t.tunnel_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_installations(object_ids);
    END IF;

    --delete tunnel_thematic_surfaces
    SELECT
      t.id
    BULK COLLECT INTO
      object_ids
    FROM
      tunnel_thematic_surface t,
      TABLE(pids) a
    WHERE
      t.tunnel_id = a.COLUMN_VALUE;

    IF object_ids IS NOT EMPTY THEN
      dummy_ids := del_tunnel_thematic_surfaces(object_ids);
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
    RETURNING
      id,
      lod1_multi_surface_id,
      lod1_solid_id,
      lod2_multi_surface_id,
      lod2_solid_id,
      lod3_multi_surface_id,
      lod3_solid_id,
      lod4_multi_surface_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5,
      surface_geometry_ids6,
      surface_geometry_ids7,
      surface_geometry_ids8;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids5;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids6;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids7;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids8;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_waterbody(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_waterbodys(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_waterbodys(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    waterboundary_surface_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids4 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids5 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids6 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids7 ID_ARRAY := ID_ARRAY();
  BEGIN
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
      waterboundary_surface_ids0;

    -- delete waterboundary_surface(s)
    IF waterboundary_surface_ids0 IS NOT EMPTY THEN
      dummy_ids := del_waterboundary_surfaces(waterboundary_surface_ids0);
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
    RETURNING
      id,
      lod0_multi_surface_id,
      lod1_multi_surface_id,
      lod1_solid_id,
      lod2_solid_id,
      lod3_solid_id,
      lod4_solid_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids2,
      surface_geometry_ids3,
      surface_geometry_ids4,
      surface_geometry_ids5,
      surface_geometry_ids6,
      surface_geometry_ids7;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids3;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids4;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids5;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids6;
    surface_geometry_ids1 := surface_geometry_ids1 MULTISET UNION ALL surface_geometry_ids7;

    -- delete surface_geometry(s)
    IF surface_geometry_ids1 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids1);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

  FUNCTION del_waterboundary_surface(pid NUMBER) RETURN NUMBER
  IS
    deleted_id NUMBER;
    dummy_ids ID_ARRAY;
  BEGIN
    dummy_ids := del_waterboundary_surfaces(ID_ARRAY(pid));

    IF dummy_ids IS NOT EMPTY THEN
      deleted_id := dummy_ids(0);
    END IF;

    RETURN deleted_id;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN deleted_id;
  END;
  ------------------------------------------

  FUNCTION del_waterboundary_surfaces(pids ID_ARRAY, caller int := 0) RETURN ID_ARRAY
  IS
    object_id number;
    objectclass_id number;
    object_ids ID_ARRAY := ID_ARRAY();
    deleted_ids ID_ARRAY := ID_ARRAY();
    dummy_ids ID_ARRAY := ID_ARRAY();
    surface_geometry_ids0 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids1 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids2 ID_ARRAY := ID_ARRAY();
    surface_geometry_ids3 ID_ARRAY := ID_ARRAY();
  BEGIN
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
    RETURNING
      id,
      lod2_surface_id,
      lod3_surface_id,
      lod4_surface_id
    BULK COLLECT INTO
      deleted_ids,
      surface_geometry_ids1,
      surface_geometry_ids2,
      surface_geometry_ids3;

    -- collect all surface_geometryids into one nested table
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids1;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids2;
    surface_geometry_ids0 := surface_geometry_ids0 MULTISET UNION ALL surface_geometry_ids3;

    -- delete surface_geometry(s)
    IF surface_geometry_ids0 IS NOT EMPTY THEN
      dummy_ids := del_surface_geometrys(surface_geometry_ids0);
    END IF;

    IF caller <> 1 THEN
      -- delete cityobject
      IF deleted_ids IS NOT EMPTY THEN
        dummy_ids := del_cityobjects(deleted_ids, 2);
      END IF;
    END IF;

    RETURN deleted_ids;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN deleted_ids;
  END;
  ------------------------------------------

END citydb_delete;
/
