function plotObjectiveAndSubjectiveMeasures(data1,data2,titleText,rows,columns,plotNum,Paths)
%% create data
labels = {'PAS 1','PAS 2','PAS 3','PAS 4'};
indLabels=[1,3,4,6];
D1=createData(data1,labels,indLabels);
D2=createData(data2,labels,indLabels);

%% Plot
subplot(rows,columns,plotNum)

%addpath of cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

% read into cell array of the appropriate dimensions
for pas = 1:length(labels)
    for group = 1:4
        if group == 1 %U experiment 1
            data(group,pas)=nanmean(D1.condition(1).SR(:,pas));
            dataErr(group,pas)=nanstd(D1.condition(1).SR(:,pas))/sqrt(sum(~isnan(D1.condition(1).SR(:,pas))));
            dataPoints{group,pas} = D1.condition(1).SR(:,pas);
        elseif group == 2 %C experiment 1
            data(group,pas)=nanmean(D1.condition(2).SR(:,pas));
            dataErr(group,pas)=nanstd(D1.condition(2).SR(:,pas))/sqrt(sum(~isnan(D1.condition(2).SR(:,pas))));
            dataPoints{group,pas} = D1.condition(2).SR(:,pas);
        elseif group == 3 %U experiment 2
            data(group,pas)=nanmean(D2.condition(1).SR(:,pas));
            dataErr(group,pas)=nanstd(D2.condition(1).SR(:,pas))/sqrt(sum(~isnan(D2.condition(1).SR(:,pas))));
            dataPoints{group,pas} = D2.condition(1).SR(:,pas);
        elseif group == 4 %C experiment 2
            data(group,pas)=nanmean(D2.condition(2).SR(:,pas));
            dataErr(group,pas)=nanstd(D2.condition(2).SR(:,pas))/sqrt(sum(~isnan(D2.condition(2).SR(:,pas))));
            dataPoints{group,pas} = D2.condition(2).SR(:,pas);
        end
    end
end
cd(wd)
colors(1,:)=cb(5, :); %blue
colors(2,:) = cb(1, :); %green 
colors(3,:) =cb(3, :) ; %purple
colors(4,:) = cb(10, :); %purple
bh=ErrorBarOnGroupedBarsWithScatter(data,dataErr,dataPoints,colors);

bh(1).FaceColor = cb(5, :); %blue
bh(2).FaceColor = cb(1, :); %green
bh(3).FaceColor = cb(3, :) ; %purple
bh(4).FaceColor = cb(10, :); %purple

% bh(1).EdgeColor = [1 1 1]; 
% bh(2).EdgeColor = [1 1 1]; 
% bh(3).EdgeColor = [1 1 1]; 
% bh(4).EdgeColor = [1 1 1]; 

yline(50,'Color',[0.5 0.5 0.5],'LineWidth',1)

set(gca,'XTickLabel',{'U','C','U','C'})
set(gca,'FontSize',20);
ytickformat('percentage')
title(titleText)
ylabel('Accuracy')
%lgd=legend(labels);
%lgd.Location='southwest';
%lgd.FontSize=18;
ylim([20 100])

    function D=createData(data,labels,indLabels)
        for cc=1:size(data,2) %visibility condition
            for ii=1:length(indLabels) %PAS option
                for ss=1:size(data,1) %subejct
                    D.condition(cc).SR(ss,ii)=data{ss,cc}(indLabels(ii)).accuracyRecognitionTest*100;
                end
            end
        end
    end
end