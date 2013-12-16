-- CITYOBJECT_GENERICATTRIB.sql
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
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ALor
--
CREATE TABLE CITYOBJECT_GENERICATTRIB
(
ID NUMBER NOT NULL,
PARENT_GENATT_ID NUMBER,
ROOT_GENATT_ID NUMBER,
ATTRNAME VARCHAR2(256) NOT NULL,
DATATYPE NUMBER(1),
STRVAL VARCHAR2(4000),
INTVAL NUMBER,
REALVAL NUMBER,
URIVAL VARCHAR2(4000),
DATEVAL DATE,
GEOMVAL MDSYS.SDO_GEOMETRY,
BLOBVAL BLOB,
UNIT VARCHAR2(4000),
CITYOBJECT_ID NUMBER NOT NULL,
SURFACE_GEOMETRY_ID NUMBER,
GRP_CODESPACE VARCHAR2(4000) 
)
;
ALTER TABLE CITYOBJECT_GENERICATTRIB
ADD CONSTRAINT CITYOBJ_GENERICATTRIB_PK PRIMARY KEY
(
ID
)
 ENABLE
;