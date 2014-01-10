-- CREATE_DB2.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Philipp Willkomm <pwillkomm@moss.de>
--              Gerhard König <gerhard.koenig@tu-berlin.de>
--              Alexandra Lorenz <di.alex.lorenz@googlemail.com>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
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
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
-- 2.0.1     2008-06-28   versioning is enabled depending on var      TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ALor
--

--
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

VARIABLE VERSIONBATCHFILE VARCHAR2(50);

-- This script is called from CREATE_DB.sql and it
-- is required that the three substitution variables
-- &SRSNO, &GMLSRSNAME, and &VERSIONING are set properly.

--// create database srs
@@SCHEMA/TABLES/METADATA/DATABASE_SRS.sql

INSERT INTO DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (&SRSNO,'&GMLSRSNAME');
COMMIT;

--// create tables
@@SCHEMA/TABLES/METADATA/OBJECTCLASS.sql
@@SCHEMA/TABLES/CORE/CITYMODEL.sql
@@SCHEMA/TABLES/CORE/CITYOBJECT.sql
@@SCHEMA/TABLES/CORE/CITYOBJECT_MEMBER.sql
@@SCHEMA/TABLES/CORE/EXTERNAL_REFERENCE.sql
@@SCHEMA/TABLES/CORE/GENERALIZATION.sql
@@SCHEMA/TABLES/CORE/IMPLICIT_GEOMETRY.sql
@@SCHEMA/TABLES/GEOMETRY/SURFACE_GEOMETRY.sql
@@SCHEMA/TABLES/CITYFURNITURE/CITY_FURNITURE.sql
@@SCHEMA/TABLES/GENERICS/CITYOBJECT_GENERICATTRIB.sql
@@SCHEMA/TABLES/GENERICS/GENERIC_CITYOBJECT.sql
@@SCHEMA/TABLES/CITYOBJECTGROUP/CITYOBJECTGROUP.sql
@@SCHEMA/TABLES/CITYOBJECTGROUP/GROUP_TO_CITYOBJECT.sql
@@SCHEMA/TABLES/BUILDING/ADDRESS.sql
@@SCHEMA/TABLES/BUILDING/ADDRESS_TO_BUILDING.sql
@@SCHEMA/TABLES/BUILDING/BUILDING.sql
@@SCHEMA/TABLES/BUILDING/BUILDING_FURNITURE.sql
@@SCHEMA/TABLES/BUILDING/BUILDING_INSTALLATION.sql
@@SCHEMA/TABLES/BUILDING/OPENING.sql
@@SCHEMA/TABLES/BUILDING/OPENING_TO_THEM_SURFACE.sql
@@SCHEMA/TABLES/BUILDING/ROOM.sql
@@SCHEMA/TABLES/BUILDING/THEMATIC_SURFACE.sql
@@SCHEMA/TABLES/APPEARANCE/APPEARANCE.sql
@@SCHEMA/TABLES/APPEARANCE/SURFACE_DATA.sql
@@SCHEMA/TABLES/APPEARANCE/TEXTUREPARAM.sql
@@SCHEMA/TABLES/APPEARANCE/APPEAR_TO_SURFACE_DATA.sql
@@SCHEMA/TABLES/APPEARANCE/TEX_IMAGE.sql
@@SCHEMA/TABLES/RELIEF/BREAKLINE_RELIEF.sql
@@SCHEMA/TABLES/RELIEF/MASSPOINT_RELIEF.sql
@@SCHEMA/TABLES/RELIEF/RASTER_RELIEF.sql
@@SCHEMA/TABLES/RELIEF/RASTER_RELIEF_GEORASTER.sql
@@SCHEMA/TABLES/RELIEF/RASTER_REL_GEORASTER_RDT.sql
@@SCHEMA/TABLES/RELIEF/RELIEF_COMPONENT.sql
@@SCHEMA/TABLES/RELIEF/RELIEF_FEAT_TO_REL_COMP.sql
@@SCHEMA/TABLES/RELIEF/RELIEF_FEATURE.sql
@@SCHEMA/TABLES/RELIEF/TIN_RELIEF.sql
@@SCHEMA/TABLES/TRANSPORTATION/TRANSPORTATION_COMPLEX.sql
@@SCHEMA/TABLES/TRANSPORTATION/TRAFFIC_AREA.sql
@@SCHEMA/TABLES/LANDUSE/LAND_USE.sql
@@SCHEMA/TABLES/VEGETATION/PLANT_COVER.sql
@@SCHEMA/TABLES/VEGETATION/SOLITARY_VEGETAT_OBJECT.sql
@@SCHEMA/TABLES/WATERBODY/WATERBODY.sql
@@SCHEMA/TABLES/WATERBODY/WATERBOD_TO_WATERBND_SRF.sql
@@SCHEMA/TABLES/WATERBODY/WATERBOUNDARY_SURFACE.sql
@@SCHEMA/TABLES/BRIDGE/ADDRESS_TO_BRIDGE.sql
@@SCHEMA/TABLES/BRIDGE/BRD_CONSTR_ELEMENT.sql
@@SCHEMA/TABLES/BRIDGE/BRD_OPEN_TO_THEM_SURFACE.sql
@@SCHEMA/TABLES/BRIDGE/BRD_THEMATIC_SURFACE.sql
@@SCHEMA/TABLES/BRIDGE/BRIDGE_FURNITURE.sql
@@SCHEMA/TABLES/BRIDGE/BRIDGE_INSTALLATION.sql
@@SCHEMA/TABLES/BRIDGE/BRIDGE_OPENING.sql
@@SCHEMA/TABLES/BRIDGE/BRIDGE_ROOM.sql
@@SCHEMA/TABLES/BRIDGE/BRIDGE.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL_FURNITURE.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL_HOLLOWSPACE.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL_INSTALLATION.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL_OPEN_TO_THEM_SURF.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL_OPENING.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL_THEMATIC_SURFACE.sql
@@SCHEMA/TABLES/TUNNEL/TUNNEL.sql

--// create sequences
@@SCHEMA/SEQUENCES/CITYMODEL_SEQ.sql
@@SCHEMA/SEQUENCES/CITYOBJECT_SEQ.sql
@@SCHEMA/SEQUENCES/EXTERNAL_REF_SEQ.sql
@@SCHEMA/SEQUENCES/IMPLICIT_GEOMETRY_SEQ.sql
@@SCHEMA/SEQUENCES/SURFACE_GEOMETRY_SEQ.sql
@@SCHEMA/SEQUENCES/RASTER_REL_GEORASTER_SEQ.sql
@@SCHEMA/SEQUENCES/RASTER_REL_GEORST_RDT_SEQ.sql
@@SCHEMA/SEQUENCES/CITYOBJECT_GENERICATT_SEQ.sql
@@SCHEMA/SEQUENCES/ADDRESS_SEQ.sql
@@SCHEMA/SEQUENCES/APPEARANCE_SEQ.sql
@@SCHEMA/SEQUENCES/SURFACE_DATA_SEQ.sql
@@SCHEMA/SEQUENCES/TEX_IMAGE_SEQ.sql

--// activate constraints
@@SCHEMA/CONSTRAINTS/CONSTRAINTS.sql

--// BUILD INDEXES
@@SCHEMA/INDEXES/SIMPLE_INDEX.sql
@@SCHEMA/INDEXES/SPATIAL_INDEX.sql

@@UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql

--// (possibly) activate versioning
BEGIN
  :VERSIONBATCHFILE := 'UTIL/CREATE_DB/DO_NOTHING.sql';
END;
/
BEGIN
  IF ('&VERSIONING'='yes' OR '&VERSIONING'='YES' OR '&VERSIONING'='y' OR '&VERSIONING'='Y') THEN
    :VERSIONBATCHFILE := 'ENABLE_VERSIONING.sql';
  END IF;
END;
/
-- Transfer the value from the bind variable to the substitution variable
column mc2 new_value VERSIONBATCHFILE2 print
select :VERSIONBATCHFILE mc2 from dual;
@@&VERSIONBATCHFILE2

--// CREATE TABLES & PROCEDURES OF THE PLANNINGMANAGER

@@CREATE_PLANNING_MANAGER.sql

--// geodb packages

@@CREATE_GEODB_PKG.sql

SHOW ERRORS;
COMMIT;

SELECT 'DB creation complete!' as message from DUAL;
