DELETE FROM objectclass;

-- Core Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1, null, 'Undefined', 1, 0, 1, '{"identifier":"core:Undefined","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (2, null, 'AbstractObject', 1, 0, 1, '{"identifier":"core:AbstractObject","table":"feature","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"objectid","type":"string"}},{"name":"identifier","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier_codespace","type":"string"},"parent":1},{"name":"envelope","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"envelope","type":"geometry"}},{"name":"objectClassId","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"objectclass_id","type":"integer"}},{"name":"lastModificationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"last_modification_date","type":"timestamp"}},{"name":"updatingPerson","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"updating_person","type":"string"}},{"name":"reasonForUpdate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"reason_for_update","type":"string"}},{"name":"lineage","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"lineage","type":"string"}},{"name":"description","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:StringOrRef"},{"name":"descriptionReference","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Reference"},{"name":"name","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (3, 2, 'AbstractFeature', 1, 0, 1, '{"identifier":"core:AbstractFeature","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (4, null, 'Address', 0, 0, 1, '{"identifier":"core:Address","table":"address","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"objectid","type":"string"}},{"name":"identifier","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier_codespace","type":"string"},"parent":1},{"name":"street","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"street","type":"string"}},{"name":"houseNumber","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"house_number","type":"string"}},{"name":"poBox","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"po_box","type":"string"}},{"name":"zipCode","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"zip_code","type":"string"}},{"name":"city","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"city","type":"string"}},{"name":"state","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"state","type":"string"}},{"name":"country","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"country","type":"string"}},{"name":"multiPoint","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"multi_point","type":"geometry"}}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (5, 3, 'AbstractPointCloud', 1, 0, 1, '{"identifier":"core:AbstractPointCloud","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (6, 3, 'AbstractFeatureWithLifespan', 1, 0, 1, '{"identifier":"core:AbstractFeatureWithLifespan","table":"feature","properties":[{"name":"creationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"creation_date","type":"timestamp"}},{"name":"terminationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"termination_date","type":"timestamp"}},{"name":"validFrom","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"valid_from","type":"timestamp"}},{"name":"validTo","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"valid_to","type":"timestamp"}}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (7, 6, 'AbstractCityObject', 1, 0, 1, '{"identifier":"core:AbstractCityObject","table":"feature","properties":[{"name":"externalReference","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:ExternalReference"},{"name":"generalizesTo","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"relativeToTerrain","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:String"},{"name":"relativeToWater","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:String"},{"name":"relatedTo","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"appearance","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:AppearanceProperty"},{"name":"dynamizer","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (8, 7, 'AbstractSpace', 1, 0, 1, '{"identifier":"core:AbstractSpace","table":"feature","properties":[{"name":"spaceType","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:String"},{"name":"volume","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:QualifiedVolume"},{"name":"area","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:QualifiedArea"},{"name":"boundary","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"lod0Point","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod0MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod0MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod1Solid","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod2Solid","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod2MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod2MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod3Solid","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod3MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod3MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (9, 8, 'AbstractLogicalSpace', 1, 0, 1, '{"identifier":"core:AbstractLogicalSpace","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (10, 8, 'AbstractPhysicalSpace', 1, 0, 1, '{"identifier":"core:AbstractPhysicalSpace","table":"feature","properties":[{"name":"lod1TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod2TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod3TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"pointCloud","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (11, 10, 'AbstractUnoccupiedSpace', 1, 0, 1, '{"identifier":"core:AbstractUnoccupiedSpace","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (12, 10, 'AbstractOccupiedSpace', 1, 0, 1, '{"identifier":"core:AbstractOccupiedSpace","table":"feature","properties":[{"name":"lod1ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:ImplicitGeometryProperty"},{"name":"lod2ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:ImplicitGeometryProperty"},{"name":"lod3ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (13, 7, 'AbstractSpaceBoundary', 1, 0, 1, '{"identifier":"core:AbstractSpaceBoundary","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (14, 13, 'AbstractThematicSurface', 1, 0, 1, '{"identifier":"core:AbstractThematicSurface","table":"feature","properties":[{"name":"area","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:QualifiedArea"},{"name":"lod0MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod2MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"lod3MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:GeometryProperty"},{"name":"pointCloud","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (15, 14, 'ClosureSurface', 0, 0, 1, '{"identifier":"core:ClosureSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (16, 6, 'AbstractDynamizer', 1, 0, 1, '{"identifier":"core:AbstractDynamizer","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (17, 6, 'AbstractVersionTransition', 1, 0, 1, '{"identifier":"core:AbstractVersionTransition","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (18, 6, 'CityModel', 0, 0, 1, '{"identifier":"core:CityModel","table":"feature","properties":[{"name":"cityObjectMember","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"versionMember","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"versionTransitionMember","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty"},{"name":"appearanceMember","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:AppearanceProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (19, 6, 'AbstractVersion', 1, 0, 1, '{"identifier":"core:AbstractVersion","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (20, null, 'AbstractAppearance', 1, 0, 1, '{"identifier":"core:AbstractAppearance","table":"appearance"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (21, null, 'ImplicitGeometry', 0, 0, 1, '{"identifier":"core:ImplicitGeometry","table":"implicit_geometry","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"objectid","type":"string"}},{"name":"mimeType","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"mime_type","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"mime_type_codespace","type":"string"},"parent":1},{"name":"libraryObject","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"reference_to_library","type":"uri"}},{"name":"relativeGeometry","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","join":{"table":"geometry_data","fromColumn":"relative_geometry_id","toColumn":"id"}},{"name":"appearance","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","join":{"table":"appearance","fromColumn":"id","toColumn":"implicit_geometry_id"}}]}');

-- Dynamizer Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (100, 16, 'Dynamizer', 0, 0, 2, '{"identifier":"dyn:Dynamizer","table":"feature","properties":[{"name":"attributeRef","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"startTime","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Timestamp"},{"name":"endTime","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Timestamp"},{"name":"dynamicData","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:FeatureProperty"},{"name":"sensorConnection","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"dyn:SensorConnection"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (101, 3, 'AbstractTimeseries', 1, 0, 2, '{"identifier":"dyn:AbstractTimeseries","table":"feature","properties":[{"name":"firstTimestamp","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Timestamp"},{"name":"lastTimestamp","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Timestamp"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (102, 101, 'AbstractAtomicTimeseries', 1, 0, 2, '{"identifier":"dyn:AbstractAtomicTimeseries","table":"feature","properties":[{"name":"observationProperty","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"uom","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (103, 102, 'TabulatedFileTimeseries', 0, 0, 2, '{"identifier":"dyn:TabulatedFileTimeseries","table":"feature","properties":[{"name":"fileLocation","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:URI"},{"name":"fileType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Code"},{"name":"mimeType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Code"},{"name":"valueType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"numberOfHeaderLines","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Integer"},{"name":"fieldSeparator","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"decimalSymbol","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"idColumnNo","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Integer"},{"name":"idColumnName","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"idValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"timeColumnNo","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Integer"},{"name":"timeColumnName","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"valueColumnNo","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Integer"},{"name":"valueColumnName","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (104, 102, 'StandardFileTimeseries', 0, 0, 2, '{"identifier":"dyn:StandardFileTimeseries","table":"feature","properties":[{"name":"fileLocation","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:URI"},{"name":"fileType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Code"},{"name":"mimeType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (105, 102, 'GenericTimeseries', 0, 0, 2, '{"identifier":"dyn:GenericTimeseries","table":"feature","properties":[{"name":"valueType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String"},{"name":"timeValuePair","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"dyn:TimePairValue"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (106, 101, 'CompositeTimeseries', 0, 0, 2, '{"identifier":"dyn:CompositeTimeseries","table":"feature","properties":[{"name":"component","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"dyn:TimeseriesComponent"}]}');

-- Generics Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (200, 9, 'GenericLogicalSpace', 0, 1, 3, '{"identifier":"gen:GenericLogicalSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (201, 12, 'GenericOccupiedSpace', 0, 1, 3, '{"identifier":"gen:GenericOccupiedSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"lod0Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod1Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod0TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod0ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (202, 11, 'GenericUnoccupiedSpace', 0, 1, 3, '{"identifier":"gen:GenericUnoccupiedSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (203, 14, 'GenericThematicSurface', 0, 0, 3, '{"identifier":"gen:GenericThematicSurface","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/generics/5.0","type":"core:Code"}]}');

-- LandUse Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (300, 14, 'LandUse', 0, 1, 4, '{"identifier":"luse:LandUse","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/landuse/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/landuse/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/landuse/5.0","type":"core:Code"}]}');

-- PointCloud Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (400, 5, 'PointCloud', 0, 0, 5, '{"identifier":"pcl:PointCloud","table":"feature","properties":[{"name":"mimeType","namespace":"http://3dcitydb.org/3dcitydb/pointcloud/5.0","type":"core:Code"},{"name":"pointFile","namespace":"http://3dcitydb.org/3dcitydb/pointcloud/5.0","type":"core:URI"},{"name":"pointFileSrsName","namespace":"http://3dcitydb.org/3dcitydb/pointcloud/5.0","type":"core:String"},{"name":"points","namespace":"http://3dcitydb.org/3dcitydb/pointcloud/5.0","type":"core:GeometryProperty"}]}');

-- Relief Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (500, 13, 'ReliefFeature', 0, 1, 6, '{"identifier":"dem:ReliefFeature","table":"feature","properties":[{"name":"lod","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:Integer"},{"name":"reliefComponent","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (501, 13, 'AbstractReliefComponent', 1, 0, 6, '{"identifier":"dem:AbstractReliefComponent","table":"feature","properties":[{"name":"lod","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:Integer"},{"name":"extent","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (502, 501, 'TINRelief', 0, 0, 6, '{"identifier":"dem:TINRelief","table":"feature","properties":[{"name":"tin","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (503, 501, 'MassPointRelief', 0, 0, 6, '{"identifier":"dem:MassPointRelief","table":"feature","properties":[{"name":"reliefPoints","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:GeometryProperty"},{"name":"pointCloud","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (504, 501, 'BreaklineRelief', 0, 0, 6, '{"identifier":"dem:BreaklineRelief","table":"feature","properties":[{"name":"ridgeOrValleyLines","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:GeometryProperty"},{"name":"breaklines","namespace":"http://3dcitydb.org/3dcitydb/relief/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (505, 501, 'RasterRelief', 0, 0, 6, '{"identifier":"dem:RasterRelief","table":"feature"}');

-- Transportation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (600, 11, 'AbstractTransportationSpace', 1, 0, 7, '{"identifier":"tran:AbstractTransportationSpace","table":"feature","properties":[{"name":"trafficDirection","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:String"},{"name":"occupancy","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Occupancy"},{"name":"trafficSpace","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"auxiliaryTrafficSpace","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"hole","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"marking","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (601, 600, 'Railway', 0, 1, 7, '{"identifier":"tran:Railway","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"section","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"intersection","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (602, 600, 'Section', 0, 0, 7, '{"identifier":"tran:Section","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (603, 600, 'Waterway', 0, 1, 7, '{"identifier":"tran:Waterway","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"section","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"intersection","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (604, 600, 'Intersection', 0, 0, 7, '{"identifier":"tran:Intersection","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (605, 600, 'Square', 0, 1, 7, '{"identifier":"tran:Square","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (606, 600, 'Track', 0, 1, 7, '{"identifier":"tran:Track","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (607, 600, 'Road', 0, 1, 7, '{"identifier":"tran:Road","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"section","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"intersection","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (608, 11, 'AuxiliaryTrafficSpace', 0, 0, 7, '{"identifier":"tran:AuxiliaryTrafficSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"granularity","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:String"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (609, 11, 'ClearanceSpace', 0, 0, 7, '{"identifier":"tran:ClearanceSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (610, 11, 'TrafficSpace', 0, 0, 7, '{"identifier":"tran:TrafficSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"granularity","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:String"},{"name":"trafficDirection","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:String"},{"name":"occupancy","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Occupancy"},{"name":"predecessor","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"successor","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"},{"name":"clearanceSpace","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (611, 11, 'Hole', 0, 0, 7, '{"identifier":"tran:Hole","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (612, 14, 'AuxiliaryTrafficArea', 0, 0, 7, '{"identifier":"tran:AuxiliaryTrafficArea","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"surfaceMaterial","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (613, 14, 'TrafficArea', 0, 0, 7, '{"identifier":"tran:TrafficArea","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"},{"name":"surfaceMaterial","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (614, 14, 'Marking', 0, 0, 7, '{"identifier":"tran:Marking","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/transportation/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (615, 14, 'HoleSurface', 0, 0, 7, '{"identifier":"tran:HoleSurface","table":"feature"}');

-- Construction Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (700, 12, 'AbstractConstruction', 1, 0, 8, '{"identifier":"con:AbstractConstruction","table":"feature","properties":[{"name":"conditionOfConstruction","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:String"},{"name":"dateOfConstruction","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Timestamp"},{"name":"dateOfDemolition","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Timestamp"},{"name":"constructionEvent","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"con:ConstructionEvent"},{"name":"elevation","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"con:Elevation"},{"name":"height","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"con:Height"},{"name":"occupancy","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Occupancy"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (701, 700, 'OtherConstruction', 0, 1, 8, '{"identifier":"con:OtherConstruction","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (702, 12, 'AbstractConstructiveElement', 1, 0, 8, '{"identifier":"con:AbstractConstructiveElement","table":"feature","properties":[{"name":"isStructuralElement","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Boolean"},{"name":"filling","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (703, 12, 'AbstractFillingElement', 1, 0, 8, '{"identifier":"con:AbstractFillingElement","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (704, 703, 'Window', 0, 0, 8, '{"identifier":"con:Window","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"address","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:AddressProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (705, 703, 'Door', 0, 0, 8, '{"identifier":"con:Door","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"},{"name":"address","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:AddressProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (706, 12, 'AbstractFurniture', 1, 0, 8, '{"identifier":"con:AbstractFurniture","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (707, 12, 'AbstractInstallation', 1, 0, 8, '{"identifier":"con:AbstractInstallation","table":"feature","properties":[{"name":"relationToConstruction","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:String"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (708, 14, 'AbstractConstructionSurface', 1, 0, 8, '{"identifier":"con:AbstractConstructionSurface","table":"feature","properties":[{"name":"fillingSurface","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (709, 708, 'WallSurface', 0, 0, 8, '{"identifier":"con:WallSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (710, 708, 'GroundSurface', 0, 0, 8, '{"identifier":"con:GroundSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (711, 708, 'InteriorWallSurface', 0, 0, 8, '{"identifier":"con:InteriorWallSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (712, 708, 'RoofSurface', 0, 0, 8, '{"identifier":"con:RoofSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (713, 708, 'FloorSurface', 0, 0, 8, '{"identifier":"con:FloorSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (714, 708, 'OuterFloorSurface', 0, 0, 8, '{"identifier":"con:OuterFloorSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (715, 708, 'CeilingSurface', 0, 0, 8, '{"identifier":"con:CeilingSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (716, 708, 'OuterCeilingSurface', 0, 0, 8, '{"identifier":"con:OuterCeilingSurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (717, 14, 'AbstractFillingSurface', 1, 0, 8, '{"identifier":"con:AbstractFillingSurface","table":"feature","properties":[{"name":"lod3ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (718, 717, 'DoorSurface', 0, 0, 8, '{"identifier":"con:DoorSurface","table":"feature","properties":[{"name":"address","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:AddressProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (719, 717, 'WindowSurface', 0, 0, 8, '{"identifier":"con:WindowSurface","table":"feature"}');

-- Tunnel Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (800, 700, 'AbstractTunnel', 1, 0, 9, '{"identifier":"tun:AbstractTunnel","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"tunnelConstructiveElement","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"},{"name":"tunnelInstallation","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"},{"name":"hollowSpace","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"},{"name":"tunnelFurniture","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (801, 800, 'Tunnel', 0, 1, 9, '{"identifier":"tun:Tunnel","table":"feature","properties":[{"name":"tunnelPart","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (802, 800, 'TunnelPart', 0, 0, 9, '{"identifier":"tun:TunnelPart","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (803, 702, 'TunnelConstructiveElement', 0, 0, 9, '{"identifier":"tun:TunnelConstructiveElement","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (804, 11, 'HollowSpace', 0, 0, 9, '{"identifier":"tun:HollowSpace","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"tunnelFurniture","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"},{"name":"tunnelInstallation","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:FeatureProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (805, 707, 'TunnelInstallation', 0, 0, 9, '{"identifier":"tun:TunnelInstallation","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (806, 706, 'TunnelFurniture', 0, 0, 9, '{"identifier":"tun:TunnelFurniture","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/tunnel/5.0","type":"core:Code"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

-- Building Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (900, 700, 'AbstractBuilding', 1, 0, 10, '{"identifier":"bldg:AbstractBuilding","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"roofType","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"storeysAboveGround","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Integer"},{"name":"storeysBelowGround","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Integer"},{"name":"storeyHeightsAboveGround","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:MeasureOrNilReasonList"},{"name":"storeyHeightsBelowGround","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:MeasureOrNilReasonList"},{"name":"buildingConstructiveElement","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingInstallation","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingRoom","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingFurniture","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingSubdivision","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"address","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:AddressProperty"},{"name":"lod0RoofEdge","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (901, 900, 'Building', 0, 1, 10, '{"identifier":"bldg:Building","table":"feature","properties":[{"name":"buildingPart","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (902, 900, 'BuildingPart', 0, 0, 10, '{"identifier":"bldg:BuildingPart","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (903, 702, 'BuildingConstructiveElement', 0, 0, 10, '{"identifier":"bldg:BuildingConstructiveElement","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (904, 11, 'BuildingRoom', 0, 0, 10, '{"identifier":"bldg:BuildingRoom","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"roomHeight","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"bldg:RoomHeight"},{"name":"buildingFurniture","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingInstallation","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (905, 707, 'BuildingInstallation', 0, 0, 10, '{"identifier":"bldg:BuildingInstallation","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (906, 706, 'BuildingFurniture', 0, 0, 10, '{"identifier":"bldg:BuildingFurniture","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (907, 9, 'AbstractBuildingSubdivision', 1, 0, 10, '{"identifier":"bldg:AbstractBuildingSubdivision","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code"},{"name":"elevation","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"con:Elevation"},{"name":"sortKey","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Double"},{"name":"buildingConstructiveElement","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingFurniture","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingInstallation","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"buildingRoom","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (908, 907, 'BuildingUnit', 0, 0, 10, '{"identifier":"bldg:BuildingUnit","table":"feature","properties":[{"name":"storey","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"},{"name":"address","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:AddressProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (909, 907, 'Storey', 0, 0, 10, '{"identifier":"bldg:Storey","table":"feature","properties":[{"name":"buildingUnit","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:FeatureProperty"}]}');

-- Bridge Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1000, 700, 'AbstractBridge', 1, 0, 11, '{"identifier":"brid:AbstractBridge","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"isMovable","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Boolean"},{"name":"bridgeConstructiveElement","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"},{"name":"bridgeInstallation","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"},{"name":"bridgeRoom","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"},{"name":"bridgeFurniture","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"},{"name":"address","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:AddressProperty"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1001, 1000, 'Bridge', 0, 1, 11, '{"identifier":"brid:Bridge","table":"feature","properties":[{"name":"bridgePart","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1002, 1000, 'BridgePart', 0, 0, 11, '{"identifier":"brid:BridgePart","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1003, 702, 'BridgeConstructiveElement', 0, 0, 11, '{"identifier":"brid:BridgeConstructiveElement","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"lod1Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1004, 11, 'BridgeRoom', 0, 0, 11, '{"identifier":"brid:BridgeRoom","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"bridgeFurniture","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"},{"name":"bridgeInstallation","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:FeatureProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1005, 707, 'BridgeInstallation', 0, 0, 11, '{"identifier":"brid:BridgeInstallation","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1006, 706, 'BridgeFurniture', 0, 0, 11, '{"identifier":"brid:BridgeFurniture","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/bridge/5.0","type":"core:Code"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

-- Appearance Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1100, 20, 'Appearance', 0, 0, 12, '{"identifier":"app:Appearance","table":"appearance","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"objectid","type":"string"}},{"name":"identifier","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier_codespace","type":"string"},"parent":1},{"name":"theme","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"theme","type":"string"}},{"name":"creationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"creation_date","type":"timestamp"}},{"name":"terminationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"termination_date","type":"timestamp"}},{"name":"validFrom","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"valid_from","type":"timestamp"}},{"name":"validTo","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"valid_to","type":"timestamp"}},{"name":"isGlobal","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"is_global","type":"boolean"}},{"name":"surfaceData","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","joinTable":{"table":"appear_to_surface_data","sourceJoin":{"table":"appearance","fromColumn":"appearance_id","toColumn":"id"},"targetJoin":{"table":"surface_data","fromColumn":"surface_data_id","toColumn":"id"}}}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1101, null, 'AbstractSurfaceData', 1, 0, 12, '{"identifier":"app:AbstractSurfaceData","table":"surface_data","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"objectid","type":"string"}},{"name":"identifier","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"identifier_codespace","type":"string"},"parent":1},{"name":"isFront","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"is_front","type":"boolean"}}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1102, 1101, 'X3DMaterial', 0, 0, 12, '{"identifier":"app:X3DMaterial","table":"surface_data","properties":[{"name":"shininess","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_shininess","type":"double"}},{"name":"transparency","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_transparency","type":"double"}},{"name":"ambientIntensity","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_ambient_intensity","type":"double"}},{"name":"specularColor","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_specular_color","type":"string"}},{"name":"diffuseColor","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_diffuse_color","type":"string"}},{"name":"emissiveColor","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_emissive_color","type":"string"}},{"name":"isSmooth","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"x3d_is_smooth","type":"boolean"}}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1103, 1101, 'AbstractTexture', 1, 0, 12, '{"identifier":"app:AbstractTexture","table":"surface_data","properties":[{"name":"imageURI","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"image_uri","type":"uri"},"join":{"table":"tex_image","fromColumn":"tex_image_id","toColumn":"id"}},{"name":"mimeType","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"mime_type","type":"string"},"join":{"table":"tex_image","fromColumn":"tex_image_id","toColumn":"id"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"mime_type_codespace","type":"string"},"parent":1},{"name":"wrapMode","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"tex_wrap_mode","type":"string"}},{"name":"borderColor","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"tex_border_color","type":"string"}}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1104, 1103, 'ParameterizedTexture', 0, 0, 12, '{"identifier":"app:ParameterizedTexture","table":"surface_data"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1105, 1103, 'GeoreferencedTexture', 0, 0, 12, '{"identifier":"app:GeoreferencedTexture","table":"surface_data","properties":[{"name":"referencePoint","namespace":"http://3dcitydb.org/3dcitydb/appearance/5.0","value":{"column":"gt_reference_point","type":"geometry"}}]}');

-- CityObjectGroup Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1200, 9, 'CityObjectGroup', 0, 1, 13, '{"identifier":"grp:CityObjectGroup","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"core:Code"},{"name":"groupMember","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"grp:Role"},{"name":"parent","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"core:FeatureProperty"},{"name":"geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

-- Vegetation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1300, 12, 'AbstractVegetationObject', 1, 0, 14, '{"identifier":"veg:AbstractVegetationObject","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1301, 1300, 'SolitaryVegetationObject', 0, 1, 14, '{"identifier":"veg:SolitaryVegetationObject","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"species","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"height","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"trunkDiameter","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"crownDiameter","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"rootBallDiameter","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"maxRootBallDepth","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"lod1Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1302, 1300, 'PlantCover', 0, 1, 14, '{"identifier":"veg:PlantCover","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Code"},{"name":"averageHeight","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"minHeight","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"maxHeight","namespace":"http://3dcitydb.org/3dcitydb/vegetation/5.0","type":"core:Measure"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod1MultiSolid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod2MultiSolid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3MultiSolid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4MultiSolid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

-- Versioning Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1400, 19, 'Version', 0, 0, 15, '{"identifier":"vers:Version","table":"feature","properties":[{"name":"tag","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:String"},{"name":"versionMember","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:FeatureProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1401, 17, 'VersionTransition', 0, 0, 15, '{"identifier":"vers:VersionTransition","table":"feature","properties":[{"name":"reason","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:String"},{"name":"clonePredecessor","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:Boolean"},{"name":"type","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:String"},{"name":"from","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:FeatureProperty"},{"name":"to","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:FeatureProperty"},{"name":"transaction","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"vers:Transaction"}]}');

-- WaterBody Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1500, 12, 'WaterBody', 0, 1, 16, '{"identifier":"wtr:WaterBody","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/waterbody/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/waterbody/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/waterbody/5.0","type":"core:Code"},{"name":"lod1MultiCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod1MultiSurface","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Solid","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1501, 14, 'AbstractWaterBoundarySurface', 1, 0, 16, '{"identifier":"wtr:AbstractWaterBoundarySurface","table":"feature"}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1502, 1501, 'WaterSurface', 0, 0, 16, '{"identifier":"wtr:WaterSurface","table":"feature","properties":[{"name":"waterLevel","namespace":"http://3dcitydb.org/3dcitydb/waterbody/5.0","type":"core:Code"}]}');

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1503, 1501, 'WaterGroundSurface', 0, 0, 16, '{"identifier":"wtr:WaterGroundSurface","table":"feature"}');

-- CityFurniture Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1600, 12, 'CityFurniture', 0, 1, 17, '{"identifier":"frn:CityFurniture","table":"feature","properties":[{"name":"class","namespace":"http://3dcitydb.org/3dcitydb/cityfurniture/5.0","type":"core:Code"},{"name":"function","namespace":"http://3dcitydb.org/3dcitydb/cityfurniture/5.0","type":"core:Code"},{"name":"usage","namespace":"http://3dcitydb.org/3dcitydb/cityfurniture/5.0","type":"core:Code"},{"name":"lod1Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod2Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod3Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4Geometry","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4TerrainIntersectionCurve","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:GeometryProperty"},{"name":"lod4ImplicitRepresentation","namespace":"http://3dcitydb.org/3dcitydb/deprecated/5.0","type":"core:ImplicitGeometryProperty"}]}');
