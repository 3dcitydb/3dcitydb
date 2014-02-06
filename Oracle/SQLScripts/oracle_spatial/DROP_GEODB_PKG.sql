-- DROP_GEODB_PKG.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
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
-- Drops subpackages "geodb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.0     2014-01-09   minor updates for 3DCityDB V3               FKun
-- 1.0.0     2008-09-10   release version                             CNag
--
SELECT 'Deleting packages ''geodb_util'', ''geodb_idx'', ''geodb_srs'', ''geodb_stat'', ''geodb_delete_by_lineage'', ''geodb_delete'' and corresponding types' as message from DUAL;
--// drop global types
DROP TYPE STRARRAY;
DROP TYPE SEQ_TABLE;
DROP TYPE INDEX_OBJ;
DROP TYPE DB_INFO_TABLE;
DROP TYPE DB_INFO_OBJ;

--// drop packages
DROP PACKAGE geodb_util;
DROP PACKAGE geodb_idx;
DROP PACKAGE geodb_srs;
DROP PACKAGE geodb_stat;
DROP PACKAGE geodb_delete_by_lineage;
DROP PACKAGE geodb_delete;

SELECT 'Packages ''geodb_util'', ''geodb_idx'', ''geodb_srs'', ''geodb_stat'', ''geodb_delete_by_lineage'', and ''geodb_delete'' deleted' as message from DUAL;