"""
    homgendatatest(data1,data2;time1,time2,fig_size)

Test homogeneity of meteorological data
Input time series (with missing data and the one used to filled the missing
periods) must not be of identical length. Important is that bot time
series are overlapped and use identical time resolution, i.e.,use time2regular
function to re-sample the data prior calling this function.
The procedure follows the FAO Irrigation and drainage paper 56,
instructions at: http://www.fao.org/docrep/X0490E/x0490e0l.htm

**Input**
* data1: first data vector (DataArray)
* data2: second data vector (DataArray)
* time1: optional time vector corresponding to data1, if data1 and data2 do not overlap
* time2: optional time vector corresponding to data2, if data1 and data2 do not overlap
* fig_size: output figure size (default=(13,8))

**Example**
```
using DataFrames, MMpkg
timein = collect(linspace(0,2*pi,100));
datain = DataFrame(time=timein,
				   data1= sin.(2*pi.*timein).+rand(length(timein))/2,
				   data2= sin.(2*pi.*timein).+rand(length(timein))/3);
homogendatatest(datain[:data1],datain[:data2],
				time1=datain[:time],time2=timein)
```
"""
function homogendatatest(data1::DataArray,data2::DataArray;
                        time1=@data([]),time2=@data([]),
                        fig_size=(13,8));
    # set default values
    if length(time1) == 0 || length(time2) == 0
        time1,time2 = @data(collect(0:1:length(data1))),@data(collect(0:1:length(data2)));
    end
    # Prepare data
    timeuse,data1use,data2use = MMpkg.cut2equal(time1,data1,time2,data2,remnan=true);
    ## regression analysis
    PyPlot.figure(figsize=fig_size)
    PyPlot.subplot(2,2,1);
    resid = homogendatatest_reg(data1use,data2use);
    ## Test homogeneity
    PyPlot.subplot(2,2,2);
    homogendatatest_ellipse(data1,data2,resid)
    ## Double mass technique
    y2_surr,y2_res = homogendatatest_doublemass(data1use,data2use)
    PyPlot.subplot(2,2,3);
    PyPlot.plot(cumsum(data2use),cumsum(data1use),"k.",cumsum(data2use),y2_surr,"r-");
    PyPlot.legend(["input","fit"]);
    PyPlot.title("Double mass: cumulative sums vs regression");
    PyPlot.xlabel("data2");PyPlot.ylabel("data1");
    PyPlot.subplot(2,2,4);
    PyPlot.plot(timeuse,y2_res,"k.");
    PyPlot.title("Double mass residuals (should not be systematic/no trend)");
    PyPlot.ylabel("residuals");
    PyPlot.legend(["fit residuals"])
    eltype(time1) == DateTime ? PyPlot.xlabel("date-time") : PyPlot.xlabel("record number");
end

"""
auxiliary function for computation of a regression model
"""
function homogendatatest_reg(data1::DataArray,data2::DataArray)
    # Compute standard deviations, means, covariance and correlation
    x_mean,y_mean = mean(data2),mean(data1)
    x_std,y_std  = std(data2),std(data1)
    covxy  = cov(data2,data1);
    corxy  = cor(data2,data1);
    # Regression analysis
    b = covxy/x_std^2;
    a = y_mean - b.*x_mean;
    y_surr = a + b*data2;
    PyPlot.plot(data2,data1,"k.",data2,y_surr,"r-");
    PyPlot.legend(["input data","regression"]);
    PyPlot.ylabel("data1");#PyPlot.xlabel("data2");
    PyPlot.xlim((minimum(data2),maximum(data2)));
    PyPlot.ylim((minimum(data2),maximum(data2)));
    PyPlot.title(@sprintf("Regression=%.2f (should:0.7-1.3), r^2 = %.2f (should>0.7)",b,corxy^2));
    return data1 - y_surr
end

"""
auxiliary function to plot error ellipsis
"""
function homogendatatest_ellipse(data1,data2,resid)
    # Set p and corresponding zp values: according to FAO: "80% is commonly
    # utilized". zp is standard normal variate for selected probabilities P.
    p_val,zp = [80 85 90 95],[0.84 1.04 1.28 1.64]; # !!change zp if p_val modified!!
    n = length(data2);
    α = repmat([n/2],length(p_val));
    ψ = linspace(0.,2*pi,120);
    PyPlot.plot(cumsum(resid),"r-");
    stdres = std(resid);
	plotline = ["k-","b--","b-","k--"];
	out_leg = ["residuals"];
    for i in 1:length(p_val)
        β = n/sqrt(n-1)*zp[i]*stdres;
        # Compute coordinates of probability ellipsis
        X = α[i]*cos.(ψ);
        Y = β*sin.(ψ);
        if mod(i,2) == 1
            PyPlot.plot(X+X[i],Y,plotline[i],LineWidth=2)
        else
            PyPlot.plot(X+X[i],Y,plotline[i],LineWidth=0.5)
        end
        push!(out_leg,@sprintf("P at %d%%",p_val[i]));
    end
    PyPlot.title("Associated ellipsis for given probabilities (important if r^2<1)");
    PyPlot.legend(out_leg);
end
"""
auxiliary function to compute double-mass technique
"""
function homogendatatest_doublemass(data1,data2)
    x_cum = cumsum(data2);
    y_cum = cumsum(data1);
    b2 = sum((x_cum-mean(x_cum)).*(y_cum-mean(y_cum)))/sum((x_cum-mean(x_cum)).^2);
    y2_surr = x_cum*b2;
    y2_res = y_cum - y2_surr;
    return y2_surr,y2_res
end
