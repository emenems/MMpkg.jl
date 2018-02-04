module MMpkg
	# Load functions defined in separate files
	include("createrepo.jl");
	include("docversion.jl");
	include("inpolygon.jl");
	include("meshgrid.jl");
	include("geotools.jl");
	include("meteotools.jl");
	# Export selected functions
	export createrepo, docversion # createrepo + docversion
	export inpolygon # inpolygon
	export meshgrid, mesh2vec # meshgrid
	export lonlat2psi, elip2xyz, elip2sphere, replacesphere # geotools
	export meteo2density, geopot2height, satwatpres, sh2rh, dew2rh, dew2sh, rh2dew, rh2abs # meteotools
end
