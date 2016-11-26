-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
--     
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

----------------------------------------------------------------------
--
-- S O L D N E R     P R O J E C T I O N
--
----------------------------------------------------------------------
-- Reference to the following Soldner projection and the parameter:

-- Christian Manthe, Christian Clemen, Lothar Gruendig:
-- Using Oracle Spatial with Coordinate Systems Based on Any Regional Geodetic Datum
-- In:
-- Argina G. Novitskaya (ed.)
-- FIG Commissions 5, 6 and SSGA Workshop for an Innovative Technologies for an Efficient Geospatial Management of Earth Resources
-- Proceedings 23-30 July 2009
-- Siberian State Academy of Geodesy (SSGA), Novosibirsk 2009
-- p. 20-30.
-- ISSN: 978-5-87693-339-3
-- URL: http://www.fig.net/commission6/lakebaikal_2009/papers/04_manthe_clemen_gruendig.pdf (last access 10.02.2010)

ALTER session SET NLS_NUMERIC_CHARACTERS = ".,";

----------------------------------------------------------------------
-- Delete old entries
----------------------------------------------------------------------
DELETE FROM MDSYS.SDO_COORD_REF_SYS WHERE SRID=81989002;
DELETE FROM mdsys.sdo_cs_srs WHERE SRID=81989002;
DELETE FROM MDSYS.SDO_COORD_REF_SYSTEM WHERE SRID=81989003;
DELETE FROM MDSYS.SDO_COORD_OP_PARAM_VALS WHERE COORD_OP_ID=81989004;
DELETE FROM MDSYS.SDO_COORD_OPS WHERE COORD_OP_ID=81989004;
DELETE FROM MDSYS.SDO_DATUMS WHERE DATUM_ID = 81989005;
----------------------------------------------------------------------
-- Projection
----------------------------------------------------------------------
INSERT INTO MDSYS.SDO_COORD_OPS ( COORD_OP_ID, COORD_OP_NAME, COORD_OP_TYPE, SOURCE_SRID,
    TARGET_SRID ,COORD_TFM_VERSION, COORD_OP_VARIANT, COORD_OP_METHOD_ID, UOM_ID_SOURCE_OFFSETS, UOM_ID_TARGET_OFFSETS , INFORMATION_SOURCE, DATA_SOURCE, SHOW_OPERATION,IS_LEGACY, LEGACY_CODE, REVERSE_OP, IS_IMPLEMENTED_FORWARD, IS_IMPLEMENTED_REVERSE) 
  VALUES (81989004,'Soldner Berlin','CONVERSION',NULL,NULL,NULL,NULL,9806,NULL,NULL,'IGG TU Berlin','IGG TU Berlin',1,'FALSE',NULL,0,0,0);
----------------------------------------------------------------------
-- Set Berlin Parameter of Soldner/Cassini Projection --
----------------------------------------------------------------------
--
-- 8801: Latitude_Of_Origin
--
 INSERT INTO MDSYS.SDO_COORD_OP_PARAM_VALS (COORD_OP_ID, COORD_OP_METHOD_ID,PARAMETER_ID, PARAMETER_VALUE, PARAM_VALUE_FILE_REF, UOM_ID) 
  VALUES (81989004,9806,8801,52.41864827777778,NULL,10001);
--
-- 8802: Central_Meridian
--
INSERT INTO MDSYS.SDO_COORD_OP_PARAM_VALS (COORD_OP_ID,COORD_OP_METHOD_ID, PARAMETER_ID, PARAMETER_VALUE, PARAM_VALUE_FILE_REF, UOM_ID)
  VALUES (81989004,9806,8802,13.62720366666667,NULL,10001);
--
-- 8806: False_Easting
--
 INSERT INTO MDSYS.SDO_COORD_OP_PARAM_VALS (COORD_OP_ID, COORD_OP_METHOD_ID,PARAMETER_ID, PARAMETER_VALUE,PARAM_VALUE_FILE_REF, UOM_ID)
  VALUES (81989004,9806,8806,40000,NULL,9001);
--
-- 8807: False_Northing
-- 
 INSERT INTO MDSYS.SDO_COORD_OP_PARAM_VALS (COORD_OP_ID,COORD_OP_METHOD_ID,PARAMETER_ID,PARAMETER_VALUE,PARAM_VALUE_FILE_REF, UOM_ID) 
  VALUES (81989004,9806,8807,10000,NULL,9001);
  
  
----------------------------------------------------------------------
--
-- D A T U M   N E T Z 8 8 
--
----------------------------------------------------------------------
  
----------------------------------------------------------------------
-- Netz88 Datum (Ellipsoid) --
----------------------------------------------------------------------
 INSERT INTO MDSYS.SDO_DATUMS (DATUM_ID,DATUM_NAME,DATUM_TYPE,ELLIPSOID_ID,PRIME_MERIDIAN_ID,INFORMATION_SOURCE,DATA_SOURCE,SHIFT_X,SHIFT_Y,SHIFT_Z,ROTATE_X,ROTATE_Y,ROTATE_Z,SCALE_ADJUST,IS_LEGACY,LEGACY_CODE)
  VALUES (81989005,'Netz88 (Berlin)','GEODETIC',8004,8901,'IGG TU Berlin','IGG TU Berlin',675.239155,25.30349,422.544682,-0.717994,-1.766241,-0.719541,-0.245916,'FALSE',NULL);
  ---------------------------------------------------------------------
--
-- 2D-Geographic Coordinate System with Datum Netz88 (status 850))
--
----------------------------------------------------------------------
 INSERT INTO MDSYS.SDO_COORD_REF_SYSTEM (SRID,COORD_REF_SYS_NAME,COORD_REF_SYS_KIND,COORD_SYS_ID,DATUM_ID,GEOG_CRS_DATUM_ID,SOURCE_GEOG_SRID,PROJECTION_CONV_ID,CMPD_HORIZ_SRID,CMPD_VERT_SRID,INFORMATION_SOURCE,DATA_SOURCE,IS_LEGACY,LEGACY_CODE,LEGACY_WKTEXT,LEGACY_CS_BOUNDS,IS_VALID,SUPPORTS_SDO_GEOMETRY)
  VALUES (81989003,'Geographische Koordinaten Netz88 (Berlin)','GEOGRAPHIC2D',6405,81989005,NULL,NULL,NULL,NULL,NULL,'IGG TU Berlin','IGG TU Berlin','FALSE',NULL,NULL,NULL,'FALSE','TRUE');
----------------------------------------------------------------------
-- Soldner Coordinate System with Datum Netz88 (status 500)
----------------------------------------------------------------------
 INSERT INTO MDSYS.SDO_COORD_REF_SYSTEM (SRID,COORD_REF_SYS_NAME,COORD_REF_SYS_KIND,COORD_SYS_ID,DATUM_ID,SOURCE_GEOG_SRID,PROJECTION_CONV_ID,CMPD_HORIZ_SRID ,CMPD_VERT_SRID,INFORMATION_SOURCE,DATA_SOURCE,IS_LEGACY,LEGACY_CODE,LEGACY_WKTEXT,LEGACY_CS_BOUNDS,GEOG_CRS_DATUM_ID)
  VALUES (81989002,'Soldner Koordinaten Netz88 (Berlin)','PROJECTED',4400,NULL,81989003,81989004,NULL,NULL,'IGG TU Berlin','IGG TU Berlin','FALSE',NULL, NULL,NULL,81989005);


COMMIT;

