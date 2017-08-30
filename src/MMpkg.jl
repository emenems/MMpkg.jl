module MMpkg
	# Load functions defined in separate files
	include("createrepo.jl");
	include("docversion.jl");
	include("inpolygon.jl");
	include("meshgrid.jl");
	include("geotools.jl");
	include("meteotools.jl");
	# Export selected functions
	export createrepo, docversion, inpolygon, meshgrid, mesh2vec
	export lonlat2psi, elip2xyz, elip2sphere, replacesphere # geotools
	export meteo2density, humidityConvert, satwatpres, sh2rh, dew2rh, dew2sh, rh2dew, rh2abs # meteotools
end
