clear
clc
close all

%% Paramaters
saveFlag=0; %1 save, 0 do not save
seed=1;
AnalysisType=1; %1 main

%Control analysis
%2 preregistration control, 3 RttM control, 4 permutation control

%Analyses for revision:
%5 conscious trials from unconscious and conscious sessions
%89 analysis of exp 1&2 8 right participants, 9 left participants (instead of experiment in the rows, it is dominant eye)
%11 downsample number of trials according to the smaller visibility condition for each participant
%12 downsample number of trials according to the smaller visibility condition for each image
%13 free viewing data without a mask and conscious condition
%14 pixel based classification to objects and regions
%15 first saccade analysis
%17 classification to objects and regions based on 50% overlap and above


%% paths
if AnalysisType == 1
    ending='_Final';
elseif AnalysisType == 2
    ending='_PreregistrationCheck';
elseif AnalysisType == 3
    ending='_RttMCheck';
elseif AnalysisType == 4
    ending='_PermutationCheck';
elseif AnalysisType == 5
    ending='_ConsciousTrialsBothSessions';
elseif AnalysisType == 89
    ending='_LeftRightDominantEye';
elseif AnalysisType == 11
    ending='_DownSampleTrialsParticipantLevel';
elseif AnalysisType == 12
    ending='_DownSampleTrialsImageLevel';
elseif AnalysisType == 13
    ending='_FreeViewingVsConscious';
elseif AnalysisType == 14
    ending='_ClassificationPixel';
elseif AnalysisType == 15
    ending='_FirstFixation';
elseif AnalysisType == 17
    ending='_StringentOverlapRule';
end
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.breakAxis=[foldersPath,'\Code\breakxaxis'];
cd(codePath)

if AnalysisType == 89
    path1=[dataPath,'\Experiment12_RightDominantEye'];
    path2=[dataPath,'\Experiment12_LeftDominantEye'];
elseif AnalysisType == 13
    path1=[dataPath,'\Experiment1_Final'];
    path2=[dataPath,'\Experiment2_Final'];
    pathNoMon=[dataPath,'\FreeViewingNoMondrians'];
else
    path1=[dataPath,'\Experiment1',ending];
    path2=[dataPath,'\Experiment2',ending];
end

%% load data
if AnalysisType ~= 14 &&  AnalysisType ~= 17
    load([path1,'\','RegionsSummary_RemoveCenterBias.mat']);
    RegionsResults1=RegionsSummary;
    clear RegionsSummary;
    load([path2,'\','RegionsSummary_RemoveCenterBias.mat']);
    RegionsResults2=RegionsSummary;
    clear RegionsSummary;
end

load([path1,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsResults1=ObjectsSummary;
clear ObjectsSummary;
load([path2,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsResults2=ObjectsSummary;
clear ObjectsSummary;

load([path1,'\','AttributesSummary_RemoveCenterBias.mat']);
AttributesResults1=AttributesSummary;
clear AttributesSummary
load([path2,'\','AttributesSummary_RemoveCenterBias.mat']);
AttributesResults2=AttributesSummary;
clear AttributesSummary

if AnalysisType == 13
    load([pathNoMon,'\','RegionsSummary_RemoveCenterBias.mat']);
    RegionsResults3=RegionsSummary;
    clear RegionsSummary;
    
    load([pathNoMon,'\','ObjectsSummary_RemoveCenterBias.mat']);
    ObjectsResults3=ObjectsSummary;
    clear ObjectsSummary;
    
    load([pathNoMon,'\','AttributesSummary_RemoveCenterBias.mat']);
    AttributesResults3=AttributesSummary;
    clear AttributesSummary
end

%% Random number generator
sprev=rng(seed);

%% load colors
%addpath cd cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cd(wd)

if AnalysisType == 5
    colors(1,:)=cb(4,:); %red, condition 1 color of histogram
    colors(2,:)=[1.0000,0.3000,0.3961]; %pink, condition 1 color of lines
    
    colors(3,:)=cb(10,:); %purple, condition 2 color of histogram
    colors(4,:)=[0.4940 0.1840 0.5560]; %purple, condition 2 color of lines
elseif AnalysisType == 13
    colors(1,:)=cb(1,:); %green, condition 1 color of histogram
    colors(2,:)=[0.2510 0.8784 0.8157]; %green, condition 1 color of lines
    
    colors(3,:)=cb(10,:); %purple, condition 2 color of histogram
    colors(4,:)=[0.4940 0.1840 0.5560]; %purple, condition 2 color of lines
else
    colors(1,:)=cb(5,:); %blue, condition 1 color of histogram
    colors(2,:)=[0 0.4470 0.7410]; %blue, condition 1 color of lines
    
    colors(3,:)=cb(10,:); %purple, condition 2 color of histogram
    colors(4,:)=[0.4940 0.1840 0.5560]; %purple, condition 2 color of lines
end

if AnalysisType ~= 14 &&  AnalysisType ~= 17
    %%  Region Plots
    figure('units','normalized','outerposition',[0.2 0 0.8 1])
    rows=4;
    columns=4;
    
    %  FixPerPix plots experimnent 1 & 2
    plotNumbersExp1=[1,2,3,4];
    plotNumbersExp2=[5,6,7,8];
    
    %Astreicks mat (row is experiment, column is region)
    %except in condition 89 in which row: 1 right dominant eye, 2 left dominant eye
    if AnalysisType == 1
        FlagAstUall=[0 0 0 1;0 0 1 1];
        FlagAstCall=[0 1 1 1;0 1 1 1];
    elseif AnalysisType == 13
        FlagAstUall=[RegionsResults3.condition(1).pvalFPP<0.05;RegionsResults3.condition(1).pvalFPP<0.05];
        FlagAstCall=[RegionsResults1.condition(2).pvalFPP<0.05;RegionsResults2.condition(2).pvalFPP<0.05];
    else
        FlagAstUall=[RegionsResults1.condition(1).pvalFPP<0.05;RegionsResults2.condition(1).pvalFPP<0.05];
        FlagAstCall=[RegionsResults1.condition(2).pvalFPP<0.05;RegionsResults2.condition(2).pvalFPP<0.05];
    end
    
    % read into cell array of the appropriate dimensions
    for gg=1:length(RegionsResults1.GroupNames) %area types
        for cc=1:2 %visiblity conditions
            if AnalysisType == 13
                if cc == 1
                    %exp 1
                    data{gg,cc,1} = RegionsResults3.condition(cc).FixPerPixShuffled(:,gg);
                    realVal(gg,cc,1)=RegionsResults3.condition(cc).FixPerPix(gg);
                    %exp 2
                    data{gg,cc,2} = RegionsResults3.condition(cc).FixPerPixShuffled(:,gg);
                    realVal(gg,cc,2)=RegionsResults3.condition(cc).FixPerPix(gg);
                elseif cc == 2
                    %exp 1
                    data{gg,cc,1} = RegionsResults1.condition(cc).FixPerPixShuffled(:,gg);
                    realVal(gg,cc,1)=RegionsResults1.condition(cc).FixPerPix(gg);
                    %exp 2
                    data{gg,cc,2} = RegionsResults2.condition(cc).FixPerPixShuffled(:,gg);
                    realVal(gg,cc,2)=RegionsResults2.condition(cc).FixPerPix(gg);
                end
            else
                %exp 1
                data{gg,cc,1} = RegionsResults1.condition(cc).FixPerPixShuffled(:,gg);
                realVal(gg,cc,1)=RegionsResults1.condition(cc).FixPerPix(gg);
                %exp 2
                data{gg,cc,2} = RegionsResults2.condition(cc).FixPerPixShuffled(:,gg);
                realVal(gg,cc,2)=RegionsResults2.condition(cc).FixPerPix(gg);
            end
        end
    end
    
    for gg=1:length(RegionsResults1.GroupNames) %area types
        clear dataP
        plotNum=[plotNumbersExp1(gg),plotNumbersExp2(gg)];
        
        dataP.data1Exp1=data{gg,1,1}; %U exp 1
        dataP.data2Exp1=data{gg,2,1}; %C exp 1
        dataP.data1Exp2=data{gg,1,2}; %U exp 2
        dataP.data2Exp2=data{gg,2,2}; %C exp 2
        
        dataP.realVal1Exp1=realVal(gg,1,1); %U exp 1
        dataP.realVal2Exp1=realVal(gg,2,1); %C exp 1
        dataP.realVal1Exp2=realVal(gg,1,2); %U exp 2
        dataP.realVal2Exp2=realVal(gg,2,2); %C exp 2
        
        FlagAstU=FlagAstUall(:,gg); %row is experiment number
        FlagAstC=FlagAstCall(:,gg); %row is experiment number
        
        if gg==4 %background areas
            prc=5;
        else
            prc=95;
        end
        measure='FPP';
        if gg==3
            titleText='High & Low';
        else
            titleText=RegionsResults1.GroupNames{gg};
        end
        
        xexponent=5;
        plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent,colors)
    end
    
    clear dataP data realVal
    
    %  FixDurPerPix plots experimnent 1 & 2
    plotNumbersExp1=[9,10,11,12];
    plotNumbersExp2=[13,14,15,16];
    
    %Astreicks mat (row is experiment, column is region)
    %except in condition 89 in which row: 1 right dominant eye, 2 left dominant eye
    if AnalysisType == 1
        FlagAstUall=[0 0 0 0;0 0 0 0];
        FlagAstCall=[0 1 1 1;0 0 1 1];
    elseif AnalysisType == 13
        FlagAstUall=[RegionsResults3.condition(1).pvalFDPP<0.05;RegionsResults3.condition(1).pvalFDPP<0.05];
        FlagAstCall=[RegionsResults1.condition(2).pvalFDPP<0.05;RegionsResults2.condition(2).pvalFDPP<0.05];
    else
        FlagAstUall=[RegionsResults1.condition(1).pvalFDPP<0.05;RegionsResults2.condition(1).pvalFDPP<0.05];
        FlagAstCall=[RegionsResults1.condition(2).pvalFDPP<0.05;RegionsResults2.condition(2).pvalFDPP<0.05];
    end
    
    % read into cell array of the appropriate dimensions
    for gg=1:length(RegionsResults1.GroupNames)
        for cc=1:2 %visiblity conditions
            if AnalysisType == 13
                if cc == 1
                    %exp 1
                    data{gg,cc,1} = RegionsResults3.condition(cc).FixDurPerPixShuffled(:,gg);
                    realVal(gg,cc,1)=RegionsResults3.condition(cc).FixDurPerPix(gg);
                    %exp 2
                    data{gg,cc,2} = RegionsResults3.condition(cc).FixDurPerPixShuffled(:,gg);
                    realVal(gg,cc,2)=RegionsResults3.condition(cc).FixDurPerPix(gg);
                else
                    %exp 1
                    data{gg,cc,1} = RegionsResults1.condition(cc).FixDurPerPixShuffled(:,gg);
                    realVal(gg,cc,1)=RegionsResults1.condition(cc).FixDurPerPix(gg);
                    %exp 2
                    data{gg,cc,2} = RegionsResults2.condition(cc).FixDurPerPixShuffled(:,gg);
                    realVal(gg,cc,2)=RegionsResults2.condition(cc).FixDurPerPix(gg);
                end
            else
                %exp 1
                data{gg,cc,1} = RegionsResults1.condition(cc).FixDurPerPixShuffled(:,gg);
                realVal(gg,cc,1)=RegionsResults1.condition(cc).FixDurPerPix(gg);
                %exp 2
                data{gg,cc,2} = RegionsResults2.condition(cc).FixDurPerPixShuffled(:,gg);
                realVal(gg,cc,2)=RegionsResults2.condition(cc).FixDurPerPix(gg);
            end
        end
    end
    
    for gg=1:length(RegionsResults1.GroupNames) %area types
        clear dataP
        plotNum=[plotNumbersExp1(gg),plotNumbersExp2(gg)];
        
        dataP.data1Exp1=data{gg,1,1}; %U exp 1
        dataP.data2Exp1=data{gg,2,1}; %C exp 1
        dataP.data1Exp2=data{gg,1,2}; %U exp 2
        dataP.data2Exp2=data{gg,2,2}; %C exp 2
        
        dataP.realVal1Exp1=realVal(gg,1,1); %U exp 1
        dataP.realVal2Exp1=realVal(gg,2,1); %C exp 1
        dataP.realVal1Exp2=realVal(gg,1,2); %U exp 2
        dataP.realVal2Exp2=realVal(gg,2,2); %C exp 2
        
        FlagAstU=FlagAstUall(:,gg); %row is experiment number
        FlagAstC=FlagAstCall(:,gg); %row is experiment number
        
        if gg==4 %background areas
            prc=5;
        else
            prc=95;
        end
        measure='FDPP';
        xexponent=2;
        titleText=[];
        
        plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent,colors)
    end
    clear data realVal dataP

    if saveFlag
        saveas(gcf,['Regions',ending,'.svg'], 'svg')
    end
end

%% Objects analysis
figure('units','normalized','outerposition',[0.2 0 0.8 1])
rows=4;
columns=3;

% FixPerPix plots experimnent 1 & 2
plotNumbersExp1=[1,2];
plotNumbersExp2=[4,5];
%Astreicks mat (row is experiment, column is area type: 1- obj, 2-bg)
%except in condition 89 in which row: 1 right dominant eye, 2 left dominant eye
if AnalysisType == 1
    FlagAstUall=[1 1;1 1];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 13
    FlagAstUall=[ObjectsResults3.pvalFPPObj(1),ObjectsResults3.pvalFPPBg(1);ObjectsResults3.pvalFPPObj(1),ObjectsResults3.pvalFPPBg(1)]<0.05;
    FlagAstCall=[ObjectsResults1.pvalFPPObj(2),ObjectsResults1.pvalFPPBg(2);ObjectsResults2.pvalFPPObj(2),ObjectsResults2.pvalFPPBg(2)]<0.05;
else
    FlagAstUall=[ObjectsResults1.pvalFPPObj(1),ObjectsResults1.pvalFPPBg(1);ObjectsResults2.pvalFPPObj(1),ObjectsResults2.pvalFPPBg(1)]<0.05;
    FlagAstCall=[ObjectsResults1.pvalFPPObj(2),ObjectsResults1.pvalFPPBg(2);ObjectsResults2.pvalFPPObj(2),ObjectsResults2.pvalFPPBg(2)]<0.05;
end

% read into cell array of the appropriate dimensions
for cc=1:2 %visiblity conditions
    if AnalysisType == 13
        if cc == 1
            %Experiment 1
            %Objects
            data{1,cc,1}=ObjectsResults3.FixPerPixObjShuffled(:,cc);
            realVal(1,cc,1)=ObjectsResults3.FixPerPixObj(cc);
            %Background
            data{2,cc,1}=ObjectsResults3.FixPerPixBgShuffled(:,cc);
            realVal(2,cc,1)=ObjectsResults3.FixPerPixBg(cc);
            
            %Experiment 2
            %Objects
            data{1,cc,2}=ObjectsResults3.FixPerPixObjShuffled(:,cc);
            realVal(1,cc,2)=ObjectsResults3.FixPerPixObj(cc);
            %Background
            data{2,cc,2}=ObjectsResults3.FixPerPixBgShuffled(:,cc);
            realVal(2,cc,2)=ObjectsResults3.FixPerPixBg(cc);
        else
            %Experiment 1
            %Objects
            data{1,cc,1}=ObjectsResults1.FixPerPixObjShuffled(:,cc);
            realVal(1,cc,1)=ObjectsResults1.FixPerPixObj(cc);
            %Background
            data{2,cc,1}=ObjectsResults1.FixPerPixBgShuffled(:,cc);
            realVal(2,cc,1)=ObjectsResults1.FixPerPixBg(cc);
            
            %Experiment 2
            %Objects
            data{1,cc,2}=ObjectsResults2.FixPerPixObjShuffled(:,cc);
            realVal(1,cc,2)=ObjectsResults2.FixPerPixObj(cc);
            %Background
            data{2,cc,2}=ObjectsResults2.FixPerPixBgShuffled(:,cc);
            realVal(2,cc,2)=ObjectsResults2.FixPerPixBg(cc);
        end
    else
        %Experiment 1
        %Objects
        data{1,cc,1}=ObjectsResults1.FixPerPixObjShuffled(:,cc);
        realVal(1,cc,1)=ObjectsResults1.FixPerPixObj(cc);
        %Background
        data{2,cc,1}=ObjectsResults1.FixPerPixBgShuffled(:,cc);
        realVal(2,cc,1)=ObjectsResults1.FixPerPixBg(cc);
        
        %Experiment 2
        %Objects
        data{1,cc,2}=ObjectsResults2.FixPerPixObjShuffled(:,cc);
        realVal(1,cc,2)=ObjectsResults2.FixPerPixObj(cc);
        %Background
        data{2,cc,2}=ObjectsResults2.FixPerPixBgShuffled(:,cc);
        realVal(2,cc,2)=ObjectsResults2.FixPerPixBg(cc);
    end
end

for gg=1:size(data,1) %areas types object and background
    plotNum=[plotNumbersExp1(gg),plotNumbersExp2(gg)];
    dataP.data1Exp1=data{gg,1,1}; %U exp 1
    dataP.data2Exp1=data{gg,2,1}; %C exp 1
    dataP.data1Exp2=data{gg,1,2}; %U exp 2
    dataP.data2Exp2=data{gg,2,2}; %C exp 2
    
    dataP.realVal1Exp1=realVal(gg,1,1); %U exp 1
    dataP.realVal2Exp1=realVal(gg,2,1); %C exp 1
    dataP.realVal1Exp2=realVal(gg,1,2); %U exp 2
    dataP.realVal2Exp2=realVal(gg,2,2); %C exp 2
    
    FlagAstU=FlagAstUall(:,gg); %row is experiment number
    FlagAstC=FlagAstCall(:,gg); %row is experiment number
    
    if gg==2 %background areas
        prc=5;
    else
        prc=95;
    end
    measure='FPP';
    if gg==1
        titleText='Objects';
    else
        titleText='Background';
    end
    xexponent=5;
    plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent,colors)
end

clear dataP data realVal

% FixDurPerPix plots experimnent 1 & 2
plotNumbersExp1=[7,8];
plotNumbersExp2=[10,11];
%Astreicks mat (row is experiment, column is are type: 1- obj, 2-bg)
%except in condition 89 in which row: 1 right dominant eye, 2 left dominant eye
if AnalysisType == 1
    FlagAstUall=[0 0;0 0];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 13
    FlagAstUall=[ObjectsResults3.pvalFDPPObj(1),ObjectsResults3.pvalFDPPBg(1);ObjectsResults3.pvalFDPPObj(1),ObjectsResults3.pvalFDPPBg(1)]<0.05;
    FlagAstCall=[ObjectsResults1.pvalFDPPObj(2),ObjectsResults1.pvalFDPPBg(2);ObjectsResults2.pvalFDPPObj(2),ObjectsResults2.pvalFDPPBg(2)]<0.05;
else
    FlagAstUall=[ObjectsResults1.pvalFDPPObj(1),ObjectsResults1.pvalFDPPBg(1);ObjectsResults2.pvalFDPPObj(1),ObjectsResults2.pvalFDPPBg(1)]<0.05;
    FlagAstCall=[ObjectsResults1.pvalFDPPObj(2),ObjectsResults1.pvalFDPPBg(2);ObjectsResults2.pvalFDPPObj(2),ObjectsResults2.pvalFDPPBg(2)]<0.05;
end

% read into cell array of the appropriate dimensions
for cc=1:2 %visiblity conditions
    if AnalysisType == 13
        if cc == 1
            %Experiment 1
            %Objects
            data{1,cc,1}=ObjectsResults3.FixDurPerPixObjShuffled(:,cc);
            realVal(1,cc,1)=ObjectsResults3.FixDurPerPixObj(cc);
            %Background
            data{2,cc,1}=ObjectsResults3.FixDurPerPixBgShuffled(:,cc);
            realVal(2,cc,1)=ObjectsResults3.FixDurPerPixBg(cc);
            
            %Experiment 2
            %Objects
            data{1,cc,2}=ObjectsResults3.FixDurPerPixObjShuffled(:,cc);
            realVal(1,cc,2)=ObjectsResults3.FixDurPerPixObj(cc);
            %Background
            data{2,cc,2}=ObjectsResults3.FixDurPerPixBgShuffled(:,cc);
            realVal(2,cc,2)=ObjectsResults3.FixDurPerPixBg(cc);
        else
            %Experiment 1
            %Objects
            data{1,cc,1}=ObjectsResults1.FixDurPerPixObjShuffled(:,cc);
            realVal(1,cc,1)=ObjectsResults1.FixDurPerPixObj(cc);
            %Background
            data{2,cc,1}=ObjectsResults1.FixDurPerPixBgShuffled(:,cc);
            realVal(2,cc,1)=ObjectsResults1.FixDurPerPixBg(cc);
            
            %Experiment 2
            %Objects
            data{1,cc,2}=ObjectsResults2.FixDurPerPixObjShuffled(:,cc);
            realVal(1,cc,2)=ObjectsResults2.FixDurPerPixObj(cc);
            %Background
            data{2,cc,2}=ObjectsResults2.FixDurPerPixBgShuffled(:,cc);
            realVal(2,cc,2)=ObjectsResults2.FixDurPerPixBg(cc);
        end
    else
        %Experiment 1
        %Objects
        data{1,cc,1}=ObjectsResults1.FixDurPerPixObjShuffled(:,cc);
        realVal(1,cc,1)=ObjectsResults1.FixDurPerPixObj(cc);
        %Background
        data{2,cc,1}=ObjectsResults1.FixDurPerPixBgShuffled(:,cc);
        realVal(2,cc,1)=ObjectsResults1.FixDurPerPixBg(cc);
        
        %Experiment 2
        %Objects
        data{1,cc,2}=ObjectsResults2.FixDurPerPixObjShuffled(:,cc);
        realVal(1,cc,2)=ObjectsResults2.FixDurPerPixObj(cc);
        %Background
        data{2,cc,2}=ObjectsResults2.FixDurPerPixBgShuffled(:,cc);
        realVal(2,cc,2)=ObjectsResults2.FixDurPerPixBg(cc);
    end
end

for gg=1:size(data,1) %areas types object and background
    plotNum=[plotNumbersExp1(gg),plotNumbersExp2(gg)];
    dataP.data1Exp1=data{gg,1,1}; %U exp 1
    dataP.data2Exp1=data{gg,2,1}; %C exp 1
    dataP.data1Exp2=data{gg,1,2}; %U exp 2
    dataP.data2Exp2=data{gg,2,2}; %C exp 2
    
    dataP.realVal1Exp1=realVal(gg,1,1); %U exp 1
    dataP.realVal2Exp1=realVal(gg,2,1); %C exp 1
    dataP.realVal1Exp2=realVal(gg,1,2); %U exp 2
    dataP.realVal2Exp2=realVal(gg,2,2); %C exp 2
    
    FlagAstU=FlagAstUall(:,gg); %row is experiment number
    FlagAstC=FlagAstCall(:,gg); %row is experiment number
    
    if gg==2 %background areas
        prc=5;
    else
        prc=95;
    end
    measure='FDPP';
    if gg==1
        titleText='Objects';
    else
        titleText='Background';
    end
    xexponent=2;
    plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent,colors)
end

clear data realVal dataP

%% Emotinal face analysis
EmFaAtt=3;

% FixPerPix plots experimnent 1 & 2
plotNumbersExp1=3;
plotNumbersExp2=6;

%Astreicks mat (row is experiment, column is 1-emotional face)
%except in condition 89 in which row: 1 right dominant eye, 2 left dominant eye
if AnalysisType == 1
    FlagAstU=[0;1];
    FlagAstC=[1;1];
elseif AnalysisType == 13
    FlagAstU=[AttributesResults3.pvalFPPAtt(1,3);AttributesResults3.pvalFPPAtt(1,3)]<0.05;
    FlagAstC=[AttributesResults1.pvalFPPAtt(2,3);AttributesResults2.pvalFPPAtt(2,3)]<0.05;
else
    FlagAstU=[AttributesResults1.pvalFPPAtt(1,3);AttributesResults2.pvalFPPAtt(1,3)]<0.05;
    FlagAstC=[AttributesResults1.pvalFPPAtt(2,3);AttributesResults2.pvalFPPAtt(2,3)]<0.05;
end

% read into cell array of the appropriate dimensions
if AnalysisType == 13
    %Experiment 1
    %U
    data{1,1}=AttributesResults3.condition(1).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(1,1)=AttributesResults3.FixPerPixAtt(1,EmFaAtt);
    %C
    data{2,1}=AttributesResults1.condition(2).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(2,1)=AttributesResults1.FixPerPixAtt(2,EmFaAtt);
    %Experiment 2
    %U
    data{1,2}=AttributesResults3.condition(1).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(1,2)=AttributesResults3.FixPerPixAtt(1,EmFaAtt);
    %C
    data{2,2}=AttributesResults2.condition(2).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(2,2)=AttributesResults2.FixPerPixAtt(2,EmFaAtt);
else
    %Experiment 1
    %U
    data{1,1}=AttributesResults1.condition(1).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(1,1)=AttributesResults1.FixPerPixAtt(1,EmFaAtt);
    %C
    data{2,1}=AttributesResults1.condition(2).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(2,1)=AttributesResults1.FixPerPixAtt(2,EmFaAtt);
    %Experiment 2
    %U
    data{1,2}=AttributesResults2.condition(1).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(1,2)=AttributesResults2.FixPerPixAtt(1,EmFaAtt);
    %C
    data{2,2}=AttributesResults2.condition(2).FixPerPixAttShuffled(:,EmFaAtt);
    realVal(2,2)=AttributesResults2.FixPerPixAtt(2,EmFaAtt);
end

plotNum=[plotNumbersExp1,plotNumbersExp2];
%experiment 1
dataP.data1Exp1=data{1,1}; %U
dataP.data2Exp1=data{2,1}; %C
dataP.realVal1Exp1=realVal(1,1); %U
dataP.realVal2Exp1=realVal(2,1); %C
%experiment 2
dataP.data1Exp2=data{1,2}; %U
dataP.data2Exp2=data{2,2}; %C
dataP.realVal1Exp2=realVal(1,2); %U
dataP.realVal2Exp2=realVal(2,2); %C
prc=95;
measure='FPP';
titleText='Emotional Face';
xexponent=5;
plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent,colors)

clear data realVal dataP

% FixDurPerPix plots experimnent 1 & 2
plotNumbersExp1=9;
plotNumbersExp2=12;
%Astreicks mat (row is experiment, column is 1-emotional face)
%except in condition 89 in which row: 1 right dominant eye, 2 left dominant eye
if AnalysisType == 1
    FlagAstU=[1;0];
    FlagAstC=[1;1];
elseif AnalysisType == 13
    FlagAstU=[AttributesResults3.pvalFDPPAtt(1,3);AttributesResults3.pvalFDPPAtt(1,3)]<0.05;
    FlagAstC=[AttributesResults1.pvalFDPPAtt(2,3);AttributesResults2.pvalFDPPAtt(2,3)]<0.05;
else
    FlagAstU=[AttributesResults1.pvalFDPPAtt(1,3);AttributesResults2.pvalFDPPAtt(1,3)]<0.05;
    FlagAstC=[AttributesResults1.pvalFDPPAtt(2,3);AttributesResults2.pvalFDPPAtt(2,3)]<0.05;
end

% read into cell array of the appropriate dimensions
if AnalysisType == 13
    %Experiment 1
    %U
    data{1,1}=AttributesResults3.condition(1).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(1,1)=AttributesResults3.FixDurPerPixAtt(1,EmFaAtt);
    %C
    data{2,1}=AttributesResults1.condition(2).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(2,1)=AttributesResults1.FixDurPerPixAtt(2,EmFaAtt);
    %Experiment 2
    %U
    data{1,2}=AttributesResults3.condition(1).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(1,2)=AttributesResults3.FixDurPerPixAtt(1,EmFaAtt);
    %C
    data{2,2}=AttributesResults2.condition(2).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(2,2)=AttributesResults2.FixDurPerPixAtt(2,EmFaAtt);
else
    %Experiment 1
    %U
    data{1,1}=AttributesResults1.condition(1).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(1,1)=AttributesResults1.FixDurPerPixAtt(1,EmFaAtt);
    %C
    data{2,1}=AttributesResults1.condition(2).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(2,1)=AttributesResults1.FixDurPerPixAtt(2,EmFaAtt);
    %Experiment 2
    %U
    data{1,2}=AttributesResults2.condition(1).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(1,2)=AttributesResults2.FixDurPerPixAtt(1,EmFaAtt);
    %C
    data{2,2}=AttributesResults2.condition(2).FixDurPerPixAttShuffled(:,EmFaAtt);
    realVal(2,2)=AttributesResults2.FixDurPerPixAtt(2,EmFaAtt);
end

plotNum=[plotNumbersExp1,plotNumbersExp2];
%experiment 1
dataP.data1Exp1=data{1,1}; %U
dataP.data2Exp1=data{2,1}; %C
dataP.realVal1Exp1=realVal(1,1); %U
dataP.realVal2Exp1=realVal(2,1); %C
%experiment 2
dataP.data1Exp2=data{1,2}; %U
dataP.data2Exp2=data{2,2}; %C
dataP.realVal1Exp2=realVal(1,2); %U
dataP.realVal2Exp2=realVal(2,2); %C
prc=95;
measure='FDPP';
titleText='Emotional Face';
xexponent=2;
plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent,colors)

if saveFlag
    saveas(gcf,['ObjectsEmFa',ending,'.svg'], 'svg')
end

%% create data table
if AnalysisType ~= 1
    if AnalysisType == 14 &&  AnalysisType == 17
        TablePermAnalysis=createResultsTableImageAnalysisOnlyObjects(ObjectsResults1,ObjectsResults2,AttributesResults1,AttributesResults2);
    elseif AnalysisType == 13
        TablePermAnalysis=createResultsTableImageAnalysisFreeViewing(ObjectsResults1,ObjectsResults2,ObjectsResults3,RegionsResults1,RegionsResults2,RegionsResults3,AttributesResults1,AttributesResults2,AttributesResults3);
    else
        TablePermAnalysis=createResultsTableImageAnalysis(ObjectsResults1,ObjectsResults2,RegionsResults1,RegionsResults2,AttributesResults1,AttributesResults2);
    end
    
    %% save table
    if saveFlag
        writetable(TablePermAnalysis,['ImageAnalysisPvalEffSize',ending,'.csv'])
    end
end

%% return random number generator to default
rng(sprev);