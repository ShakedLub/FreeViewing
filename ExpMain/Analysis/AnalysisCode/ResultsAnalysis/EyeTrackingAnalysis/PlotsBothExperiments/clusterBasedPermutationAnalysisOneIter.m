function [maxScoreCluster,clusters]=clusterBasedPermutationAnalysisOneIter(Data,Param)
%Data: subjects X time points. In each cell for a different region condition
numCond=size(Data,2); %region conditions
numTimeBins=round(size(Data{1}(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames),2)/Param.TimeBin);

%% calculate statistic for each time bin
for rr=1:numCond %region conditions
    tt=Param.AnalysisMinTimeLimitFrames-1;
    for tb=1:numTimeBins
        startTime=tt+1;
        endTime=startTime+Param.TimeBin-1;
        tt=endTime;
        Y{tb}(:,rr)=mean(Data{rr}(:,startTime:endTime),2);
    end
end

%% paired t-test for two conditions, or repeated measures anova (region conditions)
%define the within subjects columns (8 rows one per column)
if numCond ==4
    varNames={'R1','R2','R3','R4'};
    within=table([1;2;3;4],'VariableNames',{'Condition'});

    for tb=1:numTimeBins
        Tab = array2table(Y{tb}, 'VariableNames', varNames);
        
        %fit the repeated measures model
        rm=fitrm(Tab,'R1-R4 ~ 1','WithinDesign',within);

        %Run the 2 factors repeated measures anova
        ranovatabl=ranova(rm,'WithinModel','Condition');
        
        idx=strcmp(ranovatabl.Properties.RowNames,'(Intercept):Condition');
        F(tb)=ranovatabl.F(idx);
        Pval(tb)=ranovatabl.pValue(idx);
        
        %Post-hoc pairwise comparisons
        %mc = multcompare(rm, 'Condition', 'ComparisonType', 'bonferroni');
    end
    
elseif numCond == 2
    for tb=1:numTimeBins
        [BinaryData(tb),Pval(tb),~,stats{tb}]= ttest(Y{tb}(:,1),Y{tb}(:,2),'Tail','Right');
        T(tb)=stats{tb}.tstat;
     end
end

%% find critical time bins
if numCond ==4
    BinaryData=zeros(1,length(F));
    BinaryData(Pval<0.05)=1;
end

%% find clusters in time
d=diff([0 BinaryData 0]);
starts= find(d==1);
ends = find(d==-1)-1;

startsTimeVec=Param.AnalysisMinTimeLimitFrames:Param.TimeBin:Param.AnalysisMaxTimeLimitFrames;
startsTimeVec(end)=[];
endsTimeVec=startsTimeVec+Param.TimeBin;

startsTime=startsTimeVec(starts);
endsTime=endsTimeVec(ends);

%% calculate cluster statisitc
if numCond ==4
    for cl=1:length(starts)
        ScoreCluster(cl)=sum(F(starts(cl):ends(cl)));
    end
elseif numCond ==2
    for cl=1:length(starts)
        ScoreCluster(cl)=sum(T(starts(cl):ends(cl)));
    end
end
if length(starts) ~= 0
    maxScoreCluster=max(ScoreCluster);
else
    maxScoreCluster=0;
    ScoreCluster=[];
end

clusters.BinaryData=BinaryData;
clusters.startsBin=starts;
clusters.endsBin=ends;
clusters.startsTime=startsTime;
clusters.endsTime=endsTime;
clusters.ScoreCluster=ScoreCluster;
end
