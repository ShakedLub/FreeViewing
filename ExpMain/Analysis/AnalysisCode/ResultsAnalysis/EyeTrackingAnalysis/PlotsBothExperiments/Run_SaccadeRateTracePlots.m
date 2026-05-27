clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save

Param.EyeTrackerFrameRate=1000;
Param.AnalysisMinTimeLimit=500; %msec
Param.AnalysisMinTimeLimitFrames=Param.AnalysisMinTimeLimit/((1/Param.EyeTrackerFrameRate)*1000);
Param.AnalysisMaxTimeLimit=3500; %msec
Param.AnalysisMaxTimeLimitFrames=Param.AnalysisMaxTimeLimit/((1/Param.EyeTrackerFrameRate)*1000);
Param.seed=1;
Param.alpha=0.05; %Taken from tree BH

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

%% load data
load([path1,'\','Results_SaccRateTrace_Objects1.mat']);
load([path2,'\','Results_SaccRateTrace_Objects2.mat']);

load([path1,'\','ResultsPermShuffledTrails_Objects1.mat']);
load([path2,'\','ResultsPermShuffledTrails_Objects2.mat']);

%% Random number generator
sprev=rng(Param.seed);

%%  Plot Objects analysis
figure('units','normalized','outerposition',[0 0 1 1])
ylimits=[0,0.8e-4];
aa=1; %sub plot number
kk=1; %U condition
ylab='Exp 1';
plotSaccadeRateTraceObjects(Results_SaccRateTrace_Objects1,ResultsPermShuffledTrails_Objects1,Paths,Param,aa,kk,ylab,ylimits);

aa=2; %sub plot number
kk=1; %U condition
ylab='Exp 2';
plotSaccadeRateTraceObjects(Results_SaccRateTrace_Objects2,ResultsPermShuffledTrails_Objects2,Paths,Param,aa,kk,ylab,ylimits);

aa=3; %sub plot number
kk=2; %C condition
ylab='Exp 1';
plotSaccadeRateTraceObjects(Results_SaccRateTrace_Objects1,ResultsPermShuffledTrails_Objects1,Paths,Param,aa,kk,ylab,ylimits);

aa=4; %sub plot number
kk=2; %C condition
ylab='Exp 2';
plotSaccadeRateTraceObjects(Results_SaccRateTrace_Objects2,ResultsPermShuffledTrails_Objects2,Paths,Param,aa,kk,ylab,ylimits);

if saveFlag
    saveas(gcf,'SaccadeRateTraceObjects.svg', 'svg')
end

%% create table of data
%the p-value in the table is not corrected
tbl=createTableSaccadicRate(ResultsPermShuffledTrails_Objects1,ResultsPermShuffledTrails_Objects2,Param);

%% Save table
if saveFlag
    writetable(tbl,'SaccadicRateAnalysis.csv')
end

%% return random number generator to default
rng(sprev);