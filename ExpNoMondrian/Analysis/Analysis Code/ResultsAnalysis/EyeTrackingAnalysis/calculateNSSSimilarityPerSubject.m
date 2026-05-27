function Results_PerSubj=calculateNSSSimilarityPerSubject(Results,EXPDATA_ALL,subjNumber,Paths)
%initialize Results_PerSubj
for ii=1:length(subjNumber)
    Results_PerSubj(ii).subjNumber=subjNumber(ii);
    Results_PerSubj(ii).trial=[];
end
for ii=1:size(Results.image,2) %images
    for jj=1:size(Results.image(ii).subject,2) %subj
        subjNum=Results.image(ii).subject(jj).subjNum;  
        ind_subj=find(subjNumber==subjNum);
        TrialNumberOverall=Results.image(ii).subject(jj).TrialNumberOverall;
        BlockNum=EXPDATA_ALL{ind_subj}.Trials_Analysis([EXPDATA_ALL{ind_subj}.Trials_Analysis.TrialNumberOverall] == TrialNumberOverall).BlockNum;
        
        %trial number in Results_PerSubject        
        tt=size(Results_PerSubj(ind_subj).trial,2)+1;
        
        Results_PerSubj(ind_subj).trial(tt).BlockNum=BlockNum;
        Results_PerSubj(ind_subj).trial(tt).TrialNumberOverall=TrialNumberOverall;
        Results_PerSubj(ind_subj).trial(tt).NSSSimPerSubj=Results.image(ii).subject(jj).NSSSimPerSubj;
    end
end

%calculations for results per subj
for ii=1:size(Results_PerSubj,2) %subejcts
    blocks=unique([Results_PerSubj(ii).trial.BlockNum]);
    for bb=1:length(blocks)
        Results_PerSubj(ii).meanNSSSimBlock(bb)=mean([Results_PerSubj(ii).trial([Results_PerSubj(ii).trial.BlockNum] == blocks(bb)).NSSSimPerSubj]);
    end
    Results_PerSubj(ii).meanNSSSim=mean([Results_PerSubj(ii).trial.NSSSimPerSubj]);
    Results_PerSubj(ii).stdNSS=std([Results_PerSubj(ii).trial.NSSSimPerSubj]);
end

%%rain cloud plot
%addpath cd cbrewer
cd(Paths.RainCloudPlot)
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cl(1, :) = cb(4, :);

figure
h1 = raincloud_plot([Results_PerSubj.meanNSSSim], 'box_on', 1, 'box_dodge', 1, 'box_dodge_amount',...
    0, 'dot_dodge_amount', .3, 'color', cl, 'cloud_edge_col', cl);
box off
title('NSS similarity per participant')
xlabel('NSS similarity')
ylabel('Count')
set(gca,'FontSize',18)
cd(Paths.EyeTrackingAnalysisFolder)
end