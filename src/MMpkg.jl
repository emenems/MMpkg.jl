module MMpkg
	# Load functions defined in separate files
	include("createrepo.jl");
	include("docversion.jl");
	include("inpolygon.jl");
	# Export selected functions
	export createrepo, docversion, inpolygon
end