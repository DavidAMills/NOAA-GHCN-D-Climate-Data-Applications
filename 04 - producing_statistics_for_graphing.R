# 04 - producing_statistics_for-graphing.r
# Script by David Mills
# dam203@txstate.edu
# Last Updated: March 26, 2019
# Necessary Local Files
# Files created during Step 3.

library(matrixStats)

# Define and set the Working Directory
workdir <- "D:\\NOAA-Data-Experiment\\"
setwd(workdir)

# A list of elements to loop through for data aggregation.
elements <- list("PRCP","TMAX","TMIN","SNWD","SNOW","TOBS","TAVG")

for(i in elements)
  {
  # Choose an Element to study (TAVG, TOBS, SNOW, SNWD TMIN, TMAX, PRCP).
  element <- i
  
  # Set the range for the study.
  startyear = 1763
  lastyear = 2018
  
  # Set the year to the starting year for your study.
  year = startyear
  
  # Reads in the data for PRCP, TMAX, TMIN, SNWD, SNOW, TOBS, or TAVG.
  Stations <- read.csv(paste0("data/Stations_0_",element,".csv"))
  
  # Creates a Distribution List with the Year and Sum Total of Stations within the temporal scope, 
  # then formats and converts to a dataframe.
  Distribution <- NULL
  Distribution$Column_Names <- as.data.frame(colnames(Stations[10:265]))
  Distribution$Stations_Sum <- as.data.frame(colSums(Stations[ , 10:paste0(lastyear-startyear+10), drop = FALSE]))
  Distribution$Stations_Means <- as.data.frame(colMeans(Stations[ , 10:paste0(lastyear-startyear+10), drop = FALSE]))
  Distribution$Stations_Medians <- as.data.frame(colMedians(as.matrix(Stations[ , 10:paste0(lastyear-startyear+10), drop = FALSE])))
  Distribution <- as.data.frame(Distribution)
  names(Distribution) <- c("Year","Sums","Means","Medians")
  Distribution$Year <- substring(Distribution$Year, 2)
  
  # Creates the name for a variable to hold the sums, means, and medians for aggregation.
  SUMSnam <- paste0(element,"sums")
  MEANSnam <- paste0(element,"means")
  MEDIANSnam <- paste0(element,"medians")
  
  # Stores the sums, means, and medians data in the variable.
  assign(SUMSnam,Distribution$Sums)
  assign(MEANSnam,Distribution$Means)
  assign(MEDIANSnam,Distribution$Medians)
  }

# Bring all of the data together into a single dataframe.
graphdata <- NULL
graphdata$PRCPsums <- as.data.frame(PRCPsums)
graphdata$TMAXsums <- as.data.frame(TMAXsums)
graphdata$TMINsums <- as.data.frame(TMINsums)
graphdata$SNWDsums <- as.data.frame(SNWDsums)
graphdata$SNOWsums <- as.data.frame(SNOWsums)
graphdata$TOBSsums <- as.data.frame(TOBSsums)
graphdata$TAVGsums <- as.data.frame(TAVGsums)
graphdata$PRCPmeans <- as.data.frame(PRCPmeans)
graphdata$TMAXmeans <- as.data.frame(TMAXmeans)
graphdata$TMINmeans <- as.data.frame(TMINmeans)
graphdata$SNWDmeans <- as.data.frame(SNWDmeans)
graphdata$SNOWmeans <- as.data.frame(SNOWmeans)
graphdata$TOBSmeans <- as.data.frame(TOBSmeans)
graphdata$TAVGmeans <- as.data.frame(TAVGmeans)
graphdata$PRCPmedians <- as.data.frame(PRCPmedians)
graphdata$TMAXmedians <- as.data.frame(TMAXmedians)
graphdata$TMINmedians <- as.data.frame(TMINmedians)
graphdata$SNWDmedians <- as.data.frame(SNWDmedians)
graphdata$SNOWmedians <- as.data.frame(SNOWmedians)
graphdata$TOBSmedians <- as.data.frame(TOBSmedians)
graphdata$TAVGmedians <- as.data.frame(TAVGmedians)
graphdata <- as.data.frame(graphdata)
rownames(graphdata) <- Distribution$Year

# Write CSV Files for permanently storing the formatted data.
write.csv(graphdata, paste0("data/graphdata.csv"))