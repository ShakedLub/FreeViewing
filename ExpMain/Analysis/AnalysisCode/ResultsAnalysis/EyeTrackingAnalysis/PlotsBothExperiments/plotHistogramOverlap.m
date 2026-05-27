function plotHistogramOverlap(Results_PerSubj,aa,Paths)
%% load rain cloud plot 
%addpath cd cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

%% Prepare data
percentOverlapU=[];
percentOverlapC=[];
isSmallerU=[];
isSmallerC=[];
for ii=1:size(Results_PerSubj,2) %subjects
    for kk=1:size(Results_PerSubj(ii).condition,2) %conditions
        for jj=1:size(Results_PerSubj(ii).condition(kk).trial,2) %trials
            if kk == 1
                percentOverlapU=[percentOverlapU,Results_PerSubj(ii).condition(kk).trial(jj).percentOverlapObjectCircle];
                isSmallerU=[isSmallerU,Results_PerSubj(ii).condition(kk).trial(jj).isObjectSmallerThanCircle];
            else
                percentOverlapC=[percentOverlapC,Results_PerSubj(ii).condition(kk).trial(jj).percentOverlapObjectCircle];
                isSmallerC=[isSmallerC,Results_PerSubj(ii).condition(kk).trial(jj).isObjectSmallerThanCircle];
            end
        end
    end
end
percentOverlapU=percentOverlapU*100;
percentOverlapC=percentOverlapC*100;

percentOverlapU(isnan(percentOverlapU))=[];
percentOverlapC(isnan(percentOverlapC))=[];
isSmallerU(isnan(isSmallerU))=[];
isSmallerC(isnan(isSmallerC))=[];

percentOverlapU(logical(isSmallerU))=[];
percentOverlapC(logical(isSmallerC))=[];

%% plot
subplot(2,1,aa)

%colors
Param.colorAtt(1,:)=[0 0.4470 0.7410]; 
Param.colorAtt(2,:)=[0.4940 0.1840 0.5560]; 

h1 = raincloud_plot(percentOverlapU, 'box_on', 1, 'color', Param.colorAtt(1,:), 'cloud_edge_col', Param.colorAtt(1,:),'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15, 'box_col_match', 0);
h2 = raincloud_plot(percentOverlapC, 'box_on', 1, 'color', Param.colorAtt(2,:),'cloud_edge_col', Param.colorAtt(2,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35,'box_col_match', 0);
if aa ==1
    legend([h1{1} h2{1}], {'U', 'C'});
end
xtickformat('percentage')
title(['Exp ',num2str(aa)])

if aa == 2
    xlabel('Percent overlap of the circle surronding the fixation and the object')
end
ylabel('density')
ylim([-0.01 0.015])
set(gca,'FontSize',20)
Ax = gca;
Ax.Box = 'off';
cd(wd)
end