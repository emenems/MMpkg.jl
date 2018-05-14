
using Base.Test, DataFrames

include("../src/geotools.jl")
include("../src/meteotools.jl")
include("../src/variousfces.jl")
include("../src/spectralanalysis.jl")


#######################################
######### METEOTOOLS.JL ###############
#######################################
# rh2abs:  http://planetcalc.com/2167/
@test round(rh2abs(60.,25.+273.15)*1000) == 14

# rh2dew: See http://dpcalc.org for results
@test round(rh2dew(75.,-1.+273.15)) == round(-5+273.15)

# satwatpres: https://en.wikipedia.org/wiki/Vapour_pressure_of_water
@test round(satwatpres(20+273.15)/10) == 234

# meteo2density. Approximation: http://www.thefullwiki.org/Density_of_air
# Humid air: https://www.brisbanehotairballooning.com.au/calculate-air-density/
@test round(meteo2density(100000.,273.15+20.,35.)*1e+4) == 11847
# Dry air:https://en.wikipedia.org/wiki/Density_of_air
@test round(meteo2density(101325.,273.15+15.,0.)*1e+4) == 12250

# dew2rh: http://dpcalc.org
@test round(dew2rh(24+273.15,32+273.15)) == 63.

# dew2sh:
# https://www.rotronic.com/en/humidity_measurement-feuchtemessung-mesure_de_l_humidite/humidity-calculator-feuchterechner-mr
@test round(dew2sh(6.73+273.15,101325.)*1e+5) == 606

# sh2rh:
# https://www.rotronic.com/en/humidity_measurement-feuchtemessung-mesure_de_l_humidite/humidity-calculator-feuchterechner-mr
@test round(sh2rh(0.00606,23+273.15,101325.)) == 35

# geopot2height
@test geopot2height(1000.0,g=9.80665) ≈ 1000.0/9.80665

#######################################
########### VARIOUSFCES.JL ############
#######################################
# cut2equal
y1,y2 = collect(1.:1.:10),collect(33.:1.:42)
x1,x2 = copy(y1),collect(3.:1:12);
x,y1c,y2c = cut2equal(x1,y1,x2,y2);
@test x == collect(3.:1.:10)
@test y1c == collect(3.:1.:10)
@test y2c == collect(33.:1.:40)
# Remove also NaNs
y1[5] = NaN
x,y1c,y2c = cut2equal(x1,y1,x2,y2,remnan=true);
@test x == [3.,4,6,7,8,9,10]
@test y1c == [3.,4,6,7,8,9,10]
@test y2c == [33.,34,36,37,38,39,40]

#######################################
########### GEOTOOLS.JL ###############
#######################################
# test lonlat2psi: spherical distnace between points
psi = lonlat2psi(0.,0.,0.,0.);
@test psi ≈ 0
psi = lonlat2psi(1.,0.,0.,0.);
psi = rad2deg(psi);
@test psi ≈ 1.0

# Eccentricity: https://de.mathworks.com/help/map/ref/referenceellipsoid-class.html
e1 = eccentricity1(6378137.,6356752.31414036);
@test round(e1*1e+13) == round(0.0818191910428158*1e+13)

# Radius of replacement sphere (https://de.mathworks.com/help/map/ref/referenceellipsoid-class.html )
re = replacesphere(6378137.,6356752.31414036)
rr = sqrt(510065621718491/(4*pi))
@test rr ≈ re

# elip2xyz
x,y,z = elip2xyz(0.0,0.0,height=0.0,a=6378137.,b=6356752.31414036)
@test x ≈ 6378137.
@test y ≈ 0.
@test z ≈ 0.
x,y,z = elip2xyz(0.0,90.0,height=10.0,a=6378137.,b=6356752.31414036)
@test z ≈ 6356752.31414036+10.
@test y ≈ 0.
@test x ≈ 0.

# elip2sphere
@test elip2sphere(0.0,90.0,height=10.0,a=6378137.,b=6356752.31414036) ≈ 90.
@test elip2sphere(10.0,0.0,height=1000.0,a=6378137.,b=6356752.31414036) ≈ 0.

# deg2decimal
@test deg2decimal(90,30,0) == 90.5
@test deg2decimal(-90,15,0) == -90.25

# decimal2deg
@test decimal2deg(90.5) == (90,30,0)
t = decimal2deg(-90.25);
@test t[1] == -90
@test t[2] == 15
@test t[3] ≈ 0

# spectral analysis =  just compute no check
t = collect(1.:1:100.);
signal = 1.0.*cos.(2*pi./10.*t) +
     2.0.*cos.(2*pi./20.*t) +
     3.0.*cos.(2*pi./30.*t) +
     randn(length(t));
out = spectralAnalysis(signal,resol=1.,fftlength=1000)# win=DSP.hanning
# plot results (>nyquist frequency=2 days)
#plot(out[:period],out[:amplitude])
#xlim([2,100])
println("End of test")
