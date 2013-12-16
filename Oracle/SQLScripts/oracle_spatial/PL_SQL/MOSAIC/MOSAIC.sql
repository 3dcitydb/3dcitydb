-- /////////////////////////////////////////////////////////////////////////////
-- //
-- // Stored procedures written in PL/SQL for raster data management
-- // 
-- // Authors: Prof. Dr. Thomas H. Kolbe, Dr. Andreas Poth
-- //
-- // Last Update: 2007-12-09


-- // Set_Orthophoto_SRID - Stored procedure for setting the SRID
-- // of the imported orthophoto tiles to the database predefined CRS.
-- // This procedure must be called after importing raster tiles
-- // using the import / export tool from lat/lon, because it leaves
-- // the SRID of the imported raster tiles empty.

CREATE OR REPLACE  PROCEDURE SET_ORTHOPHOTO_SRID  IS
	geor          sdo_georaster;
	orthophoto_id ORTHOPHOTO_IMP.ID%TYPE;
	srs_id        DATABASE_SRS.SRID%TYPE;

CURSOR c_orthophoto_imp IS  /* select all imported orthophoto tiles */
   SELECT id, orthophotoproperty FROM ORTHOPHOTO_IMP FOR UPDATE;

BEGIN

-- // Fetch SRID for this database 
SELECT srid INTO srs_id FROM DATABASE_SRS;

OPEN c_orthophoto_imp;
   LOOP
      FETCH c_orthophoto_imp INTO orthophoto_id, geor;
      exit when c_orthophoto_imp%NOTFOUND;

    	sdo_geor.setModelSRID(geor, srs_id);
    	UPDATE ORTHOPHOTO_IMP SET orthophotoproperty=geor
    	WHERE CURRENT OF c_orthophoto_imp;
   END LOOP;
CLOSE c_orthophoto_imp;

END set_Orthophoto_SRID;
/


-- // Set_Raster_Relief_SRID - Stored procedure for setting the SRID
-- // of the imported RasterRelief tiles to the database predefined CRS.
-- // This procedure must be called after importing raster tiles
-- // using the import / export tool from lat/lon, because it leaves
-- // the SRID of the imported raster tiles empty.

CREATE OR REPLACE  PROCEDURE SET_RASTER_RELIEF_SRID  IS
	geor          sdo_georaster;
	raster_relief_id RASTER_RELIEF_IMP.ID%TYPE;
	srs_id        DATABASE_SRS.SRID%TYPE;

CURSOR c_raster_relief_imp IS  /* select all imported raster_relief tiles */
   SELECT id, rasterproperty FROM RASTER_RELIEF_IMP FOR UPDATE;

BEGIN

-- // Fetch SRID for this database 
SELECT srid INTO srs_id FROM DATABASE_SRS;

OPEN c_raster_relief_imp;
   LOOP
      FETCH c_raster_relief_imp INTO raster_relief_id, geor;
      exit when c_raster_relief_imp%NOTFOUND;

    	sdo_geor.setModelSRID(geor, srs_id);
    	UPDATE RASTER_RELIEF_IMP SET rasterproperty=geor
    	WHERE CURRENT OF c_raster_relief_imp;
   END LOOP;
CLOSE c_raster_relief_imp;

END set_Raster_Relief_SRID;
/


-- // mosaicOrthophotosInitial - Stored procedure which
-- // calls the mosaic function of Oracle GeoRaster for gathering 
-- // orthophoto tiles within one large raster data object for a given LOD.
-- // The big georaster is stored in the table ORTHOPHOTO with
-- // a new ID that is generated using CITYOBJECT_SEQ. This ID
-- // is printed to stdout. In order to see the ID value, database
-- // output has to be activated in SQL*Plus before calling the 
-- // procedure by the following command:
-- // SET SERVEROUTPUT on
-- //
-- // PARAMETERS:
-- //   nameVal = name of the orthophoto
-- //   typeVal = type description of the orhtophoto
-- //   lineageVal = lineage (sensor, source) of the orthophoto
-- //   LoDVal = LoD of the Orthophoto
-- // Example:
-- //   Execute mosaicOrthophotosInitial('Orthophoto1','True Orthophoto 0.2m','HRSC camera flight',2); 

CREATE OR REPLACE PROCEDURE mosaicOrthophotosInitial ( 
	nameVal VARCHAR2, typeVal VARCHAR2, lineageVal IN VARCHAR2, 
	LoDVal IN NUMBER ) 
AS
	gr            sdo_georaster;
	geor          sdo_georaster;
	fprnt         sdo_geometry;
	orthophoto_id CITYOBJECT.ID%TYPE;
	srs_id        DATABASE_SRS.SRID%TYPE;
        tabname       VARCHAR2(50);

BEGIN
	-- // Fetch SRID for this database 
	SELECT srid INTO srs_id FROM DATABASE_SRS;
	
	-- // Generate new ID value for the new Orthophoto-CITYOBJECT 
	SELECT CITYOBJECT_SEQ.nextval INTO orthophoto_id FROM DUAL;
  
	-- // Use dummy footprint because real envelope is not known before 
	-- // calling mosaic. 
	fprnt := mdsys.sdo_geometry (3003, srs_id, null, 
	                             mdsys.sdo_elem_info_array (1,1003,3),
	                             mdsys.sdo_ordinate_array ( 0, 0, 0, 1, 1, 1 ) );

	-- // ***** To do: GMLID and GMLID_CODESPACE should be set to sensible values
	INSERT INTO CITYOBJECT ( ID, CLASS_ID, ENVELOPE, CREATION_DATE, LINEAGE ) 
	       VALUES ( orthophoto_id, 20, fprnt, SYSDATE, lineageVal );

	-- // set the modelSRID of all raster tiles
	SET_ORTHOPHOTO_SRID;
	-- // create big raster object by mosaicking the image tiles
	DBMS_OUTPUT.PUT_LINE('Mosaicking image tiles... ');

	-- // get owner of table scheme
        SELECT USER INTO tabname FROM dual;
        tabname := tabname||'.ORTHOPHOTO_RDT';
        gr := sdo_geor.init( tabname );

	sdo_geor.mosaic( 'ORTHOPHOTO_IMP', 'ORTHOPHOTOPROPERTY', gr, null );
	-- // set the CRS of the big raster
	sdo_geor.setModelSRID(gr, srs_id);
	-- // insert big raster into table ORTHOPHOTO
	INSERT INTO ORTHOPHOTO ( id, ORTHOPHOTOPROPERTY, NAME, TYPE, DATUM, LOD ) 
	       VALUES ( orthophoto_id, gr, nameVal, typeVal, SYSDATE, LoDVal );

	-- // update footprint
	SELECT sdo_geor.generateSpatialExtent(ORTHOPHOTOPROPERTY) into fprnt 
	       FROM ORTHOPHOTO 
	       WHERE id = orthophoto_id for update;
	-- // ***** Problem: footprint is 2D, but must be 3D for CITYOBJECT
	-- UPDATE CITYOBJECT set ENVELOPE = fprnt where ID = orthophoto_id;

	-- // create pyramid
	SELECT ORTHOPHOTOPROPERTY INTO geor from ORTHOPHOTO 
	       where id = orthophoto_id for update;

	-- // params can be rLevel=XXX and resampling=NN | BILINEAR | AVERAGE4 | 
	-- //                                         AVERAGE16 | CUBIC
	-- // e.g. 'rLevel=4, resampling=BILINEAR'
	DBMS_OUTPUT.PUT_LINE('Generating image pyramid... ');
	sdo_geor.generatePyramid( geor, 'resampling=CUBIC');
	update ORTHOPHOTO set ORTHOPHOTOPROPERTY = geor where id = orthophoto_id;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('New Orthophoto-Cityobject generated with ID '|| 
	                     orthophoto_id);
END mosaicOrthophotosInitial;
/


-- // mosaicOrthophotosUpdate - Stored procedure for updating
-- // an existing Orthophoto. This is useful if some image tiles
-- // in ORTHOPHOTO_IMP have been replaced by updated versions.
-- // The procedure calls the mosaic function for gathering 
-- // orthophoto tiles within one large raster data object 
-- // which then replaces the former GeoRaster of the given
-- // Orthophoto.
-- //
-- // PARAMETERS:
-- //   idVal = ID of the Orthophoto
-- //   reason = reason for the update
-- //   updatingPerson = person who initiates this update
-- // Example:
-- //   Execute mosaicOrthophotosUpdate(8197,'Update of some tiles','Mr Smith'); 

CREATE OR REPLACE PROCEDURE mosaicOrthophotosUpdate( 
	idVal IN NUMBER, reason IN VARCHAR2, updatingPerson IN VARCHAR2 ) 
AS
	gr 	sdo_georaster;
	geor 	sdo_georaster;
	fprnt 	sdo_geometry;
	srs_id	DATABASE_SRS.SRID%TYPE;
        tabname VARCHAR2(50);
	
BEGIN	
	-- // Fetch SRID for this database 
	SELECT srid INTO srs_id FROM DATABASE_SRS;
	
	delete from ORTHOPHOTO_RDT where RASTERID = idVal;

	-- // set the modelSRID of all raster tiles
	SET_ORTHOPHOTO_SRID;
	-- // create big raster object by mosaicking the image tiles
	DBMS_OUTPUT.PUT_LINE('Mosaicking image tiles... ');

	-- // get owner of table scheme
        SELECT USER INTO tabname FROM dual;
        tabname := tabname||'.ORTHOPHOTO_RDT';
        gr := sdo_geor.init( tabname );

	sdo_geor.mosaic( 'ORTHOPHOTO_IMP', 'ORTHOPHOTOPROPERTY', gr, null );
	-- // set the CRS of the big raster 
	sdo_geor.setModelSRID(gr, srs_id);
	-- // update big raster in table ORTHOPHOTO
	UPDATE ORTHOPHOTO set ORTHOPHOTOPROPERTY = gr 
	       where id = idVAL;
	
	-- // update footprint
	SELECT sdo_geor.generateSpatialExtent(ORTHOPHOTOPROPERTY) into fprnt 
	       FROM ORTHOPHOTO WHERE id = idVal for update;
	
	update CITYOBJECT set ENVELOPE = fprnt, LAST_MODIFICATION_DATE = SYSDATE, 
	       UPDATING_PERSON = updatingPerson, REASON_FOR_UPDATE = reason;
	
	-- // create pyramid
	SELECT ORTHOPHOTOPROPERTY INTO geor from ORTHOPHOTO 
	       where id = idVal for update;
	
	-- // params can be rLevel=XXX and resampling=NN | BILINEAR | AVERAGE4 |
	-- //                                         AVERAGE16 | CUBIC
	-- // e.g. 'rLevel=4, resampling=BILINEAR'
	DBMS_OUTPUT.PUT_LINE('Generating image pyramid... ');
	sdo_geor.generatePyramid( geor, 'resampling=CUBIC');	
	update ORTHOPHOTO set ORTHOPHOTOPROPERTY = geor where id = idVal;
	
	COMMIT;
END mosaicOrthophotosUpdate;
/


-- // mosaicRasterReliefInitial - Stored procedure which
-- // calls the mosaic function of Oracle GeoRaster for gathering 
-- // RasterRelief tiles within one large raster data object for a 
-- // given LOD. The big georaster is stored in the table RASTER_RELIEF 
-- // with a new ID that is generated using CITYOBJECT_SEQ. 
-- // Furthermore, a new RELIEF tuple with a new ID from
-- // CITYOBJECT_SEQ is generated of which the new RasterRelief 
-- // becomes the only member. Both IDs are printed to stdout. 
-- // In order to see the ID values, database output has to be 
-- // activated in SQL*Plus before calling the procedure by the 
-- // following command:
-- // SET SERVEROUTPUT on
-- //
-- // PARAMETERS:
-- //   gmlIdRelief = gml:id of the ReliefFeature feature
-- //   gmlIdRaster = gml:id of the Raster feature
-- //	gmlIdCodespace = Codespace for the gml:id values
-- //   nameVal = name of the orthophoto
-- //   descVal = description of the orthophoto
-- //   lineageVal = lineage (sensor, source) of the orthophoto
-- //   LoDVal = LoD of the Orthophoto
-- // Example:
-- //   Execute mosaicRasterReliefInitial('UUID_2000abcd','UUID_2000abce','UUID',
-- //                'DTM of Berlin','0.5m Raster','Photogrammetric Processing',2); 

CREATE OR REPLACE PROCEDURE mosaicRasterReliefInitial ( 
	gmlIdRelief VARCHAR2, gmlIdRaster VARCHAR2, gmlIdCodespace VARCHAR2,
	nameVal VARCHAR2, descVal VARCHAR2, lineageVal IN VARCHAR2, 
	LoDVal IN NUMBER ) 
AS
	gr               sdo_georaster;
	geor             sdo_georaster;
	fprnt            sdo_geometry;
	relief_id        CITYOBJECT.ID%TYPE;
	relief_component_id CITYOBJECT.ID%TYPE;
	srs_id		 DATABASE_SRS.SRID%TYPE;
        tabname          VARCHAR2(50);
	
BEGIN
	-- // Fetch SRID for this database 
	SELECT srid INTO srs_id FROM DATABASE_SRS;
	
	-- // generate new ID values for the two new CITYOBJECTs (RASTER_RELIEF 
	-- // and RELIEF)
	SELECT CITYOBJECT_SEQ.nextval INTO relief_component_id FROM DUAL;
	SELECT CITYOBJECT_SEQ.nextval INTO relief_id FROM DUAL;
  
	-- // use dummy because real envelope is not known before calling mosaic
	fprnt := mdsys.sdo_geometry (3003, srs_id, null, 
	                             mdsys.sdo_elem_info_array (1,1003,3),
	                             mdsys.sdo_ordinate_array ( 0, 0, 0, 1, 1, 1 ) );

	-- // create ReliefFeature object
	INSERT INTO CITYOBJECT ( ID, GMLID, GMLID_CODESPACE, CLASS_ID, ENVELOPE, 
				 CREATION_DATE, LINEAGE ) 
	       VALUES ( relief_id, gmlIdRelief, gmlIdCodespace, 14, fprnt, SYSDATE, lineageVal );
	INSERT INTO RELIEF_FEATURE ( ID, NAME, DESCRIPTION, LOD ) 
	       VALUES ( relief_id, nameVal, descVal, LoDVal);

	-- // create RASTER object
	INSERT INTO CITYOBJECT ( ID, GMLID, GMLID_CODESPACE, CLASS_ID, ENVELOPE, 
				 CREATION_DATE, LINEAGE ) 
	       VALUES ( relief_component_id, gmlIdRaster, gmlIdCodespace, 19, fprnt, 
	       		SYSDATE, lineageVal );
	INSERT INTO RELIEF_COMPONENT ( ID, NAME, DESCRIPTION, LOD ) 
	       VALUES ( relief_component_id, nameVal, descVal, LoDVal );

	-- // set the modelSRID of all raster tiles
	SET_RASTER_RELIEF_SRID;
	-- // create big raster object by mosaicking the image tiles
	DBMS_OUTPUT.PUT_LINE('Mosaicking DTM tiles...');

	-- // get owner of table scheme
        SELECT USER INTO tabname FROM dual;
        tabname := tabname||'.RASTER_RELIEF_RDT';
        gr := sdo_geor.init( tabname );

	sdo_geor.mosaic( 'RASTER_RELIEF_IMP', 'RASTERPROPERTY', gr, null );
	-- // set the CRS of the big raster 
	sdo_geor.setModelSRID(gr,srs_id);
	-- // insert big raster into table RASTER_RELIEF
	INSERT INTO RASTER_RELIEF ( ID, RASTERPROPERTY ) 
	       VALUES ( relief_component_id, gr );

	-- // update footprint
	SELECT sdo_geor.generateSpatialExtent(RASTERPROPERTY) into fprnt 
	       FROM RASTER_RELIEF 
	       WHERE id = relief_component_id for update;

	-- // set correct envelope in all respective tables
	UPDATE RELIEF_COMPONENT set EXTENT = fprnt where ID = relief_component_id;
	-- // ***** Problem: footprint is 2D, but must be 3D for CITYOBJECT
	-- UPDATE CITYOBJECT set ENVELOPE = fprnt where ID = relief_id;
	-- UPDATE CITYOBJECT set ENVELOPE = fprnt where ID = relief_component_id;

	-- // insert association between ReliefFeature and Raster
	INSERT INTO RELIEF_FEAT_TO_REL_COMP ( RELIEF_FEATURE_ID, RELIEF_COMPONENT_ID ) 
	       VALUES ( relief_id, relief_component_id);

	-- // create pyramid
	SELECT RASTERPROPERTY INTO geor from RASTER_RELIEF 
	       WHERE id = relief_component_id FOR UPDATE;

	-- // params can be rLevel=XXX and resampling=NN | BILINEAR | AVERAGE4 | 
	-- //                                         AVERAGE16 | CUBIC
	-- // e.g. 'rLevel=4, resampling=BILINEAR'
	DBMS_OUTPUT.PUT_LINE('Generating raster pyramid...');
	sdo_geor.generatePyramid( geor, 'resampling=CUBIC');
	update RASTER_RELIEF set RASTERPROPERTY = geor where id = relief_component_id;

	-- // update tuples in RASTER_RELIEF_IMP to point to the generated 
	-- // RELIEF and RASTER_RELIEF tuples
	UPDATE RASTER_RELIEF_IMP set RELIEF_ID=relief_id, 
	                             RASTER_RELIEF_ID=relief_component_id;
  
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('New Raster-Cityobject generated with ID '|| 
	                     relief_component_id);
	DBMS_OUTPUT.PUT_LINE('New ReliefFeature-Cityobject generated with ID '|| 
	                     relief_id);
END mosaicRasterReliefInitial;
/


-- // mosaicRasterReliefUpdate - Stored procedure for updating
-- // an existing RasterRelief. This is useful if some raster tiles
-- // in RASTER_RELIEF_IMP have been replaced by updated versions.
-- // The procedure calls the mosaic function for gathering 
-- // raster_relief tiles within one large raster data object 
-- // which then replaces the former GeoRaster of the given
-- // ReliefObject.
-- //
-- // PARAMETERS:
-- //   idVal = ID of the Raster feature
-- //   reason = reason for the update
-- //   updatingPerson = person who initiates this update
-- // Example:
-- //   Execute mosaicRasterReliefUpdate(15233,'Update of some tiles','Mr Smith'); 

CREATE OR REPLACE PROCEDURE mosaicRasterReliefUpdate( 
	idVal IN NUMBER, reason IN VARCHAR2, updatingPerson IN VARCHAR2 ) 
AS
	gr	sdo_georaster;
	geor	sdo_georaster;
	fprnt	sdo_geometry;
	srs_id	DATABASE_SRS.SRID%TYPE;
        tabname VARCHAR2(50);

BEGIN
	-- // Fetch SRID for this database 
	SELECT srid INTO srs_id FROM DATABASE_SRS;
	
	-- // discard the old raster
	-- delete from RASTER_RELIEF_RDT where RASTER_RELIEF_ID = idVal;

	-- // set the modelSRID of all imported raster tiles
	SET_RASTER_RELIEF_SRID;

	-- // get owner of table scheme
        SELECT USER INTO tabname FROM dual;
        tabname := tabname||'.RASTER_RELIEF_RDT';
        gr := sdo_geor.init( tabname );

	DBMS_OUTPUT.PUT_LINE('Mosaicking DTM tiles...');
	sdo_geor.mosaic( 'RASTER_RELIEF_IMP', 'RASTERPROPERTY', gr, null );
	-- // set the CRS of the big raster 
	sdo_geor.setModelSRID(gr,srs_id);
	-- // update big raster in table RASTER_RELIEF
	UPDATE RASTER_RELIEF set RASTERPROPERTY = gr where id = idVAL;
	
	-- // update footprint
	SELECT sdo_geor.generateSpatialExtent(RASTERPROPERTY) into fprnt 
	       FROM RASTER_RELIEF WHERE id = idVal for update;
	
	update CITYOBJECT set ENVELOPE = fprnt, LAST_MODIFICATION_DATE = SYSDATE, 
	       UPDATING_PERSON = updatingPerson, REASON_FOR_UPDATE = reason
	       where id=idVal;
	update CITYOBJECT set ENVELOPE = fprnt, LAST_MODIFICATION_DATE = SYSDATE, 
	       UPDATING_PERSON = updatingPerson, REASON_FOR_UPDATE = reason
	       where id=(select RELIEF_FEATURE_ID from RELIEF_FEAT_TO_REL_COMP
	       		 where RELIEF_COMPONENT_ID=idVal);
	update RELIEF_COMPONENT set EXTENT = fprnt where id=idVal;
	
	-- // create pyramid
	SELECT RASTERPROPERTY INTO geor from RASTER_RELIEF 
	       where id = idVal for update;
	
	-- // params can be rLevel=XXX and resampling=NN | BILINEAR | AVERAGE4 | 
	-- //                                         AVERAGE16 | CUBIC
	-- // e.g. 'rLevel=4, resampling=BILINEAR'
	DBMS_OUTPUT.PUT_LINE('Generating raster pyramid...');
	sdo_geor.generatePyramid( geor, 'resampling=CUBIC');	
	update RASTER_RELIEF set RASTERPROPERTY = geor where id = idVal;
	
	COMMIT;
END mosaicRasterReliefUpdate;
/
