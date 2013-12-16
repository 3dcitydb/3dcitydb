-- DELETE_BY_LINEAGE.sql
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
-- 1.3.0     2013-08-08   extended to all thematic classes            GHud
--                                                                    FKun
-- 1.2.0     2012-02-22   minor changes                               CNag
-- 1.1.0     2011-02-11   moved to new DELETE functionality           CNag
-- 1.0.0     2008-09-10   release version                             ASta
--

CREATE OR REPLACE PACKAGE geodb_delete_by_lineage
AS
  procedure delete_cityobjects(lineage_value varchar2);
  procedure delete_buildings(lineage_value varchar2);
  procedure delete_city_furnitures(lineage_value varchar2);
  procedure delete_generic_cityobjects(lineage_value varchar2);
  procedure delete_land_uses(lineage_value varchar2);
  procedure delete_plant_covers(lineage_value varchar2);
  procedure delete_solitary_veg_objs(lineage_value varchar2);
  procedure delete_transport_complexes(lineage_value varchar2);
  procedure delete_waterbodies(lineage_value varchar2);
  procedure delete_cityobjectgroups(lineage_value varchar2);
  procedure delete_relief_features(lineage_value varchar2);
END geodb_delete_by_lineage;
/

CREATE OR REPLACE PACKAGE BODY GEODB_DELETE_BY_LINEAGE
AS 

  procedure delete_buildings(lineage_value varchar2)
  is
    cursor building_cur is
      select b.id from building b, cityobject c where b.id = c.id and c.lineage = lineage_value;
  begin    
    for building_rec in building_cur loop
      begin
        geodb_delete.delete_building(building_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_buildings: deletion of building with ID ' || building_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_implicitgeometries;
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_buildings: ' || SQLERRM);
  end;

  procedure delete_city_furnitures(lineage_value varchar2)
  is
    cursor city_furniture_cur is
      select cf.id from city_furniture cf, cityobject c where cf.id = c.id and c.lineage = lineage_value;
  begin
    for city_furniture_rec in city_furniture_cur loop
      begin
        geodb_delete.delete_city_furniture(city_furniture_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_city_furnitures: deletion of city_furniture with ID ' || city_furniture_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_implicitgeometries;
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_city_furnitures: ' || SQLERRM);
  end;

  procedure delete_generic_cityobjects(lineage_value varchar2)
  is
    cursor generic_cityobject_cur is
      select gco.id from generic_cityobject gco, cityobject c where gco.id = c.id and c.lineage = lineage_value;
  begin
    for generic_cityobject_rec in generic_cityobject_cur loop
      begin
        geodb_delete.delete_generic_cityobject(generic_cityobject_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_generic_cityobjects: deletion of generic_cityobject with ID ' || generic_cityobject_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_implicitgeometries;
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_generic_cityobjects: ' || SQLERRM);
  end;

  procedure delete_land_uses(lineage_value varchar2)
  is
    cursor land_use_cur is
      select lu.id from land_use lu, cityobject c where lu.id = c.id and c.lineage = lineage_value;
  begin
    for land_use_rec in land_use_cur loop
      begin
        geodb_delete.delete_land_use(land_use_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_land_uses: deletion of land_use with ID ' || land_use_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_land_uses: ' || SQLERRM);
  end;

  procedure delete_plant_covers(lineage_value varchar2)
  is
    cursor plant_cover_cur is
      select pc.id from plant_cover pc, cityobject c where pc.id = c.id and c.lineage = lineage_value;
  begin
    for plant_cover_rec in plant_cover_cur loop
      begin
        geodb_delete.delete_plant_cover(plant_cover_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_plant_covers: deletion of plant_cover with ID ' || plant_cover_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_plant_covers: ' || SQLERRM);
  end;

  procedure delete_solitary_veg_objs(lineage_value varchar2)
  is
    cursor solitary_veg_obj_cur is
      select svo.id from solitary_vegetat_object svo, cityobject c where svo.id = c.id and c.lineage = lineage_value;
  begin
    for solitary_veg_obj_rec in solitary_veg_obj_cur loop
      begin
        geodb_delete.delete_solitary_veg_obj(solitary_veg_obj_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_solitary_veg_objs: deletion of solitary_veg_obj with ID ' || solitary_veg_obj_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_implicitgeometries;
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_solitary_veg_objs: ' || SQLERRM);
  end;

  procedure delete_transport_complexes(lineage_value varchar2)
  is
    cursor transport_complex_cur is
      select tc.id from transportation_complex tc, cityobject c where tc.id = c.id and c.lineage = lineage_value;
  begin
    for transport_complex_rec in transport_complex_cur loop
      begin
        geodb_delete.delete_transport_complex(transport_complex_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_transport_complexes: deletion of transportation_complex with ID ' || transport_complex_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_transport_complexes: ' || SQLERRM);
  end;

  procedure delete_waterbodies(lineage_value varchar2)
  is
    cursor waterbody_cur is
      select wb.id from waterbody wb, cityobject c where wb.id = c.id and c.lineage = lineage_value;
  begin
    for waterbody_rec in waterbody_cur loop
      begin
        geodb_delete.delete_waterbody(waterbody_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_waterbodies: deletion of waterbody with ID ' || waterbody_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_waterbodies: ' || SQLERRM);
  end;

  procedure delete_cityobjectgroups(lineage_value varchar2)
  is
    cursor cityobjectgroup_cur is
      select cog.id from cityobjectgroup cog, cityobject c where cog.id = c.id and c.lineage = lineage_value;
  begin    
    for cityobjectgroup_rec in cityobjectgroup_cur loop
      begin
        geodb_delete.delete_cityobjectgroup(cityobjectgroup_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_cityobjectgroups: deletion of cityobjectgroup with ID ' || cityobjectgroup_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_cityobjectgroups: ' || SQLERRM);
  end;

  procedure delete_relief_features(lineage_value varchar2)
  is
    cursor relief_feature_cur is
      select rf.id from relief_feature rf, cityobject c where rf.id = c.id and c.lineage = lineage_value;
  begin
    for relief_feature_rec in relief_feature_cur loop
      begin
        geodb_delete.delete_relief_feature(relief_feature_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_relief_features: deletion of relief_feature with ID ' || relief_feature_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_relief_features: ' || SQLERRM);
  end;

  procedure delete_cityobjects(lineage_value varchar2)
  is
    cursor cityobject_cur is
      select id from cityobject where lineage = lineage_value;
  begin
    for cityobject_rec in cityobject_cur loop
      begin
        geodb_delete.delete_cityobject(cityobject_rec.id);
      exception
        when others then
          dbms_output.put_line('delete_cityobjects: deletion of cityobject with ID ' || cityobject_rec.id || ' threw: ' || SQLERRM);
      end;
    end loop;

    -- cleanup
    geodb_delete.cleanup_implicitgeometries;
    geodb_delete.cleanup_appearances;
    geodb_delete.cleanup_citymodels;
  exception
    when others then
      dbms_output.put_line('delete_cityobjects: ' || SQLERRM);
  end;

END geodb_delete_by_lineage;
/