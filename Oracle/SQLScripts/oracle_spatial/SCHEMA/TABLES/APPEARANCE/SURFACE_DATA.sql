-- SURFACE_DATA.sql
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
CREATE TABLE SURFACE_DATA
(
ID NUMBER NOT NULL,
GMLID VARCHAR2(256),
GMLID_CODESPACE VARCHAR2(1000),
NAME VARCHAR2(1000),
NAME_CODESPACE VARCHAR2(4000),
DESCRIPTION VARCHAR2(4000),
IS_FRONT NUMBER(1, 0),
TYPE VARCHAR2(30),
X3D_SHININESS BINARY_DOUBLE,
X3D_TRANSPARENCY BINARY_DOUBLE,
X3D_AMBIENT_INTENSITY BINARY_DOUBLE,
X3D_SPECULAR_COLOR VARCHAR2(256),
X3D_DIFFUSE_COLOR VARCHAR2(256),
X3D_EMISSIVE_COLOR VARCHAR2(256),
X3D_IS_SMOOTH NUMBER(1, 0),
TEX_IMAGE_URI VARCHAR2(4000),
TEX_IMAGE ORDSYS.ORDIMAGE,
TEX_MIME_TYPE VARCHAR2(256),
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