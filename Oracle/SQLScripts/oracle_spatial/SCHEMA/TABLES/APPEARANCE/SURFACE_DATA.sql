-- SURFACE_DATA.sql
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
CREATE TABLE SURFACE_DATA
(
ID NUMBER NOT NULL,
GMLID VARCHAR2(256),
NAME VARCHAR2(1000),
NAME_CODESPACE VARCHAR2(4000),
DESCRIPTION VARCHAR2(4000),
IS_FRONT NUMBER(1, 0),
OBJECTCLASS_ID NUMBER, 
X3D_SHININESS BINARY_DOUBLE,
X3D_TRANSPARENCY BINARY_DOUBLE,
X3D_AMBIENT_INTENSITY BINARY_DOUBLE,
X3D_SPECULAR_COLOR VARCHAR2(256),
X3D_DIFFUSE_COLOR VARCHAR2(256),
X3D_EMISSIVE_COLOR VARCHAR2(256),
X3D_IS_SMOOTH NUMBER(1, 0),
TEX_IMAGE_ID NUMBER, 
TEX_TEXTURE_TYPE VARCHAR2(256),
TEX_WRAP_MODE VARCHAR2(256),
TEX_BORDER_COLOR VARCHAR2(256),
GT_PREFER_WORLDFILE NUMBER(1, 0),
GT_ORIENTATION VARCHAR2(256),
GT_REFERENCE_POINT MDSYS.SDO_GEOMETRY
)
;
ALTER TABLE SURFACE_DATA
ADD CONSTRAINT SURFACE_DATA_PK PRIMARY KEY
(
ID
)
 ENABLE
;