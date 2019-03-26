# 02 - filter_data_by_temporal_consistency.r
# Script by David Mills
# dam203@txstate.edu
# Last Updated: March 26, 2019
# Necessary Local Files
# initial_weather_stations.csv created in Step 1.
# All files (1763-2018), decompressed, from ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/

library(dplyr)
library(data.table)

# Define and set the Working Directory
workdir <- "D:\\NOAA-Data-Experiment\\"
setwd(workdir)

# Load the datasets for stations and for year data.
df_stations <- read.csv("data/initial_weather_stations.csv", header=TRUE)
# Only keep GHCND stations.
df_stations <- df_stations[grepl("GHCND:", df_stations$id),]
# Use substring to remove the first 6 characters from the stations id column.
df_stations$id <- sub('......', '', df_stations$id)

# Set the range for the study.
startyear = 1763
lastyear = 2018

# Begin with the starting year of the study.
year = startyear

while(year < lastyear + 1)
{
  # Sets the # of days in the year. Program to check if the input year is a leap year or not.
  if((year %% 4) == 0) {
    if((year %% 100) == 0) {
      if((year %% 400) == 0) {
        days = 366
      } else {
        days = 365
      }
    } else {
      days = 366
    }
  } else {
    days = 365
  }

  df_year <- read.csv(paste0("data/raw/",year,".csv"), header=FALSE)
  
  # Add the column names for the years dataframe as indicated by the ghcn-daily-by_year-format file.
  colnames(df_year) <- c("ID","YYYYMMDD","ELEMENT","DATA","M-FLAG","Q-FLAG","S-FLAG","OBS-TIME")
  
  # Get a summary of the data in the Elements column.
  # ElementSummary <- as.data.frame(summary(df_year$ELEMENT))
  
  # Create a dataframes holding the PRCP, TMIN, TMAX, SNWD, SNOW, TOBS, and TAVG data.
  df_year_PRCP <- df_year[ which(df_year$ELEMENT=='PRCP'),]
  df_year_TMAX <- df_year[ which(df_year$ELEMENT=='TMAX'),]
  df_year_TMIN <- df_year[ which(df_year$ELEMENT=='TMIN'),]
  df_year_SNWD <- df_year[ which(df_year$ELEMENT=='SNWD'),]
  df_year_SNOW <- df_year[ which(df_year$ELEMENT=='SNOW'),]
  df_year_TOBS <- df_year[ which(df_year$ELEMENT=='TOBS'),]
  df_year_TAVG <- df_year[ which(df_year$ELEMENT=='TAVG'),]
  
  # Create a dataframe that contains all stations with PRCP data present for 365 or 366 days of the year.
  # "maxsum" is required, it defaults to 100 if it is not defined, 10000000 has been used to ensure all records are captured.
  df_year_PRCP_ID <- as.data.frame(summary(df_year_PRCP$ID, maxsum = 10000000) == days)
  colnames(df_year_PRCP_ID) <- c("BOOLEAN")
  setDT(df_year_PRCP_ID, keep.rownames = "ID")
  df_year_PRCP_ID <- as.data.frame(df_year_PRCP_ID[df_year_PRCP_ID$BOOLEAN==TRUE,])
  
  # Create a dataframe that contains all stations with TMAX data present for 365 or 366 days of the year.
  df_year_TMAX_ID <- as.data.frame(summary(df_year_TMAX$ID, maxsum = 10000000) == days)
  colnames(df_year_TMAX_ID) <- c("BOOLEAN")
  setDT(df_year_TMAX_ID, keep.rownames = "ID")
  df_year_TMAX_ID <- as.data.frame(df_year_TMAX_ID[df_year_TMAX_ID$BOOLEAN==TRUE,])
  
  # Create a dataframe that contains all stations with TMIN data present for 365 or 366 days of the year.
  df_year_TMIN_ID <- as.data.frame(summary(df_year_TMIN$ID, maxsum = 10000000) == days)
  colnames(df_year_TMIN_ID) <- c("BOOLEAN")
  setDT(df_year_TMIN_ID, keep.rownames = "ID")
  df_year_TMIN_ID <- as.data.frame(df_year_TMIN_ID[df_year_TMIN_ID$BOOLEAN==TRUE,])
  
  # Create a dataframe that contains all stations with SNWD data present for 365 or 366 days of the year.
  df_year_SNWD_ID <- as.data.frame(summary(df_year_SNWD$ID, maxsum = 10000000) == days)
  colnames(df_year_SNWD_ID) <- c("BOOLEAN")
  setDT(df_year_SNWD_ID, keep.rownames = "ID")
  df_year_SNWD_ID <- as.data.frame(df_year_SNWD_ID[df_year_SNWD_ID$BOOLEAN==TRUE,])
  
  # Create a dataframe that contains all stations with SNOW data present for 365 or 366 days of the year.
  df_year_SNOW_ID <- as.data.frame(summary(df_year_SNOW$ID, maxsum = 10000000) == days)
  colnames(df_year_SNOW_ID) <- c("BOOLEAN")
  setDT(df_year_SNOW_ID, keep.rownames = "ID")
  df_year_SNOW_ID <- as.data.frame(df_year_SNOW_ID[df_year_SNOW_ID$BOOLEAN==TRUE,])
  
  # Create a dataframe that contains all stations with TOBS data present for 365 or 366 days of the year.
  df_year_TOBS_ID <- as.data.frame(summary(df_year_TOBS$ID, maxsum = 10000000) == days)
  colnames(df_year_TOBS_ID) <- c("BOOLEAN")
  setDT(df_year_TOBS_ID, keep.rownames = "ID")
  df_year_TOBS_ID <- as.data.frame(df_year_TOBS_ID[df_year_TOBS_ID$BOOLEAN==TRUE,])
  
  # Create a dataframe that contains all stations with TAVG data present for 365 or 366 days of the year.
  df_year_TAVG_ID <- as.data.frame(summary(df_year_TAVG$ID, maxsum = 10000000) == days)
  colnames(df_year_TAVG_ID) <- c("BOOLEAN")
  setDT(df_year_TAVG_ID, keep.rownames = "ID")
  df_year_TAVG_ID <- as.data.frame(df_year_TAVG_ID[df_year_TAVG_ID$BOOLEAN==TRUE,])
  
  # Write CSV Files for permanently storing the year Data.
  write.csv(df_year_PRCP, paste0("data/",year,"_PRCP.csv"))
  write.csv(df_year_TMAX, paste0("data/",year,"_TMAX.csv"))
  write.csv(df_year_TMIN, paste0("data/",year,"_TMIN.csv"))
  write.csv(df_year_SNWD, paste0("data/",year,"_SNWD.csv"))
  write.csv(df_year_SNOW, paste0("data/",year,"_SNOW.csv"))
  write.csv(df_year_TOBS, paste0("data/",year,"_TOBS.csv"))
  write.csv(df_year_TAVG, paste0("data/",year,"_TAVG.csv"))
  
  # Add 1 to year to iterate through the years.
  year <- year + 1
}
