-- DROP_CITYDB_PKG.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2015  Chair of Geoinformatics,
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
-- Drops subpackages "citydb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.1.0     2015-07-21   added citydb_envelope package               FKun
-- 2.0.0     2014-10-10   minor updates for 3DCityDB V3               FKun
-- 1.0.0     2008-09-10   release version                             CNag
--
SELECT 'Deleting packages ''citydb_util'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'' and corresponding types' as message from DUAL;

--// drop index table and corresponding sequence
DROP TABLE INDEX_TABLE CASCADE CONSTRAINTS;
DROP SEQUENCE INDEX_TABLE_SEQ;

--// drop global types
DROP TYPE STRARRAY;
DROP TYPE ID_ARRAY;
DROP TYPE INDEX_OBJ;
DROP TYPE DB_VERSION_TABLE;
DROP TYPE DB_VERSION_OBJ;
DROP TYPE DB_INFO_TABLE;
DROP TYPE DB_INFO_OBJ;

--// drop packages
DROP PACKAGE citydb_util;
DROP PACKAGE citydb_idx;
DROP PACKAGE citydb_srs;
DROP PACKAGE citydb_stat;
DROP PACKAGE citydb_envelope;
DROP PACKAGE citydb_delete_by_lineage;
DROP PACKAGE citydb_delete;

SELECT 'Packages ''citydb_util'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' deleted' as message from DUAL;