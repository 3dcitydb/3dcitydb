3D City Database
================
The 3D City Database is a free 3D geo database to store, represent, and manage virtual 3D city models on top of a standard spatial relational database. The database model contains semantically rich, hierarchically structured, multi-scale urban objects facilitating complex GIS modeling and analysis tasks, far beyond visualization. In 2012, the 3D City Database received the Oracle Spatial Excellence Award for Education and Research.

The schema of the 3D City Database is based on the [OGC City Geography Markup Language (CityGML)](http://www.opengeospatial.org/standards/citygml), an international standard for representing and exchanging virtual 3D city models issued by the [Open Geospatial Consortium (OGC)](http://www.opengeospatial.org/).

The 3D City Database has been realized as Oracle Spatial/Locator and
PostgreSQL/PostGIS database schema, supporting following key features:

 * Full support for CityGML versions 2.0.0 and 1.0.0
 * Complex thematic modelling
 * Five different Levels of Detail (LODs)
 * Appearance information (textures and materials)
 * Digital terrain models (DTMs)
 * Representation of generic and prototypical 3D objects
 * Free, also recursive aggregation of geo objects
 * Flexible 3D geometries

The 3D City Database comes as a collection of SQL scripts that allow for creating and dropping database instances.

Who's using the 3D City Database?
---------------------------------

The 3D City Database is in use in real life production systems in many places around the world such as Berlin, Potsdam, Hamburg, Munich, Frankfurt, Dresden, Rotterdam, Vienna, Helsinki, Singapore, Zurich and is also being used in a number of research projects. The companies [virtualcitySYSTEMS](http://www.virtualcitysystems.de/) and [M.O.S.S.](https://www.moss.de/), who are also partners in development, use the 3D City Database at the core of their commercial products and services to create, maintain, visualize, transform, and export virtual 3D city models. Furthermore, the state mapping agencies of the federal states in Germany store and manage the state-wide collected 3D building models (approx. 51 million building models) in CityGML LOD1 and LOD2 using the 3D City Database. 

License
-------
The 3D City Database is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE` file for more details.

Note that releases of the software before version 3.3.0 continue to be licensed under GNU LGPL 3.0. To request a previous release of the 3D City Database under Apache License 2.0 create a GitHub issue.

Latest release
--------------
The latest stable release of the 3D City Database is 3.3.1.

Download the SQL scripts and documentation [here](https://github.com/3dcitydb/3dcitydb/releases/download/v3.3.1/3DCityDB-3.3.1.zip). Previous releases are available from the [releases section](https://github.com/3dcitydb/3dcitydb/releases).

System requirements
-------------------
* Oracle DBMS >= 10g R2 with Spatial or Locator option
* PostgreSQL DBMS >= 9.1 with PostGIS extension >= 2.0

Documentation
-------------
A complete and comprehensive documentation on the 3D City Database and its tools is available with the software and [online](http://www.3dcitydb.org/3dcitydb/documentation/).

Contributing
------------
* To file bugs found in the software create a GitHub issue.
* To contribute code for fixing filed issues create a pull request with the issue id.
* To propose a new feature create a GitHub issue and open a discussion.

Cooperation partners and supporters  
-----------------------------------

The 3D City Database has been developed by and with the support from the following cooperation partners:

* [Chair of Geoinformatics, Technical University of Munich](https://www.gis.bgu.tum.de/)
* [virtualcitySYSTEMS GmbH, Berlin](http://www.virtualcitysystems.de/)
* [M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen](http://www.moss.de/)

More information
----------------
[OGC CityGML](http://www.opengeospatial.org/standards/citygml) is an open data model and XML-based format for the storage and exchange of semantic 3D city models. It is an application schema for the [Geography Markup Language version 3.1.1 (GML3)](http://www.opengeospatial.org/standards/gml), the extendible international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211. The aim of the development of CityGML is to reach a common definition of the basic entities, attributes, and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.
