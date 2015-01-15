== Migration steps from version 2.1 to version 3.0 ==

1. Create the database v3 with @CREATE_DB.sql 

    - Enter the SRID for the database 
    - Enter the SRSName to be used 
    - Specify if the versioning shall be enabled 

2. Run the script @GRANT_ACCESS.sql as the DBA user 

    - Enter the username for the accesses to be granted 
    - Enter the schema name on which the accesses to be granted 

3. Execute @MIGRATE_DB.sql as your current user 

    - Enter the schema name from which the data will be copied 

Done! 

Example: 

Let's assume that version 2.1 DB has UTM32 Coordinate System which corresponds to SRID = 83032 and assume that the schema name which we will copy the data from is named as "3DCITYDB_TEST2" and your schema name is named as "3DCITYDB_TEST3". 

    - First, you create a new user and run @CREATE_DB.sql script for version 3.0.0 on this schema. You give the SRID as "83032" and the corresponding SRSName and your choice about versioning. 

    - After the database is created, you log on as a DBA User to be able to grant select accesses to this user for the schema which we will migrate from and run @GRANT_ACCESS.sql script. You give the values "3DCITYDB_TEST3" and "3DCITYDB_TEST2" as parameters. 

    - When the script is finished, you log on with your username "3DCITYDB_TEST3" again and run the script @MIGRATE_DB.sql and give the schema name which the data will be copied as the parameter: "3DCITYDB_TEST2". 

    - When the migration script is completed, you see a message "DB migration is completed successfully." on the console. 

 