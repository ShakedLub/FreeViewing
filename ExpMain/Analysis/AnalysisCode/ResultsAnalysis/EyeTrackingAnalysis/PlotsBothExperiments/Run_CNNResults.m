clear
clc
close all

%% Paramaters
saveFlag=0; %1 save, 0 do not save
AnalysisType=1;
%1: main

%Control analysis
%3: RttM check

%Analyses for revision (run on both experiments):
%5: conscious trials from unconscious and conscious sessions
%89: fig 1 only right dominant eye participants included from both experiments
     %fig 2 only left dominant eye participants included from both experiments
%1112: fig 1: downsample number of trials according to the smaller
       %visibility condition for each participant from both experiments
       %fig 2: downsample number of trials according to the smaller
       %visibility condition for each image from both experiments
%13: free viewing data without a mask and conscious condition from both experiments


%% paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
cd(codePath)

if AnalysisType==1
    path1=[dataPath,'\RSA\Experiment1_Final'];
    path2=[dataPath,'\RSA\Experiment2_Final'];
    path12=[dataPath,'\RSA\Experiment12_Final'];
elseif AnalysisType==3
    path1=[];
    path2=[];
    path12=[dataPath,'\RSA\Experiment12_RttMCheck'];
elseif AnalysisType==5
    path1=[];
    path2=[];
    path12=[dataPath,'\RSA\Experiment12_ConsciousTrialsBothSessions'];
elseif AnalysisType==89
    path1=[dataPath,'\RSA\Experiment12_RightDominantEye'];
    path2=[dataPath,'\RSA\Experiment12_LeftDominantEye'];
    path12=[];
elseif AnalysisType==1112
    path1=[dataPath,'\RSA\Experiment12_DownSampleTrialsParticipantLevel'];
    path2=[dataPath,'\RSA\Experiment12_DownSampleTrialsImageLevel'];
    path12=[];
elseif AnalysisType==13
    path1=[];
    path2=[];
    path12=[dataPath,'\RSA\Experiment12_FreeViewingVsConscious'];
end

%% load data
if ~isempty(path1)
    load([path1,'\','Results_RemoveCenterBias.mat']);
    Results1=Results;
    clear Results
end
if ~isempty(path2)
    load([path2,'\','Results_RemoveCenterBias.mat']);
    Results2=Results;
    clear Results
end
if ~isempty(path12)
    load([path12,'\','Results_RemoveCenterBias.mat']);
    Results12=Results;
    clear Results
end

if AnalysisType==1
    load([dataPath,'\','BigTreeBH_Final.mat']);
elseif AnalysisType==3  
    load([path12,'\','ResultsTreeBH.mat']);
elseif AnalysisType==5
    load([path12,'\','ResultsTreeBH.mat']);
elseif AnalysisType==89
    load([path1,'\','ResultsTreeBH.mat']);
    ResultsTreeBH1=ResultsTreeBH;
    load([path2,'\','ResultsTreeBH.mat']);
    ResultsTreeBH2=ResultsTreeBH;
    clear ResultsTreeBH
elseif AnalysisType==1112
    load([path1,'\','ResultsTreeBH.mat']);
    ResultsTreeBH1=ResultsTreeBH;
    load([path2,'\','ResultsTreeBH.mat']);
    ResultsTreeBH2=ResultsTreeBH;
    clear ResultsTreeBH
elseif AnalysisType==13
    load([path12,'\','ResultsTreeBH.mat']);
end

if AnalysisType==1
    %% plot data both experiments
    figure('units','normalized','outerposition',[0 0.25 1 0.5])
    rows=1;
    columns=1;
    numPlot=1;
    titleText='Exp 1&2';
    colors(1,:)=[0 0.4470 0.7410]; %blue
    colors(2,:)=[0.4940 0.1840 0.5560]; %purple
    plotCorrelationsRDM(Results12,G_output,rows,columns,numPlot,titleText,colors)
    
    % save image
    if saveFlag
        saveas(gcf,'CNNExp1&2.svg', 'svg')
    end
    
    %% plot each experiment seperatly
    figure('units','normalized','outerposition',[0 0.25 1 0.75])
    rows=2;
    columns=1;
    
    %Plot experiment 1
    numPlot=1;
    titleText='Exp 1';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results1,G_output,rows,columns,numPlot,titleText,colors)
    
    %Plot experiment 2
    numPlot=2;
    titleText='Exp 2';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results2,G_output,rows,columns,numPlot,titleText,colors)
    
    %save image
    if saveFlag
        saveas(gcf,'CNNExp1Exp2.svg', 'svg')
    end
elseif AnalysisType==3
    
    figure('units','normalized','outerposition',[0 0.25 1 0.5])
    rows=1;
    columns=1;
    numPlot=1;
    titleText='Exp 1&2';
    colors(1,:)=[0 0.4470 0.7410]; %blue
    colors(2,:)=[0.4940 0.1840 0.5560]; %purple
    plotCorrelationsRDM(Results12,ResultsTreeBH,rows,columns,numPlot,titleText,colors)
    
    % save image
    if saveFlag
        saveas(gcf,'CNN_RttMCheck.svg', 'svg')
    end
    
    Table=createResultsTableCNN(ResultsTreeBH,Results12);
    
    if saveFlag
        writetable(Table,'CNNAnalysisPvalEffSize_RttMControl.csv')
    end
elseif AnalysisType==5
    %% plot data both experiments
    figure('units','normalized','outerposition',[0 0.25 1 0.5])
    rows=1;
    columns=1;
    numPlot=1;
    titleText='Exp 1&2';
    colors(1,:)=[1.0000,0.3000,0.3961]; %pink
    colors(2,:)=[0.4940 0.1840 0.5560]; %purple
    plotCorrelationsRDM(Results12,ResultsTreeBH,rows,columns,numPlot,titleText,colors)
    
    % save image
    if saveFlag
        saveas(gcf,'CNNExp1&2ConsciousConditionBothSessions.svg', 'svg')
    end
    
    Table=createResultsTableCNN(ResultsTreeBH,Results12);
    
    if saveFlag
        writetable(Table,'CNNAnalysisPvalEffSize_ConsciousTrialsBothSessions.csv')
    end
    
elseif AnalysisType==89
    %% plot right dominant eye and left dominant eye data seperatly
    figure('units','normalized','outerposition',[0 0.25 1 0.75])
    rows=2;
    columns=1;
    
    %Plot experiment right dominant eye
    numPlot=1;
    titleText='Right dominant eye';
    subplot(rows,columns,numPlot)
    colors(1,:)=[0 0.4470 0.7410]; %blue
    colors(2,:)=[0.4940 0.1840 0.5560]; %purple
    plotCorrelationsRDM(Results1,ResultsTreeBH1,rows,columns,numPlot,titleText,colors)
    
    %Plot experiment left dominant eye
    numPlot=2;
    titleText='Left dominant eye';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results2,ResultsTreeBH2,rows,columns,numPlot,titleText,colors)
    
    Table1=createResultsTableCNN(ResultsTreeBH1,Results1);
    Table2=createResultsTableCNN(ResultsTreeBH2,Results2);
    if saveFlag
        writetable(Table1,'CNNAnalysisPvalEffSize_RightDominantEye.csv')
        writetable(Table2,'CNNAnalysisPvalEffSize_LeftDominantEye.csv')
    end
    
    %save image
    if saveFlag
        saveas(gcf,'CNN_RightLeftDominantEye.svg', 'svg')
    end
elseif AnalysisType==1112
    %% plot down sample based on participants in Fig1, and based on images in Fig2
    figure('units','normalized','outerposition',[0 0.25 1 0.75])
    rows=2;
    columns=1;
    
    %Plot down sample based on participants
    numPlot=1;
    titleText='Matched trial sets based on participants';
    subplot(rows,columns,numPlot)
    colors(1,:)=[0 0.4470 0.7410]; %blue
    colors(2,:)=[0.4940 0.1840 0.5560]; %purple
    plotCorrelationsRDM(Results1,ResultsTreeBH1,rows,columns,numPlot,titleText,colors)
    
    %Plot experiment left dominant eye
    numPlot=2;
    titleText='Matched trial sets based on images';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results2,ResultsTreeBH2,rows,columns,numPlot,titleText,colors)
    
    %save image
    if saveFlag
        saveas(gcf,'CNN_DownSample.svg', 'svg')
    end
    
    Table1=createResultsTableCNN(ResultsTreeBH1,Results1);
    Table2=createResultsTableCNN(ResultsTreeBH2,Results2);
    if saveFlag
        writetable(Table1,'CNNAnalysisPvalEffSize_DownSampleParticipants.csv')
        writetable(Table2,'CNNAnalysisPvalEffSize_DownSampleImages.csv')
    end
    
    %save image
    if saveFlag
        saveas(gcf,'CNN_RightLeftDominantEye.svg', 'svg')
    end
    
elseif AnalysisType==13
    %% plot data both experiments
    figure('units','normalized','outerposition',[0 0.25 1 0.5])
    rows=1;
    columns=1;
    numPlot=1;
    titleText='Exp 1&2';
    colors(1,:)=[0.2510 0.8784 0.8157]; %green
    colors(2,:)=[0.4940 0.1840 0.5560]; %purple
    plotCorrelationsRDM(Results12,ResultsTreeBH,rows,columns,numPlot,titleText,colors)
    
    % save image
    if saveFlag
        saveas(gcf,'CNNExp1&2FreeViewingVsConscious.svg', 'svg')
    end
    
    % create pvalue and effect size table
    Table=createResultsTableCNNFV(ResultsTreeBH,Results12);
    if saveFlag
        writetable(Table,'CNNAnalysisPvalEffSize_FreeViewing.csv')
    end
end

function Table=createResultsTableCNNFV(ResultsTreeBH,Results12)
numLayers=size(Results12.Rho,2);

NodeNames={ResultsTreeBH.Nodes.name};
NodeNames=NodeNames{:};

%experiment 12
for ii=1:numLayers
    indU=find(strcmp(NodeNames,['UL',num2str(ii)]));
    indC=find(strcmp(NodeNames,['CL',num2str(ii)]));
    indSub=find(strcmp(NodeNames,['U-CL',num2str(ii)]));
    pFV(ii)=ResultsTreeBH.Nodes{indU,'corr_p'};
    pC(ii)=ResultsTreeBH.Nodes{indC,'corr_p'};
    if ~isempty(indSub)
        pSub(ii)=ResultsTreeBH.Nodes{indSub,'corr_p'};
    else
        pSub(ii)=NaN;
    end
end

pFV=round(pFV,3);
pC=round(pC,3);
pSub=round(pSub,3);

%find effect sizes in experiment 1&2
ESFV12=Results12.effectSize(1,:);
ESC12=Results12.effectSize(2,:);
ESSub12=Results12.effectSizeSub;

ESFV12=round(ESFV12,2);
ESC12=round(ESC12,2);
ESSub12=round(ESSub12,2);

%create table
Table = table(pFV',ESFV12',pC',ESC12',pSub',ESSub12','VariableNames',{'PvalFV','ESFV','PvalC','ESC','PvalSub','ESSub'});
end

function Table=createResultsTableCNN(ResultsTreeBH,Results12)
numLayers=size(Results12.Rho,2);

NodeNames={ResultsTreeBH.Nodes.name};
NodeNames=NodeNames{:};

%experiment 12
for ii=1:numLayers
    indU=find(strcmp(NodeNames,['UL',num2str(ii)]));
    indC=find(strcmp(NodeNames,['CL',num2str(ii)]));
    indSub=find(strcmp(NodeNames,['U-CL',num2str(ii)]));
    pU(ii)=ResultsTreeBH.Nodes{indU,'corr_p'};
    pC(ii)=ResultsTreeBH.Nodes{indC,'corr_p'};
    if ~isempty(indSub)
        pSub(ii)=ResultsTreeBH.Nodes{indSub,'corr_p'};
    else
        pSub(ii)=NaN;
    end
end

pU=round(pU,3);
pC=round(pC,3);
pSub=round(pSub,3);

%find effect sizes in experiment 1&2
ESU12=Results12.effectSize(1,:);
ESC12=Results12.effectSize(2,:);
ESSub12=Results12.effectSizeSub;

ESU12=round(ESU12,2);
ESC12=round(ESC12,2);
ESSub12=round(ESSub12,2);

%create table
Table = table(pU',ESU12',pC',ESC12',pSub',ESSub12','VariableNames',{'PvalU','ESU','PvalC','ESC','PvalSub','ESSub'});
end

