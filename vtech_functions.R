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