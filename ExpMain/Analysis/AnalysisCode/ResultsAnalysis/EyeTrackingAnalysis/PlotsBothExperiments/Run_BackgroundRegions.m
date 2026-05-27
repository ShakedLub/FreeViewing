%check if background regions are viewed below chance in the region analysis and objects analysis
close all
clear clc

%% Paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
path1=[dataPath,'\Experiment1_Final'];
path2=[dataPath,'\Experiment2_Final'];
cd(codePath)

%% load data
load([path1,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsSummary1=RegionsSummary;
clear RegionsSummary;
load([path2,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsSummary2=RegionsSummary;
clear RegionsSummary;

load([path1,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsSummary1=ObjectsSummary;
clear ObjectsSummary;
load([path2,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsSummary2=ObjectsSummary;
clear ObjectsSummary;

%% check if background regions are viewed below chance
%% Regions analysis experiment 1
gg=4; % background regions
for kk=1:2 %visibility conditions   
    Results1.Regions.condition(kk).numExtremeObsFDPP=sum(RegionsSummary1.condition(kk).FixDurPerPixShuffled(:,gg)>=RegionsSummary1.condition(kk).FixDurPerPix(gg))+1;
    Results1.Regions.condition(kk).numAllObsFDPP=length(RegionsSummary1.condition(kk).FixDurPerPixShuffled(:,gg))+1;
    Results1.Regions.condition(kk).pvalFDPP=Results1.Regions.condition(kk).numExtremeObsFDPP/Results1.Regions.condition(kk).numAllObsFDPP;
end

%% Regions analysis experiment 2
gg=4; % background regions
for kk=1:2 %visibility conditions    
    Results2.Regions.condition(kk).numExtremeObsFDPP=sum(RegionsSummary2.condition(kk).FixDurPerPixShuffled(:,gg)>=RegionsSummary2.condition(kk).FixDurPerPix(gg))+1;
    Results2.Regions.condition(kk).numAllObsFDPP=length(RegionsSummary2.condition(kk).FixDurPerPixShuffled(:,gg))+1;
    Results2.Regions.condition(kk).pvalFDPP=Results2.Regions.condition(kk).numExtremeObsFDPP/Results2.Regions.condition(kk).numAllObsFDPP;
end

%% Object analysis experiment 1
for kk=1:2 %visibility conditions  
    Results1.Objects.condition(kk).numExtremeObsFDPPBg=sum(ObjectsSummary1.FixDurPerPixBgShuffled(:,kk)>=ObjectsSummary1.FixDurPerPixBg(kk))+1;
    Results1.Objects.condition(kk).numAllObsFDPPBg=length(ObjectsSummary1.FixDurPerPixBgShuffled(:,kk))+1;
    Results1.Objects.condition(kk).pvalFDPPBg=Results1.Objects.condition(kk).numExtremeObsFDPPBg/Results1.Objects.condition(kk).numAllObsFDPPBg;
end

%% Object analysis experiment 2
for kk=1:2 %visibility conditions  
    Results2.Objects.condition(kk).numExtremeObsFDPPBg=sum(ObjectsSummary2.FixDurPerPixBgShuffled(:,kk)>=ObjectsSummary2.FixDurPerPixBg(kk))+1;
    Results2.Objects.condition(kk).numAllObsFDPPBg=length(ObjectsSummary2.FixDurPerPixBgShuffled(:,kk))+1;
    Results2.Objects.condition(kk).pvalFDPPBg=Results2.Objects.condition(kk).numExtremeObsFDPPBg/Results2.Objects.condition(kk).numAllObsFDPPBg;
end