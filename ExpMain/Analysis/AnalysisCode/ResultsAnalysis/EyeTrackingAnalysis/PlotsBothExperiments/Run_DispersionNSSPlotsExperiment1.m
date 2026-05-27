clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save

%% Paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
Paths.RainCloudPlot=[foldersPath,'\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(codePath)

pathControl=[dataPath,'\Experiment1_Final'];

%% Load data
load([pathControl,'\','DispersionResults_RemoveCenterBias.mat']);
load([pathControl,'\','NSSSimilarity_RemoveCenterBias.mat']);

%% plot
% load rain cloud plot 
%addpath cd cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

colors(1,:)=cb(5,:); %blue, condition 1 color of histogram
colors(2,:)=cb(10,:); %purple, condition 2 color of histogram

%% NSS similarity
figure('units','normalized','outerposition',[0 0.25 1 0.75])
subplot(1, 3, 1)

%delete images with nans
inddel=find(isnan(NSSSimilarity.meanNSSSimilarityPerImage(:,1)) | isnan(NSSSimilarity.meanNSSSimilarityPerImage(:,2)));
meanNSSSimilarityPerImage=NSSSimilarity.meanNSSSimilarityPerImage; 
meanNSSSimilarityPerImage(inddel,:)=[];

d{1}=meanNSSSimilarityPerImage(:,1);
d{2}=meanNSSSimilarityPerImage(:,2);
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', colors(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', colors(2,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
legend([h1{1} h2{1}], {'U', 'C'},'FontSize',20);
xlabel('NSS similarity','FontSize',22)
ylabel('density','FontSize',22)
%set(gca, 'YLim', [-.4 1]);
box off
set(gca,'FontSize',22)

%% Dispersion plots
%delete images with nans
inddel=find(isnan(DispersionResults.meanHorizontalDispersion(:,1)) | isnan(DispersionResults.meanHorizontalDispersion(:,2)));
meanHorizontalDispersion=DispersionResults.meanHorizontalDispersion;
meanHorizontalDispersion(inddel,:)=[];

inddel=find(isnan(DispersionResults.meanVerticalDispersion(:,1)) | isnan(DispersionResults.meanVerticalDispersion(:,2)));
meanVerticalDispersion=DispersionResults.meanVerticalDispersion;
meanVerticalDispersion(inddel,:)=[];

ax1=subplot(1, 3, 2);
d{1}=meanHorizontalDispersion(:,1);
d{2}=meanHorizontalDispersion(:,2);
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', colors(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', colors(2,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
%legend([h1{1} h2{1}], {'Unconscious', 'Conscious'},'FontSize',18);
xlabel('Horizontal dispersion','FontSize',22)
%set(gca, 'YLim', [-.01 .025]);
box off
set(gca,'FontSize',22)

ax2=subplot(1, 3, 3);
d{1}=meanVerticalDispersion(:,1);
d{2}=meanVerticalDispersion(:,2);
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', colors(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', colors(2,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
%legend([h1{1} h2{1}], {'Unconscious', 'Conscious'},'FontSize',18);
xlabel('Vertical dispersion','FontSize',22)
%set(gca, 'YLim', [-.02 .045]);
box off
set(gca,'FontSize',22)

%change x-axis to be the same in dispersion plots
linkaxes([ax1,ax2],'x')

cd(codePath)

if saveFlag
    saveas(gcf,'NssSimilarityAndDispersion.svg', 'svg')
end
