close all
clear
clc

%% conditions
saveFlag=0;
experiment_number='1'; % '1' or '2'

%% Parameters
PILOT_NUM=experiment_number;

Param.possible_response_PAS_Q={1,[1 2],2,3,[3 4],4,NaN};
Param.possible_response_Recognition_Q=[0 1]; %0-wrong, 1-correct

Param.StimuliTypes=1:2; %image and control
Param.imageTrials=Param.StimuliTypes(1);
Param.controlTrials=Param.StimuliTypes(2);

Param.UC=1;
Param.C=2;

Param.pBinomialTest=0.5;
Param.alpha=0.05;
Param.th_accuracy=0.8;
Param.minimal_num_Trials=20;

% Remove specific trials for specific subjects because they are not good
switch PILOT_NUM
    case '1'
        Specific_Trials_Exclude.SUBJ_NUM_REMOVE=[412,419,420,407,432];
        Specific_Trials_Exclude.EXP_COND_REMOVE={'U','U','U','U','U'};
        Specific_Trials_Exclude.TRIALS_REMOVE={[1:2,41],[240:247],[1,161],[1:2],[121]}; %trials number overall
    case '2'
        Specific_Trials_Exclude.SUBJ_NUM_REMOVE=[503,506,511,507,528,528,532,532,525];
        Specific_Trials_Exclude.EXP_COND_REMOVE={'U','U','C','U','U','C','U','C','U'};
        Specific_Trials_Exclude.TRIALS_REMOVE={[241:280],[121:122],[121],[160],[241],[121],[1:3],[121:160],[1]};
end

%% Paths
Paths.BehavioralAnalysisFolder=cd;

cd ..\..\..\..\
Paths.DataFolder=[pwd,'\Raw Data'];
Paths.ExpMatrixFolder=[Paths.DataFolder,'\Behavioral\Pilot',PILOT_NUM];
Paths.myBinomTest=[pwd,'\Analysis\AnalysisFolders\Code\myBinomTest'];
Paths.RainCloudPlot=[pwd,'\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(Paths.BehavioralAnalysisFolder)

%% Load data
%Participant 427, was ran as 407exAA, so his number in EXPDATA is changed.
%This participant was added after adding trials with blinks (because he has enough trials
%to be included)
%Also participants with objective awareness result above chance are added
%with different numbers than the ones ran in the randomization
[EXPDATA_ALL,subjNumber]=loadData(Paths);

%% Remove trials
for ii=1:size(EXPDATA_ALL,1) %subjects
    for jj=1:size(EXPDATA_ALL,2) %conditions 
        clear EXP_COND SUBJ_NUM DOM_EYE fixations saccades raw_data
        %subj parameters
        if jj==1
            EXP_COND='U';
        elseif jj==2
            EXP_COND='C';
        end
        SUBJ_NUM=EXPDATA_ALL{ii,jj}.info.subject_info.subject_number_and_experiment;

        %remove control trials
        EXPDATA_ALL{ii,jj}=removeControlTrials(EXPDATA_ALL{ii,jj});
        
        %delete 2 images that were not supposed to be included:
        %image 1131.jpg with federer
        %image 1546.jpg image with strong stripes
        EXPDATA_ALL{ii,jj}=removeSpecificImages(EXPDATA_ALL{ii,jj});
        
        %remove trials without an answer in recognition question
        EXPDATA_ALL{ii,jj}=removeTrialsWithoutAnswerRecognitionQuestion(EXPDATA_ALL{ii,jj});
        
        %remove for specific subejcts specific trials that are not good
        FlagSpecificTrials=0;
        for cc=1:length(Specific_Trials_Exclude.SUBJ_NUM_REMOVE)
            if  SUBJ_NUM==Specific_Trials_Exclude.SUBJ_NUM_REMOVE(cc) && strcmp(EXP_COND,Specific_Trials_Exclude.EXP_COND_REMOVE{cc})
                EXPDATA_ALL{ii,jj}=removeSpecificTrials(EXPDATA_ALL{ii,jj},Specific_Trials_Exclude.TRIALS_REMOVE{cc});
                FlagSpecificTrials=1;
                break
            end
        end
        if FlagSpecificTrials==0
            EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificTrials=0;
        end
    end
end

%Trials removed
[TrialsRemoved,meanUTrialsRemoved,meanCTrialsRemoved]=CountTrialsRemoved(EXPDATA_ALL);

%% Awareness analysis
for ii=1:size(EXPDATA_ALL,1) %subejcts
    for kk=1:size(EXPDATA_ALL,2) %condition
        %Awareness analysis
        Results_Awareness{ii,kk}=AwarenessAnalysis(EXPDATA_ALL{ii,kk},Param);
    end    
end

%check if subjects should be excluded due to visibility issues
[Results_Awareness,Summary_Awareness]=subjectExclusionAwareness(Results_Awareness,Paths,Param,subjNumber);

%save data with objective aware participants
if saveFlag
    save(['TrialsRemoved_Pilot',PILOT_NUM,'Final.mat'],'TrialsRemoved')
    save(['Results_Awareness_Pilot',PILOT_NUM,'Final.mat'],'Results_Awareness')
    save(['Summary_Awareness_Pilot',PILOT_NUM,'Final.mat'],'Summary_Awareness')
    save(['Param_Pilot',PILOT_NUM,'Final.mat'],'Param')
    save(['Specific_Trials_Exclude_Pilot',PILOT_NUM,'Final.mat'],'Specific_Trials_Exclude')
end

%Exclude objective aware subjects
[EXPDATA_ALL_withoutAware,subjNumber_withoutAware,Results_Awareness_withoutAware,Summary_Awareness_withoutAware]=removeObjectiveAwareSubjects(EXPDATA_ALL,subjNumber,Results_Awareness,Summary_Awareness);

%plot data
plotAwareness(Summary_Awareness_withoutAware.Data,Paths)

%plot pas data
dataPAS=arrangeDataPAS(Results_Awareness_withoutAware);
plotPAS(dataPAS)
if saveFlag
    save(['dataPAS_Pilot',PILOT_NUM,'Final.mat'],'dataPAS')
end