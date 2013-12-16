-- ENABLE_VERSIONING.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Gerhard König <gerhard.koenig@tu-berlin.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Alexandra Stadler <stadler@igg.tu-berlin.de>
--
-- Copyright:   (c) 2007-2008  Institute for Geodesy and Geoinformation Science,
--                             Technische Universit�t Berlin, Germany
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
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.1     2008-06-28   log message included                        TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--
SELECT 'EnableVersioning procedure is working, that takes a while.' as message from DUAL;


EXECUTE DBMS_WM.EnableVersioning('ADDRESS,ADDRESS_TO_BUILDING,APPEAR_TO_SURFACE_DATA,APPEARANCE,BREAKLINE_RELIEF,BUILDING,BUILDING_FURNITURE,BUILDING_INSTALLATION,CITY_FURNITURE,CITYMODEL,CITYOBJECT,CITYOBJECT_GENERICATTRIB,CITYOBJECT_MEMBER,CITYOBJECTGROUP,EXTERNAL_REFERENCE,GENERALIZATION,GENERIC_CITYOBJECT,GROUP_TO_CITYOBJECT,IMPLICIT_GEOMETRY,LAND_USE,MASSPOINT_RELIEF,OPENING,OPENING_TO_THEM_SURFACE,PLANT_COVER,RELIEF_COMPONENT,RELIEF_FEAT_TO_REL_COMP,RELIEF_FEATURE,ROOM,SOLITARY_VEGETAT_OBJECT,SURFACE_DATA,SURFACE_GEOMETRY,TEXTUREPARAM,THEMATIC_SURFACE,TIN_RELIEF,TRAFFIC_AREA,TRANSPORTATION_COMPLEX,WATERBOD_TO_WATERBND_SRF,WATERBODY,WATERBOUNDARY_SURFACE','VIEW_WO_OVERWRITE');