function plotSubjectiveMeasure(dataPAS1,dataPAS2,titleText,rows,columns,plotNum,Paths)
subplot(rows,columns,plotNum)

%addpath of cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

labels = {'PAS 1','PAS 2','PAS 3','PAS 4'};
indLabels=[1,3,4,6];
%data (rows visibility condition and experiment, columns PAS number)
for ii=1:length(indLabels)
    data(1,ii)=dataPAS1(indLabels(ii)).meanCount(1); %U exp 1
    data(2,ii)=dataPAS1(indLabels(ii)).meanCount(2);  %C exp 1
    data(3,ii)=dataPAS2(indLabels(ii)).meanCount(1); %U exp 2
    data(4,ii)=dataPAS2(indLabels(ii)).meanCount(2);  %C exp 2
    
    dataErr(1,ii)=dataPAS1(indLabels(ii)).stdErrCount(1); %U exp 1
    dataErr(2,ii)=dataPAS1(indLabels(ii)).stdErrCount(2);  %C exp 1
    dataErr(3,ii)=dataPAS2(indLabels(ii)).stdErrCount(1); %U exp 2
    dataErr(4,ii)=dataPAS2(indLabels(ii)).stdErrCount(2);  %C exp 2
    

    dataPoints{1,ii}=dataPAS1(indLabels(ii)).countPAS(:,1);%U exp 1
    dataPoints{2,ii}=dataPAS1(indLabels(ii)).countPAS(:,2);%C exp 1
    dataPoints{3,ii}=dataPAS2(indLabels(ii)).countPAS(:,1);%U exp 2
    dataPoints{4,ii}=dataPAS2(indLabels(ii)).countPAS(:,2);%C exp 2
end
cd(wd)
bh=ErrorBarOnGroupedBarsWithScatter(data,dataErr,dataPoints);
 
bh(1).FaceColor = cb(5, :); %blue
bh(2).FaceColor = cb(1, :); %green 
bh(3).FaceColor =cb(3, :) ; %purple
bh(4).FaceColor = cb(10, :); %purple

set(gca,'XTickLabel',{'U','C','U','C'})
set(gca,'FontSize',20);
title(titleText)
ylabel('Number of trials')
lgd=legend(labels);
%lgd.Location='best';
lgd.FontSize=18;
end