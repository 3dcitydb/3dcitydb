-- CREATE_RO_USER.sql
--
-- Authors:     Javier Herreruela <javier.herreruela@tu-berlin.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012, Institute for Geodesy and Geoinformation Science,
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
-- 2.0.7     2014-10-10   add elements of 3DCityDB v3.0               FKun
-- 2.0.6     2010-06-03   bugfix for execute object rights in 2.0.6   JHer
-- 2.0.3     2010-06-03   release version                             JHer
--                                                                    CNag
--

SET SERVEROUTPUT ON;
-- SET FEEDBACK ON

prompt
prompt
accept RO_USERNAME CHAR PROMPT 'Please enter a username for the read-only user: '
accept SCHEMA_OWNER CHAR PROMPT 'Please enter the owner of the schema to which this user will have read-only access: '
prompt
prompt

DECLARE
 v_schemaOwnerName ALL_USERS.USERNAME%TYPE := null;
 v_readOnlyName ALL_USERS.USERNAME%TYPE := null;
 v_role DBA_ROLES.ROLE%TYPE := null;
 
 RO_USER_ALREADY_EXISTS EXCEPTION;

BEGIN

  IF ('&RO_USERNAME' IS NULL) THEN 
    dbms_output.put_line('Invalid username!');
  END IF;

  IF ('&SCHEMA_OWNER' IS NULL) THEN
    dbms_output.put_line('Invalid schema owner!');
  END IF;

  BEGIN  
    EXECUTE IMMEDIATE 'SELECT username FROM all_users WHERE username = :1' INTO v_schemaOwnerName USING upper('&SCHEMA_OWNER');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Schema owner ' || '&SCHEMA_OWNER' || ' does not exist!');
        RAISE;
  END;

  BEGIN  
    EXECUTE IMMEDIATE 'SELECT username FROM all_users WHERE username = :1' INTO v_readOnlyName USING upper('&RO_USERNAME');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL; -- do nothing, read-only user must not exist
      WHEN OTHERS THEN
        RAISE;
  END;

  IF (v_readOnlyName IS NOT NULL) THEN
    RAISE RO_USER_ALREADY_EXISTS;
  END IF;

  v_readOnlyName := '&RO_USERNAME';
  EXECUTE IMMEDIATE 'CREATE USER ' || v_readOnlyName || ' IDENTIFIED BY berlin3d PASSWORD EXPIRE';

  BEGIN
    EXECUTE IMMEDIATE 'SELECT role FROM dba_roles WHERE role = :1' INTO v_role USING upper('&SCHEMA_OWNER') || '_READ_ONLY';

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_role := upper('&SCHEMA_OWNER') || '_READ_ONLY';
        EXECUTE IMMEDIATE 'CREATE ROLE ' || v_role;

        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.ADDRESS to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.ADDRESS_TO_BRIDGE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.ADDRESS_TO_BUILDING to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.APPEAR_TO_SURFACE_DATA to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.APPEARANCE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BREAKLINE_RELIEF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_CONSTR_ELEMENT to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_FURNITURE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_INSTALLATION to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_OPEN_TO_THEM_SRF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_OPENING to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_ROOM to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BRIDGE_THEMATIC_SURFACE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BUILDING to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BUILDING_FURNITURE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.BUILDING_INSTALLATION to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.CITY_FURNITURE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.CITYMODEL to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.CITYOBJECT to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.CITYOBJECT_GENERICATTRIB to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.CITYOBJECT_MEMBER to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.CITYOBJECTGROUP to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.DATABASE_SRS to ' || v_role;
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.DB_INFO_OBJ to ' || v_role;
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.DB_INFO_TABLE to ' || v_role;
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.DB_VERSION_OBJ to ' || v_role;
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.DB_VERSION_TABLE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.EXTERNAL_REFERENCE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.GENERALIZATION to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.GENERIC_CITYOBJECT to ' || v_role;
--      EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.CITYDB_DELETE to ' || v_role; 
--      EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.CITYDB_DELETE_BY_LINEAGE to ' || v_role;
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.CITYDB_IDX to ' || v_role;
--      EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.CITYDB_SRS to ' || v_role;	 
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.CITYDB_STAT to ' || v_role;
        EXECUTE IMMEDIATE 'grant execute on ' || upper('&SCHEMA_OWNER') || '.CITYDB_UTIL to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.GRID_COVERAGE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.GROUP_TO_CITYOBJECT to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.IMPLICIT_GEOMETRY to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.INDEX_TABLE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.LAND_USE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.MASSPOINT_RELIEF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.OBJECTCLASS to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.OPENING to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.OPENING_TO_THEM_SURFACE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.PLANT_COVER to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.RASTER_RELIEF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.RELIEF_COMPONENT to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.RELIEF_FEATURE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.RELIEF_FEAT_TO_REL_COMP to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.ROOM to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.SOLITARY_VEGETAT_OBJECT to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.SURFACE_DATA to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.SURFACE_GEOMETRY to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TEX_IMAGE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TEXTUREPARAM to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.THEMATIC_SURFACE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TIN_RELIEF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TRAFFIC_AREA to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TRANSPORTATION_COMPLEX to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL_FURNITURE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL_HOLLOW_SPACE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL_INSTALLATION to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL_OPEN_TO_THEM_SRF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL_OPENING to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.TUNNEL_THEMATIC_SURFACE to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.WATERBODY to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.WATERBOD_TO_WATERBND_SRF to ' || v_role;
        EXECUTE IMMEDIATE 'grant select on ' || upper('&SCHEMA_OWNER') || '.WATERBOUNDARY_SURFACE to ' || v_role;

      WHEN OTHERS THEN
        RAISE;
  END;

  -- grant privileges
  EXECUTE IMMEDIATE 'grant ' || v_role || ' to ' || v_readOnlyName;
  EXECUTE IMMEDIATE 'grant CONNECT to ' || v_readOnlyName;
  EXECUTE IMMEDIATE 'grant RESOURCE to ' || v_readOnlyName;

  -- synonyms for tables
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.ADDRESS for ' || v_schemaOwnerName || '.ADDRESS';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.ADDRESS_TO_BRIDGE for ' || v_schemaOwnerName || '.ADDRESS_TO_BRIDGE'; 
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.ADDRESS_TO_BUILDING for ' || v_schemaOwnerName || '.ADDRESS_TO_BUILDING';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.APPEAR_TO_SURFACE_DATA for ' || v_schemaOwnerName || '.APPEAR_TO_SURFACE_DATA';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.APPEARANCE for ' || v_schemaOwnerName || '.APPEARANCE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BREAKLINE_RELIEF for ' || v_schemaOwnerName || '.BREAKLINE_RELIEF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE for ' || v_schemaOwnerName || '.BRIDGE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_CONSTR_ELEMENT for ' || v_schemaOwnerName || '.BRIDGE_CONSTR_ELEMENT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_FURNITURE for ' || v_schemaOwnerName || '.BRIDGE_FURNITURE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_INSTALLATION for ' || v_schemaOwnerName || '.BRIDGE_INSTALLATION';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_OPEN_TO_THEM_SRF for ' || v_schemaOwnerName || '.BRIDGE_OPEN_TO_THEM_SRF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_OPENING for ' || v_schemaOwnerName || '.BRIDGE_OPENING';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_ROOM for ' || v_schemaOwnerName || '.BRIDGE_ROOM';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BRIDGE_THEMATIC_SURFACE for ' || v_schemaOwnerName || '.BRIDGE_THEMATIC_SURFACE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BUILDING for ' || v_schemaOwnerName || '.BUILDING';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BUILDING_FURNITURE for ' || v_schemaOwnerName || '.BUILDING_FURNITURE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.BUILDING_INSTALLATION for ' || v_schemaOwnerName || '.BUILDING_INSTALLATION';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITY_FURNITURE for ' || v_schemaOwnerName || '.CITY_FURNITURE'; 
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYMODEL for ' || v_schemaOwnerName || '.CITYMODEL';  
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYOBJECT for ' || v_schemaOwnerName || '.CITYOBJECT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYOBJECT_GENERICATTRIB for ' || v_schemaOwnerName || '.CITYOBJECT_GENERICATTRIB';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYOBJECT_MEMBER for ' || v_schemaOwnerName || '.CITYOBJECT_MEMBER';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYOBJECTGROUP for ' || v_schemaOwnerName || '.CITYOBJECTGROUP';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.DATABASE_SRS for ' || v_schemaOwnerName || '.DATABASE_SRS';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.EXTERNAL_REFERENCE for ' || v_schemaOwnerName || '.EXTERNAL_REFERENCE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.GENERALIZATION for ' || v_schemaOwnerName || '.GENERALIZATION';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.GENERIC_CITYOBJECT for ' || v_schemaOwnerName || '.GENERIC_CITYOBJECT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.GRID_COVERAGE for ' || v_schemaOwnerName || '.GRID_COVERAGE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.GROUP_TO_CITYOBJECT for ' || v_schemaOwnerName || '.GROUP_TO_CITYOBJECT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.IMPLICIT_GEOMETRY for ' || v_schemaOwnerName || '.IMPLICIT_GEOMETRY';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.INDEX_TABLE for ' || v_schemaOwnerName || '.INDEX_TABLE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.LAND_USE for ' || v_schemaOwnerName || '.LAND_USE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.MASSPOINT_RELIEF for ' || v_schemaOwnerName || '.MASSPOINT_RELIEF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.OBJECTCLASS for ' || v_schemaOwnerName || '.OBJECTCLASS';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.OPENING for ' || v_schemaOwnerName || '.OPENING';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.OPENING_TO_THEM_SURFACE for ' || v_schemaOwnerName || '.OPENING_TO_THEM_SURFACE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.PLANT_COVER for ' || v_schemaOwnerName || '.PLANT_COVER';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.RASTER_RELIEF for ' || v_schemaOwnerName || '.RASTER_RELIEF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.RELIEF_COMPONENT for ' || v_schemaOwnerName || '.RELIEF_COMPONENT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.RELIEF_FEATURE for ' || v_schemaOwnerName || '.RELIEF_FEATURE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.RELIEF_FEAT_TO_REL_COMP for ' || v_schemaOwnerName || '.RELIEF_FEAT_TO_REL_COMP';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.ROOM for ' || v_schemaOwnerName || '.ROOM';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.SOLITARY_VEGETAT_OBJECT for ' || v_schemaOwnerName || '.SOLITARY_VEGETAT_OBJECT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.SURFACE_DATA for ' || v_schemaOwnerName || '.SURFACE_DATA';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.SURFACE_GEOMETRY for ' || v_schemaOwnerName || '.SURFACE_GEOMETRY';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TEX_IMAGE for ' || v_schemaOwnerName || '.TEX_IMAGE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TEXTUREPARAM for ' || v_schemaOwnerName || '.TEXTUREPARAM';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.THEMATIC_SURFACE for ' || v_schemaOwnerName || '.THEMATIC_SURFACE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TIN_RELIEF for ' || v_schemaOwnerName || '.TIN_RELIEF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TRAFFIC_AREA for ' || v_schemaOwnerName || '.TRAFFIC_AREA';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TRANSPORTATION_COMPLEX for ' || v_schemaOwnerName || '.TRANSPORTATION_COMPLEX';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL for ' || v_schemaOwnerName || '.TUNNEL';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL_FURNITURE for ' || v_schemaOwnerName || '.TUNNEL_FURNITURE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL_HOLLOW_SPACE for ' || v_schemaOwnerName || '.TUNNEL_HOLLOW_SPACE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL_INSTALLATION for ' || v_schemaOwnerName || '.TUNNEL_INSTALLATION';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL_OPEN_TO_THEM_SRF for ' || v_schemaOwnerName || '.TUNNEL_OPEN_TO_THEM_SRF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL_OPENING for ' || v_schemaOwnerName || '.TUNNEL_OPENING';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.TUNNEL_THEMATIC_SURFACE for ' || v_schemaOwnerName || '.TUNNEL_THEMATIC_SURFACE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.WATERBOD_TO_WATERBND_SRF for ' || v_schemaOwnerName || '.WATERBOD_TO_WATERBND_SRF';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.WATERBODY for ' || v_schemaOwnerName || '.WATERBODY';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.WATERBOUNDARY_SURFACE for ' || v_schemaOwnerName || '.WATERBOUNDARY_SURFACE';  

-- synonyms for PL/SQL packages
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYDB_DELETE for ' || v_schemaOwnerName || '.CITYDB_DELETE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYDB_DELETE_BY_LINEAGE for ' || v_schemaOwnerName || '.CITYDB_DELETE_BY_LINEAGE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYDB_IDX for ' || v_schemaOwnerName || '.CITYDB_IDX';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYDB_SRS for ' || v_schemaOwnerName || '.CITYDB_SRS';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYDB_STAT for ' || v_schemaOwnerName || '.CITYDB_STAT';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.CITYDB_UTIL for ' || v_schemaOwnerName || '.CITYDB_UTIL';

-- synonyms for user defined object types
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.INDEX_OBJ for ' || v_schemaOwnerName || '.INDEX_OBJ';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.STRARRAY for ' || v_schemaOwnerName || '.STRARRAY';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.DB_VERSION_TABLE for ' || v_schemaOwnerName || '.DB_INFO_TABLE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.DB_VERSION_OBJ for ' || v_schemaOwnerName || '.DB_INFO_OBJ';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.DB_INFO_TABLE for ' || v_schemaOwnerName || '.DB_INFO_TABLE';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.DB_INFO_OBJ for ' || v_schemaOwnerName || '.DB_INFO_OBJ';
  EXECUTE IMMEDIATE 'create or replace synonym ' || v_readOnlyName || '.ID_ARRAY for ' || v_schemaOwnerName || '.ID_ARRAY';

  COMMIT;
  dbms_output.put_line(' ');
  dbms_output.put_line('create_ro_user.sql finished successfully');

  EXCEPTION
    WHEN RO_USER_ALREADY_EXISTS THEN
      dbms_output.put_line(' ');
      dbms_output.put_line('User ' || '&RO_USERNAME' || ' already exists!');
      dbms_output.put_line('create_ro_user.sql finished with errors');
    WHEN OTHERS THEN
      dbms_output.put_line(' ');
      dbms_output.put_line('create_ro_user.sql finished with errors');
END;
/
