# Scripts for analyzing data from Sabrina for her Virgina Tech (vtech) research
#### David Williams, 25 January 2017 ####

###Initial setup, data import, user functions imported:
setwd("C:/Users/David/Documents/VTech Research")
source('setup.r')


### All bdd.csv data--across all nights
# This reads each species column as one continuous observation period.
# Probably not that useful since it will be skewed by consecutive periods with no observations.
# But it was worth a try.
# This would be more worthwhile after trimming zeros from end of each instance.

dataall <- data[species] # isolate to only data columns, dropping instance info

rledata <- lapply(dataall,rle) # perform rle on all items in the dataall list
negatives <- lapply(rledata, function(x) which(x$values==0)) # find indicies of zeros in rle$values
# Now we pull the rle$lengths values at the indicies where rle$values = 0.
zerolengthsall <- lapply(names(rledata), function(i) rledata[[i]]$lengths[negatives[[i]]])

names(zerolengthsall) <- names(rledata) #put the names back for species
# Visualize with a bloxplot
boxplot(zerolengthsall)



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


### Next let's work towards rle objects for each instance of one species:
# looking at only 'laci'
z <- dcast(mtestsmall, date ~ instance + variable, subset=.(variable=="laci"))
lz <- as.list(z) # force into type list
lz <- lapply(lz[-1],na.omit) # trim down to just the observed nights for each instance


# Now we need to handle the cases where we don't have a positive presence at the
# end of an instance.
# See 'vtech_functions.r' for definition of function 'trim_zeros'
lzi <- lapply(lz,trim_zeros) # now trim the trailing zeros of our instances
list_rle_lz <- lapply(lzi, function(x) rle(as.vector(x))) # and rle each one

# Now do what we did above for one observation across all species, but this time
# do it across all instances for one species
negatives <- lapply(list_rle_lz, function(x) which(x$values==0))
zeros_lzi <- lapply(names(list_rle_lz), function(i) list_rle_lz[[i]]$lengths[negatives[[i]]])
names(zeros_lzi) <- names(list_rle_lz) #put the names back for species

# Now let's visualize these results:
boxplot(zeros_lzi) # A boxplot for each instance of this species
# And if you want to consider all instances in one set, consolidate them per below:
boxplot(unlist(zeros_lzi), 
        main="LACI - Boxplot of Nights Between Presence",
        ylab="Nights")
        ) # One boxplot for consolidated dataset across all instances
plot(ecdf(unlist(zeros_lzi)), 
     main="LACI - ECDF of Nights Between Presence",
     xlab="Number of Nights Between Presence",
     ylab="Probability Density")
     ) # One ecdf plot for consolidated dataset