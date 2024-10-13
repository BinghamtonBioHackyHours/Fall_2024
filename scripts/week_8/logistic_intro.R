
# General Linear Models Recap ---------------------------------------------


# let's warm up by simulating a general linear model where the intercept and slope
# are both 0.5 and the standard deviation of the residuals is 0.75. Draw 100 x 
# values from a standard normal distribution.

n <- 100
b0 <- .5
b1 <- .5
sigma <- .75
x <- rnorm(n)

y <- rnorm(n, b0 + b1*x, sigma)


# now fit the model using lm(), and simulate 1000 estimates of the variables using
# arm::sim()

mod <- lm(y ~ 1 + x)

nrep <- 1000

library(arm)

sims <- sim(mod, nrep)


# what is the 95% confidence intervals for the coefficients b0 and b1?

quantile(sims@coef[,1], c(.025, .975))

quantile(sims@coef[,2], c(.025, .975))


# what is the 95% confidence interval of the difference of means between an
# individual with an x value of 3 and an x value of 1. Does it contain the 
# true difference of 1?

x_3 <- sims@coef[,1] + sims@coef[,2] * 3 
x_1 <- sims@coef[,1] + sims@coef[,2] * 1

diffs <- x_3 - x_1

quantile(diffs, c(.025, .975))


# now that we are warmed up, let's start talking about generalized linear models!

# we will start by imagining Allie walking along a stream and spooking anoles. 
# most of the time they dive into the water, but once in a while the run up a 
# tree. She notes that about 85% of the time, the escape into the water. Let's 
# simulate 100 anoles running away and see how many run into the water.

n <- 100
p <- .85
set.seed(5)
y <- rbinom(n, 1, p)

# what is the mean?
mean(y)


# if we remember way back, the mean is a general linear model in it's own right,
# can we use it to estimate the probability that an anole will escape by diving?

# an assumption of the general linear model is that the residuals are normally 
# distributed around the conditional mean (just the overall mean in this case).
# let's take a look at the residuals here.

hist(y - mean(y))

# NOT very normal!!!! What can we do


# Generalized Linear Models!!!! -------------------------------------------

# we can use the glm() function to fit an intercept only model here (since we
# don't have any predictors)

mod2 <- glm(y ~ 1, family = "binomial")

display(mod2)


# we have an estimate of 1.45, (remember the probability should be .85), what
# the hell does that mean? This is the log of the odds, let's explore that a bit

x <- seq(-3, 3, l = 100)
p <- plogis(x)

plot(p ~ x, type = "l", lwd = 2)

# we want to be able to use our old familiar linear prediction apparatus to try
# to predict the outcome from some predictor variables. The first step is 
# to convert probability to odds 

odds <- p/(1-p)

plot(odds ~ x, type = "l", lwd = 2)

# now we have something that extends from 0 to positive infinity, for our linear
# model we need a parameter space that extends from negative infinity to positive
# infinity, so we take the log of the odds

log_odds <- log(odds)

plot(log_odds ~ x, type = "l", lwd = 2)

# this is how we can use a linear model to predict probabilities. Our linear 
# model is predicting the log of the odds of something happening, and we can use
# the link function to translate the log-odds into probability. The inverse logit
# in R is the plogis() function.

plot(plogis(log_odds) ~ x, type = "l", lwd = 2)


# let's look at Allie's lizard example again:

display(mod2)

# if we take the inverse logit of the intercept:

plogis(1.45)

# we get a probability of .81, which is close to the truth, let's use sim()
# to get the 95% confidence interval

sims <- sim(mod2, nrep)

quantile(plogis(sims@coef[,1]), c(.025, .975))

# let's say that Allie's lizards have an overall average log-odds of fleeing
# to the water of 0.4, and the log-odds of diving increases by 1 with 
# an increase in 1 standard deviation of size.

b0 <- .4
b1 <- 1
size <- rnorm(n)
log_odds <- b0 + b1*size
p_dive <- plogis(log_odds)

dive <- rbinom(n, 1, p_dive)

# first plot it:

plot(dive ~ size)

# let's fit a model!

mod3 <- glm(dive ~ 1 + size, family = "binomial")

display(mod3)

# let's add a fit line. First, get simulated coefficients with sim()

sims <- sim(mod3, nrep)

# we need to define a continuum of size values to predict over

size_pred <- seq(-3, 3, l = 100)

# now for each in size_pred, we need to calculate the mean probability of fleeing
# to water, sapply() is the stylish way to do this in R, but we will write out
# the full for loop for the purposes of understanding.

mean_p <- c()

for(i in 1:length(size_pred)){
  p_temp <- plogis(sims@coef[,1] + sims@coef[,2] * size_pred[i])
  mean_p[i] <- mean(p_temp)
}

# now add these mean probabilities to the plot as a line
lines(mean_p ~ size_pred, lwd = 3)

# we can add the confidence intervals to the plot as well

upper_ci <- lower_ci <- c()

for(i in 1:length(size_pred)){
  p_temp <- plogis(sims@coef[,1] + sims@coef[,2] * size_pred[i])
  upper_ci[i] <- quantile(p_temp, .975)
  lower_ci[i] <- quantile(p_temp, .025)
}

lines(upper_ci ~ size_pred, lty = 3, lwd = 2)
lines(lower_ci ~ size_pred, lty = 3, lwd = 2)

# what is the 95% CI of the difference in probability between an anole 1 
# standard deviation above the mean vs one that is 1 standard deviation below?
# does it contain the true value of .45?

big <- plogis(sims@coef[,1] + sims@coef[,2]*1)
small <- plogis(sims@coef[,1] + sims@coef[,2]*-1)

quantile(big - small, c(.025, .975))


# ok, let's work with some real data. This is germination data from a study that
# Josh did

dat <- read.csv("data/week_8/germ_dat.csv")

# let's take a look

str(dat)

# the main variables of interest for this exercise are going to be 'germ' which
# is a binary variable for whether the seed germinated (1) or not (0). 'area' is
# a measure of the size of the seed, we might want to standardize this for 
# interpretation's sake. Finally cross is the cross type (i.e. a proxy for
# the genetic makeup of the individual)

# what are the questions we might be interested here?



# we are mostly interested in genetic effects (cross) and seed size effects on
# germination, so we need to deal with those variables, let's standardize area
# and turn cross into a factor. I'm gonna switch to tidyverse here

library(tidyverse)

df <- dat %>% 
  mutate(area = (area - mean(area))/sd(area),
         cross = factor(cross, levels = c("lon", "bc_lon", "f1", "f2",
                                         "bc_cal", "cal")))


# now we can fit the model, let's just do size by itself first

mod4 <- glm(germ ~ area, data = df, family = "binomial")

display(mod4)

# you know what's next, get simulations of the variables so we can make inferences!

sims <- sim(mod4, nrep)

# let's create a data set with some sizes to predict from, the mean and the
# 95% CI

area_pred <- seq(-3,3, l = 100)

mean_p <- upr <- lwr <- c()
for(i in 1:length(area_pred)){
  p_temp <- plogis(sims@coef[,1] + sims@coef[,2] * area_pred[i])
  mean_p[i] <- mean(p_temp)
  upr[i] <- quantile(p_temp, .975)
  lwr[i] <- quantile(p_temp, .025)
}

probs <- data.frame(area_pred, mean_p, upr, lwr)

# now let's plot our fitted model on the data

df %>% 
  ggplot(aes(x = area, y = germ)) +
  geom_jitter(color = "darkslategrey", alpha = .25, width = 0, height = .015) +
  geom_line(data = probs, aes(x = area_pred, y = mean_p), linewidth = 1) +
  geom_ribbon(data = probs, aes(x = area_pred, ymax = upr, ymin = lwr), alpha = .25, inherit.aes = F) +
  theme_minimal()

# what about if we are interested in the effect of cross on germination? Let's
# fit that model.

mod5 <- glm(germ ~ cross + area - 1, data = df, family = "binomial")

display(mod5)

# you know what's next!!!!

sims <- sim(mod5, nrep)
head(sims@coef)

# what is the distribution and 95% CI in the probability of germination between
# cal and f2 crosses? Use the mean size of each cross to calculate the 
# probabilities.

mu_cal <- mean(df$area[df$cross=="cal"])
mu_f2 <- mean(df$area[df$cross=="f2"])

p_cal <- sims@coef[,6] + sims@coef[,7] * mu_cal %>% plogis()
p_f2 <- sims@coef[,4] + sims@coef[,7] * mu_f2 %>% plogis()

diffs <- p_cal - p_f2

hist(diffs)
quantile(diffs, c(.025, .975))
abline(v = quantile(diffs, c(.025, .975)), col = "red", lwd = 2)

# it seems that the f2 has a higher probability of germinating than cal, 
# unexpected!!!