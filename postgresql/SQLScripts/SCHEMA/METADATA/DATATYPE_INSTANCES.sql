DELETE FROM datatype;

-- Core Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1, null, 'Undefined', 0, 1, @core:Undefined@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (2, null, 'Boolean', 0, 1, @core:Boolean@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (3, null, 'Integer', 0, 1, @core:Integer@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (4, null, 'Double', 0, 1, @core:Double@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (5, null, 'String', 0, 1, @core:String@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (6, null, 'URI', 0, 1, @core:URI@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (7, null, 'Timestamp', 0, 1, @core:Timestamp@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (8, null, 'AddressProperty', 0, 1, @core:AddressProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (9, null, 'AppearanceProperty', 0, 1, @core:AppearanceProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (10, null, 'FeatureProperty', 0, 1, @core:FeatureProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (11, null, 'GeometryProperty', 0, 1, @core:GeometryProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (12, null, 'Reference', 0, 1, @core:Reference@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (13, null, 'CityObjectRelation', 0, 1, @core:CityObjectRelation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (14, null, 'Code', 0, 1, @core:Code@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (15, null, 'ExternalReference', 0, 1, @core:ExternalReference@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (16, null, 'ImplicitGeometryProperty', 0, 1, @core:ImplicitGeometryProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (17, null, 'Measure', 0, 1, @core:Measure@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (18, null, 'MeasureOrNilReasonList', 0, 1, @core:MeasureOrNilReasonList@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (19, null, 'Occupancy', 0, 1, @core:Occupancy@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (20, null, 'QualifiedArea', 0, 1, @core:QualifiedArea@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (21, null, 'QualifiedVolume', 0, 1, @core:QualifiedVolume@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (22, null, 'StringOrRef', 0, 1, @core:StringOrRef@);

-- Dynamizer Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (100, null, 'SensorConnection', 0, 2, @dyn:SensorConnection@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (101, null, 'TimeseriesComponent', 0, 2, @dyn:TimeseriesComponent@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (102, null, 'TimePairValue', 0, 2, @dyn:TimePairValue@);

-- Generics Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (200, null, 'GenericAttributeSet', 0, 3, @gen:GenericAttributeSet@);

-- Construction Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (700, null, 'ConstructionEvent', 0, 8, @con:ConstructionEvent@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (701, null, 'Elevation', 0, 8, @con:Elevation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (702, null, 'Height', 0, 8, @con:Height@);

-- Building Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (900, null, 'RoomHeight', 0, 10, @bldg:RoomHeight@);

-- CityObjectGroup Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1200, null, 'Role', 0, 13, @grp:Role@);

-- Versioning Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1400, null, 'Transaction', 0, 15, @vers:Transaction@);
