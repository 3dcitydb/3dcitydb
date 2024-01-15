DELETE FROM datatype;

-- Core Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1, null, 'Undefined', 0, 1, '{"identifier":"core:Undefined","table":"feature"}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (2, null, 'Boolean', 0, 1, '{"identifier":"core:Boolean","table":"property","value":{"column":"val_int","type":"boolean"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (3, null, 'Integer', 0, 1, '{"identifier":"core:Integer","table":"property","value":{"column":"val_int","type":"integer"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (4, null, 'Double', 0, 1, '{"identifier":"core:Double","table":"property","value":{"column":"val_double","type":"double"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (5, null, 'String', 0, 1, '{"identifier":"core:String","table":"property","value":{"column":"val_string","type":"string"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (6, null, 'URI', 0, 1, '{"identifier":"core:URI","table":"property","value":{"column":"val_uri","type":"uri"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (7, null, 'Timestamp', 0, 1, '{"identifier":"core:Timestamp","table":"property","value":{"column":"val_timestamp","type":"timestamp"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (8, null, 'AddressProperty', 0, 1, '{"identifier":"core:AddressProperty","table":"property","join":{"table":"address","fromColumn":"val_address_id","toColumn":"id"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (9, null, 'AppearanceProperty', 0, 1, '{"identifier":"core:AppearanceProperty","table":"property","join":{"table":"appearance","fromColumn":"val_appearance_id","toColumn":"id"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (10, null, 'FeatureProperty', 0, 1, '{"identifier":"core:FeatureProperty","table":"property","join":{"table":"feature","fromColumn":"val_feature_id","toColumn":"id"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (11, null, 'GeometryProperty', 0, 1, '{"identifier":"core:GeometryProperty","table":"property","properties":[{"name":"lod","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_lod","type":"string"}}],"join":{"table":"geometry_data","fromColumn":"val_geometry_id","toColumn":"id"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (12, null, 'Reference', 0, 1, '{"identifier":"core:Reference","table":"property","value":{"column":"val_uri","type":"uri"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (13, null, 'CityObjectRelation', 0, 1, '{"identifier":"core:CityObjectRelation","table":"property","properties":[{"name":"relatedTo","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:FeatureProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"relationType","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (14, null, 'Code', 0, 1, '{"identifier":"core:Code","table":"property","value":{"column":"val_string","type":"string"},"properties":[{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_codespace","type":"string"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (15, null, 'ExternalReference', 0, 1, '{"identifier":"core:ExternalReference","table":"property","properties":[{"name":"targetResource","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:URI"},{"name":"informationSystem","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_codespace","type":"uri"}},{"name":"relationType","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_string","type":"uri"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (16, null, 'ImplicitGeometryProperty', 0, 1, '{"identifier":"core:ImplicitGeometryProperty","table":"property","properties":[{"name":"transformationMatrix","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_array","type":"doubleArray"}},{"name":"referencePoint","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_implicitgeom_refpoint","type":"geometry"}}],"join":{"table":"implicit_geometry","fromColumn":"val_implicitgeom_id","toColumn":"id"}}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (17, null, 'Measure', 0, 1, '{"identifier":"core:Measure","table":"property","value":{"column":"val_double","type":"double"},"properties":[{"name":"uom","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_uom","type":"string"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (18, null, 'MeasureOrNilReasonList', 0, 1, '{"identifier":"core:MeasureOrNilReasonList","table":"property","value":{"column":"val_array","type":"array","schema":{"items":{"type":["number","string"]}}},"properties":[{"name":"uom","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_uom","type":"string"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (19, null, 'Occupancy', 0, 1, '{"identifier":"core:Occupancy","table":"property","value":{"property":0},"properties":[{"name":"numberOfOccupants","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Integer","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"interval","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"occupantType","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (20, null, 'QualifiedArea', 0, 1, '{"identifier":"core:QualifiedArea","table":"property","value":{"property":0},"properties":[{"name":"area","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Measure"},{"name":"typeOfArea","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Code"}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (21, null, 'QualifiedVolume', 0, 1, '{"identifier":"core:QualifiedVolume","table":"property","value":{"property":0},"properties":[{"name":"volume","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Measure"},{"name":"typeOfVolume","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","type":"core:Code"}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (22, null, 'StringOrRef', 0, 1, '{"identifier":"core:StringOrRef","table":"property","value":{"column":"val_string","type":"string"},"properties":[{"name":"href","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","value":{"column":"val_uri","type":"uri"}}]}');

-- Dynamizer Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (100, null, 'SensorConnection', 0, 2, '{"identifier":"dyn:SensorConnection","table":"property","properties":[{"name":"connectionType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"observationProperty","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"uom","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"sensorID","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"sensorName","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"observationID","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"datastreamID","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"baseURL","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:URI","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"authType","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"mqttServer","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"mqttTopic","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"linkToObservation","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"linkToSensorDescription","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"sensorLocation","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:FeatureProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (101, null, 'TimeseriesComponent', 0, 2, '{"identifier":"dyn:TimeseriesComponent","table":"property","properties":[{"name":"repetitions","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Integer","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"additionalGap","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"timeseries","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:FeatureProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (102, null, 'TimePairValue', 0, 2, '{"identifier":"dyn:TimePairValue","table":"property","properties":[{"name":"timestamp","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Timestamp","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"intValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Integer","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"doubleValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Double","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"stringValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"geometryValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:GeometryProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"uriValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:URI","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"boolValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:Boolean","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"implicitGeometryValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:ImplicitGeometryProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"appearanceValue","namespace":"http://3dcitydb.org/3dcitydb/dynamizer/5.0","type":"core:AppearanceProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

-- Generics Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (200, null, 'GenericAttributeSet', 0, 3, '{"identifier":"gen:GenericAttributeSet","table":"property"}');

-- Construction Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (700, null, 'ConstructionEvent', 0, 8, '{"identifier":"con:ConstructionEvent","table":"property","value":{"property":0},"properties":[{"name":"event","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"dateOfEvent","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Timestamp","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"description","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (701, null, 'Elevation', 0, 8, '{"identifier":"con:Elevation","table":"property","properties":[{"name":"elevationValue","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","value":{"column":"val_array","type":"doubleArray"}},{"name":"elevationReference","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code"}]}');

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (702, null, 'Height', 0, 8, '{"identifier":"con:Height","table":"property","value":{"property":0},"properties":[{"name":"value","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Measure","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"status","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"lowReference","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"highReference","namespace":"http://3dcitydb.org/3dcitydb/construction/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

-- Building Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (900, null, 'RoomHeight', 0, 10, '{"identifier":"bldg:RoomHeight","table":"property","value":{"property":0},"properties":[{"name":"value","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Measure","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"status","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"lowReference","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"highReference","namespace":"http://3dcitydb.org/3dcitydb/building/5.0","type":"core:Code","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

-- CityObjectGroup Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1200, null, 'Role', 0, 13, '{"identifier":"grp:Role","table":"property","properties":[{"name":"groupMember","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"core:FeatureProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"role","namespace":"http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');

-- Versioning Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1400, null, 'Transaction', 0, 15, '{"identifier":"vers:Transaction","table":"property","properties":[{"name":"type","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:String","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"oldFeature","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:FeatureProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}},{"name":"newFeature","namespace":"http://3dcitydb.org/3dcitydb/versioning/5.0","type":"core:FeatureProperty","join":{"table":"property","fromColumn":"parent_id","toColumn":"id"}}]}');
