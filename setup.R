# Setup Scripts for analyzing data from Sabrina for her Virgina Tech (vtech) research
#### David Williams, 24 January 2017 ####
# File Structure: assumes a working directory with 3 sub folders:
#   ./data
#   ./plots
#   ./scripts
### Final output of this script is a data frame called 'data' for analysis
# as well as a list for: species names, instance names, and dates.


###Initial data import:
data <- read.csv("./data/bdd testing all.csv") # import data from .csv derived from bdd

###Data Prep:
# Need to create a factor variable that denotes the observation instance.
# I use the uid column minus the date information 
# (example: 'E-FO11-ACT' instead of 'E-FO11-ACT 2016-05-27')
instance <- sapply(data[,1], as.character) # force dates column to type 'character'
instance <- substr(instance,1,nchar(instance)-11) # delete date info from instance
data <- cbind(instance,data) # add instance column to dataset
data <- subset(data, select=-uid) # drop uid column since it is redundant
names(data)[2] <- "date"  # rename "night_date.x" column to "date"
data$date <- as.Date(data$date, "%m/%d/%Y") # Force the date column to be of type date
species <- colnames(data)[5:ncol(data)] # create vector with species names
instance <- unique(instance) # remove duplicates from instance vector
dates <- unique(data[,2]) # create date vector

# Sourcing homegrown scripts for later:
source('./scripts/vtech_functions.r')