DELETE FROM namespace;

-- Core Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1, 'core', 'http://3dcitydb.org/3dcitydb/core/5.0');

-- Dynamizer Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (2, 'dyn', 'http://3dcitydb.org/3dcitydb/dynamizer/5.0');

-- Generics Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (3, 'gen', 'http://3dcitydb.org/3dcitydb/generics/5.0');

-- LandUse Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (4, 'luse', 'http://3dcitydb.org/3dcitydb/landuse/5.0');

-- PointCloud Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (5, 'pcl', 'http://3dcitydb.org/3dcitydb/pointcloud/5.0');

-- Relief Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (6, 'dem', 'http://3dcitydb.org/3dcitydb/relief/5.0');

-- Transportation Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (7, 'tran', 'http://3dcitydb.org/3dcitydb/transportation/5.0');

-- Construction Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (8, 'con', 'http://3dcitydb.org/3dcitydb/construction/5.0');

-- Tunnel Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (9, 'tun', 'http://3dcitydb.org/3dcitydb/tunnel/5.0');

-- Building Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (10, 'bldg', 'http://3dcitydb.org/3dcitydb/building/5.0');

-- Bridge Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (11, 'brid', 'http://3dcitydb.org/3dcitydb/bridge/5.0');

-- Appearance Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (12, 'app', 'http://3dcitydb.org/3dcitydb/appearance/5.0');

-- CityObjectGroup Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (13, 'grp', 'http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0');

-- Vegetation Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (14, 'veg', 'http://3dcitydb.org/3dcitydb/vegetation/5.0');

-- Versioning Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (15, 'vers', 'http://3dcitydb.org/3dcitydb/versioning/5.0');

-- WaterBody Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (16, 'wtr', 'http://3dcitydb.org/3dcitydb/waterbody/5.0');

-- CityFurniture Module --
INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (17, 'frn', 'http://3dcitydb.org/3dcitydb/cityfurniture/5.0');

-- Deprecated Module --
INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (18, 'depr', 'http://3dcitydb.org/3dcitydb/deprecated/5.0');
