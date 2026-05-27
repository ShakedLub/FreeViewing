function Results=checkMemoryPerformance(EXPDATA_ALL,Paths)
for ii=1:length(EXPDATA_ALL) %subejcts
    EXPDATA=EXPDATA_ALL{ii};

    %make sure only blocks with trials included in eye tracking analysis
    %are included in memory analysis
    blockNumbers=unique([EXPDATA.Trials_Experiment.BlockNum]);
    
    indInclude=ismember([EXPDATA.Memory_Task_Trials_Experiment.BlockNum],blockNumbers);
    Trials=EXPDATA.Memory_Task_Trials_Experiment(indInclude);
    
    %exclude trials that subject didn't answer
    indNotAnswer=find([Trials.DidAnswer]==0);
    Trials(indNotAnswer)=[];
    
    %percent correct per block
    Results.data(ii).percentCorrect=sum([Trials.IsCorrect])/size(Trials,2);
end
Results.meanPercentCorrect=mean([Results.data.percentCorrect]);
Results.stdPercentCorrect=std([Results.data.percentCorrect]);
Results.minPercentCorrect=min([Results.data.percentCorrect]);
Results.maxPercentCorrect=max([Results.data.percentCorrect]);

%% plot
figure
%%rain cloud plot
%addpath cd cbrewer
cd(Paths.RainCloudPlot)
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cl(1, :) = cb(3, :);
h1 = raincloud_plot([Results.data.percentCorrect]*100, 'box_on', 1, 'color', cl,'cloud_edge_col', cl, 'alpha', 1,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
    'box_col_match', 0);
box off
xtickformat('percentage')
xlim([60 120])
xlabel('Accuracy')
set(gca,'FontSize',18)
cd(Paths.EyeTrackingAnalysisFolder)
end