function summaryAgeGender=summarizeAgeAndGender(EXPDATA_ALL)
for ii=1:length(EXPDATA_ALL) %subjects
    summaryAgeGender.data(ii).subjNumber=EXPDATA_ALL{ii}.info.subject_info.subject_number_and_experiment;
    summaryAgeGender.data(ii).age=EXPDATA_ALL{ii}.info.subject_info.subject_age;
    summaryAgeGender.data(ii).gender=EXPDATA_ALL{ii}.info.subject_info.subject_gender;
end
summaryAgeGender.numFemale=sum(strcmp('F',{summaryAgeGender.data.gender}));
summaryAgeGender.meanAge=mean([summaryAgeGender.data.age]);
summaryAgeGender.stdAge=std([summaryAgeGender.data.age]);
summaryAgeGender.minAge=min([summaryAgeGender.data.age]);
summaryAgeGender.maxAge=max([summaryAgeGender.data.age]);
end