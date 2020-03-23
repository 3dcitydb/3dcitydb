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

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

BEGIN 
  dbms_output.put_line('Oracle-Version: '||DBMS_DB_VERSION.VERSION||'.'||DBMS_DB_VERSION.RELEASE);
END;
/

DEFINE TEXOP=&1;
DEFINE DBVERSION=&2;
DEFINE V2USER=&3;

VARIABLE MGRPBATCHFILE VARCHAR2(50);

BEGIN
  dbms_output.put_line('Starting DB migration... ' || SYSTIMESTAMP);
END;
/

-- check for SDO_GEORASTER support
VARIABLE GEORASTER_SUPPORT NUMBER;
BEGIN
  :GEORASTER_SUPPORT := 0;
  IF (upper('&DBVERSION')='S') THEN
    SELECT COUNT(*) INTO :GEORASTER_SUPPORT FROM ALL_SYNONYMS
	WHERE SYNONYM_NAME='SDO_GEORASTER';
  END IF;

  IF :GEORASTER_SUPPORT = 0 THEN
	dbms_output.put_line('NOTE: The data type SDO_GEORASTER is not available for this database. Raster relief tables will not be created.');
  END IF;
END;
/

BEGIN
  dbms_output.put_line('Installing the package with functions and procedures for migration...');	
END;
/

-- Drop the existing indexes (non-spatial indexes)
BEGIN
  dbms_output.put_line('Indexes are being dropped...');	
END;
/
BEGIN
  FOR ind IN
    (SELECT index_name FROM user_indexes
       WHERE uniqueness = 'NONUNIQUE')
  LOOP
    EXECUTE IMMEDIATE 'DROP INDEX '||ind.index_name;
  END LOOP;
END;
/
BEGIN
  dbms_output.put_line('Indexes are dropped.');	
END;
/

-- Disable foreign key constraints
BEGIN
  dbms_output.put_line('Disabling foreign key constraints...');	
END;
/
EXECUTE citydb_constraint.set_enabled_schema_fkeys(FALSE, USER);
/
BEGIN
  dbms_output.put_line('Foreign key constraints disabled.');	
END;
/

-- Load the generic migration package
@@CITYDB_MIGRATE.sql;

-- Load the license specific migration package
BEGIN
  :MGRPBATCHFILE := '../../UTIL/HINTS/DO_NOTHING.sql';
END;
/
BEGIN
  IF :GEORASTER_SUPPORT <> 0 THEN
    :MGRPBATCHFILE := 'CITYDB_MIGRATE_GEORASTER';
  END IF;
END;
/

-- Transfer the value from the bind variable to the substitution variable
column mc new_value MGRPBATCHFILE2 print
select :MGRPBATCHFILE mc from dual;

@@&MGRPBATCHFILE2

BEGIN
  dbms_output.put_line('Packages installed.');	
END;
/

BEGIN
  dbms_output.put_line('Data are being transferred into the tables...');	
END;
/
EXECUTE CITYDB_MIGRATE.fillSurfaceGeometryTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillCityObjectTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillCityModelTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillAddressTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillBuildingTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillAddressToBuildingTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillAppearanceTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillSurfaceDataTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillTexImageTable('&TEXOP', upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillAppearToSurfaceDataTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillBreaklineReliefTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillRoomTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillBuildingFurnitureTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillBuildingInstallationTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillImplicitGeometryTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillCityFurnitureTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillCityObjectGenAttrTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillCityObjectMemberTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillCityObjectGroupTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillExternalReferenceTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillGeneralizationTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillGenericCityObjectTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillGroupToCityObject(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillLandUseTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillMassPointReliefTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillOpeningTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillThematicSurfaceTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillOpeningToThemSurfaceTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillPlantCoverTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillReliefComponentTable(upper('&V2USER'));
BEGIN
  IF :GEORASTER_SUPPORT <> 0 THEN
    EXECUTE IMMEDIATE 'CALL CITYDB_MIGRATE_GEORASTER.fillRasterReliefTable(:1)' USING upper('&V2USER');  
  END IF;
END;
/
EXECUTE CITYDB_MIGRATE.fillReliefFeatureTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillReliefFeatToRelCompTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillSolitaryVegetatObjectTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillTextureParamTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillTinReliefTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillTransportationComplex(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillTrafficAreaTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillWaterBodyTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillWaterBoundarySurfaceTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.fillWaterbodToWaterbndSrfTable(upper('&V2USER'));
COMMIT;
EXECUTE CITYDB_MIGRATE.updateSurfaceDataTable('&TEXOP', upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.updateSurfaceGeometryTable(upper('&V2USER'));
EXECUTE CITYDB_MIGRATE.updateCityObjectTable(upper('&V2USER'));

BEGIN
  -- Update SolidGeometry if oracle version greater than 10.x 
  IF ('10' < DBMS_DB_VERSION.VERSION) THEN
    EXECUTE IMMEDIATE 'CALL CITYDB_MIGRATE.updateSolidGeometry()';  
  END IF;
END;
/

BEGIN
  dbms_output.put_line('Data transfer is completed.');	
END;
/

BEGIN
  dbms_output.put_line('Sequences are being updated...');	
END;
/
EXECUTE CITYDB_MIGRATE.updateSequences(); 
BEGIN
  dbms_output.put_line('Sequence update is completed.');	
END;
/

-- Enable foreign key constraints
BEGIN
  dbms_output.put_line('Enabling foreign key constraints...');	
END;
/
EXECUTE citydb_constraint.set_enabled_schema_fkeys(TRUE, USER);
/
BEGIN
  dbms_output.put_line('Foreign key constraints enabled.');	
END;
/

BEGIN
  dbms_output.put_line('Indexes are being re-created...');	
END;
/
-- build indexes
column script new_value SIMPLE_INDEXES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN '../../SCHEMA/INDEXES/SIMPLE_INDEXES_GEORASTER.sql'
  ELSE '../../SCHEMA/INDEXES/SIMPLE_INDEXES.sql'
  END AS script
FROM dual;

@@&SIMPLE_INDEXES
@@../../SCHEMA/INDEXES/SPATIAL_INDEXES.sql

BEGIN
  dbms_output.put_line('Index re-creation is completed.');	
END;
/

BEGIN
  dbms_output.put_line('Migration related Packages, Procedures and Functions are being removed');
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP PACKAGE CITYDB_MIGRATE';
  IF :GEORASTER_SUPPORT <> 0 THEN
    EXECUTE IMMEDIATE 'DROP PACKAGE CITYDB_MIGRATE_GEORASTER';
  END IF;
END;
/
BEGIN
  dbms_output.put_line('Removal of migration related Packages, Procedures and Functions is completed');
END;
/

COMMIT;

BEGIN
  dbms_output.put_line('DB migration is completed.' || SYSTIMESTAMP);	
END;
/