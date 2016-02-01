== Migration steps from version 2.1 to version 3.1 ==

1. Create the database v3 with @CREATE_DB.sql 

    - Enter the SRID for the database 
    - Enter the SRSName to be used 
    - Specify if the versioning shall be enabled 
    - Specify the used oracle license (spatial / locator)

2. Run the script @GRANT_ACCESS.sql as v2.1 schema user 

    - Enter the schema name (v3) on which the accesses to be granted 

3. Execute @MIGRATE_DB.sql as your current (v3) user 

    - Enter the schema name from which the data will be migrated 
    - Specify the used oracle license (spatial / locator)
    
4. Execute @UPGRADE_DB_TO_3_1.sql as your current (v3) user 

Done! 

Example: 

Let's assume that version 2.1 DB has UTM32 Coordinate System which corresponds 
to SRID = 83032 and assume that the schema name which we will copy the data 
from is named as "3DCITYDB_TEST2" and your schema name is named as "3DCITYDB_TEST3". 

    - First, you create a new user and run @CREATE_DB.sql script for version 
      3.0.0 on this schema. You give the SRID as "83032" and the corresponding 
      SRSName (urn:ogc:def:crs,crs:EPSG:6.12:25832,crs:EPSG:6.12:5783) and 
      your choice about versioning and used oracle license (spatial / locator). 

    - After the database is created, you log on to v2.1 schema user to be able to 
      grant select accesses to this user for the schema which we will migrate 
      from and run @GRANT_ACCESS.sql script. 
      You give the value "3DCITYDB_TEST3" as parameter. 

    - When the script is finished, you log on with your username "3DCITYDB_TEST3" 
      again and run the script @MIGRATE_DB.sql and give the schema name which the 
      data will be copied as the parameter: "3DCITYDB_TEST2". 
      Second parameter is the used oracle license (spatial / locator).

    - When the migration script is completed, you see a message 
      "DB migration is completed successfully." on the console. 
      
    - As the final step, the script @UPGRADE_DB_TO_3_1.sql must be run 
      in order to bring the database to the version 3.1.
