-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
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

SET SERVEROUTPUT ON verify off;
SET FEEDBACK OFF;

BEGIN 
	dbms_output.put_line('Oracle-Version: '||DBMS_DB_VERSION.VERSION||'.'||DBMS_DB_VERSION.RELEASE);
END;
/

ACCEPT SCHEMAINPUT PROMPT 'Enter the user name of 3DCityDB v2.1 instance : '
ACCEPT DBVERSION CHAR DEFAULT 'S' PROMPT 'Which DB license are you using in the v3.3 instance? (Spatial(S)/Locator(L), default is S): '
ACCEPT TEXOP CHAR DEFAULT 'n' PROMPT 'No texture URI is used for multiple texture files (yes(y)/unknown(n), default is n): '

VARIABLE MGRPBATCHFILE VARCHAR2(50);
VARIABLE GEORASTER_SUPPORT NUMBER;

BEGIN
	dbms_output.put_line('Starting DB migration... ' || SYSTIMESTAMP);
END;
/

DECLARE
	schema_name VARCHAR2(30) := upper('&SCHEMAINPUT');
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

-- Check for SDO_GEORASTER support
BEGIN
  :GEORASTER_SUPPORT := 0;
  IF (upper('&DBVERSION')='S') THEN
    SELECT COUNT(*) INTO :GEORASTER_SUPPORT FROM ALL_SYNONYMS
	WHERE SYNONYM_NAME='SDO_GEORASTER';
  END IF;
END;
/

-- Drop the existing indexes (non-spatial indexes)
BEGIN
	dbms_output.put_line('Indexes are being dropped...');	
END;
/
@@DROP_INDEXES_V3.sql
BEGIN
	dbms_output.put_line('Indexes are dropped.');	
END;
/

-- Load the generic migration package
@@MIGRATE_DB_V2_V3.sql;

-- Load the license specific migration package
BEGIN
  :MGRPBATCHFILE := '../UTIL/CREATE_DB/DO_NOTHING.sql';
END;
/
BEGIN
  IF (upper('&DBVERSION')='S' and :GEORASTER_SUPPORT <> 0) THEN
    :MGRPBATCHFILE := 'MIGRATE_DB_V2_V3_Sptl';
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
EXECUTE CITYDB_MIGRATE_V2_V3.fillSurfaceGeometryTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillCityObjectTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillCityModelTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillAddressTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillBuildingTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillAddressToBuildingTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillAppearanceTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillSurfaceDataTable('&TEXOP');
EXECUTE CITYDB_MIGRATE_V2_V3.fillAppearToSurfaceDataTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillBreaklineReliefTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillRoomTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillBuildingFurnitureTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillBuildingInstallationTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillImplicitGeometryTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillCityFurnitureTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillCityObjectGenAttrTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillCityObjectMemberTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillCityObjectGroupTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillExternalReferenceTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillGeneralizationTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillGenericCityObjectTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillGroupToCityObject();
EXECUTE CITYDB_MIGRATE_V2_V3.fillLandUseTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillMassPointReliefTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillOpeningTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillThematicSurfaceTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillOpeningToThemSurfaceTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillPlantCoverTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillReliefComponentTable();
BEGIN
  IF (upper('&DBVERSION')='S') THEN
    EXECUTE IMMEDIATE 'CALL CITYDB_MIGRATE_V2_V3_SPTL.fillRasterReliefTable()';  
  END IF;
END;
/
EXECUTE CITYDB_MIGRATE_V2_V3.fillReliefFeatureTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillReliefFeatToRelCompTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillSolitaryVegetatObjectTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillTextureParamTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillTinReliefTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillTransportationComplex();
EXECUTE CITYDB_MIGRATE_V2_V3.fillTrafficAreaTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillWaterBodyTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillWaterBoundarySurfaceTable();
EXECUTE CITYDB_MIGRATE_V2_V3.fillWaterbodToWaterbndSrfTable();
EXECUTE CITYDB_MIGRATE_V2_V3.updateSurfaceGeoTableCityObj();

BEGIN
  -- Update SolidGeometry if oracle version greater than 10.x 
  IF ('10' < DBMS_DB_VERSION.VERSION) THEN
    EXECUTE IMMEDIATE 'CALL CITYDB_MIGRATE_V2_V3.updateSolidGeometry()';  
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
EXECUTE CITYDB_MIGRATE_V2_V3.updateSequences(); 
BEGIN
	dbms_output.put_line('Sequence update is completed.');	
END;
/

BEGIN
	dbms_output.put_line('Indexes are being re-created...');	
END;
/
-- Create the non-spatial indexes again
@@CREATE_INDEXES_V3.sql
BEGIN
	dbms_output.put_line('Index re-creation is completed.');	
END;
/

BEGIN
	dbms_output.put_line('Constraints are being created...');	
END;
/
-- Create the non-spatial indexes again
@@CONSTRAINTS_V3.sql
BEGIN
	dbms_output.put_line('Constraints are created.');	
END;
/


BEGIN
	dbms_output.put_line('Migration related Packages, Procedures and Functions are being removed');
END;
/
BEGIN
	EXECUTE IMMEDIATE 'DROP PACKAGE CITYDB_MIGRATE_V2_V3';
  IF ('&DBVERSION'='S' or '&DBVERSION'='s') THEN
  	EXECUTE IMMEDIATE 'DROP PACKAGE CITYDB_MIGRATE_V2_V3_Sptl';
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