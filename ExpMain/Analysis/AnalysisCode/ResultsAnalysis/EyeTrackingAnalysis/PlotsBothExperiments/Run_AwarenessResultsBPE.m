clear
clc
close all

% Bayesian parameter estimation
%% Parameters
saveFlag=1;

%% paths
codePath=cd;
cd ..\..\..\..\
analysisCodePath=[pwd,'\AnalysisCode'];
dataPath=[analysisCodePath,'\ResultsAnalysis\BehavioralAnalysis\AnalysisR\Output'];

foldersPath=[pwd,'\AnalysisFolders'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(codePath)

%% load data
Table_U1 = readtable([dataPath,'\post_samplesU1.csv']);
Table_U2 = readtable([dataPath,'\post_samplesU2.csv']);
Table_C1 = readtable([dataPath,'\post_samplesC1.csv']);
Table_C2 = readtable([dataPath,'\post_samplesC2.csv']);

%% Create plots of the Bayesian parameter estimation distributions of the Intercept
% load rain cloud plot 
%addpath cd cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

%colors
Param.colorAtt(1,:)=[0 0.4470 0.7410];
Param.colorAtt(2,:)=[0 0.4470 0.7410];
Param.colorAtt(3,:)=[0.4940 0.1840 0.5560];
Param.colorAtt(4,:)=[0.4940 0.1840 0.5560];

%Data in odds ratio
data1=Table_U1.Intercept; 
data2=Table_U2.Intercept; 
data3=Table_C1.Intercept; 
data4=Table_C2.Intercept; 

%Data in probability (sucess rate)
data1 = 1 ./ (1 + exp(-data1));
data2 = 1 ./ (1 + exp(-data2));
data3 = 1 ./ (1 + exp(-data3));
data4 = 1 ./ (1 + exp(-data4));

%Data in percent
data1 = data1*100;
data2 = data2*100;
data3 = data3*100;
data4 = data4*100;

figure('units','normalized','outerposition',[0 0 1 1])
ax{1}=subplot(2,2,1);
h1 = raincloud_plot(data1, 'box_on', 1, 'color', Param.colorAtt(1,:), 'cloud_edge_col', Param.colorAtt(1,:),'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15, 'box_col_match', 0);
hold on
xline(50,'Color',[0.5 0.5 0.5],'LineWidth',1)
hold off
title('Experiment 1','FontWeight','normal')
ylabel('density')
set(gca,'FontSize',22)
Ax = gca;
Ax.Box = 'off';
xtickformat('percentage')


ax{2}=subplot(2,2,2);
h1 = raincloud_plot(data2, 'box_on', 1, 'color', Param.colorAtt(2,:), 'cloud_edge_col', Param.colorAtt(2,:),'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15, 'box_col_match', 0);
hold on
xline(50,'Color',[0.5 0.5 0.5],'LineWidth',1)
hold off
title('Experiment 2','FontWeight','normal')
set(gca,'FontSize',22)
Ax = gca;
Ax.Box = 'off';
xtickformat('percentage')

%change x-axis to be the same
linkaxes([ax{1},ax{2}],'x')

ax{3}=subplot(2,2,3);
h1 = raincloud_plot(data3, 'box_on', 1, 'color', Param.colorAtt(3,:), 'cloud_edge_col', Param.colorAtt(3,:),'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15, 'box_col_match', 0);
ylabel('density')
xlabel('Success rate')
set(gca,'FontSize',22)
Ax = gca;
Ax.Box = 'off';
xtickformat('percentage')

ax{4}=subplot(2,2,4);
h1 = raincloud_plot(data4, 'box_on', 1, 'color', Param.colorAtt(4,:), 'cloud_edge_col', Param.colorAtt(4,:),'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15, 'box_col_match', 0);
xlabel('Success rate')
set(gca,'FontSize',22)
Ax = gca;
Ax.Box = 'off';
xtickformat('percentage')

%change x-axis to be the same
linkaxes([ax{3},ax{4}],'x')

cd(wd)

if saveFlag
    saveas(gcf,'AwarenessResultsBPE.svg', 'svg')
end
