
include("../src/inpolygon.jl")
include("../src/meshgrid.jl")
using Base.Test

# inpolygon
xv = [0,10,10,0.];
yv = [0,0,10,10.];
# Vertex, edge, outside
x = [0.,10.,3];
y = [0.,9.9,-0.1];
o = inpolygon(x,y,xv,yv)
@test o[1] == true;
@test o[2] == true;
@test o[end] == false;

# meshgrid
x = [1,2,3,4];
y = [10,20,30,40];
xi,yi = meshgrid(x,y)
@test xi[2,3] == 3.0
@test yi[2,3] == 20.0

# mesh2vec
xi = [1 2 3 4; 1 2 3 4; 1 2 3 4; 1 2 3 4];
yi = [10 10 10 10; 20 20 20 20; 30 30 30 30; 40 40 40 40];
x,y = mesh2vec(xi,yi);
@test x[end] == 4
@test y[1] == 10
println("End");
