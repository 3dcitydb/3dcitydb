BEGIN
	dbms_output.put_line('Installing the functions for migration...');	
END;
/
@@FUNCTIONS/CONVERTPOLYGONTOSDOFORM.sql;
@@FUNCTIONS/CONVERTVARCHARTOSDOGEOM.sql;
BEGIN
	dbms_output.put_line('Functions installed.');	
END;
/
BEGIN
	dbms_output.put_line('Installing the packages for migration...');	
END;
/
@@PACKAGES/GEODB_MIGRATE_V2_V3.sql;
BEGIN
	dbms_output.put_line('Packages installed.');	
END;
/

BEGIN
	dbms_output.put_line('Installing the procedures for migration...');	
END;
/
@@PROCEDURES/UPDATESEQUENCES.sql;
BEGIN
	dbms_output.put_line('Procedures installed.');	
END;
/

BEGIN
	dbms_output.put_line('Data are being transferred into the tables...');	
END;
/
@@FILL_TABLES.sql
BEGIN
	dbms_output.put_line('Data transfer is completed.');	
END;
/

BEGIN
	dbms_output.put_line('Sequences are being updated...');	
END;
/
@@UPDATE_SEQUENCES.sql
BEGIN
	dbms_output.put_line('Sequence update is completed.');	
END;
/

COMMIT;

BEGIN
	dbms_output.put_line('DB migration is completed.');	
END;
/