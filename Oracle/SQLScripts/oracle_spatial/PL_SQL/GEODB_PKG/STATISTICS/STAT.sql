-- STAT.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Dr. Gerhard Groeger <groeger@ikg.uni-bonn.de>
--              Joerg Schmittwilken <schmittwilken@ikg.uni-bonn.de>
--              Viktor Stroh <stroh@ikg.uni-bonn.de>
--              Dr. Andreas Poth <poth@lat-lon.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2008  Institute for Geodesy and Geoinformation Science,
--                             Technische Universit�t Berlin, Germany
--                             http://www.igg.tu-berlin.de
--              (c) 2004-2006, Institute for Cartography and Geoinformation,
--                             Universit�t Bonn, Germany
--                             http://www.ikg.uni-bonn.de
--              (c) 2005-2006, lat/lon GmbH, Germany
--                             http://www.lat-lon.de--              
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates package "geodb_stat" containing utility methods for creating
-- database statistics.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.1       2008-09-10   release version                             CNag
-- 1.0       2006-04-03   release version                             LPlu
--                                                                    TKol
--                                                                    GGro
--                                                                    JSch
--                                                                    VStr
--                                                                    APot
--

/*****************************************************************
* PACKAGE geodb_stat
* 
* utility methods for creating database statistics
******************************************************************/
CREATE OR REPLACE PACKAGE geodb_stat
AS
  FUNCTION table_contents RETURN STRARRAY;
END geodb_stat;
/

CREATE OR REPLACE PACKAGE BODY geodb_stat
AS
  
  /*****************************************************************
  * versioning_status
  *
  ******************************************************************/
  FUNCTION table_contents RETURN STRARRAY
  IS
    report STRARRAY := STRARRAY();
    ws VARCHAR2(30);
    cnt NUMBER;
    refreshDate DATE;
    reportDate DATE;
    pa_id PLANNING_ALTERNATIVE.ID%TYPE;
    pa_title PLANNING_ALTERNATIVE.TITLE%TYPE;
  
  BEGIN
    SELECT SYSDATE INTO reportDate FROM DUAL;  
    report.extend; report(report.count) := ('Database Report on 3D City Model - Report date: ' || TO_CHAR(reportDate, 'DD.MM.YYYY HH24:MI:SS'));
    report.extend; report(report.count) := ('===================================================================');
  
    -- Determine current workspace
    ws := DBMS_WM.GetWorkspace;
    report.extend; report(report.count) := ('Current workspace: ' || ws);
  
    IF ws != 'LIVE' THEN
      -- Get associated planning alternative
      SELECT id,title INTO pa_id,pa_title FROM PLANNING_ALTERNATIVE
      WHERE workspace_name=ws;
      report.extend; report(report.count) := (' (PlanningAlternative ID ' || pa_id ||': "' || pa_title || '")');

      -- Query date of last refresh
      SELECT createtime INTO refreshDate
      FROM all_workspace_savepoints
      WHERE savepoint='refreshed' AND workspace=ws;
      report.extend; report(report.count) := ('Last refresh from LIVE workspace: ' || TO_CHAR(refreshDate, 'DD.MM.YYYY HH24:MI:SS'));
    END IF;
    report.extend; report(report.count) := '';
  
    SELECT count(*) INTO cnt FROM citymodel;
    report.extend; report(report.count) := ('#CITYMODEL:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM cityobject_member;
    report.extend; report(report.count) := ('#CITYOBJECT_MEMBER:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM cityobject;
    report.extend; report(report.count) := ('#CITYOBJECT:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM generalization;
    report.extend; report(report.count) := ('#GENERALIZATION:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM external_reference;
    report.extend; report(report.count) := ('#EXTERNAL_REFERENCE:\t\t' || cnt);
  
    -- Geometry
    SELECT count(*) INTO cnt FROM implicit_geometry;
    report.extend; report(report.count) := ('#IMPLICIT_GEOMETRY:\t\t' || cnt);  
    SELECT count(*) INTO cnt FROM surface_geometry;
    report.extend; report(report.count) := ('#SURFACE_GEOMETRY:\t\t' || cnt);
  
    -- Building
    SELECT count(*) INTO cnt FROM address;
    report.extend; report(report.count) := ('#ADDRESS:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM address_to_building;
    report.extend; report(report.count) := ('#ADDRESS_TO_BUILDING:\t\t' || cnt);  
    SELECT count(*) INTO cnt FROM building;
    report.extend; report(report.count) := ('#BUILDING:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM building_furniture;
    report.extend; report(report.count) := ('#BUILDING_FURNITURE:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM building_installation;
    report.extend; report(report.count) := ('#BUILDING_INSTALLATION:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM opening;
    report.extend; report(report.count) := ('#OPENING:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM opening_to_them_surface;
    report.extend; report(report.count) := ('#OPENING_TO_THEM_SURFACE:\t' || cnt);
    SELECT count(*) INTO cnt FROM room;
    report.extend; report(report.count) := ('#ROOM:\t\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM thematic_surface;
    report.extend; report(report.count) := ('#THEMATIC_SURFACE:\t\t' || cnt);
  
    -- CityFurniture
    SELECT count(*) INTO cnt FROM city_furniture;
    report.extend; report(report.count) := ('#CITY_FURNITURE:\t\t' || cnt);
  
    -- CityObjectGroup
    SELECT count(*) INTO cnt FROM cityobjectgroup;
    report.extend; report(report.count) := ('#CITYOBJECTGROUP:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM group_to_cityobject;
    report.extend; report(report.count) := ('#GROUP_TO_CITYOBJECT:\t\t' || cnt);
  
    -- LandUse
    SELECT count(*) INTO cnt FROM land_use;
    report.extend; report(report.count) := ('#LAND_USE:\t\t\t' || cnt);
  
    -- Relief
    SELECT count(*) INTO cnt FROM relief_feature;
    report.extend; report(report.count) := ('#RELIEF_FEATURE:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM relief_component;
    report.extend; report(report.count) := ('#RELIEF_COMPONENT:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM relief_feat_to_rel_comp;
    report.extend; report(report.count) := ('#RELIEF_FEAT_TO_REL_COMP:\t' || cnt);
    SELECT count(*) INTO cnt FROM tin_relief;
    report.extend; report(report.count) := ('#TIN_RELIEF:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM breakline_relief;
    report.extend; report(report.count) := ('#BREAKLINE_RELIEF:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM masspoint_relief;
    report.extend; report(report.count) := ('#MASSPOINT_RELIEF:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM raster_relief;
    report.extend; report(report.count) := ('#RASTER_RELIEF:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM raster_relief_imp;
    report.extend; report(report.count) := ('#RASTER_RELIEF_IMP:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM relief;
    report.extend; report(report.count) := ('#RELIEF:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM orthophoto;
    report.extend; report(report.count) := ('#ORTHOPHOTO:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM orthophoto_imp;
    report.extend; report(report.count) := ('#ORTHOPHOTO_IMP:\t\t' || cnt);
  
    -- Transportation
    SELECT count(*) INTO cnt FROM transportation_complex;
    report.extend; report(report.count) := ('#TRANSPORTATION_COMPLEX:\t' || cnt);
    SELECT count(*) INTO cnt FROM traffic_area;
    report.extend; report(report.count) := ('#TRAFFIC_AREA:\t\t\t' || cnt);
   
    -- Vegetation
    SELECT count(*) INTO cnt FROM plant_cover;
    report.extend; report(report.count) := ('#PLANT_COVER:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM solitary_vegetat_object;
    report.extend; report(report.count) := ('#SOLITARY_VEGETAT_OBJECT:\t' || cnt);
  
    -- WaterBody
    SELECT count(*) INTO cnt FROM waterbody;
    report.extend; report(report.count) := ('#WATERBODY:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM waterboundary_surface;
    report.extend; report(report.count) := ('#WATERBOUNDARY_SURFACE:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM waterbod_to_waterbnd_srf;
    report.extend; report(report.count) := ('#WATERBOD_TO_WATERBND_SRF:\t' || cnt);
    
    -- GenericCityObject
    SELECT count(*) INTO cnt FROM generic_cityobject;
    report.extend; report(report.count) := ('#GENERIC_CITYOBJECT:\t\t' || cnt);
    SELECT count(*) INTO cnt FROM cityobject_genericattrib;
    report.extend; report(report.count) := ('#CITYOBJECT_GENERICATTRIB:\t' || cnt);
  
    -- Appearance
    SELECT count(*) INTO cnt FROM appearance;
    report.extend; report(report.count) := ('#APPEARANCE:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM surface_data;
    report.extend; report(report.count) := ('#SURFACE_DATA:\t\t\t' || cnt);
    SELECT count(*) INTO cnt FROM appear_to_surface_data;
    report.extend; report(report.count) := ('#APPEAR_TO_SURFACE_DATA:\t' || cnt);
    SELECT count(*) INTO cnt FROM textureparam;
    report.extend; report(report.count) := ('#TEXTUREPARAM:\t\t\t' || cnt);  
  
    RETURN report;
  END;
  
END geodb_stat;
/