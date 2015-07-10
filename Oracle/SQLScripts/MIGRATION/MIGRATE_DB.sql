-- MIGRATE_DB.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>
--             Felix Kunde <fkunde@virtualcitysystems.de>
--             Gyoergy Hudra <ghudra@moss.de>
--
-- Copyright:  (c) 2012-2015  Chair of Geoinformatics,
--                            Technische Universität München, Germany
--                            http://www.gis.bv.tum.de
--
--              This script is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Top-level migration script that starts the migration process for a 3DCityDB 
-- instance of v2.1.0 to v3.0.0
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2015-01-22   release version                             AM
--                                                                    FKun
--           2015-03-11   locator/spatial, check version > 10.x       GHud
-- 

SET SERVEROUTPUT ON verify off;
SET FEEDBACK OFF;

BEGIN 
	dbms_output.put_line('Oracle-Version: '||DBMS_DB_VERSION.VERSION||'.'||DBMS_DB_VERSION.RELEASE);
END;
/

ACCEPT SCHEMAINPUT PROMPT 'Enter the user name of 3DCityDB v2.1.0 instance : '
ACCEPT DBVERSION CHAR DEFAULT 'S' PROMPT 'Which DB license are you using in the v3.0.0 instance? (Spatial(S)/Locator(L), default is S): '
ACCEPT TEXOP CHAR DEFAULT 'n' PROMPT 'No texture URI is used for multiple texture files (yes(y)/unknown(n), default is n): '

VARIABLE MGRPBATCHFILE VARCHAR2(50);

BEGIN
	dbms_output.put_line('Starting DB migration...');
	dbms_output.put_line('Creating Synonyms...');
END;
/

DECLARE
	schema_name VARCHAR2(30) := upper('&SCHEMAINPUT');
BEGIN
	dbms_output.put_line('Starting DB migration... ' || SYSTIMESTAMP);
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

-- Load the generic migration package
@@MIGRATE_DB_V2_V3.sql;

-- Load the license specific migration package
BEGIN
  :MGRPBATCHFILE := '../UTIL/CREATE_DB/DO_NOTHING.sql';
END;
/
BEGIN
  IF ('&DBVERSION'='S' or '&DBVERSION'='s') THEN
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