-- BRIDGE_OPENING.sql
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
CREATE TABLE BRIDGE_OPENING 
(
ID NUMBER NOT NULL,
OBJECTCLASS_ID NUMBER,
ADDRESS_ID NUMBER,
LOD3_MULTI_SURFACE_ID NUMBER,
LOD4_MULTI_SURFACE_ID NUMBER,
LOD3_IMPLICIT_REP_ID NUMBER,
LOD3_IMPLICIT_REF_POINT MDSYS.SDO_GEOMETRY,
LOD3_IMPLICIT_TRANSFORMATION VARCHAR2(1000),
LOD4_IMPLICIT_REP_ID NUMBER,
LOD4_IMPLICIT_REF_POINT MDSYS.SDO_GEOMETRY,
LOD4_IMPLICIT_TRANSFORMATION VARCHAR2(1000)
)
;
ALTER TABLE BRIDGE_OPENING
ADD CONSTRAINT BRIDGE_OPENING_PK PRIMARY KEY 
(
  ID 
)
  ENABLE 
; 