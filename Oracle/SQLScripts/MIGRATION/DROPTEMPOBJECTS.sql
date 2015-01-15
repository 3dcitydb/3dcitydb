BEGIN
	dbms_output.put_line('Migration related Packages, Procedures and Functions are being removed');
	EXECUTE IMMEDIATE 'DROP PACKAGE GEODB_MIGRATE_V2_V3';
	EXECUTE IMMEDIATE 'DROP PROCEDURE updateSequences';
	EXECUTE IMMEDIATE 'DROP FUNCTION convertVarcharToSDOGeom';
	EXECUTE IMMEDIATE 'DROP FUNCTION convertPolygonToSdoForm';
	dbms_output.put_line('Removal of migration related Packages, Procedures and Functions is completed');
END;
/