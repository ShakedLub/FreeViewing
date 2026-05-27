# Load required R packages
library(afex) # for ANOVA
library(emmeans) # for follow up analysis
library(ggeffects) # for plotting
library(stats)
library(lme4)
library(tidyverse)
library(dplyr)
library(ggplot2)

## Fixation duration is checked for all fixations on objects and background
## Fixation count is checked for all fixations on objects and background and zero count is given to each object that was not
## viewed, and the background if it was not viewed

## *When eccintrity_obj is included fixation count is checked for all fixations on objects (fixations on background are not included
## because they do not have eccentricity_obj) and also zero count is given to each object that was not
## viewed

# clear workspace
rm(list=ls())

#Get the functions
source('./Scripts/Functions.R')

#set random number generator
set.seed(1)

# effects coding so that the anova results will be valid
options(contrasts=c('contr.sum', 'contr.poly'))

#load data
data=read.csv("./Data/FixationDurationAndCountControlAnalysis1.csv")
#data=read.csv("./Data/FixationDurationAndCountControlAnalysis2.csv")

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
data_fix_count=data

#create data for conscious condition and unconscious condition sepsratly
data_fix_dur_U=filter(data_fix_dur, session == 1)
data_fix_dur_C=filter(data_fix_dur, session == 2)
data_fix_count_U=filter(data_fix_count, session == 1)
data_fix_count_C=filter(data_fix_count, session == 2)

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

mat = matrix(ncol = 2, nrow = 1)
results_fix_count_U=data.frame(mat)
colnames(results_fix_count_U)<-c("param_name","p_ROI_size")

mat = matrix(ncol = 2, nrow = 1)
results_fix_count_C=data.frame(mat)
colnames(results_fix_count_C)<-c("param_name","p_ROI_size")

# Mixed effects model ========
############### fixation duration ###############
results_fix_dur_U=fixDurMixedModel(data_fix_dur_U,results_fix_dur_U)
results_fix_dur_C=fixDurMixedModel(data_fix_dur_C,results_fix_dur_C)

############### fixation count ###############
results_fix_count_U=fixCountMixedModel(data_fix_count_U,results_fix_count_U)
results_fix_count_C=fixCountMixedModel(data_fix_count_C,results_fix_count_C)

## FDR ========
p=p.adjust(cbind(results_fix_dur_U[2:4],results_fix_dur_C[2:4],results_fix_count_U[2],results_fix_count_C[2]),method="fdr")
results_fix_dur_U["p_eccentricity_fix_fdr"]=p[1]
results_fix_dur_U["p_sacc_amp_fdr"]=p[2]
results_fix_dur_U["p_ROI_size_fdr"]=p[3]

results_fix_dur_C["p_eccentricity_fix_fdr"]=p[4]
results_fix_dur_C["p_sacc_amp_fdr"]=p[5]
results_fix_dur_C["p_ROI_size_fdr"]=p[6]

results_fix_count_U["p_ROI_size_fdr"]=p[7]

results_fix_count_C["p_ROI_size_fdr"]=p[8]
