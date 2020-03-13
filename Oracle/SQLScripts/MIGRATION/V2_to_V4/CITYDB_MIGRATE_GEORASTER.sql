-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2020
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

CREATE OR REPLACE PACKAGE citydb_migrate_georaster
AS
  PROCEDURE fillRasterReliefTable(v2_schema_name VARCHAR2 := USER);
END citydb_migrate_georaster;
/

CREATE OR REPLACE PACKAGE BODY citydb_migrate_georaster
AS
  PROCEDURE fillRasterReliefTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Raster_Relief table is being copied...');
    -- fill grid_coverage table
    EXECUTE IMMEDIATE 'INSERT INTO grid_coverage
      SELECT id, rasterproperty FROM '||v2_schema_name||'.raster_relief ORDER BY id';
    -- fill raster_relief table
    EXECUTE IMMEDIATE 'INSERT INTO raster_relief
      SELECT id, 19 AS objectclass_id, CAST(null AS VARCHAR2(1000)) AS uri, id AS coverage_id
        FROM '||v2_schema_name||'.raster_relief ORDER BY id';
    dbms_output.put_line('Raster_Relief table copy is completed.');
  END;

END citydb_migrate_georaster;
/
