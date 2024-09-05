library(tidyverse)


# first we need to read in the data

d <- read.csv("data/week_2/root_data_christie_2023.csv")



# look at the structure
str(d)

# dimensions of the data?

dim(d)
nrow(d)
ncol(d)

# so there are 480 observations of 12 variables

# looks like there are 4 categorical variables we might be interested in, let's see how 
# many observations are in each of them

table(d$generation)
unique(d$treatment)
nrow(d[grepl(d$treatment, pattern = "wet"),])
nrow(d[d$treatment==wet,])
table(d$treatment)

table(d[ , c("treatment", "generation")])

d %>% 
  group_by(generation, treatment) %>% 
  summarise(mu = mean(total_biomass),
            sig = sd(total_biomass),
            se = sig/sqrt(n()),
            upr = mu + 1.96*se,
            lwr = mu - 1.96*se)



# since we are probably looking for an affect of generation and treatment, how many
# are in each combination of generation and treatment





# it looked like there were some columns 
# that had NAs, let's see how many NAs are in each column

nas <- lapply(d, function(x) sum(is.na(x)))
print(nas)
a <- apply(d, 2, function(x) sum(is.na(x)))
class(a)

# looks like there is a lot of missing data! 

# let's take a look at the total biomass column


sum(d$total_biomass == 0)




# seems there is a big spike at 0, what does it look like if we remove those
# plot a histogram of total biomass

hist(d$total_biomass)

# plot a histogram excluding the zeros

bio.0 <- subset(d, d$total_biomass != 0)

sum(bio.0$total_biomass == 0)

hist(bio.0$total_biomass)

d %>% 
  filter(total_biomass > 0) %>% 
  ggplot(aes(x = total_biomass)) +
  geom_histogram()

# we often think about size in terms of log size, let's log it!



# we will assume if total biomass = 0 that the plant did not germinate, what is the
# proportion of plants that germinated




# not great, does it seem like there is a difference between the generations?
# the treatments?



# how many entries have root and vegetative masses but no floral mass?



# what is the proportion of germinated seeds that grew flowers?



# is the germination rate different between generations in each treatment

mus <- d %>% 
  mutate(root_shoot = root_mass/veg_mass) %>% 
  drop_na(root_shoot) %>% 
  group_by(treatment, generation) %>% 
  summarise(mu = mean(root_shoot),
            se = sd(root_shoot)/sqrt(n()),
            upr = mu + 1.96*se, 
            lwr = mu - 1.96*se) 


  



d %>% 
  mutate(root_shoot = root_mass/veg_mass) %>% 
  
  drop_na(root_shoot) %>% 
  
  ggplot(aes(x = generation, y = root_shoot, fill = generation)) +
  
  geom_violin() +
  
  geom_jitter(width = .25, color = "purple") +
  theme_barbie() +
  scale_fill_manual(values = c("pink", "hotpink"))
  
  geom_errorbar(data = mus, mapping = aes(x = generation, ymax = upr, ymin = lwr), inherit.aes = F, width = .1, color = "blue") +
  
  geom_point(mus, mapping = aes(x = generation, y = mu),
             size = 4, color = "blue") +
  
  facet_wrap(treatment ~ .) +
  
  scale_fill_manual(values = c("darkslategrey", "slategray2")) +
  
  theme_light() +
  
  theme(legend.position = "none",
        panel.grid = element_blank())
  























