# ===================================================
# NA_code.R
# Author(s): Josh Samra
# Date: August 10th, 2015
# Description: Cleaning the raw hdat file.
# Data: IBTrACS NA Basin Dataset
# ===================================================
library('stringr')

#getting values for storms.csv from rawdata folder
storm_data <- read.table("raw_NA.hdat", sep = '\t')

storms_id <- c(1:1777)
storms_header <- str_extract(storm_data$V1, '\\d\\d/\\d\\d/\\d\\d\\d\\d')
clean_storms_date <- as.Date(na.omit(storms_header), format = '%m/%d/%Y')

days <- str_extract_all(storm_data$V1, 'M=..')
days_vec <- na.omit(sapply(days, "[", 1))
clean_days <- as.numeric(substr(days_vec, 3, 4))

name <- str_extract_all(storm_data$V1, 'SNBR=................')
name_vec <- na.omit(sapply(name, "[", 1))
clean_names <- trimws(as.character(substr(name_vec, 11,25)), 'both')

storms_df <- data.frame(id = storms_id,
                        date = clean_storms_date,
                        days = clean_days,
                        name = clean_names)
write.csv(storms_df, "storms.csv")

#getting values for tracks.csv

tracks_id <- rep(storms_df$id, storms_df$days * 4)

date_data <- unlist(str_extract_all(substr(storm_data$V1, 7, 20), '\\d*/\\d*[*EWSL]'))
raw_date <- substr(date_data, 1, 5)
tracks_year <- substr(rep(clean_storms_date, storms_df$days * 4), 1,4)
tracks_date <- as.Date(paste(rep(raw_date, each = 4), tracks_year, sep = '/'),
                       format = '%m/%d/%Y')

periods <- c('00h', '06h', '12h', '18h')
tracks_period <- rep(periods, 12889)

#separating the different track values by period for lat, long, wind, press
sep <- substr(storm_data$V1, 12, 79)
sep2 <- str_extract_all(sep, '[*EWSL][\\d\\s\\d]*')
sep3 <- trimws(unlist(sep2), 'both')

#Need to remove all of the "S" characters

for (i in 1:length(sep3)) {
  if (nchar(sep3[i]) == 1) {
    sep3[i] <- NA
  } else {
    sep3[i] <- sep3[i]
  }
}

sep4 <- na.omit(sep3)

tracks_stage <- substr(sep4, 1, 1)
tracks_stage1 <- gsub('\\*', 'cyclone', tracks_stage)
tracks_stage2 <- gsub('S', 'subtropical', tracks_stage1)
tracks_stage_final <- gsub('E', 'extratropical', tracks_stage2)

tracks_lat <- as.numeric(substr(sep4,2,5)) / 100
tracks_lon <- as.numeric(substr(sep4,6,8)) / -10
tracks_wind <- as.numeric(trimws(substr(sep4, 10, 12), 'both'))
tracks_press <- as.numeric(substr(sep4, 14, length(sep4)))

tracks_df <- data.frame(id = tracks_id,
                        date = tracks_date,
                        period = tracks_period,
                        stage = tracks_stage_final,
                        lat = tracks_lat,
                        lon = tracks_lon,
                        wind = tracks_wind,
                        press = tracks_press)

clean_tracks_df <- subset(tracks_df, tracks_df$lat > 0 | tracks_df$lon > 0)

write.csv(clean_tracks_df, 'tracks.csv')
