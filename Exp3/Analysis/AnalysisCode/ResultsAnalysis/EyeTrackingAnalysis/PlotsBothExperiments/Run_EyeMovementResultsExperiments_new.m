clear
clc
close all

%% Paramaters
AnalysisType=3; %1 main, 2 preregistration control, 3 RttM check, 4 permutation control
saveFlag=1; %1 save, 0 do not save
seed=1;

%% paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.breakAxis=[foldersPath,'\Code\breakxaxis'];
cd(codePath)

if AnalysisType == 1
    path1=[dataPath,'\Pilot1_Final'];
    path2=[dataPath,'\Pilot2_Final'];
elseif AnalysisType == 2
    path1=[dataPath,'\Pilot1_PreregistrationCheck'];
    path2=[dataPath,'\Pilot2_PreregistrationCheck'];
elseif AnalysisType == 3
    path1=[dataPath,'\Pilot1_RttMCheck'];
    path2=[dataPath,'\Pilot2_RttMCheck'];
elseif AnalysisType == 4
    path1=[dataPath,'\Pilot1_PermutationCheck'];
    path2=[dataPath,'\Pilot2_PermutationCheck'];
end

%% load data
load([path1,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsResults1=RegionsSummary;
clear RegionsSummary;
load([path2,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsResults2=RegionsSummary;
clear RegionsSummary;

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


%% Random number generator
sprev=rng(seed);

%%  Region Plots
%figure('units','normalized','outerposition',[0.25 0 0.7 1])
figure('units','normalized','outerposition',[0.2 0 0.8 1])
rows=4;
columns=4;

%  FixPerPix plots experimnent 1 & 2
plotNumbersExp1=[1,2,3,4];
plotNumbersExp2=[5,6,7,8];

%Astreicks vec (row is experiment, column is region)
if AnalysisType == 1
    FlagAstUall=[0 0 0 1;0 0 1 1];
    FlagAstCall=[0 1 1 1;0 1 1 1];
elseif AnalysisType == 2
    FlagAstUall=[0 1 0 1;0 0 1 1];
    FlagAstCall=[0 1 1 1;0 1 1 1];
elseif AnalysisType == 3
    FlagAstUall=[0 1 0 0;0 0 1 1];
    FlagAstCall=[0 1 1 1;0 1 1 1];
elseif AnalysisType == 4
    FlagAstUall=[0 0 0 0;0 0 1 1];
    FlagAstCall=[0 1 1 1;0 1 1 1];
end

% read into cell array of the appropriate dimensions
for gg=1:length(RegionsResults1.GroupNames) %area types
    for cc=1:2 %visiblity conditions
        %exp 1
        data{gg,cc,1} = RegionsResults1.condition(cc).FixPerPixShuffled(:,gg);
        realVal(gg,cc,1)=RegionsResults1.condition(cc).FixPerPix(gg);
        %exp 2
        data{gg,cc,2} = RegionsResults2.condition(cc).FixPerPixShuffled(:,gg);
        realVal(gg,cc,2)=RegionsResults2.condition(cc).FixPerPix(gg);
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
    plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)
end

clear dataP data realVal

%  FixDurPerPix plots experimnent 1 & 2
plotNumbersExp1=[9,10,11,12];
plotNumbersExp2=[13,14,15,16];

%Astreicks vec (row is experiment, column is region)
if AnalysisType == 1
    FlagAstUall=[0 0 0 0;0 0 0 0];
    FlagAstCall=[0 1 1 1;0 0 1 1];
elseif AnalysisType == 2
    FlagAstUall=[1 0 0 0;1 0 0 0];
    FlagAstCall=[0 1 1 1;0 0 1 1];
elseif AnalysisType == 3
    FlagAstUall=[0 0 0 0;0 0 0 0];
    FlagAstCall=[0 0 1 1;0 0 1 1];
elseif AnalysisType == 4
    FlagAstUall=[0 0 0 0;0 0 0 0];
    FlagAstCall=[0 0 1 1;0 0 1 1];
end

% read into cell array of the appropriate dimensions
for gg=1:length(RegionsResults1.GroupNames)
    for cc=1:2 %visiblity conditions
        %exp 1
        data{gg,cc,1} = RegionsResults1.condition(cc).FixDurPerPixShuffled(:,gg);
        realVal(gg,cc,1)=RegionsResults1.condition(cc).FixDurPerPix(gg);
        %exp 2
        data{gg,cc,2} = RegionsResults2.condition(cc).FixDurPerPixShuffled(:,gg);
        realVal(gg,cc,2)=RegionsResults2.condition(cc).FixDurPerPix(gg);
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
    
    plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)
end
clear data realVal dataP

if saveFlag
    if AnalysisType == 1
        saveas(gcf,'Regions.svg', 'svg')
    elseif AnalysisType == 2
        saveas(gcf,'Regions_PreregCheck.svg', 'svg')
    elseif AnalysisType == 3
        saveas(gcf,'Regions_RttMCheck.svg', 'svg')
    elseif AnalysisType == 4
        saveas(gcf,'Regions_PermutationCheck.svg', 'svg')
    end
end


%% Objects analysis
figure('units','normalized','outerposition',[0.2 0 0.8 1])
rows=4;
columns=3;

% FixPerPix plots experimnent 1 & 2
plotNumbersExp1=[1,2];
plotNumbersExp2=[4,5];
%Astreicks vec (row is experiment, column is area type: 1- obj, 2-bg)
if AnalysisType == 1
    FlagAstUall=[1 1;1 1];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 2
    FlagAstUall=[0 0;1 1];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 3
    FlagAstUall=[0 0;1 1];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 4
    FlagAstUall=[0 0;1 1];
    FlagAstCall=[1 1;1 1];
end

% read into cell array of the appropriate dimensions
for cc=1:2 %visiblity conditions
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
    plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)
end

clear dataP data realVal

% FixDurPerPix plots experimnent 1 & 2
plotNumbersExp1=[7,8];
plotNumbersExp2=[10,11];
%Astreicks vec (row is experiment, column is are type: 1- obj, 2-bg)
if AnalysisType == 1
    FlagAstUall=[0 0;0 0];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 2
    FlagAstUall=[1 0;0 0];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 3
    FlagAstUall=[0 0;0 0];
    FlagAstCall=[1 1;1 1];
elseif AnalysisType == 4
    FlagAstUall=[0 0;0 0];
    FlagAstCall=[1 1;1 1];
end
% read into cell array of the appropriate dimensions
for cc=1:2 %visiblity conditions
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
    plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)
end

clear data realVal dataP

%% Emotinal face analysis
EmFaAtt=3;

% FixPerPix plots experimnent 1 & 2
plotNumbersExp1=3;
plotNumbersExp2=6;

%Astreicks vec (row is experiment, column is 1-emotional face)
if AnalysisType == 1
    FlagAstU=[0;1];
    FlagAstC=[1;1];
elseif AnalysisType == 2
    FlagAstU=[1;1];
    FlagAstC=[1;1];
elseif AnalysisType == 3
    FlagAstU=[0;1];
    FlagAstC=[1;1];
elseif AnalysisType == 4
    FlagAstU=[1;0];
    FlagAstC=[1;1];
end

% read into cell array of the appropriate dimensions
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
plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)

clear data realVal dataP

% FixDurPerPix plots experimnent 1 & 2
plotNumbersExp1=9;
plotNumbersExp2=12;
%Astreicks vec (row is experiment, column is 1-emotional face)
if AnalysisType == 1
    FlagAstU=[1;0];
    FlagAstC=[1;1];
elseif AnalysisType == 2
    FlagAstU=[1;0];
    FlagAstC=[1;1];
elseif AnalysisType == 3
    FlagAstU=[0;0];
    FlagAstC=[1;1];
elseif AnalysisType == 4
    FlagAstU=[1;0];
    FlagAstC=[1;1];
end

% read into cell array of the appropriate dimensions
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
plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)

if saveFlag
    if AnalysisType == 1
        saveas(gcf,'ObjectsEmFa.svg', 'svg')
    elseif AnalysisType == 2
        saveas(gcf,'ObjectsEmFa_PreregCheck.svg', 'svg')
    elseif AnalysisType == 3
        saveas(gcf,'ObjectsEmFa_RttMCheck.svg', 'svg')
    elseif AnalysisType == 4
        saveas(gcf,'ObjectsEmFa_PermutationCheck.svg', 'svg')
    end
end

%% return random number generator to default
rng(sprev);