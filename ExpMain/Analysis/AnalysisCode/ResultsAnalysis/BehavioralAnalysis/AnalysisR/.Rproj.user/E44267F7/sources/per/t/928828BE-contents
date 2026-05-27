# Load required R packages
library(brms) 
library(dplyr)
library(cmdstanr)
library(bayestestR)

#Parameters
ExpNumber = 1
seed=1

set.seed(seed)

#load data
if (ExpNumber == 1) {
  data=read.csv("./Data/ObjectiveDataExp1.csv")
} else if (ExpNumber == 2) {
  data=read.csv("./Data/ObjectiveDataExp2.csv")
}

#Organize variables 
data$subject_id <- factor(data$subject_id) #factorize variables
data$condition <- factor(data$condition,  #factorize variables
                               levels=c(1,2))

#divide to conscious and unconscious data
dataU=filter(data, condition == 1)
dataC=filter(data, condition == 2)

#Initialize results struct
mat = matrix(ncol = 5, nrow = 2)
Results=data.frame(mat)
colnames(Results)<-c("Condition","Median","HDI_Low","HDI_High","PD")

#summarize data
mean_part_U <- dataU %>%
  group_by(subject_id) %>%
  summarise(mean_is_correct = mean(is_correct, na.rm = TRUE),
            median_is_correct = median(is_correct, na.rm = TRUE))

mean_part_C <- dataC %>%
  group_by(subject_id) %>%
  summarise(mean_is_correct = mean(is_correct, na.rm = TRUE),
            median_is_correct = median(is_correct, na.rm = TRUE))

#Model options
options(mc.cores = parallel::detectCores())
options(brms.backend = "cmdstanr") #better than rstan, needs specific installation 

#set non-inforamtive prior
pri_correct <- c(
  set_prior("normal(0, 1.5)", class = "Intercept"),     #non informative, prior for intercept with mean 0.5 and very large SD (the numbers are in log odds)
  set_prior("exponential(1)",   class = "sd")           #subject variability, random effect (prior that is commonly used)
)

######################## Unconscious condition ########################
brm_awareness <- brm(
  is_correct ~1+(1|subject_id),
  data = dataU, 
  family = bernoulli,
  prior = pri_correct,
  backend = "cmdstan", #USE rstan if you don't install cmdstan
  chains = 4, iter = 4000, warmup = 2000, seed = 2025,
  refresh = 50
)

# present plots of all parameters: intercept and sigma of random effect
plot(brm_awareness)

#Probability of direction
p=pd(brm_awareness)

#Get HDI for a specific parameter (results are in log odds)
post_samplesU <- as.data.frame(brm_awareness)
h=hdi(post_samplesU$Intercept) 

#Get median (results are in log odds)
s=describe_posterior(brm_awareness, ci = 0.95, test = "pd")

#posterior predictive check- checks the results I have in comparison to results that are hypothesized
pp_check(brm_awareness)

#Save Results
#Parameters about the intercept:
# 1) range of parameters with 95%HDI (when normal dist 95% CI and 95% HDI are the same) - shows width of distribution
# 2) median 
# 3) Probability of direction, how much of the distribution is above 0.5 ideal this will be 50% 
Results$Condition[1]='U'
Results$Median[1]=1/(1+exp(-s$Median))
Results$HDI_Low[1]=1/(1+exp(-h$CI_low))
Results$HDI_High[1]=1/(1+exp(-h$CI_high))
Results$PD[1]=p$pd

######################## Conscious condition ########################
brm_awareness <- brm(
  is_correct ~1+(1|subject_id),
  data = dataC, 
  family = bernoulli,
  prior = pri_correct,
  backend = "cmdstan", #USE rstan if you don't install cmdstan
  chains = 4, iter = 4000, warmup = 2000, seed = 2025,
  refresh = 50
)

# present plots of all parameters: intercept and sigma of random effect
plot(brm_awareness)

#Probability of direction
p=pd(brm_awareness)

#Get HDI for specific parameter (results are in log odds)
post_samplesC <- as.data.frame(brm_awareness)
h=hdi(post_samplesC$Intercept) 

#Get median (results are in log odds)
s=describe_posterior(brm_awareness, ci = 0.95, test = "pd")

#posterior predictive check- checks the results I have in comparison to results that are hypothesized
pp_check(brm_awareness)

#Save Results
#Parameters about the intercept:
# 1) range of parameters with 95%HDI (when normal dist 95% CI and 95% HDI are the same) - shows width of distribution
# 2) median 
# 3) Probability of direction, how much of the distribution is above 0.5 ideal this will be 50% 
Results$Condition[2]='C'
Results$Median[2]=1/(1+exp(-s$Median))
Results$HDI_Low[2]=1/(1+exp(-h$CI_low))
Results$HDI_High[2]=1/(1+exp(-h$CI_high))
Results$PD[2]=p$pd

if (ExpNumber == 1) {
  write.csv(Results, file = paste0("./Output/Results1.csv")) 
  write.csv(post_samplesU, file = paste0("./Output/post_samplesU1.csv"))
  write.csv(post_samplesC, file = paste0("./Output/post_samplesC1.csv"))
} else if (ExpNumber == 2) {
  write.csv(Results, file = paste0("./Output/Results2.csv")) 
  write.csv(post_samplesU, file = paste0("./Output/post_samplesU2.csv"))
  write.csv(post_samplesC, file = paste0("./Output/post_samplesC2.csv"))
}

