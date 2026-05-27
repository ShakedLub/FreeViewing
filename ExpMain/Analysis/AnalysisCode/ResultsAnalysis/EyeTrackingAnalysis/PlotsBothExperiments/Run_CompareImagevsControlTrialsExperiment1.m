clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save
seed=1;
Nrepetitions=1000;
alpha=0.05;

%% Paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
cd(codePath)

pathImages=[dataPath,'\Experiment1_Final'];
pathControl=[dataPath,'\Experiment1_ControlTrials'];

%% load data
load([pathImages,'\','Fixations_PerSubject_RemoveCenterBias.mat']);
load([pathControl,'\','Fixations_PerSubjectControl_RemoveCenterBias.mat']);

%% Random number generator
sprev=rng(seed);

%% Delete participants that do not have trials from image trials and control trials
if ~isequal([Fixations_PerSubject.subjNum],[Fixations_PerSubjectControl.subjNum])
    subjDel=[];
    for ii=1:length([Fixations_PerSubject.subjNum])
        subj=Fixations_PerSubject(ii).subjNum;
        if ~ismember(subj,[Fixations_PerSubjectControl.subjNum])
            subjDel=[subjDel,ii];
        end
    end
    
    if ~isempty(subjDel)
        Fixations_PerSubject(subjDel)=[];
    end
end

%% Run analysis
[ResultsControlVsImageTrials,dataImvsCon,ResultsPermutation,parameterNames,Fixations_PerSubject,Fixations_PerSubjectControl]=compareControlVsImageTrials(Fixations_PerSubject,Fixations_PerSubjectControl,Nrepetitions,alpha);

%% save data
if saveFlag
    save([pathControl,'\','ResultsControlVsImageTrials_RemoveCenterBias.mat'],'ResultsControlVsImageTrials')
    save([pathControl,'\','dataImvsCon_RemoveCenterBias.mat'],'dataImvsCon')
    save([pathControl,'\','ResultsPermutation_RemoveCenterBias.mat'],'ResultsPermutation')
    save([pathControl,'\','parameterNames_RemoveCenterBias.mat'],'parameterNames')
    save([pathControl,'\','Fixations_PerSubjectImageWithParameters_RemoveCenterBias.mat'],'Fixations_PerSubject')
    save([pathControl,'\','Fixations_PerSubjectControlWithParameters_RemoveCenterBias.mat'],'Fixations_PerSubjectControl')
end

%% return random number generator to default
rng(sprev);