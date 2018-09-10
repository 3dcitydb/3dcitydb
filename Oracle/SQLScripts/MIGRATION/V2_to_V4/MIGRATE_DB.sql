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

DECLARE
  schema_name VARCHAR2(30) := upper('&V2USER');
BEGIN
  dbms_output.put_line('Creating Synonyms...');

  FOR R IN (SELECT owner, table_name FROM all_tables WHERE owner=schema_name) LOOP
    EXECUTE IMMEDIATE 'CREATE SYNONYM '||R.table_name||'_v2 FOR "'||schema_name||'".'||R.table_name;
	--dbms_output.put_line('CREATE SYNONYM '||R.table_name||'_v2 FOR "'||schema_name||'".'||R.table_name);
  END LOOP;

  dbms_output.put_line('Synonyms created.');
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
@@DROP_INDEXES_V4.sql;
BEGIN
  dbms_output.put_line('Indexes are dropped.');	
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
EXECUTE CITYDB_MIGRATE.fillSurfaceGeometryTable();
EXECUTE CITYDB_MIGRATE.fillCityObjectTable();
EXECUTE CITYDB_MIGRATE.fillCityModelTable();
EXECUTE CITYDB_MIGRATE.fillAddressTable();
EXECUTE CITYDB_MIGRATE.fillBuildingTable();
EXECUTE CITYDB_MIGRATE.fillAddressToBuildingTable();
EXECUTE CITYDB_MIGRATE.fillAppearanceTable();
EXECUTE CITYDB_MIGRATE.fillSurfaceDataTable('&TEXOP');
EXECUTE CITYDB_MIGRATE.fillAppearToSurfaceDataTable();
EXECUTE CITYDB_MIGRATE.fillBreaklineReliefTable();
EXECUTE CITYDB_MIGRATE.fillRoomTable();
EXECUTE CITYDB_MIGRATE.fillBuildingFurnitureTable();
EXECUTE CITYDB_MIGRATE.fillBuildingInstallationTable();
EXECUTE CITYDB_MIGRATE.fillImplicitGeometryTable();
EXECUTE CITYDB_MIGRATE.fillCityFurnitureTable();
EXECUTE CITYDB_MIGRATE.fillCityObjectGenAttrTable();
EXECUTE CITYDB_MIGRATE.fillCityObjectMemberTable();
EXECUTE CITYDB_MIGRATE.fillCityObjectGroupTable();
EXECUTE CITYDB_MIGRATE.fillExternalReferenceTable();
EXECUTE CITYDB_MIGRATE.fillGeneralizationTable();
EXECUTE CITYDB_MIGRATE.fillGenericCityObjectTable();
EXECUTE CITYDB_MIGRATE.fillGroupToCityObject();
EXECUTE CITYDB_MIGRATE.fillLandUseTable();
EXECUTE CITYDB_MIGRATE.fillMassPointReliefTable();
EXECUTE CITYDB_MIGRATE.fillOpeningTable();
EXECUTE CITYDB_MIGRATE.fillThematicSurfaceTable();
EXECUTE CITYDB_MIGRATE.fillOpeningToThemSurfaceTable();
EXECUTE CITYDB_MIGRATE.fillPlantCoverTable();
EXECUTE CITYDB_MIGRATE.fillReliefComponentTable();
BEGIN
  IF :GEORASTER_SUPPORT <> 0 THEN
    EXECUTE IMMEDIATE 'CALL CITYDB_MIGRATE_GEORASTER.fillRasterReliefTable()';  
  END IF;
END;
/
EXECUTE CITYDB_MIGRATE.fillReliefFeatureTable();
EXECUTE CITYDB_MIGRATE.fillReliefFeatToRelCompTable();
EXECUTE CITYDB_MIGRATE.fillSolitaryVegetatObjectTable();
EXECUTE CITYDB_MIGRATE.fillTextureParamTable();
EXECUTE CITYDB_MIGRATE.fillTinReliefTable();
EXECUTE CITYDB_MIGRATE.fillTransportationComplex();
EXECUTE CITYDB_MIGRATE.fillTrafficAreaTable();
EXECUTE CITYDB_MIGRATE.fillWaterBodyTable();
EXECUTE CITYDB_MIGRATE.fillWaterBoundarySurfaceTable();
EXECUTE CITYDB_MIGRATE.fillWaterbodToWaterbndSrfTable();
EXECUTE CITYDB_MIGRATE.updateSurfaceGeoTableCityObj();

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
  FOR R IN (SELECT synonym_name FROM user_synonyms) LOOP
    EXECUTE IMMEDIATE 'DROP SYNONYM '||R.synonym_name;
    -- dbms_output.put_line('drop synonym '||R.synonym_name);
  END LOOP;
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