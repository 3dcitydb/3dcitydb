-- CREATE_DB2.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Philipp Willkomm <pwillkomm@moss.de>
--              Gerhard König <gerhard.koenig@tu-berlin.de>
--              Alexandra Lorenz <di.alex.lorenz@googlemail.com>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
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
-- 3.0.0     2015-03-05   added support for Oracle Locator            ZYao
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
-- 2.0.1     2008-06-28   versioning is enabled depending on var      TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ALor
--

--
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

VARIABLE VERSIONBATCHFILE VARCHAR2(50);


--// create tables
@@SCHEMA/TABLES/TABLES.sql

-- This script is called from CREATE_DB.sql and it
-- is required that the three substitution variables
-- &SRSNO, &GMLSRSNAME, and &VERSIONING are set properly.

INSERT INTO DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (&SRSNO,'&GMLSRSNAME');
COMMIT;

--// create sequences
@@SCHEMA/SEQUENCES/SEQUENCES.sql

--// activate constraints
@@SCHEMA/CONSTRAINTS/CONSTRAINTS.sql

--// build indexes
@@SCHEMA/INDEXES/SIMPLE_INDEX.sql
@@SCHEMA/INDEXES/SPATIAL_INDEX.sql

--// create objectclass instances
@@UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql

--// (possibly) activate versioning
BEGIN
  :VERSIONBATCHFILE := 'UTIL/CREATE_DB/DO_NOTHING.sql';
END;
/
BEGIN
  IF ('&VERSIONING'='yes' OR '&VERSIONING'='YES' OR '&VERSIONING'='y' OR '&VERSIONING'='Y') THEN
    :VERSIONBATCHFILE := 'ENABLE_VERSIONING2.sql';
  END IF;
END;
/
-- Transfer the value from the bind variable to the substitution variable
column mc2 new_value VERSIONBATCHFILE2 print
select :VERSIONBATCHFILE mc2 from dual;
@@&VERSIONBATCHFILE2

--// citydb packages
@@CREATE_CITYDB_PKG.sql

SHOW ERRORS;
COMMIT;

SELECT 'DB creation complete!' as message from DUAL;
