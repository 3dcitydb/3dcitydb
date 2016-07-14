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
-------------------------------------------------------------------------------
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2015-03-05   added support for Oracle Locator            ZYao
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ALor
CREATE SEQUENCE ADDRESS_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE APPEARANCE_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE CITYMODEL_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE CITYOBJECT_GENERICATT_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE CITYOBJECT_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE EXTERNAL_REF_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE IMPLICIT_GEOMETRY_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

BEGIN
  IF ('&DBVERSION'='S' or '&DBVERSION'='s') THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE GRID_COVERAGE_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 NOCACHE';  
    EXECUTE IMMEDIATE 'CREATE SEQUENCE GRID_COVERAGE_RDT_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 NOCACHE';
  END IF;
END;
/

CREATE SEQUENCE SURFACE_DATA_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE SURFACE_GEOMETRY_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;

CREATE SEQUENCE TEX_IMAGE_SEQ INCREMENT BY 1 START WITH 1 MINVALUE 1 CACHE 10000;
