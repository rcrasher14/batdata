### Scripts to remove trailing zeros from instance data
# This assumes you've sourced the 'setup.r' script which includes user defined functions.
# Each instance is a set of observations over time for a given device.
# If a species was observed as present for a given date, then that species' data
# column will =1.  If presence of the species was not observed on that date,
# then the data column will =0.  The goal of these scripts is to remove NAs
# from anywhere in an instance, and any zeros at the end of an instance.

###Initial setup, data import, user functions imported:
setwd("H:/Personal/VTech Research")
source('setup.r')

library(plyr)
library(reshape2)

# without the samp.occ variable
testdata <- subset(data, select=-samp.occ)

# Melt the data into long format
mtestdata <- melt(testdata, id.vars = c("instance", "date","area"))

# Cast the data into a list with date as the row, instance+species as the columns
data_trim <- dcast(mtestdata, date ~ instance + variable)

# For each column, drop any NA values
data_trim <- lapply(data_trim[-1],na.omit)
data_trim <- lapply(data_trim,trim_zeros) # loop over data_trim, removing zeros from each list item

remove(mtestdata,testdata) # drop interim variables from memory



### Now just for fun, let's do some plotting on our results###########################
# Do the rle trick, and plot the zeros of the consolidated set
data_trim <- lapply(data_trim,as.numeric) # force to type numeric
data_zeros <- lapply(data_trim,zero_lengths) # find zero lengths for each entry

# Now for some visualizations:
# Note, these are the plots for the entire data set across all
# species and instances, after zeros have been removed.
# These plots excludes instances where presence was never established.
boxplot(unlist(data_zeros), 
        main="Nights Between Presence-All",
        ylab="Nights"
        ) # boxplot of zeros across all trimmed instances across all species
plot(ecdf(unlist(data_zeros)), 
     main="ECDF of Nights Between Presence-All",
     xlab="Number of Nights Between Presence",
     ylab="Probability Density"
     ) # ecdf of zeros across all trimmed instances across all species