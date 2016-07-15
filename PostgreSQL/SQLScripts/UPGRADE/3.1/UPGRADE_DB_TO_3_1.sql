-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
--     
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
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
