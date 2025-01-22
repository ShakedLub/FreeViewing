function plotObjectiveMeasure(Data1,Data2,rows,columns,plotNum,titleText,Paths)
subplot(rows,columns,plotNum)

%addpath of cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

%data (rows experiment number, columns visibility condition)
%Experiment 1 
data{1,1}=[Data1.dPrimeUC]; %U
data{1,2}=[Data1.dPrimeC]; %C
%Experiment 2 
data{2,1}=[Data2.dPrimeUC]; %U
data{2,2}=[Data2.dPrimeC]; %C

%numtrials (rows experiment number, columns visibility condition)
%Experiment 1 
numTrials{1,1}=[Data1.numTrialsUC]; %U
numTrials{1,2}=[Data1.numTrialsC]; %C
%Experiment 2 
numTrials{2,1}=[Data2.numTrialsUC]; %U
numTrials{2,2}=[Data2.numTrialsC]; %C

cl(1, :) = cb(5, :);
cl(2, :) = cb(10, :);
h   = rm_raincloud_dots_different_sizes(data,numTrials,cl);
h.l(1).Color='None';
h.l(2).Color='None';
hold on
set(gca,'YTickLabel',{'Exp 2','Exp 1'})
y=ylim;
hold off
xlabel('d prime')
title(titleText)
set(gca,'FontSize',20)
lgd=legend([h.p{1,1} h.p{1,2}],{'U','C'});
lgd.Location='best';
lgd.FontSize=18;
cd(wd)
end