function DispersionPerSubj=CalcFixationDispersionPerSubj(DispersionResults,fixations,subjNumber)
for ii=1:length(subjNumber)
    DispersionPerSubj(ii).subjNumber=subjNumber(ii);
    for kk=1:size(fixations(1).condition,2) %conditions
        DispersionPerSubj(ii).condition(kk).scoresH=[];
        DispersionPerSubj(ii).condition(kk).scoresV=[];
    end
end
for ii=1:size(DispersionResults.scores,2) %images
    for kk=1:size(DispersionResults.scores(ii).condition,2) %conditions
        for jj=1:size(DispersionResults.scores(ii).condition(kk).subject,2) %subj
            if ~isempty([DispersionResults.scores(ii).condition(kk).subject.horizontalDispersion])
                subjN=fixations(ii).condition(kk).subject(jj).subjNum;
                scoreH=DispersionResults.scores(ii).condition(kk).subject(jj).horizontalDispersion;
                scoreV=DispersionResults.scores(ii).condition(kk).subject(jj).verticalDispersion;
                
                ind=find(subjNumber==subjN);
                DispersionPerSubj(ind).condition(kk).scoresH=[DispersionPerSubj(ind).condition(kk).scoresH,scoreH];
                DispersionPerSubj(ind).condition(kk).scoresV=[DispersionPerSubj(ind).condition(kk).scoresV,scoreV];
            end
        end
    end
end
for ii=1:size(DispersionPerSubj,2) %subejcts   
    DispersionPerSubj(ii).horizontalDispersion_U=mean(DispersionPerSubj(ii).condition(1).scoresH);
    DispersionPerSubj(ii).horizontalDispersion_C=mean(DispersionPerSubj(ii).condition(2).scoresH);
    DispersionPerSubj(ii).horizontalDispersion=mean([DispersionPerSubj(ii).condition(1).scoresH,DispersionPerSubj(ii).condition(2).scoresH]);
    
    DispersionPerSubj(ii).verticalDispersion_U=mean(DispersionPerSubj(ii).condition(1).scoresV);
    DispersionPerSubj(ii).verticalDispersion_C=mean(DispersionPerSubj(ii).condition(2).scoresV);
    DispersionPerSubj(ii).verticalDispersion=mean([DispersionPerSubj(ii).condition(1).scoresV,DispersionPerSubj(ii).condition(2).scoresV]);
end

%% Plot
subplot(1,3,2)
yU=[DispersionPerSubj.horizontalDispersion_U];
yC=[DispersionPerSubj.horizontalDispersion_C];
y=[yU,yC];
x=[ones(1,size(DispersionPerSubj,2)),ones(1,size(DispersionPerSubj,2))*2];
scatter(x,y,50,'o','filled',...
    'MarkerEdgeColor',[0 .5 .5],...
    'MarkerFaceColor',[0 .7 .7])
hold on
for ii=1:size(DispersionPerSubj,2) %subjects
    line([1 2],[yU(ii),yC(ii)],'LineStyle','--')
end
boxplot(y,x)
hold off
set(gca,'XTick',[1,2])
set(gca,'XTickLabel',{'Unconscious','Conscious'})
ylabel('Horizontal dispersion')
xlabel('Visibilty Conditions')
set(gca,'FontSize',20)

subplot(1,3,3)
yU=[DispersionPerSubj.verticalDispersion_U];
yC=[DispersionPerSubj.verticalDispersion_C];
y=[yU,yC];
x=[ones(1,size(DispersionPerSubj,2)),ones(1,size(DispersionPerSubj,2))*2];
scatter(x,y,50,'o','filled',...
    'MarkerEdgeColor',[0 .5 .5],...
    'MarkerFaceColor',[0 .7 .7])
hold on
for ii=1:size(DispersionPerSubj,2) %subjects
    line([1 2],[yU(ii),yC(ii)],'LineStyle','--')
end
boxplot(y,x)
hold off
set(gca,'XTick',[1,2])
set(gca,'XTickLabel',{'Unconscious','Conscious'})
ylabel('Vertical dispersion')
xlabel('Visibilty Conditions')
set(gca,'FontSize',20)
end