-- CREATE_GEODB_PKG.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
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
-- Creates subpackages "geodb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2008-09-10   release version                             CNag
--
SELECT 'Creating packages ''geodb_util'', ''geodb_idx'', ''geodb_stat'', ''geodb_delete_by_lineage'', ''geodb_delete'', and corresponding types' as message from DUAL;
@@PL_SQL/GEODB_PKG/UTIL/UTIL.sql;
@@PL_SQL/GEODB_PKG/INDEX/IDX.sql;
@@PL_SQL/GEODB_PKG/STATISTICS/STAT.sql;
@@PL_SQL/GEODB_PKG/DELETE/DELETE.sql;
@@PL_SQL/GEODB_PKG/DELETE/DELETE_BY_LINEAGE;
SELECT 'Packages ''geodb_util'', ''geodb_idx'', ''geodb_stat'', ''geodb_delete_by_lineage'', and ''geodb_delete'' created' as message from DUAL;

SELECT 'Creating matching tool packages ''geodb_match'', ''geodb_merge'', and corresponding types' as message from DUAL;
@@PL_SQL/GEODB_PKG/MATCHING/MATCH.sql;
@@PL_SQL/GEODB_PKG/MATCHING/MERGE.sql;
SELECT 'Packages ''geodb_match'', and ''geodb_merge'' created' as message from DUAL;

