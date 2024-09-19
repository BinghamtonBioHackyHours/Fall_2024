
# Loading in Data and Necessary Libraries ---------------------------------

fly <- read.csv("Fall 2024/Fall 2024 Data/Fly_example_HH.csv", header = T)

#libraries:
library(lme4)
library(Matrix)
library(dplyr)
library(ggplot2)
library(tidyverse)

# Data Exploration --------------------------------------------------------

#Prior to regression, we need to get to know our data. Let's take a look at the structure of everything.


#all of the names of our columns are capitalized - we can change them if we want or keep it the same, up to you!

#One change we want to make right away is that SEX, IND, GENOTYPE, TREAT, REP, and GROUP should all be factors. Here, we want them to be factors since the actual numbers hold no meaning! They are placeholders for identifiers.


#Let's check to see if we have any missing data values in our DT column.


#This is interesting! Any NA values we have in our DT column suggest that those flies never developed to adulthood (they didn't emerge). Let's create new columns that tell us whether or not an individual fly emerged, as well as the proportion that emerged.

#create a column that is 0,1 for whether adult emerged (emerged = 1, didn't = 0)
#based on NA or time in DT column


#Now, we want to be able to count the number of offspring that have emerged for each REP vial
#Create a column to be a unique indicator of REP, then use aggregate() to count the number emerged. Then, use match to put that in a new column (Num_Emerged).

#create a column that includes the GENOTYPE_TREAT_GROUP_REP (GTGR)

#now create a new data frame that will sum the number of flies that emerged based on that new identifier. Take a minute to learn about the aggregate() function.


#Awesome! Now we have our new columns for whether flies emerged and the number of flies that emerged based on the genotype, treatment, and group.

# Taking a closer look at the data ----------------------------------------

#One of the assumptions of linear modeling is that the data is normally distributed. Let's see if our Development time (DT) is roughly normal.

#looks normal enough!

#Lets look for any outliers/trends we might be interested in


# T-testing ---------------------------------------------------------------

#A in this case is our control, and C seems to be very different from A. Let's subset our data and run a t test to check the relationship


#combining them into a single data frame so we can run the t-test the way that makes it look like a linear model.



#running t-test with separate data frames - gives us same values as above.

#These end up being the same!
#looks like there is a significant difference between treatments A and C when it comes to overall development time.

#saving it as tt


#linear model like last time where we only want the intercept


#What is another t.test we could run based on our data?



# ANOVA -------------------------------------------------------------------

#Since we have so many different Treatments/genotypes, it makes more sense to use ANOVA to compare them.


# Linear Modeling ---------------------------------------------------------

#Now that we've looked at some simple models with our data, let's investigate by adding some predictors. Say we want to investigate whether both Treatment and Genotype impact DT. Generate a linear model that would allow us to test for that.


#something cool we can do with ANOVA is test if a term we've added to one of our models is significantly impacting the data. In this case, we already have a model where we just look at treatment, lets use ANOVA to see if the addition of genotype is really significant.


#Let's say we are interested in understanding if SEX and TREAT have an impact on development time. Generate a linear model with both variables and then use anova to compare it to mod2.aov.



#Since we have such a significant p-value for the above tests, we could imagine subsetting our data by treatment and seeing if SEX has a significant effect based on that subset. Let's try that just with Treatments A and C since we already have those values


##Try subsetting by the other two treatments and check to see if sex is a significant influence on DT in those scenarios.


#we could also fall down the rabbit hole of subsetting by sex in order to see how the different sexes respond to the treatment gradient.


#let's start with a female model

#now males

##What if we want to model with a binary variable?  --------------------

#Earlier, I had you create a binary variable for whether or not individual flies emerged. We can use this to run binary logistic regression! This type of regression models how the odds of "success" (in this case, emergence) depend upon our set of explanatory variables.

#Let's run a model to see if TREAT has an affect on whether a fly emerged.
#in this case, we can't use lm(). Our dependent variable in this example is binary, so we have to fit a generalized linear model and tell R that we want the family of the model to = "binomial"


#Now, let's do the same thing but use genotype.


# Interactions ------------------------------------------------------------

#interactions: association of predictors conditional on other predictors. Here are some conceptual examples:
#1) Influence of sugar in coffee depends on stirring.
#2) influence of a gene on a phenotype depends on the environment

#Interpreting interactions is HARD. The presence of an interaction indicates that the effect of one predictor variable on the response variable is different at different values of the other predictor variable.

#Let's model how the interaction between treatment and sex affects development time of our flies.

#lets use anova to compare our model with our interaction to our model without the interaction to see if our interaction term is significant.



#What if we do this with genotype?



#What if we add a genotype by sex interaction?



#Challenge: Make a linear model testing the affect of TREAT, SEX, GENOTYPE, and GROUP on fly development time, compare it to a model witout GROUP, and interpret the results.


# If Extra Time -----------------------------------------------------------

#At the beginning, I made you make a column with proportion of flies emerged investigate if there is a relationship between the number of flies emerged and the different genotypes, sexes, and treatments.



#Is there a group affect? We could fall down tons of rabbit holes while investigating our data with linear models!
