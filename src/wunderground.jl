"""
	getWUdata(id,timein;url,downto,keepfile)
Download and read Weather Underground daily (historic) data

**Input**
* id: site ID (e.g. "SADL" for airport La Plata, Argentina)
* timein: time step-range to be loaded
* url: weather underground URL (set to "" if data already downloaded)
* downto: download data to this folder
* keepfile: keep the downloaded data

**Output**
* dataframe containing mean daily data

**Example**
```
# using DataFrames
siteid = "SADL";
timevec = DateTime(2018,3,1):Dates.Day(1):DateTime(2018,3,2);
datafold = "f:/mikolaj/data/sites/aggo/meteo/wu_download/";
wu_url = "https://www.wunderground.com/history/airport/";
# Download (and keep) the data
out1 = getWUdata(siteid,timevec,url=wu_url,downto=datafold,keepfile=true)
# Read alredy downloaded data
out2 = getWUdata(siteid,timevec,url="",downto=datafold)
```
"""
function getWUdata(id::String,timein::StepRange{DateTime,Base.Dates.Day};
					url::String="https://www.wunderground.com/history/airport/",
					downto::String="",keepfile::Bool=true)::DataFrames.DataFrame
	# declare parameters to be downloaded/read (set keywords in the HTML file)
	downpar=Dict(:precipitation=>"Precipitation",:pressure=>"Sea Level Pressure",
				 :temperature=>"Mean Temperature",:windspeed=>"Wind Speed",
				 :dewpoint=>"Dew Point",:humidity=>"Average Humidity")
	# declare output dataframe
	dataout = DataFrame(datetime=collect(timein));
	for j in keys(downpar)
		dataout[j] = [NaN for i in timein];
	end
	# run loop for all time epochs
	for (i,v) in enumerate(timein)
		fullurl = url*id*"/"*Dates.format(v,"yyyy/mm/dd")*"/DailyHistory.html";
		filename = "WU_download_"*id*Dates.format(v,"_yyyymmdd")*".html";
		downfile = joinpath(isempty(downto) ? pwd() : downto,filename)
		try
			!isempty(url) ? download(download(fullurl,downfile)) : nothing
			for j in keys(downpar)
				dataout[j][i] = readWUdata(downfile,downpar[j]);
			end
			(!keepfile && !isempty(url)) ? rm(downfile) : nothing
		end
	end
	return dataout
end
"""
Aux. function to read the content of wunderground html file
"""
function readWUdata(downfile::String,keyword::String)::Float64
	out::Float64=NaN;
	open(downfile,"r") do fid
		# find line with the keyword
		row = readline(fid);
		while !contains(row,"<span>"*keyword*"</span>")
			row = readline(fid);
			eof(fid) ? break : nothing;
		end
		# set regular expression (either with or without decimal sign + additional line)
		if keyword=="Precipitation" || keyword=="Sea Level Pressure"
			re = r"[0-9]{1,}.[0-9]{1,}";
			readline(fid);# first line after is a dummy
		elseif keyword=="Average Humidity"
			re = r"[0-9]{1,}"
		else # "Mean Temperature" | Wind Speed | Dew Point
			re = r"[0-9]{1,}";
			readline(fid);# next line after is a dummy
		end
		mm = fid |> readline |> x-> match(re,x);
		out = mm !== nothing ? parse(Float64,mm.match) : NaN
	end
	return out
end
