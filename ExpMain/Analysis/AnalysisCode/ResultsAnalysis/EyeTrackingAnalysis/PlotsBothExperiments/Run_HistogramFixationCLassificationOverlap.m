clear
clc
close all

%% Param
saveFlag=1;

%% Paths
Paths.codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(Paths.codePath)
path1=[dataPath,'\Experiment1_CountOverlaps'];
path2=[dataPath,'\Experiment2_CountOverlaps'];

%% load data
load([path1,'\','ObjectsResults_PerSubj_RemoveCenterBias.mat']);
ObjectsResults_PerSubj1=ObjectsResults_PerSubj;
clear ObjectsResults_PerSubj;
load([path2,'\','ObjectsResults_PerSubj_RemoveCenterBias.mat']);
ObjectsResults_PerSubj2=ObjectsResults_PerSubj;
clear ObjectsResults_PerSubj;


%% create histogram
figure('units','normalized','outerposition',[0 0 1 1])

plotHistogramOverlap(ObjectsResults_PerSubj1,1,Paths)
plotHistogramOverlap(ObjectsResults_PerSubj2,2,Paths)

if saveFlag
    saveas(gcf,'HistogramOverlapRegions.svg', 'svg')
    saveas(gcf,'HistogramOverlapRegions.jpg', 'jpg')
end