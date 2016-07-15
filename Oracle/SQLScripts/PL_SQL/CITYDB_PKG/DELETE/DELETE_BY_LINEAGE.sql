-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
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

CREATE OR REPLACE PACKAGE citydb_delete_by_lineage
AS
  function delete_cityobjects(lineage_value varchar2, delete_members int := 0, schema_name varchar2 := user) return id_array;
  function delete_buildings(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_bridges(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_tunnels(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_city_furnitures(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_generic_cityobjects(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_land_uses(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_plant_covers(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_solitary_veg_objs(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_transport_complexes(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_waterbodies(lineage_value varchar2, schema_name varchar2 := user) return id_array;
  function delete_cityobjectgroups(lineage_value varchar2, delete_members int := 0, schema_name varchar2 := user) return id_array;
  function delete_relief_features(lineage_value varchar2, schema_name varchar2 := user) return id_array;
END citydb_delete_by_lineage;
/

CREATE OR REPLACE PACKAGE BODY citydb_delete_by_lineage
AS 
  type ref_cursor is ref cursor;

  function delete_buildings(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    building_cur ref_cursor;
    building_id number;
  begin
    open building_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=26 and lineage = :1' using lineage_value;
    loop
      fetch building_cur into building_id;
      exit when building_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_building(building_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_buildings: deletion of building with ID ' || building_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close building_cur;
    
    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_buildings: ' || SQLERRM);
  end;

  function delete_bridges(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    bridge_cur ref_cursor;
    bridge_id number;
  begin
    open bridge_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=64 and lineage = :1' using lineage_value;
    loop
      fetch bridge_cur into bridge_id;
      exit when bridge_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_bridge(bridge_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_bridges: deletion of bridge with ID ' || bridge_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close bridge_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_bridges: ' || SQLERRM);
  end;

  function delete_tunnels(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    tunnel_cur ref_cursor;
    tunnel_id number;
  begin
    open tunnel_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=85 and lineage = :1' using lineage_value;
    loop
      fetch tunnel_cur into tunnel_id;
      exit when tunnel_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_tunnel(tunnel_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_tunnels: deletion of tunnel with ID ' || tunnel_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close tunnel_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_tunnels: ' || SQLERRM);
  end;
  
  function delete_city_furnitures(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    city_furniture_cur ref_cursor;
    city_furniture_id number;
  begin
    open city_furniture_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=21 and lineage = :1' using lineage_value;
    loop
      fetch city_furniture_cur into city_furniture_id;
      exit when city_furniture_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_city_furniture(city_furniture_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_city_furnitures: deletion of city_furniture with ID ' || city_furniture_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close city_furniture_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_city_furnitures: ' || SQLERRM);
  end;

  function delete_generic_cityobjects(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    generic_cityobject_cur ref_cursor;
    generic_cityobject_id number;
  begin
    open generic_cityobject_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=5 and lineage = :1' using lineage_value;
    loop
      fetch generic_cityobject_cur into generic_cityobject_id;
      exit when generic_cityobject_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_generic_cityobject(generic_cityobject_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_generic_cityobjects: deletion of generic_cityobject with ID ' || generic_cityobject_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close generic_cityobject_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_generic_cityobjects: ' || SQLERRM);
  end;

  function delete_land_uses(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    land_use_cur ref_cursor;
    land_use_id number;
  begin
    open land_use_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=4 and lineage = :1' using lineage_value;
    loop
      fetch land_use_cur into land_use_id;
      exit when land_use_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_land_use(land_use_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_land_uses: deletion of land_use with ID ' || land_use_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close land_use_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_land_uses: ' || SQLERRM);
  end;

  function delete_plant_covers(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    plant_cover_cur ref_cursor;
    plant_cover_id number;
  begin
    open plant_cover_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=8 and lineage = :1' using lineage_value;
    loop
      fetch plant_cover_cur into plant_cover_id;
      exit when plant_cover_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_plant_cover(plant_cover_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_plant_covers: deletion of plant_cover with ID ' || plant_cover_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close plant_cover_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_plant_covers: ' || SQLERRM);
  end;

  function delete_solitary_veg_objs(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    solitary_veg_obj_cur ref_cursor;
    solitary_veg_obj_id number;
  begin
    open solitary_veg_obj_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=8 and lineage = :1' using lineage_value;
    loop
      fetch solitary_veg_obj_cur into solitary_veg_obj_id;
      exit when solitary_veg_obj_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_solitary_veg_obj(solitary_veg_obj_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_solitary_veg_objs: deletion of solitary_vegetat_object with ID ' || solitary_veg_obj_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close solitary_veg_obj_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_solitary_veg_objs: ' || SQLERRM);
  end;

  function delete_transport_complexes(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    transport_complex_cur ref_cursor;
    transport_complex_id number;
  begin
    open transport_complex_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=42 and lineage = :1' using lineage_value;
    loop
      fetch transport_complex_cur into transport_complex_id;
      exit when transport_complex_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_transport_complex(transport_complex_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_transport_complexes: deletion of transportation_complex with ID ' || transport_complex_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close transport_complex_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_transport_complexes: ' || SQLERRM);
  end;

  function delete_waterbodies(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    waterbody_cur ref_cursor;
    waterbody_id number;
  begin
    open waterbody_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=9 and lineage = :1' using lineage_value;
    loop
      fetch waterbody_cur into waterbody_id;
      exit when waterbody_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_waterbody(waterbody_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_waterbodies: deletion of waterbody with ID ' || waterbody_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close waterbody_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_waterbodies: ' || SQLERRM);
  end;

  function delete_cityobjectgroups(lineage_value varchar2, delete_members int := 0, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    cityobjectgroup_cur ref_cursor;
    cityobjectgroup_id number;
  begin
    open cityobjectgroup_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=23 and lineage = :1' using lineage_value;
    loop      
      fetch cityobjectgroup_cur into cityobjectgroup_id;
      exit when cityobjectgroup_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_cityobjectgroup(cityobjectgroup_id, delete_members, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_cityobjectgroups: deletion of cityobjectgroup with ID ' || cityobjectgroup_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close cityobjectgroup_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_cityobjectgroups: ' || SQLERRM);
  end;

  function delete_relief_features(lineage_value varchar2, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    relief_feature_cur ref_cursor;
    relief_feature_id number;
  begin
    open relief_feature_cur for 'select id from '|| schema_name || '.cityobject where objectclass_id=14 and lineage = :1' using lineage_value;
    loop
      fetch relief_feature_cur into relief_feature_id;
      exit when relief_feature_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_relief_feature(relief_feature_id, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_relief_features: deletion of relief_feature with ID ' || relief_feature_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close relief_feature_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_relief_features: ' || SQLERRM);
  end;

  function delete_cityobjects(lineage_value varchar2, delete_members int := 0, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    cityobject_cur ref_cursor;
    cityobject_id number;
  begin
    open cityobject_cur for 'select id from '|| schema_name || '.cityobject where lineage = :1' using lineage_value;
    loop
      fetch cityobject_cur into cityobject_id;
      exit when cityobject_cur%notfound;
      begin
        deleted_id := citydb_delete.delete_cityobject(cityobject_id, delete_members, 0, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      exception
        when others then
          dbms_output.put_line('delete_cityobjects: deletion of cityobject with ID ' || cityobject_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close cityobject_cur;

    -- cleanup
    dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
    dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    dummy_ids := citydb_delete.cleanup_citymodels(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('delete_cityobjects: ' || SQLERRM);
  end;

END citydb_delete_by_lineage;
/