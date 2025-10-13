-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: Okt 6, 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

-- Required to insert large JSON values
CREATE OR REPLACE PROCEDURE map_objectclass_schema(
  p_objectclass_id IN NUMBER,
  p_schema         IN CLOB
)
IS
BEGIN
  UPDATE objectclass
  SET schema = p_schema
  WHERE id = p_objectclass_id;
END;
/

CREATE OR REPLACE PROCEDURE map_datatype_schema(
  p_datatype_id    IN NUMBER,
  p_schema         IN CLOB
)
IS
BEGIN
  UPDATE datatype
  SET schema = p_schema
  WHERE id = p_datatype_id;
END;
/
