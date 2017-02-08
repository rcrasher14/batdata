# Scripts for analyzing data from Sabrina for her Virgina Tech (vtech) research
#### David Williams, 25 January 2017 ####

###Initial setup, data import, user functions imported:
setwd("H:/Personal/VTech Research")
source('setup.r')




# Now to melt this data and see what else we can do
library(plyr)
library(reshape2)

# Here without the samp.occ variable
testsmall <- subset(data, select=-samp.occ)

# Melt the data into long formate
mtestsmall <- melt(testsmall, id.vars = c("instance", "date","area"))

# Now for some interesting ways to summarize the data:
# Total positive days by instance
total_positive_across_instances <- dcast(mtestsmall, instance ~ variable, sum)
num_nights_per_instance         <- dcast(mtestsmall, instance ~ variable, length)
# Total positive days by date
total_positive_across_dates     <- dcast(mtestsmall, date ~ variable, sum)
num_instances_per_date          <- dcast(mtestsmall, date ~ variable, length)