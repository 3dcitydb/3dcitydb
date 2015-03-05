-- DROP_DB.sql
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
-- 2.0.2     2008-06-28   disable versioning before dropping          TKol
-- 2.0.1     2008-06-28   also drop planning manager tables           TKol
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--                                                                    ASta
--                                                                    ALor
--
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

prompt
prompt DROP_DB procedure will be started
accept DBVERSION CHAR DEFAULT 'S' PROMPT 'Which database license are you using? (Oracle Spaital(S)/Oracle Locator(L), default is S): '
prompt

VARIABLE BATCHFILE VARCHAR2(50);

BEGIN
  IF NOT ('&DBVERSION'='L' or '&DBVERSION'='l' or '&DBVERSION'='S' or '&DBVERSION'='s') THEN
  	:BATCHFILE := 'UTIL/CREATE_DB/HINT_ON_MISSTYPING_DBVERSION';	
  ELSE 
  	:BATCHFILE := 'DROP_DB2';
  END IF;  
END;
/

-- Transfer the value from the bind variable to the substitution variable
column mc new_value BATCHFILE2 print
select :BATCHFILE mc from dual;

@@&BATCHFILE2
