-- THEMATIC_SURFACE.sql
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
CREATE TABLE THEMATIC_SURFACE
(
ID NUMBER NOT NULL,
NAME VARCHAR2(1000),
NAME_CODESPACE VARCHAR2(4000),
DESCRIPTION VARCHAR2(4000),
TYPE VARCHAR2(256),
BUILDING_ID NUMBER,
ROOM_ID NUMBER,
LOD2_MULTI_SURFACE_ID NUMBER,
LOD3_MULTI_SURFACE_ID NUMBER,
LOD4_MULTI_SURFACE_ID NUMBER
)
;
ALTER TABLE THEMATIC_SURFACE
ADD CONSTRAINT THEMATIC_SURFACE_PK PRIMARY KEY
(
ID
)
 ENABLE
;