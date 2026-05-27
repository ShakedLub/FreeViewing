# Load required R packages
library(afex) # for ANOVA
library(emmeans) # for follow up analysis
library(ggeffects) # for plotting
library(stats)
library(lme4)
library(tidyverse)
library(dplyr)
library(ggplot2)

# clear workspace
rm(list=ls())

#Get the functions
source('./Scripts/Functions.R')

#set random number generator
set.seed(1)

# effects coding so that the anova results will be valid
options(contrasts=c('contr.sum', 'contr.poly'))

#load data
#data=read.csv("./Data/FixationDurationAndCountControlAnalysis1.csv")
data=read.csv("./Data/FixationDurationAndCountControlAnalysis2.csv")

#Prepare data
data$participant=as.factor(data$participant)
data$session=as.factor(data$session) # visibilityCondition: 1 U, 2 C 
data$image_name=as.factor(data$image_name)

#calculate log duration
data$log_fixation_duration=log10(data$fixation_duration)

#create table for fixation duration analysis without fixation_count=0
#counts that were added for obects that were not viewed
#and the background if it was not viewed
data_fix_dur=filter(data, fixation_count == 1)

#create data for conscious condition and unconscious condition sepsratly
data_fix_dur_U=filter(data_fix_dur, session == 1)
data_fix_dur_C=filter(data_fix_dur, session == 2)

# Person mean centering
data_fix_dur_U=addPersonMeanCentering(data_fix_dur_U)
data_fix_dur_C=addPersonMeanCentering(data_fix_dur_C)

#initialize results dataframe
mat = matrix(ncol = 4, nrow = 1)
results_fix_dur_U=data.frame(mat)
colnames(results_fix_dur_U)<-c("param_name","p_eccentricity_fix","p_sacc_amp","p_ROI_size")

mat = matrix(ncol = 4, nrow = 1)
results_fix_dur_C=data.frame(mat)
colnames(results_fix_dur_C)<-c("param_name","p_eccentricity_fix","p_sacc_amp","p_ROI_size")

# Mixed effects model ========
############### fixation duration ###############
results_fix_dur_U=fixDurMixedModel(data_fix_dur_U,results_fix_dur_U)
results_fix_dur_C=fixDurMixedModel(data_fix_dur_C,results_fix_dur_C)

## FDR ========
p=p.adjust(cbind(results_fix_dur_U[2:4],results_fix_dur_C[2:4]),method="fdr")
results_fix_dur_U["p_eccentricity_fix_fdr"]=p[1]
results_fix_dur_U["p_sacc_amp_fdr"]=p[2]
results_fix_dur_U["p_ROI_size_fdr"]=p[3]

results_fix_dur_C["p_eccentricity_fix_fdr"]=p[4]
results_fix_dur_C["p_sacc_amp_fdr"]=p[5]
results_fix_dur_C["p_ROI_size_fdr"]=p[6]
