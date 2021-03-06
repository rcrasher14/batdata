# Function to trim off zero entries at the end of a vector/list
# Input: vector or list
# Output: Vector or list, but with zeros removed from the end
#         such that the last value is a non-zero value.
trim_zeros <- function(x){
  rl <- rle(as.vector(x))
  if(tail(rl$values,1) == 0) {
    x <- head(x, -tail(rl$lengths,1))
  }
  return(x)
}


# Function to find the lengths of the zero runs in a given vector
# Input: vector or list
# Output: list of the lengths where the values of the rle() of the vector
#           equal zero.
zero_lengths <- function(x){
  xrle <- rle(as.vector(x))
  negatives <- which(xrle$values==0)
  zeros <- xrle$lengths[negatives]
  names(zeros) <- names(x)
  return(zeros)
}


# Function to iterate over a list, returning a list with the lengths
# of the zero runs for each element in the provided list.
# Input: list
# Output: list of the zero lengths for each item from the provided list.
list_zero_lengths <- function(x){
  x <- lapply(x,na.omit)
  x <- lapply(x,as.numeric)
  x <- lapply(x,trim_zeros)
  x_zeros <- lapply(x,zero_lengths)
  return(x_zeros)
}


# Function to generate vector with distance to next one.
# Input: vector
# Output: vector with distance to next ones
distance_to_one <- function(x){
  input <- x[!is.na(x)]  # calculate from instance nights only
  input_ones <- which(input==1) # Find 1's--vectors with only 0's are handled later
  # Add length so that we have a vector with the indices of each one, and the last index
  input_ones <- c(input_ones,length(input))
  # Now create a vector with the distance between ones(and the final index if != 1)
  if(length(input_ones)!=0){ # if there is a 1, then use them
    runs <- c(input_ones[1],diff(input_ones))
  } else{ # handle the case where there are no 1's and simply run to the end
    runs <- input_ones
  }
  # increment the final index to just outside the dataset
  # so that the final diff value is 1 not zero--as if the next value would have equaled 1
  input_ones[length(input_ones)] <- input_ones[length(input_ones)] + 1
  # now create a vector mirroring input, but with the index of the next one
  # or the last index, whatever is sooner.
  d <- rep(input_ones,runs)
  # fabricate a set of indices
  ind <- c(1:length(input))
  dist_to_one <- d - ind # Calculate the distance to ones
  x[!is.na(x)]<-dist_to_one # replace non-NA values in x with dist_to_one
  return(x)
}

# Function to iterate over a list, returning distance to next ones
# Input: list
# Output: dataframe of distance to one vectors
list_distance_to_one <- function(x){
  ldist <- lapply(x,distance_to_one) # Loop over list elements
  rtn <- as.data.frame(ldist) # Coerce into a dataframe
  row.names(rtn)<-dates # reapply date data
  return(rtn)
}
