-- CREATE_INDEXES.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2011  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates additional indexes on APPEAR_TO_SURFACE_DATA 
-- (should already exist on databases of version 2.0.2 and later).
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.1.0     2013-08-29   index added                                 FKun
-- 1.0.0     2011-05-16   release version                             CNag
--

set serveroutput on;

declare
  app_to_surf_data_fkx_1 index_obj :=
    index_obj.construct_normal('APP_TO_SURF_DATA_FKX', 'APPEAR_TO_SURFACE_DATA', 'SURFACE_DATA_ID');
  app_to_surf_data_fkx_2 index_obj :=
    index_obj.construct_normal('APP_TO_SURF_DATA_FKX1', 'APPEAR_TO_SURFACE_DATA', 'APPEARANCE_ID');
  genericcity_lod0refpnt_spx index_obj :=
    index_obj.construct_spatial_3d('GENERICCITY_LOD0REFPNT_SPX', 'GENERIC_CITYOBJECT', 'LOD0_IMPLICIT_REF_POINT');
    
  is_version_enabled boolean;
  log varchar2(4000);
begin
  is_version_enabled := geodb_util.versioning_table('APPEAR_TO_SURFACE_DATA') = 'ON';
  
  if geodb_idx.index_status(app_to_surf_data_fkx_1) <> 'VALID' then
    dbms_output.put_line('Creating index APP_TO_SURF_DATA_FKX.');
    log := geodb_idx.drop_index(app_to_surf_data_fkx_1, is_version_enabled);
    log := geodb_idx.create_index(app_to_surf_data_fkx_1, is_version_enabled);
  else
    dbms_output.put_line('Index APP_TO_SURF_DATA_FKX already exists.');
  end if;
  
  if geodb_idx.index_status(app_to_surf_data_fkx_2) <> 'VALID' then
    dbms_output.put_line('Creating index APP_TO_SURF_DATA_FKX1.');
    log := geodb_idx.drop_index(app_to_surf_data_fkx_2, is_version_enabled);
    log := geodb_idx.create_index(app_to_surf_data_fkx_2, is_version_enabled);
  else
    dbms_output.put_line('Index APP_TO_SURF_DATA_FKX1 already exists.');
  end if;  
  
  if geodb_idx.index_status(genericcity_lod0refpnt_spx) <> 'VALID' then
    dbms_output.put_line('Creating index GENERICCITY_LOD0REFPNT_SPX.');
    log := geodb_idx.drop_index(genericcity_lod0refpnt_spx, is_version_enabled);
    log := geodb_idx.create_index(genericcity_lod0refpnt_spx, is_version_enabled);
  else
    dbms_output.put_line('Index GENERICCITY_LOD0REFPNT_SPX already exists.');
  end if;
  
  dbms_output.put_line('');
end;
/

