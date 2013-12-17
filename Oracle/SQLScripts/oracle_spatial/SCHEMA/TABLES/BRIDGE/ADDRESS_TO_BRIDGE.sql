-- ADDRESS_TO_BRIDGE.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Zhihang Yao <zhihang.yao@tum.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Philipp Willkomm <pwillkomm@moss.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
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

CREATE TABLE ADDRESS_TO_BRIDGE 
(
BIRDGE_ID NUMBER NOT NULL, 
ADDRESS_ID NUMBER NOT NULL 
)
;
ALTER TABLE ADDRESS_TO_BRIDGE
ADD CONSTRAINT ADDRESS_TO_BRIDGE_PK PRIMARY KEY 
(
BIRDGE_ID, 
ADDRESS_ID 
)
  ENABLE 
;