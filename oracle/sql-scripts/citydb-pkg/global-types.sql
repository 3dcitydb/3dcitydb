/*****************************************************************
 * CONTENT: Global type definitions
 *
 * Type definitions used by the PL/SQL packages
 *****************************************************************/

CREATE OR REPLACE TYPE version AS OBJECT (
  version VARCHAR2(100),
  major_version NUMBER(10),
  minor_version NUMBER(10),
  minor_revision NUMBER(10)
);
/

CREATE OR REPLACE TYPE version_tab IS TABLE OF version;
/

CREATE OR REPLACE TYPE db_info AS OBJECT (
  srid NUMBER(38),
  srs_name VARCHAR2(1000),
  coord_ref_sys_name VARCHAR2(255),
  coord_ref_sys_kind VARCHAR2(255),
  wktext VARCHAR2(4000)
);
/

CREATE OR REPLACE TYPE db_info_tab IS TABLE OF db_info;
/

CREATE OR REPLACE TYPE crs_info AS OBJECT (
  coord_ref_sys_name VARCHAR2(255),
  coord_ref_sys_kind VARCHAR2(255),
  wktext VARCHAR2(4000)
);
/

CREATE OR REPLACE TYPE crs_info_tab IS TABLE OF crs_info;
/

CREATE OR REPLACE TYPE number_tab IS TABLE OF NUMBER;
/