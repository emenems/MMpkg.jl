"""
	createrepo(name,path,args...)

Create and initialize git repository, plus
fill it with default files (module, test, readme, etc.).

**Input**
* name: repository name (string without .jl extension)
* path: (optional) destination folder. path+name, or current working directory+name folder will be created
* args: optional further functions to be created inside the `src` folder (string without file extension)

**Example**

```
# Create just the repository and default files
createrepo("NewModule","f:/mikolaj/code/libraries/julia")
# Create repo + two function files
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
		@printf(fid,"module %s\n\nend #module",name);
	end
	# Create (optional) function files
	for i in args
		open(repofolder*"/src/"*i*".jl","w") do fid
			@printf(fid,"function %s()\n\nend",i);
		end
	end
	# Create test file
	open(repofolder*"/test/runtests.jl","w") do fid
		@printf(fid,"# Run the test from %s folder\n",name);
		@printf(fid,"using %s\nusing Base.Test\n\n",name);
		@printf(fid,"# List of test files:\n");
		@printf(fid,"tests = [\"\"]\n")
		@printf(fid,"# Run all tests in the list\n")
		@printf(fid,"for i in tests\n");
		@printf(fid,"\tinclude(i)\n")
		@printf(fid,"end\n");
		@printf(fid,"println(\"Test End!\")\n");
	end
	# Create readme file
	open(repofolder*"/readme.md","w") do fid
		@printf(fid,"%s\n",name)
		for i = 1:length(name)
			@printf(fid,"=");
		end
		@printf(fid,"\n");
	end
	# Initialize git
	curpath = pwd();
	cd(repofolder)
	run(`git init`)
	run(`git add readme.md`)
	run(`git add "src/*.jl"`)
	run(`git add "test/*.jl"`)
	cd(curpath)
end
