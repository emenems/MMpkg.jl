MMpkg
========
This repository contains various (auxiliary) functions that are not part of other Modules

### Dependency
* some functions require DataFrames (>=0.11.0), PyPlot and RCall packages
* In addition, R/raster library is required in `rfces.jl`

## Functions

#### Simple conversion of ellipsoidal and spherical coordinates
* `elip2xyz`: convert longitude, latitude and height to X,Y,Z (Cartesian) coordinates
* `elip2sphere`: convert longitude, latitude and height on a ellipsoid to spherical coordinates
* `lonlat2psi`: compute spherical distance between points on ellipsoid
* `replacesphere`: compute radius of a replacement sphere (to ellipsoid)
* `deg2decimal`: convert degrees, minutes and seconds to decimal degrees
* `decimal2deg`: convert decimal degrees to degrees, minutes and seconds

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

#### Plot
* `plotyy`: plot data with 2 Y axes (comparable to Matlab [plotyy](https://www.mathworks.com/help/matlab/ref/plotyy.html) function)

#### Function exploiting R libraries
* `shpRpolygon`: read SHP polygon exploiting R/raster/shapefile function 

#### Various/other functions
* `cut2equal`: cut two pairs of x & y vectors to equal x vector
* `homogendatatest`: test two input vectors for homogeneity
* `getWUdata`: download [WUnderground](wunderground.com/history/) historical weather data
* `spectralAnalysis`: carry out simple spectral analysis
