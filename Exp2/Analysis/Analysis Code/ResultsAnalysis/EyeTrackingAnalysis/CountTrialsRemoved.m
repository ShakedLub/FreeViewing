function TrialsRemoved=CountTrialsRemoved(EXPDATA_ALL)
for ii=1:length(EXPDATA_ALL) %subjects
    TrialsRemoved.data(ii).SubjectNumber=EXPDATA_ALL{ii}.info.subject_info.subject_number_and_experiment;
    TrialsRemoved.data(ii).AllTrials=size(EXPDATA_ALL{ii}.Trials_Experiment,2)-EXPDATA_ALL{ii}.TrialsRemoved.NotOSIEImages;
    TrialsRemoved.data(ii).TrialsAfterRemoval=size(EXPDATA_ALL{ii}.Trials_Analysis,2);
    TrialsRemoved.data(ii).PercentTrialsRemoved=1-(TrialsRemoved.data(ii).TrialsAfterRemoval/TrialsRemoved.data(ii).AllTrials);
    
    TrialsRemoved.data(ii).SpecificTrials=EXPDATA_ALL{ii}.TrialsRemoved.SpecificTrials;
    TrialsRemoved.data(ii).OneTrialBeforeCalibration=EXPDATA_ALL{ii}.TrialsRemoved.OneTrialBeforeCalibration;
    TrialsRemoved.data(ii).NotOSIEImages=EXPDATA_ALL{ii}.TrialsRemoved.NotOSIEImages;
    
    TrialsRemoved.data(ii).AllTechnical=TrialsRemoved.data(ii).SpecificTrials+TrialsRemoved.data(ii).OneTrialBeforeCalibration;
    TrialsRemoved.data(ii).PercentRemovedTechnical=TrialsRemoved.data(ii).AllTechnical/TrialsRemoved.data(ii).AllTrials;
end

TrialsRemoved.meanTrialsRemoved_Technical=mean([TrialsRemoved.data.PercentRemovedTechnical]);

for ii=1:length(EXPDATA_ALL) %subjects
    TrialsRemoved.numTrialsSummary(ii).SubjNum=EXPDATA_ALL{ii}.info.subject_info.subject_number_and_experiment;
    TrialsRemoved.numTrialsSummary(ii).numTrials=size(EXPDATA_ALL{ii}.Trials_Analysis,2); 
end
end
