-- MIGRATE_DB_V2_V3.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>             
--
-- Copyright:  (c) 2014, M.O.S.S. Computer Grafik Systeme GmbH
--						 Hohenbrunner Weg 13, D-82024 Taufkirchen
--						 Germany
-- 
--              This script is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
-- Migration script from Oracle 3DCityDB version 2.1 to version 3.0
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2014-10-14   release version                             AM
-- 

SET SERVEROUTPUT ON verify off;
SET FEEDBACK OFF;
ACCEPT SCHEMAINPUT PROMPT 'Enter the user name of 3DCityDB v2.1.0 instance : '

BEGIN
	dbms_output.put_line('Starting DB migration...');
	dbms_output.put_line('Creating Synonyms...');
END;
/

DECLARE
	schema_name VARCHAR2(30) := upper('&SCHEMAINPUT');
BEGIN
	dbms_output.put_line('Starting DB migration...');
	dbms_output.put_line('Creating Synonyms...');

	FOR R IN (SELECT owner, table_name FROM all_tables WHERE owner=schema_name) LOOP
		EXECUTE IMMEDIATE 'CREATE SYNONYM '||R.table_name||'_v2 FOR "'||schema_name||'".'||R.table_name;
		-- dbms_output.put_line('CREATE SYNONYM '||R.table_name||'_v2 FOR "'||schema_name||'".'||R.table_name);
	END LOOP;

	dbms_output.put_line('Synonyms created.');
END;
/

BEGIN
	dbms_output.put_line('Installing the package with functions and procedures for migration...');	
END;
/
@@PACKAGES/CITYDB_MIGRATE_V2_V3.sql;
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
EXECUTE CITYDB_MIGRATE_V2_V3.fillSurfaceDataTable;
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
EXECUTE CITYDB_MIGRATE_V2_V3.fillRasterReliefTable();
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
EXECUTE CITYDB_MIGRATE_V2_V3.updateSolidGeometry();

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
	dbms_output.put_line('Migration related Packages, Procedures and Functions are being removed');
END;
/
BEGIN
	EXECUTE IMMEDIATE 'DROP PACKAGE CITYDB_MIGRATE_V2_V3';
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
	dbms_output.put_line('DB migration is completed.');	
END;
/