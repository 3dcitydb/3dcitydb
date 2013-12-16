-- DELETE.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--              György Hudra <ghudra@moss.de>
--
-- Copyright:   (c) 2013       Faculty of Civil, Geo and Environmental Engineering, 
--                             Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de/
--              (c) 2007-2013  Institute for Geodesy and Geoinformation Science,
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
  procedure cleanup_appearances(only_global int :=1);
  procedure cleanup_cityobjectgroups;
  procedure cleanup_citymodels;
  procedure cleanup_implicitgeometries;
  procedure delete_cityobject(pid number);
END geodb_delete;
/

CREATE OR REPLACE PACKAGE BODY geodb_delete
AS
  -- private procedures
  procedure intern_delete_surface_geometry(pid number);
  procedure intern_delete_implicit_geom(pid number);
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

  procedure post_delete_implicit_geom(implicit_geometry_rec implicit_geometry%rowtype);
  procedure pre_delete_cityobject(pid number);
  procedure pre_delete_citymodel(citymodel_rec citymodel%rowtype);
  procedure pre_delete_appearance(appearance_rec appearance%rowtype);
  procedure pre_delete_surface_data(surface_data_rec surface_data%rowtype);
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

  function is_not_referenced(table_name varchar2, check_column varchar2, check_id number, not_column varchar2, not_id number) return boolean;
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
    if implicit_geometry_rec.relative_geometry_id is not null then
      intern_delete_surface_geometry(implicit_geometry_rec.relative_geometry_id);
    end if;
  exception
    when others then
      dbms_output.put_line('post_delete_implicit_geom (id: ' || implicit_geometry_rec.id || '): ' || SQLERRM);
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
  exception
    when others then
      dbms_output.put_line('delete_surface_data (id: ' || surface_data_rec.id || '): ' || SQLERRM);
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
    if cityobjectgroup_rec.surface_geometry_id is not null then
      intern_delete_surface_geometry(cityobjectgroup_rec.surface_geometry_id);
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
    if building_installation_rec.lod2_geometry_id is not null then
      intern_delete_surface_geometry(building_installation_rec.lod2_geometry_id);
    end if;
    if building_installation_rec.lod3_geometry_id is not null then
      intern_delete_surface_geometry(building_installation_rec.lod3_geometry_id);
    end if;
    if building_installation_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(building_installation_rec.lod4_geometry_id);
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
    if room_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(room_rec.lod4_geometry_id);
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
    if building_furniture_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(building_furniture_rec.lod4_geometry_id);
    end if;
    -- !!! delete implicit geometry only if it is not referenced by other cityobjects any more
    -- !!! see/use procedure cleanup_implicitgeometries
    -- if building_furniture_rec.lod4_implicit_rep_id is not null then
    --   intern_delete_implicit_geom(building_furniture_rec.lod4_implicit_rep_id);
    -- end if; 

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
    if building_rec.lod1_geometry_id is not null then
      intern_delete_surface_geometry(building_rec.lod1_geometry_id);
    end if; 
    if building_rec.lod2_geometry_id is not null then
      intern_delete_surface_geometry(building_rec.lod2_geometry_id);
    end if;
    if building_rec.lod3_geometry_id is not null then
      intern_delete_surface_geometry(building_rec.lod3_geometry_id);
    end if;
    if building_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(building_rec.lod4_geometry_id);
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
    if city_furniture_rec.lod1_geometry_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod1_geometry_id);
    end if; 
    if city_furniture_rec.lod2_geometry_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod2_geometry_id);
    end if;
    if city_furniture_rec.lod3_geometry_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod3_geometry_id);
    end if;
    if city_furniture_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(city_furniture_rec.lod4_geometry_id);
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
    if generic_cityobject_rec.lod0_geometry_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod0_geometry_id);
    end if; 
    if generic_cityobject_rec.lod1_geometry_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod1_geometry_id);
    end if; 
    if generic_cityobject_rec.lod2_geometry_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod2_geometry_id);
    end if;
    if generic_cityobject_rec.lod3_geometry_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod3_geometry_id);
    end if;
    if generic_cityobject_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(generic_cityobject_rec.lod4_geometry_id);
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
    if plant_cover_rec.lod1_geometry_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod1_geometry_id);
    end if; 
    if plant_cover_rec.lod2_geometry_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod2_geometry_id);
    end if;
    if plant_cover_rec.lod3_geometry_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod3_geometry_id);
    end if;
    if plant_cover_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(plant_cover_rec.lod4_geometry_id);
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
    if solitary_veg_obj_rec.lod1_geometry_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod1_geometry_id);
    end if; 
    if solitary_veg_obj_rec.lod2_geometry_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod2_geometry_id);
    end if;
    if solitary_veg_obj_rec.lod3_geometry_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod3_geometry_id);
    end if;
    if solitary_veg_obj_rec.lod4_geometry_id is not null then
      intern_delete_surface_geometry(solitary_veg_obj_rec.lod4_geometry_id);
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
    --
    -- !!! Not yet implemented !!!
    --
    execute immediate 'delete from raster_relief where id=:1' using raster_relief_rec.id;

  exception
    when others then
      dbms_output.put_line('delete_raster_relief (id: ' || raster_relief_rec.id || '): ' || SQLERRM);
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
    execute immediate 'select * from cityobjectgroup where id=:1'
      into cityobjectgroup_rec
      using pid;

    delete_cityobjectgroup(cityobjectgroup_rec);
  exception
    when no_data_found then
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

  procedure delete_address(pid number)
  is
  begin
    execute immediate 'delete from address_to_building where address_id=:1' using pid;
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
  exception
    when others then
      dbms_output.put_line('cleanup_appearances: ' || SQLERRM);
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

  procedure cleanup_implicitgeometries
  is
    cursor implicitgeom_cur is
      select ig.id from implicit_geometry ig
        left join BUILDING_FURNITURE bf on bf.LOD4_IMPLICIT_REP_ID = ig.id
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
        where (bf.LOD4_IMPLICIT_REP_ID is null) and
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
              (svo4.LOD4_IMPLICIT_REP_ID is null);
  begin
    for rec in implicitgeom_cur loop
      intern_delete_implicit_geom(rec.id);
    end loop;
  exception
    when others then
      dbms_output.put_line('cleanup_implicitgeometries: ' || SQLERRM);
  end;

  -- generic function to delete any cityobject  
  procedure delete_cityobject(pid number)
  is
    objectclass_id number;    
  begin
    execute immediate 'select class_id from cityobject where id=:1'
      into objectclass_id
      using pid;

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
           objectclass_id = 28 then delete_cityobjectgroup(pid);
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

END geodb_delete;
/