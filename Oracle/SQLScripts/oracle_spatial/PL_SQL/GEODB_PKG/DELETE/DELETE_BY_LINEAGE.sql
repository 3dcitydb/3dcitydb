-- DELETE_BY_LINEAGE.sql
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
-- 1.3.0     2013-08-08   extended to all thematic classes            GHud
--                                                                    FKun
-- 1.2.0     2012-02-22   minor changes                               CNag
-- 1.1.0     2011-02-11   moved to new DELETE functionality           CNag
-- 1.0.0     2008-09-10   release version                             ASta
--

CREATE OR REPLACE PACKAGE geodb_delete_by_lineage
AS
  procedure delete_cityobjects(lineage_value varchar2, affect_rel_objs int := 0, schema_name varchar2 := USER);
  procedure delete_buildings(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_bridges(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_tunnels(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_city_furnitures(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_generic_cityobjects(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_land_uses(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_plant_covers(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_solitary_veg_objs(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_transport_complexes(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_waterbodies(lineage_value varchar2, schema_name varchar2 := USER);
  procedure delete_cityobjectgroups(lineage_value varchar2, affect_rel_objs int := 0, schema_name varchar2 := USER);
  procedure delete_relief_features(lineage_value varchar2, schema_name varchar2 := USER);
END geodb_delete_by_lineage;
/

CREATE OR REPLACE PACKAGE BODY GEODB_DELETE_BY_LINEAGE
AS 
  type ref_cursor is ref cursor;

  procedure delete_buildings(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    building_cur ref_cursor;
    building_id number;
  begin
	open building_cur for 'select b.id from ' || schema_name || '.building b, ' || schema_name || '.cityobject c where b.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch building_cur into building_id;
      begin
        geodb_delete.delete_building(building_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_buildings: deletion of building with ID ' || building_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close building_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_buildings: ' || SQLERRM);
  end;

  procedure delete_bridges(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    bridge_cur ref_cursor;
    bridge_id number;
  begin
	open bridge_cur for 'select b.id from ' || schema_name || '.bridge b, ' || schema_name || '.cityobject c where b.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch bridge_cur into bridge_id;
      begin
        geodb_delete.delete_bridge(bridge_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_bridges: deletion of bridge with ID ' || bridge_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close bridge_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_bridges: ' || SQLERRM);
  end;

  procedure delete_tunnels(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    tunnel_cur ref_cursor;
    tunnel_id number;
  begin
  	open tunnel_cur for 'select t.id from ' || schema_name || '.tunnel t, ' || schema_name || '.cityobject c where t.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch tunnel_cur into tunnel_id;
      begin
        geodb_delete.delete_tunnel(tunnel_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_tunnels: deletion of tunnel with ID ' || tunnel_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close tunnel_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_tunnels: ' || SQLERRM);
  end;
  
  procedure delete_city_furnitures(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    city_furniture_cur ref_cursor;
    city_furniture_id number;
  begin
	open city_furniture_cur for 'select cf.id from ' || schema_name || '.city_furniture cf, ' || schema_name || '.cityobject c where cf.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch city_furniture_cur into city_furniture_id;
      begin
        geodb_delete.delete_city_furniture(city_furniture_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_city_furnitures: deletion of city_furniture with ID ' || city_furniture_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close city_furniture_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);

  exception
    when others then
      dbms_output.put_line('delete_city_furnitures: ' || SQLERRM);
  end;

  procedure delete_generic_cityobjects(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    generic_cityobject_cur ref_cursor;
    generic_cityobject_id number;
  begin
	open generic_cityobject_cur for 'select gco.id from ' || schema_name || '.generic_cityobject gco, ' || schema_name || '.cityobject c where gco.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch generic_cityobject_cur into generic_cityobject_id;
      begin
        geodb_delete.delete_generic_cityobject(generic_cityobject_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_generic_cityobjects: deletion of generic_cityobject with ID ' || generic_cityobject_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close generic_cityobject_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_generic_cityobjects: ' || SQLERRM);
  end;

  procedure delete_land_uses(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    land_use_cur ref_cursor;
    land_use_id number;
  begin
	open land_use_cur for 'select lu.id from ' || schema_name || '.land_use lu, ' || schema_name || '.cityobject c where lu.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch land_use_cur into land_use_id;
      begin
        geodb_delete.delete_land_use(land_use_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_land_uses: deletion of land_use with ID ' || land_use_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close land_use_cur;

    -- cleanup
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_land_uses: ' || SQLERRM);
  end;

  procedure delete_plant_covers(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    plant_cover_cur ref_cursor;
    plant_cover_id number;
  begin
	open plant_cover_cur for 'select pc.id from ' || schema_name || '.plant_cover pc, ' || schema_name || '.cityobject c where pc.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch plant_cover_cur into plant_cover_id;
      begin
        geodb_delete.delete_plant_cover(plant_cover_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_plant_covers: deletion of plant_cover with ID ' || plant_cover_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close plant_cover_cur;

    -- cleanup
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_plant_covers: ' || SQLERRM);
  end;

  procedure delete_solitary_veg_objs(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    solitary_veg_obj_cur ref_cursor;
    solitary_veg_obj_id number;
  begin
	open solitary_veg_obj_cur for 'select svo.id from ' || schema_name || '.solitary_vegetat_object svo, ' || schema_name || '.cityobject c where svo.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch solitary_veg_obj_cur into solitary_veg_obj_id;
      begin
        geodb_delete.delete_solitary_veg_obj(solitary_veg_obj_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_solitary_veg_objs: deletion of solitary_vegetat_object with ID ' || solitary_veg_obj_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close solitary_veg_obj_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_solitary_veg_objs: ' || SQLERRM);
  end;

  procedure delete_transport_complexes(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    transport_complex_cur ref_cursor;
    transport_complex_id number;
  begin
	open transport_complex_cur for 'select tc.id from ' || schema_name || '.transportation_complex tc, ' || schema_name || '.cityobject c where tc.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch transport_complex_cur into transport_complex_id;
      begin
        geodb_delete.delete_transport_complex(transport_complex_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_transport_complexes: deletion of transportation_complex with ID ' || transport_complex_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close transport_complex_cur;

    -- cleanup
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_transport_complexes: ' || SQLERRM);
  end;

  procedure delete_waterbodies(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    waterbody_cur ref_cursor;
    waterbody_id number;
  begin
	open waterbody_cur for 'select wb.id from ' || schema_name || '.waterbody wb, ' || schema_name || '.cityobject c where wb.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch waterbody_cur into waterbody_id;
      begin
        geodb_delete.delete_waterbody(waterbody_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_waterbodies: deletion of waterbody with ID ' || waterbody_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close waterbody_cur;

    -- cleanup
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_waterbodies: ' || SQLERRM);
  end;

  procedure delete_cityobjectgroups(
    lineage_value varchar2,
    affect_rel_objs int := 0,
    schema_name varchar2 := USER
    )
  is
    cityobjectgroup_cur ref_cursor;
    cityobjectgroup_id number;
  begin
	open cityobjectgroup_cur for 'select cog.id from ' || schema_name || '.cityobjectgroup cog, ' || schema_name || '.cityobject c where cog.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch cityobjectgroup_cur into cityobjectgroup_id;
      begin
        geodb_delete.delete_cityobjectgroup(cityobjectgroup_id, affect_rel_objs, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_cityobjectgroups: deletion of cityobjectgroup with ID ' || cityobjectgroup_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close cityobjectgroup_cur;

    -- cleanup
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_cityobjectgroups: ' || SQLERRM);
  end;

  procedure delete_relief_features(
    lineage_value varchar2, 
    schema_name varchar2 := USER
    )
  is
    relief_feature_cur ref_cursor;
    relief_feature_id number;
  begin
	open relief_feature_cur for 'select rf.id from ' || schema_name || '.relief_feature rf, ' || schema_name || '.cityobject c where rf.id = c.id and c.lineage = :1' USING lineage_value; 
    loop
      fetch relief_feature_cur into relief_feature_id;
      begin
        geodb_delete.delete_relief_feature(relief_feature_id, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_relief_features: deletion of relief_feature with ID ' || relief_feature_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close relief_feature_cur;

    -- cleanup
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_relief_features: ' || SQLERRM);
  end;

  procedure delete_cityobjects(
    lineage_value varchar2,
    affect_rel_objs int := 0,
    schema_name varchar2 := USER
    )
  is
    cityobject_cur ref_cursor;
    cityobject_id number;
  begin
	open cityobject_cur for 'select id from ' || schema_name || '.cityobject where lineage = :1' USING lineage_value; 
    loop
      fetch cityobject_cur into cityobject_id;
      begin
        geodb_delete.delete_cityobject(cityobject_id, affect_rel_objs, 0, schema_name);
      exception
        when others then
          dbms_output.put_line('delete_cityobjects: deletion of cityobject with ID ' || cityobject_id || ' threw: ' || SQLERRM);
      end;
    end loop;
    close cityobject_cur;

    -- cleanup
    geodb_delete.cleanup_implicit_geometries(1, schema_name);
    geodb_delete.cleanup_appearances(1, schema_name);
    geodb_delete.cleanup_citymodels(schema_name);
  exception
    when others then
      dbms_output.put_line('delete_cityobjects: ' || SQLERRM);
  end;

END geodb_delete_by_lineage;
/