# ===================================================
# analysis.R
# Author(s): Josh Samra
# Date: August 14th, 2015
# Description: Analyzing tracks and header data.
# Data: tracks.csv, storms.csv from data folder
# ===================================================

storms <- read.csv('storms.csv')
tracks <- read.csv('tracks.csv')

#cleaning up the read csv file
storms$X <- NULL
tracks$X <- NULL

storms_table_by_year <- table(substr(storms$date, 1,4))
barplot(storms_table_by_year, ylim = c(0,35))

tracks_35 <- subset(tracks, tracks$wind >= 35)
tracks_35_ids <- unique(tracks_35$id)
storms_35_by_year <- table(substr(storms[tracks_35_ids,2],1,4))
barplot(storms_35_by_year,  ylim = c(0,35))

tracks_64 <- subset(tracks, tracks$wind >= 64)
tracks_64_ids <- unique(tracks_64$id)
storms_64_by_year <- table(substr(storms[tracks_64_ids,2],1,4))
barplot(storms_64_by_year,  ylim = c(0,35))

#There are no wind values greater than 95, but I wrote the code anyways
tracks_96 <- subset(tracks, tracks$wind >= 96)
tracks_96_ids <- unique(tracks_96$id)
storms_96_by_year <- table(substr(storms[tracks_96_ids,2],1,4))
barplot(storms_96_by_year,  ylim = c(0,35))

#Storm data by month
storms_table_by_month <- table(substr(storms$date, 6,7))
barplot(storms_table_by_month, ylim = c(0,600))

storms_35_by_month <- table(substr(storms[tracks_35_ids,2],6,7))
barplot(storms_35_by_month, ylim = c(0,600))

storms_64_by_month <- table(substr(storms[tracks_64_ids,2],6,7))
barplot(storms_64_by_month, ylim = c(0,600))

#And because there are no values, we get nothing for 96.
storms_96_by_month <- table(substr(storms[tracks_96_ids,2],6,7))
barplot(storms_96_by_month, ylim = c(0,600))

quantile35 <- as.numeric(quantile(storms_35_by_year, probs = c(.25, .5, .75)))
knots35data <- c(mean(storms_35_by_year), sd(storms_35_by_year), quantile35)

quantile64 <- as.numeric(quantile(storms_64_by_year, probs = c(.25, .5, .75)))
knots64data <- c(mean(storms_64_by_year), sd(storms_64_by_year), quantile64)

quantile96 <- as.numeric(quantile(storms_96_by_year, probs = c(.25, .5, .75)))
knots96data <- c(mean(storms_96_by_year), sd(storms_96_by_year), quantile96)

ann_25 <- c(quantile35[1], quantile64[1], quantile96[1])
ann_50 <- c(quantile35[2], quantile64[2], quantile96[2])
ann_75 <- c(quantile35[3], quantile64[3], quantile96[3])
ann_sd <- c(knots35data[2], knots64data[2], knots96data[2])
ann_avg <- c(knots35data[1], knots64data[1], knots96data[1])

annual_avg_storms <- data.frame(id = c("35 knots", "64 knots", "96 knots"),
                                avg = ann_avg,
                                stdev = ann_sd,
                                '25th' = ann_25,
                                '50th' = ann_50,
                                '75th' = ann_75)

#Get mean and median for wind and pressure
windavg <- numeric(0)
pressavg <- numeric(0)
windmedian <- numeric(0)
pressmedian <- numeric(0)
for (i in 1:1777) {
  windavg[i] <- mean(subset(tracks$wind, tracks$id == i))
  pressavg[i] <- mean(subset(tracks$press, tracks$id == i))
  windmedian[i] <- median(subset(tracks$wind, tracks$id == i))
  pressmedian[i] <- median(subset(tracks$press, tracks$id == i))
}
windavg <- round(windavg, digits = 2)
pressavg <- round(pressavg, digits = 2)

#Correlation of wind and pressure
avgcorr <- cor(windavg, pressavg)
medcorr <- cor(windmedian, pressmedian)

#mean wind and pressure
meanreg <- lm(windavg~pressavg)
par(cex=.5)
plot(windavg, pressavg, main = "Average Wind Speed and Pressure")
abline(reg = meanreg, col = '#ff1155')

#median wind and pressure
medianreg <- lm(windmedian~pressmedian)
par(cex=.5)
plot(windmedian, pressmedian, main = "Median Wind Speed and Pressure")
abline(reg = medianreg, col = '#0000ff')