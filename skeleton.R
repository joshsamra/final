# ===================================================
# skeleton.R
# Author(s): Josh Samra
# Date: August 10th, 2015
# Description: Creating the directories, Readme, and resource download instructions.
# ===================================================

#Creating the directories for the project
dir.create("/Users/joshsamra/Desktop/summer2015/stat133/final/code")
dir.create("/Users/joshsamra/Desktop/summer2015/stat133/final/rawdata")
dir.create("/Users/joshsamra/Desktop/summer2015/stat133/final/data")
dir.create("/Users/joshsamra/Desktop/summer2015/stat133/final/resources")
dir.create("/Users/joshsamra/Desktop/summer2015/stat133/final/report")
dir.create("/Users/joshsamra/Desktop/summer2015/stat133/final/images")

#Creating the Readme file
file.create('README.md')
file.edit('README.md')

#Getting Data
download.file('ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/hurdat_format/basin/Basin.NA.ibtracs_hurdat.v03r06.hdat',
              destfile = 'raw_NA.hdat')
download.file('ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/basin/Basin.EP.ibtracs_wmo.v03r06.csv',
              destfile = 'EP_1980_2010.csv')
download.file('ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/basin/Basin.NA.ibtracs_wmo.v03r06.csv',
              destfile = 'NA_1980_2010.csv')