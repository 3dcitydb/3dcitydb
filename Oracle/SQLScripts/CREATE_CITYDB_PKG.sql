-- CREATE_CITYDB_PKG.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2015  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
-- Copyright:   (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates subpackages "citydb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.1.0     2015-07-21   added citydb_envelope package               FKun
-- 2.0.0     2014-10-10   minor updates for 3DCityDB V3               FKun
-- 1.0.0     2008-09-10   release version                             CNag
--

VARIABLE DELETE_FILE VARCHAR2(50);

SELECT 'Creating packages ''citydb_util'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'', and corresponding types' as message from DUAL;
@@PL_SQL/CITYDB_PKG/UTIL/UTIL.sql;
@@PL_SQL/CITYDB_PKG/INDEX/IDX.sql;
@@PL_SQL/CITYDB_PKG/SRS/SRS.sql;
@@PL_SQL/CITYDB_PKG/STATISTICS/STAT.sql;
@@PL_SQL/CITYDB_PKG/STATISTICS/ENVELOPE.sql;

BEGIN
  IF ('&DBVERSION'='S' or '&DBVERSION'='s') THEN
    :DELETE_FILE := 'PL_SQL/CITYDB_PKG/DELETE/DELETE.sql';
  ELSE
    :DELETE_FILE := 'PL_SQL/CITYDB_PKG/DELETE/DELETE2.sql';
  END IF;
END;
/

-- Transfer the value from the bind variable to the substitution variable
column mc new_value DELETE_FILE2 print
select :DELETE_FILE mc from dual;
@@&DELETE_FILE2;

@@PL_SQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE;
SELECT 'Packages ''citydb_util'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' created' as message from DUAL;

