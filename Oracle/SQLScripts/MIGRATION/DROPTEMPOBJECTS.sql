BEGIN
	dbms_output.put_line('Migration related Packages, Procedures and Functions are being removed');
	EXECUTE IMMEDIATE 'DROP PACKAGE GEODB_MIGRATE_V2_V3';
	EXECUTE IMMEDIATE 'DROP PROCEDURE updateSequences';
	EXECUTE IMMEDIATE 'DROP FUNCTION convertVarcharToSDOGeom';
	EXECUTE IMMEDIATE 'DROP FUNCTION convertPolygonToSdoForm';
	FOR R IN (SELECT owner, synonym_name FROM all_synonyms WHERE owner=USER) LOOP
		EXECUTE IMMEDIATE 'DROP SYNONYM '||R.synonym_name;
		-- dbms_output.put_line('drop synonym '||R.synonym_name);
	END LOOP;
	dbms_output.put_line('Removal of migration related Packages, Procedures and Functions is completed');
END;
/