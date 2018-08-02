-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2018
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

CREATE OR REPLACE PACKAGE citydb_migrate_sptl
AS
  PROCEDURE fillRasterReliefTable;
END citydb_migrate_sptl;
/

CREATE OR REPLACE PACKAGE BODY citydb_migrate_sptl
AS
  type ref_cursor is ref cursor;
 
  PROCEDURE fillRasterReliefTable
  IS
    -- variables --
    CURSOR raster_relief_v2 IS select * from raster_relief_v2 order by id;
    gridID NUMBER(10);
  BEGIN
    dbms_output.put_line('Raster_Relief table is being copied...');
    FOR raster_relief IN raster_relief_v2 LOOP
        -- Add the Raster Property into the Grid Coverage Table
        IF (raster_relief.RASTERPROPERTY IS NOT NULL) THEN
           gridID := GRID_COVERAGE_SEQ.NEXTVAL;
           insert into grid_coverage
           (ID,RASTERPROPERTY)
           values
           (gridID,raster_relief.RASTERPROPERTY) ;
        END IF;

        -- Is the raster relief id the same as raster component id?
        insert into raster_relief
        (ID, OBJECTCLASS_ID, COVERAGE_ID)
        values
        (raster_relief.ID, 19, gridID);
    END LOOP;
    dbms_output.put_line('Raster_Relief table copy is completed.');
  END;

END citydb_migrate_sptl;
/
