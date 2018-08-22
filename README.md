# myoisst
scripts and average oi-sst-ncdfs to show SST and SST anomalies in selected areas of the North Atlantic

Set up in order to document and hopefully improve the genration of figures of SST and SST anomalies in the area covered by the IESSNS (International Ecosystem Summer Survey in the Nordic Seas, sometimes referred to as the mackerel survey).

Data from NOAA climate repositories previously at NCDC (National Climatic Data Center), now at NCEI (National Centers for Environmental Information)

Old repository:

https://www.ncdc.noaa.gov/oisst

New repository:

https://www.ncei.noaa.gov/thredds/blended-global/oisst-catalog.html

Downloaded the OISST-V2-AVHRR Daily files.

Used Network Common Operators:

http://nco.sourceforge.net/

to subset the global datasets and take averages at the original resolution. For the mackerel,  averaged the daily files in July of each year and then took a 20 year average 1990-2009 prior to the start of continous IESSNS surveys. See legacy scripts in this [folder](nco-scripts) and the averages as nc-files in [folder](macArea), the reference climatology chosen by the survey group as [file](macArea/ave_m07.nc), annual July averages in year-subd-irectories to the side (dailies removed).

Have heard about efforts to make it possible to do the data aquisition directly from R (similar to the package marmap), hope that will be realized some time.
