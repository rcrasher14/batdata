# experimenting with finding distance to next one

m1 <- as.numeric(na.omit(species_tables$laci$`E-FO11-ACT`))
m1m <- which(m1==1)
m1m <- c(m1m,length(m1))
m1runs <- c(m1m[1],diff(m1m))
m1m[length(m1m)] <- m1m[length(m1m)] + 1
d <- rep(m1m,m1runs)
ind <- c(1:length(m1))

distance_to_one <- d - ind

m1
distance_to_one