CREATE OR REPLACE TRIGGER log_feature_deletes
BEFORE DELETE ON feature
FOR EACH ROW
DECLARE
  v_is_toplevel OBJECTCLASS.IS_TOPLEVEL%TYPE;
BEGIN
  SELECT is_toplevel
  INTO v_is_toplevel
  FROM objectclass
  WHERE id = :OLD.objectclass_id;

  IF v_is_toplevel = 1 THEN
    UPDATE feature_changelog
    SET feature_id = NULL
    WHERE feature_id = :OLD.id;

    INSERT INTO feature_changelog (
      feature_id, objectclass_id, objectid, identifier, identifier_codespace,
      envelope, transaction_type, transaction_date, db_user, reason_for_update
    ) VALUES (
      NULL, :OLD.objectclass_id, :OLD.objectid, :OLD.identifier, :OLD.identifier_codespace,
      :OLD.envelope, 'DELETE', CURRENT_TIMESTAMP, USER, NULL
    );
  END IF;
END log_feature_deletes;
/

CREATE OR REPLACE TRIGGER log_feature_upserts
AFTER INSERT OR UPDATE ON feature
FOR EACH ROW
DECLARE
  v_is_toplevel OBJECTCLASS.IS_TOPLEVEL%TYPE;
  transaction_type VARCHAR2(50);
BEGIN
  IF UPDATING AND NVL(:OLD.last_modification_date, TO_DATE('1900-01-01','YYYY-MM-DD')) = NVL(:NEW.last_modification_date, TO_DATE('1900-01-01','YYYY-MM-DD')) THEN
    RETURN;
  END IF;

  SELECT is_toplevel
  INTO v_is_toplevel
  FROM objectclass
  WHERE id = :NEW.objectclass_id;

  IF v_is_toplevel = 1 THEN
    IF INSERTING THEN
      transaction_type := 'INSERT';
    ELSIF UPDATING THEN
      IF :NEW.termination_date IS NOT NULL THEN
        transaction_type := 'TERMINATE';
      ELSE
        transaction_type := 'UPDATE';
      END IF;
    END IF;

    INSERT INTO feature_changelog (
      feature_id, objectclass_id, objectid, identifier, identifier_codespace,
      envelope, transaction_type, transaction_date, db_user, reason_for_update
    ) VALUES (
      :NEW.id, :NEW.objectclass_id, :NEW.objectid, :NEW.identifier, :NEW.identifier_codespace,
      :NEW.envelope, transaction_type, CURRENT_TIMESTAMP, USER, :NEW.reason_for_update
    );
  END IF;
END log_feature_upserts;
/