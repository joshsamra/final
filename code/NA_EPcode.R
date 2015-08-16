# ===================================================
# NA_EPcode.R
# Author(s): Josh Samra
# Date: August 10th, 2015
# Description: Cleaning the NA and EP csv files and creating visualizations
# Data: IBTrACS NA and EP 1980 to 2010 csv's.
# ===================================================
library(ggplot2)
library(maps)

na_1980_2010 <- read.csv('NA_1980_2010.csv', header = TRUE)
ep_1980_2010 <- read.csv('EP_1980_2010.csv', header = TRUE)

