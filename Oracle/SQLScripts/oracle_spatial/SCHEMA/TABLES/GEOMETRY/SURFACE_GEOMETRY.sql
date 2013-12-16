-- SURFACE_GEOMETRY.sql
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
CREATE TABLE SURFACE_GEOMETRY
(
ID NUMBER NOT NULL,
GMLID VARCHAR2(256),
GMLID_CODESPACE VARCHAR2(1000),
PARENT_ID NUMBER,
ROOT_ID NUMBER,
IS_SOLID NUMBER(1, 0),
IS_COMPOSITE NUMBER(1, 0),
IS_TRIANGULATED NUMBER(1, 0),
IS_XLINK NUMBER(1, 0),
IS_REVERSE NUMBER(1, 0),
GEOMETRY MDSYS.SDO_GEOMETRY
)
;
ALTER TABLE SURFACE_GEOMETRY
ADD CONSTRAINT SURFACE_GEOMETRY_PK PRIMARY KEY
(
ID
)
 ENABLE
;