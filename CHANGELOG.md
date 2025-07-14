# Changelog

## [Unreleased]

### Changed
- Added a `NOT NULL` constraint on the `datatype_id` column of the `property` table to require a data type for each
  property.
- Changed the geometry type of the column `val_implicitgeom_refpoint` in the `property` table from `GEOMETRYZ`
  to `POINTZ`.
- Replaced all `NUMERIC` columns used as boolean flags with `INTEGER` to reduce storage overhead.
- Updated the behavior of database functions that take a `schema_name` parameter. The schema is now consistently
  set by temporarily changing the `search_path` for the scope of the current transaction. If `schema_name` is
  omitted, the function operates on the current 3DCityDB schema in the `search_path`. [#260](https://github.com/3dcitydb/3dcitydb/pull/260)
- Removed database functions for setting and dropping foreign keys.

### Added
- Introduced the `relationType` attribute in the JSON schema mapping of feature properties. The attribute can take the
  values `relates` and `contains`, reflecting the value stored in the `val_relation_type` column of the
  `property` table.
- Added an `lod` attribute to the JSON schema mapping of the `ImplicitGeometryProperty` data type.
- Added an index on the `theme` column of the `appearance` table to improve query performance.
- Added new database functions `get_current_schema`, `set_current_schema`, and `schema_exists` to manage the
  active 3DCityDB schema.
- Added a new `db_properties` function that lists database properties relevant for the 3DCityDB as name-value pairs.
- Added shell and SQL scripts to upgrade an existing 3DCityDB instance to the latest minor or patch version.

### Fixed
- Fixed issues that prevented the `get_feature_envelope` function from working correctly. [#258](https://github.com/3dcitydb/3dcitydb/issues/258)
- Fixed delete scripts to correctly remove parent attributes of feature properties that share the same attribute name
  when the referenced features are deleted. This primarily affects the attributes `grp:groupMember` and
  `core:relatedTo`. [#261](https://github.com/3dcitydb/3dcitydb/pull/261)
- Fixed issues in the Docker scripts, such as removing the `postgis_raster` extension and using the correct 3DCityDB
  version number.

## [5.0.0] - 2025-03-17

This is the initial release of the 3D City Database v5, a major revision of the previous v4 release, featuring a
completely redesigned, significantly simplified, and streamlined database schema. This release is not backward
compatible, and legacy 3DCityDB v4 tools cannot be used with it. Refer to
the [user manual](https://3dcitydb.github.io/3dcitydb-mkdocs/) for complete documentation.

## [Before 5.0.0]
The changelog of previous 3D City Database releases before version 5.0 is available
[here](https://github.com/3dcitydb/3dcitydb/tree/3dcitydb-v4/CHANGES.md).

[Unreleased]: https://github.com/3dcitydb/3dcitydb/compare/v5.0.0..HEAD
[5.0.0]: https://github.com/3dcitydb/3dcitydb/releases/tag/v5.0.0
[Before 5.0.0]: https://github.com/3dcitydb/3dcitydb/tree/3dcitydb-v4/CHANGES.md