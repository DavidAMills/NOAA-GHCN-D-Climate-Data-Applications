# 05 - determining_which_years_have_thirty.r
# Script by David Mills
# dam203@txstate.edu
# Last Updated: April 20, 2019
# Necessary Local Files
# Files created during Step 3.

# Define and set the Working Directory
workdir <- "D:\\NOAA-Data-Experiment\\"
setwd(workdir)

# A list of elements to loop through for data aggregation.
elements <- list("PRCP","TMAX","TMIN","SNWD","SNOW","TOBS","TAVG")

# Create an empty variable for future variable storage.
Stations <- as.data.frame(NULL)

# Choose an Element to study (TAVG, TOBS, SNOW, SNWD TMIN, TMAX, PRCP).
for(element in elements)
  {
  # Store the location and name of the current element data.
  nam <- paste0("data/Stations_0_",element,".csv")
  
  # Import the Stations_element CSV to a dataframe.
  Stations <- read.csv(nam)

  # Remove all of the "X" characters from the column names for the years.
  names(Stations)[10:265] <- gsub("[^0-9\\.]", "", colnames(Stations[10:265]))
  
  year <- NULL
  morethanthirty <- NULL

  for(i in 1:256)
    {
    i <- i + 9
    year[i-9] <- colnames(Stations[i])
    morethanthirty[i-9] <- sum(Stations[i] >= 30)
    }

  # Creates an empty variable for combining output.
  YearlyGreaterThanThirty <- as.data.frame(year)
  YearlyGreaterThanThirty$Count <- morethanthirty

  write.csv(YearlyGreaterThanThirty,paste0("data/Stations_Thirty_",element,".csv"))
}
