-- BUILDING.sql
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
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ASta
--
CREATE TABLE BUILDING
(
ID NUMBER NOT NULL,
NAME VARCHAR2(1000),
NAME_CODESPACE VARCHAR2(4000),
BUILDING_PARENT_ID NUMBER,
BUILDING_ROOT_ID NUMBER,
DESCRIPTION VARCHAR2(4000),
CLASS VARCHAR2(256),
FUNCTION VARCHAR2(1000),
USAGE VARCHAR2(1000),
YEAR_OF_CONSTRUCTION DATE,
YEAR_OF_DEMOLITION DATE,
ROOF_TYPE VARCHAR2(256),
MEASURED_HEIGHT BINARY_DOUBLE,
STOREYS_ABOVE_GROUND NUMBER(8),
STOREYS_BELOW_GROUND NUMBER(8),
STOREY_HEIGHTS_ABOVE_GROUND VARCHAR2(4000),
STOREY_HEIGHTS_BELOW_GROUND VARCHAR2(4000),
LOD1_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD2_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD3_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD4_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD2_MULTI_CURVE MDSYS.SDO_GEOMETRY,
LOD3_MULTI_CURVE MDSYS.SDO_GEOMETRY,
LOD4_MULTI_CURVE MDSYS.SDO_GEOMETRY,
LOD1_GEOMETRY_ID NUMBER,
LOD2_GEOMETRY_ID NUMBER,
LOD3_GEOMETRY_ID NUMBER,
LOD4_GEOMETRY_ID NUMBER
)
;
ALTER TABLE BUILDING
ADD CONSTRAINT BUILDING_PK PRIMARY KEY
(
ID
)
 ENABLE
;