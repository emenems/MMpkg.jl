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
	@printf("\nGlobal variables (whos()):\n")
	whos()
end
function docversion(fid::IOStream)
	@printf(fid,"Automatic Julia version and package status report:\n\n");
	versioninfo(fid);
	@printf(fid,"\nInstalled packages (may not be used, see using/import command in code):\n");
	Pkg.status(fid);
	@printf(fid,"\nGlobal variables (whos()):\n")
	whos(fid);
end
