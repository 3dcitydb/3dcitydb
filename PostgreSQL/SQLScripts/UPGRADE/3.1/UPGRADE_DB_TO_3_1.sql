-- UPGRADE_DB_TO_3_1.sql
--
-- Authors:     Felix Kunde <felix-kunde@gmx.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
-------------------------------------------------------------------------------
-- About:
-- Upgrade script to version 3.1 of the 3D City Database
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2015-11-05   release version                             FKun
--

SET client_min_messages TO WARNING;

\echo 'Starting 3D City Database upgrade...'
\set ON_ERROR_STOP ON
\echo

--// drop obsolete indexes
DROP INDEX citydb.cityobject_inx;
DROP INDEX citydb.appearance_inx;
DROP INDEX citydb.surface_geom_inx;
DROP INDEX citydb.surface_data_inx;

--// add columns new in v3.1
ALTER TABLE citydb.citymodel
  ADD COLUMN gmlid_codespace VARCHAR(1000);

ALTER TABLE citydb.cityobject
  ADD COLUMN gmlid_codespace VARCHAR(1000);

ALTER TABLE citydb.appearance
  ADD COLUMN gmlid_codespace VARCHAR(1000);

ALTER TABLE citydb.surface_data
  ADD COLUMN gmlid_codespace VARCHAR(1000);
  
ALTER TABLE citydb.surface_geometry
  ADD COLUMN gmlid_codespace VARCHAR(1000);

ALTER TABLE citydb.address
  ADD COLUMN gmlid VARCHAR(256),
  ADD COLUMN gmlid_codespace VARCHAR(1000);

--// fill gmlid column in address table
UPDATE citydb.address SET gmlid = ('ID_'||id);

--// create new indexes
CREATE INDEX citymodel_inx ON citydb.citymodel (gmlid, gmlid_codespace);
CREATE INDEX cityobject_inx ON citydb.cityobject (gmlid, gmlid_codespace);
CREATE INDEX cityobject_lineage_inx ON citydb.cityobject (lineage);
CREATE INDEX appearance_inx ON citydb.appearance (gmlid, gmlid_codespace);
CREATE INDEX surface_geom_inx ON citydb.surface_geometry (gmlid, gmlid_codespace);
CREATE INDEX surface_data_inx ON citydb.surface_data (gmlid, gmlid_codespace);
CREATE INDEX address_inx ON citydb.address (gmlid, gmlid_codespace);
CREATE INDEX address_point_spx ON citydb.address USING gist (multi_point);
CREATE INDEX grid_coverage_spx ON citydb.grid_coverage USING gist (ST_ConvexHull(rasterproperty));

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
