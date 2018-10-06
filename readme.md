MMpkg
========
[![Build Status](https://travis-ci.org/emenems/MMpkg.jl.svg?branch=master)](https://travis-ci.org/emenems/MMpkg.jl)
[![codecov](https://codecov.io/gh/emenems/MMpkg.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/emenems/MMpkg.jl)
[![Coverage Status](https://coveralls.io/repos/github/emenems/MMpkg.jl/badge.svg?branch=master)](https://coveralls.io/github/emenems/MMpkg.jl?branch=master)

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
* `sub2df`: convert SubDataFrame to DataFrame

## Usage
* Check the function help for instructions and example usage, e.g., `?elip2xyz`

> Check the `REQUIRE` file for dependencies
