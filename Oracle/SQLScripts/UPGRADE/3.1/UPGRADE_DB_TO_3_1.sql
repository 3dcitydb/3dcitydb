-- UPGRADE_DB_TO_3_1.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2015  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
-------------------------------------------------------------------------------
-- About:
-- Upgrade script from version 3.0 to version 3.1 of the 3D City Database
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2015-11-05   release version                             FKun
-- 1.0.1     2016-02-17   DROP INDEX statements added for             TKolbe 
--                        ADDRESS_INX, CITYMODEL_INX.
--                        Removed lines with "\" after normal SQL
--                        statements (they are only necessary after
--                        PL/SQL commands).
--

SET SERVEROUTPUT ON

SELECT 'Starting 3D City Database upgrade...' as message from DUAL;

--// drop indexes to be replaced
DROP INDEX CITYMODEL_INX;
DROP INDEX CITYOBJECT_INX;
DROP INDEX APPEARANCE_INX;
DROP INDEX SURFACE_GEOM_INX;
DROP INDEX SURFACE_DATA_INX;
DROP INDEX ADDRESS_INX;

--// add columns new in v3.1
ALTER TABLE CITYMODEL
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE CITYOBJECT
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE APPEARANCE
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE SURFACE_DATA
  ADD GMLID_CODESPACE VARCHAR2(1000);
  
ALTER TABLE SURFACE_GEOMETRY
  ADD GMLID_CODESPACE VARCHAR2(1000);

ALTER TABLE ADDRESS
  ADD (GMLID VARCHAR2(256),
       GMLID_CODESPACE VARCHAR2(1000));

--// fill gmlid column in address table
UPDATE ADDRESS SET GMLID = ('ID_'||ID);

--// create new indexes
CREATE INDEX CITYMODEL_INX ON CITYMODEL (GMLID, GMLID_CODESPACE);
CREATE INDEX CITYOBJECT_INX ON CITYOBJECT (GMLID, GMLID_CODESPACE);
CREATE INDEX CITYOBJECT_LINEAGE_INX ON CITYOBJECT (LINEAGE);
CREATE INDEX APPEARANCE_INX ON APPEARANCE (GMLID, GMLID_CODESPACE);
CREATE INDEX SURFACE_GEOM_INX ON SURFACE_GEOMETRY (GMLID, GMLID_CODESPACE);
CREATE INDEX SURFACE_DATA_INX ON SURFACE_DATA (GMLID, GMLID_CODESPACE);
CREATE INDEX ADDRESS_INX ON ADDRESS (GMLID, GMLID_CODESPACE);

--// get SRID for spatial index
VARIABLE SRID NUMBER;
BEGIN
  SELECT SRID INTO :SRID FROM DATABASE_SRS;
END;
/

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='ADDRESS' AND COLUMN_NAME='MULTI_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
VALUES ('ADDRESS','MULTI_POINT', MDSYS.SDO_DIM_ARRAY(
           MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
           MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),
           MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)), :SRID);

CREATE INDEX ADDRESS_POINT_SPX ON ADDRESS (MULTI_POINT) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

--// drop old versions of CITYDB_PKG
@DROP_CITYDB_PKG.sql

--// contents of @@../../CREATE_CITYDB_PKG.sql
SELECT 'Installing CITYDB packages...' as message from DUAL;
@@../../PL_SQL/CITYDB_PKG/UTIL/UTIL.sql;
@@../../PL_SQL/CITYDB_PKG/INDEX/IDX.sql;
@@../../PL_SQL/CITYDB_PKG/SRS/SRS.sql;
@@../../PL_SQL/CITYDB_PKG/STATISTICS/STAT.sql;
@@../../PL_SQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql;
@@../../PL_SQL/CITYDB_PKG/DELETE/DELETE.sql;
@@../../PL_SQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql;
SELECT 'CITYDB package installed.' as message from DUAL;

SELECT '3D City Database upgrade complete!' as message from DUAL;
