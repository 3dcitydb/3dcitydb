-- CITYOBJECT_GENERICATTRIB.sql
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
CREATE TABLE CITYOBJECT_GENERICATTRIB
(
ID NUMBER NOT NULL,
ATTRNAME VARCHAR2(256) NOT NULL,
DATATYPE NUMBER(1),
STRVAL VARCHAR2(4000),
INTVAL NUMBER,
REALVAL NUMBER,
URIVAL VARCHAR2(4000),
DATEVAL DATE,
GEOMVAL MDSYS.SDO_GEOMETRY,
BLOBVAL BLOB,
CITYOBJECT_ID NUMBER NOT NULL,
SURFACE_GEOMETRY_ID NUMBER
)
;
ALTER TABLE CITYOBJECT_GENERICATTRIB
ADD CONSTRAINT CITYOBJ_GENERICATTRIB_PK PRIMARY KEY
(
ID
)
 ENABLE
;