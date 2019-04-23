# 05 - determining_years_with_thirty_and_producing_location_files.r
# Script by David Mills
# dam203@txstate.edu
# Last Updated: April 22, 2019
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
  
  # Create empty variables for to store information from the for loop collecting names/locations.
  Names <- NULL
  Longitude <- NULL
  Latitude <- NULL

  # For loop that runs through every column (year)
  for(i in 1:256)
    {
    # i + 9 to start at column 10, the first year.
    i <- i + 9
    # Grabs the column name and stores it as the year.
    year[i-9] <- colnames(Stations[i])
    # Adds every station in each year with greater than or equal to 30 years of consecutive data.
    morethanthirty[i-9] <- sum(Stations[i] >= 30)
    
    # Used for tracking the Names position in the soon to be newly created array to hold names per year.
    z <- 1
    
    # The loop runs to check every row of data for a value greater than 30 for the year identified in script 05, 1907.
    for(x in 1:nrow(Stations))
    {
      # Checks the year column for all rows to see if the consecutive years is greater than or equal to thirty.
      if(Stations[x,i] >= 30)
      {
        # If it is, stores the Name, Longitude, and Latitude.
        Names[z] <- as.character(Stations$name[i])
        Longitude[z] <- as.character(Stations$longitude[i])
        Latitude[z] <- as.character(Stations$latitude[i])
        # z + 1 to go to the next row in case there are more stations with 30+ years.
        z <- z + 1
      }
    }
    
    # Creates a Names dataframe with the Names, then adds the Latitude and Longitudes.
    Names_Loc <- as.data.frame(Names)
    Names_Loc$Names <- as.character(Names)
    Names_Loc$Latitude <- Latitude
    Names_Loc$Longitude <- Longitude
    
    # If there is at least 1 stations with 30+ years of consecutive data.
    if(nrow(Names_Loc) >= 1)
      {
      # Write CSV Files for permanently storing the formatted data.
      write.csv(Names_Loc,paste0("data/Stations_ClimateReady_",element,"_",year[i-9],".csv"))
      
      # Reset Names_Loc dataframe back to zero.
      Names_Loc <- NULL
      }
    }
  # Create the dataframe starting with the year variable.
  YearlyGreaterThanThirty <- as.data.frame(year)
  # Add the counts column.
  YearlyGreaterThanThirty$Count <- morethanthirty

  # Write the CSV for each element.
  write.csv(YearlyGreaterThanThirty,paste0("data/Stations_Thirty_",element,".csv"))
  }
