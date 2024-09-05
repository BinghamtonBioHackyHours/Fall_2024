
# first we need to read in the data

d <- read.csv("data/week_2/root_data_christie_2023.csv")


# look at the structure
str(d)

# dimensions of the data?

dim(d)

# so there are 480 observations of 12 variables

# looks like there are 4 categorical variables we might be interested in, let's see how 
# many observations are in each of them

table(d$population)
table(d$generation)
table(d$maternal_line)
table(d$treatment)

# since we are probably looking for an affect of generation and treatment, how many
# are in each combination of generation and treatment

table(d[, c("generation", "treatment")])



# it looked like there were some columns 
# that had NAs, let's see how many NAs are in each column

apply(d, 2, function(x) sum(is.na(x)))

# looks like there is a lot of missing data! 

# let's take a look at the total biomass column

hist(d$total_biomass)


# seems there is a big spike at 0, what does it look like if we remove those

hist(d$total_biomass[d$total_biomass>0])

# we often think about size in terms of log size, let's log it!

hist(log(d$total_biomass[d$total_biomass>0]))

# we will assume if total biomass = 0 that the plant did not germinate, what is the
# proportion of plants that germinated

sum(d$total_biomass > 0)/nrow(d)


# not great, does it seem like there is a difference between the generations?
# the treatments?

library(tidyverse)

d %>% 
  group_by(generation) %>% 
  summarise(germ = sum(total_biomass>0)/n())

d %>% 
  group_by(treatment) %>%
  summarise(germ = sum(total_biomass>0)/n())

# how many entries have root and vegetative masses but no floral mass?

sum(d$total_biomass>0 & is.na(d$floral_mass))

# what is the proportion of germinated seeds that grew flowers?

sum(!is.na(d$floral_mass))/sum(d$total_biomass>0)

# is the germination rate different between generations in each treatment

d %>% 
  group_by(treatment, generation) %>% 
  summarise(germ = sum(total_biomass>0)/n(),
            n = n())


d %>% 
  mutate(root_shoot = root_mass/veg_mass) %>% 
  drop_na(root_shoot) %>% 
  ggplot(aes(x = generation, y = root_shoot)) +
  geom_jitter(width = .25)
