addPersonMeanCentering = function (data) {
  # add means for Person mean centering calculation
  # x_grand overall mean
  # x_image mean of each image
  # x_part mean of each participant
  
  # calculate x_image
  mean_image <- data %>%
    group_by(image_name) %>%
    summarise(mean_eccentricity_fix = mean(eccentricity_fix, na.rm = TRUE),
              mean_sacc_amp = mean(sacc_amp, na.rm = TRUE))
  
  # calculate x_part
  mean_part <- data %>%
    group_by(participant) %>%
    summarise(mean_eccentricity_fix = mean(eccentricity_fix, na.rm = TRUE),
              mean_sacc_amp = mean(sacc_amp, na.rm = TRUE))
  
  # calculate x_grand
  eccentricity_fix_grand_mean=mean(data$eccentricity_fix, na.rm = TRUE)
  sacc_amp_grand_mean=mean(data$sacc_amp, na.rm = TRUE)
  
  #add averages to data
  # add x_image
  imageNames=levels(as.factor(data$image_name))
  for (ii in 1:length(imageNames)) { #images
    im=imageNames[ii]
    data$eccentricity_fix_image[data$image_name==im]=mean_image$mean_eccentricity_fix[mean_image$image_name==im]
    data$sacc_amp_image[data$image_name==im]=mean_image$mean_sacc_amp[mean_image$image_name==im]
  }
  
  # add x_part
  partNum=levels(as.factor(data$participant))
  for (ii in 1:length(partNum)) { #participants
    part=partNum[ii]
    data$eccentricity_fix_part[data$participant==part]=mean_part$mean_eccentricity_fix[mean_part$participant==part]
    data$sacc_amp_part[data$participant==part]=mean_part$mean_sacc_amp[mean_part$participant==part]
  }
  
  # add x_grand
  data$eccentricity_fix_grand=eccentricity_fix_grand_mean
  data$sacc_amp_grand=sacc_amp_grand_mean
  
  # add value person mean centered
  #x_within = x - x_image - x_part + x_grand
  data$eccentricity_fix_final = data$eccentricity_fix - data$eccentricity_fix_image - data$eccentricity_fix_part + data$eccentricity_fix_grand
  data$sacc_amp_final = data$sacc_amp - data$sacc_amp_image - data$sacc_amp_part + data$sacc_amp_grand
  
  return(data)
}

fixDurMixedModel = function(data,results) {
  # Mixed effects model fixation duration ========
  #create dataframe for analysis
  vec=c(1,4,18,19,10,11)
  dataA=data[,vec]
  names(dataA)[6]='parameter'
  
  #clean missing values
  dataA <- na.omit(dataA) 
  
  m<-lmer(parameter~1+eccentricity_fix_final+sacc_amp_final+ROI_size +(1+eccentricity_fix_final+sacc_amp_final+ROI_size|participant)+(1+eccentricity_fix_final+sacc_amp_final+ROI_size|image_name),data=dataA,control=lmerControl("bobyqa"))
  a=anova(m)
  
  results["param_name"]="log_fixation_duration"
  results["p_eccentricity_fix"]=a$`Pr(>F)`[1]
  results["p_sacc_amp"]=a$`Pr(>F)`[2]
  results["p_ROI_size"]=a$`Pr(>F)`[3]
  
  return(results)
}
