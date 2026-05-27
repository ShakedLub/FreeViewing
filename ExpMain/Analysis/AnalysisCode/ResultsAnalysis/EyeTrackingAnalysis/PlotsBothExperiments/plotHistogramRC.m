function plotHistogramRC(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText,Paths)
% load rain cloud plot
%addpath cd cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

vecReptitions=vecReptitions*100;
realVal=realVal*100;

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
color1=cb(5,:);

subplot(rows,columns,plotNum)
h1 = raincloud_plot(vecReptitions, 'box_on', 1, 'color', color1, 'cloud_edge_col', cb(1,:),'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15, 'box_col_match', 0);

hold on
alpha=prctile(vecReptitions,prc);
lim=axis;
line([realVal,realVal],[lim(3),lim(4)],'Color',color1,'LineWidth',2)
line([alpha,alpha],[lim(3),lim(4)],'Color',color1,'LineStyle','--','LineWidth',2)

%astricks
lim=axis;
height=((lim(4)-lim(3))/12);

if ((prc == 5 && realVal < alpha) || (prc == 95 && realVal > alpha)) 
    plot(realVal,lim(4),'*','MarkerSize',10,'Color',color1);
end
hold off

xtickformat('percentage')
title(titleText,'FontWeight','normal')
xlabel(xlabelText)
set(gca,'FontSize',18)
Ax = gca;
Ax.Box = 'off';
cd(wd)
end