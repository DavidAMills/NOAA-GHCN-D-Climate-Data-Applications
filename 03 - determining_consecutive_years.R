# 03 - determining_consecutive_years.r
# Script by David Mills
# dam203@txstate.edu
# Last Updated: March 26, 2019
# Necessary Local Files
# initial_weather_stations.csv created in Step 1.
# All files created during Step 2.

library(dplyr)
library(data.table)

# Define and set the Working Directory
workdir <- "D:\\NOAA-Data-Experiment\\"
setwd(workdir)

# Set the range for the study.
startyear = 1763
lastyear = 2018

# Choose the percent of the stations days that can be missing data.
missingdays = 0

# Begin with the starting year of the study.
year = startyear

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

# Calculates the days necessary for the percentage selected.
days <- days - missingdays

# Reads in the initial weather stations.
Stations <- read.csv("data/initial_weather_stations.csv")
# Only keep GHCND stations.
Stations <- Stations[grepl("GHCND:", Stations$id),]
# Use substring to remove the first 6 characters from the stations id column.
Stations$id <- sub('......', '', Stations$id)

# Create the list of elements.
list_elements <- list("PRCP","TMAX","TMIN","SNWD","SNOW","TOBS","TAVG")

# Repeats these steps for all elements.
for(element in list_elements)
{
# Reads in the first year in the studies temporal scope.
CurrentYear <- read.csv(paste0("data/",year,"_",element,".csv"))

# Create a dataframe that contains all stations with r;r,rmy data present for 365 or 366 days of the year.
# "maxsum" is required, it defaults to 100 if it is not defined, 10000000 has been used to ensure all records are captured.
CurrentYear <- as.data.frame(summary(CurrentYear$ID, maxsum = 10000000) >= days)
# Rename the column to BOOLEAN.
colnames(CurrentYear) <- c("BOOLEAN")
# Change the Rowname which contains the ID to a column called ID.
setDT(CurrentYear, keep.rownames = "ID")
# Only keep true values (the ones containing the desired amount of days.)
CurrentYear <- as.data.frame(CurrentYear[CurrentYear$BOOLEAN==TRUE,])

# Creates a column with 1's for present and 0's for not to track consecutive years using the CurrentYear.
Stations[, as.character(year)] <- as.integer(Stations$id %in% CurrentYear$ID)

# Iterates to the next year.
year <- year + 1

while(year <= lastyear)
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
  
  # Reads in the first year in the studies temporal scope.
  CurrentYear <- read.csv(paste0("data/",year,"_",element,".csv"))
  
  # Create a dataframe that contains all stations with r;r,rmy data present for 365 or 366 days of the year.
  # "maxsum" is required, it defaults to 100 if it is not defined, 10000000 has been used to ensure all records are captured.
  CurrentYear <- as.data.frame(summary(CurrentYear$ID, maxsum = 10000000) == days)
  # Rename the column to BOOLEAN.
  colnames(CurrentYear) <- c("BOOLEAN")
  # Change the Rowname which contains the ID to a column called ID.
  setDT(CurrentYear, keep.rownames = "ID")
  # Only keep true values (the ones containing the desired amount of days.)
  CurrentYear <- as.data.frame(CurrentYear[CurrentYear$BOOLEAN==TRUE,])
  
  # Creates a column with 1's for present and 0's for not present to track consecutive years using the CurrentYear.
  Stations[, as.character(year)] <- as.integer(Stations$id %in% CurrentYear$ID)
  
  # Adds the previous year to the current year.
  Stations[, as.character(year)] <- Stations[, as.character(year)] + Stations[, as.character(year - 1)]
  
  # Sets current year back to 0 if it was 0 before adding the rows together.
  Stations[, as.character(year)] <- ifelse(Stations[, as.character(year)] == Stations[, as.character(year - 1)], 0, Stations[, as.character(year)])
  
  # Add 1 to year to iterate through the years.
  year <- year + 1
}

Stations <- Stations[!rowSums(Stations[10:265])==0, ]

write.csv(Stations, paste0("data/Stations_",missingdays,"_",element,".csv"), row.names=FALSE)
}
