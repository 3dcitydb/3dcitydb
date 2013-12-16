-- MATCH.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2008  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
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
-- 1.0.0     2008-09-10   release version                             CNag
--

set term off;
set serveroutput off;

drop table match_overlap_all;
create table match_overlap_all
      (id1 number,
      parent_id1 number,
      root_id1 number,
      area1 number,
      lod1 number,
      lineage varchar2(256),
      id2 number,
      parent_id2 number,
      root_id2 number,
      area2 number,
      lod2 number,
      intersection_geometry mdsys.sdo_geometry,
      intersection_area number,
      area1_cov_by_area2 number,
      area2_cov_by_area1 number)
      nologging;
      
drop table match_overlap_relevant;
create table match_overlap_relevant
      (id1 number,
      parent_id1 number,
      root_id1 number,
      area1 number,
      lod1 number,
      lineage varchar2(256),
      id2 number,
      parent_id2 number,
      root_id2 number,
      area2 number,
      lod2 number,
      intersection_geometry mdsys.sdo_geometry,
      intersection_area number,
      area1_cov_by_area2 number,
      area2_cov_by_area1 number)
      nologging;

drop table match_master_projected;
create table match_master_projected
      (id number,
      parent_id number,
      root_id number,
      geometry mdsys.sdo_geometry) 
      nologging;
     
drop table match_cand_projected;
create table match_cand_projected 
      (id number,
      parent_id number,
      root_id number,
      geometry mdsys.sdo_geometry) 
      nologging;
      
drop table match_collect_geom;
create table match_collect_geom 
      (id number,
      parent_id number,
      root_id number,
      geometry mdsys.sdo_geometry) 
      nologging;
      
truncate table match_tmp_building;
drop table match_tmp_building;
create global temporary table match_tmp_building
      (id number,
      parent_id number,
      root_id number,
      geometry_id number)
      on commit preserve rows;

set term on;
set serveroutput on;

CREATE OR REPLACE PACKAGE geodb_match
AS 
  procedure create_matching_table(lod_cand number, lineage cityobject.lineage%type, lod_master number, delta_cand number, delta_master number, tolerance number := 0.001, aggregate_building number := 1);  
 
  procedure collect_cand_building(lod number, lineage cityobject.lineage%type);
  procedure collect_master_building(lod number, lineage cityobject.lineage%type);
  procedure collect_geometry(lod number);
  procedure rectify_geometry(tolerance number := 0.001);
  procedure aggregate_geometry(table_name varchar2, tolerance number := 0.001, aggregate_building number := 1);
  procedure join_cand_master(lod_cand number, lineage cityobject.lineage%type, lod_master number, tolerance number := 0.001);
	procedure create_relevant_matches(delta_cand number, delta_master number);
  procedure clear_matching_tables;
 
  function aggregate_mbr(table_name varchar2) return mdsys.sdo_geometry;
  function aggregate_geometry_by_id(id number, tolerance number := 0.001, aggregate_building number := 1) return mdsys.sdo_geometry; 
END geodb_match;
/

CREATE OR REPLACE PACKAGE BODY geodb_match
AS
  -- private procedures
  function get_2d_srid return number;
  
  -- private constants
  CAND_GEOMETRY_TABLE constant string(30) := 'MATCH_CAND_PROJECTED';
  MASTER_GEOMETRY_TABLE constant string(30) := 'MATCH_MASTER_PROJECTED';
  
  -- declaration of private indexes
  match_master_projected_spx index_obj := 
    index_obj.construct_spatial_2d('match_master_projected_spx', MASTER_GEOMETRY_TABLE, 'geometry'); 
  match_cand_projected_spx index_obj := 
    index_obj.construct_spatial_2d('match_cand_projected_spx', CAND_GEOMETRY_TABLE, 'geometry');    
  match_overlap_all_spx index_obj := 
    index_obj.construct_spatial_2d('match_overlap_all_spx', 'match_overlap_all', 'intersection_geometry');  
  match_result_spx index_obj := 
    index_obj.construct_spatial_2d('match_overlap_relevant_spx', 'match_overlap_relevant', 'intersection_geometry');
    
  match_collect_id_idx index_obj :=
    index_obj.construct_normal('match_collect_id_idx', 'match_collect_geom', 'id');
  match_collect_root_id_idx index_obj :=
    index_obj.construct_normal('match_collect_root_id_idx', 'match_collect_geom', 'root_id');
  
  procedure create_matching_table(lod_cand number, lineage cityobject.lineage%type, lod_master number, delta_cand number, delta_master number, tolerance number := 0.001, aggregate_building number := 1)
  is 
    log varchar2(4000);
  begin 
    -- gather candidate buildings
    collect_cand_building(lod_cand, lineage);

    -- gather candidate geometry
    collect_geometry(lod_cand);
    
    -- rectify candidate geometry 
    rectify_geometry(tolerance);
    
    -- aggregate candidate geometry   
    aggregate_geometry(CAND_GEOMETRY_TABLE, tolerance, aggregate_building);   
    
    -- gather master buildings
    collect_master_building(lod_master, lineage);
    
    -- gather master geometry
    collect_geometry(lod_master);
    
    -- rectify master geometry 
    rectify_geometry(tolerance);
    
    -- aggregate master geometry   
    aggregate_geometry(MASTER_GEOMETRY_TABLE, tolerance, aggregate_building); 
    
    -- fill matching table
    join_cand_master(lod_cand, lineage, lod_master, tolerance);
    
    -- densify to 1:1 matches
    create_relevant_matches(delta_cand, delta_master);
    
    commit;
  end;
  
  procedure collect_cand_building(lod number, lineage cityobject.lineage%type)
  is
  begin
    -- truncate tmp table
    execute immediate 'truncate table match_tmp_building';
    
    -- retrieve all building tupels belonging to the specified lineage
    execute immediate 'insert all into match_tmp_building
      select b.id, b.building_parent_id parent_id, b.building_root_id root_id, b.lod'||to_char(lod)||'_geometry_id geometry_id
        from building b, cityobject c
        where c.id = b.id
              and c.lineage = :1' using lineage;
  end;
  
  procedure collect_master_building(lod number, lineage cityobject.lineage%type)
  is
  begin
    -- truncate tmp table
    execute immediate 'truncate table match_tmp_building';
    
    -- retrieve all building tupels not belonging to the specified lineage and
    -- whose mbr is interacting with the aggregated mbr of all candidate building footprint
    execute immediate 'insert all into match_tmp_building
      select b.id, b.building_parent_id parent_id, b.building_root_id root_id, b.lod'||to_char(lod)||'_geometry_id geometry_id
        from building b, cityobject c
        where c.id = b.id
              and sdo_filter(c.envelope, :2) = ''TRUE''
              and (c.lineage <> :1 or c.lineage is null)' 
      using aggregate_mbr(CAND_GEOMETRY_TABLE),
            lineage;
  end;
  
  procedure collect_geometry(lod number)
  is
    log varchar2(4000);
    srid number;
  begin
    -- first, truncate tmp table
    execute immediate 'truncate table match_collect_geom';
    log := geodb_idx.drop_index(match_collect_id_idx, false);
    log := geodb_idx.drop_index(match_collect_root_id_idx, false); 
  
    -- get srid for 2d geometries
    srid := get_2d_srid;
  
    -- second, retrieve exterior shell surfaces from building
    execute immediate 'insert all /*+ append nologging */ into match_collect_geom
      select bl.id, bl.parent_id, bl.root_id, geodb_util.to_2d(s.geometry, :1)
        from match_tmp_building bl, surface_geometry s
        where s.root_id = bl.geometry_id
              and s.geometry is not null'
      using srid;
    
    -- for lod > 1 we also have to check surfaces from the tables
    -- building_installation and thematic surface
    if lod > 1 then
      -- retrieve surfaces from building installations referencing the identified
      -- building tupels
      execute immediate 'insert all /*+ append nologging */ into match_collect_geom
        select bl.id, bl.parent_id, bl.root_id, geodb_util.to_2d(s.geometry, :1)
          from match_tmp_building bl, building_installation i, surface_geometry s
          where i.building_id = bl.id
                and i.is_external = 1
                and s.root_id = i.lod'||to_char(lod)||'_geometry_id
                and s.geometry is not null'
        using srid;
    
      -- retrieve surfaces from thematic surfaces referencing the identified
      -- building tupels
      execute immediate 'insert all /*+ append nologging */ into match_collect_geom
        select bl.id, bl.parent_id, bl.root_id, geodb_util.to_2d(s.geometry, :1)
          from match_tmp_building bl, thematic_surface t, surface_geometry s
          where t.building_id = bl.id
                and upper(t.type) not in (''INTERIORWALLSURFACE'', ''CEILINGSURFACE'', ''FLOORSURFACE'')
                and s.root_id = t.lod'||to_char(lod)||'_multi_surface_id
                and s.geometry is not null'
        using srid;
    end if;    
  exception
    when others then
      dbms_output.put_line('collect_geometry: ' || SQLERRM);
  end;

  procedure rectify_geometry(tolerance number := 0.001)
  is
  begin
    -- first, remove invalid geometries 
    execute immediate 'delete from match_collect_geom where sdo_geom.validate_geometry(geometry, :1) <> ''TRUE''' using tolerance;
           
    -- second, delete vertical surfaces
    execute immediate 'delete from match_collect_geom where sdo_geom.sdo_area(geometry, :1) <= :2' using tolerance, tolerance;
  exception
    when others then
      dbms_output.put_line('rectify_geometry: ' || SQLERRM);
  end;

  procedure aggregate_geometry(table_name varchar2, tolerance number := 0.001, aggregate_building number := 1)
  is
    log varchar2(4000);
  begin
    -- truncate table
    execute immediate 'truncate table '||table_name;
    
    -- drop spatial indexes   
    if match_cand_projected_spx.table_name = table_name then
      log := geodb_idx.drop_index(match_cand_projected_spx, false);
    else
      log := geodb_idx.drop_index(match_master_projected_spx, false);
    end if;
   
    if aggregate_building > 0 then    
      declare
        cursor root_id_cur is
          select distinct root_id
          from match_tmp_building;
          
      begin
        log := geodb_idx.create_index(match_collect_root_id_idx, false, 'nologging');
      
        for root_id_rec in root_id_cur loop
          execute immediate 'insert into '||table_name||' (id, parent_id, root_id, geometry)
            values (:1, null, :2, :3)' 
            using root_id_rec.root_id, 
                  root_id_rec.root_id, 
                  aggregate_geometry_by_id(root_id_rec.root_id, tolerance, 1);          
        end loop;
      end;
    else
      declare
        cursor id_cur is
          select distinct id, parent_id, root_id 
          from match_tmp_building;
          
      begin
        log := geodb_idx.create_index(match_collect_id_idx, false, 'nologging');
      
        for id_rec in id_cur loop
          execute immediate 'insert into '||table_name||' (id, parent_id, root_id, geometry)
            values (:1, :2, :3, :4)' 
            using id_rec.id, 
                  id_rec.parent_id, 
                  id_rec.root_id, 
                  aggregate_geometry_by_id(id_rec.id, tolerance, 0);          
        end loop;
      end;
    end if;
    
    -- clean up aggregate table
    execute immediate 'delete from '||table_name||' where geometry is null';
    
    -- create spatial index
    if match_cand_projected_spx.table_name = table_name then
      match_cand_projected_spx.srid := get_2d_srid;
      log := geodb_idx.create_index(match_cand_projected_spx, false);
    else
      match_master_projected_spx.srid := get_2d_srid;
      log := geodb_idx.create_index(match_master_projected_spx, false);
    end if;
  end;

  procedure join_cand_master(lod_cand number, lineage cityobject.lineage%type, lod_master number, tolerance number := 0.001)
  is
    log varchar2(4000);
  begin
    -- clean environment
    execute immediate 'truncate table match_overlap_all';
    log := geodb_idx.drop_index(match_overlap_all_spx, false);
  
    execute immediate 'insert all /*+ append nologging */ into match_overlap_all 
      (id1, parent_id1, root_id1, area1, lod1, lineage,
      id2, parent_id2, root_id2, area2, lod2,
      intersection_geometry)
      select c.id id1, c.parent_id parent_id1, c.root_id root_id1, sdo_geom.sdo_area(c.geometry, :1) area1, :2, :3,
             m.id id2, m.parent_id parent_id2, m.root_id root_id2, sdo_geom.sdo_area(m.geometry, :4) area2, :5,
             sdo_geom.sdo_intersection(c.geometry, m.geometry, :6)
      from table(sdo_join(:7, ''geometry'', :8, ''geometry'', ''mask=INSIDE+CONTAINS+EQUAL+COVERS+COVEREDBY+OVERLAPBDYINTERSECT'')) 
           res, '||CAND_GEOMETRY_TABLE||' c, '||MASTER_GEOMETRY_TABLE||' m
      where c.rowid = res.rowid1 and m.rowid = res.rowid2' 
      using tolerance,
            lod_cand,
            lineage,
            tolerance,
            lod_master,
            tolerance,
            CAND_GEOMETRY_TABLE, 
            MASTER_GEOMETRY_TABLE;
            
      execute immediate 'update match_overlap_all set intersection_area = sdo_geom.sdo_area(intersection_geometry, :1)' using tolerance;
      execute immediate 'delete from match_overlap_all where intersection_area = 0';
      execute immediate 'update match_overlap_all set area1_cov_by_area2 = geodb_util.min(intersection_area / area1, 1.0), 
                                                 area2_cov_by_area1 = geodb_util.min(intersection_area / area2, 1.0)'; 
      
      -- create spatial index on intersection geometry 
      match_overlap_all_spx.srid := get_2d_srid;
      log := geodb_idx.create_index(match_overlap_all_spx, false);
  end;
  
  procedure create_relevant_matches(delta_cand number, delta_master number)
  is
    log varchar2(4000);
    
    cursor ref_to_cand_cur is
      select id2, count(id1) as cnt_cand from match_overlap_relevant group by id2;
    cursor cand_to_ref_cur is
      select id1, count(id2) as cnt_ref from match_overlap_relevant group by id1;
  begin
    -- truncate table
    execute immediate 'truncate table match_overlap_relevant';
    log := geodb_idx.drop_index(match_result_spx, false);
    
    -- retrieve all match tupels with more than a user-specified percentage of area coverage
    execute immediate 'insert all /*+ append nologging */ into match_overlap_relevant 
      select * from match_overlap_all
        where area1_cov_by_area2 >= :1 and area2_cov_by_area1 >= :2' using delta_cand, delta_master;
              
    -- enforce 1:1 matches between candidates and reference buildings
    for ref_to_cand_rec in ref_to_cand_cur loop
      if ref_to_cand_rec.cnt_cand > 1 then
        execute immediate 'delete from match_overlap_relevant where id2=:1' using ref_to_cand_rec.id2;
      end if;
    end loop;
    
    for cand_to_ref_rec in cand_to_ref_cur loop
      if cand_to_ref_rec.cnt_ref > 1 then
        execute immediate 'delete from match_overlap_relevant where id1=:1' using cand_to_ref_rec.id1;
      end if;
    end loop;
    
    -- create spatial index on intersection geometry
    match_result_spx.srid := get_2d_srid;
    log := geodb_idx.create_index(match_result_spx, false);
  exception
      when others then
        dbms_output.put_line('create_relevant_matches: ' || SQLERRM);
  end;
  
  procedure clear_matching_tables
  is
  begin
    execute immediate 'truncate table match_overlap_all';
    execute immediate 'truncate table match_overlap_relevant';
    execute immediate 'truncate table match_master_projected';
    execute immediate 'truncate table match_cand_projected';
    execute immediate 'truncate table match_collect_geom';
    execute immediate 'truncate table match_tmp_building';
    execute immediate 'truncate table merge_collect_geom';
    execute immediate 'truncate table merge_container_ids';
  exception
    when others then
      dbms_output.put_line('clean_matching_tables: ' || SQLERRM);
  end;

  function aggregate_mbr(table_name varchar2)
  return mdsys.sdo_geometry
  is
    aggr_mbr mdsys.sdo_geometry;
    srid number;
  begin
    execute immediate 'select srid from database_srs' into srid;
    execute immediate 'select sdo_aggr_mbr(geometry) from '||table_name||'' into aggr_mbr;
    aggr_mbr.sdo_srid := srid;
    
    return aggr_mbr;
  exception
    when others then 
      return null;
  end;

  /*
  * create footprint for building by aggregating (using boolean union) all identified
  * polygons.
  */
  function aggregate_geometry_by_id(id number, tolerance number := 0.001, aggregate_building number := 1)
  return mdsys.sdo_geometry
  is
    aggr_geom mdsys.sdo_geometry;
    attr string(10);
  begin
    if aggregate_building > 0 then
      attr := 'root_id';
    else
      attr := 'id';
    end if;
  
    execute immediate 'select sdo_aggr_union(mdsys.sdoaggrtype(aggr_geom, :1))
      from (select sdo_aggr_union(mdsys.sdoaggrtype(aggr_geom, :2)) aggr_geom
          from (select sdo_aggr_union(mdsys.sdoaggrtype(aggr_geom, :3)) aggr_geom
                from (select sdo_aggr_union(mdsys.sdoaggrtype(geometry, :4)) aggr_geom
                      from match_collect_geom 
                      where '||attr||'=:5
                      group by mod(rownum, 1000)
                     )
                group by mod (rownum, 100)
               )
      group by mod (rownum, 10)
      )' 
      into aggr_geom 
      using tolerance, 
            tolerance,
            tolerance,
            tolerance,
            id;
     
     return aggr_geom;
  exception
    when others then
      dbms_output.put_line(id || ': ' || SQLERRM);
      return null;
  end;
  
  function get_2d_srid return number
  is
    srid number;
  begin
    if geodb_util.is_db_coord_ref_sys_3d = 1 then
      srid := null;
    else
      execute immediate 'select srid from database_srs' into srid;
    end if;
    
    return srid;
  end;
  
END geodb_match;
/