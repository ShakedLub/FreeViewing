function [TrialsRemoved,meanUTrialsRemoved,meanCTrialsRemoved]=CountTrialsRemoved(EXPDATA_ALL)
kk=0;
for ii=1:size(EXPDATA_ALL,1) %subjects
    for jj=1:size(EXPDATA_ALL,2) %condition
        kk=kk+1;
        TrialsRemoved(kk).SubjectNumber=EXPDATA_ALL{ii,jj}.info.subject_info.subject_number_and_experiment;
        TrialsRemoved(kk).ExpCond=EXPDATA_ALL{ii,jj}.info.subject_info.experiment_condition;
        TrialsRemoved(kk).AllTrials=size(EXPDATA_ALL{ii,jj}.Trials_Experiment,2)+size(EXPDATA_ALL{ii,jj}.Trials_Extra,2);
        TrialsRemoved(kk).AllImageTrials=TrialsRemoved(kk).AllTrials-EXPDATA_ALL{ii,jj}.TrialsRemoved.ControlTrials;
        
        TrialsRemoved(kk).TrialsAfterRemoval=size(EXPDATA_ALL{ii,jj}.TrialsAnalysis,2);
        TrialsRemoved(kk).PercentTrialsRemoved=1-(TrialsRemoved(kk).TrialsAfterRemoval/TrialsRemoved(kk).AllImageTrials);
           
        TrialsRemoved(kk).ControlTrials=EXPDATA_ALL{ii,jj}.TrialsRemoved.ControlTrials;
        TrialsRemoved(kk).SpecificImages=EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificImages;
        TrialsRemoved(kk).TrialsWithoutAnswerRecognitionQuestion=EXPDATA_ALL{ii,jj}.TrialsRemoved.TrialsWithoutAnswerRecognitionQuestion;
        TrialsRemoved(kk).SpecificTrials=EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificTrials;

    end
end
meanUTrialsRemoved=mean([TrialsRemoved([TrialsRemoved.ExpCond]==1).PercentTrialsRemoved]);
meanCTrialsRemoved=mean([TrialsRemoved([TrialsRemoved.ExpCond]==2).PercentTrialsRemoved]);
end
