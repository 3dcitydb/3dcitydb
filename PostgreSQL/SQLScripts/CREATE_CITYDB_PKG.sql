-- CREATE_CITYDB_PKG.sql
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
-- Creates schema "citydb_pkg.*
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description               | Author
-- 1.0.0     2012-05-21   release version             CNag
--                                                    FKun
--

-------------------------------------------------------------------------------
-- Conversion-Report:
-- PACKAGES do not exist in PostgreSQL. 
-- Only within PostgreSQL Plus Advance Server from EnterpriseDB.
-- The use of schemas is proposed. Thus usage-rights may have to be set.
-------------------------------------------------------------------------------

--// create CITYDB_PKG schema
CREATE SCHEMA citydb_pkg;

--// call PL/pgSQL-Scripts to add CITYDB_PKG-Functions
\i PL_pgSQL/CITYDB_PKG/UTIL/UTIL.sql
\i PL_pgSQL/CITYDB_PKG/INDEX/IDX.sql
\i PL_pgSQL/CITYDB_PKG/SRS/SRS.sql
\i PL_pgSQL/CITYDB_PKG/STATISTICS/STAT.sql
\i PL_pgSQL/CITYDB_PKG/DELETE/DELETE.sql
\i PL_pgSQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql