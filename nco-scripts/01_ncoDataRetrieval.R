######################################################################
###
### SÞJ, January 2015
### SÞJ, July 2015, retrieved first half of 2015
### SÞJ, Agust 2015, retrieved 1995+ for a larger area
### SÞJ, Agust 2017, retrieved just July for the whole period
### SÞJ, Agust 2018, retrieved just July 2018 from new location.
###
### Script to get SST-ncdf's from eclips.ncdc.noaa.gov
### (Daily Reynolds Optimum Interpolation
### We use nco to cut out region of interest, 
### This method of retrieval saves on disk space 
### but could be improved as regards bandwith usage
###
######################################################################

### Define region of interest
### lat/lon bounds as character according to 'nco' standard practice
minLat <- "50.0"; maxLat <- "80.0"
minLon <- "305.0"; maxLon <- "35.0"
## i.e. 50 -- 80N and 55W -- 35E
## we don't stride over these data at the moment

## do one year to start with

## write-path to data on local storage
rootPath <- "/media/1tb/Data/OI-daily-v2/macArea/2018"

setwd(rootPath)

mmdd <- seq(
  as.Date("2018-07-01"), 
  as.Date("2018-07-31"), by = 1)
mmdd <- format(mmdd, "%m%d")
outFiles <- paste0("d", mmdd, ".nc")
# data have been download-ed manually from the new place
# we just loop over the global avhrr-data-sets and cut out
# our area so as to have comparable to previous years
ncdfFiles <- paste0("avhrr-only-v2.2018", substring(outFiles, 2))

for(i in seq(along = mmdd)) {
#  print(paste("MMonthDDay", mmdd[i]))
  ncoCall <- paste0(
    "ncks --overwrite --local /tmp --dimension lat,", minLat, ",", maxLat,
    " --dimension lon,", minLon, ",", maxLon, " ",
    ncdfFiles[i], " ", outFiles[i])
  system(ncoCall)
}

## add record dimension to enable averageing
system("for i in d????.nc; 
  do ncks --overwrite --mk_rec_dmn time $i $i; 
  done")

########## Data retrieval done #############################################
############################################################################
