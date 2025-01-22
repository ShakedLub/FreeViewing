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
            dataPoints{group,pas} = D1.condition(1).SR(:,pas);
        elseif group == 2 %C experiment 1
            data(group,pas)=nanmean(D1.condition(2).SR(:,pas));
            dataPoints{group,pas} = D1.condition(2).SR(:,pas);
        elseif group == 3 %U experiment 2
            data(group,pas)=nanmean(D2.condition(1).SR(:,pas));
            dataPoints{group,pas} = D2.condition(1).SR(:,pas);
        elseif group == 4 %C experiment 2
            data(group,pas)=nanmean(D2.condition(2).SR(:,pas));
            dataPoints{group,pas} = D2.condition(2).SR(:,pas);
        end
    end
end
cd(wd)
bh=bar(data);

% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(data);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
hold on
for i = 1:nbars %num PAS options
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    for j=1:length(x) %ngroups
        scatter(x(j)*ones(1,length(dataPoints{j,i})), dataPoints{j,i},20,[0.6,0.6,0.6],'filled')
    end
end
yline(50,'Color',[0.5,0.5,0.5])
hold off
bh(1).FaceColor = cb(5, :); %blue
bh(2).FaceColor = cb(1, :); %green 
bh(3).FaceColor =cb(3, :) ; %purple
bh(4).FaceColor = cb(10, :); %purple

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