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
  
  # Create empty variables for storage of the year and 
  # the count of stations with more than 30 years of data per year.
  year <- NULL
  morethanthirty <- NULL

  # For loop that runs through every column (year)
  for(i in 1:256)
    {
    # i + 9 to start at column 10, the first year.
    i <- i + 9
    # Grabs the column name and stores it as the year.
    year[i-9] <- colnames(Stations[i])
    # Adds every station in each year with greater than or equal to 30 years of consecutive data.
    morethanthirty[i-9] <- sum(Stations[i] >= 30)
    }

  # Create teh dataframe starting with the year variable.
  YearlyGreaterThanThirty <- as.data.frame(year)
  # Add the counts column.
  YearlyGreaterThanThirty$Count <- morethanthirty

  # Write the CSV for each element.
  write.csv(YearlyGreaterThanThirty,paste0("data/Stations_Thirty_",element,".csv"))
}
