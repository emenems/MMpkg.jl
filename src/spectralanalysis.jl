"""
	spectralAnalysis(signal;resol,win,fftlength)
Compute simple spectral analysis

**Input**
* `signal`: input DataArray time series with `resol` sampling
* `resol`: temporal resolution (used to computed output frequencies and periods)
* `win`: window to by applied to input signal, none by default, e.g. `DSP.hanning` (after `import DSP`)
* `fftlength`: use to pad input signal with zeros, i.e. increase spectral resolution

**Output**
* dataframe with frequency, period and amplitude of the resulting spectrum

**Example**
```
using DataFrames, PyPlot
import DSP
t = @data(collect(1.:1:100.));
signal = 1.0.*cos(2*pi./10.*t) +
    	 2.0.*cos(2*pi./20.*t) +
    	 3.0.*cos(2*pi./30.*t) +
		 randn(length(t));
out = spectralAnalysis(signal,resol=1.,fftlength=1000)# win=DSP.hanning
# plot results (>nyquist frequency=2 days)
plot(out[:period],out[:amplitude])
xlim([2,100])
```
"""
function spectralAnalysis(signal::DataArray{Float64};resol::Float64=1.0,
							win=ones,fftlength::Int=0)::DataFrame
	# pad input signal with zeros if needed (+remove mean value)
	signalmean = mean(filter(!isnan,signal));
	if fftlength > 0
		signalin = vcat(signal.-signalmean,
						zeros(eltype(signal),fftlength-length(signal)));
	else
		signalin = signal.-signalmean;
	end
	# compute FFT and covert to amplitude, frequency,...
	signallength::Int = length(signalin);
	y = fft(win != ones ? signalin.*win(signallength) : signalin);
	out = DataFrame(frequency = collect(0.:1:signallength-1).*((1/resol)/signallength),
					amplitude = (2./length(signal)).*abs.(y), # use original length of signal to resore energy
					phase = angle.(y));
	out[:period] = 1./out[:frequency];
	return out;
end
