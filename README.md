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

License
-------
The 3D City Database is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the `LICENSE` file for more details.

Note that releases of the software before version 3.3.0 continue to be licensed under GNU LGPL 3.0. To request a previous release of the 3D City Database under Apache License 2.0 create a GitHub issue.

Latest release
--------------
The latest stable release of the 3D City Database is 3.2.0.

Download the SQL scripts and documentation [here](https://github.com/3dcitydb/3dcitydb/archive/v3.2.0.zip). Previous releases are available from the [releases section](https://github.com/3dcitydb/3dcitydb/releases).
