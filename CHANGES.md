Change Log
==========

### 4.3.0 - tba

##### Changes
* Added two new columns `GMLID` and `GMLID_CODESPACE` to the `IMPLICIT_GEOMETRY` table.

### 4.2.0 - 2021-10-08

##### Changes
* PostgreSQL: Changed all primary key columns to use 64-bit `bigint` as data type instead of 32-bit `integer`.
  This change increases the maximum value of primary keys and, thus, the number of city objects and
  surface geometries that can be stored in the database. Foreign key columns as well as affected database
  functions have been updated correspondingly. [#66](https://github.com/3dcitydb/3dcitydb/pull/66)
  * The upgrade and migration scripts take care to correctly update existing 3DCityDB instances. This also
    includes ADE schemas that have been registered with a 3DCityDB instance.
  * This change *does not affect* 3DCityDB instances running on Oracle.

##### Fixes
* PostgreSQL: Fixed `change_schema_srid` function to avoid inconsistencies in the database schema when the new SRID
  matches the old one. [#67](https://github.com/3dcitydb/3dcitydb/issues/67), [#68](https://github.com/3dcitydb/3dcitydb/pull/68)
* PostgreSQL: Fixed `get_index` function.
* Oracle: Fixed `DROP_DB` script to also remove spatial metadata.
* Fixed upgrade scripts for PostgreSQL and Oracle. [#61](https://github.com/3dcitydb/3dcitydb/pull/61)

### 4.1.0 - 2021-04-28

##### Additions
* Added support for running the 3D City Database in a Docker container. This work is based on the previous 
  developments from TUM GIS at https://github.com/tum-gis/3dcitydb-docker-postgis, which have been moved to the 3DCityDB
  GitHub repository. Kudos to TUM GIS for this great contribution. [#54](https://github.com/3dcitydb/3dcitydb/pull/54)
* The `IS_XLINK` column of the `SURFACE_GEOMETRY` table can now take the values 0, 1, and 2 to be able to 
  distinguish between geometry references across top-level features (`IS_XLINK` = 1) and references within the same
  top-level feature (`IS_XLINK` = 2). This information helps to substantially increase the performance of CityGML
  exports in case mainly local references are used (which is true for most real-world CityGML datasets). The
  Importer/Exporter version 4.3.0 fully supports this change. [importer-exporter #159](https://github.com/3dcitydb/importer-exporter/pull/159)

##### Fixes
* PostgreSQL: Fixed a bug in `GRANT_ACCESS.sql`, which may cause the CityGML export to fail due to insufficient privileges
  when using a read-only user. [importer-exporter #167](https://github.com/3dcitydb/importer-exporter/issues/167)
* Oracle: Fixed a bug in `GRANT_ACCESS.sql`, where database views are not taken into account while granting users access.
* Oracle: Fixed an issue, where the names of versioned tables are not correctly printed in database reports.

### 4.0.3 - 2020-04-06

##### Fixes
* PostgreSQL: fixed a bug in the SQL script `GRANT_ACCESS.sql` which fails when the database, user, or schema name contains an uppercase letter.
* PostgreSQL: fixed a bug in the SQL script `REVOKE_ACCESS.sql` which fails when the GRANTEE name contains an uppercase letter.
* Fixed a bug in the shell (UNIX, macOS) script `MIGRATE_DB.sh` which fails when migrating a 3DCityDB instance from v2 to v4. 
* PostgreSQL: Fixed a bug in the SQL script `CONSTRAINT.sql`which causes an error when running the upgrade script on multiple 3DCityDB schemas. [#41](https://github.com/3dcitydb/3dcitydb/pull/41)
* PostgreSQL: Added existence check of the `postgis_raster` extension which is required by the 3DCityDB when using PostGIS 3 or higher.

##### Additions
* Added indexes on the columns `CREATION_DATE`, `TERMINATION_DATE` and `LAST_MODIFICATION_DATE` in the CITYOBJECT table.

##### Miscellaneous 
* Removed the `Documentation` folder. Instead, the 3DCityDB documentation is now maintained in a separate Github repository [here](https://github.com/3dcitydb/3dcitydb-docs).
* Renamed the `Oracle` and `PostgreSQL` folders to lowercase. 
* Automated creation of release packages using Gradle as build system.

### 4.0.2 - 2019-08-06

##### Fixes
* Oracle: Fixed `sdo2geojson3d` function to correctly format coordinate values. 
* PostgreSQL: Fixed a bug in the `V3_to_V4` migration script where the `citydb` prefix should not be used.

##### Additions
* Added upgrade scripts for upgrading or migrating to the latest 3dcitydb version.

### 4.0.1 - 2019-01-09

##### Fixes
* Fixed a bug in the `V3_to_V4` migration script when updating a 3DCityDB v3.0.0 instance to v4.0. The previous version of the migration script missed to add the `GMLID_CODESPACE` column to some feature tables. _Note:_ There is no need to take any action if you have set up the 3DCityDB v4.0 using the `CREATE_DB` scripts or if you have updated from v3.1.0 or higher.

### 4.0 - 2018-09-18

##### Breaking Changes
* New packages `CITYDB_CONSTRAINT` and `CITYDB_OBJCLASS`.
* Removed user prompts from SQL scripts for setting up or dropping 3DCityDB instances to better support automation workflows.
* `DELETE` and `ENVELOPE` are now generated automatically in order to deal with schema changes introduced by ADEs. The function prefix has been shortened to `del_` and `env_` to avoid exceeding the character limit under Oracle.
  - Aligned `DELETE` API under Oracle and PostgreSQL (no more `_pre` and `_post` methods).
  - Two delete endpoints are provided for each feature class: Delete by single ID value or delete by a set of IDs.
  - All 1:n references are deleted right away. Replaced all explicit cleanup scripts (except for `cleanup_appearances`) with one generic cleanup function.
* Added `OBJECTCLASS_ID` column to all feature tables to distinguish CityGML core features from features defined in a CityGML ADE. 
* Added `NOT NULL` constraints on each OBJECTCLASS_ID column.
* Augmented `OBJECTCLASS` table with more feature-specific columns and added new entries for missing core features.
* Improved performance of stored procedures by reducing amount of dynamic SQL. 
  - `schema_name` parameter has been removed from `DELETE` and `ENVELOPE` scripts.
  - Under PostgreSQL these scripts (as well as the `INDEX_TABLE`) are now part of a data schema (e.g. `citydb`).
* Removed the `CITYDB_DELETE_BY_LINEAGE` package. The only function left is `del_cityobjects_by_lineage` which is now part of the `DELETE` package.
* Changed delete rule of one foreign key in link tables to `ON DELETE CASCADE` to produce better delete scripts.
* Moved `update_schema_constraints` and `update_table_constraint` procedures into new `CITYDB_CONSTRAINT` package and renamed them to `set_schema_fkey_delete_rule` and `set_fkey_delete_rule`.
  - Changed data type for `on_delete_param` to `CHAR` as only one letter is needed to set a new delete rule: 'a' for `ON DELETE NO ACTION`, 'n' for `ON DELETE SET NULL`, 'c' for `ON DELETE CASCADE` or (PostgreSQL-only) 'r' for `ON DELETE RESTRICT`.
* Moved `objectclass_id_to_table_name` function to new `CITYDB_OBJCLASS` package.
* Removed `schema_name` parameter from `get_seq_values` function
* Oracle: Removed `schema_name` parameter from `construct_solid` function.
* Rearranged folder and script structure:
  - Removed folders `PL_SQL` (Oracle) and `PL_pgSQL` (PostgreSQL) to make `CITYDB_PKG` a top-level directory under the `SQLScripts` folder.
  - Moved `OBJECTCLASS_INSTANCES` script to `SCHEMA/OBJECTCLASS` folder.
  - PostgreSQL: New `SCHEMAS` directory in `UTIL` folder.
  - Oracle: One instead of two `CREATE_DB` scripts.
  - Oracle: Moved versioning scripts to their own directory in the `UTIL` folder.
  - Oracle: Renamed `CREATE_DB` folder in `UTIL` directory to `HINTS`.

##### Additions
* New metadata tables `ADE`, `SCHEMA`, `SCHEMA_REFERENCING` and `SCHEMA_TO_OBJECTCLASS` for registering CityGML ADEs.
* New prefilled metadata table `AGGREGATION_INFO` that supports the automatic generation of `DELETE` and `ENVELOPE` scripts.
* Added batch (Windows) and shell (UNIX, macOS) scripts for interactively setting up or dropping a 3DCityDB instance of both PostgreSQL and Oracle. The new shell scripts provide improved user dialogs. 
* Function `objectclass_id_to_table_name` now has a counterpart: `table_name_to_objectclass_ids` returning an array of objectclass ids (`CITYDB_OBJCLASS` package in Oracle, part of a data schema in PostgreSQL).
* New database procedures to enable/disable foreign key constraints to speed up bulk write operations (`CITYDB_CONSTRAINT` package in Oracle, part of the `citydb_pkg` schema in PostgreSQL).
* New SQL script to create additional 3DCityDB data schemas in one database (PostgreSQL).
* New shell and SQL scripts to grant read-only or full read-write access to another schema.
* Added database migration scripts for version 2.1 and version 3.3 to version 4.0.
* Added `schema_name` parameter to functions `db_metadata` and `db_info`.
* Added `schema_name` parameter to `is_db_ref_sys_3d` function.
* PostgreSQL: Added volatility categories for better query planning.
* Oracle: Better handling of missing `SDO_GEORASTER` support in SQL scripts.
* Oracle: Defining spatial metadata on all geometry columns with new function `set_schema_sdo_metadata` in `CITYDB_CONSTRAINT` package instead of a hard-coded part in `SPATIAL_INDEX.sql` script.
* Oracle: Added `schema_name` parameter to `get_index` function
* Oracle: Dropping spatial indexes will not delete spatial metadata anymore.
* Oracle: Do not delete spatial metadata when spatial index is not valid.
* Oracle: Added schema_name parameter to `get_dim` function.

##### Fixes
* Fixed envelope calculation for ReliefFeature. [#36](https://github.com/3dcitydb/3dcitydb/issues/36)
* Fixed `CREATE_DB` error due to disabled GeoRaster support under Oracle Spatial 12.1.0.2. [#10](https://github.com/3dcitydb/3dcitydb/issues/10)

##### Miscellaneous 
* [3DCityDB Docker images](https://github.com/tum-gis/3dcitydb-docker-postgis) are now available for a range of 3DCityDB versions to support continuous integration workflows.
