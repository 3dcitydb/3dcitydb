-- UPGRADE_DB_TO_3_1.sql
--
-- Authors:     Felix Kunde <felix-kunde@gmx.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
-------------------------------------------------------------------------------
-- About:
-- Upgrade script from version 3.1 to version 3.2 of the 3D City Database
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.1     2016-03-24   update to version 3.2            			  ZYao 
-- 1.0.1     2016-02-17   DROP INDEX statements added for             TKolbe 
--                        ADDRESS_INX, CITYMODEL_INX.
--                        Removed lines with "\" after normal SQL
--                        statements (they are only necessary after
--                        PL/SQL commands).
-- 1.0.0     2015-11-05   release version                             FKun
--

SET SERVEROUTPUT ON

SELECT 'Starting 3D City Database upgrade...' as message from DUAL;

--// drop old versions of CITYDB_PKG
@DROP_CITYDB_PKG.sql

--// contents of @@../../CREATE_CITYDB_PKG.sql
SELECT 'Installing CITYDB packages...' as message from DUAL;
@@../../PL_SQL/CITYDB_PKG/UTIL/UTIL.sql;
@@../../PL_SQL/CITYDB_PKG/INDEX/IDX.sql;
@@../../PL_SQL/CITYDB_PKG/SRS/SRS.sql;
@@../../PL_SQL/CITYDB_PKG/STATISTICS/STAT.sql;
@@../../PL_SQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql;
@@../../PL_SQL/CITYDB_PKG/DELETE/DELETE.sql;
@@../../PL_SQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql;
SELECT 'CITYDB package installed.' as message from DUAL;

SELECT '3D City Database upgrade complete!' as message from DUAL;
