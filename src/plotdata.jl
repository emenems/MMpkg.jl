"""
	plotyy(x1,y1,x2,y2,...)
Plot time series with two y-axes

**Example**
```
x1 = collect(1:1:10);
y1 = ones(length(x1));
x2 = collect(2:1:11);
y2 = x2.*0.5;

MMpkg.plotyy(x1,y1,x2,y2,
			   ylabel1="soil moisture (\$m^3/m^3\$)",ylabelcol1="black",
			   ylabel2="precipitation (\$mm/hour\$)",ylabelcol2="red",
			   linecol1="k-",linecol2="r-",
			   ylim1=(0,2),ylim2=(0,6),font_size=12)
```
"""
function plotyy(x1,y1,x2,y2;
				linecol1="k-",linecol2="b-",
				ylabel1="",ylabel2="",ylim1=(),ylim2=(),
				ylabelcol1="black",ylabelcol2="blue",font_size=10)
	# first (left) plot
	plot(x1,y1,linecol1);
	!isempty(ylim1) ? ylim(ylim1) : nothing
	!isempty(ylabel1) ? ylabel(ylabel1,color=ylabelcol1,fontsize=font_size) : nothing
	ax = gca();
	for item in vcat(ax[:get_xticklabels](),ax[:get_yticklabels]())
		item[:set_fontsize](font_size)
	end
	# Second (right) plot
	ax2 = ax[:twinx]()
	for item in ax2[:get_yticklabels]()
		item[:set_fontsize](font_size)
	end
	!isempty(ylim2) ? ylim(ylim2) : nothing
	!isempty(ylabel2) ? ylabel(ylabel2,color=ylabelcol2,fontsize=font_size) : nothing
	plot(x2,y2,linecol2)
end
