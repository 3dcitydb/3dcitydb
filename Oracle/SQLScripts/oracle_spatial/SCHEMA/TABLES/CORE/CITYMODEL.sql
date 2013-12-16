-- CITYMODEL.sql
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
CREATE TABLE CITYMODEL
(
ID NUMBER NOT NULL,
GMLID VARCHAR2(256),
NAME VARCHAR2(1000),
NAME_CODESPACE VARCHAR2(4000),
DESCRIPTION VARCHAR2(4000),
ENVELOPE MDSYS.SDO_GEOMETRY,
CREATION_DATE TIMESTAMP,
TERMINATION_DATE TIMESTAMP,
LAST_MODIFICATION_DATE TIMESTAMP,
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