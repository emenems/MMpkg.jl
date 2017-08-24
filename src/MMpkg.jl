module MMpkg
	# Load functions defined in separate files
	include("createrepo.jl");
	include("docversion.jl");
	include("inpolygon.jl");
	include("meshgrid.jl");
	# Export selected functions
	export createrepo, docversion, inpolygon, meshgrid, mesh2vec
end
