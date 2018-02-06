## Set of functions related to geodetic computations on ellipsoid and spere
# Constants: geodetic
const a_elip = 6378137.; # WGS84 ellipsoid major axis (m)
const b_elip = 6356752.314245; # WGS84 ellipsoid minor axis (m)
"""
	lonlat2psi(lon1,lat1,lon2,lat2;a,b)
Compute spherical distance between points on ellipsoid

**Input**
* lon1: longitude of the first point in degrees
* lat1: latitude of the first point in degrees
* lon2: longitude of the second point in degrees
* lat2: latitude of the second point in degrees
* a: (optional) major axis of the ellipsoid
* b: (optional) minor axis of the ellipsoid

**Output**
* psi: spherical distance in radians

**Example**
```
psi = lonlat2psi(1.,0.,0.,0.);
```
"""
function lonlat2psi(lon1::Float64,lat1::Float64,lon2::Float64,lat2::Float64;a::Float64=a_elip,b::Float64=b_elip)
    # Transform to XYZ
    x1,y1,z1 = elip2xyz(lon1,lat1,height=0.,a=a,b=b);
    x2,y2,z2 = elip2xyz(lon2,lat2,height=0.,a=a,b=b);
    # Transform to sphere (longitude stays the same)
    lat1s = atan(z1/sqrt(x1^2+y1^2));
    lat2s = atan(z2/sqrt(x2^2+y2^2));
    # Calc spherical distance in radians
    return acos(sin(lat1s)*sin(lat2s) + cos(lat1s)*cos(lat2s)*cosd(lon1-lon2));
end

"""
	elip2xyz(lon,lat;height,a,b)
Convert longitude and latitude on ellipsoid to X,Y,Z coordinates

**Input**
* lon: longitude on sphere (degrees)
* lat: latitude on sphere (degrees)
* height: optional height above the ellipsoid (default = 0.0)
* a: (optional) major axis of the ellipsoid
* b: (optional) minor axis of the ellipsoid

**Output**
* x,y,z coordinates (m)

**Example**
```
x,y,z = elip2xyz(0.0,0.0,height=10.0,a=6378137.,b=6356752.31414036)
```
"""
function elip2xyz(lon::Float64,lat::Float64;height::Float64=0.0,a::Float64=a_elip,b::Float64=b_elip)
    e = eccentricity1(a,b);
    n = a/sqrt(1.-e^2*sind(lat)^2);
    x = (n+height)*cosd(lat)*cosd(lon);
    y = (n+height)*cosd(lat)*sind(lon);
    z = (n*(1.-e^2)+height)*sind(lat);
    return x,y,z
end


"""
    elip2sphere(lon,lat;height,a,b)
Convert ellipsoidal latitude to spherical

**Input**
* lon: longitude on sphere (degrees)
* lat: latitude on sphere (degree)
* height: optional height above the ellipsoid
* a: (optional) major axis of the ellipsoid
* b: (optional) minor axis of the ellipsoid

**Output**
* latitude on sphere (degrees)

**Example**
```
lat = elip2sphere(0.0,90.0,height=10.0,a=6378137.,b=6356752.31414036);
```

"""
function elip2sphere(lon::Float64,lat::Float64;height::Float64=0.0,a::Float64=a_elip,b::Float64=b_elip)
    X,Y,Z = elip2xyz(lon,lat,height=height,a=a,b=b);
    lat = atan(Z/sqrt(X^2+Y^2));
	return rad2deg(lat);
end


"""
	eccentricity1(a,b)
Compute first [eccentricity](https://en.wikipedia.org/wiki/Ellipsoid)

**Input**
* a: major axis (m)
* b: minor axis (m)

**Output**
* eccentricity in m

**Example**
```
e1 = eccentricity1(6378137.,6356752.31414036);
```
"""
function eccentricity1(a::Float64=a_elip,b::Float64=b_elip)
	sqrt((a^2-b^2)/a^2);
end

"""
	replacesphere(a,b)
Compute radius of a replacement sphere with identical surface as ellipsoid

**Input**
* a: major axis (m)
* b: minor axis (m)

**Output**
* radius in m

**Example**
```
re = replacesphere(6378137.,6356752.31414036)
```
"""
function replacesphere(a::Float64=a_elip,b::Float64=b_elip)
	e = eccentricity1(a,b);
	sqrt(1 + 2/3*e^2 + 3/5*e^4 + 4/7*e^6 + 5/9*e^8 + 6/11*e^10 + 7/13*e^12)*b;
end


"""
	deg2decimal(d,m,s)
Convert degrees, minutes and seconds to decimal degrees

**Input**
* d: degrees
* m: minutes
* s: seconds

**Output**
* decimal degrees (not radians!)

**Example**
```
degd = deg2decimal(90,30,10)
```
"""
function deg2decimal(d,m,s)
	mult = 1;
	# check sign
	if d < 0
		mult = -1;
	end
	return mult*(abs(d) + abs(m)/60 + abs(s)/3600)
end

"""
	decimal2deg(degd)
Convert degrees, minutes and seconds to decimal degrees

**Input**
* decimal degrees (not radians!)

**Output**
* tuple containing (degrees,minutes,second)

**Example**
```
deg = decimal2deg(90.5)
```
"""
function decimal2deg(degd)
	if degd < 0
		d = ceil(degd);
		m = floor((d - degd)*60)
		s = ((d - degd)*60 - m)*60
	else
		d = floor(degd);
		m = floor((degd - d)*60)
		s = ((degd - d)*60 - m)*60
	end
	return (d,m,s)
end
