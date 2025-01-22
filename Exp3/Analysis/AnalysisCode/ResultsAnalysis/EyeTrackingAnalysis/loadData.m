function [EXPDATA_ALL,EYETRACKING_ALL,subjNumber]=loadData(Paths,Param)
%Load awareness scores
load([Paths.BehavioralResults,'\Summary_Awareness_Pilot',Param.PILOT_NUM,'Final.mat']);

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
    
    %Participant 427, was ran as 407exAA, so his number in EXPDATA is changed.
    %This participant was added after adding trials with blinks (because he has enough trials
    %to be included)
    if contains(d(ii).name,'427')
        EXPDATA.info.subject_info.subject_number_for_randomization=27;
        EXPDATA.info.subject_info.subject_number_and_experiment=427;
    end
    
    %Objective aware experiment 1
    if contains(d(ii).name,'430')
        EXPDATA.info.subject_info.subject_number_for_randomization=30;
        EXPDATA.info.subject_info.subject_number_and_experiment=430;
    end
    if contains(d(ii).name,'431')
        EXPDATA.info.subject_info.subject_number_for_randomization=31;
        EXPDATA.info.subject_info.subject_number_and_experiment=431;
    end
    if contains(d(ii).name,'432')
        EXPDATA.info.subject_info.subject_number_for_randomization=32;
        EXPDATA.info.subject_info.subject_number_and_experiment=432;
    end
    if contains(d(ii).name,'433')
        EXPDATA.info.subject_info.subject_number_for_randomization=33;
        EXPDATA.info.subject_info.subject_number_and_experiment=433;
    end
    if contains(d(ii).name,'434')
        EXPDATA.info.subject_info.subject_number_for_randomization=34;
        EXPDATA.info.subject_info.subject_number_and_experiment=434;
    end
    
    %Objective aware experiment 2
    if contains(d(ii).name,'527')
        EXPDATA.info.subject_info.subject_number_for_randomization=27;
        EXPDATA.info.subject_info.subject_number_and_experiment=527;
    end
    if contains(d(ii).name,'528')
        EXPDATA.info.subject_info.subject_number_for_randomization=28;
        EXPDATA.info.subject_info.subject_number_and_experiment=528;
    end
    if contains(d(ii).name,'529')
        EXPDATA.info.subject_info.subject_number_for_randomization=29;
        EXPDATA.info.subject_info.subject_number_and_experiment=529;
    end
    if contains(d(ii).name,'530')
        EXPDATA.info.subject_info.subject_number_for_randomization=30;
        EXPDATA.info.subject_info.subject_number_and_experiment=530;
    end
    if contains(d(ii).name,'531')
        EXPDATA.info.subject_info.subject_number_for_randomization=31;
        EXPDATA.info.subject_info.subject_number_and_experiment=531;
    end
    if contains(d(ii).name,'532')
        EXPDATA.info.subject_info.subject_number_for_randomization=32;
        EXPDATA.info.subject_info.subject_number_and_experiment=532;
    end
    
    SUBJ_NUM_RAND=EXPDATA.info.subject_info.subject_number_for_randomization;
    expCond=EXPDATA.info.subject_info.experiment_condition;
    SUBJ_NUM_EXP=EXPDATA.info.subject_info.subject_number_and_experiment;
    
    %remove empty trials from expdata
    EXPDATA=removeEmptyTrials(EXPDATA,'Trials_Experiment');
    EXPDATA=removeEmptyTrials(EXPDATA,'Trials_Extra');
    
    %add trial number overall to EXPDATA
    for kk=1:size(EXPDATA.Trials_Experiment,2)
        EXPDATA.Trials_Experiment(kk).TrialNumberOverall=kk;
    end
    for kk=1:size(EXPDATA.Trials_Extra,2)
        numO=size(EXPDATA.Trials_Experiment,2)+kk;
        EXPDATA.Trials_Extra(kk).TrialNumberOverall=numO;
    end
    
    %add objective awareness status of participant
    if expCond==1
        indSub=find([Summary_Awareness.Data.subjNumber]==SUBJ_NUM_EXP); %ind sub in SummaryResults_AwarenessAnalysis
        if Summary_Awareness.Data(indSub).isExcludedUC && Summary_Awareness.Data(indSub).AccuracyUC > 0.5
            EXPDATA.info.subject_info.objective_aware=1;
        else
            EXPDATA.info.subject_info.objective_aware=0;
        end
        EXPDATA.info.subject_info.AccuracyUC=Summary_Awareness.Data(indSub).AccuracyUC;
        EXPDATA.info.subject_info.numTrialsUC=Summary_Awareness.Data(indSub).numTrialsUC;
    end
    
    %load eye tracking matrix
    if expCond==1
        EXP_COND='U';
    elseif expCond==2
        EXP_COND='C';
    end
    ETfileName=['s_',EXP_COND,'_',num2str(SUBJ_NUM_EXP),'.mat'];
    load([Paths.EyeTrackingFolder,'\',ETfileName])
    
    EXPDATA_ALL{SUBJ_NUM_RAND,expCond}=EXPDATA;
    EYETRACKING_ALL{SUBJ_NUM_RAND,expCond}=eye_tracking_data_mat;
end

%Change EXPDATA_ALL and EYETRACKING_ALL to include only subjects who participated in the 2 conditions
subjIndInclude=[];
subjNumber=[];
for ii=1:size(EXPDATA_ALL,1)
    if ~isempty(EXPDATA_ALL{ii,1}) && ~isempty(EXPDATA_ALL{ii,2})
        subjIndInclude=[subjIndInclude,ii];
        subjNumber=[subjNumber,EXPDATA_ALL{ii,1}.info.subject_info.subject_number_and_experiment];
    end
end
EXPDATA_ALL=EXPDATA_ALL(subjIndInclude,:);
EYETRACKING_ALL=EYETRACKING_ALL(subjIndInclude,:);
end