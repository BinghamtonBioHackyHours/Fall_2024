fert <- read.csv("data/CrossFertility_180607.csv")

View(fert)

boxplot(fert$Seed.set ~ fert$mother.species)

boxplot(fert$Seed.set ~ fert$treatment)

boxplot(fert$Seed.set ~ fert$female)
library(lme4)
library(tidyverse)

# Convert characters to factors with tidyverse
fert <- fert %>%
  mutate(female = as.factor(female), mother.species = as.factor(mother.species), treatment = as.factor(treatment), total = normal + deformed + aborted)
# And add a column for total seeds

# Or do it one at a time in base R
# fert$female <- as.factor(fert$female)

# If you don't specify a family, it will default to Gaussian, which is inappropriate
# Need to include weights because just giving a proportion doesn't tell how many trials it's out of. So if there were 2 trials, a proportion of 50% would be not confident, whereas a proportion of 50% with 1000 trials would show much tighter confidence intervals.
mod1 <- glmer(Seed.set ~ (1|female), data = fert, family = "binomial", weights = total)
mod1
# The results are in logit - log of odds of being successful. Need plogis to convert to probability

ranef(mod1)
# Add these values to the fixed effects mean from the model to get expected values for each mother.

hist(rnorm(1000, .6586, .6507))
abline(v = as.numeric(ranef(mod1)) + .6586)

# Add in effect of species
mod2 <- glmer(Seed.set ~ (1|female) + mother.species - 1, data = fert, family = "binomial", weights = total)
mod2
ranef(mod2)

library(arm)
sims <- sim(mod2, 1000)
head(sims@fixef)

dioica <- plogis(sims@fixef[,1])
latifolia <- plogis(sims@fixef[,2])

hist(dioica - latifolia)

mod3 <- glm(Seed.set ~ female -1 + mother.species, data = fert, weights = total)
mod3

mod4 <- glmer(Seed.set ~ (1|female) + mother.species -1 + treatment -1 + mother.species*treatment -1, data = fert, family = "binomial", weights = total)
mod4
arm::display(mod4)

sim2 <- sim(mod4, 1000)
head(sim2@fixef)
dd <- plogis(sim2@fixef[,1])
ld <- plogis(sim2@fixef[,2])
hist(dd-ld)

dl <- plogis(sim2@fixef[,1] + sim2@fixef[,3]) 
hist(dd-dl)
ll <- plogis(sim2@fixef[,2] + sim2@fixef[,3] + sim2@fixef[,5])
hist(ll-ld)