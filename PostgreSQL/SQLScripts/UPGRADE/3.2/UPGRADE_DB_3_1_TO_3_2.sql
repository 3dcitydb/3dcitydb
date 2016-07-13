-- UPGRADE_DB_TO_3_2.sql
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
-- Upgrade script from version 3.1 to 3.2 of the 3D City Database
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.1     2016-03-24   release version                             ZYao
-- 1.0.0     2015-11-05   release version                             FKun
--

SET client_min_messages TO WARNING;

\echo 'Starting 3D City Database upgrade...'
\set ON_ERROR_STOP ON
\echo

--// drop old versions of CITYDB_PKG
DROP SCHEMA CITYDB_PKG CASCADE;

--// create CITYDB_PKG
\echo
\echo 'Upgrading CITYDB_PKG schema...'
CREATE SCHEMA CITYDB_PKG;

--// call PL/pgSQL-Scripts to add CITYDB_PKG functions
\i ../../PL_pgSQL/CITYDB_PKG/UTIL/UTIL.sql
\i ../../PL_pgSQL/CITYDB_PKG/INDEX/IDX.sql
\i ../../PL_pgSQL/CITYDB_PKG/SRS/SRS.sql
\i ../../PL_pgSQL/CITYDB_PKG/STATISTICS/STAT.sql
\i ../../PL_pgSQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql
\i ../../PL_pgSQL/CITYDB_PKG/DELETE/DELETE.sql
\i ../../PL_pgSQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql

\echo
\echo '3D City Database upgrade complete!'
