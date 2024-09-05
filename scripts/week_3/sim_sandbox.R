# play around with the distribution functions for the normal, 
# binomial, and poisson distributions



# n.b. all stats about African wild dogs are vibes based and not necessarily 
# real (other than the first one, they really do have a success rate of about
# 85%!!!)



# African wild dogs have on of the highest hunting success rates,
# at least among cursorial predators. They are successful on about 85%
# of hunts. You are going to the field to observe 10 wild dog hunts.
# Simulate a series of 10 independent hunts.



# the expected value of a binomial distribution is n*p, so for 10 hunts
# the mean of a binomial process with p = .85 is 8.5. The variance is n*p*(1-p)
# so for this process it is 1.275. Simulate 1000 sets of 10 hunts. What
# is the mean and variance, how does it compare to the values above?



# let's say a pack will be in serious physiological trouble if it fails in
# 3 or more hunts out of 10. What is the probability of a pack failing
# in 3 or more hunts out of 10. First simulate 1000 hunts to approximate this
# probability, compare to what you get using pbinom()



# You are curious about how many hunts a pack would go through, on average
# before failing in two consecutive hunts. Write a function 
# to simulate this process. hint: use a while loop that runs until the
# pack fails twice in a row.



# simulate 1000 series of hunts until the pack fails twice in a row.
# what is the mean, the standard deviation of this random variable?


# what is the probability that the pack will go 100 hunts or longer
# before it fails twice in a row


# make a figure that plots the cumulative probability of a pack taking n hunts 
# to get 2 failures.



# Let's say we are observing a pack that hunts primarily wildebeests. 
# if the pack is hunting a wildebeest that is less than 1 standard deviation
# in size above the mean, the pack is successful 90% of the time. But if the
# wildebeest is larger, the pack only succeeds 30% of the time. If the pack
# chooses a wildebeest randomly with regard to size, how many hunts out
# of 10 will the pack succeed in? Simulate 1000 sets of 10 hunts.




# The average temperature during the time of year your are doing field
# work is 93. However the weather is predicted to be cooler than average
# for the time you are supposed to be there. The predicted temperatures
# for the period are a mean of 88 degrees with an uncertainty 
# (in standard deviations) of 4 degrees. Because the prey tires relatively
# faster at higher temperatures than the pack does, the probability of a
# successful hunt is .95 when the temperature is greater than 93 and .75 
# when it is lower than 93. Given the weather forecast, what do you
# predict the success rate in 10 hunts for your pack will be?