# play around with the distribution functions for the normal, 
# binomial, and poisson distributions

# sample 1000 obs from a normal with a mean of 5 and
# standard dev of 10
z <- rnorm(n = 1000,mean = 5,sd = 10)

# plot histogram of z
hist(z)

# is the sd of z close to 10?
sd(z)

# is the mean of z close to 10?
mean(z)


# create a vector from 1:1000
ind <- 1:length(z)

# from 1:length of z, calculate the mean of each sub  
# sample of 1:length z
mus <- sapply(ind, function(d) mean(z[1:d]))


# plotting the vector of means against the number of values in the vector
plot(mus~ind, type = "l")

# add a value (5) for the true mean
abline(h = 5, col = 'red')

# plotting the probability density function for a 
# normal dist with mean of 5 and sd of 10
curve(dnorm(x, 5, 10), from = -30, to = 40, lwd = 2)

# what is the probability of a value being less than 
# 20?
pnorm(q = 20, mean = 5, sd = 10)

# monte carlo approx of the probability of z being 
# above 20
sum(z<20)/1000

# same as above but more than 20
pnorm(q = 20,mean = 5,sd = 10, lower.tail = F)

# same as above but greater than 20
sum(z>20)/1000

# play with the binomial function a bit

# simulate 10 genotypes at unlinked bi-allelic loci at a frequency of .5
# 0 represents one homozygote, 1 represents the heterozygote, 2 represents
# the opposite homozygote
rbinom(n = 10, size = 2,prob = .5)

# probability of getting exectly 100 heads out of 200 tosses
dbinom(x = 100, size = 200, prob = .5)

# approximate this with rbinom
sum(rbinom(1e4, 200, .5) == 100)/1e4


# plot the probability mass function for the binomial distribution with
# n = 200 and p = .5
j <- 1:200
plot(dbinom(j, size = 200, prob = .5) ~ j, type = "l", lwd = 3)
# plot the minimum and the maximum from a 1000 samples from this distribution
samps <- rbinom(1000, 200, .5)
abline(v = c(min(samps), max(samps)), col = "red", lwd = 2)


# mess with the poisson a little, demonstrate that the mean == variance
r <- rpois(n = 1000, 10)
hist(r)
mean(r)
var(r)

# probability that with a Poisson distribution where lambda = 10, the value will
# be greater than 15
ppois(q = 15, lambda = 10, lower.tail = F)

# check the approximation from the sample above
sum(r>15)/1000


# simulation challenges!

# n.b. all stats about African wild dogs are vibes based and not necessarily 
# real (other than the first one, they really do have a success rate of about
# 85%!!!)



# African wild dogs have one of the highest hunting success rates,
# at least among cursorial predators. They are successful on about 85%
# of hunts. You are going to the field to observe 10 wild dog hunts.
# Simulate a series of 10 independent hunts.

rbinom(10, 1, .85)

# if you just wanted the sum of succesful hunts you could use:
rbinom(1,10, .85)



# the expected value of a binomial distribution is n*p, so for 10 hunts
# the mean of a binomial process with p = .85 is 8.5. The variance is n*p*(1-p)
# so for this process it is 1.275. Simulate 1000 sets of 10 hunts. What
# is the mean and variance, how does it compare to the values above?


# 1000 sets of 10 hunts
e <- rbinom(1000, size = 10, .85)
# mean number of succeses
mean(e)
# variance in the number of succeses
var(e)


# let's say a pack will be in serious physiological trouble if it fails in
# 3 or more hunts out of 10. What is the probability of a pack failing
# in 3 or more hunts out of 10. First simulate 1000 sets of 10 hunts to approximate this
# probability, compare to what you get using pbinom()

# proportion of e less than or equal to 7
sum(e <= 7)/1000
# analytical probability of having 7 or fewer
pbinom(q = 7, size = 10, prob = .85)



# You are curious about how many hunts a pack would go through, on average
# before failing in two consecutive hunts. Write a function 
# to simulate this process. hint: use a while loop that runs until the
# pack fails twice in a row.

fail_twice <- function(){
  hunts <- rbinom(n = 2, size = 1, prob = .85)
  i <- 2
  while(hunts[i] + hunts[i-1] > 0){
    hunts[i + 1] <- rbinom(1, 1, .85)
    i <- i + 1
  }
  
  length(hunts)
}

fail_twice()


# simulate 1000 series of hunts until the pack fails twice in a row.
# what is the mean, the standard deviation of this random variable?

# 1000 simulations of the number of hunts till 2 failures
a <- replicate(1000, fail_twice())
# plot histogram
hist(a)
# mean
mean(a)
# standard deviation
sd(a)

# what is the probability that the pack will go 100 hunts or longer
# before it fails twice in a row

# proportion of simulations where the pack hunted 100 times or more before failing twice
sum(a >= 100)/1000


# make a figure that plots the cumulative probability of a pack taking n hunts 
# to get 2 failures.

# make a vector of 2 to the maximum number of hunts in the sample
num_hunts <- 2:max(a)
# calculate the probability that the pack takes x or lower number of hunts
# to fail twice
p_s <- sapply(num_hunts, function(x) sum(a<=x)/1000)
# plot the cumulative probability
plot(p_s ~ num_hunts, type = "l", lwd = 2, ylab = "Cumulative Probability",
     xlab = "Number of Hunts Until 2 Failures")


# Let's say we are observing a pack that hunts primarily wildebeests. 
# if the pack is hunting a wildebeest that is less than 1 standard deviation
# in size above the mean, the pack is successful 90% of the time. But if the
# wildebeest is larger, the pack only succeeds 30% of the time. If the pack
# chooses a wildebeest randomly with regard to size, how many hunts out
# of 10 will the pack succeed in? Simulate 1000 sets of 10 hunts.


# simulate the wildibeest that the pack chooses (need 1000*10 for 1000 simulations
# of 10 hunts each)
w_size <- matrix(rnorm(1000*10), ncol = 1000)
# if the wildebeest has size greater than 1 prob = .3 else .9
probs <- ifelse(w_size > 1, .3, .9)
# simulate the outcome of the hunts, iterating over each column of probs
hunts <- apply(probs, 2, function(x) rbinom(n = 1, size = 10, prob = x))
# plot the simulations
hist(hunts)
# calculate mean and variance
mean(hunts)
var(hunts)

# The average temperature during the time of year your are doing field
# work is 93. However the weather is predicted to be cooler than average
# for the time you are supposed to be there. The predicted temperatures
# for the period are a mean of 88 degrees with an uncertainty 
# (in standard deviations) of 4 degrees. Because the prey tires relatively
# faster at higher temperatures than the pack does, the probability of a
# successful hunt is .95 when the temperature is greater than 93 and .75 
# when it is lower than 93. Given the weather forecast, what do you
# predict the success rate in 10 hunts for your pack will be?

# very similar to above, just different distributions
temperature <- matrix(rnorm(1000*10, mean = 88, sd = 4), ncol = 1000)
# convert to probabilities of success
probs <- ifelse(temperature > 93, .95, .75)
# simulate hunts
hunts <- apply(probs, 2, function(x) rbinom(n = 1, size = 10, prob = x))
# plot the simulations
hist(hunts)
# calculate mean and variance
mean(hunts)
var(hunts)
