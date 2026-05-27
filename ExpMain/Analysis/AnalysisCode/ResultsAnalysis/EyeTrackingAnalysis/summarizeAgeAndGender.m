function summary=summarizeAgeAndGender(EXPDATA_ALL)
for ii=1:size(EXPDATA_ALL,1) %subjects
    summary.data(ii).subjNumber=EXPDATA_ALL{ii,1}.info.subject_info.subject_number_and_experiment;
    summary.data(ii).age=EXPDATA_ALL{ii,1}.info.subject_info.subject_age;
    summary.data(ii).gender=EXPDATA_ALL{ii,1}.info.subject_info.subject_gender;
    summary.data(ii).alpha=EXPDATA_ALL{ii,1}.info.experiment_parameters.alpha_image;
end
summary.numFemale=sum(strcmp('F',{summary.data.gender}));
summary.meanAge=mean([summary.data.age]);
summary.stdAge=std([summary.data.age]);
summary.minAge=min([summary.data.age]);
summary.maxAge=max([summary.data.age]);
summary.meanAlpha=mean([summary.data.alpha]);
summary.stdAlpha=std([summary.data.alpha]);
end