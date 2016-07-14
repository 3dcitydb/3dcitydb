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
-------------------------------------------------------------------------------
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2015-03-05   added support for Oracle Locator            ZYao
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
-- 2.0.1     2008-06-28   log message included                        TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--

SELECT 'EnableVersioning procedure is working, that takes a while.' as message from DUAL;

-- for Oracle locator, the RASTER_RELIEF and GRID_COVERAGE_RDT tables are not exist
BEGIN
  IF ('&DBVERSION'='S' or '&DBVERSION'='s') THEN
    DBMS_WM.EnableVersioning('ADDRESS,ADDRESS_TO_BRIDGE,ADDRESS_TO_BUILDING,APPEAR_TO_SURFACE_DATA,APPEARANCE,BREAKLINE_RELIEF,BRIDGE,BRIDGE_CONSTR_ELEMENT,BRIDGE_FURNITURE,BRIDGE_INSTALLATION,BRIDGE_OPEN_TO_THEM_SRF,BRIDGE_OPENING,BRIDGE_ROOM,BRIDGE_THEMATIC_SURFACE,BUILDING,BUILDING_FURNITURE,BUILDING_INSTALLATION,CITY_FURNITURE,CITYMODEL,CITYOBJECT,CITYOBJECT_GENERICATTRIB,CITYOBJECT_MEMBER,CITYOBJECTGROUP,EXTERNAL_REFERENCE,GENERALIZATION,GENERIC_CITYOBJECT,GROUP_TO_CITYOBJECT,IMPLICIT_GEOMETRY,LAND_USE,MASSPOINT_RELIEF,OPENING,OPENING_TO_THEM_SURFACE,PLANT_COVER,GRID_COVERAGE_RDT,RASTER_RELIEF,RELIEF_COMPONENT,RELIEF_FEAT_TO_REL_COMP,RELIEF_FEATURE,ROOM,SOLITARY_VEGETAT_OBJECT,SURFACE_DATA,SURFACE_GEOMETRY,TEX_IMAGE,TEXTUREPARAM,THEMATIC_SURFACE,TIN_RELIEF,TRAFFIC_AREA,TRANSPORTATION_COMPLEX,TUNNEL,TUNNEL_FURNITURE,TUNNEL_HOLLOW_SPACE,TUNNEL_INSTALLATION,TUNNEL_OPEN_TO_THEM_SRF,TUNNEL_OPENING,TUNNEL_THEMATIC_SURFACE,WATERBOD_TO_WATERBND_SRF,WATERBODY,WATERBOUNDARY_SURFACE','VIEW_WO_OVERWRITE'); 
  ELSE
  	DBMS_WM.EnableVersioning('ADDRESS,ADDRESS_TO_BRIDGE,ADDRESS_TO_BUILDING,APPEAR_TO_SURFACE_DATA,APPEARANCE,BREAKLINE_RELIEF,BRIDGE,BRIDGE_CONSTR_ELEMENT,BRIDGE_FURNITURE,BRIDGE_INSTALLATION,BRIDGE_OPEN_TO_THEM_SRF,BRIDGE_OPENING,BRIDGE_ROOM,BRIDGE_THEMATIC_SURFACE,BUILDING,BUILDING_FURNITURE,BUILDING_INSTALLATION,CITY_FURNITURE,CITYMODEL,CITYOBJECT,CITYOBJECT_GENERICATTRIB,CITYOBJECT_MEMBER,CITYOBJECTGROUP,EXTERNAL_REFERENCE,GENERALIZATION,GENERIC_CITYOBJECT,GROUP_TO_CITYOBJECT,IMPLICIT_GEOMETRY,LAND_USE,MASSPOINT_RELIEF,OPENING,OPENING_TO_THEM_SURFACE,PLANT_COVER,RELIEF_COMPONENT,RELIEF_FEAT_TO_REL_COMP,RELIEF_FEATURE,ROOM,SOLITARY_VEGETAT_OBJECT,SURFACE_DATA,SURFACE_GEOMETRY,TEX_IMAGE,TEXTUREPARAM,THEMATIC_SURFACE,TIN_RELIEF,TRAFFIC_AREA,TRANSPORTATION_COMPLEX,TUNNEL,TUNNEL_FURNITURE,TUNNEL_HOLLOW_SPACE,TUNNEL_INSTALLATION,TUNNEL_OPEN_TO_THEM_SRF,TUNNEL_OPENING,TUNNEL_THEMATIC_SURFACE,WATERBOD_TO_WATERBND_SRF,WATERBODY,WATERBOUNDARY_SURFACE','VIEW_WO_OVERWRITE');  
  END IF;
END;
/

