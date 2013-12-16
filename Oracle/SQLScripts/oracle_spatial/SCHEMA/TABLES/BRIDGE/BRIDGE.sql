-- BRIDGE.sql
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
--
CREATE TABLE BRIDGE 
(
ID NUMBER NOT NULL,
BRIDGE_PARENT_ID NUMBER,
BRIDGE_ROOT_ID NUMBER,
CLASS VARCHAR2(256),
CLASS_CODESPACE VARCHAR2(4000),
FUNCTION VARCHAR2(1000),
FUNCTION_CODESPACE VARCHAR2(4000),
USAGE VARCHAR2(1000),
USAGE_CODESPACE VARCHAR2(4000),
YEAR_OF_CONSTRUCTION DATE,
YEAR_OF_DEMOLITION DATE,
IS_MOVABLE NUMBER(1, 0),
LOD1_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD2_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD3_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD4_TERRAIN_INTERSECTION MDSYS.SDO_GEOMETRY,
LOD2_MULTI_CURVE MDSYS.SDO_GEOMETRY,
LOD3_MULTI_CURVE MDSYS.SDO_GEOMETRY,
LOD4_MULTI_CURVE MDSYS.SDO_GEOMETRY,
LOD1_MULTI_SURFACE_ID NUMBER,
LOD2_MULTI_SURFACE_ID NUMBER,
LOD3_MULTI_SURFACE_ID NUMBER,
LOD4_MULTI_SURFACE_ID NUMBER,
LOD1_SOLID_ID NUMBER,
LOD2_SOLID_ID NUMBER,
LOD3_SOLID_ID NUMBER,
LOD4_SOLID_ID NUMBER
)
;
ALTER TABLE BRIDGE
ADD CONSTRAINT BRIDGE_PK PRIMARY KEY 
(
  ID 
)
  ENABLE 
;