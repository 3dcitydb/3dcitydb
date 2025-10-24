DELETE FROM namespace;

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES
  (1, 'core', 'http://3dcitydb.org/3dcitydb/core/5.0'),
  (2, 'dyn', 'http://3dcitydb.org/3dcitydb/dynamizer/5.0'),
  (3, 'gen', 'http://3dcitydb.org/3dcitydb/generics/5.0'),
  (4, 'luse', 'http://3dcitydb.org/3dcitydb/landuse/5.0'),
  (5, 'pcl', 'http://3dcitydb.org/3dcitydb/pointcloud/5.0'),
  (6, 'dem', 'http://3dcitydb.org/3dcitydb/relief/5.0'),
  (7, 'tran', 'http://3dcitydb.org/3dcitydb/transportation/5.0'),
  (8, 'con', 'http://3dcitydb.org/3dcitydb/construction/5.0'),
  (9, 'tun', 'http://3dcitydb.org/3dcitydb/tunnel/5.0'),
  (10, 'bldg', 'http://3dcitydb.org/3dcitydb/building/5.0'),
  (11, 'brid', 'http://3dcitydb.org/3dcitydb/bridge/5.0'),
  (12, 'app', 'http://3dcitydb.org/3dcitydb/appearance/5.0'),
  (13, 'grp', 'http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0'),
  (14, 'veg', 'http://3dcitydb.org/3dcitydb/vegetation/5.0'),
  (15, 'vers', 'http://3dcitydb.org/3dcitydb/versioning/5.0'),
  (16, 'wtr', 'http://3dcitydb.org/3dcitydb/waterbody/5.0'),
  (17, 'frn', 'http://3dcitydb.org/3dcitydb/cityfurniture/5.0'),
  (18, 'depr', 'http://3dcitydb.org/3dcitydb/deprecated/5.0');

COMMIT;