"""
    cut2equal(x1,y1,x2,y2)
Function to cut 2 input time series to equal time interval

**Input**
* x1,y1: first x & y vectors (can be DateTime)
* x2,y2: second x & y vectors
* remnan: remove NaNs from output vectors (y only, optional, by default=false)

**Output**
* x,y1cut,y2cut: common x vector, y1 & y2 cutted to equal interval

**Example**
```
y1,y2 = collect(1:1:10),collect(33:1:42)
x1,x2 = copy(y1),collect(3:1:12);
x,y1c,y2c = cut2equal(x1,y1,x2,y2);
```
"""
function cut2equal(x1,y1,x2,y2;remnan=false)
    t1,t2 = maximum([minimum(x1),minimum(x2)]),minimum([maximum(x1),maximum(x2)])
    y1c = y1[map(x-> x.>= t1 && x .<= t2,x1)]
    y2c = y2[map(x-> x.>= t1 && x .<= t2,x2)]
    x  = x2[map(x-> x.>= t1 && x .<= t2,x2)]
	if remnan
		inan = map(!isnan,y1c.+y2c);
		y1c,y2c,x = y1c[inan],y2c[inan],x[inan];
	end
    return x,y1c,y2c
end
