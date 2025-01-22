function plotMainSequence(EXPDATA_ALL,subjNumber)
%create all saccades matrix for each observer
for ii=1:length(subjNumber) %subjects
    AllSaccades(ii).subjNum=subjNumber(ii);
    for kk=1:size(EXPDATA_ALL,2) %condition        
        AllSaccades(ii).condition(kk).sacc_Amp=[];
        AllSaccades(ii).condition(kk).sacc_Vel=[];
        AllSaccades(ii).condition(kk).sacc_Dur=[];
        AllSaccades(ii).condition(kk).subjIdPlot=[];
    end
end

for ii=1:size(EXPDATA_ALL,1) %subjects
    for kk=1:size(EXPDATA_ALL,2) %condition
        subjNum=EXPDATA_ALL{ii,kk}.info.subject_info.subject_number_and_experiment;
        indSubj=find(subjNumber==subjNum);
        for jj=1:size(EXPDATA_ALL{ii,kk}.Trials_Analysis,2) %trials
            AllSaccades(indSubj).condition(kk).sacc_Amp=[AllSaccades(indSubj).condition(kk).sacc_Amp,EXPDATA_ALL{ii,kk}.Trials_Analysis(jj).saccadeAmplitudes];
            AllSaccades(indSubj).condition(kk).sacc_Vel=[AllSaccades(indSubj).condition(kk).sacc_Vel,EXPDATA_ALL{ii,kk}.Trials_Analysis(jj).saccadeVelocities];
            AllSaccades(indSubj).condition(kk).sacc_Dur=[AllSaccades(indSubj).condition(kk).sacc_Dur,EXPDATA_ALL{ii,kk}.Trials_Analysis(jj).saccadeDurations];
            AllSaccades(indSubj).condition(kk).subjIdPlot=[AllSaccades(indSubj).condition(kk).subjIdPlot,ones(1,length(EXPDATA_ALL{ii,kk}.Trials_Analysis(jj).saccadeDurations))*ii];
        end
    end
end

%plot main saccade for all subjects
figure
for kk=1:size(EXPDATA_ALL,2) %condition
    subplot(1,2,kk)
    x=[];
    y=[];
    id=[];
    for ii=1:size(EXPDATA_ALL,1) %subjects
        x=[x,AllSaccades(ii).condition(kk).sacc_Amp];
        y=[y,AllSaccades(ii).condition(kk).sacc_Vel];
        id=[id,AllSaccades(ii).condition(kk).subjIdPlot];
    end
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
    if kk==1
        title(['Unconscious condition r= ',num2str(round(r,2)),'pval=',num2str(round(pval,2))])
    else
        title(['Conscious condition r= ',num2str(round(r,2)),'pval=',num2str(round(pval,2))])
    end
    set(gca,'FontSize',20)
end
end