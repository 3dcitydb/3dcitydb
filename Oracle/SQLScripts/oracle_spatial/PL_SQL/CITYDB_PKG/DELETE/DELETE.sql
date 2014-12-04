-- DELETE.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--              György Hudra <ghudra@moss.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 3.0.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- 
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                                    | Author
-- 2.1.0     2014-11-10   delete with returning id of deleted features     FKun
-- 2.0.0     2014-10-10   extended for 3DCityDB V3                         GHud
--                                                                         FKun
--                                                                         CNag
-- 1.2.0     2013-08-08   extended to all thematic classes                 GHud
--                                                                         FKun
-- 1.1.0     2012-02-22   some performance improvements                    CNag
-- 1.0.0     2011-02-11   release version                                  CNag
--

CREATE OR REPLACE PACKAGE citydb_delete
AS
  function delete_surface_geometry(pid number, clean_apps int := 0, schema_name varchar2 := user) return id_array;
  function delete_implicit_geometry(pid number, clean_apps int := 0, schema_name varchar2 := user) return number;
  function delete_grid_coverage(pid number, schema_name varchar2 := user) return number;
  function delete_external_reference(pid number, schema_name varchar2 := user) return number;
  function delete_citymodel(pid number, delete_members int := 0, schema_name varchar2 := user) return number;
  function delete_appearance(pid number, schema_name varchar2 := user) return number;
  function delete_surface_data(pid number, schema_name varchar2 := user) return number;
  function delete_cityobjectgroup(pid number, delete_members int := 0, schema_name varchar2 := user) return number;
  function delete_thematic_surface(pid number, schema_name varchar2 := user) return number;
  function delete_opening(pid number, schema_name varchar2 := user) return number;
  function delete_address(pid number, schema_name varchar2 := user) return number;
  function delete_building_installation(pid number, schema_name varchar2 := user) return number;
  function delete_room(pid number, schema_name varchar2 := user) return number;
  function delete_building_furniture(pid number, schema_name varchar2 := user) return number;
  function delete_building(pid number, schema_name varchar2 := user) return number;
  function delete_city_furniture(pid number, schema_name varchar2 := user) return number;
  function delete_generic_cityobject(pid number, schema_name varchar2 := user) return number;
  function delete_land_use(pid number, schema_name varchar2 := user) return number;
  function delete_plant_cover(pid number, schema_name varchar2 := user) return number;
  function delete_solitary_veg_obj(pid number, schema_name varchar2 := user) return number;
  function delete_transport_complex(pid number, schema_name varchar2 := user) return number;
  function delete_traffic_area(pid number, schema_name varchar2 := user) return number;
  function delete_waterbnd_surface(pid number, schema_name varchar2 := user) return number;
  function delete_waterbody(pid number, schema_name varchar2 := user) return number;
  function delete_relief_feature(pid number, schema_name varchar2 := user) return number;
  function delete_relief_component(pid number, schema_name varchar2 := user) return number;
  function delete_tin_relief(pid number, schema_name varchar2 := user) return number;
  function delete_masspoint_relief(pid number, schema_name varchar2 := user) return number;
  function delete_breakline_relief(pid number, schema_name varchar2 := user) return number;
  function delete_raster_relief(pid number, schema_name varchar2 := user) return number;
  function delete_bridge(pid number, schema_name varchar2 := user) return number;
  function delete_bridge_installation(pid number, schema_name varchar2 := user) return number;
  function delete_bridge_thematic_surface(pid number, schema_name varchar2 := user) return number;
  function delete_bridge_opening(pid number, schema_name varchar2 := user) return number;
  function delete_bridge_furniture(pid number, schema_name varchar2 := user) return number;
  function delete_bridge_room(pid number, schema_name varchar2 := user) return number;
  function delete_bridge_constr_element(pid number, schema_name varchar2 := user) return number;
  function delete_tunnel(pid number, schema_name varchar2 := user) return number;
  function delete_tunnel_installation(pid number, schema_name varchar2 := user) return number;
  function delete_tunnel_thematic_surface(pid number, schema_name varchar2 := user) return number;
  function delete_tunnel_opening(pid number, schema_name varchar2 := user) return number;
  function delete_tunnel_furniture(pid number, schema_name varchar2 := user) return number;
  function delete_tunnel_hollow_space(pid number, schema_name varchar2 := user) return number;
  function delete_cityobject(pid number, delete_members int := 0, cleanup int := 0, schema_name varchar2 := user) return number;
  function delete_cityobject_cascade(pid number, schema_name varchar2 := user) return number;

  function cleanup_appearances(only_global int :=1, schema_name varchar2 := user) return id_array;
  function cleanup_addresses(schema_name varchar2 := user) return id_array;
  function cleanup_citymodels(schema_name varchar2 := user) return id_array;
  function cleanup_cityobjectgroups(schema_name varchar2 := user) return id_array;
  function cleanup_grid_coverages(schema_name varchar2 := user) return id_array;
  function cleanup_implicit_geometries(clean_apps int := 0, schema_name varchar2 := user) return id_array;
  function cleanup_tex_images(schema_name varchar2 := user) return id_array;
  procedure cleanup_schema(schema_name varchar2 := user);
  
  function is_not_referenced(table_name varchar2, check_column varchar2, check_id number, not_column varchar2, not_id number, schema_name varchar2 := user) return boolean;
END citydb_delete;
/

CREATE OR REPLACE PACKAGE BODY citydb_delete
AS
  -- private procedures
  function intern_delete_surface_geometry(pid number, schema_name varchar2 := user) return id_array;
  function intern_delete_implicit_geom(pid number, schema_name varchar2 := user) return number;
  function intern_delete_grid_coverage(pid number, schema_name varchar2 := user) return number;
  function intern_delete_cityobject(pid number, schema_name varchar2 := user) return number;
  function delete_citymodel(citymodel_rec citymodel%rowtype, delete_members int := 0, schema_name varchar2 := user) return number;
  function delete_appearance(appearance_rec appearance%rowtype, schema_name varchar2 := user) return number;
  function delete_surface_data(surface_data_rec surface_data%rowtype, schema_name varchar2 := user) return number;
  function delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype, delete_members int := 0, schema_name varchar2 := user) return number;
  function delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype, schema_name varchar2 := user) return number;
  function delete_opening(opening_rec opening%rowtype, schema_name varchar2 := user) return number;
  function delete_building_installation(building_installation_rec building_installation%rowtype, schema_name varchar2 := user) return number;
  function delete_room(room_rec room%rowtype, schema_name varchar2 := user) return number;
  function delete_building_furniture(building_furniture_rec building_furniture%rowtype, schema_name varchar2 := user) return number;
  function delete_building(building_rec building%rowtype, schema_name varchar2 := user) return number;
  function delete_city_furniture(city_furniture_rec city_furniture%rowtype, schema_name varchar2 := user) return number;
  function delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype, schema_name varchar2 := user) return number;
  function delete_land_use(land_use_rec land_use%rowtype, schema_name varchar2 := user) return number;
  function delete_plant_cover(plant_cover_rec plant_cover%rowtype, schema_name varchar2 := user) return number;
  function delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype, schema_name varchar2 := user) return number;
  function delete_traffic_area(traffic_area_rec traffic_area%rowtype, schema_name varchar2 := user) return number;
  function delete_transport_complex(transport_complex_rec transportation_complex%rowtype, schema_name varchar2 := user) return number;
  function delete_waterbody(waterbody_rec waterbody%rowtype, schema_name varchar2 := user) return number;
  function delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype, schema_name varchar2 := user) return number;
  function delete_relief_feature(relief_feature_rec relief_feature%rowtype, schema_name varchar2 := user) return number;
  function delete_relief_component(relief_component_rec relief_component%rowtype, schema_name varchar2 := user) return number;
  function delete_tin_relief(tin_relief_rec tin_relief%rowtype, schema_name varchar2 := user) return number;
  function delete_masspoint_relief(masspoint_relief_rec masspoint_relief%rowtype, schema_name varchar2 := user) return number;
  function delete_breakline_relief(breakline_relief_rec breakline_relief%rowtype, schema_name varchar2 := user) return number;
  function delete_raster_relief(raster_relief_rec raster_relief%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge(bridge_rec bridge%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge_thematic_surface(bridge_thematic_surface_rec bridge_thematic_surface%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge_installation(bridge_installation_rec bridge_installation%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge_room(bridge_room_rec bridge_room%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype, schema_name varchar2 := user) return number;
  function delete_bridge_constr_element(bridge_constr_element_rec bridge_constr_element%rowtype, schema_name varchar2 := user) return number;
  function delete_tunnel(tunnel_rec tunnel%rowtype, schema_name varchar2 := user) return number;
  function delete_tunnel_thematic_surface(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype, schema_name varchar2 := user) return number;
  function delete_tunnel_installation(tunnel_installation_rec tunnel_installation%rowtype, schema_name varchar2 := user) return number;
  function delete_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype, schema_name varchar2 := user) return number;
  function delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype, schema_name varchar2 := user) return number;
  function delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype, schema_name varchar2 := user) return number;
  
  procedure post_delete_implicit_geom(implicit_geometry_rec implicit_geometry%rowtype, schema_name varchar2 := user);
  procedure pre_delete_cityobject(pid number, schema_name varchar2 := user);
  procedure pre_delete_citymodel(citymodel_rec citymodel%rowtype, delete_members int := 0, schema_name varchar2 := user);
  procedure pre_delete_appearance(appearance_rec appearance%rowtype, schema_name varchar2 := user);
  procedure pre_delete_surface_data(surface_data_rec surface_data%rowtype, schema_name varchar2 := user);
  procedure pre_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype, delete_members int := 0, schema_name varchar2 := user);
  procedure post_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype, schema_name varchar2 := user);
  procedure pre_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype, schema_name varchar2 := user);
  procedure post_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype, schema_name varchar2 := user);
  procedure pre_delete_opening(opening_rec opening%rowtype, schema_name varchar2 := user);
  procedure post_delete_opening(opening_rec opening%rowtype, schema_name varchar2 := user);
  procedure pre_delete_building_inst(building_installation_rec building_installation%rowtype, schema_name varchar2 := user);
  procedure post_delete_building_inst(building_installation_rec building_installation%rowtype, schema_name varchar2 := user);
  procedure pre_delete_room(room_rec room%rowtype, schema_name varchar2 := user);
  procedure post_delete_room(room_rec room%rowtype, schema_name varchar2 := user);
  procedure post_delete_building_furniture(building_furniture_rec building_furniture%rowtype, schema_name varchar2 := user);
  procedure pre_delete_building(building_rec building%rowtype, schema_name varchar2 := user);
  procedure post_delete_building(building_rec building%rowtype, schema_name varchar2 := user);
  procedure post_delete_city_furniture(city_furniture_rec city_furniture%rowtype, schema_name varchar2 := user);
  procedure post_delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype, schema_name varchar2 := user);
  procedure post_delete_land_use(land_use_rec land_use%rowtype, schema_name varchar2 := user);
  procedure post_delete_plant_cover(plant_cover_rec plant_cover%rowtype, schema_name varchar2 := user);
  procedure post_delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype, schema_name varchar2 := user);
  procedure post_delete_traffic_area(traffic_area_rec traffic_area%rowtype, schema_name varchar2 := user);
  procedure pre_delete_transport_complex(transport_complex_rec transportation_complex%rowtype, schema_name varchar2 := user);
  procedure post_delete_transport_complex(transport_complex_rec transportation_complex%rowtype, schema_name varchar2 := user);
  procedure pre_delete_waterbody(waterbody_rec waterbody%rowtype, schema_name varchar2 := user);
  procedure post_delete_waterbody(waterbody_rec waterbody%rowtype, schema_name varchar2 := user);
  procedure pre_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype, schema_name varchar2 := user);
  procedure post_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype, schema_name varchar2 := user);
  procedure pre_delete_relief_feature(relief_feature_rec relief_feature%rowtype, schema_name varchar2 := user);
  procedure post_delete_relief_feature(relief_feature_rec relief_feature%rowtype, schema_name varchar2 := user);
  procedure pre_delete_relief_component(relief_component_rec relief_component%rowtype, schema_name varchar2 := user);
  procedure post_delete_relief_component(relief_component_rec relief_component%rowtype, schema_name varchar2 := user);
  procedure post_delete_tin_relief(tin_relief_rec tin_relief%rowtype, schema_name varchar2 := user);
  procedure post_delete_raster_relief(raster_relief_rec raster_relief%rowtype, schema_name varchar2 := user);
  procedure pre_delete_bridge(bridge_rec bridge%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge(bridge_rec bridge%rowtype, schema_name varchar2 := user);
  procedure pre_delete_bridge_them_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge_them_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype, schema_name varchar2 := user);
  procedure pre_delete_bridge_inst(bridge_installation_rec bridge_installation%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge_inst(bridge_installation_rec bridge_installation%rowtype, schema_name varchar2 := user);
  procedure pre_delete_bridge_constr_elem(bridge_constr_element_rec bridge_constr_element%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge_constr_elem(bridge_constr_element_rec bridge_constr_element%rowtype, schema_name varchar2 := user);
  procedure pre_delete_bridge_room(bridge_room_rec bridge_room%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge_room(bridge_room_rec bridge_room%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype, schema_name varchar2 := user);
  procedure pre_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype, schema_name varchar2 := user);
  procedure post_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype, schema_name varchar2 := user);
  procedure pre_delete_tunnel(tunnel_rec tunnel%rowtype, schema_name varchar2 := user);
  procedure post_delete_tunnel(tunnel_rec tunnel%rowtype, schema_name varchar2 := user);
  procedure pre_delete_tunnel_them_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype, schema_name varchar2 := user);
  procedure post_delete_tunnel_them_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype, schema_name varchar2 := user);
  procedure pre_delete_tunnel_inst(tunnel_installation_rec tunnel_installation%rowtype, schema_name varchar2 := user);
  procedure post_delete_tunnel_inst(tunnel_installation_rec tunnel_installation%rowtype, schema_name varchar2 := user);
  procedure pre_delete_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype, schema_name varchar2 := user);
  procedure post_delete_tunnel_hollowspace(tunnel_hollow_space_rec tunnel_hollow_space%rowtype, schema_name varchar2 := user);
  procedure post_delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype, schema_name varchar2 := user);
  procedure pre_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype, schema_name varchar2 := user);
  procedure post_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype, schema_name varchar2 := user);

  type ref_cursor is ref cursor;

  /*
    internal helpers
  */
  function is_not_referenced(table_name varchar2, check_column varchar2, check_id number, not_column varchar2, not_id number, schema_name varchar2 := user) return boolean
  is
    ref_cur ref_cursor;
    dummy number;
    is_not_referenced boolean;
  begin
    open ref_cur for 'select 1 from ' || schema_name || '.' || table_name || ' where ' || check_column || '=:1 and not ' || not_column || '=:2' using check_id, not_id;
    loop 
      fetch ref_cur into dummy;
      is_not_referenced := ref_cur%notfound;
      exit;
    end loop;
    close ref_cur;

    return is_not_referenced;
  end;

  /*
    internal: delete from SURFACE_GEOMETRY
  */
  function intern_delete_surface_geometry(pid number, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    geom_cur ref_cursor;
    sg_id number;
  begin
    open geom_cur for 'select id from ' || schema_name || '.surface_geometry start with id=:1 connect by prior id=parent_id order by level desc' using pid;
    loop
      fetch geom_cur into sg_id;
      exit when geom_cur%notfound;
      execute immediate 'delete from ' || schema_name || '.textureparam where surface_geometry_id=:1' using sg_id;
      execute immediate 'delete from ' || schema_name || '.surface_geometry where id=:1 returning id into :2' using sg_id, out deleted_id;
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;	  
    end loop;
    close geom_cur;

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('intern_delete_surface_geometry (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from IMPLICIT_GEOMETRY
  */
  function intern_delete_implicit_geom(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    implicit_geometry_rec implicit_geometry%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.implicit_geometry where id=:1'
      into implicit_geometry_rec
      using pid;

    execute immediate 'delete from ' || schema_name || '.implicit_geometry where id=:1 returning id into :2' using pid, out deleted_id;
    post_delete_implicit_geom(implicit_geometry_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('intern_delete_implicit_geom (id: ' || pid || '): ' || SQLERRM);
  end; 

  procedure post_delete_implicit_geom(implicit_geometry_rec implicit_geometry%rowtype, schema_name varchar2 := user)
  is
    dummy_ids id_array := id_array();
  begin
    if implicit_geometry_rec.relative_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(implicit_geometry_rec.relative_brep_id, schema_name);
    end if;
  exception
    when others then
      dbms_output.put_line('post_delete_implicit_geom (id: ' || implicit_geometry_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from GRID_COVERAGE
  */
  function intern_delete_grid_coverage(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.grid_coverage where id=:1 returning id into :2' using pid, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('intern_delete_grid_coverage (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITY_OBJECT
  */
  procedure pre_delete_cityobject(pid number, schema_name varchar2 := user)
  is
    dummy_id number;
    appearance_cur ref_cursor;
    appearance_rec appearance%rowtype;
  begin
    execute immediate 'delete from ' || schema_name || '.cityobject_member where cityobject_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.group_to_cityobject where cityobject_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.generalization where generalizes_to_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.generalization where cityobject_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.external_reference where cityobject_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.cityobject_genericattrib where cityobject_id=:1' using pid;
    execute immediate 'update ' || schema_name || '.cityobjectgroup set parent_cityobject_id=null where parent_cityobject_id=:1' using pid;

    open appearance_cur for 'select * from ' || schema_name || '.appearance where cityobject_id=:1' using pid;
    loop
      fetch appearance_cur into appearance_rec;
      exit when appearance_cur%notfound;
      dummy_id := delete_appearance(appearance_rec, schema_name);
    end loop;
    close appearance_cur;
  exception
    when others then
      dbms_output.put_line('pre_delete_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  function intern_delete_cityobject(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_cityobject(pid, schema_name);
    execute immediate 'delete from ' || schema_name || '.cityobject where id=:1 returning id into :2' using pid, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('intern_delete_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITYMODEL
  */
  procedure pre_delete_citymodel(citymodel_rec citymodel%rowtype, delete_members int := 0, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
    member_cur ref_cursor;
    member_id number;
    appearance_cur ref_cursor;
    appearance_rec appearance%rowtype;
  begin
    -- delete members
    if delete_members <> 0 then
      open member_cur for 'select cityobject_id from ' || schema_name || '.cityobject_member where citymodel_id=:1' USING citymodel_rec.id;
      loop
        fetch member_cur into member_id;
        exit when member_cur%notfound;
        begin
          dummy_id := delete_cityobject(member_id, delete_members, 0, schema_name);
        exception
          when others then
            dbms_output.put_line('pre_delete_citymodel: deletion of cityobject_member with ID ' || member_id || ' threw: ' || SQLERRM);
        end;
      end loop;

      -- cleanup
      dummy_ids := cleanup_implicit_geometries(1, schema_name);
      dummy_ids := cleanup_appearances(1, schema_name);      
    end if;

    execute immediate 'delete from ' || schema_name || '.cityobject_member where citymodel_id=:1' using citymodel_rec.id;

    open appearance_cur for 'select * from ' || schema_name || '.appearance where cityobject_id=:1' using citymodel_rec.id;
    loop
      fetch appearance_cur into appearance_rec;
      exit when appearance_cur%notfound;
      dummy_id := delete_appearance(appearance_rec, schema_name);
    end loop;
    close appearance_cur;
  exception
    when others then
      dbms_output.put_line('pre_delete_citymodel (id: ' || citymodel_rec.id || '): ' || SQLERRM);
  end;

  function delete_citymodel(citymodel_rec citymodel%rowtype, delete_members int := 0, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_citymodel(citymodel_rec, delete_members, schema_name);
    execute immediate 'delete from ' || schema_name || '.citymodel where id=:1 returning id into :2' using citymodel_rec.id, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_citymodel (id: ' || citymodel_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from APPEARANCE
  */
  procedure pre_delete_appearance(appearance_rec appearance%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    surface_data_cur ref_cursor;
    surface_data_rec surface_data%rowtype;
  begin
    -- delete surface data not being referenced by appearances any more
    open surface_data_cur for 'select s.* from ' || schema_name || '.surface_data s, ' || schema_name || '.appear_to_surface_data ats
        where s.id=ats.surface_data_id and ats.appearance_id=:1' using appearance_rec.id;
    loop
      fetch surface_data_cur into surface_data_rec;
      exit when surface_data_cur%notfound;
      if is_not_referenced('appear_to_surface_data', 'surface_data_id', surface_data_rec.id, 'appearance_id', appearance_rec.id, schema_name) then 
        dummy_id := delete_surface_data(surface_data_rec, schema_name);
      end if;
    end loop;
    close surface_data_cur;

    execute immediate 'delete from ' || schema_name || '.appear_to_surface_data where appearance_id=:1' using appearance_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_appearance (id: ' || appearance_rec.id || '): ' || SQLERRM);
  end;

  function delete_appearance(appearance_rec appearance%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_appearance(appearance_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.appearance where id=:1 returning id into :2' using appearance_rec.id, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_appearance (id: ' || appearance_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from SURFACE_DATA
  */
  procedure pre_delete_surface_data(surface_data_rec surface_data%rowtype, schema_name varchar2 := user)
  is
  begin
      execute immediate 'delete from ' || schema_name || '.appear_to_surface_data where surface_data_id=:1' using surface_data_rec.id;
      execute immediate 'delete from ' || schema_name || '.textureparam where surface_data_id=:1' using surface_data_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_surface_data (id: ' || surface_data_rec.id || '): ' || SQLERRM);
  end;

  function delete_surface_data(surface_data_rec surface_data%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_surface_data(surface_data_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.surface_data where id=:1 returning id into :2' using surface_data_rec.id, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_surface_data (id: ' || surface_data_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITYOBJECTGROUP
  */
  procedure pre_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype, delete_members int := 0, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
    member_cur ref_cursor;
    member_id number;
  begin
    -- delete members
    if delete_members <> 0 then
      open member_cur for 'select cityobject_id from ' || schema_name || '.group_to_cityobject where cityobjectgroup_id=:1' USING cityobjectgroup_rec.id;
      loop
        fetch member_cur into member_id;
        exit when member_cur%notfound;
        begin
          dummy_id := delete_cityobject(member_id, delete_members, 0, schema_name);
        exception
          when others then
            dbms_output.put_line('pre_delete_cityobjectgroup: deletion of group_member with ID ' || member_id || ' threw: ' || SQLERRM);
        end;
      end loop;

      -- cleanup
      dummy_ids := citydb_delete.cleanup_implicit_geometries(1, schema_name);
      dummy_ids := citydb_delete.cleanup_appearances(1, schema_name);
    end if;
    
    execute immediate 'delete from ' || schema_name || '.group_to_cityobject where cityobjectgroup_id=:1' using cityobjectgroup_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_cityobjectgroup (id: ' || cityobjectgroup_rec.id || '): ' || SQLERRM);
  end;

  function delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype, delete_members int := 0, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_cityobjectgroup(cityobjectgroup_rec, delete_members, schema_name);
    execute immediate 'delete from ' || schema_name || '.cityobjectgroup where id=:1 returning id into :2' using cityobjectgroup_rec.id, out deleted_id;
    post_delete_cityobjectgroup(cityobjectgroup_rec, schema_name); 
    return deleted_id;	
  exception
    when others then
      dbms_output.put_line('delete_cityobjectgroup (id: ' || cityobjectgroup_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if cityobjectgroup_rec.brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(cityobjectgroup_rec.brep_id, schema_name);
    end if;  

    dummy_id := intern_delete_cityobject(cityobjectgroup_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_cityobjectgroup (id: ' || cityobjectgroup_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from THEMATIC_SURFACE
  */
  procedure pre_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    opening_cur ref_cursor;
    opening_rec opening%rowtype;
  begin
    -- delete openings not being referenced by a thematic surface any more
    open opening_cur for 'select o.* from ' || schema_name || '.opening o, ' || schema_name || '.opening_to_them_surface otm 
        where o.id=otm.opening_id and otm.thematic_surface_id=:1' using thematic_surface_rec.id;
    loop
      fetch opening_cur into opening_rec;
      exit when opening_cur%notfound;
      if is_not_referenced('opening_to_them_surface', 'opening_id', opening_rec.id, 'thematic_surface_id', thematic_surface_rec.id, schema_name) then 
        dummy_id := delete_opening(opening_rec, schema_name);
      end if;
    end loop;
    close opening_cur;

    execute immediate 'delete from ' || schema_name || '.opening_to_them_surface where thematic_surface_id=:1' using thematic_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_thematic_surface (id: ' || thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  function delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_thematic_surface(thematic_surface_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.thematic_surface where id=:1 returning id into :2' using thematic_surface_rec.id, out deleted_id;
    post_delete_thematic_surface(thematic_surface_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_thematic_surface (id: ' || thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if thematic_surface_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(thematic_surface_rec.lod2_multi_surface_id, schema_name);
    end if;
    if thematic_surface_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(thematic_surface_rec.lod3_multi_surface_id, schema_name);
    end if;
    if thematic_surface_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(thematic_surface_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(thematic_surface_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_thematic_surface (id: ' || thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from OPENING
  */
  procedure pre_delete_opening(opening_rec opening%rowtype, schema_name varchar2 := user)
  is
  begin
    execute immediate 'delete from ' || schema_name || '.opening_to_them_surface where opening_id=:1' using opening_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_opening (id: ' || opening_rec.id || '): ' || SQLERRM);
  end;

  function delete_opening(opening_rec opening%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_opening(opening_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.opening where id=:1 returning id into :2' using opening_rec.id, out deleted_id;
    post_delete_opening(opening_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_opening (id: ' || opening_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_opening(opening_rec opening%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
    address_cur ref_cursor;
    address_id number;
  begin
    if opening_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(opening_rec.lod3_multi_surface_id, schema_name);
    end if;
    if opening_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(opening_rec.lod4_multi_surface_id, schema_name);
    end if;

    -- delete addresses not being referenced from buildings and openings any more
    open address_cur for 'select a.id from ' || schema_name || '.address a left outer join ' || schema_name || '.address_to_building ab
        on a.id=ab.address_id where a.id=:1 and ab.address_id is null' using opening_rec.address_id;
    loop
      fetch address_cur into address_id;
      exit when address_cur%notfound;
      if is_not_referenced('opening', 'address_id', address_id, 'id', opening_rec.id, schema_name) then
        dummy_id := delete_address(address_id, schema_name);
      end if;   
    end loop;
    close address_cur;

    dummy_id := intern_delete_cityobject(opening_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_opening (id: ' || opening_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BUILDING_INSTALLATION
  */
  procedure pre_delete_building_inst(building_installation_rec building_installation%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    thematic_surface_cur ref_cursor;
    thematic_surface_rec thematic_surface%rowtype;
  begin
    open thematic_surface_cur for 'select * from ' || schema_name || '.thematic_surface where building_installation_id=:1' using building_installation_rec.id;
    loop
      fetch thematic_surface_cur into thematic_surface_rec;
      exit when thematic_surface_cur%notfound;
      dummy_id := delete_thematic_surface(thematic_surface_rec, schema_name);
    end loop;
    close thematic_surface_cur;
  exception
    when others then
      dbms_output.put_line('pre_delete_building_inst (id: ' || building_installation_rec.id || '): ' || SQLERRM);
  end;

  function delete_building_installation(building_installation_rec building_installation%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_building_inst(building_installation_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.building_installation where id=:1 returning id into :2' using building_installation_rec.id, out deleted_id;
    post_delete_building_inst(building_installation_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_building_installation (id: ' || building_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_building_inst(building_installation_rec building_installation%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if building_installation_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_installation_rec.lod2_brep_id, schema_name);
    end if;
    if building_installation_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_installation_rec.lod3_brep_id, schema_name);
    end if;
    if building_installation_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_installation_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(building_installation_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_building_inst (id: ' || building_installation_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from ROOM
  */
  procedure pre_delete_room(room_rec room%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    thematic_surface_cur ref_cursor;
    thematic_surface_rec thematic_surface%rowtype;
    building_installation_cur ref_cursor;
    building_installation_rec building_installation%rowtype;
    building_furniture_cur ref_cursor;
    building_furniture_rec building_furniture%rowtype;
  begin
    open thematic_surface_cur for 'select * from ' || schema_name || '.thematic_surface where room_id=:1' using room_rec.id;
    loop
      fetch thematic_surface_cur into thematic_surface_rec;
      exit when thematic_surface_cur%notfound;
      dummy_id := delete_thematic_surface(thematic_surface_rec, schema_name);
    end loop;
    close thematic_surface_cur;

    open building_installation_cur for 'select * from ' || schema_name || '.building_installation where room_id=:1' using room_rec.id;
    loop
      fetch building_installation_cur into building_installation_rec;
      exit when building_installation_cur%notfound;
      dummy_id := delete_building_installation(building_installation_rec, schema_name);
    end loop;
    close building_installation_cur;

    open building_furniture_cur for 'select * from ' || schema_name || '.building_furniture where room_id=:1' using room_rec.id;
    loop
      fetch building_furniture_cur into building_furniture_rec;
      exit when building_furniture_cur%notfound;
      dummy_id := delete_building_furniture(building_furniture_rec, schema_name);
    end loop;
    close building_furniture_cur;
   exception
    when others then
      dbms_output.put_line('pre_delete_room (id: ' || room_rec.id || '): ' || SQLERRM);
  end;

  function delete_room(room_rec room%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_room(room_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.room where id=:1 returning id into :2' using room_rec.id, out deleted_id;
    post_delete_room(room_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_room (id: ' || room_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_room(room_rec room%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if room_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(room_rec.lod4_multi_surface_id, schema_name);
    end if;
    if room_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(room_rec.lod4_solid_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(room_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_room (id: ' || room_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BUILDING_FURNITURE
  */
  function delete_building_furniture(building_furniture_rec building_furniture%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.building_furniture where id=:1 returning id into :2' using building_furniture_rec.id, out deleted_id;
    post_delete_building_furniture(building_furniture_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_building_furniture (id: ' || building_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_building_furniture(building_furniture_rec building_furniture%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if building_furniture_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_furniture_rec.lod4_brep_id, schema_name);
    end if;
    
    dummy_id := intern_delete_cityobject(building_furniture_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_building_furniture (id: ' || building_furniture_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BUILDING
  */
  procedure pre_delete_building(building_rec building%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    building_part_cur ref_cursor;
    building_part_rec building%rowtype;
    thematic_surface_cur ref_cursor;
    thematic_surface_rec thematic_surface%rowtype;
    building_installation_cur ref_cursor;
    building_installation_rec building_installation%rowtype;
    room_cur ref_cursor;
    room_rec room%rowtype;
    address_cur ref_cursor;
    address_id number;
  begin
    open building_part_cur for 'select * from ' || schema_name || '.building where id!=:1 and building_parent_id=:2' using building_rec.id, building_rec.id;
    loop
      fetch building_part_cur into building_part_rec;
      exit when building_part_cur%notfound;
      dummy_id := delete_building(building_part_rec, schema_name);
    end loop;
    close building_part_cur;

    open thematic_surface_cur for 'select * from ' || schema_name || '.thematic_surface where building_id=:1' using building_rec.id;
    loop
      fetch thematic_surface_cur into thematic_surface_rec;
      exit when thematic_surface_cur%notfound;
      dummy_id := delete_thematic_surface(thematic_surface_rec, schema_name);
    end loop;
    close thematic_surface_cur;

    open building_installation_cur for 'select * from ' || schema_name || '.building_installation where building_id=:1' using building_rec.id;
    loop
      fetch building_installation_cur into building_installation_rec;
      exit when building_installation_cur%notfound;
      dummy_id := delete_building_installation(building_installation_rec, schema_name);
    end loop;
    close building_installation_cur;

    open room_cur for 'select * from ' || schema_name || '.room where building_id=:1' using building_rec.id;
    loop
      fetch room_cur into room_rec;
      exit when room_cur%notfound;
      dummy_id := delete_room(room_rec, schema_name);
    end loop;
    close room_cur;

    -- delete addresses being not referenced from buildings any more
    open address_cur for 'select address_id from ' || schema_name || '.address_to_building where building_id=:1' using building_rec.id;
    loop
      fetch address_cur into address_id;
      exit when address_cur%notfound;
      if is_not_referenced('address_to_building', 'address_id', address_id, 'building_id', building_rec.id, schema_name) then 
        dummy_id := delete_address(address_id, schema_name);
      end if;
    end loop;
    close address_cur;

    execute immediate 'delete from ' || schema_name || '.address_to_building where building_id=:1' using building_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_building (id: ' || building_rec.id || '): ' || SQLERRM);
  end;

  function delete_building(building_rec building%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_building(building_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.building where id=:1 returning id into :2' using building_rec.id, out deleted_id;
    post_delete_building(building_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_building (id: ' || building_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_building(building_rec building%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if building_rec.lod0_footprint_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod0_footprint_id, schema_name);
    end if; 
    if building_rec.lod0_roofprint_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod0_roofprint_id, schema_name);
    end if;

    if building_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod1_multi_surface_id, schema_name);
    end if; 
    if building_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod2_multi_surface_id, schema_name);
    end if;
    if building_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod3_multi_surface_id, schema_name);
    end if;
    if building_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod4_multi_surface_id, schema_name);
    end if;

    if building_rec.lod1_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod1_solid_id, schema_name);
    end if; 
    if building_rec.lod2_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod2_solid_id, schema_name);
    end if;
    if building_rec.lod3_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod3_solid_id, schema_name);
    end if;
    if building_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(building_rec.lod4_solid_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(building_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_building (id: ' || building_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITY_FURNITURE
  */
  function delete_city_furniture(city_furniture_rec city_furniture%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.city_furniture where id=:1 returning id into :2' using city_furniture_rec.id, out deleted_id;
    post_delete_city_furniture(city_furniture_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_city_furniture (id: ' || city_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_city_furniture(city_furniture_rec city_furniture%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if city_furniture_rec.lod1_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(city_furniture_rec.lod1_brep_id, schema_name);
    end if; 
    if city_furniture_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(city_furniture_rec.lod2_brep_id, schema_name);
    end if;
    if city_furniture_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(city_furniture_rec.lod3_brep_id, schema_name);
    end if;
    if city_furniture_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(city_furniture_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(city_furniture_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_city_furniture (id: ' || city_furniture_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from GENERIC_CITYOBJECT
  */
  function delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.generic_cityobject where id=:1 returning id into :2' using generic_cityobject_rec.id, out deleted_id;
    post_delete_generic_cityobject(generic_cityobject_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_generic_cityobject (id: ' || generic_cityobject_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if generic_cityobject_rec.lod0_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(generic_cityobject_rec.lod0_brep_id, schema_name);
    end if; 
    if generic_cityobject_rec.lod1_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(generic_cityobject_rec.lod1_brep_id, schema_name);
    end if; 
    if generic_cityobject_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(generic_cityobject_rec.lod2_brep_id, schema_name);
    end if;
    if generic_cityobject_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(generic_cityobject_rec.lod3_brep_id, schema_name);
    end if;
    if generic_cityobject_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(generic_cityobject_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(generic_cityobject_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_generic_cityobject (id: ' || generic_cityobject_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from LAND_USE
  */
  function delete_land_use(land_use_rec land_use%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.land_use where id=:1 returning id into :2' using land_use_rec.id, out deleted_id;
    post_delete_land_use(land_use_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_land_use (id: ' || land_use_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_land_use(land_use_rec land_use%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if land_use_rec.lod0_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(land_use_rec.lod0_multi_surface_id, schema_name);
    end if; 
    if land_use_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(land_use_rec.lod1_multi_surface_id, schema_name);
    end if; 
    if land_use_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(land_use_rec.lod2_multi_surface_id, schema_name);
    end if;
    if land_use_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(land_use_rec.lod3_multi_surface_id, schema_name);
    end if;
    if land_use_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(land_use_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(land_use_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_land_use (id: ' || land_use_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from PLANT_COVER
  */
  function delete_plant_cover(plant_cover_rec plant_cover%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.plant_cover where id=:1 returning id into :2' using plant_cover_rec.id, out deleted_id;
    post_delete_plant_cover(plant_cover_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_plant_cover (id: ' || plant_cover_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_plant_cover(plant_cover_rec plant_cover%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if plant_cover_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod1_multi_surface_id, schema_name);
    end if; 
    if plant_cover_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod2_multi_surface_id, schema_name);
    end if;
    if plant_cover_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod3_multi_surface_id, schema_name);
    end if;
    if plant_cover_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod4_multi_surface_id, schema_name);
    end if;

    if plant_cover_rec.lod1_multi_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod1_multi_solid_id, schema_name);
    end if; 
    if plant_cover_rec.lod2_multi_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod2_multi_solid_id, schema_name);
    end if;
    if plant_cover_rec.lod3_multi_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod3_multi_solid_id, schema_name);
    end if;
    if plant_cover_rec.lod4_multi_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(plant_cover_rec.lod4_multi_solid_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(plant_cover_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_plant_cover (id: ' || plant_cover_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from SOLITARY_VEGETAT_OBJECT
  */
  function delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.solitary_vegetat_object where id=:1 returning id into :2' using solitary_veg_obj_rec.id, out deleted_id;
    post_delete_solitary_veg_obj(solitary_veg_obj_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_solitary_veg_obj (id: ' || solitary_veg_obj_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if solitary_veg_obj_rec.lod1_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(solitary_veg_obj_rec.lod1_brep_id, schema_name);
    end if; 
    if solitary_veg_obj_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(solitary_veg_obj_rec.lod2_brep_id, schema_name);
    end if;
    if solitary_veg_obj_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(solitary_veg_obj_rec.lod3_brep_id, schema_name);
    end if;
    if solitary_veg_obj_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(solitary_veg_obj_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(solitary_veg_obj_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_solitary_veg_obj (id: ' || solitary_veg_obj_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TRAFFIC_AREA
  */
  function delete_traffic_area(traffic_area_rec traffic_area%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.traffic_area where id=:1 returning id into :2' using traffic_area_rec.id, out deleted_id;
    post_delete_traffic_area(traffic_area_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_traffic_area (id: ' || traffic_area_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_traffic_area(traffic_area_rec traffic_area%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if traffic_area_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(traffic_area_rec.lod2_multi_surface_id, schema_name);
    end if;
    if traffic_area_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(traffic_area_rec.lod3_multi_surface_id, schema_name);
    end if;
    if traffic_area_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(traffic_area_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(traffic_area_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_traffic_area (id: ' || traffic_area_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TRANSPORTATION_COMPLEX
  */
  procedure pre_delete_transport_complex(transport_complex_rec transportation_complex%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    traffic_area_cur ref_cursor;
    traffic_area_rec traffic_area%rowtype;
  begin
    open traffic_area_cur for 'select * from ' || schema_name || '.traffic_area where transportation_complex_id=:1' using transport_complex_rec.id;
    loop
      fetch traffic_area_cur into traffic_area_rec;
      exit when traffic_area_cur%notfound;
      dummy_id := delete_traffic_area(traffic_area_rec, schema_name);
    end loop;
    close traffic_area_cur;

  exception
    when others then
      dbms_output.put_line('pre_delete_transport_complex (id: ' || transport_complex_rec.id || '): ' || SQLERRM);
  end;

  function delete_transport_complex(transport_complex_rec transportation_complex%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_transport_complex(transport_complex_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.transportation_complex where id=:1 returning id into :2' using transport_complex_rec.id, out deleted_id;
    post_delete_transport_complex(transport_complex_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_transport_complex (id: ' || transport_complex_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_transport_complex(transport_complex_rec transportation_complex%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if transport_complex_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(transport_complex_rec.lod1_multi_surface_id, schema_name);
    end if; 
    if transport_complex_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(transport_complex_rec.lod2_multi_surface_id, schema_name);
    end if;
    if transport_complex_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(transport_complex_rec.lod3_multi_surface_id, schema_name);
    end if;
    if transport_complex_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(transport_complex_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(transport_complex_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_transport_complex (id: ' || transport_complex_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from WATERBODY
  */
  procedure pre_delete_waterbody(waterbody_rec waterbody%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    waterbnd_surface_cur ref_cursor;
    waterbnd_surface_id number;
  begin
    -- delete water boundary surface being not referenced from waterbodies any more
    open waterbnd_surface_cur for 'select waterboundary_surface_id from ' || schema_name || '.waterbod_to_waterbnd_srf where waterbody_id=:1' using waterbody_rec.id;
    loop
      fetch waterbnd_surface_cur into waterbnd_surface_id;
      exit when waterbnd_surface_cur%notfound;
      if is_not_referenced('waterbod_to_waterbnd_srf', 'waterboundary_surface_id', waterbnd_surface_id, 'waterbody_id', waterbody_rec.id, schema_name) then 
        dummy_id := delete_waterbnd_surface(waterbnd_surface_id, schema_name);
      end if;
    end loop;
    close waterbnd_surface_cur;

    execute immediate 'delete from ' || schema_name || '.waterbod_to_waterbnd_srf where waterbody_id=:1' using waterbody_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_waterbody (id: ' || waterbody_rec.id || '): ' || SQLERRM);
  end;

  function delete_waterbody(waterbody_rec waterbody%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_waterbody(waterbody_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.waterbody where id=:1 returning id into :2' using waterbody_rec.id, out deleted_id;
    post_delete_waterbody(waterbody_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_waterbody (id: ' || waterbody_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_waterbody(waterbody_rec waterbody%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if waterbody_rec.lod1_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbody_rec.lod1_solid_id, schema_name);
    end if; 
    if waterbody_rec.lod2_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbody_rec.lod2_solid_id, schema_name);
    end if;
    if waterbody_rec.lod3_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbody_rec.lod3_solid_id, schema_name);
    end if;
    if waterbody_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbody_rec.lod4_solid_id, schema_name);
    end if;
    if waterbody_rec.lod0_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbody_rec.lod0_multi_surface_id, schema_name);
    end if;
    if waterbody_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbody_rec.lod1_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(waterbody_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_waterbody (id: ' || waterbody_rec.id || '): ' || SQLERRM);
  end;

  procedure pre_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype, schema_name varchar2 := user)
  is
  begin
    execute immediate 'delete from ' || schema_name || '.waterbod_to_waterbnd_srf where waterboundary_surface_id=:1' using waterbnd_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_waterbnd_surface (id: ' || waterbnd_surface_rec.id || '): ' || SQLERRM);
  end;

  function delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_waterbnd_surface(waterbnd_surface_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.waterboundary_surface where id=:1 returning id into :2' using waterbnd_surface_rec.id, out deleted_id;
    post_delete_waterbnd_surface(waterbnd_surface_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_waterbnd_surface (id: ' || waterbnd_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if waterbnd_surface_rec.lod2_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbnd_surface_rec.lod2_surface_id, schema_name);
    end if;
    if waterbnd_surface_rec.lod3_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbnd_surface_rec.lod3_surface_id, schema_name);
    end if;
    if waterbnd_surface_rec.lod4_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(waterbnd_surface_rec.lod4_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(waterbnd_surface_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_waterbnd_surface (id: ' || waterbnd_surface_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from RELIEF_FEATURE
  */
  procedure pre_delete_relief_feature(relief_feature_rec relief_feature%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    relief_component_cur ref_cursor;
    component_id number;
  begin
    -- delete relief component being not referenced from relief features any more
    open relief_component_cur for 'select relief_component_id from ' || schema_name || '.relief_feat_to_rel_comp where relief_feature_id=:1' using relief_feature_rec.id;
    loop
      fetch relief_component_cur into component_id;
      exit when relief_component_cur%notfound;
      if is_not_referenced('relief_feat_to_rel_comp', 'relief_component_id', component_id, 'relief_feature_id', relief_feature_rec.id, schema_name) then 
        dummy_id := delete_relief_component(component_id, schema_name);
      end if;
    end loop;
    close relief_component_cur;

    execute immediate 'delete from ' || schema_name || '.relief_feat_to_rel_comp where relief_feature_id=:1' using relief_feature_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_relief_feature (id: ' || relief_feature_rec.id || '): ' || SQLERRM);
  end;

  function delete_relief_feature(relief_feature_rec relief_feature%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_relief_feature(relief_feature_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.relief_feature where id=:1 returning id into :2' using relief_feature_rec.id, out deleted_id;
    post_delete_relief_feature(relief_feature_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_relief_feature (id: ' || relief_feature_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_relief_feature(relief_feature_rec relief_feature%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
  begin
    dummy_id := intern_delete_cityobject(relief_feature_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_relief_feature (id: ' || relief_feature_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from RELIEF_COMPONENT
  */
  procedure pre_delete_relief_component(relief_component_rec relief_component%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.relief_feat_to_rel_comp where relief_component_id=:1' using relief_component_rec.id;

    dummy_id := delete_tin_relief(relief_component_rec.id, schema_name);
    dummy_id := delete_masspoint_relief(relief_component_rec.id, schema_name);
    dummy_id := delete_breakline_relief(relief_component_rec.id, schema_name);
    dummy_id := delete_raster_relief(relief_component_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('pre_delete_relief_component (id: ' || relief_component_rec.id || '): ' || SQLERRM);
  end;

  function delete_relief_component(relief_component_rec relief_component%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_relief_component(relief_component_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.relief_component where id=:1 returning id into :2' using relief_component_rec.id, out deleted_id;
    post_delete_relief_component(relief_component_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_relief_component (id: ' || relief_component_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_relief_component(relief_component_rec relief_component%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
  begin
    dummy_id := intern_delete_cityobject(relief_component_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_relief_component (id: ' || relief_component_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TIN_RELIEF
  */
  function delete_tin_relief(tin_relief_rec tin_relief%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.tin_relief where id=:1 returning id into :2' using tin_relief_rec.id, out deleted_id;
    post_delete_tin_relief(tin_relief_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tin_relief (id: ' || tin_relief_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tin_relief(tin_relief_rec tin_relief%rowtype, schema_name varchar2 := user)
  is
    dummy_ids id_array := id_array();
  begin
    if tin_relief_rec.surface_geometry_id is not null then
      dummy_ids := intern_delete_surface_geometry(tin_relief_rec.surface_geometry_id, schema_name);
    end if;
  exception
    when others then
      dbms_output.put_line('post_delete_tin_relief (id: ' || tin_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from MASSPOINT_RELIEF
  */
  function delete_masspoint_relief(masspoint_relief_rec masspoint_relief%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.masspoint_relief where id=:1 returning id into :2' using masspoint_relief_rec.id, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_masspoint_relief (id: ' || masspoint_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BREAKLINE_RELIEF
  */
  function delete_breakline_relief(breakline_relief_rec breakline_relief%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.breakline_relief where id=:1 returning id into :2' using breakline_relief_rec.id, out deleted_id;
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_breakline_relief (id: ' || breakline_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from RASTER_RELIEF
  */
  function delete_raster_relief(raster_relief_rec raster_relief%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.raster_relief where id=:1 returning id into :2' using raster_relief_rec.id, out deleted_id;
    post_delete_raster_relief(raster_relief_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_raster_relief (id: ' || raster_relief_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_raster_relief(raster_relief_rec raster_relief%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
  begin
    dummy_id := intern_delete_grid_coverage(raster_relief_rec.coverage_id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_raster_relief (id: ' || raster_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE
  */
  procedure pre_delete_bridge(bridge_rec bridge%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    bridge_part_cur ref_cursor;
    bridge_part_rec bridge%rowtype;
    bridge_thematic_surface_cur ref_cursor;
    bridge_thematic_surface_rec bridge_thematic_surface%rowtype;
    bridge_installation_cur ref_cursor;
    bridge_installation_rec bridge_installation%rowtype;
    bridge_constr_element_cur ref_cursor;
    bridge_constr_element_rec bridge_constr_element%rowtype;
    bridge_room_cur ref_cursor;
    bridge_room_rec bridge_room%rowtype;
    address_cur ref_cursor;
    address_id number; 
  begin
    open bridge_part_cur for 'select * from ' || schema_name || '.bridge where id!=:1 and bridge_parent_id=:2' using bridge_rec.id, bridge_rec.id;
    loop
      fetch bridge_part_cur into bridge_part_rec;
      exit when bridge_part_cur%notfound;
      dummy_id := delete_bridge(bridge_part_rec, schema_name);
    end loop;
    close bridge_part_cur;

    open bridge_thematic_surface_cur for 'select * from ' || schema_name || '.bridge_thematic_surface where bridge_id=:1' using bridge_rec.id;
    loop
      fetch bridge_thematic_surface_cur into bridge_thematic_surface_rec;
      exit when bridge_thematic_surface_cur%notfound;
      dummy_id := delete_bridge_thematic_surface(bridge_thematic_surface_rec, schema_name);
    end loop;
    close bridge_thematic_surface_cur;

    open bridge_installation_cur for 'select * from ' || schema_name || '.bridge_installation where bridge_id=:1' using bridge_rec.id;
    loop
      fetch bridge_installation_cur into bridge_installation_rec;
      exit when bridge_installation_cur%notfound;
      dummy_id := delete_bridge_installation(bridge_installation_rec, schema_name);
    end loop;
    close bridge_installation_cur;

    open bridge_constr_element_cur for 'select * from ' || schema_name || '.bridge_constr_element where bridge_id=:1' using bridge_rec.id;
    loop
      fetch bridge_constr_element_cur into bridge_constr_element_rec;
      exit when bridge_constr_element_cur%notfound;
      dummy_id := delete_bridge_constr_element(bridge_constr_element_rec, schema_name);
    end loop;
    close bridge_constr_element_cur;

    open bridge_room_cur for 'select * from ' || schema_name || '.bridge_room where bridge_id=:1' using bridge_rec.id;
    loop
      fetch bridge_room_cur into bridge_room_rec;
      exit when bridge_room_cur%notfound;
      dummy_id := delete_bridge_room(bridge_room_rec, schema_name);
    end loop;
    close bridge_room_cur;

    -- delete addresses being not referenced from bridges any more
    open address_cur for 'select address_id from ' || schema_name || '.address_to_bridge where bridge_id=:1' using bridge_rec.id;
    loop
      fetch address_cur into address_id;
      exit when address_cur%notfound;
      if is_not_referenced('address_to_bridge', 'address_id', address_id, 'bridge_id', bridge_rec.id, schema_name) then 
        dummy_id := delete_address(address_id, schema_name);
      end if;
    end loop;
    close address_cur;

    execute immediate 'delete from ' || schema_name || '.address_to_bridge where bridge_id=:1' using bridge_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge (id: ' || bridge_rec.id || '): ' || SQLERRM);
  end;

  function delete_bridge(bridge_rec bridge%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_bridge(bridge_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.bridge where id=:1 returning id into :2' using bridge_rec.id, out deleted_id;
    post_delete_bridge(bridge_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge (id: ' || bridge_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge(bridge_rec bridge%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if bridge_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod1_multi_surface_id, schema_name);
    end if; 
    if bridge_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod2_multi_surface_id, schema_name);
    end if;
    if bridge_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod3_multi_surface_id, schema_name);
    end if;
    if bridge_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod4_multi_surface_id, schema_name);
    end if;

    if bridge_rec.lod1_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod1_solid_id, schema_name);
    end if; 
    if bridge_rec.lod2_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod2_solid_id, schema_name);
    end if;
    if bridge_rec.lod3_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod3_solid_id, schema_name);
    end if;
    if bridge_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_rec.lod4_solid_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(bridge_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge (id: ' || bridge_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE_THEMATIC_SURFACE
  */
  procedure pre_delete_bridge_them_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    bridge_opening_cur ref_cursor;
    bridge_opening_rec bridge_opening%rowtype;
  begin
    -- delete bridge openings not being referenced by a bridge thematic surface any more
    open bridge_opening_cur for 'select bo.* from ' || schema_name || '.bridge_opening bo, ' || schema_name || '.bridge_open_to_them_srf botm 
        where bo.id=botm.bridge_opening_id and botm.bridge_thematic_surface_id=:1' using bridge_thematic_surface_rec.id;
    loop
      fetch bridge_opening_cur into bridge_opening_rec;
      exit when bridge_opening_cur%notfound;
      if is_not_referenced('bridge_open_to_them_srf', 'bridge_opening_id', bridge_opening_rec.id, 'bridge_thematic_surface_id', bridge_thematic_surface_rec.id, schema_name) then 
        dummy_id := delete_bridge_opening(bridge_opening_rec, schema_name);
      end if;
    end loop;
    close bridge_opening_cur;

    execute immediate 'delete from ' || schema_name || '.bridge_open_to_them_srf where bridge_thematic_surface_id=:1' using bridge_thematic_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge_them_srf (id: ' || bridge_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  function delete_bridge_thematic_surface(bridge_thematic_surface_rec bridge_thematic_surface%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_bridge_them_srf(bridge_thematic_surface_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.bridge_thematic_surface where id=:1 returning id into :2' using bridge_thematic_surface_rec.id, out deleted_id;
    post_delete_bridge_them_srf(bridge_thematic_surface_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge_thematic_surface (id: ' || bridge_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_them_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if bridge_thematic_surface_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_thematic_surface_rec.lod2_multi_surface_id, schema_name);
    end if;
    if bridge_thematic_surface_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_thematic_surface_rec.lod3_multi_surface_id, schema_name);
    end if;
    if bridge_thematic_surface_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_thematic_surface_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(bridge_thematic_surface_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_them_srf (id: ' || bridge_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE_INSTALLATION
  */
  procedure pre_delete_bridge_inst(bridge_installation_rec bridge_installation%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    bridge_thematic_surface_cur ref_cursor;
    bridge_thematic_surface_rec bridge_thematic_surface%rowtype;
  begin
    open bridge_thematic_surface_cur for 'select * from ' || schema_name || '.bridge_thematic_surface where bridge_installation_id=:1' using bridge_installation_rec.id;
    loop
      fetch bridge_thematic_surface_cur into bridge_thematic_surface_rec;
      exit when bridge_thematic_surface_cur%notfound;
      dummy_id := delete_bridge_thematic_surface(bridge_thematic_surface_rec, schema_name);
    end loop;
    close bridge_thematic_surface_cur;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge_inst (id: ' || bridge_installation_rec.id || '): ' || SQLERRM);
  end;

  function delete_bridge_installation(bridge_installation_rec bridge_installation%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_bridge_inst(bridge_installation_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.bridge_installation where id=:1 returning id into :2' using bridge_installation_rec.id, out deleted_id;
    post_delete_bridge_inst(bridge_installation_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge_installation (id: ' || bridge_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_inst(bridge_installation_rec bridge_installation%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if bridge_installation_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_installation_rec.lod2_brep_id, schema_name);
    end if;
    if bridge_installation_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_installation_rec.lod3_brep_id, schema_name);
    end if;
    if bridge_installation_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_installation_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(bridge_installation_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_inst (id: ' || bridge_installation_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE_CONSTR_ELEMENT
  */
  procedure pre_delete_bridge_constr_elem(bridge_constr_element_rec bridge_constr_element%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    bridge_thematic_surface_cur ref_cursor;
    bridge_thematic_surface_rec bridge_thematic_surface%rowtype;
  begin
    open bridge_thematic_surface_cur for 'select * from ' || schema_name || '.bridge_thematic_surface where bridge_constr_element_id=:1' using bridge_constr_element_rec.id;
    loop
      fetch bridge_thematic_surface_cur into bridge_thematic_surface_rec;
      exit when bridge_thematic_surface_cur%notfound;
      dummy_id := delete_bridge_thematic_surface(bridge_thematic_surface_rec, schema_name);
    end loop;
    close bridge_thematic_surface_cur;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge_constr_elem (id: ' || bridge_constr_element_rec.id || '): ' || SQLERRM);
  end;

  function delete_bridge_constr_element(bridge_constr_element_rec bridge_constr_element%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_bridge_constr_elem(bridge_constr_element_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.bridge_constr_element where id=:1 returning id into :2' using bridge_constr_element_rec.id, out deleted_id;
    post_delete_bridge_constr_elem(bridge_constr_element_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge_constr_element (id: ' || bridge_constr_element_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_constr_elem(bridge_constr_element_rec bridge_constr_element%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if bridge_constr_element_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_constr_element_rec.lod2_brep_id, schema_name);
    end if;
    if bridge_constr_element_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_constr_element_rec.lod3_brep_id, schema_name);
    end if;
    if bridge_constr_element_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_constr_element_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(bridge_constr_element_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_constr_elem (id: ' || bridge_constr_element_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from BRIDGE_ROOM
  */
  procedure pre_delete_bridge_room(bridge_room_rec bridge_room%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    bridge_thematic_surface_cur ref_cursor;
    bridge_thematic_surface_rec bridge_thematic_surface%rowtype;
    bridge_installation_cur ref_cursor;
    bridge_installation_rec bridge_installation%rowtype;
    bridge_furniture_cur ref_cursor;
    bridge_furniture_rec bridge_furniture%rowtype;
  begin
    open bridge_thematic_surface_cur for 'select * from ' || schema_name || '.bridge_thematic_surface where bridge_room_id=:1' using bridge_room_rec.id;
    loop
      fetch bridge_thematic_surface_cur into bridge_thematic_surface_rec;
      exit when bridge_thematic_surface_cur%notfound;
      dummy_id := delete_bridge_thematic_surface(bridge_thematic_surface_rec, schema_name);
    end loop;
    close bridge_thematic_surface_cur;

    open bridge_installation_cur for 'select * from ' || schema_name || '.bridge_installation where bridge_room_id=:1' using bridge_room_rec.id;
    loop
      fetch bridge_installation_cur into bridge_installation_rec;
      exit when bridge_installation_cur%notfound;
      dummy_id := delete_bridge_installation(bridge_installation_rec, schema_name);
    end loop;
    close bridge_installation_cur;

    open bridge_furniture_cur for 'select * from ' || schema_name || '.bridge_furniture where bridge_room_id=:1' using bridge_room_rec.id;
    loop
      fetch bridge_furniture_cur into bridge_furniture_rec;
      exit when bridge_furniture_cur%notfound;
      dummy_id := delete_bridge_furniture(bridge_furniture_rec, schema_name);
    end loop;
    close bridge_furniture_cur;
   exception
    when others then
      dbms_output.put_line('pre_delete_bridge_room (id: ' || bridge_room_rec.id || '): ' || SQLERRM);
  end;

  function delete_bridge_room(bridge_room_rec bridge_room%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_bridge_room(bridge_room_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.bridge_room where id=:1 returning id into :2' using bridge_room_rec.id, out deleted_id;
    post_delete_bridge_room(bridge_room_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge_room (id: ' || bridge_room_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_room(bridge_room_rec bridge_room%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if bridge_room_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_room_rec.lod4_multi_surface_id, schema_name);
    end if;
    if bridge_room_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_room_rec.lod4_solid_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(bridge_room_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_room (id: ' || bridge_room_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from BRIDGE_FURNITURE
  */
  function delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.bridge_furniture where id=:1 returning id into :2' using bridge_furniture_rec.id, out deleted_id;
    post_delete_bridge_furniture(bridge_furniture_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge_furniture (id: ' || bridge_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if bridge_furniture_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_furniture_rec.lod4_brep_id, schema_name);
    end if;
    dummy_id := intern_delete_cityobject(bridge_furniture_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_furniture (id: ' || bridge_furniture_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from BRIDGE_OPENING
  */
  procedure pre_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype, schema_name varchar2 := user)
  is
  begin
    execute immediate 'delete from ' || schema_name || '.bridge_open_to_them_srf where bridge_opening_id=:1' using bridge_opening_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge_opening (id: ' || bridge_opening_rec.id || '): ' || SQLERRM);
  end;

  function delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_bridge_opening(bridge_opening_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.bridge_opening where id=:1 returning id into :2' using bridge_opening_rec.id, out deleted_id;
    post_delete_bridge_opening(bridge_opening_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_bridge_opening (id: ' || bridge_opening_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
    address_cur ref_cursor;
    address_id number;
  begin
    if bridge_opening_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_opening_rec.lod3_multi_surface_id, schema_name);
    end if;
    if bridge_opening_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(bridge_opening_rec.lod4_multi_surface_id, schema_name);
    end if;

    -- delete addresses not being referenced from buildings and openings any more
    open address_cur for 'select a.id from ' || schema_name || '.address a left outer join ' || schema_name || '.address_to_bridge ab
        on a.id=ab.address_id where a.id=:1 and ab.address_id is null' using bridge_opening_rec.address_id;
    loop
      fetch address_cur into address_id;
      exit when address_cur%notfound;
      if is_not_referenced('bridge_opening', 'address_id', address_id, 'id', bridge_opening_rec.id, schema_name) then
        dummy_id := delete_address(address_id, schema_name);
      end if;   
    end loop;
    close address_cur;

    dummy_id := intern_delete_cityobject(bridge_opening_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_opening (id: ' || bridge_opening_rec.id || '): ' || SQLERRM);
  end;
  
   /*
    internal: delete from TUNNEL
  */
  procedure pre_delete_tunnel(tunnel_rec tunnel%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    tunnel_part_cur ref_cursor;
    tunnel_part_rec tunnel%rowtype;
    tunnel_thematic_surface_cur ref_cursor;
    tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype;
    tunnel_installation_cur ref_cursor;
    tunnel_installation_rec tunnel_installation%rowtype;
    tunnel_hollow_space_cur ref_cursor;
    tunnel_hollow_space_rec tunnel_hollow_space%rowtype;    
  begin
    open tunnel_part_cur for 'select * from ' || schema_name || '.tunnel where id!=:1 and tunnel_parent_id=:2' using tunnel_rec.id, tunnel_rec.id;
    loop
      fetch tunnel_part_cur into tunnel_part_rec;
      exit when tunnel_part_cur%notfound;
      dummy_id := delete_tunnel(tunnel_part_rec, schema_name);
    end loop;
    close tunnel_part_cur;
    
    open tunnel_thematic_surface_cur for 'select * from ' || schema_name || '.tunnel_thematic_surface where tunnel_id=:1' using tunnel_rec.id;
    loop
      fetch tunnel_thematic_surface_cur into tunnel_thematic_surface_rec;
      exit when tunnel_thematic_surface_cur%notfound;
      dummy_id := delete_tunnel_thematic_surface(tunnel_thematic_surface_rec, schema_name);
    end loop;
    close tunnel_thematic_surface_cur;
    
    open tunnel_installation_cur for 'select * from ' || schema_name || '.tunnel_installation where tunnel_id=:1' using tunnel_rec.id;
    loop
      fetch tunnel_installation_cur into tunnel_installation_rec;
      exit when tunnel_installation_cur%notfound;
      dummy_id := delete_tunnel_installation(tunnel_installation_rec, schema_name);
    end loop;
    close tunnel_installation_cur;
    
    open tunnel_hollow_space_cur for 'select * from ' || schema_name || '.tunnel_hollow_space where tunnel_id=:1' using tunnel_rec.id;
    loop
      fetch tunnel_hollow_space_cur into tunnel_hollow_space_rec;
      exit when tunnel_hollow_space_cur%notfound;
      dummy_id := delete_tunnel_hollow_space(tunnel_hollow_space_rec, schema_name);
    end loop;
    close tunnel_hollow_space_cur;
        
  exception
    when others then
      dbms_output.put_line('pre_delete_tunnel (id: ' || tunnel_rec.id || '): ' || SQLERRM);
  end;

  function delete_tunnel(tunnel_rec tunnel%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_tunnel(tunnel_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.tunnel where id=:1 returning id into :2' using tunnel_rec.id, out deleted_id;
    post_delete_tunnel(tunnel_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tunnel (id: ' || tunnel_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel(tunnel_rec tunnel%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if tunnel_rec.lod1_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod1_multi_surface_id, schema_name);
    end if; 
    if tunnel_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod2_multi_surface_id, schema_name);
    end if;
    if tunnel_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod3_multi_surface_id, schema_name);
    end if;
    if tunnel_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod4_multi_surface_id, schema_name);
    end if;

    if tunnel_rec.lod1_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod1_solid_id, schema_name);
    end if; 
    if tunnel_rec.lod2_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod2_solid_id, schema_name);
    end if;
    if tunnel_rec.lod3_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod3_solid_id, schema_name);
    end if;
    if tunnel_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_rec.lod4_solid_id, schema_name);
    end if;
    
    dummy_id := intern_delete_cityobject(tunnel_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel (id: ' || tunnel_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL_THEMATIC_SURFACE
  */
  procedure pre_delete_tunnel_them_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    tunnel_opening_cur ref_cursor;
    tunnel_opening_rec tunnel_opening%rowtype;
  begin
    -- delete tunnel openings not being referenced by a tunnel thematic surface any more
    open tunnel_opening_cur for 'select o.* from ' || schema_name || '.tunnel_opening o, ' || schema_name || '.tunnel_open_to_them_srf otm 
        where o.id=otm.tunnel_opening_id and otm.tunnel_thematic_surface_id=:1' using tunnel_thematic_surface_rec.id;
    loop
      fetch tunnel_opening_cur into tunnel_opening_rec;
      exit when tunnel_opening_cur%notfound;
      if is_not_referenced('tunnel_open_to_them_srf', 'tunnel_opening_id', tunnel_opening_rec.id, 'tunnel_thematic_surface_id', tunnel_thematic_surface_rec.id, schema_name) then 
        dummy_id := delete_tunnel_opening(tunnel_opening_rec, schema_name);
      end if;
    end loop;
    close tunnel_opening_cur;

    execute immediate 'delete from ' || schema_name || '.tunnel_open_to_them_srf where tunnel_thematic_surface_id=:1' using tunnel_thematic_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_tunnel_them_srf (id: ' || tunnel_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  function delete_tunnel_thematic_surface(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_tunnel_them_srf(tunnel_thematic_surface_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.tunnel_thematic_surface where id=:1 returning id into :2' using tunnel_thematic_surface_rec.id, out deleted_id;
    post_delete_tunnel_them_srf(tunnel_thematic_surface_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tunnel_thematic_surface (id: ' || tunnel_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_them_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if tunnel_thematic_surface_rec.lod2_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_thematic_surface_rec.lod2_multi_surface_id, schema_name);
    end if;
    if tunnel_thematic_surface_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_thematic_surface_rec.lod3_multi_surface_id, schema_name);
    end if;
    if tunnel_thematic_surface_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_thematic_surface_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(tunnel_thematic_surface_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_them_srf (id: ' || tunnel_thematic_surface_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL_OPENING
  */
  procedure pre_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype, schema_name varchar2 := user)
  is
  begin
    execute immediate 'delete from ' || schema_name || '.tunnel_open_to_them_srf where tunnel_opening_id=:1' using tunnel_opening_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_tunnel_opening (id: ' || tunnel_opening_rec.id || '): ' || SQLERRM);
  end;

  function delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_tunnel_opening(tunnel_opening_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.tunnel_opening where id=:1 returning id into :2' using tunnel_opening_rec.id, out deleted_id;
    post_delete_tunnel_opening(tunnel_opening_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tunnel_opening (id: ' || tunnel_opening_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if tunnel_opening_rec.lod3_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_opening_rec.lod3_multi_surface_id, schema_name);
    end if;
    if tunnel_opening_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_opening_rec.lod4_multi_surface_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(tunnel_opening_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_opening (id: ' || tunnel_opening_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL_FURNITURE
  */
  function delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.tunnel_furniture where id=:1 returning id into :2' using tunnel_furniture_rec.id, out deleted_id;
    post_delete_tunnel_furniture(tunnel_furniture_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tunnel_furniture (id: ' || tunnel_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if tunnel_furniture_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_furniture_rec.lod4_brep_id, schema_name);
    end if;
    dummy_id := intern_delete_cityobject(tunnel_furniture_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_furniture (id: ' || tunnel_furniture_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TUNNEL_INSTALLATION
  */
  procedure pre_delete_tunnel_inst(tunnel_installation_rec tunnel_installation%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    tunnel_thematic_surface_cur ref_cursor;
    tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype;
  begin
    open tunnel_thematic_surface_cur for 'select * from ' || schema_name || '.tunnel_thematic_surface where tunnel_installation_id=:1' using tunnel_installation_rec.id;
    loop
      fetch tunnel_thematic_surface_cur into tunnel_thematic_surface_rec;
      exit when tunnel_thematic_surface_cur%notfound;
      dummy_id := delete_tunnel_thematic_surface(tunnel_thematic_surface_rec, schema_name);
    end loop;
    close tunnel_thematic_surface_cur;
  exception
    when others then
      dbms_output.put_line('pre_delete_tunnel_inst (id: ' || tunnel_installation_rec.id || '): ' || SQLERRM);
  end;
  
  function delete_tunnel_installation(tunnel_installation_rec tunnel_installation%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_tunnel_inst(tunnel_installation_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.tunnel_installation where id=:1 returning id into :2' using tunnel_installation_rec.id, out deleted_id;
    post_delete_tunnel_inst(tunnel_installation_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tunnel_installation (id: ' || tunnel_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_inst(tunnel_installation_rec tunnel_installation%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if tunnel_installation_rec.lod2_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_installation_rec.lod2_brep_id, schema_name);
    end if;
    if tunnel_installation_rec.lod3_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_installation_rec.lod3_brep_id, schema_name);
    end if;
    if tunnel_installation_rec.lod4_brep_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_installation_rec.lod4_brep_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(tunnel_installation_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_inst (id: ' || tunnel_installation_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TUNNEL_HOLLOW_SPACE
  */
  procedure pre_delete_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    tunnel_thematic_surface_cur ref_cursor;
    tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype;
    tunnel_installation_cur ref_cursor;
    tunnel_installation_rec tunnel_installation%rowtype;
    tunnel_furniture_cur ref_cursor;
    tunnel_furniture_rec tunnel_furniture%rowtype;
  begin
    open tunnel_thematic_surface_cur for 'select * from ' || schema_name || '.tunnel_thematic_surface where tunnel_hollow_space_id=:1' using tunnel_hollow_space_rec.id;
    loop
      fetch tunnel_thematic_surface_cur into tunnel_thematic_surface_rec;
      exit when tunnel_thematic_surface_cur%notfound;
      dummy_id := delete_tunnel_thematic_surface(tunnel_thematic_surface_rec, schema_name);
    end loop;
    close tunnel_thematic_surface_cur;
    
    open tunnel_installation_cur for 'select * from ' || schema_name || '.tunnel_installation where tunnel_hollow_space_id=:1' using tunnel_hollow_space_rec.id;
    loop
      fetch tunnel_installation_cur into tunnel_installation_rec;
      exit when tunnel_installation_cur%notfound;
      dummy_id := delete_tunnel_installation(tunnel_installation_rec, schema_name);
    end loop;
    close tunnel_installation_cur;

    open tunnel_furniture_cur for 'select * from ' || schema_name || '.tunnel_furniture where tunnel_hollow_space_id=:1' using tunnel_hollow_space_rec.id;
    loop
      fetch tunnel_furniture_cur into tunnel_furniture_rec;
      exit when tunnel_furniture_cur%notfound;
      dummy_id := delete_tunnel_furniture(tunnel_furniture_rec, schema_name);
    end loop;
    close tunnel_furniture_cur;
   exception
    when others then
      dbms_output.put_line('pre_delete_tunnel_hollow_space (id: ' || tunnel_hollow_space_rec.id || '): ' || SQLERRM);
  end;

  function delete_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    pre_delete_tunnel_hollow_space(tunnel_hollow_space_rec, schema_name);
    execute immediate 'delete from ' || schema_name || '.tunnel_hollow_space where id=:1 returning id into :2' using tunnel_hollow_space_rec.id, out deleted_id;
    post_delete_tunnel_hollowspace(tunnel_hollow_space_rec, schema_name);
    return deleted_id;
  exception
    when others then
      dbms_output.put_line('delete_tunnel_hollow_space (id: ' || tunnel_hollow_space_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_hollowspace(tunnel_hollow_space_rec tunnel_hollow_space%rowtype, schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
  begin
    if tunnel_hollow_space_rec.lod4_multi_surface_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_hollow_space_rec.lod4_multi_surface_id, schema_name);
    end if;
    if tunnel_hollow_space_rec.lod4_solid_id is not null then
      dummy_ids := intern_delete_surface_geometry(tunnel_hollow_space_rec.lod4_solid_id, schema_name);
    end if;

    dummy_id := intern_delete_cityobject(tunnel_hollow_space_rec.id, schema_name);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_hollowspace (id: ' || tunnel_hollow_space_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    PUBLIC API PROCEDURES
  */  
  function delete_surface_geometry(pid number, clean_apps int := 0, schema_name varchar2 := user) return id_array
  is
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
  begin
    deleted_ids := intern_delete_surface_geometry(pid, schema_name);

    if clean_apps <> 0 then
      dummy_ids := cleanup_appearances(0, schema_name);
    end if;

    return deleted_ids;
  exception
    when no_data_found then
      return deleted_ids;
    when others then
      dbms_output.put_line('delete_surface_geometry (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_implicit_geometry(pid number, clean_apps int := 0, schema_name varchar2 := user) return number
  is
    deleted_id number;
    dummy_ids id_array := id_array();
  begin
    deleted_id := intern_delete_implicit_geom(pid, schema_name);
    
    if clean_apps <> 0 then
      dummy_ids := cleanup_appearances(0, schema_name);
    end if;

    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_implicit_geometry (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_grid_coverage(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    deleted_id := intern_delete_grid_coverage(pid, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_grid_coverage (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_external_reference(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.external_reference where id=:1 returning id into :2' using pid, out deleted_id;
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_external_reference (id: ' || pid || '): ' || SQLERRM);
  end; 

  function delete_citymodel(pid number, delete_members int := 0, schema_name varchar2 := user) return number
  is
    deleted_id number;
    citymodel_rec citymodel%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.citymodel where id=:1'
      into citymodel_rec
      using pid;

    deleted_id := delete_citymodel(citymodel_rec, delete_members, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_citymodel (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_appearance(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    appearance_rec appearance%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.appearance where id=:1'
      into appearance_rec
      using pid;

    deleted_id := delete_appearance(appearance_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_appearance (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_surface_data(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    surface_data_rec surface_data%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.surface_data where id=:1'
      into surface_data_rec
      using pid;

    deleted_id := delete_surface_data(surface_data_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_surface_data (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_cityobjectgroup(pid number, delete_members int := 0, schema_name varchar2 := user) return number
  is
    deleted_id number;
    cityobjectgroup_rec cityobjectgroup%rowtype;
  begin
    dbms_output.put_line('delete_cityobjectgroup (id: ' || pid || ') ...');

    execute immediate 'select * from ' || schema_name || '.cityobjectgroup where id=:1'
      into cityobjectgroup_rec
      using pid;

    dbms_output.put_line('delete_cityobjectgroup(rec, delete_members, schema_name) ...');      
    deleted_id := delete_cityobjectgroup(cityobjectgroup_rec, delete_members, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      dbms_output.put_line('No record found. (Call intern_delete_cityobject instead ...)');
      deleted_id := intern_delete_cityobject(pid, schema_name);
      return deleted_id;
    when others then
      dbms_output.put_line('delete_cityobjectgroup (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_address(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
  begin
    execute immediate 'delete from ' || schema_name || '.address_to_building where address_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.address_to_bridge where address_id=:1' using pid;
    execute immediate 'update ' || schema_name || '.opening set address_id=null where address_id=:1' using pid;
    execute immediate 'update ' || schema_name || '.bridge_opening set address_id=null where address_id=:1' using pid;
    execute immediate 'delete from ' || schema_name || '.address where id=:1' using pid;
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_address (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_building(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    building_rec building%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.building where id=:1'
      into building_rec
      using pid;

    deleted_id := delete_building(building_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_building (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_thematic_surface(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    thematic_surface_rec thematic_surface%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.thematic_surface where id=:1'
      into thematic_surface_rec
      using pid;

    deleted_id := delete_thematic_surface(thematic_surface_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_thematic_surface (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_building_installation(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    building_installation_rec building_installation%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.building_installation where id=:1'
      into building_installation_rec
      using pid;

    deleted_id := delete_building_installation(building_installation_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_building_installation (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_opening(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    opening_rec opening%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.opening where id=:1'
      into opening_rec
      using pid;
    
    deleted_id := delete_opening(opening_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_opening (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_room(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    room_rec room%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.room where id=:1'
      into room_rec
      using pid;

    deleted_id := delete_room(room_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_room (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_building_furniture(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    building_furniture_rec building_furniture%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.building_furniture where id=:1'
      into building_furniture_rec
      using pid;

    deleted_id := delete_building_furniture(building_furniture_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_building_furniture (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_city_furniture(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    city_furniture_rec city_furniture%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.city_furniture where id=:1'
      into city_furniture_rec
      using pid;

    deleted_id := delete_city_furniture(city_furniture_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_city_furniture (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_generic_cityobject(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    generic_cityobject_rec generic_cityobject%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.generic_cityobject where id=:1'
      into generic_cityobject_rec
      using pid;

    deleted_id := delete_generic_cityobject(generic_cityobject_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_generic_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_land_use(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    land_use_rec land_use%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.land_use where id=:1'
      into land_use_rec
      using pid;

    deleted_id := delete_land_use(land_use_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_land_use (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_plant_cover(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    plant_cover_rec plant_cover%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.plant_cover where id=:1'
      into plant_cover_rec
      using pid;

    deleted_id := delete_plant_cover(plant_cover_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_plant_cover (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_solitary_veg_obj(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    solitary_veg_obj_rec solitary_vegetat_object%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.solitary_vegetat_object where id=:1'
      into solitary_veg_obj_rec
      using pid;

    deleted_id := delete_solitary_veg_obj(solitary_veg_obj_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_solitary_veg_obj (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_transport_complex(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    transport_complex_rec transportation_complex%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.transportation_complex where id=:1'
      into transport_complex_rec
      using pid;

    deleted_id := delete_transport_complex(transport_complex_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_transport_complex (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_traffic_area(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    traffic_area_rec traffic_area%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.traffic_area where id=:1'
      into traffic_area_rec
      using pid;

    deleted_id := delete_traffic_area(traffic_area_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_traffic_area (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_waterbody(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    waterbody_rec waterbody%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.waterbody where id=:1'
      into waterbody_rec
      using pid;

    deleted_id := delete_waterbody(waterbody_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_waterbody (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_waterbnd_surface(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    waterbnd_surface_rec waterboundary_surface%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.waterboundary_surface where id=:1'
      into waterbnd_surface_rec
      using pid;

    deleted_id := delete_waterbnd_surface(waterbnd_surface_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_waterbnd_surface (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_relief_feature(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    relief_feature_rec relief_feature%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.relief_feature where id=:1'
      into relief_feature_rec
      using pid;

    deleted_id := delete_relief_feature(relief_feature_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_relief_feature (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_relief_component(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    relief_component_rec relief_component%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.relief_component where id=:1'
      into relief_component_rec
      using pid;

    deleted_id := delete_relief_component(relief_component_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_relief_component (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_tin_relief(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tin_relief_rec tin_relief%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.tin_relief where id=:1'
      into tin_relief_rec
      using pid;

    deleted_id := delete_tin_relief(tin_relief_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tin_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_masspoint_relief(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    masspoint_relief_rec masspoint_relief%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.masspoint_relief where id=:1'
      into masspoint_relief_rec
      using pid;

    deleted_id := delete_masspoint_relief(masspoint_relief_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_masspoint_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_breakline_relief(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    breakline_relief_rec breakline_relief%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.breakline_relief where id=:1'
      into breakline_relief_rec
      using pid;

    deleted_id := delete_breakline_relief(breakline_relief_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_breakline_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_raster_relief(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    raster_relief_rec raster_relief%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.raster_relief where id=:1'
      into raster_relief_rec
      using pid;

    deleted_id := delete_raster_relief(raster_relief_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_raster_relief (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_bridge(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_rec bridge%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.bridge where id=:1'
      into bridge_rec
      using pid;

    deleted_id := delete_bridge(bridge_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_bridge_thematic_surface(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_thematic_surface_rec bridge_thematic_surface%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.bridge_thematic_surface where id=:1'
      into bridge_thematic_surface_rec
      using pid;

    deleted_id := delete_bridge_thematic_surface(bridge_thematic_surface_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge_thematic_surface (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_bridge_installation(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_installation_rec bridge_installation%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.bridge_installation where id=:1'
      into bridge_installation_rec
      using pid;

    deleted_id := delete_bridge_installation(bridge_installation_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge_installation (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_bridge_constr_element(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_constr_element_rec bridge_constr_element%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.bridge_constr_element where id=:1'
      into bridge_constr_element_rec
      using pid;

    deleted_id := delete_bridge_constr_element(bridge_constr_element_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge_constr_element (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_bridge_opening(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_opening_rec bridge_opening%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.bridge_opening where id=:1'
      into bridge_opening_rec
      using pid;
    
    deleted_id := delete_bridge_opening(bridge_opening_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge_opening (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_bridge_room(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_room_rec bridge_room%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.bridge_room where id=:1'
      into bridge_room_rec
      using pid;

    deleted_id := delete_bridge_room(bridge_room_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge_room (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_bridge_furniture(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    bridge_furniture_rec bridge_furniture%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.bridge_furniture where id=:1'
      into bridge_furniture_rec
      using pid;

    deleted_id := delete_bridge_furniture(bridge_furniture_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_bridge_furniture (id: ' || pid || '): ' || SQLERRM);
  end; 
  
  function delete_tunnel(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tunnel_rec tunnel%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.tunnel where id=:1'
      into tunnel_rec
      using pid;

    deleted_id := delete_tunnel(tunnel_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tunnel (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_tunnel_thematic_surface(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.tunnel_thematic_surface where id=:1'
      into tunnel_thematic_surface_rec
      using pid;

    deleted_id := delete_tunnel_thematic_surface(tunnel_thematic_surface_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tunnel_thematic_surface (id: ' || pid || '): ' || SQLERRM);
  end;
  
  function delete_tunnel_installation(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tunnel_installation_rec tunnel_installation%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.tunnel_installation where id=:1'
      into tunnel_installation_rec
      using pid;

    deleted_id := delete_tunnel_installation(tunnel_installation_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tunnel_installation (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_tunnel_opening(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tunnel_opening_rec tunnel_opening%rowtype;
  begin
    execute immediate 'select * from ' || schema_name || '.tunnel_opening where id=:1'
      into tunnel_opening_rec
      using pid;
    
    deleted_id := delete_tunnel_opening(tunnel_opening_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tunnel_opening (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_tunnel_hollow_space(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tunnel_hollow_space_rec tunnel_hollow_space%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.tunnel_hollow_space where id=:1'
      into tunnel_hollow_space_rec
      using pid;

    deleted_id := delete_tunnel_hollow_space(tunnel_hollow_space_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tunnel_hollow_space (id: ' || pid || '): ' || SQLERRM);
  end;

  function delete_tunnel_furniture(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    tunnel_furniture_rec tunnel_furniture%rowtype;    
  begin
    execute immediate 'select * from ' || schema_name || '.tunnel_furniture where id=:1'
      into tunnel_furniture_rec
      using pid;

    deleted_id := delete_tunnel_furniture(tunnel_furniture_rec, schema_name);
    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_tunnel_furniture (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
  cleanup functions
  */
  function cleanup_implicit_geometries(clean_apps int := 0, schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    dummy_ids id_array := id_array();
    implicit_geom_cur ref_cursor;
    implicit_geom_id number;
  begin
    open implicit_geom_cur for 'select ig.id from ' || schema_name || '.implicit_geometry ig
        left join ' || schema_name || '.BUILDING_FURNITURE bldf4 on bldf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BUILDING_INSTALLATION bldi2 on bldi2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BUILDING_INSTALLATION bldi3 on bldi3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BUILDING_INSTALLATION bldi4 on bldi4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.OPENING op3 on op3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.OPENING op4 on op4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.CITY_FURNITURE cf1 on cf1.LOD1_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.CITY_FURNITURE cf2 on cf2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.CITY_FURNITURE cf3 on cf3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.CITY_FURNITURE cf4 on cf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.GENERIC_CITYOBJECT gco0 on gco0.LOD0_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.GENERIC_CITYOBJECT gco1 on gco1.LOD1_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.GENERIC_CITYOBJECT gco2 on gco2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.GENERIC_CITYOBJECT gco3 on gco3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.GENERIC_CITYOBJECT gco4 on gco4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.SOLITARY_VEGETAT_OBJECT svo1 on svo1.LOD1_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.SOLITARY_VEGETAT_OBJECT svo2 on svo2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.SOLITARY_VEGETAT_OBJECT svo3 on svo3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.SOLITARY_VEGETAT_OBJECT svo4 on svo4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_CONSTR_ELEMENT bce1 on bce1.LOD1_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_CONSTR_ELEMENT bce2 on bce2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_CONSTR_ELEMENT bce3 on bce3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_CONSTR_ELEMENT bce4 on bce4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_FURNITURE brdf4 on brdf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_INSTALLATION brdi2 on brdi2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_INSTALLATION brdi3 on brdi3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_INSTALLATION brdi4 on brdi4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_OPENING brdo3 on brdo3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.BRIDGE_OPENING brdo4 on brdo4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.TUNNEL_FURNITURE tunf4 on tunf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.TUNNEL_INSTALLATION tuni2 on tuni2.LOD2_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.TUNNEL_INSTALLATION tuni3 on tuni3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.TUNNEL_INSTALLATION tuni4 on tuni4.LOD4_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.TUNNEL_OPENING tuno3 on tuno3.LOD3_IMPLICIT_REP_ID = ig.id
        left join ' || schema_name || '.TUNNEL_OPENING tuno4 on tuno4.LOD4_IMPLICIT_REP_ID = ig.id
        where (bldf4.LOD4_IMPLICIT_REP_ID is null) and
              (bldi2.LOD2_IMPLICIT_REP_ID is null) and
              (bldi3.LOD3_IMPLICIT_REP_ID is null) and
              (bldi4.LOD4_IMPLICIT_REP_ID is null) and
              (op3.LOD3_IMPLICIT_REP_ID is null) and
              (op4.LOD4_IMPLICIT_REP_ID is null) and
              (cf1.LOD1_IMPLICIT_REP_ID is null) and
              (cf2.LOD2_IMPLICIT_REP_ID is null) and
              (cf3.LOD3_IMPLICIT_REP_ID is null) and
              (cf4.LOD4_IMPLICIT_REP_ID is null) and
              (gco0.LOD0_IMPLICIT_REP_ID is null) and
              (gco1.LOD1_IMPLICIT_REP_ID is null) and
              (gco2.LOD2_IMPLICIT_REP_ID is null) and
              (gco3.LOD3_IMPLICIT_REP_ID is null) and
              (gco4.LOD4_IMPLICIT_REP_ID is null) and
              (svo1.LOD1_IMPLICIT_REP_ID is null) and
              (svo2.LOD2_IMPLICIT_REP_ID is null) and
              (svo3.LOD3_IMPLICIT_REP_ID is null) and
              (svo4.LOD4_IMPLICIT_REP_ID is null) and
              (bce1.LOD1_IMPLICIT_REP_ID is null) and
              (bce2.LOD2_IMPLICIT_REP_ID is null) and
              (bce3.LOD3_IMPLICIT_REP_ID is null) and
              (bce4.LOD4_IMPLICIT_REP_ID is null) and
              (brdf4.LOD4_IMPLICIT_REP_ID is null) and
              (brdi2.LOD2_IMPLICIT_REP_ID is null) and
              (brdi3.LOD3_IMPLICIT_REP_ID is null) and
              (brdi4.LOD4_IMPLICIT_REP_ID is null) and
              (brdo3.LOD3_IMPLICIT_REP_ID is null) and
              (brdo4.LOD4_IMPLICIT_REP_ID is null) and
              (tunf4.LOD4_IMPLICIT_REP_ID is null) and
              (tuni2.LOD2_IMPLICIT_REP_ID is null) and
              (tuni3.LOD3_IMPLICIT_REP_ID is null) and
              (tuni4.LOD4_IMPLICIT_REP_ID is null) and
              (tuno3.LOD3_IMPLICIT_REP_ID is null) and
              (tuno4.LOD4_IMPLICIT_REP_ID is null)';
    loop
      fetch implicit_geom_cur into implicit_geom_id;
      exit when implicit_geom_cur%notfound;
      deleted_id := intern_delete_implicit_geom(implicit_geom_id, schema_name);
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;
    end loop;
    close implicit_geom_cur;
    
    if clean_apps <> 0 then
      dummy_ids := cleanup_appearances(0, schema_name);
    end if;

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('cleanup_implicit_geometries: ' || SQLERRM);
  end;

  function cleanup_grid_coverages(schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    grid_coverage_cur ref_cursor;
    grid_coverage_id number;
  begin
    open grid_coverage_cur for 'select gc.id from ' || schema_name || '.grid_coverage gc left outer join ' || schema_name || '.raster_relief rr
        on gc.id=rr.coverage_id where rr.coverage_id is null';
    loop
      fetch grid_coverage_cur into grid_coverage_id;
      exit when grid_coverage_cur%notfound;
      execute immediate 'delete from ' || schema_name || '.grid_coverage where id=:1 returning id into :2' using grid_coverage_id, out deleted_id;
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;
    end loop;
    close grid_coverage_cur;

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('cleanup_grid_coverages: ' || SQLERRM);
  end;

  function cleanup_tex_images(schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    tex_image_cur ref_cursor;
    tex_image_id number;
  begin
    open tex_image_cur for 'select ti.id from ' || schema_name || '.tex_image ti left outer join ' || schema_name || '.surface_data sd
        on ti.id=sd.tex_image_id where sd.tex_image_id is null';
    loop
      fetch tex_image_cur into tex_image_id;
      exit when tex_image_cur%notfound;
      execute immediate 'delete from ' || schema_name || '.tex_image where id=:1 returning id into :2' using tex_image_id, out deleted_id;
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;
    end loop;
    close tex_image_cur;

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('cleanup_tex_images: ' || SQLERRM);
  end;

  function cleanup_appearances(only_global int := 1, schema_name varchar2 := user) return id_array
  is
    dummy_id number;
    dummy_ids id_array := id_array();
    deleted_id number;
    deleted_ids id_array := id_array();
    surface_data_global_cur ref_cursor;
    surface_data_global_rec surface_data%rowtype;
    appearance_cur ref_cursor;
    appearance_rec appearance%rowtype;
  begin
    -- global appearances are not related to a cityobject.
    -- however, we assume that all surface geometries of a cityobject
    -- have been deleted at this stage. thus, we can check and delete
    -- surface data which does not have a valid texture parameterization
    -- any more.
    open surface_data_global_cur for 'select s.* from ' || schema_name || '.surface_data s left outer join ' || schema_name || '.textureparam t
        on s.id=t.surface_data_id where t.surface_data_id is null';
    loop
      fetch surface_data_global_cur into surface_data_global_rec;
      exit when surface_data_global_cur%notfound;
      dummy_id := delete_surface_data(surface_data_global_rec, schema_name);
    end loop;
    close surface_data_global_cur;

    -- delete appearances which does not have surface data any more
    if only_global=1 then
      open appearance_cur for 'select a.* from ' || schema_name || '.appearance a left outer join ' || schema_name || '.appear_to_surface_data asd
        on a.id=asd.appearance_id where a.cityobject_id is null and asd.appearance_id is null';
      loop
        fetch appearance_cur into appearance_rec;
        exit when appearance_cur%notfound;
        deleted_id := delete_appearance(appearance_rec, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      end loop;
      close appearance_cur;
    else
      open appearance_cur for 'select a.* from ' || schema_name || '.appearance a left outer join ' || schema_name || '.appear_to_surface_data asd
        on a.id=asd.appearance_id where asd.appearance_id is null';
      loop
        fetch appearance_cur into appearance_rec;
        exit when appearance_cur%notfound;
        deleted_id := delete_appearance(appearance_rec, schema_name);
        deleted_ids.extend;
        deleted_ids(deleted_ids.count) := deleted_id;
      end loop;
      close appearance_cur;
    end if;

    -- cleanup texture images    
    dummy_ids := cleanup_tex_images(schema_name);

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('cleanup_appearances: ' || SQLERRM);
  end;
  
  function cleanup_addresses(schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    address_cur ref_cursor;
    add_id number;
  begin
    open address_cur for 'select ad.id from ' || schema_name || '.address ad
      left outer join ' || schema_name || '.address_to_building ad2b on ad2b.address_id = ad.id
      left outer join ' || schema_name || '.address_to_bridge ad2brd on ad2brd.address_id = ad.id
      left outer join ' || schema_name || '.opening o on o.address_id = ad.id
      left outer join ' || schema_name || '.bridge_opening brdo on brdo.address_id = ad.id
      where ad2b.building_id is null
        and ad2brd.bridge_id is null
        and o.address_id is null
        and brdo.address_id is null';
    loop
      fetch address_cur into add_id;
      exit when address_cur%notfound;
      deleted_id := delete_address(add_id, schema_name);
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;
    end loop;
    close address_cur;

    return deleted_ids;
  exception  
    when others then
      dbms_output.put_line('cleanup_addresses: ' || SQLERRM);
  end;

  function cleanup_cityobjectgroups(schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    group_cur ref_cursor;
    group_rec cityobjectgroup%rowtype;
  begin
    open group_cur for 'select g.* from ' || schema_name || '.cityobjectgroup g left outer join ' || schema_name || '.group_to_cityobject gtc
        on g.id=gtc.cityobjectgroup_id where gtc.cityobject_id is null';
    loop
      fetch group_cur into group_rec;
      exit when group_cur%notfound;
      deleted_id := delete_cityobjectgroup(group_rec, 0, schema_name);
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;
    end loop;
    close group_cur;

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('cleanup_cityobjectgroups: ' || SQLERRM);
  end;

  function cleanup_citymodels(schema_name varchar2 := user) return id_array
  is
    deleted_id number;
    deleted_ids id_array := id_array();
    citymodel_cur ref_cursor;
    citymodel_rec citymodel%rowtype;
  begin
    open citymodel_cur for 'select c.* from ' || schema_name || '.citymodel c left outer join ' || schema_name || '.cityobject_member cm
        on c.id=cm.citymodel_id where cm.cityobject_id is null';
    loop
      fetch citymodel_cur into citymodel_rec;
      exit when citymodel_cur%notfound;
      deleted_id := delete_citymodel(citymodel_rec, 0, schema_name);
      deleted_ids.extend;
      deleted_ids(deleted_ids.count) := deleted_id;
    end loop;
    close citymodel_cur;

    return deleted_ids;
  exception
    when others then
      dbms_output.put_line('cleanup_citymodel: ' || SQLERRM);
  end;
  
  -- generic function to delete any cityobject  
  function delete_cityobject(pid number, delete_members int := 0, cleanup int := 0, schema_name varchar2 := user) return number
  is
    deleted_id number;
    dummy_ids id_array := id_array();
    objectclass_id number;
    objectclass_name varchar2(256);
    object_gmlid varchar2(256);
  begin
  
    execute immediate 'select co.objectclass_id, oc.classname, co.gmlid from ' || schema_name || '.cityobject co join ' || schema_name || '.objectclass oc on (oc.id=co.objectclass_id) where co.id=:1'
      into objectclass_id, objectclass_name, object_gmlid
      using pid;

    dbms_output.put_line('delete_cityobject ([' || objectclass_name || '] id=' || pid || ', gmlid=' || object_gmlid || ')');
    
    case 
      when objectclass_id = 4 then deleted_id := delete_land_use(pid, schema_name);
      when objectclass_id = 5 then deleted_id := delete_generic_cityobject(pid, schema_name);
      when objectclass_id = 7 then deleted_id := delete_solitary_veg_obj(pid, schema_name);
      when objectclass_id = 8 then deleted_id := delete_plant_cover(pid, schema_name);
      when objectclass_id = 9 then deleted_id := delete_waterbody(pid, schema_name);
      when objectclass_id = 11 or 
           objectclass_id = 12 or 
           objectclass_id = 13 then deleted_id := delete_waterbnd_surface(pid, schema_name);
      when objectclass_id = 14 then deleted_id := delete_relief_feature(pid, schema_name);
      when objectclass_id = 16 or 
           objectclass_id = 17 or 
           objectclass_id = 18 or 
           objectclass_id = 19 then deleted_id := delete_relief_component(pid, schema_name);
      when objectclass_id = 21 then deleted_id := delete_city_furniture(pid, schema_name);
      when objectclass_id = 23 then deleted_id := delete_cityobjectgroup(pid, delete_members, schema_name);
      when objectclass_id = 25 or 
           objectclass_id = 26 then deleted_id := delete_building(pid, schema_name);
      when objectclass_id = 27 or 
           objectclass_id = 28 then deleted_id := delete_building_installation(pid, schema_name);
      when objectclass_id = 30 or 
           objectclass_id = 31 or 
           objectclass_id = 32 or 
           objectclass_id = 33 or 
           objectclass_id = 34 or 
           objectclass_id = 35 or 
           objectclass_id = 36 then deleted_id := delete_thematic_surface(pid, schema_name);
      when objectclass_id = 38 or 
           objectclass_id = 39 then deleted_id := delete_opening(pid, schema_name);
      when objectclass_id = 40 then deleted_id := delete_building_furniture(pid, schema_name);
      when objectclass_id = 41 then deleted_id := delete_room(pid, schema_name);
      when objectclass_id = 43 or 
           objectclass_id = 44 or 
           objectclass_id = 45 or 
           objectclass_id = 46 then deleted_id := delete_transport_complex(pid, schema_name);
      when objectclass_id = 47 or 
           objectclass_id = 48 then deleted_id := delete_traffic_area(pid, schema_name);
      when objectclass_id = 57 then deleted_id := delete_citymodel(pid, delete_members, schema_name);
      when objectclass_id = 60 or 
           objectclass_id = 61 then deleted_id := delete_thematic_surface(pid, schema_name);
      when objectclass_id = 63 or 
           objectclass_id = 64 then deleted_id := delete_bridge(pid, schema_name);
      when objectclass_id = 65 or 
           objectclass_id = 66 then deleted_id := delete_bridge_installation(pid, schema_name);
      when objectclass_id = 68 or 
           objectclass_id = 69 or 
           objectclass_id = 70 or 
           objectclass_id = 71 or 
           objectclass_id = 72 or 
           objectclass_id = 73 or 
           objectclass_id = 74 or 
           objectclass_id = 75 or 
           objectclass_id = 76 then deleted_id := delete_bridge_thematic_surface(pid, schema_name);
      when objectclass_id = 78 or 
           objectclass_id = 79 then deleted_id := delete_bridge_opening(pid, schema_name);
      when objectclass_id = 80 then deleted_id := delete_bridge_furniture(pid, schema_name);
      when objectclass_id = 81 then deleted_id := delete_bridge_room(pid, schema_name);
      when objectclass_id = 82 then deleted_id := delete_bridge_constr_element(pid, schema_name);
      when objectclass_id = 84 or 
           objectclass_id = 85 then deleted_id := delete_tunnel(pid, schema_name);
      when objectclass_id = 86 or 
           objectclass_id = 87 then deleted_id := delete_tunnel_installation(pid, schema_name);
      when objectclass_id = 89 or 
           objectclass_id = 90 or 
           objectclass_id = 91 or 
           objectclass_id = 92 or 
           objectclass_id = 93 or 
           objectclass_id = 94 or 
           objectclass_id = 95 or 
           objectclass_id = 96 or 
           objectclass_id = 97 then deleted_id := delete_tunnel_thematic_surface(pid, schema_name);
      when objectclass_id = 99 or 
           objectclass_id = 100 then deleted_id := delete_tunnel_opening(pid, schema_name);
      when objectclass_id = 101 then deleted_id := delete_tunnel_furniture(pid, schema_name);
      when objectclass_id = 102 then deleted_id := delete_tunnel_hollow_space(pid, schema_name);
      else
        -- do nothing
        null;
    end case;
    
    if cleanup <> 0 then
      dummy_ids := cleanup_implicit_geometries(1, schema_name);
      dummy_ids := cleanup_appearances(1, schema_name);
      dummy_ids := cleanup_citymodels(schema_name);
    end if;

    return deleted_id;
  exception
    when no_data_found then
      return deleted_id;
    when others then
      dbms_output.put_line('delete_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  -- delete a cityobject using its foreign key relations
  -- NOTE: all constraints have to be set to ON DELETE CASCADE (function: citydb_util.update_schema_constraints)
  function delete_cityobject_cascade(pid number, schema_name varchar2 := user) return number
  is
    deleted_id number;
    dummy_ids id_array := id_array();
  begin  
    -- delete cityobject and all entries from other tables referencing the cityobject_id
    execute immediate 'delete from ' || schema_name || '.cityobject where id = :1 returning id into :2' using pid, out deleted_id;

    -- cleanup
    dummy_ids := cleanup_implicit_geometries(1, schema_name);
    dummy_ids := cleanup_appearances(0, schema_name);
    dummy_ids := cleanup_grid_coverages(schema_name);	
    dummy_ids := cleanup_addresses(schema_name);
    dummy_ids := cleanup_cityobjectgroups(schema_name);
    dummy_ids := cleanup_citymodels(schema_name);

    return deleted_id;	
  exception
    when others then
      dbms_output.put_line('delete_cityobject_cascade (id: ' || pid || '): ' || SQLERRM);
  end;

  -- delete all cityobjects using their foreign key relations
  -- NOTE: all constraints have to be set to ON DELETE CASCADE (function: citydb_pkg.update_schema_constraints)
  procedure cleanup_schema(schema_name varchar2 := user)
  is
    dummy_id number;
    dummy_ids id_array := id_array();
    cityobject_cur ref_cursor;
    cityobject_id number;
    seq_value number;
  begin
    -- clear tables
    open cityobject_cur for 'select id from ' || schema_name || '.cityobject';
    loop
      fetch cityobject_cur into cityobject_id;
      exit when cityobject_cur%notfound;
      dummy_id := delete_cityobject_cascade(cityobject_id, schema_name);
    end loop;
    close cityobject_cur;

    dummy_ids := cleanup_appearances(0, schema_name);
    dummy_ids := cleanup_grid_coverages(schema_name);	
    dummy_ids := cleanup_addresses(schema_name);
    dummy_ids := cleanup_citymodels(schema_name);

    -- reset sequences
    execute immediate 'select ' || schema_name || '.address_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.address_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.address_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.address_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.address_seq increment by 1';

    execute immediate 'select ' || schema_name || '.appearance_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.appearance_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.appearance_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.appearance_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.appearance_seq increment by 1';

    execute immediate 'select ' || schema_name || '.citymodel_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.citymodel_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.citymodel_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.citymodel_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.citymodel_seq increment by 1';

    execute immediate 'select ' || schema_name || '.cityobject_genericatt_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.cityobject_genericatt_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.cityobject_genericatt_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.cityobject_genericatt_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.cityobject_genericatt_seq increment by 1';

    execute immediate 'select ' || schema_name || '.cityobject_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.cityobject_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.cityobject_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.cityobject_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.cityobject_seq increment by 1';

    execute immediate 'select ' || schema_name || '.external_ref_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.external_ref_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.external_ref_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.external_ref_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.external_ref_seq increment by 1';

    execute immediate 'select ' || schema_name || '.grid_coverage_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.grid_coverage_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.grid_coverage_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.grid_coverage_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.grid_coverage_seq increment by 1';

    execute immediate 'select ' || schema_name || '.grid_coverage_rdt_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.grid_coverage_rdt_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.grid_coverage_rdt_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.grid_coverage_rdt_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.grid_coverage_rdt_seq increment by 1';

    execute immediate 'select ' || schema_name || '.implicit_geometry_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.implicit_geometry_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.implicit_geometry_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.implicit_geometry_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.implicit_geometry_seq increment by 1';

    execute immediate 'select ' || schema_name || '.surface_data_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.surface_data_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.surface_data_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.surface_data_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.surface_data_seq increment by 1';

    execute immediate 'select ' || schema_name || '.surface_geometry_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.surface_geometry_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.surface_geometry_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.surface_geometry_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.surface_geometry_seq increment by 1';

    execute immediate 'select ' || schema_name || '.tex_image_seq.nextval from dual' into seq_value;
    if (seq_value = 1) then
      execute immediate 'select ' || schema_name || '.tex_image_seq.nextval from dual' into seq_value;
    end if;
    execute immediate 'alter sequence ' || schema_name || '.tex_image_seq increment by ' || (seq_value-1)*-1;
    execute immediate 'select ' || schema_name || '.tex_image_seq.nextval from dual';
    execute immediate 'alter sequence ' || schema_name || '.tex_image_seq increment by 1';

  exception
    when others then
      dbms_output.put_line('cleanup_schema: ' || SQLERRM);
  end;

END citydb_delete;
/