function Results_PerSubj=calculateNSSSimilarityPerSubject(Results,EXPDATA_ALL,subjNumber)

%initialize Results_PerSubj
for ii=1:length(subjNumber)
    Results_PerSubj(ii).subjNumber=subjNumber(ii);
    for kk=1:size(EXPDATA_ALL,2) %conditions
        Results_PerSubj(ii).condition(kk).trial=[];
    end
end

%divide NSS results per subject
for ii=1:size(Results.image,2) %images
    for kk=1:size(Results.image(ii).condition,2) %conditions
        for jj=1:size(Results.image(ii).condition(kk).subject,2) %subj
            subjNum=Results.image(ii).condition(kk).subject(jj).subjNum;
            ind_subj=find(subjNumber==subjNum);
            TrialNumberOverall=Results.image(ii).condition(kk).subject(jj).TrialNumberOverall;
            BlockNum=EXPDATA_ALL{ind_subj,kk}.Trials_Analysis([EXPDATA_ALL{ind_subj,kk}.Trials_Analysis.TrialNumberOverall] == TrialNumberOverall).BlockNum;
            
            %trial number in Results_PerSubject
            tt=size(Results_PerSubj(ind_subj).condition(kk).trial,2)+1;
            
            Results_PerSubj(ind_subj).condition(kk).trial(tt).BlockNum=BlockNum;
            Results_PerSubj(ind_subj).condition(kk).trial(tt).TrialNumberOverall=TrialNumberOverall;
            Results_PerSubj(ind_subj).condition(kk).trial(tt).NSSSimPerSubj=Results.image(ii).condition(kk).subject(jj).NSSSimPerSubj;
        end
    end
end

%calculations for results per subj
for ii=1:size(Results_PerSubj,2) %subejcts
    for kk=1:size(Results_PerSubj(ii).condition,2) %condition
        blocks=unique([Results_PerSubj(ii).condition(kk).trial.BlockNum]);
        for bb=1:length(blocks)
            Results_PerSubj(ii).condition(kk).meanNSSSimBlock(bb)=mean([Results_PerSubj(ii).condition(kk).trial([Results_PerSubj(ii).condition(kk).trial.BlockNum] == blocks(bb)).NSSSimPerSubj]);
        end
    end
    Results_PerSubj(ii).meanNSSSim_U=mean([Results_PerSubj(ii).condition(1).trial.NSSSimPerSubj]);
    Results_PerSubj(ii).meanNSSSim_C=mean([Results_PerSubj(ii).condition(2).trial.NSSSimPerSubj]);
    Results_PerSubj(ii).stdNSSSim_U=std([Results_PerSubj(ii).condition(1).trial.NSSSimPerSubj]);
    Results_PerSubj(ii).stdNSSSim_C=std([Results_PerSubj(ii).condition(2).trial.NSSSimPerSubj]);
end

%% Plot
figure
yU=[Results_PerSubj.meanNSSSim_U];
yC=[Results_PerSubj.meanNSSSim_C];
y=[yU,yC];
x=[ones(1,size(Results_PerSubj,2)),ones(1,size(Results_PerSubj,2))*2];
scatter(x,y,50,'o','filled',...
    'MarkerEdgeColor',[0 .5 .5],...
    'MarkerFaceColor',[0 .7 .7])
hold on
for ii=1:size(Results_PerSubj,2) %subjects
    line([1 2],[yU(ii),yC(ii)],'LineStyle','--')
end
boxplot(y,x)
hold off
set(gca,'XTick',[1,2])
set(gca,'XTickLabel',{'Unconscious','Conscious'})
ylabel('NSS Similarity')
xlabel('Visibilty Conditions')
set(gca,'FontSize',20)
end