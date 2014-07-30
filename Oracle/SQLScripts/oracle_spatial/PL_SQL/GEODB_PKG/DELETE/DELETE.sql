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
-- Version | Date       | Description                               | Author
-- 2.0.0     2014-07-30   extended for 3DCityDB V3                    GHud
--                                                                    FKun
-- 1.2.0     2013-08-08   extended to all thematic classes            GHud
--                                                                    FKun
-- 1.1.0     2012-02-22   some performance improvements               CNag
-- 1.0.0     2011-02-11   release version                             CNag
--

CREATE OR REPLACE PACKAGE geodb_delete
AS
  procedure delete_surface_geometry(pid number, clean_apps int := 0);
  procedure delete_implicit_geometry(pid number);
  procedure delete_external_reference(pid number);
  procedure delete_citymodel(pid number);
  procedure delete_appearance(pid number);
  procedure delete_surface_data(pid number);
  procedure delete_cityobjectgroup(pid number);
  procedure delete_thematic_surface(pid number);
  procedure delete_opening(pid number);
  procedure delete_address(pid number);
  procedure delete_building_installation(pid number);
  procedure delete_room(pid number);
  procedure delete_building_furniture(pid number);
  procedure delete_building(pid number);
  procedure delete_city_furniture(pid number);
  procedure delete_generic_cityobject(pid number);
  procedure delete_land_use(pid number);
  procedure delete_plant_cover(pid number);
  procedure delete_solitary_veg_obj(pid number);
  procedure delete_transport_complex(pid number);
  procedure delete_traffic_area(pid number);
  procedure delete_waterbnd_surface(pid number);
  procedure delete_waterbody(pid number);
  procedure delete_relief_feature(pid number);
  procedure delete_relief_component(pid number);
  procedure delete_tin_relief(pid number);
  procedure delete_masspoint_relief(pid number);
  procedure delete_breakline_relief(pid number);
  procedure delete_raster_relief(pid number);
  procedure delete_bridge(pid number);
  procedure delete_bridge_installation(pid number);
  procedure delete_bridge_thematic_surface(pid number);
  procedure delete_bridge_opening(pid number);
  procedure delete_bridge_furniture(pid number);
  procedure delete_bridge_room(pid number);
  procedure delete_bridge_constr_element(pid number);
  procedure delete_tunnel(pid number);
  procedure delete_tunnel_installation(pid number);
  procedure delete_tunnel_thematic_surface(pid number);
  procedure delete_tunnel_opening(pid number);
  procedure delete_tunnel_furniture(pid number);
  procedure delete_tunnel_hollow_space(pid number);
  procedure cleanup_implicit_geometries;
  procedure cleanup_tex_images;
  procedure cleanup_appearances(only_global int :=1);
  procedure cleanup_addresses;
  procedure cleanup_cityobjectgroups;
  procedure cleanup_citymodels;
  procedure delete_cityobject(pid number);
  procedure delete_cityobject_cascade(pid number);
  
  function is_not_referenced(table_name varchar2, check_column varchar2, check_id number, not_column varchar2, not_id number) return boolean;
END geodb_delete;
/

CREATE OR REPLACE PACKAGE BODY geodb_delete
AS
  -- private procedures
  procedure intern_delete_surface_geometry(pid number);
  procedure intern_delete_implicit_geom(pid number);
  procedure intern_delete_grid_coverage(pid number);
  procedure intern_delete_cityobject(pid number);
  procedure delete_citymodel(citymodel_rec citymodel%rowtype);
  procedure delete_appearance(appearance_rec appearance%rowtype);
  procedure delete_surface_data(surface_data_rec surface_data%rowtype);
  procedure delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype);
  procedure delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype);
  procedure delete_opening(opening_rec opening%rowtype);
  procedure delete_building_installation(building_installation_rec building_installation%rowtype);
  procedure delete_room(room_rec room%rowtype);
  procedure delete_building_furniture(building_furniture_rec building_furniture%rowtype);
  procedure delete_building(building_rec building%rowtype);
  procedure delete_city_furniture(city_furniture_rec city_furniture%rowtype);
  procedure delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype);
  procedure delete_land_use(land_use_rec land_use%rowtype);
  procedure delete_plant_cover(plant_cover_rec plant_cover%rowtype);
  procedure delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype);
  procedure delete_traffic_area(traffic_area_rec traffic_area%rowtype);
  procedure delete_transport_complex(transport_complex_rec transportation_complex%rowtype);
  procedure delete_waterbody(waterbody_rec waterbody%rowtype);
  procedure delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype);
  procedure delete_relief_feature(relief_feature_rec relief_feature%rowtype);
  procedure delete_relief_component(relief_component_rec relief_component%rowtype);
  procedure delete_tin_relief(tin_relief_rec tin_relief%rowtype);
  procedure delete_masspoint_relief(masspoint_relief_rec masspoint_relief%rowtype);
  procedure delete_breakline_relief(breakline_relief_rec breakline_relief%rowtype);
  procedure delete_raster_relief(raster_relief_rec raster_relief%rowtype);
  procedure delete_bridge(bridge_rec bridge%rowtype);
  procedure delete_bridge_thematic_surface(bridge_thematic_surface_rec bridge_thematic_surface%rowtype);
  procedure delete_bridge_installation(bridge_installation_rec bridge_installation%rowtype);
  procedure delete_bridge_room(bridge_room_rec bridge_room%rowtype);
  procedure delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype);
  procedure delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype);
  procedure delete_bridge_constr_element(bridge_constr_element_rec bridge_constr_element%rowtype);
  procedure delete_tunnel(tunnel_rec tunnel%rowtype);
  procedure delete_tunnel_thematic_surface(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype);
  procedure delete_tunnel_installation(tunnel_installation_rec tunnel_installation%rowtype);
  procedure delete_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype);
  procedure delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype);
  procedure delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype);
  
  procedure post_delete_implicit_geom(implicit_geometry_rec implicit_geometry%rowtype);
  procedure pre_delete_cityobject(pid number);
  procedure pre_delete_citymodel(citymodel_rec citymodel%rowtype);
  procedure pre_delete_appearance(appearance_rec appearance%rowtype);
  procedure pre_delete_surface_data(surface_data_rec surface_data%rowtype);
  procedure post_delete_surface_data(surface_data_rec surface_data%rowtype);
  procedure pre_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype);
  procedure post_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype);
  procedure pre_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype);
  procedure post_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype);
  procedure pre_delete_opening(opening_rec opening%rowtype);
  procedure post_delete_opening(opening_rec opening%rowtype);
  procedure post_delete_building_inst(building_installation_rec building_installation%rowtype);
  procedure pre_delete_room(room_rec room%rowtype);
  procedure post_delete_room(room_rec room%rowtype);
  procedure post_delete_building_furniture(building_furniture_rec building_furniture%rowtype);
  procedure pre_delete_building(building_rec building%rowtype);
  procedure post_delete_building(building_rec building%rowtype);
  procedure post_delete_city_furniture(city_furniture_rec city_furniture%rowtype);
  procedure post_delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype);
  procedure post_delete_land_use(land_use_rec land_use%rowtype);
  procedure post_delete_plant_cover(plant_cover_rec plant_cover%rowtype);
  procedure post_delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype);
  procedure post_delete_traffic_area(traffic_area_rec traffic_area%rowtype);
  procedure pre_delete_transport_complex(transport_complex_rec transportation_complex%rowtype);
  procedure post_delete_transport_complex(transport_complex_rec transportation_complex%rowtype);
  procedure pre_delete_waterbody(waterbody_rec waterbody%rowtype);
  procedure post_delete_waterbody(waterbody_rec waterbody%rowtype);
  procedure pre_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype);
  procedure post_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype);
  procedure pre_delete_relief_feature(relief_feature_rec relief_feature%rowtype);
  procedure post_delete_relief_feature(relief_feature_rec relief_feature%rowtype);
  procedure pre_delete_relief_component(relief_component_rec relief_component%rowtype);
  procedure post_delete_relief_component(relief_component_rec relief_component%rowtype);
  procedure post_delete_tin_relief(tin_relief_rec tin_relief%rowtype);
  procedure post_delete_raster_relief(raster_relief_rec raster_relief%rowtype);
  procedure pre_delete_bridge(bridge_rec bridge%rowtype);
  procedure post_delete_bridge(bridge_rec bridge%rowtype);
  procedure pre_del_bridge_thematic_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype);
  procedure post_del_bridge_thematic_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype);
  procedure post_delete_bridge_inst(bridge_installation_rec bridge_installation%rowtype);
  procedure post_del_bridge_constr_element(bridge_constr_element_rec bridge_constr_element%rowtype);
  procedure pre_delete_bridge_room(bridge_room_rec bridge_room%rowtype);
  procedure post_delete_bridge_room(bridge_room_rec bridge_room%rowtype);
  procedure post_delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype);
  procedure pre_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype);
  procedure post_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype);
  procedure pre_delete_tunnel(tunnel_rec tunnel%rowtype);
  procedure post_delete_tunnel(tunnel_rec tunnel%rowtype);
  procedure pre_del_tunnel_thematic_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype);
  procedure post_del_tunnel_thematic_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype);
  procedure post_delete_tunnel_inst(tunnel_installation_rec tunnel_installation%rowtype);
  procedure pre_del_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype);
  procedure post_del_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype);
  procedure post_delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype);
  procedure pre_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype);
  procedure post_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype);

  
  type ref_cursor is ref cursor;

  /*
    internal helpers
  */
  function is_not_referenced(table_name varchar2, check_column varchar2, check_id number, not_column varchar2, not_id number) return boolean
  is
    ref_cur ref_cursor;
    dummy number;
    is_not_referenced boolean;
  begin
    open ref_cur for 'select 1 from ' || table_name || ' where ' || check_column || '=:1 and not ' || not_column || '=:2' using check_id, not_id;
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
  procedure intern_delete_surface_geometry(pid number)
  is
    cursor geom_cur is
      select id from surface_geometry start with id=pid connect by prior id=parent_id order by level desc;
  begin
    for rec in geom_cur loop
      execute immediate 'delete from textureparam where surface_geometry_id=:1' using rec.id;
      execute immediate 'delete from surface_geometry where id=:1' using rec.id; 
    end loop;
  exception
    when others then
      dbms_output.put_line('intern_delete_surface_geometry (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from IMPLICIT_GEOMETRY
  */
  procedure intern_delete_implicit_geom(pid number)
  is
    implicit_geometry_rec implicit_geometry%rowtype;
  begin
    execute immediate 'select * from implicit_geometry where id=:1'
      into implicit_geometry_rec
      using pid;

    execute immediate 'delete from implicit_geometry where id=:1' using pid;
    post_delete_implicit_geom(implicit_geometry_rec);
  exception
    when others then
      dbms_output.put_line('intern_delete_implicit_geom (id: ' || pid || '): ' || SQLERRM);
  end; 

  procedure post_delete_implicit_geom(implicit_geometry_rec implicit_geometry%rowtype)
  is
  begin
    if implicit_geometry_rec.relative_brep_id is not null then
      intern_delete_surface_geometry(implicit_geometry_rec.relative_brep_id);
    end if;
  exception
    when others then
      dbms_output.put_line('post_delete_implicit_geom (id: ' || implicit_geometry_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from GRID_COVERAGE
  */
  procedure intern_delete_grid_coverage(pid number)
  is
  begin
    execute immediate 'delete from grid_coverage where id=:1' using pid;
  exception
    when others then
      dbms_output.put_line('intern_delete_grid_coverage (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITY_OBJECT
  */
  procedure pre_delete_cityobject(pid number)
  is
    cursor appearance_cur is
      select * from appearance where cityobject_id=pid;      
  begin   
    execute immediate 'delete from cityobject_member where cityobject_id=:1' using pid;
    execute immediate 'delete from group_to_cityobject where cityobject_id=:1' using pid;
    execute immediate 'delete from generalization where generalizes_to_id=:1' using pid;
    execute immediate 'delete from generalization where cityobject_id=:1' using pid;
    execute immediate 'delete from external_reference where cityobject_id=:1' using pid;
    execute immediate 'delete from cityobject_genericattrib where cityobject_id=:1' using pid;
    execute immediate 'update cityobjectgroup set parent_cityobject_id=null where parent_cityobject_id=:1' using pid;

    for rec in appearance_cur loop
      delete_appearance(rec);
    end loop;
  exception
    when others then
      dbms_output.put_line('pre_delete_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure intern_delete_cityobject(pid number)
  is
  begin
    pre_delete_cityobject(pid);
    execute immediate 'delete from cityobject where id=:1' using pid;
  exception
    when others then
      dbms_output.put_line('intern_delete_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITYMODEL
  */
  procedure pre_delete_citymodel(citymodel_rec citymodel%rowtype)
  is
    cursor appearance_cur is
      select * from appearance where cityobject_id=citymodel_rec.id;
  begin
    -- TODO
    -- delete contained cityobjects!

    execute immediate 'delete from cityobject_member where citymodel_id=:1' using citymodel_rec.id;

    for rec in appearance_cur loop
      delete_appearance(rec);
    end loop;
  exception
    when others then
      dbms_output.put_line('pre_delete_citymodel (id: ' || citymodel_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_citymodel(citymodel_rec citymodel%rowtype)
  is
  begin
    pre_delete_citymodel(citymodel_rec);
    execute immediate 'delete from citymodel where id=:1' using citymodel_rec.id;
  exception
    when others then
      dbms_output.put_line('delete_citymodel (id: ' || citymodel_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from APPEARANCE
  */
  procedure pre_delete_appearance(appearance_rec appearance%rowtype)
  is
    cursor surface_data_cur is
      select s.* from surface_data s, appear_to_surface_data ats
        where s.id=ats.surface_data_id and ats.appearance_id=appearance_rec.id;
  begin
    -- delete surface data not being referenced by appearances any more
    for rec in surface_data_cur loop
      if is_not_referenced('appear_to_surface_data', 'surface_data_id', rec.id, 'appearance_id', appearance_rec.id) then 
        delete_surface_data(rec);
      end if;
    end loop;

    execute immediate 'delete from appear_to_surface_data where appearance_id=:1' using appearance_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_appearance (id: ' || appearance_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_appearance(appearance_rec appearance%rowtype)
  is
  begin
    pre_delete_appearance(appearance_rec);
    execute immediate 'delete from appearance where id=:1' using appearance_rec.id;
  exception
    when others then
      dbms_output.put_line('delete_appearance (id: ' || appearance_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from SURFACE_DATA
  */
  procedure pre_delete_surface_data(surface_data_rec surface_data%rowtype)
  is
  begin
      execute immediate 'delete from appear_to_surface_data where surface_data_id=:1' using surface_data_rec.id;
      execute immediate 'delete from textureparam where surface_data_id=:1' using surface_data_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_surface_data (id: ' || surface_data_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_surface_data(surface_data_rec surface_data%rowtype)
  is
  begin
    pre_delete_surface_data(surface_data_rec);
    execute immediate 'delete from surface_data where id=:1' using surface_data_rec.id;
    post_delete_surface_data(surface_data_rec);
  exception
    when others then
      dbms_output.put_line('delete_surface_data (id: ' || surface_data_rec.id || '): ' || SQLERRM);
  end;
  
  procedure post_delete_surface_data(surface_data_rec surface_data%rowtype)
  is
  begin
    null;
  exception
    when others then
      dbms_output.put_line('post_delete_surface_data (id: ' || surface_data_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITYOBJECTGROUP
  */
  procedure pre_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype)
  is
  begin
    execute immediate 'delete from group_to_cityobject where cityobjectgroup_id=:1' using cityobjectgroup_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_cityobjectgroup (id: ' || cityobjectgroup_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype)
  is
  begin
    pre_delete_cityobjectgroup(cityobjectgroup_rec);
    execute immediate 'delete from cityobjectgroup where id=:1' using cityobjectgroup_rec.id;
    post_delete_cityobjectgroup(cityobjectgroup_rec);      
    exception
    when others then
      dbms_output.put_line('delete_cityobjectgroup (id: ' || cityobjectgroup_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_cityobjectgroup(cityobjectgroup_rec cityobjectgroup%rowtype)
  is
  begin
    if cityobjectgroup_rec.brep_id is not null then
      intern_delete_surface_geometry(cityobjectgroup_rec.brep_id);
    end if;  

    intern_delete_cityobject(cityobjectgroup_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_cityobjectgroup (id: ' || cityobjectgroup_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from THEMATIC_SURFACE
  */
  procedure pre_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype)
  is
    cursor opening_cur is
      select o.* from opening o, opening_to_them_surface otm 
        where o.id=otm.opening_id and otm.thematic_surface_id=thematic_surface_rec.id;
  begin
    -- delete openings not being referenced by a thematic surface any more
    for rec in opening_cur loop
      if is_not_referenced('opening_to_them_surface', 'opening_id', rec.id, 'thematic_surface_id', thematic_surface_rec.id) then 
        delete_opening(rec);
      end if;
    end loop;

    execute immediate 'delete from opening_to_them_surface where thematic_surface_id=:1' using thematic_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_thematic_surface (id: ' || thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype)
  is
  begin
    pre_delete_thematic_surface(thematic_surface_rec);
    execute immediate 'delete from thematic_surface where id=:1' using thematic_surface_rec.id;
    post_delete_thematic_surface(thematic_surface_rec);
  exception
    when others then
      dbms_output.put_line('delete_thematic_surface (id: ' || thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_thematic_surface(thematic_surface_rec thematic_surface%rowtype)
  is
  begin
    if thematic_surface_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(thematic_surface_rec.lod2_multi_surface_id);
    end if;
    if thematic_surface_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(thematic_surface_rec.lod3_multi_surface_id);
    end if;
    if thematic_surface_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(thematic_surface_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(thematic_surface_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_thematic_surface (id: ' || thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from OPENING
  */
  procedure pre_delete_opening(opening_rec opening%rowtype)
  is
  begin
    execute immediate 'delete from opening_to_them_surface where opening_id=:1' using opening_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_opening (id: ' || opening_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_opening(opening_rec opening%rowtype)
  is
  begin
    pre_delete_opening(opening_rec);
    execute immediate 'delete from opening where id=:1' using opening_rec.id;
    post_delete_opening(opening_rec);
  exception
    when others then
      dbms_output.put_line('delete_opening (id: ' || opening_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_opening(opening_rec opening%rowtype)
  is
    cursor address_cur is
      select a.id from address a left outer join address_to_building ab
        on a.id=ab.address_id where a.id=opening_rec.address_id and ab.address_id is null;
  begin
    if opening_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(opening_rec.lod3_multi_surface_id);
    end if;
    if opening_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(opening_rec.lod4_multi_surface_id);
    end if;

    -- delete addresses not being referenced from buildings and openings any more
    for rec in address_cur loop
      if is_not_referenced('opening', 'address_id', rec.id, 'id', opening_rec.id) then
        delete_address(rec.id);
      end if;   
    end loop;

    intern_delete_cityobject(opening_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_opening (id: ' || opening_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BUILDING_INSTALLATION
  */
  procedure delete_building_installation(building_installation_rec building_installation%rowtype)
  is
  begin
    execute immediate 'delete from building_installation where id=:1' using building_installation_rec.id;
    post_delete_building_inst(building_installation_rec);
  exception
    when others then
      dbms_output.put_line('delete_building_installation (id: ' || building_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_building_inst(building_installation_rec building_installation%rowtype)
  is
  begin
    if building_installation_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(building_installation_rec.lod2_brep_id);
    end if;
    if building_installation_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(building_installation_rec.lod3_brep_id);
    end if;
    if building_installation_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(building_installation_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(building_installation_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_building_inst (id: ' || building_installation_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from ROOM
  */
  procedure pre_delete_room(room_rec room%rowtype)
  is
    cursor thematic_surface_cur is
      select * from thematic_surface where room_id=room_rec.id;

    cursor building_installation_cur is
      select * from building_installation where room_id=room_rec.id;

    cursor building_furniture_cur is
      select * from building_furniture where room_id=room_rec.id;
  begin
    for rec in thematic_surface_cur loop
      delete_thematic_surface(rec);
    end loop;

    for rec in building_installation_cur loop
      delete_building_installation(rec);
    end loop;

    for rec in building_furniture_cur loop
      delete_building_furniture(rec);
    end loop;
   exception
    when others then
      dbms_output.put_line('pre_delete_room (id: ' || room_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_room(room_rec room%rowtype)
  is
  begin
    pre_delete_room(room_rec);
    execute immediate 'delete from room where id=:1' using room_rec.id;
    post_delete_room(room_rec);
  exception
    when others then
      dbms_output.put_line('delete_room (id: ' || room_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_room(room_rec room%rowtype)
  is
  begin
    if room_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(room_rec.lod4_multi_surface_id);
    end if;
    if room_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(room_rec.lod4_solid_id);
    end if;

    intern_delete_cityobject(room_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_room (id: ' || room_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BUILDING_FURNITURE
  */
  procedure delete_building_furniture(building_furniture_rec building_furniture%rowtype)
  is
  begin
    execute immediate 'delete from building_furniture where id=:1' using building_furniture_rec.id;
    post_delete_building_furniture(building_furniture_rec);
  exception
    when others then
      dbms_output.put_line('delete_building_furniture (id: ' || building_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_building_furniture(building_furniture_rec building_furniture%rowtype)
  is
  begin
    if building_furniture_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(building_furniture_rec.lod4_brep_id);
    end if;
    intern_delete_cityobject(building_furniture_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_building_furniture (id: ' || building_furniture_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BUILDING
  */
  procedure pre_delete_building(building_rec building%rowtype)
  is    
    cursor building_part_cur is
      select * from building where id!=building_rec.id and building_parent_id=building_rec.id;
    
    cursor thematic_surface_cur is
      select * from thematic_surface where building_id=building_rec.id;
    
    cursor building_installation_cur is
      select * from building_installation where building_id=building_rec.id;
      
    cursor room_cur is
      select * from room where building_id=building_rec.id;
    
    cursor address_cur is
      select address_id from address_to_building where building_id=building_rec.id;
  begin
    for rec in building_part_cur loop
      delete_building(rec);
    end loop;
    
    for rec in thematic_surface_cur loop
      delete_thematic_surface(rec);
    end loop;
    
    for rec in building_installation_cur loop
      delete_building_installation(rec);
    end loop;
    
    for rec in room_cur loop
      delete_room(rec);
    end loop;
        
    -- delete addresses being not referenced from buildings any more
    for rec in address_cur loop
      if is_not_referenced('address_to_building', 'address_id', rec.address_id, 'building_id', building_rec.id) then 
        delete_address(rec.address_id);
      end if;
    end loop;
    
    execute immediate 'delete from address_to_building where building_id=:1' using building_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_building (id: ' || building_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_building(building_rec building%rowtype)
  is
  begin
    pre_delete_building(building_rec);
    execute immediate 'delete from building where id=:1' using building_rec.id;
    post_delete_building(building_rec);
  exception
    when others then
      dbms_output.put_line('delete_building (id: ' || building_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_building(building_rec building%rowtype)
  is
  begin
    if building_rec.lod0_footprint_id is not null then
      intern_delete_surface_geometry(building_rec.lod0_footprint_id);
    end if; 
    if building_rec.lod0_roofprint_id is not null then
      intern_delete_surface_geometry(building_rec.lod0_roofprint_id);
    end if;
  
    if building_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(building_rec.lod1_multi_surface_id);
    end if; 
    if building_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(building_rec.lod2_multi_surface_id);
    end if;
    if building_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(building_rec.lod3_multi_surface_id);
    end if;
    if building_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(building_rec.lod4_multi_surface_id);
    end if;

    if building_rec.lod1_solid_id is not null then
      intern_delete_surface_geometry(building_rec.lod1_solid_id);
    end if; 
    if building_rec.lod2_solid_id is not null then
      intern_delete_surface_geometry(building_rec.lod2_solid_id);
    end if;
    if building_rec.lod3_solid_id is not null then
      intern_delete_surface_geometry(building_rec.lod3_solid_id);
    end if;
    if building_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(building_rec.lod4_solid_id);
    end if;
    
    intern_delete_cityobject(building_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_building (id: ' || building_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from CITY_FURNITURE
  */
  procedure delete_city_furniture(city_furniture_rec city_furniture%rowtype)
  is
  begin
    execute immediate 'delete from city_furniture where id=:1' using city_furniture_rec.id;
    post_delete_city_furniture(city_furniture_rec);
  exception
    when others then
      dbms_output.put_line('delete_city_furniture (id: ' || city_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_city_furniture(city_furniture_rec city_furniture%rowtype)
  is
  begin
    if city_furniture_rec.lod1_brep_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod1_brep_id);
    end if; 
    if city_furniture_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod2_brep_id);
    end if;
    if city_furniture_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod3_brep_id);
    end if;
    if city_furniture_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(city_furniture_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_city_furniture (id: ' || city_furniture_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from GENERIC_CITYOBJECT
  */
  procedure delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype)
  is
  begin
    execute immediate 'delete from generic_cityobject where id=:1' using generic_cityobject_rec.id;
    post_delete_generic_cityobject(generic_cityobject_rec);
  exception
    when others then
      dbms_output.put_line('delete_generic_cityobject (id: ' || generic_cityobject_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_generic_cityobject(generic_cityobject_rec generic_cityobject%rowtype)
  is
  begin
    if generic_cityobject_rec.lod0_brep_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod0_brep_id);
    end if; 
    if generic_cityobject_rec.lod1_brep_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod1_brep_id);
    end if; 
    if generic_cityobject_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod2_brep_id);
    end if;
    if generic_cityobject_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod3_brep_id);
    end if;
    if generic_cityobject_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(generic_cityobject_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_generic_cityobject (id: ' || generic_cityobject_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from LAND_USE
  */
  procedure delete_land_use(land_use_rec land_use%rowtype)
  is
  begin
    execute immediate 'delete from land_use where id=:1' using land_use_rec.id;
    post_delete_land_use(land_use_rec);
  exception
    when others then
      dbms_output.put_line('delete_land_use (id: ' || land_use_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_land_use(land_use_rec land_use%rowtype)
  is
  begin
    if land_use_rec.lod0_multi_surface_id is not null then
      intern_delete_surface_geometry(land_use_rec.lod0_multi_surface_id);
    end if; 
    if land_use_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(land_use_rec.lod1_multi_surface_id);
    end if; 
    if land_use_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(land_use_rec.lod2_multi_surface_id);
    end if;
    if land_use_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(land_use_rec.lod3_multi_surface_id);
    end if;
    if land_use_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(land_use_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(land_use_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_land_use (id: ' || land_use_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from PLANT_COVER
  */
  procedure delete_plant_cover(plant_cover_rec plant_cover%rowtype)
  is
  begin
    execute immediate 'delete from plant_cover where id=:1' using plant_cover_rec.id;
    post_delete_plant_cover(plant_cover_rec);
  exception
    when others then
      dbms_output.put_line('delete_plant_cover (id: ' || plant_cover_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_plant_cover(plant_cover_rec plant_cover%rowtype)
  is
  begin
    if plant_cover_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod1_multi_surface_id);
    end if; 
    if plant_cover_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod2_multi_surface_id);
    end if;
    if plant_cover_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod3_multi_surface_id);
    end if;
    if plant_cover_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod4_multi_surface_id);
    end if;

    if plant_cover_rec.lod1_multi_solid_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod1_multi_solid_id);
    end if; 
    if plant_cover_rec.lod2_multi_solid_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod2_multi_solid_id);
    end if;
    if plant_cover_rec.lod3_multi_solid_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod3_multi_solid_id);
    end if;
    if plant_cover_rec.lod4_multi_solid_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod4_multi_solid_id);
    end if;
    
    intern_delete_cityobject(plant_cover_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_plant_cover (id: ' || plant_cover_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from SOLITARY_VEGETAT_OBJECT
  */
  procedure delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype)
  is
  begin
    execute immediate 'delete from solitary_vegetat_object where id=:1' using solitary_veg_obj_rec.id;
    post_delete_solitary_veg_obj(solitary_veg_obj_rec);
  exception
    when others then
      dbms_output.put_line('delete_solitary_veg_obj (id: ' || solitary_veg_obj_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_solitary_veg_obj(solitary_veg_obj_rec solitary_vegetat_object%rowtype)
  is
  begin
    if solitary_veg_obj_rec.lod1_brep_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod1_brep_id);
    end if; 
    if solitary_veg_obj_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod2_brep_id);
    end if;
    if solitary_veg_obj_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod3_brep_id);
    end if;
    if solitary_veg_obj_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(solitary_veg_obj_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_solitary_veg_obj (id: ' || solitary_veg_obj_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TRAFFIC_AREA
  */
  procedure delete_traffic_area(traffic_area_rec traffic_area%rowtype)
  is
  begin
    execute immediate 'delete from traffic_area where id=:1' using traffic_area_rec.id;
    post_delete_traffic_area(traffic_area_rec);
  exception
    when others then
      dbms_output.put_line('delete_traffic_area (id: ' || traffic_area_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_traffic_area(traffic_area_rec traffic_area%rowtype)
  is
  begin
    if traffic_area_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(traffic_area_rec.lod2_multi_surface_id);
    end if;
    if traffic_area_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(traffic_area_rec.lod3_multi_surface_id);
    end if;
    if traffic_area_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(traffic_area_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(traffic_area_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_traffic_area (id: ' || traffic_area_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TRANSPORTATION_COMPLEX
  */
  procedure pre_delete_transport_complex(transport_complex_rec transportation_complex%rowtype)
  is    
    cursor traffic_area_cur is
      select * from traffic_area where transportation_complex_id=transport_complex_rec.id;
  begin
    for rec in traffic_area_cur loop
      delete_traffic_area(rec);
    end loop;

  exception
    when others then
      dbms_output.put_line('pre_delete_transport_complex (id: ' || transport_complex_rec.id || '): ' || SQLERRM);
  end;
  
  procedure delete_transport_complex(transport_complex_rec transportation_complex%rowtype)
  is
  begin
    pre_delete_transport_complex(transport_complex_rec);
    execute immediate 'delete from transportation_complex where id=:1' using transport_complex_rec.id;
    post_delete_transport_complex(transport_complex_rec);
  exception
    when others then
      dbms_output.put_line('delete_transport_complex (id: ' || transport_complex_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_transport_complex(transport_complex_rec transportation_complex%rowtype)
  is
  begin
    if transport_complex_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(transport_complex_rec.lod1_multi_surface_id);
    end if; 
    if transport_complex_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(transport_complex_rec.lod2_multi_surface_id);
    end if;
    if transport_complex_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(transport_complex_rec.lod3_multi_surface_id);
    end if;
    if transport_complex_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(transport_complex_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(transport_complex_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_transport_complex (id: ' || transport_complex_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from WATERBODY
  */
  procedure pre_delete_waterbody(waterbody_rec waterbody%rowtype)
  is    
    cursor waterbnd_surface_cur is
      select waterboundary_surface_id from waterbod_to_waterbnd_srf where waterbody_id=waterbody_rec.id;
  begin
    -- delete water boundary surface being not referenced from waterbodies any more
    for rec in waterbnd_surface_cur loop
      if is_not_referenced('waterbod_to_waterbnd_srf', 'waterboundary_surface_id', rec.waterboundary_surface_id, 'waterbody_id', waterbody_rec.id) then 
        delete_waterbnd_surface(rec.waterboundary_surface_id);
      end if;
    end loop;

    execute immediate 'delete from waterbod_to_waterbnd_srf where waterbody_id=:1' using waterbody_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_waterbody (id: ' || waterbody_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_waterbody(waterbody_rec waterbody%rowtype)
  is
  begin
    pre_delete_waterbody(waterbody_rec);
    execute immediate 'delete from waterbody where id=:1' using waterbody_rec.id;
    post_delete_waterbody(waterbody_rec);
  exception
    when others then
      dbms_output.put_line('delete_waterbody (id: ' || waterbody_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_waterbody(waterbody_rec waterbody%rowtype)
  is
  begin
    if waterbody_rec.lod1_solid_id is not null then
      intern_delete_surface_geometry(waterbody_rec.lod1_solid_id);
    end if; 
    if waterbody_rec.lod2_solid_id is not null then
      intern_delete_surface_geometry(waterbody_rec.lod2_solid_id);
    end if;
    if waterbody_rec.lod3_solid_id is not null then
      intern_delete_surface_geometry(waterbody_rec.lod3_solid_id);
    end if;
    if waterbody_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(waterbody_rec.lod4_solid_id);
    end if;
    if waterbody_rec.lod0_multi_surface_id is not null then
      intern_delete_surface_geometry(waterbody_rec.lod0_multi_surface_id);
    end if;
    if waterbody_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(waterbody_rec.lod1_multi_surface_id);
    end if;

    intern_delete_cityobject(waterbody_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_waterbody (id: ' || waterbody_rec.id || '): ' || SQLERRM);
  end;

  procedure pre_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype)
  is
  begin
    execute immediate 'delete from waterbod_to_waterbnd_srf where waterboundary_surface_id=:1' using waterbnd_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_waterbnd_surface (id: ' || waterbnd_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype)
  is
  begin
    pre_delete_waterbnd_surface(waterbnd_surface_rec);
    execute immediate 'delete from waterboundary_surface where id=:1' using waterbnd_surface_rec.id;
    post_delete_waterbnd_surface(waterbnd_surface_rec);
  exception
    when others then
      dbms_output.put_line('delete_waterbnd_surface (id: ' || waterbnd_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_waterbnd_surface(waterbnd_surface_rec waterboundary_surface%rowtype)
  is
  begin
    if waterbnd_surface_rec.lod2_surface_id is not null then
      intern_delete_surface_geometry(waterbnd_surface_rec.lod2_surface_id);
    end if;
    if waterbnd_surface_rec.lod3_surface_id is not null then
      intern_delete_surface_geometry(waterbnd_surface_rec.lod3_surface_id);
    end if;
    if waterbnd_surface_rec.lod4_surface_id is not null then
      intern_delete_surface_geometry(waterbnd_surface_rec.lod4_surface_id);
    end if;

    intern_delete_cityobject(waterbnd_surface_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_waterbnd_surface (id: ' || waterbnd_surface_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from RELIEF_FEATURE
  */
  procedure pre_delete_relief_feature(relief_feature_rec relief_feature%rowtype)
  is    
    cursor relief_component_cur is
      select relief_component_id from relief_feat_to_rel_comp where relief_feature_id=relief_feature_rec.id;
  begin
    -- delete relief component being not referenced from relief fetaures any more
    for rec in relief_component_cur loop
      if is_not_referenced('relief_feat_to_rel_comp', 'relief_component_id', rec.relief_component_id, 'relief_feature_id', relief_feature_rec.id) then 
        delete_relief_component(rec.relief_component_id);
      end if;
    end loop;

    execute immediate 'delete from relief_feat_to_rel_comp where relief_feature_id=:1' using relief_feature_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_relief_feature (id: ' || relief_feature_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_relief_feature(relief_feature_rec relief_feature%rowtype)
  is
  begin
    pre_delete_relief_feature(relief_feature_rec);
    execute immediate 'delete from relief_feature where id=:1' using relief_feature_rec.id;
    post_delete_relief_feature(relief_feature_rec);
  exception
    when others then
      dbms_output.put_line('delete_relief_feature (id: ' || relief_feature_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_relief_feature(relief_feature_rec relief_feature%rowtype)
  is
  begin
    intern_delete_cityobject(relief_feature_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_relief_feature (id: ' || relief_feature_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from RELIEF_COMPONENT
  */
  procedure pre_delete_relief_component(relief_component_rec relief_component%rowtype)
  is    
  begin
    execute immediate 'delete from relief_feat_to_rel_comp where relief_component_id=:1' using relief_component_rec.id;

    delete_tin_relief(relief_component_rec.id);
    delete_masspoint_relief(relief_component_rec.id);
    delete_breakline_relief(relief_component_rec.id);
    delete_raster_relief(relief_component_rec.id);
  exception
    when others then
      dbms_output.put_line('pre_delete_relief_component (id: ' || relief_component_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_relief_component(relief_component_rec relief_component%rowtype)
  is
  begin
    pre_delete_relief_component(relief_component_rec);
    execute immediate 'delete from relief_component where id=:1' using relief_component_rec.id;
    post_delete_relief_component(relief_component_rec);
  exception
    when others then
      dbms_output.put_line('delete_relief_component (id: ' || relief_component_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_relief_component(relief_component_rec relief_component%rowtype)
  is
  begin
    intern_delete_cityobject(relief_component_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_relief_component (id: ' || relief_component_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TIN_RELIEF
  */
  procedure delete_tin_relief(tin_relief_rec tin_relief%rowtype)
  is
  begin
    execute immediate 'delete from tin_relief where id=:1' using tin_relief_rec.id;
    post_delete_tin_relief(tin_relief_rec);    
  exception
    when others then
      dbms_output.put_line('delete_tin_relief (id: ' || tin_relief_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tin_relief(tin_relief_rec tin_relief%rowtype)
  is
  begin
    if tin_relief_rec.surface_geometry_id is not null then
      intern_delete_surface_geometry(tin_relief_rec.surface_geometry_id);
    end if;
  exception
    when others then
      dbms_output.put_line('post_delete_tin_relief (id: ' || tin_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from MASSPOINT_RELIEF
  */
  procedure delete_masspoint_relief(masspoint_relief_rec masspoint_relief%rowtype)
  is
  begin
    execute immediate 'delete from masspoint_relief where id=:1' using masspoint_relief_rec.id;

  exception
    when others then
      dbms_output.put_line('delete_masspoint_relief (id: ' || masspoint_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BREAKLINE_RELIEF
  */
  procedure delete_breakline_relief(breakline_relief_rec breakline_relief%rowtype)
  is
  begin
    execute immediate 'delete from breakline_relief where id=:1' using breakline_relief_rec.id;

  exception
    when others then
      dbms_output.put_line('delete_breakline_relief (id: ' || breakline_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from RASTER_RELIEF
  */
  procedure delete_raster_relief(raster_relief_rec raster_relief%rowtype)
  is
  begin
    execute immediate 'delete from raster_relief where id=:1' using raster_relief_rec.id;
    post_delete_raster_relief(raster_relief_rec);
  exception
    when others then
      dbms_output.put_line('delete_raster_relief (id: ' || raster_relief_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_raster_relief(raster_relief_rec raster_relief%rowtype)
  is
  begin
    intern_delete_grid_coverage(raster_relief_rec.coverage_id);
  exception
    when others then
      dbms_output.put_line('post_delete_raster_relief (id: ' || raster_relief_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE
  */
  procedure pre_delete_bridge(bridge_rec bridge%rowtype)
  is    
    cursor bridge_part_cur is
      select * from bridge where id!=bridge_rec.id and bridge_parent_id=bridge_rec.id;
    
    cursor bridge_thematic_surface_cur is
      select * from bridge_thematic_surface where bridge_id=bridge_rec.id;
    
    cursor bridge_installation_cur is
      select * from bridge_installation where bridge_id=bridge_rec.id;
      
    cursor bridge_constr_element_cur is
      select * from bridge_constr_element where bridge_id=bridge_rec.id;
      
    cursor bridge_room_cur is
      select * from bridge_room where bridge_id=bridge_rec.id;
    
    cursor address_cur is
      select address_id from address_to_bridge where bridge_id=bridge_rec.id;
  begin
    for rec in bridge_part_cur loop
      delete_bridge(rec);
    end loop;
    
    for rec in bridge_thematic_surface_cur loop
      delete_bridge_thematic_surface(rec);
    end loop;
    
    for rec in bridge_installation_cur loop
      delete_bridge_installation(rec);
    end loop;

    for rec in bridge_constr_element_cur loop
      delete_bridge_constr_element(rec);
    end loop;
    
    for rec in bridge_room_cur loop
      delete_bridge_room(rec);
    end loop;
        
    -- delete addresses being not referenced from bridges any more
    for rec in address_cur loop
      if is_not_referenced('address_to_bridge', 'address_id', rec.address_id, 'bridge_id', bridge_rec.id) then 
        delete_address(rec.address_id);
      end if;
    end loop;
    
    execute immediate 'delete from address_to_bridge where bridge_id=:1' using bridge_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge (id: ' || bridge_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge(bridge_rec bridge%rowtype)
  is
  begin
    if bridge_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod1_multi_surface_id);
    end if; 
    if bridge_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod2_multi_surface_id);
    end if;
    if bridge_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod3_multi_surface_id);
    end if;
    if bridge_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod4_multi_surface_id);
    end if;

    if bridge_rec.lod1_solid_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod1_solid_id);
    end if; 
    if bridge_rec.lod2_solid_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod2_solid_id);
    end if;
    if bridge_rec.lod3_solid_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod3_solid_id);
    end if;
    if bridge_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(bridge_rec.lod4_solid_id);
    end if;
    
    intern_delete_cityobject(bridge_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge (id: ' || bridge_rec.id || '): ' || SQLERRM);
  end;
 
  procedure delete_bridge_thematic_surface(pid number)
  is
    bridge_thematic_surface_rec bridge_thematic_surface%rowtype;
  begin
    execute immediate 'select * from bridge_thematic_surface where id=:1'
      into bridge_thematic_surface_rec
      using pid;

    delete_bridge_thematic_surface(bridge_thematic_surface_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge_thematic_surface (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE_THEMATIC_SURFACE
  */
  procedure pre_del_bridge_thematic_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype)
  is
    cursor bridge_opening_cur is
      select bo.* from bridge_opening bo, bridge_open_to_them_srf botm 
        where bo.id=botm.bridge_opening_id and botm.bridge_thematic_surface_id=bridge_thematic_surface_rec.id;
  begin
    -- delete bridge openings not being referenced by a bridge thematic surface any more
    for rec in bridge_opening_cur loop
      if is_not_referenced('bridge_open_to_them_srf', 'bridge_opening_id', rec.id, 'bridge_thematic_surface_id', bridge_thematic_surface_rec.id) then 
        delete_bridge_opening(rec);
      end if;
    end loop;

    execute immediate 'delete from bridge_open_to_them_srf where bridge_thematic_surface_id=:1' using bridge_thematic_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_del_bridge_thematic_srf (id: ' || bridge_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_bridge_thematic_surface(bridge_thematic_surface_rec bridge_thematic_surface%rowtype)
  is
  begin
    pre_del_bridge_thematic_srf(bridge_thematic_surface_rec);
    execute immediate 'delete from bridge_thematic_surface where id=:1' using bridge_thematic_surface_rec.id;
    post_del_bridge_thematic_srf(bridge_thematic_surface_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge_thematic_surface (id: ' || bridge_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_del_bridge_thematic_srf(bridge_thematic_surface_rec bridge_thematic_surface%rowtype)
  is
  begin
    if bridge_thematic_surface_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_thematic_surface_rec.lod2_multi_surface_id);
    end if;
    if bridge_thematic_surface_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_thematic_surface_rec.lod3_multi_surface_id);
    end if;
    if bridge_thematic_surface_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_thematic_surface_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(bridge_thematic_surface_rec.id);
  exception
    when others then
      dbms_output.put_line('post_del_bridge_thematic_srf (id: ' || bridge_thematic_surface_rec.id || '): ' || SQLERRM);
  end;
  
  procedure delete_bridge_installation(pid number)
  is
    bridge_installation_rec bridge_installation%rowtype;
  begin
    execute immediate 'select * from bridge_installation where id=:1'
      into bridge_installation_rec
      using pid;

    delete_bridge_installation(bridge_installation_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge_installation (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE_INSTALLATION
  */
  procedure delete_bridge_installation(bridge_installation_rec bridge_installation%rowtype)
  is
  begin
    execute immediate 'delete from bridge_installation where id=:1' using bridge_installation_rec.id;
    post_delete_bridge_inst(bridge_installation_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge_installation (id: ' || bridge_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_inst(bridge_installation_rec bridge_installation%rowtype)
  is
  begin
    if bridge_installation_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(bridge_installation_rec.lod2_brep_id);
    end if;
    if bridge_installation_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(bridge_installation_rec.lod3_brep_id);
    end if;
    if bridge_installation_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(bridge_installation_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(bridge_installation_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_inst (id: ' || bridge_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_bridge_constr_element(pid number)
  is
    bridge_constr_element_rec bridge_constr_element%rowtype;
  begin
    execute immediate 'select * from bridge_constr_element where id=:1'
      into bridge_constr_element_rec
      using pid;

    delete_bridge_constr_element(bridge_constr_element_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge_constr_element (id: ' || pid || '): ' || SQLERRM);
  end;

  /*
    internal: delete from BRIDGE_CONSTR_ELEMENT
  */
  procedure delete_bridge_constr_element(bridge_constr_element_rec bridge_constr_element%rowtype)
  is
  begin
    execute immediate 'delete from bridge_constr_element where id=:1' using bridge_constr_element_rec.id;
    post_del_bridge_constr_element(bridge_constr_element_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge_constr_element (id: ' || bridge_constr_element_rec.id || '): ' || SQLERRM);
  end;

  procedure post_del_bridge_constr_element(bridge_constr_element_rec bridge_constr_element%rowtype)
  is
  begin
    if bridge_constr_element_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(bridge_constr_element_rec.lod2_brep_id);
    end if;
    if bridge_constr_element_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(bridge_constr_element_rec.lod3_brep_id);
    end if;
    if bridge_constr_element_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(bridge_constr_element_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(bridge_constr_element_rec.id);
  exception
    when others then
      dbms_output.put_line('post_del_bridge_constr_element (id: ' || bridge_constr_element_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_bridge_room(pid number)
  is
    bridge_room_rec bridge_room%rowtype;    
  begin
    execute immediate 'select * from bridge_room where id=:1'
      into bridge_room_rec
      using pid;

    delete_bridge_room(bridge_room_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge_room (id: ' || pid || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from BRIDGE_ROOM
  */
  procedure pre_delete_bridge_room(bridge_room_rec bridge_room%rowtype)
  is
    cursor bridge_thematic_surface_cur is
      select * from bridge_thematic_surface where bridge_room_id=bridge_room_rec.id;

    cursor bridge_installation_cur is
      select * from bridge_installation where bridge_room_id=bridge_room_rec.id;

    cursor bridge_furniture_cur is
      select * from bridge_furniture where bridge_room_id=bridge_room_rec.id;
  begin
    for rec in bridge_thematic_surface_cur loop
      delete_bridge_thematic_surface(rec);
    end loop;

    for rec in bridge_installation_cur loop
      delete_bridge_installation(rec);
    end loop;

    for rec in bridge_furniture_cur loop
      delete_bridge_furniture(rec);
    end loop;
   exception
    when others then
      dbms_output.put_line('pre_delete_bridge_room (id: ' || bridge_room_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_bridge_room(bridge_room_rec bridge_room%rowtype)
  is
  begin
    pre_delete_bridge_room(bridge_room_rec);
    execute immediate 'delete from bridge_room where id=:1' using bridge_room_rec.id;
    post_delete_bridge_room(bridge_room_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge_room (id: ' || bridge_room_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_room(bridge_room_rec bridge_room%rowtype)
  is
  begin
    if bridge_room_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_room_rec.lod4_multi_surface_id);
    end if;
    if bridge_room_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(bridge_room_rec.lod4_solid_id);
    end if;

    intern_delete_cityobject(bridge_room_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_room (id: ' || bridge_room_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from BRIDGE_FURNITURE
  */
  procedure delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype)
  is
  begin
    execute immediate 'delete from bridge_furniture where id=:1' using bridge_furniture_rec.id;
    post_delete_bridge_furniture(bridge_furniture_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge_furniture (id: ' || bridge_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_furniture(bridge_furniture_rec bridge_furniture%rowtype)
  is
  begin
    if bridge_furniture_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(bridge_furniture_rec.lod4_brep_id);
    end if;
    intern_delete_cityobject(bridge_furniture_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_furniture (id: ' || bridge_furniture_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from BRIDGE_OPENING
  */
  procedure pre_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype)
  is
  begin
    execute immediate 'delete from bridge_open_to_them_srf where bridge_opening_id=:1' using bridge_opening_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_bridge_opening (id: ' || bridge_opening_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype)
  is
  begin
    pre_delete_bridge_opening(bridge_opening_rec);
    execute immediate 'delete from bridge_opening where id=:1' using bridge_opening_rec.id;
    post_delete_bridge_opening(bridge_opening_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge_opening (id: ' || bridge_opening_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_bridge_opening(bridge_opening_rec bridge_opening%rowtype)
  is
    cursor address_cur is
      select a.id from address a left outer join address_to_bridge ab
        on a.id=ab.address_id where a.id=bridge_opening_rec.address_id and ab.address_id is null;
  begin
    if bridge_opening_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_opening_rec.lod3_multi_surface_id);
    end if;
    if bridge_opening_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(bridge_opening_rec.lod4_multi_surface_id);
    end if;

    -- delete addresses not being referenced from buildings and openings any more
    for rec in address_cur loop
      if is_not_referenced('bridge_opening', 'address_id', rec.id, 'id', bridge_opening_rec.id) then
        delete_address(rec.id);
      end if;   
    end loop;

    intern_delete_cityobject(bridge_opening_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_bridge_opening (id: ' || bridge_opening_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL
  */
  procedure pre_delete_tunnel(tunnel_rec tunnel%rowtype)
  is    
    cursor tunnel_part_cur is
      select * from tunnel where id!=tunnel_rec.id and tunnel_parent_id=tunnel_rec.id;
    
    cursor tunnel_thematic_surface_cur is
      select * from tunnel_thematic_surface where tunnel_id=tunnel_rec.id;
    
    cursor tunnel_installation_cur is
      select * from tunnel_installation where tunnel_id=tunnel_rec.id;
      
    cursor tunnel_hollow_space_cur is
      select * from tunnel_hollow_space where tunnel_id=tunnel_rec.id;
    
  begin
    for rec in tunnel_part_cur loop
      delete_tunnel(rec);
    end loop;
    
    for rec in tunnel_thematic_surface_cur loop
      delete_tunnel_thematic_surface(rec);
    end loop;
    
    for rec in tunnel_installation_cur loop
      delete_tunnel_installation(rec);
    end loop;
    
    for rec in tunnel_hollow_space_cur loop
      delete_tunnel_hollow_space(rec);
    end loop;
        
  exception
    when others then
      dbms_output.put_line('pre_delete_tunnel (id: ' || tunnel_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_tunnel(tunnel_rec tunnel%rowtype)
  is
  begin
    pre_delete_tunnel(tunnel_rec);
    execute immediate 'delete from tunnel where id=:1' using tunnel_rec.id;
    post_delete_tunnel(tunnel_rec);
  exception
    when others then
      dbms_output.put_line('delete_tunnel (id: ' || tunnel_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel(tunnel_rec tunnel%rowtype)
  is
  begin
    if tunnel_rec.lod1_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod1_multi_surface_id);
    end if; 
    if tunnel_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod2_multi_surface_id);
    end if;
    if tunnel_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod3_multi_surface_id);
    end if;
    if tunnel_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod4_multi_surface_id);
    end if;

    if tunnel_rec.lod1_solid_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod1_solid_id);
    end if; 
    if tunnel_rec.lod2_solid_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod2_solid_id);
    end if;
    if tunnel_rec.lod3_solid_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod3_solid_id);
    end if;
    if tunnel_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(tunnel_rec.lod4_solid_id);
    end if;
    
    intern_delete_cityobject(tunnel_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel (id: ' || tunnel_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL_THEMATIC_SURFACE
  */
  procedure pre_del_tunnel_thematic_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype)
  is
    cursor tunnel_opening_cur is
      select o.* from tunnel_opening o, tunnel_open_to_them_srf otm 
        where o.id=otm.tunnel_opening_id and otm.tunnel_thematic_surface_id=tunnel_thematic_surface_rec.id;
  begin
    -- delete tunnel openings not being referenced by a tunnel thematic surface any more
    for rec in tunnel_opening_cur loop
      if is_not_referenced('tunnel_open_to_them_srf', 'tunnel_opening_id', rec.id, 'tunnel_thematic_surface_id', tunnel_thematic_surface_rec.id) then 
        delete_tunnel_opening(rec);
      end if;
    end loop;

    execute immediate 'delete from tunnel_open_to_them_srf where tunnel_thematic_surface_id=:1' using tunnel_thematic_surface_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_del_tunnel_thematic_srf (id: ' || tunnel_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_thematic_surface(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype)
  is
  begin
    pre_del_tunnel_thematic_srf(tunnel_thematic_surface_rec);
    execute immediate 'delete from tunnel_thematic_surface where id=:1' using tunnel_thematic_surface_rec.id;
    post_del_tunnel_thematic_srf(tunnel_thematic_surface_rec);
  exception
    when others then
      dbms_output.put_line('delete_tunnel_thematic_surface (id: ' || tunnel_thematic_surface_rec.id || '): ' || SQLERRM);
  end;

  procedure post_del_tunnel_thematic_srf(tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype)
  is
  begin
    if tunnel_thematic_surface_rec.lod2_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_thematic_surface_rec.lod2_multi_surface_id);
    end if;
    if tunnel_thematic_surface_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_thematic_surface_rec.lod3_multi_surface_id);
    end if;
    if tunnel_thematic_surface_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_thematic_surface_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(tunnel_thematic_surface_rec.id);
  exception
    when others then
      dbms_output.put_line('post_del_tunnel_thematic_srf (id: ' || tunnel_thematic_surface_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL_OPENING
  */
  procedure pre_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype)
  is
  begin
    execute immediate 'delete from tunnel_open_to_them_srf where tunnel_opening_id=:1' using tunnel_opening_rec.id;
  exception
    when others then
      dbms_output.put_line('pre_delete_tunnel_opening (id: ' || tunnel_opening_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype)
  is
  begin
    pre_delete_tunnel_opening(tunnel_opening_rec);
    execute immediate 'delete from tunnel_opening where id=:1' using tunnel_opening_rec.id;
    post_delete_tunnel_opening(tunnel_opening_rec);
  exception
    when others then
      dbms_output.put_line('delete_tunnel_opening (id: ' || tunnel_opening_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_opening(tunnel_opening_rec tunnel_opening%rowtype)
  is
  begin
    if tunnel_opening_rec.lod3_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_opening_rec.lod3_multi_surface_id);
    end if;
    if tunnel_opening_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_opening_rec.lod4_multi_surface_id);
    end if;

    intern_delete_cityobject(tunnel_opening_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_opening (id: ' || tunnel_opening_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    internal: delete from TUNNEL_FURNITURE
  */
  procedure delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype)
  is
  begin
    execute immediate 'delete from tunnel_furniture where id=:1' using tunnel_furniture_rec.id;
    post_delete_tunnel_furniture(tunnel_furniture_rec);
  exception
    when others then
      dbms_output.put_line('delete_tunnel_furniture (id: ' || tunnel_furniture_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_furniture(tunnel_furniture_rec tunnel_furniture%rowtype)
  is
  begin
    if tunnel_furniture_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(tunnel_furniture_rec.lod4_brep_id);
    end if;
    intern_delete_cityobject(tunnel_furniture_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_furniture (id: ' || tunnel_furniture_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TUNNEL_INSTALLATION
  */
  procedure delete_tunnel_installation(tunnel_installation_rec tunnel_installation%rowtype)
  is
  begin
    execute immediate 'delete from tunnel_installation where id=:1' using tunnel_installation_rec.id;
    post_delete_tunnel_inst(tunnel_installation_rec);
  exception
    when others then
      dbms_output.put_line('delete_tunnel_installation (id: ' || tunnel_installation_rec.id || '): ' || SQLERRM);
  end;

  procedure post_delete_tunnel_inst(tunnel_installation_rec tunnel_installation%rowtype)
  is
  begin
    if tunnel_installation_rec.lod2_brep_id is not null then
      intern_delete_surface_geometry(tunnel_installation_rec.lod2_brep_id);
    end if;
    if tunnel_installation_rec.lod3_brep_id is not null then
      intern_delete_surface_geometry(tunnel_installation_rec.lod3_brep_id);
    end if;
    if tunnel_installation_rec.lod4_brep_id is not null then
      intern_delete_surface_geometry(tunnel_installation_rec.lod4_brep_id);
    end if;

    intern_delete_cityobject(tunnel_installation_rec.id);
  exception
    when others then
      dbms_output.put_line('post_delete_tunnel_inst (id: ' || tunnel_installation_rec.id || '): ' || SQLERRM);
  end;

  /*
    internal: delete from TUNNEL_HOLLOW_SPACE
  */
  procedure pre_del_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype)
  is
    cursor tunnel_thematic_surface_cur is
      select * from tunnel_thematic_surface where tunnel_hollow_space_id=tunnel_hollow_space_rec.id;

    cursor tunnel_installation_cur is
      select * from tunnel_installation where tunnel_hollow_space_id=tunnel_hollow_space_rec.id;

    cursor tunnel_furniture_cur is
      select * from tunnel_furniture where tunnel_hollow_space_id=tunnel_hollow_space_rec.id;
  begin
    for rec in tunnel_thematic_surface_cur loop
      delete_tunnel_thematic_surface(rec);
    end loop;

    for rec in tunnel_installation_cur loop
      delete_tunnel_installation(rec);
    end loop;

    for rec in tunnel_furniture_cur loop
      delete_tunnel_furniture(rec);
    end loop;
   exception
    when others then
      dbms_output.put_line('pre_del_tunnel_hollow_space (id: ' || tunnel_hollow_space_rec.id || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype)
  is
  begin
    pre_del_tunnel_hollow_space(tunnel_hollow_space_rec);
    execute immediate 'delete from tunnel_hollow_space where id=:1' using tunnel_hollow_space_rec.id;
    post_del_tunnel_hollow_space(tunnel_hollow_space_rec);
  exception
    when others then
      dbms_output.put_line('delete_tunnel_hollow_space (id: ' || tunnel_hollow_space_rec.id || '): ' || SQLERRM);
  end;

  procedure post_del_tunnel_hollow_space(tunnel_hollow_space_rec tunnel_hollow_space%rowtype)
  is
  begin
    if tunnel_hollow_space_rec.lod4_multi_surface_id is not null then
      intern_delete_surface_geometry(tunnel_hollow_space_rec.lod4_multi_surface_id);
    end if;
    if tunnel_hollow_space_rec.lod4_solid_id is not null then
      intern_delete_surface_geometry(tunnel_hollow_space_rec.lod4_solid_id);
    end if;

    intern_delete_cityobject(tunnel_hollow_space_rec.id);
  exception
    when others then
      dbms_output.put_line('post_del_tunnel_hollow_space (id: ' || tunnel_hollow_space_rec.id || '): ' || SQLERRM);
  end;
  
  /*
    PUBLIC API PROCEDURES
  */  
  procedure delete_surface_geometry(pid number, clean_apps int := 0)
  is
  begin
    intern_delete_surface_geometry(pid);

    if clean_apps <> 0 then
      cleanup_appearances(0);
    end if;
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_surface_geometry (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_implicit_geometry(pid number)
  is
  begin
    intern_delete_implicit_geom(pid);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_implicit_geometry (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_external_reference(pid number)
  is
  begin
    execute immediate 'delete from external_reference where id=:1' using pid;
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_external_reference (id: ' || pid || '): ' || SQLERRM);
  end; 

  procedure delete_citymodel(pid number)
  is
    citymodel_rec citymodel%rowtype;
  begin
    execute immediate 'select * from citymodel where id=:1'
      into citymodel_rec
      using pid;

    delete_citymodel(citymodel_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_citymodel (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_appearance(pid number)
  is
    appearance_rec appearance%rowtype;
  begin
    execute immediate 'select * from appearance where id=:1'
      into appearance_rec
      using pid;

    delete_appearance(appearance_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_appearance (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_surface_data(pid number)
  is
    surface_data_rec surface_data%rowtype;
  begin
    execute immediate 'select * from surface_data where id=:1'
      into surface_data_rec
      using pid;

    delete_surface_data(surface_data_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_surface_data (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_cityobjectgroup(pid number)
  is
    cityobjectgroup_rec cityobjectgroup%rowtype;
  begin
    dbms_output.put_line('delete_cityobjectgroup (id: ' || pid || ') ...');

    execute immediate 'select * from cityobjectgroup where id=:1'
      into cityobjectgroup_rec
      using pid;

    dbms_output.put_line('delete_cityobjectgroup(rec) ...');      
    delete_cityobjectgroup(cityobjectgroup_rec);
  exception
    when no_data_found then
      dbms_output.put_line('No record found. (Call intern_delete_cityobject instead ...)');
      intern_delete_cityobject(pid);
      return;
    when others then
      dbms_output.put_line('delete_cityobjectgroup (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_thematic_surface(pid number)
  is
    thematic_surface_rec thematic_surface%rowtype;
  begin
    execute immediate 'select * from thematic_surface where id=:1'
      into thematic_surface_rec
      using pid;

    delete_thematic_surface(thematic_surface_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_thematic_surface (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_opening(pid number)
  is
    opening_rec opening%rowtype;
  begin
    execute immediate 'select * from opening where id=:1'
      into opening_rec
      using pid;
    
    delete_opening(opening_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_opening (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_bridge_opening(pid number)
  is
    bridge_opening_rec bridge_opening%rowtype;
  begin
    execute immediate 'select * from bridge_opening where id=:1'
      into bridge_opening_rec
      using pid;
    
    delete_bridge_opening(bridge_opening_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge_opening (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_address(pid number)
  is
  begin
    execute immediate 'delete from address_to_building where address_id=:1' using pid;
    execute immediate 'delete from address_to_bridge where address_id=:1' using pid;
    execute immediate 'update opening set address_id=null where address_id=:1' using pid;
    execute immediate 'delete from address where id=:1' using pid;
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_address (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_building_installation(pid number)
  is
    building_installation_rec building_installation%rowtype;
  begin
    execute immediate 'select * from building_installation where id=:1'
      into building_installation_rec
      using pid;

    delete_building_installation(building_installation_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_building_installation (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_room(pid number)
  is
    room_rec room%rowtype;    
  begin
    execute immediate 'select * from room where id=:1'
      into room_rec
      using pid;

    delete_room(room_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_room (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_building_furniture(pid number)
  is
    building_furniture_rec building_furniture%rowtype;    
  begin
    execute immediate 'select * from building_furniture where id=:1'
      into building_furniture_rec
      using pid;

    delete_building_furniture(building_furniture_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_building_furniture (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_building(pid number)
  is
    building_rec building%rowtype;    
  begin
    execute immediate 'select * from building where id=:1'
      into building_rec
      using pid;

    delete_building(building_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_building (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_city_furniture(pid number)
  is
    city_furniture_rec city_furniture%rowtype;    
  begin
    execute immediate 'select * from city_furniture where id=:1'
      into city_furniture_rec
      using pid;

    delete_city_furniture(city_furniture_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_city_furniture (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_generic_cityobject(pid number)
  is
    generic_cityobject_rec generic_cityobject%rowtype;    
  begin
    execute immediate 'select * from generic_cityobject where id=:1'
      into generic_cityobject_rec
      using pid;

    delete_generic_cityobject(generic_cityobject_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_generic_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_land_use(pid number)
  is
    land_use_rec land_use%rowtype;    
  begin
    execute immediate 'select * from land_use where id=:1'
      into land_use_rec
      using pid;

    delete_land_use(land_use_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_land_use (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_plant_cover(pid number)
  is
    plant_cover_rec plant_cover%rowtype;    
  begin
    execute immediate 'select * from plant_cover where id=:1'
      into plant_cover_rec
      using pid;

    delete_plant_cover(plant_cover_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_plant_cover (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_solitary_veg_obj(pid number)
  is
    solitary_veg_obj_rec solitary_vegetat_object%rowtype;    
  begin
    execute immediate 'select * from solitary_vegetat_object where id=:1'
      into solitary_veg_obj_rec
      using pid;

    delete_solitary_veg_obj(solitary_veg_obj_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_solitary_veg_obj (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_transport_complex(pid number)
  is
    transport_complex_rec transportation_complex%rowtype;    
  begin
    execute immediate 'select * from transportation_complex where id=:1'
      into transport_complex_rec
      using pid;

    delete_transport_complex(transport_complex_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_transport_complex (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_traffic_area(pid number)
  is
    traffic_area_rec traffic_area%rowtype;    
  begin
    execute immediate 'select * from traffic_area where id=:1'
      into traffic_area_rec
      using pid;

    delete_traffic_area(traffic_area_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_traffic_area (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_waterbody(pid number)
  is
    waterbody_rec waterbody%rowtype;    
  begin
    execute immediate 'select * from waterbody where id=:1'
      into waterbody_rec
      using pid;

    delete_waterbody(waterbody_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_waterbody (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_waterbnd_surface(pid number)
  is
    waterbnd_surface_rec waterboundary_surface%rowtype;
  begin
    execute immediate 'select * from waterboundary_surface where id=:1'
      into waterbnd_surface_rec
      using pid;

    delete_waterbnd_surface(waterbnd_surface_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_waterbnd_surface (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_relief_feature(pid number)
  is
    relief_feature_rec relief_feature%rowtype;    
  begin
    execute immediate 'select * from relief_feature where id=:1'
      into relief_feature_rec
      using pid;

    delete_relief_feature(relief_feature_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_relief_feature (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_relief_component(pid number)
  is
    relief_component_rec relief_component%rowtype;    
  begin
    execute immediate 'select * from relief_component where id=:1'
      into relief_component_rec
      using pid;

    delete_relief_component(relief_component_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_relief_component (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_tin_relief(pid number)
  is
    tin_relief_rec tin_relief%rowtype;    
  begin
    execute immediate 'select * from tin_relief where id=:1'
      into tin_relief_rec
      using pid;

    delete_tin_relief(tin_relief_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tin_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_masspoint_relief(pid number)
  is
    masspoint_relief_rec masspoint_relief%rowtype;
  begin
    execute immediate 'select * from masspoint_relief where id=:1'
      into masspoint_relief_rec
      using pid;

    delete_masspoint_relief(masspoint_relief_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_masspoint_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_breakline_relief(pid number)
  is
    breakline_relief_rec breakline_relief%rowtype;    
  begin
    execute immediate 'select * from breakline_relief where id=:1'
      into breakline_relief_rec
      using pid;

    delete_breakline_relief(breakline_relief_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_breakline_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_raster_relief(pid number)
  is
    raster_relief_rec raster_relief%rowtype;    
  begin
    execute immediate 'select * from raster_relief where id=:1'
      into raster_relief_rec
      using pid;

    delete_raster_relief(raster_relief_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_raster_relief (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_bridge_furniture(pid number)
  is
    bridge_furniture_rec bridge_furniture%rowtype;    
  begin
    execute immediate 'select * from bridge_furniture where id=:1'
      into bridge_furniture_rec
      using pid;

    delete_bridge_furniture(bridge_furniture_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge_furniture (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_bridge(pid number)
  is
    bridge_rec bridge%rowtype;    
  begin
    execute immediate 'select * from bridge where id=:1'
      into bridge_rec
      using pid;

    delete_bridge(bridge_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_bridge (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_tunnel(pid number)
  is
    tunnel_rec tunnel%rowtype;    
  begin
    execute immediate 'select * from tunnel where id=:1'
      into tunnel_rec
      using pid;

    delete_tunnel(tunnel_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tunnel (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_thematic_surface(pid number)
  is
    tunnel_thematic_surface_rec tunnel_thematic_surface%rowtype;
  begin
    execute immediate 'select * from tunnel_thematic_surface where id=:1'
      into tunnel_thematic_surface_rec
      using pid;

    delete_tunnel_thematic_surface(tunnel_thematic_surface_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tunnel_thematic_surface (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_opening(pid number)
  is
    tunnel_opening_rec tunnel_opening%rowtype;
  begin
    execute immediate 'select * from tunnel_opening where id=:1'
      into tunnel_opening_rec
      using pid;
    
    delete_tunnel_opening(tunnel_opening_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tunnel_opening (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_furniture(pid number)
  is
    tunnel_furniture_rec tunnel_furniture%rowtype;    
  begin
    execute immediate 'select * from tunnel_furniture where id=:1'
      into tunnel_furniture_rec
      using pid;

    delete_tunnel_furniture(tunnel_furniture_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tunnel_furniture (id: ' || pid || '): ' || SQLERRM);
  end;

  procedure delete_tunnel_hollow_space(pid number)
  is
    tunnel_hollow_space_rec tunnel_hollow_space%rowtype;    
  begin
    execute immediate 'select * from tunnel_hollow_space where id=:1'
      into tunnel_hollow_space_rec
      using pid;

    delete_tunnel_hollow_space(tunnel_hollow_space_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tunnel_hollow_space (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_tunnel_installation(pid number)
  is
    tunnel_installation_rec tunnel_installation%rowtype;
  begin
    execute immediate 'select * from tunnel_installation where id=:1'
      into tunnel_installation_rec
      using pid;

    delete_tunnel_installation(tunnel_installation_rec);
  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_tunnel_installation (id: ' || pid || '): ' || SQLERRM);
  end;
  
  procedure delete_bridge(bridge_rec bridge%rowtype)
  is
  begin
    pre_delete_bridge(bridge_rec);
    execute immediate 'delete from bridge where id=:1' using bridge_rec.id;
    post_delete_bridge(bridge_rec);
  exception
    when others then
      dbms_output.put_line('delete_bridge (id: ' || bridge_rec.id || '): ' || SQLERRM);
  end;

  /*
  cleanup procedures
  */
  procedure cleanup_implicit_geometries
  is
    cursor implicitgeom_cur is
      select ig.id from implicit_geometry ig
        left join BUILDING_FURNITURE bldf4 on bldf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join BUILDING_INSTALLATION bldi2 on bldi2.LOD2_IMPLICIT_REP_ID = ig.id
        left join BUILDING_INSTALLATION bldi3 on bldi3.LOD3_IMPLICIT_REP_ID = ig.id
        left join BUILDING_INSTALLATION bldi4 on bldi4.LOD4_IMPLICIT_REP_ID = ig.id
        left join OPENING op3 on op3.LOD3_IMPLICIT_REP_ID = ig.id
        left join OPENING op4 on op4.LOD4_IMPLICIT_REP_ID = ig.id
        left join CITY_FURNITURE cf1 on cf1.LOD1_IMPLICIT_REP_ID = ig.id
        left join CITY_FURNITURE cf2 on cf2.LOD2_IMPLICIT_REP_ID = ig.id
        left join CITY_FURNITURE cf3 on cf3.LOD3_IMPLICIT_REP_ID = ig.id
        left join CITY_FURNITURE cf4 on cf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join GENERIC_CITYOBJECT gco0 on gco0.LOD0_IMPLICIT_REP_ID = ig.id
        left join GENERIC_CITYOBJECT gco1 on gco1.LOD1_IMPLICIT_REP_ID = ig.id
        left join GENERIC_CITYOBJECT gco2 on gco2.LOD2_IMPLICIT_REP_ID = ig.id
        left join GENERIC_CITYOBJECT gco3 on gco3.LOD3_IMPLICIT_REP_ID = ig.id
        left join GENERIC_CITYOBJECT gco4 on gco4.LOD4_IMPLICIT_REP_ID = ig.id
        left join SOLITARY_VEGETAT_OBJECT svo1 on svo1.LOD1_IMPLICIT_REP_ID = ig.id
        left join SOLITARY_VEGETAT_OBJECT svo2 on svo2.LOD2_IMPLICIT_REP_ID = ig.id
        left join SOLITARY_VEGETAT_OBJECT svo3 on svo3.LOD3_IMPLICIT_REP_ID = ig.id
        left join SOLITARY_VEGETAT_OBJECT svo4 on svo4.LOD4_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_CONSTR_ELEMENT bce1 on bce1.LOD1_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_CONSTR_ELEMENT bce2 on bce2.LOD2_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_CONSTR_ELEMENT bce3 on bce3.LOD3_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_CONSTR_ELEMENT bce4 on bce4.LOD4_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_FURNITURE brdf4 on brdf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_INSTALLATION brdi2 on brdi2.LOD2_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_INSTALLATION brdi3 on brdi3.LOD3_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_INSTALLATION brdi4 on brdi4.LOD4_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_OPENING brdo3 on brdo3.LOD3_IMPLICIT_REP_ID = ig.id
        left join BRIDGE_OPENING brdo4 on brdo4.LOD4_IMPLICIT_REP_ID = ig.id
        left join TUNNEL_FURNITURE tunf4 on tunf4.LOD4_IMPLICIT_REP_ID = ig.id
        left join TUNNEL_INSTALLATION tuni2 on tuni2.LOD2_IMPLICIT_REP_ID = ig.id
        left join TUNNEL_INSTALLATION tuni3 on tuni3.LOD3_IMPLICIT_REP_ID = ig.id
        left join TUNNEL_INSTALLATION tuni4 on tuni4.LOD4_IMPLICIT_REP_ID = ig.id
        left join TUNNEL_OPENING tuno3 on tuno3.LOD3_IMPLICIT_REP_ID = ig.id
        left join TUNNEL_OPENING tuno4 on tuno4.LOD4_IMPLICIT_REP_ID = ig.id
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
              (tuno4.LOD4_IMPLICIT_REP_ID is null);
  begin
    for rec in implicitgeom_cur loop
      intern_delete_implicit_geom(rec.id);
    end loop;
  exception
    when others then
      dbms_output.put_line('cleanup_implicit_geometries: ' || SQLERRM);
  end;

  procedure cleanup_tex_images
  is
    cursor tex_image_cur is
      select ti.* from tex_image ti left outer join surface_data sd
        on ti.id=sd.tex_image_id where sd.tex_image_id is null;
  begin
    for rec in tex_image_cur loop
      execute immediate 'delete from tex_image where id=:1' using rec.id;
    end loop;
  exception
    when others then
      dbms_output.put_line('cleanup_tex_images: ' || SQLERRM);
  end;
  
  procedure cleanup_appearances(only_global int :=1)
  is
    cursor surface_data_global_cur is
      select s.* from surface_data s left outer join textureparam t
        on s.id=t.surface_data_id where t.surface_data_id is null;

    cursor appearance_cur is
      select a.* from appearance a left outer join appear_to_surface_data asd
        on a.id=asd.appearance_id where asd.appearance_id is null;

    cursor appearance_global_cur is
      select a.* from appearance a left outer join appear_to_surface_data asd
        on a.id=asd.appearance_id where a.cityobject_id is null and asd.appearance_id is null;
  begin
    -- global appearances are not related to a cityobject.
    -- however, we assume that all surface geometries of a cityobject
    -- have been deleted at this stage. thus, we can check and delete
    -- surface data which does not have a valid texture parameterization
    -- any more.
    for rec in surface_data_global_cur loop
      delete_surface_data(rec);
    end loop;

    -- delete appearances which does not have surface data any more
    if only_global=1 then
      for rec in appearance_global_cur loop
        delete_appearance(rec);
      end loop;
    else
      for rec in appearance_cur loop
        delete_appearance(rec);
      end loop;
    end if;

    -- cleanup texture images    
    cleanup_tex_images;

  exception
    when others then
      dbms_output.put_line('cleanup_appearances: ' || SQLERRM);
  end;

  procedure cleanup_addresses
  is
    cursor address_cur is
      select ad.id from address ad
        left outer join address_to_building ad2b on ad2b.address_id = ad.id
        left outer join address_to_bridge ad2brd on ad2brd.address_id = ad.id
        left outer join opening o on o.address_id = ad.id
        left outer join bridge_opening brdo on brdo.address_id = ad.id
        where ad2b.building_id is null
          and ad2brd.bridge_id is null
          and o.address_id is null
          and brdo.address_id is null;
  begin
    for rec in address_cur loop
      delete_address(rec.id);
    end loop;
  exception  
    when others then
      dbms_output.put_line('cleanup_addresses: ' || SQLERRM);
  end;

  procedure cleanup_cityobjectgroups
  is
    cursor group_cur is
      select g.* from cityobjectgroup g left outer join group_to_cityobject gtc
        on g.id=gtc.cityobjectgroup_id where gtc.cityobject_id is null;
  begin
    for rec in group_cur loop
      delete_cityobjectgroup(rec);
    end loop;
  exception
    when others then
      dbms_output.put_line('cleanup_cityobjectgroups: ' || SQLERRM);
  end;

  procedure cleanup_citymodels
  is
    cursor citymodel_cur is
      select c.* from citymodel c left outer join cityobject_member cm
        on c.id=cm.citymodel_id where cm.cityobject_id is null;
  begin
    for rec in citymodel_cur loop
      delete_citymodel(rec);
    end loop;

  exception
    when others then
      dbms_output.put_line('cleanup_citymodel: ' || SQLERRM);
  end;
  
  -- generic function to delete any cityobject  
  procedure delete_cityobject(pid number)
  is
    objectclass_id number;    
    objectclass_name varchar2(256);    
    object_gmlid varchar2(256);    
  begin
  
    execute immediate 'select co.objectclass_id, oc.classname, co.gmlid from cityobject co join objectclass oc on (oc.id=co.objectclass_id) where co.id=:1'
      into objectclass_id, objectclass_name, object_gmlid
      using pid;

    dbms_output.put_line('delete_cityobject ([' || objectclass_name || '] id=' || pid || ', gmlid=' || object_gmlid || ')');
    
    case 
      when objectclass_id = 4 then delete_land_use(pid);
      when objectclass_id = 5 then delete_generic_cityobject(pid);
      when objectclass_id = 7 then delete_solitary_veg_obj(pid);
      when objectclass_id = 8 then delete_plant_cover(pid);
      when objectclass_id = 9 then delete_waterbody(pid);
      when objectclass_id = 11 or 
           objectclass_id = 12 or 
           objectclass_id = 13 then delete_waterbnd_surface(pid);
      when objectclass_id = 14 then delete_relief_feature(pid);
      when objectclass_id = 16 or 
           objectclass_id = 17 or 
           objectclass_id = 18 or 
           objectclass_id = 19 then delete_relief_component(pid);
      when objectclass_id = 21 then delete_city_furniture(pid);
      when objectclass_id = 23 then delete_cityobjectgroup(pid);
      when objectclass_id = 25 or 
           objectclass_id = 26 then delete_building(pid);
      when objectclass_id = 27 or 
           objectclass_id = 28 then delete_building_installation(pid);
      when objectclass_id = 30 or 
           objectclass_id = 31 or 
           objectclass_id = 32 or 
           objectclass_id = 33 or 
           objectclass_id = 34 or 
           objectclass_id = 35 or 
           objectclass_id = 36 then delete_thematic_surface(pid);
      when objectclass_id = 38 or 
           objectclass_id = 39 then delete_opening(pid);
      when objectclass_id = 40 then delete_building_furniture(pid);
      when objectclass_id = 41 then delete_room(pid);
      when objectclass_id = 43 or 
           objectclass_id = 44 or 
           objectclass_id = 45 or 
           objectclass_id = 46 then delete_transport_complex(pid);
      when objectclass_id = 47 or 
           objectclass_id = 48 then delete_traffic_area(pid);
      when objectclass_id = 57 then delete_citymodel(pid);
      when objectclass_id = 60 or 
           objectclass_id = 61 then delete_thematic_surface(pid);
      when objectclass_id = 63 or 
           objectclass_id = 64 then delete_bridge(pid);
      when objectclass_id = 65 or 
           objectclass_id = 66 then delete_bridge_installation(pid);
      when objectclass_id = 68 or 
           objectclass_id = 69 or 
           objectclass_id = 70 or 
           objectclass_id = 71 or 
           objectclass_id = 72 or 
           objectclass_id = 73 or 
           objectclass_id = 74 or 
           objectclass_id = 75 or 
           objectclass_id = 76 then delete_bridge_thematic_surface(pid);
      when objectclass_id = 78 or 
           objectclass_id = 79 then delete_bridge_opening(pid);
      when objectclass_id = 80 then delete_bridge_furniture(pid);
      when objectclass_id = 81 then delete_bridge_room(pid);
      when objectclass_id = 82 then delete_bridge_constr_element(pid);
      when objectclass_id = 84 or 
           objectclass_id = 85 then delete_tunnel(pid);
      when objectclass_id = 86 or 
           objectclass_id = 87 then delete_tunnel_installation(pid);
      when objectclass_id = 89 or 
           objectclass_id = 90 or 
           objectclass_id = 91 or 
           objectclass_id = 92 or 
           objectclass_id = 93 or 
           objectclass_id = 94 or 
           objectclass_id = 95 or 
           objectclass_id = 96 or 
           objectclass_id = 97 then delete_tunnel_thematic_surface(pid);
      when objectclass_id = 99 or 
           objectclass_id = 100 then delete_tunnel_opening(pid);
      when objectclass_id = 101 then delete_tunnel_furniture(pid);
      when objectclass_id = 102 then delete_tunnel_hollow_space(pid);
      else
        -- do nothing
        null;
    end case;

  exception
    when no_data_found then
      return;
    when others then
      dbms_output.put_line('delete_cityobject (id: ' || pid || '): ' || SQLERRM);
  end;

  -- delete any cityobject using foreign key relations
  -- NOTE: all constraints have to be set to ON DELETE CASCADE (function: geodb_pkg.update_schema_constraints)
  procedure delete_cityobject_cascade(pid number)
  is
  begin  
    -- first step: delete local appearance
    execute immediate 'select delete_appearance(id) from appearance where cityobject_id = :1' using pid;
  
    -- second step: delete geometries
    execute immediate 'delete from surface_geometry where cityobject_id = :1 and parent_id is null' using pid;
  
    -- third step: delete the cityobject
    execute immediate 'delete from cityobject where id = :1' using pid;
  
    -- fourth step: cleanup
    cleanup_implicit_geometries;  
    cleanup_appearances(0);
    cleanup_addresses;
    cleanup_cityobjectgroups;
    cleanup_citymodels;
  
  exception
    when others then
      dbms_output.put_line('delete_cityobject_cascade (id: ' || pid || '): ' || SQLERRM);
  end; 

END geodb_delete;
/