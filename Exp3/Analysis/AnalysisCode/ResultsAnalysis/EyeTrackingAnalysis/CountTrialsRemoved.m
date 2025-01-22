function TrialsRemoved=CountTrialsRemoved(EXPDATA_ALL)
%count how many trials were removed in each condition and 
%summarize the number of trials included in analysis
kk=0;
for ii=1:size(EXPDATA_ALL,1) %subjects
    for jj=1:size(EXPDATA_ALL,2) %condition
        kk=kk+1;
        TrialsRemoved.data(kk).SubjectNumber=EXPDATA_ALL{ii,jj}.info.subject_info.subject_number_and_experiment;
        TrialsRemoved.data(kk).ExpCond=EXPDATA_ALL{ii,jj}.info.subject_info.experiment_condition;
        TrialsRemoved.data(kk).AllTrials=size(EXPDATA_ALL{ii,jj}.Trials_Experiment,2);
        TrialsRemoved.data(kk).AllImageTrials=TrialsRemoved.data(kk).AllTrials-EXPDATA_ALL{ii,jj}.TrialsRemoved.ControlTrials;        
        TrialsRemoved.data(kk).TrialsAfterVisbilityTechnicalRemoval=size(EXPDATA_ALL{ii,jj}.Trials_Analysis,2);
           
        TrialsRemoved.data(kk).ControlTrials=EXPDATA_ALL{ii,jj}.TrialsRemoved.ControlTrials; 
        TrialsRemoved.data(kk).SpecificImages=EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificImages;  
        TrialsRemoved.data(kk).SubjectiveAwarenessExclusion=EXPDATA_ALL{ii,jj}.TrialsRemoved.SubjectiveAwarenessExclusion;
        TrialsRemoved.data(kk).ObjectiveAwarenessNoAnswer=EXPDATA_ALL{ii,jj}.TrialsRemoved.ObjectiveAwarenessNoAnswer;
        TrialsRemoved.data(kk).SpecificTrials=EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificTrials;
        TrialsRemoved.data(kk).OneTrialBeforeCalibration=EXPDATA_ALL{ii,jj}.TrialsRemoved.OneTrialBeforeCalibration;
        
        TrialsRemoved.data(kk).AllVisibility=TrialsRemoved.data(kk).SubjectiveAwarenessExclusion;
        TrialsRemoved.data(kk).PercentRemovedVisibility=TrialsRemoved.data(kk).AllVisibility/TrialsRemoved.data(kk).AllImageTrials;
        TrialsRemoved.data(kk).AllTechnical=TrialsRemoved.data(kk).SpecificImages+TrialsRemoved.data(kk).ObjectiveAwarenessNoAnswer+TrialsRemoved.data(kk).SpecificTrials+TrialsRemoved.data(kk).OneTrialBeforeCalibration;
        TrialsRemoved.data(kk).PercentRemovedTechnical=TrialsRemoved.data(kk).AllTechnical/TrialsRemoved.data(kk).AllImageTrials;
    end
end

%average percent number of trials, across all participants
for kk=1:size(EXPDATA_ALL,2) %condition
    TrialsRemoved.meanPercentTrialsRemoved_Visibility(kk)=mean([TrialsRemoved.data([TrialsRemoved.data.ExpCond]==kk).PercentRemovedVisibility]);
    TrialsRemoved.meanPercentTrialsRemoved_Technical(kk)=mean([TrialsRemoved.data([TrialsRemoved.data.ExpCond]==kk).PercentRemovedTechnical]);
end

for ii=1:size(EXPDATA_ALL,1) %subjects
     TrialsRemoved.numTrialsSummary(ii).SubjNum=EXPDATA_ALL{ii,1}.info.subject_info.subject_number_and_experiment;  
    for kk=1:size(EXPDATA_ALL,2) %condition
        if kk==1
            TrialsRemoved.numTrialsSummary(ii).ImageTrialsU=size(EXPDATA_ALL{ii,kk}.Trials_Analysis,2);           
        elseif kk==2
            TrialsRemoved.numTrialsSummary(ii).ImageTrialsC=size(EXPDATA_ALL{ii,kk}.Trials_Analysis,2);          
        end
    end
end
end
