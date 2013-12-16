-- RENAME_OBJECTS.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Restricts names of constraints and indexes on tables to a maximum number of
-- 26 characters. This is required if the tables are version-enabled.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2011-05-16   release version                             CNag
-- 1.0.1     2012-02-14   minor change                                CNag
--
set serveroutput off;
set feedback off;
set term off;
flush on;

create or replace type rename_object as object (
  table_name varchar2(30),
  object_name varchar2(30),
  new_object_name varchar2(30),
  is_pk number
);
/
  
set serveroutput on;
set term on;

declare
  rename_err number := 0;
  ddl_err number := 0;
  schema_owner varchar2(30);
  object_count number := 0;
  
  type rename_object_table is table of rename_object;  
  rename_objects constant rename_object_table := rename_object_table (
    rename_object('APPEAR_TO_SURFACE_DATA', 'APPEARANCE_TO_SURFACEDAT_PK', 'APPEAR_TO_SURFACE_DATA_PK', 1),
    rename_object('RELIEF_FEAT_TO_REL_COMP', 'RELIEF_FEATURE_TO_RELIEF__PK', 'RELIEF_FEAT_TO_REL_COMP_PK', 1),
    rename_object('CITYOBJECT_GENERICATTRIB', 'CITYOBJECT_GENERICATTRIB_PK', 'CITYOBJ_GENERICATTRIB_PK', 1),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETATION_OBJEC_PK', 'SOLITARY_VEG_OBJECT_PK', 1),    
    rename_object('CITYOBJECT_GENERICATTRIB', 'CITYOBJECT_GENERICATTRIB_FKX', 'CITYOBJ_GENERICATTRIB_FKX', 0),
    rename_object('CITYOBJECT_GENERICATTRIB', 'CITYOBJECT_GENERICATTRIB_FKX1', 'CITYOBJ_GENERICATTRIB_FKX1', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX1', 'SOLITARY_VEGETAT_OBJ_FKX1', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX2', 'SOLITARY_VEGETAT_OBJ_FKX2', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX3', 'SOLITARY_VEGETAT_OBJ_FKX3', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX4', 'SOLITARY_VEGETAT_OBJ_FKX4', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX5', 'SOLITARY_VEGETAT_OBJ_FKX5', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX6', 'SOLITARY_VEGETAT_OBJ_FKX6', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX7', 'SOLITARY_VEGETAT_OBJ_FKX7', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOLITARY_VEGETAT_OBJECT_FKX8', 'SOLITARY_VEGETAT_OBJ_FKX8', 0),
    rename_object('TRANSPORTATION_COMPLEX', 'TRANSPORTATION_COMPLEX_FKX1', 'TRAN_COMPLEX_FKX1', 0),
    rename_object('TRANSPORTATION_COMPLEX', 'TRANSPORTATION_COMPLEX_FKX2', 'TRAN_COMPLEX_FKX2', 0),
    rename_object('TRANSPORTATION_COMPLEX', 'TRANSPORTATION_COMPLEX_FKX3', 'TRAN_COMPLEX_FKX3', 0),
    rename_object('TRANSPORTATION_COMPLEX', 'TRANSPORTATION_COMPLEX_FKX4', 'TRAN_COMPLEX_FKX4', 0),
    rename_object('BUILDING_FURNITURE', 'BUILDING_FURN_LOD4REFPNT_SPX', 'BLDG_FURN_LOD4REFPT_SPX', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOL_VEGETAT_OBJ_LOD1REFPNT_SPX', 'SOL_VEG_OBJ_LOD1REFPT_SPX', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOL_VEGETAT_OBJ_LOD2REFPNT_SPX', 'SOL_VEG_OBJ_LOD2REFPT_SPX', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOL_VEGETAT_OBJ_LOD3REFPNT_SPX', 'SOL_VEG_OBJ_LOD3REFPT_SPX', 0),
    rename_object('SOLITARY_VEGETAT_OBJECT', 'SOL_VEGETAT_OBJ_LOD4REFPNT_SPX', 'SOL_VEG_OBJ_LOD4REFPT_SPX', 0)
  );
  
begin    
  execute immediate 'select user from dual' into schema_owner;

  -- rename objects having more than 26 characters in their name
  for i in rename_objects.first .. rename_objects.last loop
    begin
      if rename_objects(i).is_pk = 1 then
        execute immediate 'select count(*) from user_constraints where constraint_name=:1' into object_count using rename_objects(i).object_name;
      else
        execute immediate 'select count(*) from user_indexes where index_name=:1' into object_count using rename_objects(i).object_name;
      end if;  
      
      if object_count <> 0 then 
        dbms_output.put_line('Renaming ' || rename_objects(i).object_name || ' on table ' || rename_objects(i).table_name);
    
        if geodb_util.versioning_table(rename_objects(i).table_name) = 'ON' then
          if rename_objects(i).is_pk = 1 then
            dbms_wm.alterversionedtable(rename_objects(i).table_name, 'RENAME_CONSTRAINT', 'constraint_name=' || rename_objects(i).object_name || ', new_constraint_name=' || rename_objects(i).new_object_name);
          else
            dbms_wm.alterversionedtable(rename_objects(i).table_name, 'RENAME_INDEX', 'index_owner=' || schema_owner || ', index_name=' || rename_objects(i).object_name || ', new_index_name=' || rename_objects(i).new_object_name);        
          end if;     
        else
          if rename_objects(i).is_pk = 1 then
            execute immediate 'alter table ' || rename_objects(i).table_name || ' rename constraint ' || rename_objects(i).object_name || ' to ' || rename_objects(i).new_object_name;
          else
            execute immediate 'alter index ' || rename_objects(i).object_name || ' rename to ' || rename_objects(i).new_object_name;        
          end if;
        end if;
      else
        dbms_output.put_line(rename_objects(i).object_name  || ' does not exist - no action required.');
      end if;
    exception
      when others then
        dbms_output.put_line('ERROR: failed to rename object ' || rename_objects(i).object_name  || ': ' || SQLERRM); 
        dbms_output.put_line(chr(10));
        rename_err := rename_err + 1;
    end;
  end loop;
  
  -- check whether ddl operations can be executed on all versioned tables 
  if geodb_util.versioning_db = 'ON' then
    declare
      table_name varchar2(50);
      cursor versioned_tables is
        select * from user_wm_versioned_tables;
    begin
      for versioned_tables_rec in versioned_tables loop
        begin
          table_name := versioned_tables_rec.table_name;
          
          -- brute force like check whether ddl operations are possible
          dbms_wm.beginddl(table_name);
          dbms_wm.rollbackddl(table_name);
        exception
          when others then
            dbms_output.put_line('ERROR: failed to perform pseudo DDL operation on table ' || table_name || ': ' || SQLERRM); 
            dbms_output.put_line(chr(10));
            ddl_err := ddl_err + 1;
        end;
      end loop;
      
      if rename_err != 0 and ddl_err = 0 then
        dbms_output.put_line('OK: DDL operations can be performed on all version-enabled tables.');
      end if;
    end;
  end if;

  if rename_err + ddl_err = 0 then
    dbms_output.put_line('rename_objects.sql successfully finished.');
  else
    dbms_output.put_line('rename_objects.sql failed with ' || (rename_err + ddl_err) || ' error(s).');  
  end if;
  
exception
  when others then
    dbms_output.put_line('rename_objects.sql raised error: ' || SQLERRM);
end;
/

drop type rename_object;