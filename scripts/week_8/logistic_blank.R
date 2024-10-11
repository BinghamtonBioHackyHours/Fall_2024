
# General Linear Models Recap ---------------------------------------------


# let's warm up by simulating a general linear model where the intercept and slope
# are both 0.5 and the standard deviation of the residuals is 0.75. Draw 100 x 
# values from a standard normal distribution.








# now fit the model using lm(), and simulate 1000 estimates of the variables using
# arm::sim()









# what is the 95% confidence intervals for the coefficients b0 and b1?







# what is the 95% confidence interval of the difference of means between an
# individual with an x value of 3 and an x value of 1. Does it contain the 
# true difference of 1?









# now that we are warmed up, let's start talking about generalized linear models!

# we will start by imagining Allie walking along a stream and spooking anoles. 
# most of the time they dive into the water, but once in a while the run up a 
# tree. She notes that about 85% of the time, the escape into the water. Let's 
# simulate 100 anoles running away and see how many run into the water.







# what is the mean?







# if we remember way back, the mean is a general linear model in it's own right,
# can we use it to estimate the probability that an anole will escape by diving?

# an assumption of the general linear model is that the residuals are normally 
# distributed around the conditional mean (just the overall mean in this case).
# let's take a look at the residuals here.









# NOT very normal!!!! What can we do


# Generalized Linear Models!!!! -------------------------------------------

# we can use the glm() function to fit an intercept only model here (since we
# don't have any predictors)










# we have an estimate of 1.45, (remember the probability should be .85), what
# the hell does that mean? This is the log of the odds, let's explore that a bit










# we want to be able to use our old familiar linear prediction apparatus to try
# to predict the outcome from some predictor variables. The first step is 
# to convert probability to odds 








# now we have something that extends from 0 to positive infinity, for our linear
# model we need a parameter space that extends from negative infinity to positive
# infinity, so we take the log of the odds











# this is how we can use a linear model to predict probabilities. Our linear 
# model is predicting the log of the odds of something happening, and we can use
# the link function to translate the log-odds into probability. The inverse logit
# in R is the plogis() function.









# let's look at Allie's lizard example again with display():



# if we take the inverse logit of the intercept:









# we get a probability of .81, which is close to the truth, let's use sim()
# to get the 95% confidence interval











# let's say that Allie's lizards have an overall average log-odds of fleeing
# to the water of 0.4, and the log-odds of diving increases by 1 with 
# an increase in 1 standard deviation of size.









# first plot it:







# let's fit a model!







# let's add a fit line. First, get simulated coefficients with sim()








# we need to define a continuum of size values to predict over










# now for each in size_pred, we need to calculate the mean probability of fleeing
# to water, sapply() is the stylish way to do this in R, but we will write out
# the full for loop for the purposes of understanding.









# now add these mean probabilities to the plot as a line






# we can add the confidence intervals to the plot as well









# what is the 95% CI of the difference in probability between an anole 1 
# standard deviation above the mean vs one that is 1 standard deviation below?
# does it contain the true value of .45?







# Analyzing Germination Data ----------------------------------------------




# ok, let's work with some real data. This is germination data from a study that
# Josh did








# let's take a look









# the main variables of interest for this exercise are going to be 'germ' which
# is a binary variable for whether the seed germinated (1) or not (0). 'area' is
# a measure of the size of the seed, we might want to standardize this for 
# interpretation's sake. Finally cross is the cross type (i.e. a proxy for
# the genetic makeup of the individual)

# what are the questions we might be interested here?



# we are mostly interested in genetic effects (cross) and seed size effects on
# germination, so we need to deal with those variables, let's standardize area
# and turn cross into a factor. I'm gonna switch to tidyverse here









# now we can fit the model, let's just do size by itself first







# you know what's next, get simulations of the variables so we can make inferences!








# let's create a data set with some sizes to predict from, the mean and the
# 95% CI









# now let's plot our fitted model on the data










# what about if we are interested in the effect of cross on germination? Let's
# fit that model.






# you know what's next!!!!







# what is the distribution and 95% CI in the probability of germination between
# cal and f2 crosses? Use the mean size of each cross to calculate the 
# probabilities.










# it seems that the f2 has a higher probability of germinating than cal, 
# unexpected!!!