close all
clc
clear

%% Parameters
seed=1;
saveFlag=1;

%% Paths
codePath=cd;
cd ..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs\MainAnalysis'];
cd(codePath)

cd ..\..\..\..\..\
RainCloudPlotPath=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(codePath)

%% load data
load([dataPath,'\Results_Memory.mat'])
load([dataPath,'\NSSSimilarity_PerSubj.mat'])

%% Random number generator
sprev=rng(seed);

%% create plot
figure('units','normalized','outerposition',[0.25 0.25 0.75 0.48])

%%rain cloud plot
%addpath cd cbrewer
w=cd(RainCloudPlotPath);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

subplot(1,3,3)
% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cl(1, :) = cb(3, :);
h1 = raincloud_plot_big_circles([Results_Memory.data.percentCorrect]*100, 'box_on', 1, 'color', cl,'cloud_edge_col', cl, 'alpha', 1,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
    'box_col_match', 0);
box off
xtickformat('percentage')
xlim([60 120])
xlabel('Accuracy')
title('Memory task')
set(gca,'FontSize',22)

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cl(1, :) = cb(4, :);

subplot(1,3,2)
h1 = raincloud_plot_big_circles([NSSSimilarity_PerSubj.meanNSSSim], 'box_on', 1, 'color', cl,'cloud_edge_col', cl, 'alpha', 1,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
    'box_col_match', 0);
box off
title('Free viewing')
xlabel('NSS similarity')
ylabel('Density')
set(gca,'FontSize',22)
cd(w)

%% save image
if saveFlag
    saveas(gcf,'ImageNonMondrain.svg', 'svg')
end

%% return random number generator to default
rng(sprev);