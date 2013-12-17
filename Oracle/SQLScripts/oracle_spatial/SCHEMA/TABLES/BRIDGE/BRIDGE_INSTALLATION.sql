-- BRIDGE_INSTALLATION.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Philipp Willkomm <pwillkomm@moss.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
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
CREATE TABLE BRIDGE_INSTALLATION 
(
ID NUMBER NOT NULL,
IS_EXTERNAL NUMBER(1, 0),
CLASS VARCHAR2(256),
CLASS_CODESPACE VARCHAR2(4000),
FUNCTION VARCHAR2(1000),
FUNCTION_CODESPACE VARCHAR2(4000),
USAGE VARCHAR2(1000),
USAGE_CODESPACE VARCHAR2(4000),
BRIDGE_ID NUMBER,
BRIDGE_ROOM_ID NUMBER,
LOD2_IMPLICIT_REP_ID NUMBER,
LOD2_IMPLICIT_REF_POINT MDSYS.SDO_GEOMETRY,
LOD2_IMPLICIT_TRANSFORMATION VARCHAR2(1000),
LOD3_IMPLICIT_REP_ID NUMBER,
LOD3_IMPLICIT_REF_POINT MDSYS.SDO_GEOMETRY, 
LOD3_IMPLICIT_TRANSFORMATION VARCHAR2(1000),
LOD4_IMPLICIT_REP_ID NUMBER,
LOD4_IMPLICIT_REF_POINT MDSYS.SDO_GEOMETRY,
LOD4_IMPLICIT_TRANSFORMATION VARCHAR2(1000),
LOD2_BREP_ID NUMBER,
LOD3_BREP_ID NUMBER,
LOD4_BREP_ID NUMBER,
LOD2_OTHER_GEOM MDSYS.SDO_GEOMETRY,
LOD3_OTHER_GEOM MDSYS.SDO_GEOMETRY,
LOD4_OTHER_GEOM MDSYS.SDO_GEOMETRY 
)
;
ALTER TABLE BRIDGE_INSTALLATION
ADD CONSTRAINT BRIDGE_INSTALLATION_PK PRIMARY KEY 
(
  ID 
)
 ENABLE 
;

