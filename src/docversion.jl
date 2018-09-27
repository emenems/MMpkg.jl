"""
	docversion(file)

Write dependency report to a given file (String or IOStream) or to command prompt.

**Input**
* file: full file name or open IOStream (writing to a IOStream will not close the file!)
* no input will result in output to REPL prompt

**Example**

```
docversion("version_notes.txt")
docversion()

```

"""

function docversion(file::String)
	fid = open(file,"w")
	docversion(fid);
	close(fid);
end
function docversion()
	@printf("Automatic Julia version and package status report:\n");
	versioninfo()
	@printf("Installed packages (may not be used, see using/import command in code):\n");
	Pkg.status()
	@printf("\n");
	@printf("Global variables (whos()):\n")
	InteractiveUtils.varinfo()
end
function docversion(fid::IOStream)
	@printf(fid,"Automatic Julia version and package status report:\n");
	@printf(fid,"\n");
	versioninfo(fid);
	@printf(fid,"\n");
	@printf(fid,"Installed packages (may not be used, see using/import command in code):\n");
	Pkg.status(fid);
	@printf(fid,"\n");
	@printf(fid,"Global variables (whos()):\n")
	InteractiveUtils.varinfo(fid);
end
