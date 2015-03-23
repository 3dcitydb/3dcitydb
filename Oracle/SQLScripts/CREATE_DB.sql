-- CREATE_DB.sql
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
-- 3.0.0     2015-03-05   added support for Oracle Locator            ZYao
-- 3.0.0     2013-12-06   new version for 3DCityDB V3                 ZYao
--                                                                    TKol
--                                                                    CNag
--                                                                    PWil
-- 2.0.1     2008-06-28   include query for versioning enable         TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ALor
--
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

prompt
prompt
accept SRSNO NUMBER DEFAULT 81989002 PROMPT 'Please enter a valid SRID (Berlin: 81989002): '
prompt Please enter the corresponding SRSName to be used in GML exports
accept GMLSRSNAME CHAR DEFAULT 'urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783' prompt '  (Berlin: urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): '
accept VERSIONING CHAR DEFAULT 'no' PROMPT 'Shall versioning be enabled (yes/no, default is no): '
accept DBVERSION CHAR DEFAULT 'S' PROMPT 'Which database license are you using? (Oracle Spaital(S)/Oracle Locator(L), default is S): '
prompt
prompt

VARIABLE SRID NUMBER;
VARIABLE CS_NAME VARCHAR2(256);
VARIABLE BATCHFILE VARCHAR2(50);

WHENEVER SQLERROR CONTINUE;

BEGIN
  SELECT SRID,CS_NAME INTO :SRID,:CS_NAME FROM MDSYS.CS_SRS
  WHERE SRID=&SRSNO;

  IF (:SRID = &SRSNO) THEN
	  IF NOT (upper('&DBVERSION')='L' or upper('&DBVERSION')='S') THEN
		:BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISTYPED_DBVERSION';
	  ELSE
	  	:BATCHFILE := 'CREATE_DB2';
	  END IF;
  ELSE 
  	:BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISSING_SRS';
  END IF;
END;
/

-- Transfer the value from the bind variable to the substitution variable
column mc new_value BATCHFILE2 print
select :BATCHFILE mc from dual;

START &BATCHFILE2