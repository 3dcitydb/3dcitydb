-- CREATE_GEODB_PKG.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>

-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de

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

