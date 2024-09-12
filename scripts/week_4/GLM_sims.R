
# A little simulation practice! -------------------------------------------

#You're a wildlife researcher studying a particular species of squirrels in a large forest. Each day, you observe this species of squirrels as it searches for acorns. Based on past observations, you know that each squirrel has a 67% chance of finding an acorn on a given search attempt. You decide to see how successful your squirrels are in collecting acorns over the course of 30 attempts. Simulate 50 days of squirrel observations where squirrels try to find acorns 30 times a day.

#How about another one?

#You are studying a rare species of bird that only lands on a specific island. You set up camp for a few weeks and record how many birds land in an hour. The rate at which they land is a little unpredictable, but previous research suggests approximately 7 birds land per hour. Let's simulate this event to see how often you might expect a different number of bird landings in any given hour over 150 hours.

# The Mean as a Linear Model ----------------------------------------------

##Let's start by installing/downloading the different packages we might need:
#libraries:
library(lme4)
library(Matrix)
library(dplyr)
library(ggplot2)
library(tidyverse)

#Let's simulate some data and run a t-test.

set.seed(5) # allows us to create reproducible results when writing code that involves variables that take on random values (i.e. guarantees we get the same random values every time you run the code)

#Turns out a t-test is a linear model - this is a little more obvious when we run a two sample t-test. Let's take a look at that before we jump into linear modeling!


# Simulate data for Group A (n = 30) with mean = 50 and standard deviation = 5


# Simulate data for Group B (n = 30) with mean = 55 and standard deviation = 5


# Combine data into a data frame


# Perform a two-sample t-test


# View the results


#Now, let's look at it the way we usually think about linear models and compare to our one sample t.test


#Looks like we get the same estimate for the mean from t.test and lm. Let's take a look at our confidence intervals:


#Again, the same confidence intervals! The t-test is a linear model where the model is the mean of the data!


##A little more simulation practice if we have time!

#You are researching the growth rates of two populations 40 of deer living in two different regions. Region A is a lush forest and region B is grassland. You want to determine if the average weight of deer in region A is significantly different from region B. Deer in region A have an average weight of 150kg with a standard deviation of 10kg. Deer in region B have an average weight of 140kg with a standard deviation of 12 kg. Use this information to simulate data and run a two sample t-test.


# Getting even more complicated! ------------------------------------------

#What about ANOVA? We use ANOVA to test for the differences in means of multiple groups. Let's see if we can write that into our linear model framework.


# The Linear Model --------------------------------------------------------

#We've worked with data coming from one or multiple categories, what if our output variable is related to some continuous variable. This lead to our traditional linear regression model:

##Let's simulate it!


#Now that we are experts, let's simulate based on a prompt!

#You are an ecologist studying how the number of flowers in a meadow is influenced by sunlight and rainfall. You want to understand if more sunlight causes more flowers to appear and how rain may impact that relationship. Simulate data from 50 different meadows with varying amounts of sunlight and rainfall and build a linear model to predict the number of flowers based on these environmental factors. Let's assume each meadow has a mean of 8 hours of sunlight a day with a standard deviation of two hours and a mean of 100mm of rainfall with a standard deviation of 20mm.

#Note: when simulating the number of flowers in each meadow, assume the sunlight increases flowers, but rainfall has an effect.

#set seed for reproducibility
set.seed(100)

# But can we make it *more* general?
#It turns out the general linear model is a special form of the **generalized** linear model
#There are three components to a generalized linear model:
#1.  A stochastic component
#2.  A structural component (Josh likes deterministic better, but you will see structural in the literature)
#3.  A link function
