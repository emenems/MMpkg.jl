## Set of functions relate do manipulation of meteorological data, especially
# global atmospheric model outputs
# Constants: meteorological
const e_const = 287.0597/461.5250; # ratio Rd/Rv, see https://www.ecmwf.int/sites/default/files/elibrary/2015/9211-part-iv-physical-processes.pdf
const g_const = 9.80665; # gravity constant for geopotential -> height conversion
"""
    meteo2density(pres,temp,humi)
Convert meteo parameters to [density](https://en.wikipedia.org/wiki/Density_of_air)

**Input**
* pres: atmospheric pressure in Pa
* temp: air temperature in K
* humi: (optional) relative humidity in %

**Ouput**
* density in kg/m^3

"""
function meteo2density(pres::Float64,temp::Float64,humi::Float64=0.0)
	pv = satwatpres(temp)*humi/100;
	pd = pres - pv;
	return (pd*0.028964 + pv*0.018016)/(8.314*temp)
end

"""
	satwatpres(temp)
Compute saturation water vapour pressure (over water) based on Buck [equation](https://en.wikipedia.org/wiki/Arden_Buck_equation)

**Input**
* temp: air temperature in K

**Output**
* saturation water vapour pressure in Pa

**Example**
```
satwatpres(20+273.15)
```
"""
function satwatpres(temp::Float64)
	temp = kel2deg(temp);
	if temp > 0
		return 611.21*exp((18.678 - temp/234.5)*(temp/(257.14+temp)))
	else
		return 611.15*exp((23.036 - temp/333.7)*(temp/(279.82+temp)))
	end
	# esat = 611.21*exp(17.502*((temp - 273.16)/(temp-32.19))); # ECMWF (2010): IFS documentation CY36r1: IV. Physical processes, eq. 7.5, p. 92
end

"""
	kel2deg(temp)
Convert temperature in K to degrees C
"""
function kel2deg(temp::Float64)
	temp-273.15;
end

"""
	deg2kel(temp)
Convert temperature in degrees C to K
"""
function deg2kel(temp::Float64)
	temp+273.15;
end

"""
	sh2rh(sh,temp,press)
Compute relative humidity using specific humidity, air temperature and pressure

**Input**
* sh: specific humidity in kg/kg
* temp: air temperature in K
* press: air pressure in Pa

**Output**
* relative humidity in %

**Example**
```
rh = sh2rh(0.00606,23+273.15,101325.)
```
"""
function sh2rh(sh,temp,press)
	e = (sh*press)/(e_const + (1 - e_const)*sh);
	es = satwatpres(temp);
	return 100*e/es;
end

"""
	dew2sh(temp,pres)
Converet dew point temperature and pressure to specific (saturated) humidity
See https://www.ecmwf.int/en/does-era-40-dataset-contain-near-surface-humidity-data

**Input**
* temp: dew point temperature in K
* pres: air pressure in Pa

**Output**
* specific humidity in kg/kg

**Example**
```
sh = dew2sh(273.15+20.,101325.)
```
"""
function dew2sh(temp::Float64,pres::Float64)
	esat = satwatpres(temp);
	return (e_const*esat)./(pres - (1 - e_const).*esat)
end

"""
	dew2rh(temp_dew,temp)
Compute relative humidity using dew and air temperature
See https://www.ecmwf.int/en/does-era-40-dataset-contain-near-surface-humidity-data

**Input**
* temp_dew: dew point temperature in K
* temp: air temperature in K

**Output**
* relative humidity in %

**Example**
```
rh = dew2rh(7+273.15,31+273.15)
```
"""
function dew2rh(temp_dew::Float64,temp::Float64)
	return 100*satwatpres(temp_dew)/satwatpres(temp)
end

"""
	rh2dew(rh,temp)
Compute dew point using relative humidity and temperature
See https://en.wikipedia.org/wiki/Dew_point

**Input**
* rh: relative humidity in %
* temp: air temperature in K

**Output**
* dew point in K

**Example**
```
dew = rh2dew(75.,-1.+273.15)
```
"""
function rh2dew(rh::Float64,temp::Float64)
	temp = kel2deg(temp);
	ym = log((rh/100)*exp((18.678 - temp/234.5)*(temp/(257.14 + temp))));
	return deg2kel((257.14*ym)/(18.678 - ym));
end

"""
	rh2abs(humid,temp)
Convert relative humidity and temperature to absolute humidity

**Input**
* humid: input humidity in %
* temp: input temperature in K

**Output**
* resulting absolute hudmity (kg/m^3)

**Example**:
```
abshum = rh2abs(60.,25+273.15);
```
"""
function rh2abs(humid::Float64,temp::Float64)
	temp = kel2deg(temp);
    out = (6.112.*exp((17.67*temp)/(temp+243.5))*humid*18.02)/
         ((273.15+temp)*100*0.08314);
    # Convert to kg/m^3
    return out/1000;
end

"""
    geopot2height(phis)
Convert geopotential (m^2.s^-2) to height (m)

**Input**
* phis: geopotential in m^2.s^-2

**Output**
* physical height in m

"""
function geopot2height(phis::Float64;g=g_const)
	return phis/g
end
function geopot2height(phis::Float32;g=g_const)
	return geopot2height(convert(Float64,phis),g=g)
end


"""
	sm2ph(θh,θs,θr,α,n)
Convert soil moisture to pressure head using van Genuchten parameters
Conversion equation: 2.29 Hydrus-1D User Manual page 58/343

**Input**
* `θh`: soil moisture to be converted (in m^3/m^3)
* `θs`: saturated water contents (soil moisture in m^3/m^3)
* `θr`: residual water contents (soil moisture in m^3/m^3)
* `α`: the inverse of the air-entry value (in desired input length units)
* `n`: pore-size distribution index

**Output**
* negative pressure head in units given by `alpha` (assuming θh < θs)

**Example**
```
ph = sm2ph(0.388,0.4232,0.0768,0.0113,1.4542)
@test round(ph,digits=1) == -47.9
```
"""
function sm2ph(θh::Float64,θs::Float64,θr::Float64,α::Float64,n::Float64)::Float64
	nrth(x,p) = x^(1/p);
	m = 1 - 1/n;
	if θh < θs
		return -nrth(nrth((θs - θr)/(θh - θr),m)-1,n)/α
	else
		return NaN
	end
end
