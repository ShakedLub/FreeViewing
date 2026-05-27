function [EXPDATA_ALL,EYETRACKING_ALL,subjNumber]=loadData(Paths)
%Load experiment matrices and arrange them
cd(Paths.ExpMatrixFolder)
d=dir('*.mat');
ind=contains({d.name},'expdata');
d=d(ind);
cd(Paths.EyeTrackingAnalysisFolder)

for ii=1:size(d,1) %files
    clear EXPDATA eye_tracking_data_mat
    %load exp data
    load([Paths.ExpMatrixFolder,'\',d(ii).name])
    SUBJ_NUM=EXPDATA.info.subject_info.subject_number_and_experiment;
    
    %remove empty trials from expdata
    EXPDATA=removeEmptyTrials(EXPDATA,'Trials_Experiment');
    EXPDATA=removeEmptyTrials(EXPDATA,'Memory_Task_Trials_Experiment');
    
    %add trial number overall to EXPDATA
    for kk=1:size(EXPDATA.Trials_Experiment,2)
        EXPDATA.Trials_Experiment(kk).TrialNumberOverall=kk;
    end
    
    %load eye tracking matrix
    ETfileName=['s',num2str(SUBJ_NUM),'.mat'];
    load([Paths.EyeTrackingFolder,'\',ETfileName])
    
    EXPDATA_ALL{ii}=EXPDATA;
    EYETRACKING_ALL{ii}=eye_tracking_data_mat;
    subjNumber(ii)=SUBJ_NUM;
end
end