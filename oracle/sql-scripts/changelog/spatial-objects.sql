INSERT INTO user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
SELECT
  'FEATURE_CHANGELOG',
  'ENVELOPE',
  diminfo,
  srid
FROM user_sdo_geom_metadata
WHERE table_name = 'FEATURE'
  AND column_name = 'ENVELOPE'
  AND NOT EXISTS (
    SELECT 1
    FROM user_sdo_geom_metadata
    WHERE table_name = 'FEATURE_CHANGELOG'
      AND column_name = 'ENVELOPE'
  );

CREATE INDEX FEATURE_CHANGELOG_ENVELOPE_SPX ON FEATURE_CHANGELOG ( ENVELOPE ) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;