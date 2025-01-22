clear
clc
close all

%% Parameters
saveFlag=0;
seed=1;

%% paths
codePath=cd;
cd ..\..\..\..\
analysisCodePath=[pwd,'\AnalysisCode'];
dataPath=[analysisCodePath,'\ResultsAnalysis\BehavioralAnalysis'];

foldersPath=[pwd,'\AnalysisFolders'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(codePath)

%% load data
load([dataPath,'\','dataPAS_Pilot1Final.mat']);
dataPAS1=dataPAS;
clear dataPAS 
load([dataPath,'\','dataPAS_Pilot2Final.mat']);
dataPAS2=dataPAS;
clear dataPAS 

load([dataPath,'\','Summary_Awareness_Pilot1Final.mat']);
SummaryResults1=Summary_Awareness;
clear Summary_Awareness;
load([dataPath,'\','Summary_Awareness_Pilot2Final.mat']);
SummaryResults2=Summary_Awareness;
clear Summary_Awareness;

load([dataPath,'\','Results_Awareness_Pilot1Final.mat']);
Results1=Results_Awareness;
clear Results_Awareness;
load([dataPath,'\','Results_Awareness_Pilot2Final.mat']);
Results2=Results_Awareness;
clear Results_Awareness;

%% Exclude objective aware subjects
[Results1,SummaryResults1]=removeObjectiveAwareSubjects(Results1,SummaryResults1);
[Results2,SummaryResults2]=removeObjectiveAwareSubjects(Results2,SummaryResults2);

%% Random number generator
sprev=rng(seed);

%% Plots
figure('units','normalized','outerposition',[0 0 1 1])
rows=3;
columns=3;

% Objective measre experimnent 1 & 2
plotNum=7;
titleText='Objective measure';
plotObjectiveMeasure(SummaryResults1.Data,SummaryResults2.Data,rows,columns,plotNum,titleText,Paths)

% Subjective measure experimnent 1 & 2
plotNum=8;
titleText='Subjective measure';
plotSubjectiveMeasure(dataPAS1,dataPAS2,titleText,rows,columns,plotNum,Paths)

% Objective and subjective measures
plotNum=9;
titleText='Objective performance per visibility level';
plotObjectiveAndSubjectiveMeasures(Results1,Results2,titleText,rows,columns,plotNum,Paths)

if saveFlag
    saveas(gcf,'AwarenessResultsAll.svg', 'svg')
end

%% return random number generator to default
rng(sprev);