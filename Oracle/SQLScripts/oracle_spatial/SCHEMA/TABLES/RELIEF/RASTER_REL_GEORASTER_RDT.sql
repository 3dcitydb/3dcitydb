-- RASTER_REL_GEORASTER_RDT.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
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
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
--

-- To use GeoRaster with Oracle Workspace Manager or Oracle Label Security, you should create a raster data table (RDT) as a relational table for the GeoRaster objects
-- Creating a Raster Data Table (Relational) Using SecureFiles
-- http://docs.oracle.com/cd/E16655_01/appdev.121/e17894/geor_operations.htm#GEORS1009

CREATE TABLE RASTER_REL_GEORASTER_RDT
  (rasterID NUMBER,
  pyramidLevel NUMBER,
  bandBlockNumber NUMBER,
  rowBlockNumber NUMBER,
  columnBlockNumber NUMBER,
  blockMBR SDO_GEOMETRY,
  rasterBlock BLOB,
  CONSTRAINT pkey PRIMARY KEY (rasterId, pyramidLevel, bandBlockNumber,
    rowBlockNumber, columnBlockNumber))
  LOB (rasterblock) STORE AS SECUREFILE(cache);