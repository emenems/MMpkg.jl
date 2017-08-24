"""
	meshgrid(x,y)
	
Function to create meshgrid, i.e. returns the same as 2D Matlab meshgrid [function](https://de.mathworks.com/help/matlab/ref/meshgrid.html).


**Input**
* x: vector or range (Int or Float)
* y: vector or range (Int or Float)

**Output**
* xi: matrix with x coordinates  (Int or Float)
* yi: matrix with y coordinates  (Int or Float)

**Example**

```
xi,yi = meshgrid(0:1:10,100:1:110);

```

"""
function meshgrid(x,y)
    xi = [j for i in y, j in x];
    yi = [i for i in y, j in x];
    return xi, yi;
end

""" 
	mesh2vec(xi,yi)

Convert meshgrid back to vector


**Input**
* xi: matrix of x coordinates (in mesghrid format)
* yi: matrix of y coordinates (in mesghrid format)

**Output**
* x: vector of x coordinates
* y: vector of x coordinates

**Example**

```
xi = [0 1 2;0 1 2;0 1 2];
yi = [10 10 10;11 11 11;12 12 12];
x,y = mesh2vec(xi,yi);

```
"""
# Compute grid vectors out of meshgrid
# Returns 2xVector{Float64}
function mesh2vec(x,y)
    return x[1,:], y[:,1]
end
