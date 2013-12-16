-- CITYMODEL.sql
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
CREATE TABLE CITYMODEL
(
ID NUMBER NOT NULL,
GMLID VARCHAR2(256),
GMLID_CODESPACE VARCHAR2(1000),
NAME VARCHAR2(1000),
NAME_CODESPACE VARCHAR2(4000),
DESCRIPTION VARCHAR2(4000),
ENVELOPE MDSYS.SDO_GEOMETRY,
CREATION_DATE DATE,
TERMINATION_DATE DATE,
LAST_MODIFICATION_DATE DATE,
UPDATING_PERSON VARCHAR2(256),
REASON_FOR_UPDATE VARCHAR2(4000),
LINEAGE VARCHAR2(256)
)
;
ALTER TABLE CITYMODEL
ADD CONSTRAINT CITYMODEL_PK PRIMARY KEY
(
ID
)
 ENABLE
;