-- TIN_RELIEF.sql
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
--
-- DROP TABLE TIN_RELIEF CASCADE CONSTRAINT PURGE;                                                                    ASta

CREATE TABLE TIN_RELIEF
(
ID NUMBER NOT NULL,
MAX_LENGTH BINARY_DOUBLE,
STOP_LINES MDSYS.SDO_GEOMETRY,
BREAK_LINES MDSYS.SDO_GEOMETRY,
CONTROL_POINTS MDSYS.SDO_GEOMETRY,
SURFACE_GEOMETRY_ID NUMBER
)
;
ALTER TABLE TIN_RELIEF
ADD CONSTRAINT TIN_RELIEF_PK PRIMARY KEY
(
ID
)
 ENABLE
;