-- MIGRATE_DB_V2_V3_SPTL.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>
--             Felix Kunde <felix-kunde@gmx.de>
--             Gyoergy Hudra <ghudra@moss.de>
--
-- Copyright:  (c) 2012-2016  Chair of Geoinformatics,
--                            Technische Universität München, Germany
--                            http://www.gis.bv.tum.de
--
--              This script is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates an PL/SQL package 'CITYDB_MIGRATE_V2_V3_SPTL' that contains
-- functions and procedures to perform migration process with spatial license
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2015-03-11   locator/spatial                             GHud
--

CREATE OR REPLACE PACKAGE citydb_migrate_v2_v3_sptl
AS
  PROCEDURE fillRasterReliefTable;
END citydb_migrate_v2_v3_sptl;
/

CREATE OR REPLACE PACKAGE BODY citydb_migrate_v2_v3_sptl
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
        (ID,COVERAGE_ID)
        values
        (raster_relief.ID,gridID);
    END LOOP;
    dbms_output.put_line('Raster_Relief table copy is completed.');
  END;

END citydb_migrate_v2_v3_sptl;
/
