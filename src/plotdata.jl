"""
	plotyy(x1,y1,x2,y2,...)
Plot time series with two y-axes

**Example**
```
x1 = collect(1:1:10);
y1 = ones(length(x1));
x2 = collect(2:1:11);
y2 = x2.*0.5;
ax1,ax2 = MMpkg.plotyy(x1,y1,x2,y2,
		   ylabel1="first Y axis\$^1\$",ylabelcol1="black",
		   ylabel2="second Y axis\$^2\$",ylabelcol2="red",
		   linecol1="k-",linecol2="r-",
		   ylim1=(0,2),ylim2=(0,6),xlim=(1,10));
ax1[:set_xlabel]("common x axis");
```
"""
function plotyy(x1,y1,x2,y2;
                linecol1="k-",linecol2="b-",xlim=(),
                ylabel1="",ylabel2="",ylim1=(),ylim2=(),
                ylabelcol1="black",ylabelcol2="blue")
    # first (left) plot
    plot(x1,y1,linecol1);
    !isempty(ylim1) ? ylim(ylim1) : nothing
    !isempty(ylabel1) ? ylabel(ylabel1,color=ylabelcol1) : nothing
    ax = gca();
    # Second (right) plot
    ax2 = ax[:twinx]()
    !isempty(ylim2) ? ylim(ylim2) : nothing
    !isempty(ylabel2) ? ylabel(ylabel2,color=ylabelcol2) : nothing
    plot(x2,y2,linecol2)
    # set x limits (will automatically set both ax and ax2)
    !isempty(xlim) ? ax[:set_xlim](xlim) : nothing
    return ax,ax2
end
