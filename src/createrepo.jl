"""
	createrepo(name,path,args...)

Create (module) repository/folder and fill it with default files   

**Input**
* name: repository name (string without .jl extension)
* path: (optional) destination folder. path+name, or current working directory+name folder will be created
* args: optional further functions to be created inside the `src` folder (string without file extension)

**Example**

```
createrepo("NewModule","f:/mikolaj/code/libraries/julia")

createrepo("NewModule","f:/mikolaj/code/libraries/julia","firstfce","secondfce")
```

"""
function createrepo(name::String,path::String="",args...)
	# Create folders
	repofolder = isempty(path) ? pwd()*"/"*name*".jl" : path*"/"*name*".jl";
	mkdir(repofolder)
	mkdir(repofolder*"/src")
	mkdir(repofolder*"/test")
	# Create main files
	open(repofolder*"/src/"*name*".jl","w") do fid
		@printf(fid,"module %s\n\nend",name);
	end
	# Create (optional) function files
	for i in args
		open(repofolder*"/src/"*i*".jl","w") do fid
			@printf(fid,"function %s()\n\nend",i);
		end
	end
	# Create test file
	open(repofolder*"/test/runtests.jl","w") do fid
		@printf(fid,"using %s\nusing Base.test\n",name);
	end
end
