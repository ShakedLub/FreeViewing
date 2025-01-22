function plotAwareness(Data,Paths)
%% recognition accuracy
%addpath cbrewer
cd(Paths.RainCloudPlot)
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

figure
data{1,1}=[Data.AccuracyUC];
data{2,1}=[Data.AccuracyC];
cl(1, :) = cb(1, :);
h   = rm_raincloud(data, cl);
hold on
y=ylim;
line([0.5,0.5],y,'Color','blue','LineStyle','--','LineWidth',2)
line([0.8,0.8],y,'Color','blue','LineStyle','--','LineWidth',2)
hold off
xlabel('Sucsess rate','FontSize',24)
set(gca,'YTickLabel',{'Conscious (PAS 3+4)','Unconscious (PAS 1)'})
set(gca,'FontSize',24)
cd(Paths.BehavioralAnalysisFolder)
end