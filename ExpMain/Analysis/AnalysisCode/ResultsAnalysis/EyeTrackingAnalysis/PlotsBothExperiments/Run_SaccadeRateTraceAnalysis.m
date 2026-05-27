clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save
permutation_type=1; %1- shuffling two conditions compared
%2- shuflling fixations between images

Param.seed=1;
Param.smoothWindow=50; %msec
Param.EyeTrackerFrameRate=1000;
Param.AnalysisMinTimeLimit=500; %msec
Param.AnalysisMinTimeLimitFrames=Param.AnalysisMinTimeLimit/((1/Param.EyeTrackerFrameRate)*1000);
Param.AnalysisMaxTimeLimit=3500; %msec
Param.AnalysisMaxTimeLimitFrames=Param.AnalysisMaxTimeLimit/((1/Param.EyeTrackerFrameRate)*1000);
Param.TimeBin=100; %msec
Param.numReptitions=1000;
Param.Nrepetitions=Param.numReptitions;
Param.pixels_per_vdegree=46.1388; %calculated based on screen width 53.2 cm;
Param.RemoveCenterBias=1;
Param.CenterBiasRadius=1.5;

%Objects and attributes analysis
Param.IncludeObjNoAttInObj=1; %object analysis 1=yes, 0=No
Param.UseCircleAroundFix=1;
Param.shuffledDataFlag=1;

%% Paths
Paths.codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.ShadedStdPlot=[foldersPath,'\Code\stdshade'];
cd(Paths.codePath)
path1=[dataPath,'\Experiment1_Final'];
path2=[dataPath,'\Experiment2_Final'];

cd ..\
Paths.eyeTrackingCode=pwd;
cd(Paths.codePath)

%% load data
load([path1,'\','Fixations_PerSubject_RemoveCenterBias.mat']);
Fixations_PerSubject1=Fixations_PerSubject;
clear Fixations_PerSubject;
load([path2,'\','Fixations_PerSubject_RemoveCenterBias.mat']);
Fixations_PerSubject2=Fixations_PerSubject;
clear Fixations_PerSubject;

subjNumber1=[Fixations_PerSubject1.subjNum];
subjNumber2=[Fixations_PerSubject2.subjNum];

load([path1,'\','ObjectsResults_PerSubj_RemoveCenterBias.mat']);
ObjectsResults_PerSubj1=ObjectsResults_PerSubj;
clear ObjectsResults_PerSubj;
load([path2,'\','ObjectsResults_PerSubj_RemoveCenterBias.mat']);
ObjectsResults_PerSubj2=ObjectsResults_PerSubj;
clear ObjectsResults_PerSubj;

load([path1,'\','FixationsPerImageProcessed_RemoveCenterBias.mat']);
Fixations1=FixationsPerImageProcessed;
clear FixationsPerImageProcessed;
load([path2,'\','FixationsPerImageProcessed_RemoveCenterBias.mat']);
Fixations2=FixationsPerImageProcessed;
clear FixationsPerImageProcessed;

%% Random number generator
sprev=rng(Param.seed);

%%  Objects analysis
Results_SaccRateTrace_Objects1=saccadeRateTraceObjects(Fixations_PerSubject1,ObjectsResults_PerSubj1,Param,'real');
Results_SaccRateTrace_Objects2=saccadeRateTraceObjects(Fixations_PerSubject2,ObjectsResults_PerSubj2,Param,'real');

if permutation_type ==1
    %% Cluster based permutation analysis
    %% Object vs background
    %Experiment 1
    for kk=1:size(Results_SaccRateTrace_Objects1.condition,2) %visibility condiitons
        SaccRate{1}=Results_SaccRateTrace_Objects1.condition(kk).SaccRate_Obj;
        SaccRate{2}=Results_SaccRateTrace_Objects1.condition(kk).SaccRate_Bg;
        dataPerSubjPerCond{1}=Results_SaccRateTrace_Objects1.condition(kk).dataPerSubjPerCond_Obj;
        dataPerSubjPerCond{2}=Results_SaccRateTrace_Objects1.condition(kk).dataPerSubjPerCond_Bg;
        ResultsPerm_Objects1{kk}=clusterBasedPermutationAnalysis(SaccRate,dataPerSubjPerCond,Param);
    end
        
    % Experiment 2
    for kk=1:size(Results_SaccRateTrace_Objects2.condition,2) %visibility condiitons
        SaccRate{1}=Results_SaccRateTrace_Objects2.condition(kk).SaccRate_Obj;
        SaccRate{2}=Results_SaccRateTrace_Objects2.condition(kk).SaccRate_Bg;
        dataPerSubjPerCond{1}=Results_SaccRateTrace_Objects2.condition(kk).dataPerSubjPerCond_Obj;
        dataPerSubjPerCond{2}=Results_SaccRateTrace_Objects2.condition(kk).dataPerSubjPerCond_Bg;
        ResultsPerm_Objects2{kk}=clusterBasedPermutationAnalysis(SaccRate,dataPerSubjPerCond,Param);
    end
    
    %% save results
    if saveFlag
        save([path1,'\','Results_SaccRateTrace_Objects1.mat'],'Results_SaccRateTrace_Objects1')
        save([path2,'\','Results_SaccRateTrace_Objects2.mat'],'Results_SaccRateTrace_Objects2')
                
        save([path1,'\','ResultsPerm_Objects1.mat'],'ResultsPerm_Objects1')
        save([path2,'\','ResultsPerm_Objects2.mat'],'ResultsPerm_Objects2')
    end
end

if permutation_type == 2
    %% Cluster based permutation analysis on shuffled fixations
    clear ObjectsResults_PerSubj1
    clear ObjectsResults_PerSubj2
    
    %add shuffled data to fixations
    if Param.shuffledDataFlag
        Fixations1=shuffleFixationsSaveTrialPermAnalysisWithSaccades(Fixations1,Fixations_PerSubject1,subjNumber1,Param.numReptitions);
        Fixations2=shuffleFixationsSaveTrialPermAnalysisWithSaccades(Fixations2,Fixations_PerSubject2,subjNumber2,Param.numReptitions);
    end
    
    clear Fixations_PerSubject1
    clear Fixations_PerSubject2
    
    cd(Paths.eyeTrackingCode)
    
    %classify random fixations to objects
    load('AttrsCombined.mat')
    ObjectsResults1=classifyFixationsObjects(Fixations1,Paths,Param,attrs,attrNames);
    ObjectsResults2=classifyFixationsObjects(Fixations2,Paths,Param,attrs,attrNames);
    
    cd(Paths.codePath)
    
    %change objects clasification to be per subject including the shuffled data
    ResultsObjects_PerSubj1=changeObjectsPerSubject(ObjectsResults1,Fixations1,subjNumber1,Param);
    Fixations_PerSubj1=changeFixationsPerSubject(Fixations1,subjNumber1);
    
    ResultsObjects_PerSubj2=changeObjectsPerSubject(ObjectsResults2,Fixations2,subjNumber2,Param);
    Fixations_PerSubj2=changeFixationsPerSubject(Fixations2,subjNumber2);
    
    %% Cluster based permutation analysis on shuffled fixations
    %% Objects vs background
    %Experiment 1
    for kk=1:size(Results_SaccRateTrace_Objects1.condition,2) %visibility condiitons
        SaccRate{1}=Results_SaccRateTrace_Objects1.condition(kk).SaccRate_Obj;
        SaccRate{2}=Results_SaccRateTrace_Objects1.condition(kk).SaccRate_Bg;
        conditions={'Obj','Bg'};
        ResultsPermShuffledTrails_Objects1{kk}=clusterBasedPermutationAnalysisShuffledTrials(SaccRate,Fixations_PerSubj1,ResultsObjects_PerSubj1,Param,Paths,kk,conditions);
    end
        
    %Experiment 2
    for kk=1:size(Results_SaccRateTrace_Objects2.condition,2) %visibility condiitons
        SaccRate{1}=Results_SaccRateTrace_Objects2.condition(kk).SaccRate_Obj;
        SaccRate{2}=Results_SaccRateTrace_Objects2.condition(kk).SaccRate_Bg;
        conditions={'Obj','Bg'};
        ResultsPermShuffledTrails_Objects2{kk}=clusterBasedPermutationAnalysisShuffledTrials(SaccRate,Fixations_PerSubj2,ResultsObjects_PerSubj2,Param,Paths,kk,conditions);
    end
    
    %% save data
    if saveFlag
        save([path1,'\','ResultsPermShuffledTrails_Objects1.mat'],'ResultsPermShuffledTrails_Objects1')
        save([path2,'\','ResultsPermShuffledTrails_Objects2.mat'],'ResultsPermShuffledTrails_Objects2')
    end
end

%% return random number generator to default
rng(sprev);