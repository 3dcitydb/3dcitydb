Change Log
==========

### 4.0 - tba

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
* Improved performance on stored procedures by reducing amount of dynamic SQL. 
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
