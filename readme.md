MMpkg
========
This repository contains various (auxiliary) functions that are not part of other Modules

### Dependency
* No additional or external module is needed

## Functions
#### Use Matlab-like meshgrid
* `meshgrid`: create Matlab-like meshgrid
* `mesh2vec`: convet meshgrid to vector

#### Points indide polygon
* `inpolygon`: find points inside a polygon

#### Simple conversion of ellipsoidal and spherical coordinates
* `elip2xyz`: convert longitude, latitude and height to X,Y,Z (Cartesian) coordinates
* `elip2sphere`: convert longitude, latitude and height on a ellipsoid to spherical coordinates
* `lonlat2psi`: compute spherical distance between points on ellipsoid
* `replacesphere`: compute radius of a replacement sphere (to ellipsoid)

#### Create repository and document used packages
* `createrepo`: initialize a git repository and fill it with default files (module, test, readme, etc.)
* `docversion`: write dependency report to a given file or to command prompt

#### Basic functions used in meteorology
* `meteo2density`: convert meteo parameters to air density
* `rh2abs`: convert relative humidity to absolute
* `rh2dew`: convert relative humidity to dew point
* `dew2sh`: convert dew point to specific humidity
* `dew2rh`: convert dew-point to relative humidity
* `sh2rh`: convert specific humidity to relative humidity
* `satwatpres`: compute saturation water vapor pressure (over water)
* `geopot2height`: convert geopotential to altitude
