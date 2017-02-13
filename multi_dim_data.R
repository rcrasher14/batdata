### Scripts experimenting with a 3 dimensional matrix 'za' with dimensions [a,b,c]
# where a=date, b=instance,c=species

# This assumes you source the 'setup.r' script which includes user defined functions.

# BACKGROUND:  Each instance is a set of observations over time for a given device.
# If a species was observed as present for a given date, then that species' data
# column will =1.  If presence of the species was not observed on that date,
# then the data column will =0.  


###Initial setup, data import, user functions imported:
#setwd("H:/Personal/VTech Research")  # Work filepath
setwd("~/VTech Research")  # home filepath
source('./scripts/setup.R')

library(plyr)
library(reshape2)

# Data without the samp.occ variable
testdata <- subset(data, select=-samp.occ)

# Melt the data into long format
mtestdata <- melt(testdata, id.vars = c("instance", "date","area"))

# Create za matrixwith dimensions [a,b,c]
# where a=date, b=instance,c=species
za <- acast(mtestdata, date ~ instance ~ variable)



### Now create a list with a table for each species########################
species_tables <- lapply(species, function(x) as.data.frame(za[,,x]))
names(species_tables) <- species  # add the species names to the list
# Iterate over cool to get zero run lengths for each species table
species_zeros <- lapply(species_tables,list_zero_lengths)
# Now a really cool boxplot!
boxplot(lapply(species_zeros,unlist), 
        main="Boxplot by Species",
        ylab="Number of Nights Between Presence"
        ) # One plot with a box for each species
# Create a list with an ecdf object for each species table from cool
species_ecdf <- lapply(species_zeros,function(x) ecdf(unlist(x)))
plot(species_ecdf$laci, 
     main="ECDF of Nights Between Presence-LACI",
     xlab="Number of Nights Between Presence",
     ylab="Probability Density"
     ) # CDF plot for laci across all observations

#plot them all and save as individual .png files
lapply(species, function(x){
  name <- toString(x)
  filename <- paste("./plots/",name,".png",sep="")
  png(filename)
  plot(species_ecdf[[x]], 
       main=c("ECDF of Nights Between Presence--",toupper(name)),
       xlab="Number of Nights Between Presence",
       ylab="Probability Density"
  )
  dev.off()
})

# Or what about all in one plot pane:
par(mfrow=c(3,3))
lapply(species, function(x){
  name <- toString(x)
  plot(species_ecdf[[x]], 
       main=toupper(name),
       xlab="Number of Nights Between Presence",
       ylab="Probability Density"
  )
})




### Now let's slice za by instance#########################################
# Now create a list with a table for each species
instance_tables <- lapply(instance, function(x) as.data.frame(za[,x,]))
names(instance_tables) <- instance  # add the species names to the list
# Iterate over cool to get zero run lengths for each instance table
instance_zeros <- lapply(instance_tables,list_zero_lengths)
# Now a really cool boxplot!
boxplot(lapply(instance_zeros,unlist), 
        main="Boxplot By Instance",
        ylab="Number of Nights Between Presence",
        las=3, # rotate x-axis labels to vertical
        cex.axis=.75 # shrink x-axis labels
) # One plot with a box for each instance
# Create a list with an ecdf object for each instance table from cool
instance_zeros1 <- subset(instance_zeros, select=-'E-NR10-ACT')
instance_ecdf <- lapply(instance_zeros[-6],function(x) ecdf(unlist(x)))
plot(instance_ecdf$`E-FO11-ACT`, 
     main="ECDF of Nights Between Presence-E-FO11-ACT",
     xlab="Number of Nights Between Presence",
     ylab="Probability Density"
) # CDF plot for E-FO11-ACT across all species