clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save
seed=1;

%% Paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(codePath)

pathControl=[dataPath,'\Experiment1_ControlTrials'];

%% load data
load([pathControl,'\','ResultsControlVsImageTrials_RemoveCenterBias.mat']);
load([pathControl,'\','dataImvsCon_RemoveCenterBias.mat']);
load([pathControl,'\','ResultsPermutation_RemoveCenterBias.mat']);
load([pathControl,'\','parameterNames_RemoveCenterBias.mat']);

%% plot
Names={'number of fixations', 'fixation duration','std fixation duration','number of saccades','saccade amplitude','std saccade amplitude'};
for tt=1:2 %2 figures one of fixation parameters and second of saccade parameters
    
    figure('units','normalized','outerposition',[0 0 1 1])
    rows=3;
    columns=4;
    jj=1;
    if tt==1
        numParam=1:3;
    else
        numParam=4:6;
    end
    
    for qq=numParam
        %boxplot
        subplot(rows,columns,jj)
        mat=[dataImvsCon.([parameterNames{qq},'_Image'])(:,1),dataImvsCon.([parameterNames{qq},'_Control'])(:,1),dataImvsCon.([parameterNames{qq},'_Image'])(:,2),dataImvsCon.([parameterNames{qq},'_Control'])(:,2)];
        boxplot(mat,'BoxStyle','filled','ColorGroup',[1 2 1 2]);
        hold on;
        parallelcoords(mat, 'Color', 0.7*[1 1 1], 'LineStyle', '-','Marker', 'o', 'MarkerSize', 5);
        hold off
        ylabel(Names{qq},'FontSize',18)
        set(gca,'XTick',[1.5,3.5])
        set(gca,'XTickLabel',{'U','C'},'FontSize',18)
        Ax = gca;
        Ax.Box = 'off';
        if qq == 1 || qq == 4
            % Find the box objects to use in the legend
            h = findobj(gca, 'Tag', 'Box');
            
            % Create legend using the found handles (order may be reversed)
            legend(h([2,1]), {'Image', 'Control'})
        end
        
        %P1
        plotNum=jj+1;
        realVal=ResultsControlVsImageTrials.([parameterNames{qq},'_PrecentSignificant_P1']);
        vecReptitions=[ResultsPermutation.([parameterNames{qq},'_PrecentSignificant_P1'])];
        ind=strcmp(parameterNames{qq},{ResultsControlVsImageTrials.Pvalue.parameterName}) & strcmp('P1',{ResultsControlVsImageTrials.Pvalue.effectName});
        Pval=ResultsControlVsImageTrials.Pvalue(ind).value_fdr_corrected;
        prc=95;
        xlabelText=[];
        if jj==1
            titleText='Trial type effect';
        else
            titleText=[];
        end
        plotHistogramRC(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText,Paths)
        
        %P2
        plotNum=jj+2;
        realVal=ResultsControlVsImageTrials.([parameterNames{qq},'_PrecentSignificant_P2']);
        vecReptitions=[ResultsPermutation.([parameterNames{qq},'_PrecentSignificant_P2'])];
        ind=strcmp(parameterNames{qq},{ResultsControlVsImageTrials.Pvalue.parameterName}) & strcmp('P2',{ResultsControlVsImageTrials.Pvalue.effectName});
        Pval=ResultsControlVsImageTrials.Pvalue(ind).value_fdr_corrected;
        prc=95;
        if qq == 3 || qq == 6
            xlabelText='Percent significant tests';
        else
            xlabelText=[];
        end
        if jj==1
            titleText='Visibility condition effect';
        else
            titleText=[];
        end
        plotHistogramRC(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText,Paths)
        
        %P12
        plotNum=jj+3;
        realVal=ResultsControlVsImageTrials.([parameterNames{qq},'_PrecentSignificant_P12']);
        vecReptitions=[ResultsPermutation.([parameterNames{qq},'_PrecentSignificant_P12'])];
        ind=strcmp(parameterNames{qq},{ResultsControlVsImageTrials.Pvalue.parameterName}) & strcmp('P12',{ResultsControlVsImageTrials.Pvalue.effectName});
        Pval=ResultsControlVsImageTrials.Pvalue(ind).value_fdr_corrected;
        prc=95;
        xlabelText=[];
        if jj==1
            titleText='Interaction effect';
        else
            titleText=[];
        end
        plotHistogramRC(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText,Paths)
        
        jj=jj+4;
    end
    if saveFlag
        saveas(gcf,['CompareImvsCon',num2str(tt),'.svg'], 'svg')
    end
end