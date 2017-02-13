### Scripts to calculate the distance to the nearest positive presence night,
# or "1", for each night in a given set of data.

# This assumes you source the 'setup.r' script which includes user defined functions,
# and that you've set up the za matrix and the species_tables list
# from the 'multi_dim_data.R' script.

### Example for one species:
laci_dist <- list_distance_to_one(species_tables$laci)

### A list across all species:
all_dist_to_one <- lapply(species_tables,list_distance_to_one)


# Current issues:
# 1) how to keep julian calendar data fo reach item?
# 2) how to handle NA data?  or what about zeros at the tail of an instance?