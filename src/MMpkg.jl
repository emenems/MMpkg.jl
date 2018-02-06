module MMpkg
	# Load functions defined in separate files
	include("createrepo.jl");
	include("docversion.jl");
	include("inpolygon.jl");
	include("geotools.jl");
	include("meteotools.jl");
	# Export selected functions
	export createrepo, docversion # createrepo + docversion
	export inpolygon # inpolygon
	export lonlat2psi, elip2xyz, elip2sphere, replacesphere, decimal2deg, deg2decimal # geotools
	export meteo2density, geopot2height, satwatpres, sh2rh, dew2rh, dew2sh, rh2dew, rh2abs # meteotools
end
