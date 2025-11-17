/*****************************************************************
* get_child_objectclass_ids
*
* @param class_id ID of the parent object class
* @param skip_abstract Set to 1 if abstract classes shall be skipped, 0 if not
* @return The IDs of all transitive subclasses of the given object class
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_child_objectclass_ids(
  class_id INTEGER,
  skip_abstract INTEGER DEFAULT 0) RETURNS SETOF INTEGER AS
$body$
DECLARE
  condition TEXT := '';
BEGIN
  IF skip_abstract <> 0 THEN
    condition = 'AND h.is_abstract <> 1';
  END IF;
  
  RETURN QUERY EXECUTE format('
    WITH RECURSIVE class_hierarchy AS (
      SELECT o.id, o.is_abstract
      FROM objectclass o
      WHERE o.id = %L
      UNION ALL
      SELECT p.id, p.is_abstract
      FROM objectclass p
      INNER JOIN class_hierarchy h ON h.id = p.superclass_id
    )
    SELECT h.id
    FROM class_hierarchy h
    WHERE h.id <> %L ' || condition,
    class_id, class_id);
END;
$body$
LANGUAGE plpgsql STABLE STRICT;

/*****************************************************************
* get_child_objectclass_ids
*
* @param class_id ID of the parent object class
* @param schema_name Name of schema
* @param skip_abstract Set to 1 if abstract classes shall be skipped, 0 if not
* @return The IDs of all transitive subclasses of the given object class
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_child_objectclass_ids(
  class_id INTEGER,
  schema_name TEXT,
  skip_abstract INTEGER DEFAULT 0) RETURNS SETOF INTEGER AS
$body$
BEGIN
  PERFORM citydb_pkg.set_current_schema(schema_name);
  RETURN QUERY
    SELECT citydb_pkg.get_child_objectclass_ids(class_id, skip_abstract);
END;
$body$
LANGUAGE plpgsql STABLE STRICT;