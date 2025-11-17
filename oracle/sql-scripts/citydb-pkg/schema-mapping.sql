/*****************************************************************
 * CONTENT: PL/SQL Package CITYDB_SCHEMA
 *
 * Methods for working with the 3DCityDB schema mapping
 *****************************************************************/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_schema
AS
  FUNCTION get_child_objectclass_ids (p_class_id IN INTEGER, p_skip_abstract IN INTEGER DEFAULT 0) RETURN number_tab;
  FUNCTION get_child_objectclass_ids (p_class_id IN INTEGER, p_schema_name IN VARCHAR2, p_skip_abstract IN INTEGER DEFAULT 0) RETURN number_tab;
END citydb_schema;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_schema
AS

  /*****************************************************************
  * Function GET_CHILD_OBJECTCLASS_IDS
  *
  * Parameters:
  *   - p_class_id => ID of the parent object class
  *   - p_skip_abstract => Set to 1 if abstract classes shall be skipped, 0 if not
  *
  * Return value:
  *   - number_tab => The IDs of all transitive subclasses of the given object class
  ******************************************************************/
  FUNCTION get_child_objectclass_ids (
    p_class_id IN INTEGER,
    p_skip_abstract IN INTEGER DEFAULT 0
  )
  RETURN number_tab
  IS
    v_condition VARCHAR2(50) := '';
    v_ids number_tab;
  BEGIN
    IF p_skip_abstract <> 0 THEN
      v_condition := 'AND h.is_abstract <> 1';
    END IF;

    EXECUTE IMMEDIATE
      'WITH class_hierarchy (id, is_abstract) AS (
         SELECT o.id, o.is_abstract
         FROM objectclass o
         WHERE o.id = :1
         UNION ALL
         SELECT p.id, p.is_abstract
         FROM objectclass p
         INNER JOIN class_hierarchy h ON h.id = p.superclass_id
       )
       SELECT h.id
       FROM class_hierarchy h
       WHERE h.id <> :2 ' || v_condition
    BULK COLLECT INTO v_ids
    USING p_class_id, p_class_id;

    RETURN v_ids;
  END get_child_objectclass_ids;

  /*****************************************************************
  * Function GET_CHILD_OBJECTCLASS_IDS
  *
  * Parameters:
  *   - p_class_id => ID of the parent object class
  *   - p_schema_name => Name of the target schema
  *   - p_skip_abstract => Set to 1 if abstract classes shall be skipped, 0 if not
  *
  * Return value:
  *   - number_tab => The IDs of all transitive subclasses of the given object class
  ******************************************************************/
  FUNCTION get_child_objectclass_ids (
    p_class_id IN INTEGER,
    p_schema_name IN VARCHAR2,
    p_skip_abstract IN INTEGER DEFAULT 0
  )
  RETURN number_tab
  IS
    v_schema_name VARCHAR2(128);
    v_ids number_tab;
  BEGIN
    v_schema_name := DBMS_ASSERT.simple_sql_name(p_schema_name);

    EXECUTE IMMEDIATE
      'SELECT * FROM TABLE(' || v_schema_name || '.citydb_schema.get_child_objectclass_ids(:1, :2))'
    BULK COLLECT INTO v_ids
    USING p_class_id, p_skip_abstract;

    RETURN v_ids;
  END get_child_objectclass_ids;

END citydb_schema;
/