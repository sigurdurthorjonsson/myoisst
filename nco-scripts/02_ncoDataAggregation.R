######################################################################
###
### Script originally from 2015 to:
###   aggregate daily SST-ncdf's from eclips.ncdc.noaa.gov
###
### SÞJ, August 2017, adapt to mackerel, just July, as in '15 report
### 20 year average (1990-2009), 
###
### Script to aggregate daily SST-ncdf's from eclips.ncdc.noaa.gov
###
######################################################################

### note aggregations are overwritten if they exist

### Define year range
## do one year to start with
# years <- c(2014)

# or more years, here whole period for this data set
years <- 1982:2018

for(j in seq(along = years)) {

print(paste("Árið er", years[j]))

## path to data on local storage
rootPath <- "/media/1tb/Data/OI-daily-v2/macArea"
myPath <- paste(rootPath, years[j], sep = "/")

setwd(myPath)

## average just July

# take average
system("ncra --overwrite d07??.nc m07.nc")
# fix long coord to minus values on western hemi
system("ncap2 --overwrite --script 'where(lon>180) lon=lon-360' m07.nc m07.nc")
# stride over lat and lon taking averages on 4x4 cells of the original grid
#system("ncra --overwrite --dimension lon,,,2 --dimension lat,,,2 m07.nc m07.nc")
## doesn't look convincing as an average, coords wrong, ..., work this out

## close year loop
}

setwd(rootPath)

system('ncra --overwrite 199?/m07.nc 200?/m07.nc ave_m07.nc')

years <- as.character(2010:2017)

for(i in seq(along = years)) {
  setwd(years[i])
    system('ncdiff --overwrite m07.nc ../ave_m07.nc diff_m07.nc') 
  setwd(rootPath)
}
