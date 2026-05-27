function plotMainSequence(EXPDATA_ALL,subjNumber)
%create all saccades matrix for each observer
for ii=1:length(subjNumber) %subjects
    AllSaccades(ii).subjNum=subjNumber(ii);
    AllSaccades(ii).sacc_Amp=[];
    AllSaccades(ii).sacc_Vel=[];
    AllSaccades(ii).sacc_Dur=[];
    AllSaccades(ii).subjIdPlot=[];
end

for ii=1:length(EXPDATA_ALL) %subjects
    subjNum=EXPDATA_ALL{ii}.info.subject_info.subject_number_and_experiment;
    indSubj=find(subjNumber==subjNum);
    for jj=1:size(EXPDATA_ALL{ii}.Trials_Analysis,2) %trials
        AllSaccades(indSubj).sacc_Amp=[AllSaccades(indSubj).sacc_Amp,EXPDATA_ALL{ii}.Trials_Analysis(jj).saccadeAmplitudes];
        AllSaccades(indSubj).sacc_Vel=[AllSaccades(indSubj).sacc_Vel,EXPDATA_ALL{ii}.Trials_Analysis(jj).saccadeVelocities];
        AllSaccades(indSubj).sacc_Dur=[AllSaccades(indSubj).sacc_Dur,EXPDATA_ALL{ii}.Trials_Analysis(jj).saccadeDurations];
        AllSaccades(indSubj).subjIdPlot=[AllSaccades(indSubj).subjIdPlot,ones(1,length(EXPDATA_ALL{ii}.Trials_Analysis(jj).saccadeDurations))*ii];
    end
end

%plot main saccade for all subjects
figure
x=[AllSaccades.sacc_Amp];
y=[AllSaccades.sacc_Vel];
id=[AllSaccades.subjIdPlot];
scatter(x,y,10,id,'filled')
xlabel('Saccade amplitude')
ylabel('Saccade velocity')
P = polyfit(x,y,1);
yfit = polyval(P,x);
hold on;
plot(x,yfit,'r');
eqn = string("Linear: y = " + round(P(1),2)) + "x + " + string(round(P(2),2));
text(min(x),max(y),eqn,"HorizontalAlignment","left","VerticalAlignment","top",'FontSize',18)
[r,pval]=corr(x',y');
title(['r= ',num2str(round(r,2)),'pval=',num2str(round(pval,2))])
set(gca,'FontSize',18)
end