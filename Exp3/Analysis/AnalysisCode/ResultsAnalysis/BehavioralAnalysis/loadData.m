function [EXPDATA_ALL,subjNumber]=loadData(Paths)
%Load experiment matrices and arrange them
cd(Paths.ExpMatrixFolder)
d=dir('*.mat');
ind=contains({d.name},'expdata');
d=d(ind);
cd(Paths.BehavioralAnalysisFolder)

for ii=1:size(d,1) %files
    clear EXPDATA
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
    
    subjNum=EXPDATA.info.subject_info.subject_number_for_randomization;
    expCond=EXPDATA.info.subject_info.experiment_condition;
    
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
    
    %Create a field with all trials for the analysis
    if size(EXPDATA.Trials_Extra,2)~=0
        EXPDATA.TrialsAnalysis=[EXPDATA.Trials_Experiment,EXPDATA.Trials_Extra];
    else
        EXPDATA.TrialsAnalysis=EXPDATA.Trials_Experiment;
    end
    
    EXPDATA_ALL{subjNum,expCond}=EXPDATA;
end

%Change expdata_all to include only subjects who participated in the 2 conditions
subjIndInclude=[];
subjNumber=[];
for ii=1:size(EXPDATA_ALL,1)
    if ~isempty(EXPDATA_ALL{ii,1}) && ~isempty(EXPDATA_ALL{ii,2})
        subjIndInclude=[subjIndInclude,ii];
        subjNumber=[subjNumber,EXPDATA_ALL{ii,1}.info.subject_info.subject_number_and_experiment];
    end
end
EXPDATA_ALL=EXPDATA_ALL(subjIndInclude,:);
end