## R Dependencies:
# library(raster)
"""
Polyg(on) type: contains ID, x/longitue, y/latitude and covered surface area
"""
mutable struct Polyg
   objectid::Int
   x::Vector{Float64}
   y::Vector{Float64}
   area::Float64
end

"""
    shpRpolygon(filein)
Read polygon from input SHP file exploiting the R/raster library

**Input**
* filein: input file name

**Output**
* Dictionary containing all found polygons (Type::Polyg)
"""
function shpRpolygon(filein::String)::Dict{Int64,Polyg}
	# read data to R
	R"""
	library(raster)
	shp <- raster::shapefile($(filein))
	"""
	# get all elements to Julia
	out = Dict{Int64,Polyg}();
	for i in 1:(R"length(shp)" |> rcopy)
        if (R"'polygons' %in% slotNames(shp)" |> rcopy)
            temp1,temp2,temp3,temp4 = getRpolyg(i);
        elseif (R"'lines' %in% slotNames(shp)" |> rcopy)
            temp1,temp2,temp3 = getRline(i);
            temp4 = NaN;
        end
        out[i] = Polyg(temp1,temp2,temp3,temp4);
	end
	return out
end
"""
Aux. function to get polygon
"""
function getRpolyg(i::Int)
    temp = R"shp@polygons[[$(i)]]@Polygons[[1]]@coords" |> rcopy
    objectid = R"shp@polygons[[$(i)]]@ID" |> rcopy
    if (R"'area' %in% slotNames(shp@polygons[[$(i)]])" |> rcopy)
        area = R"shp@polygons[[$(i)]]@Polygons[[1]]@area" |> rcopy
    else
        area = NaN;
    end
    # return objectID, X, Y, area
    return id2int(i,objectid),temp[:,1],temp[:,2], # ID, x, y
                 typeof(area) == Int ? area*1. : area;
end
"""
Aux. function to get polygon
"""
function getRline(i::Int)
    temp = R"shp@lines[[$(i)]]@Lines[[1]]@coords" |> rcopy
    objectid = R"shp@lines[[$(i)]]@ID" |> rcopy
    # return objectID, X, Y
    return id2int(i,objectid),temp[:,1],temp[:,2]
end
"""
Use Try/catch to convert what whould be string to integer
"""
function id2int(i::Int,o)
    try
        return Base.parse(Int,o)
    catch
        return i-1
    end
end

"""
Aux. funciton to plot the loaded polygons using shpRpolygon
"""
function polygplot(p::Dict{Int64,Polyg};linestyle="k-")
    for i in keys(p)
        plot(p[i].x,p[i].y,linestyle)
    end
end
