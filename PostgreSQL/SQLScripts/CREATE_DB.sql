-- CREATE_DB.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--              Philipp Willkomm <pwillkomm@moss.de>
--              Gerhard König <gerhard.koenig@tu-berlin.de>
--              Alexandra Lorenz <di.alex.lorenz@googlemail.com>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2014-01-08   new script for 3DCityDB V3                  FKun	   
-- 2.0.0     2012-05-21   PostGIS version                             FKun
--                                                                    TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ASta
--

-- This script is called from CREATE_DB.bat

SET client_min_messages TO WARNING;

\prompt 'Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin): ' SRS_NO
\prompt 'Please enter the corresponding SRSName to be used in GML exports (e.g., urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783): ' GMLSRSNAME

\set SRSNO :SRS_NO
\set ON_ERROR_STOP ON
\echo

--// checks if the chosen SRID is provided by the spatial_ref_sys table
\i UTIL/CREATE_DB/CHECK_SRID.sql
SELECT check_srid(:SRS_NO);

--// create TABLES, SEQUENCES, CONSTRAINTS, INDEXES
\i SCHEMA/SCHEMA.sql

--// fill tables OBJECTCLASS and DATABASE_SRS
\i UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql
INSERT INTO DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (:SRS_NO,:'GMLSRSNAME');

--// create GEODB_PKG (additional schema with PL_pgSQL-Functions)
\i CREATE_GEODB_PKG.sql

\echo
\echo '3DCityDB creation complete!'