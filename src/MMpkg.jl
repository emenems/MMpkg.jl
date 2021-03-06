module MMpkg
	using PyPlot
	using DataFrames
	using RCall
	using Dates
	using Statistics
	using Printf
	import FFTW
	import Pkg
	import InteractiveUtils
	# Load functions defined in separate files
	include("geotools.jl");
	include("meteotools.jl");
	include("variousfces.jl");
	include("datatest.jl");
	include("wunderground.jl");
	include("plotdata.jl");
	include("spectralanalysis.jl");
	include("rfces.jl");

	# Constants: geodetic
	const a_elip = 6378137.; # WGS84 ellipsoid major axis (m)
	const b_elip = 6356752.314245; # WGS84 ellipsoid minor axis (m)

	# Export selected functions
	export lonlat2psi, elip2xyz, elip2sphere, replacesphere, decimal2deg, deg2decimal # geotools
	export meteo2density, geopot2height, satwatpres, sh2rh, dew2rh, dew2sh, rh2dew, rh2abs # meteotools
	export cut2equal
	export homogendatatest
	export getWUdata
	export plotyy
	export spectralAnalysis
	export Polyg, shpRpolygon
	export sub2df
end
