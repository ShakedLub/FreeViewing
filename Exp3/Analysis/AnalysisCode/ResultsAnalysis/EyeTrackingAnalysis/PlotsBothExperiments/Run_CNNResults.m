clear
clc
close all

%% Paramaters
AnalysisType=1; %1 main, 3 RttM check
saveFlag=0; %1 save, 0 do not save

%% paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
cd(codePath)

if AnalysisType==1
    path1=[dataPath,'\RSA\Pilot1_Final'];
    path2=[dataPath,'\RSA\Pilot2_Final'];
    path12=[dataPath,'\RSA\Pilot1&2_Final'];
elseif AnalysisType==3
    path1=[dataPath,'\RSA\Pilot1_RttMCheck'];
    path2=[dataPath,'\RSA\Pilot2_RttMCheck'];
    path12=[dataPath,'\RSA\Pilot1&2_RttMCheck'];
end

%% load data
load([path1,'\','Results_RemoveCenterBias.mat']);
Results1=Results;
clear Results
load([path2,'\','Results_RemoveCenterBias.mat']);
Results2=Results;
clear Results
load([path12,'\','Results_RemoveCenterBias.mat']);
Results12=Results;
clear Results

if AnalysisType==1
    load([dataPath,'\','BigTreeBH.mat']);
elseif AnalysisType==3
    load([dataPath,'\','BigTreeBH_RttMCheck.mat']);
end

if AnalysisType==1
    %% plot data both experiments
    figure('units','normalized','outerposition',[0 0.25 1 0.5])
    rows=1;
    columns=1;
    numPlot=1;
    titleText='Exp 1&2';
    plotCorrelationsRDM(Results12,G_output,rows,columns,numPlot,titleText)
    
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
    plotCorrelationsRDM(Results1,G_output,rows,columns,numPlot,titleText)
    
    %Plot experiment 2
    numPlot=2;
    titleText='Exp 2';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results2,G_output,rows,columns,numPlot,titleText)
    
    %save image
    if saveFlag        
        saveas(gcf,'CNNExp1Exp2.svg', 'svg')
    end
elseif AnalysisType==3
    %% plot all analysis one figure
    figure('units','normalized','outerposition',[0 0 1 1])
    rows=3;
    columns=1;
    
    %Plot experiment 1
    numPlot=1;
    titleText='Exp 1';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results1,G_output,rows,columns,numPlot,titleText)
    
    %Plot experiment 2
    numPlot=2;
    titleText='Exp 2';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results2,G_output,rows,columns,numPlot,titleText)
    
    %Plot experiment 1&2
    numPlot=3;
    titleText='Exp 1&2';
    subplot(rows,columns,numPlot)
    plotCorrelationsRDM(Results12,G_output,rows,columns,numPlot,titleText)
    
    % save image
    if saveFlag        
        saveas(gcf,'CNN_RttMCheck.svg', 'svg')
    end
end
