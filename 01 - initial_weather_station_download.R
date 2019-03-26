# 01 - initial_weather_station_download.r
# Script by David Mills
# dam203@txstate.edu
# Last Updated: March 26, 2019

library(httr)
library(jsonlite)
library(dplyr)

# Define and set the Working Directory
workdir <- "D:\\NOAA-Data-Experiment\\"
setwd(workdir)

# Your token for accessing data on NOAA.
token = "ENTER YOUR TOKEN HERE"

# Set the limit of how many records you would like to download at once (max: 1000)
limit = 1000
# Because the limit is 1000, the offset is set to 1000 + 1 to download the next 1000 records
# until all records have been accumulated.
offset = limit + 1

# Only download stations with data available after the year posted here, you can use a starting and ending year for a range.
startyear = 1000
endyear = 2018

# Fetch all available stations in Texas - https://www.ncdc.noaa.gov/cdo-web/webservices/v2
source <- paste0("https://www.ncdc.noaa.gov/cdo-web/api/v2/stations?limit=",limit,"&startdate=",startyear,"-01-01&enddate=",endyear,"-12-31") 

# Runs GET to get the records requested.
response <- GET(source, add_headers(token = token))

# Not actually fetching all datasets, but rather a list of all datasets
raw <- content(response, as="text")
results <- fromJSON(raw)

# Convert to dataframe/tibble
df_temp <- results$results %>% as_tibble()

# Set iterative value to 1 (1 dataframe downloaded).
i = 1

# Naming the standardized sequential  storage of dataframes.
nam <- paste("df_", i, sep="")

# Puts df_temp in standardized sequential storage dataframe.
assign(nam, df_temp)

# Run the loop to gather data if all results are not gathered within the limit.
while(nrow(df_temp) == limit)
{
  # Set iterative value to + 1 (represents the dataframe being downloaded).
  i = i + 1
  
  # Fetch stations - https://www.ncdc.noaa.gov/cdo-web/webservices/v2
  source <- paste0("https://www.ncdc.noaa.gov/cdo-web/api/v2/stations?limit=",limit,"&offset=",offset,"&startdate=",startyear,"-01-01&enddate=",endyear,"-12-31") 
  
  # Runs GET to get the records requested.
  response <- GET(source, add_headers(token = token))
  
  # Gathering a list in JSON containing datasets.
  raw <- content(response, as="text")
  results <- fromJSON(raw)
  
  # Convert to dataframe/tibble
  df_temp <- results$results %>% as_tibble()
  
  # Naming the standardized sequential  storage of dataframes.
    nam <- paste("df_", i, sep="")
  
  # Puts df_temp in standardized sequential storage dataframe.
  assign(nam, df_temp)
  
  # Add the size of the limit to the offset to grab the next set of data.
  offset <- offset + limit
}

# Combines everything that was just downloaded into a list, and then rbind's as a single dataframe.
listofdf <- lapply(paste0("df_", 1:i), function(df) get(df))
df_combined <- do.call(rbind, listofdf)

write.csv(df_combined,"initial_weather_stations.csv", row.names=FALSE)
