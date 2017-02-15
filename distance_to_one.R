### Scripts to calculate the distance to the nearest positive presence night,
# or "1", for each night in a given set of data.

# This assumes you source the 'setup.r' script which includes user defined functions,
# and that you've set up the za matrix and the species_tables list
# from the 'multi_dim_data.R' script.

# It maintains NAs and date data from raw data.
# If the last observation is not a 1, then the algorithm acts as if the
# next night after the instance would have been a 1, and calculates the distance
# to it, such that an instance with all zeros would still have a distance value
# for each night.

### Example for one species:
laci_dist <- list_distance_to_one(species_tables$laci)

### A list across all species:
all_dist_to_one <- lapply(species_tables,list_distance_to_one)