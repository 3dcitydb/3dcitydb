-- BRD_THEMATIC_SURFACE.sql
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
CREATE TABLE BRD_THEMATIC_SURFACE 
(
ID NUMBER NOT NULL,
OBJECTCLASS_ID NUMBER,
BRIDGE_ID NUMBER,
BRIDGE_ROOM_ID NUMBER,
BRIDGE_INSTALLATION_ID NUMBER,
BRIDGE_CONSTR_ELEM_ID NUMBER,
LOD2_MULTI_SURFACE_ID NUMBER,
LOD3_MULTI_SURFACE_ID NUMBER,
LOD4_MULTI_SURFACE_ID NUMBER
)
;
ALTER TABLE BRD_THEMATIC_SURFACE
ADD CONSTRAINT BIRDGE_THEMATIC_SURFACE_PK PRIMARY KEY 
(
  ID 
)
 ENABLE 
; 