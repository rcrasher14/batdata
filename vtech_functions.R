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
distance_to_one <- function(input){
  #input <- as.numeric(na.omit(input))
  input_ones <- which(input==1)
  input_ones <- c(input_ones,length(input))
  runs <- c(input_ones[1],diff(input_ones))
  input_ones[length(input_ones)] <- input_ones[length(input_ones)] + 1
  d <- rep(input_ones,runs)
  ind <- c(1:length(input))
  dist_to_one <- d - ind
  return(dist_to_one)
}

# Function to iterate over a list, returning distance to next ones
# Input: list
# Output: list of distance to one vectors
list_distance_to_one <- function(x){
  ldist <- lapply(x,distance_to_one)
  # Need to figure out how to maintain the date data found in the input
  # row.names.  Trying sapply with use.names=T
  #ldist <- sapply(x,distance_to_one,simplify=F,USE.NAMES = T)
  return(ldist)
}
