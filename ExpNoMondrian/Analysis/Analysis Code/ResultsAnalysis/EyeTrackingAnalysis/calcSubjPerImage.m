function Summary=calcSubjPerImage(fixations,Paths)
for ii=1:size(fixations,2)
    Summary.NumSubjPerImage(ii)=size(fixations(ii).subject,2);
end
Summary.meanSubj=mean(Summary.NumSubjPerImage);
Summary.stdSubj=std(Summary.NumSubjPerImage);
Summary.rangeSubj=[min(Summary.NumSubjPerImage),max(Summary.NumSubjPerImage)];

%% Plot 
%%rain cloud plot
%addpath cd cbrewer
cd(Paths.RainCloudPlot)
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cl(1, :) = cb(4, :);

figure
h1 = raincloud_plot(Summary.NumSubjPerImage, 'box_on', 1, 'box_dodge', 1, 'box_dodge_amount',...
    0, 'dot_dodge_amount', .3, 'color', cl, 'cloud_edge_col', cl);
box off
title('Number of participants per image')
xlabel('Number of subjects')
ylabel('Count')
set(gca,'FontSize',18)
cd(Paths.EyeTrackingAnalysisFolder)
end