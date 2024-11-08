# Analysis of cross fertility and pollen competition
# Data from: Rahmé, Widmer & Karrenberg (2009), Journal of Evol. Biol. 22, 1637-1943
# Sophie Karrenberg
# June 2018

setwd("~/Documents/Sophie/Projects/MANUSCRIPTS/ms in prep/Reproductive barriers Silene/Supplementary material/Dryad upload")

# data & packages####
fert <- read.csv("CrossFertility_180607.csv")
str(fert)

library(lme4)
library(lsmeans)
library(boot)

#lmer for seed set####

#SD, extract means####
#data for mixed pollination excluded, 
mod <- lmer(Seed.set ~ treatment +(1|female), 
  data=fert[(fert$treatment=="D.pollen" | fert$treatment=="L.pollen") & fert$mother.species=="Dioica",])

plot(mod)
qqnorm(resid(mod))
qqline(resid(mod))
anova(mod)

(fert.SD <- summary(lsmeans(mod, pairwise~treatment, adjust="fdr", type="r"))$lsmeans)



#SL, extract means####
#data for mixed pollination excluded, 
mod <- lmer(Seed.set ~ treatment +(1|female), 
            data=fert[(fert$treatment=="D.pollen" | fert$treatment=="L.pollen") & fert$mother.species=="Latifolia",])

plot(mod)
qqnorm(resid(mod))
qqline(resid(mod))
anova(mod)

(fert.SL <- summary(lsmeans(mod, pairwise~treatment, adjust="fdr", type="r"))$lsmeans)




#extract means for both spp for  no intercept model####
fert$comb <- paste(fert$treatment, fert$mother.species, sep=".")

mod <- lmer(Seed.set ~ comb -1 + (1|female), 
            data=fert[(fert$treatment=="D.pollen" | fert$treatment=="L.pollen") ,])


(summary(mod)$coef-> current.coef)

#functions for RI index, rel. to within spp seed set

#comparison against SD
RI.seedset.SD.SDfSLm <- function(x) {
  summary(x)$coef -> current.coef
  current.coef/current.coef[1,1] -> current.coef
  1-2*(current.coef[3,1]/current.coef[1,1])/((current.coef[3,1]/current.coef[1,1])+(current.coef[1,1]/current.coef[1,1]))}


bt <- bootMer(mod, RI.seedset.SD.SDfSLm, nsim=1000, type="parametric")
ci <- boot.ci(bt, type="perc")
ci$t0 
ci$percent[4:5] 


RI.seedset.SD.SLfSDm <- function(x) {
  summary(x)$coef -> current.coef
  current.coef/current.coef[1,1] -> current.coef
  1-2*(current.coef[2,1]/current.coef[4,1])/((current.coef[2,1]/current.coef[4,1])+(current.coef[1,1]/current.coef[1,1]))}


bt <- bootMer(mod, RI.seedset.SD.SLfSDm, nsim=1000, type="parametric")
ci <- boot.ci(bt, type="perc")
ci$t0 
ci$percent[4:5]


#comparison against SL

RI.seedset.SL.SDfSLm <- function(x) {
  summary(x)$coef -> current.coef
  1-2*(current.coef[3,1]/current.coef[1,1])/((current.coef[3,1]/current.coef[1,1])+(current.coef[4,1]/current.coef[4,1]))}


bt <- bootMer(mod, RI.seedset.SL.SDfSLm, nsim=1000, type="parametric")
ci <- boot.ci(bt, type="perc")
ci$t0 
ci$percent[4:5]

RI.seedset.SL.SLfSDm <- function(x) {
  summary(x)$coef -> current.coef
  1-2*(current.coef[2,1]/current.coef[4,1])/((current.coef[2,1]/current.coef[4,1])+(current.coef[4,1]/current.coef[4,1]))}


bt <- bootMer(mod, RI.seedset.SL.SLfSDm, nsim=1000, type="parametric")
ci <- boot.ci(bt, type="perc")
ci$t0 
ci$percent[4:5]



#pollen competition####

PC <- read.csv("PollenComp_180607.csv")
str(PC)

#estimate means
mod <- lm(prop.heterosp ~ mother.sp, data=PC)
par(mfrow=c(2,2))
plot(mod)
confint(lsmeans(mod, type="r", ~mother.sp))


mod <- lm((1-prop.heterosp) ~ mother.sp, data=PC)
par(mfrow=c(2,2))
plot(mod)
confint(lsmeans(mod, type="r", ~mother.sp))

#means from model without intercept
mod <- lm(prop.heterosp ~ mother.sp-1, data=PC)


# seed prod of SDf with SL pollen (=hybrids) against  SD pollen (=1-hybrids on SD = conspecific)

RI.PC.SD.SDfSLm <- function(x,n) {
  mod <- lm(x[n] ~ PC$mother.sp-1)
  coef(mod) -> current.coef
  1-2*(current.coef[1]/0.5)/(((1-current.coef[1])/0.5)+(current.coef[1]/0.5))}

boot(data=PC$prop.heterosp,RI.PC.SD.SDfSLm , R=1000, strata=PC$mother.sp) -> bootPC
boot.ci(bootPC)
bootPC$t0

#siring success of SD pollen on SL (=hybrids) over  siring success on SD (=1-hybrids on SD = conspecific)
RI.PC.SD.SLfSDm <- function(x,n) {
  mod <- lm(x[n] ~ PC$mother.sp-1)
  coef(mod) -> current.coef
  1-2*(current.coef[2]/0.5)/(((1-current.coef[1])/0.5)+(current.coef[2]/0.5))}

boot(data=PC$prop.heterosp,RI.PC.SD.SLfSDm , R=1000, strata=PC$mother.sp) -> bootPC
boot.ci(bootPC)
bootPC$t0

# seed prod of SLf with SD pollen (=hybrids) against  SL pollen (=1-hybrids on SL = conspecific)
RI.PC.SL.SLf.SDm <- function(x,n) {
  mod <- lm(x[n] ~ PC$mother.sp-1)
  coef(mod) -> current.coef
  1-2*(current.coef[2]/0.5)/(((1-current.coef[2])/0.5)+(current.coef[2]/0.5))}
boot(data=PC$prop.heterosp,RI.PC.SL.SLf.SDm , R=1000, strata=PC$mother.sp) -> bootPC
boot.ci(bootPC)
bootPC$t0

#siring success of SL pollen on SD (=hybrids) over siring success on SL (=1-hybrids on SL = conspecific)

RI.PC.SL.SDf.SLm <- function(x,n) {
  mod <- lm(x[n] ~ PC$mother.sp-1)
  coef(mod) -> current.coef
  1-2*((current.coef[1])/0.5)/(((1-current.coef[2])/0.5)+(current.coef[1]/0.5))}
boot(data=PC$prop.heterosp,RI.PC.SL.SDf.SLm , R=1000, strata=PC$mother.sp) -> bootPC
boot.ci(bootPC)
bootPC$t0


