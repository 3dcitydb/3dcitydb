3D City Database
================

The 3D City Database is a free 3D geo database to store, represent, and manage virtual 3D city models on top of a
standard spatial relational database. The database model contains semantically rich, hierarchically structured,
multi-scale urban objects facilitating complex GIS modeling and analysis tasks, far beyond visualization.
In 2012, the 3D City Database received the Oracle Spatial Excellence Award for Education and Research.

The schema of the 3D City Database is based on the [OGC City Geography Markup Language (CityGML)](https://www.ogc.org/standard/citygml/),
an international standard for representing and exchanging
virtual 3D city models issued by the [Open Geospatial Consortium (OGC)](https://www.ogc.org/).

The 3D City Database has been realized as PostgreSQL/PostGIS and Oracle database schema,
supporting following key features:

 * Full support for CityGML versions 2.0 and 1.0
 * Complex thematic modelling including support for Application Domain Extensions (ADE)
 * Five different Levels of Detail (LODs)
 * Appearance information (textures and materials)
 * Digital terrain models (DTMs)
 * Representation of generic and prototypical 3D objects
 * Free, also recursive aggregation of geo objects
 * Flexible 3D geometries (Solid, BRep)

The 3D City Database comes as a collection of SQL scripts that allow for creating and dropping database instances.

Who's using the 3D City Database?
---------------------------------

The 3D City Database is in use in real life production systems in many places around the world such as
Berlin, Potsdam, Hamburg, Munich, Frankfurt, Dresden, Rotterdam, Vienna, Helsinki, Singapore, Zurich
and is also being used in a number of research projects.

The companies [Virtual City Systems](https://vc.systems/) and [M.O.S.S.](https://www.moss.de/), who are also
partners in development, use the 3D City Database at the core of their commercial products and services to create,
maintain, visualize, transform, and export virtual 3D city models. Furthermore, the state mapping agencies of the
federal states in Germany store and manage the state-wide collected 3D city models
(including approx. 51 million building models) in CityGML LOD1 and LOD2 using the 3D City Database. 

License
-------
The 3D City Database is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
See the `LICENSE` file for more details.

Note that releases of the software before version 3.3.0 continue to be licensed under [GNU LGPL 3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html).
To request a previous release of the 3D City Database under Apache License 2.0 create a GitHub issue.

Latest release
--------------
The latest stable release of the 3D City Database is 4.4.1.

You can download the latest release as well as previous releases from the
[releases section](https://github.com/3dcitydb/3dcitydb/releases).

System requirements
-------------------
Setting up an instance of the 3D City Database requires an existing installation of a PostgreSQL, Oracle,
or PolarDB database. The following database versions are supported.

* PostgreSQL >= 12 with PostGIS >= 3.0
* Oracle >= 19c
* PolarDB for PostgresSQL >= 1.1 with Ganos >= 4.6

It is recommended that you always install the latest patches, minor releases, and security updates for your
database system. Database versions that have reached end-of-life are no longer supported by the 3D City Database.

Documentation and literature
----------------------------
A complete and comprehensive user manual on the 3D City Database and its tools is available
[online](http://3dcitydb-docs.rtfd.io/).

An Open Access paper on the 3DCityDB has been published in the International Journal on Open Geospatial Data,
Software and Standards 3 (5), 2018: [Z. Yao, C. Nagel, F. Kunde, G. Hudra, P. Willkomm, A. Donaubauer, T. Adolphi, T. H. Kolbe: 3DCityDB - a 3D geodatabase solution for the management, analysis, and visualization of semantic 3D city models based on CityGML](https://doi.org/10.1186/s40965-018-0046-7). Please use this reference when citing the 3DCityDB project.

Database setup
--------------
To create a new database instance of the 3D City Database, simply execute
the `CREATE_DB.bat` batch script under Windows respectively the `CREATE_DB.sh`
shell script under UNIX/Linux/MacOS environments. These scripts are available
for both PostgreSQL and Oracle and can be found in the subfolders "3dcitydb/
postgresql/ShellScripts" and "3dcitydb/oracle/ShellScripts".

The connection details for your database account have to be edited in the
`CONNECTION_DETAILS` script prior to running the `CREATE_DB` script (or any
other shell script provided in these folders).

The shell scripts can usually be executed on double click. For some UNIX/Linux
distributions, you will have to run the script from within a shell environment.
Please open your favorite shell and first check whether execution rights are
correctly set for the script.

To make the script executable for the owner of the file, enter the following:

    chmod u+x CREATE_DB.sh

Afterwards, simply run the script by the following command:

    ./CREATE_DB.sh

The setup procedure requires the following mandatory user inputs:
1) Spatial Reference System ID (SRID) to be used for all geometry objects,
2) EPSG code of the height system (optional),
3) String encoding of the SRS used for the gml:srsName attribute in CityGML exports.

For Oracle, one additional input is required:

4) Decision whether the database instance should be versioning enabled.

Afterwards, the script will start the setup procedure and invoke additional
SQL scripts in the background. Please refer to the [user manual](http://3dcitydb-docs.rtfd.io/)
of the 3D City Database for a comprehensive step-by-step guide.

Database deletion
-----------------
To drop an existing database instance of the 3D City Database, simply execute
the shell script `DROP_DB` for your database (PostgreSQL or Oracle) and
operating system. Make sure that you have entered the correct connection
details in the script `CONNECTION_DETAILS` beforehand.

Using with Docker
-----------------

The 3D City Database is also available as Docker image. You can either build an image for PostgreSQL or Oracle
yourself using one of the provided Docker files or use a pre-built PostgreSQL image from Docker Hub at
https://hub.docker.com/r/3dcitydb/3dcitydb-pg.

A comprehensive documentation on how to use the 3D City Database with Docker can be found in the
[online user manual](http://3dcitydb-docs.rtfd.io/).

Contributing
------------
* To file bugs found in the software create a GitHub issue.
* To contribute code for fixing filed issues create a pull request with the issue id.
* To propose a new feature create a GitHub issue and open a discussion.

Cooperation partners and supporters
-----------------------------------
The 3D City Database has been developed by and with the support from the following cooperation partners:

* [Chair of Geoinformatics, Technical University of Munich](https://www.lrg.tum.de/gis/)
* [Virtual City Systems, Berlin](https://vc.systems/)
* [M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen](http://www.moss.de/)

More information
----------------
[OGC CityGML](https://www.ogc.org/standard/citygml/) is an open data model and XML-based format for the
storage and exchange of semantic 3D city models. It is an application schema for the
[Geography Markup Language version 3.1.1 (GML3)](https://www.ogc.org/standard/gml/), the extensible
international standard for spatial data exchange issued by the Open Geospatial Consortium (OGC) and the ISO TC211.
The aim of the development of CityGML is to reach a common definition of the basic entities, attributes,
and relations of a 3D city model.

CityGML is an international OGC standard and can be used free of charge.