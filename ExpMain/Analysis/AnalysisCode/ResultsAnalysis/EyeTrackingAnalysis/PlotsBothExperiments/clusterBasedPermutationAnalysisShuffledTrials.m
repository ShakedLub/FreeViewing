function Results=clusterBasedPermutationAnalysisShuffledTrials(SaccRate,Fixations_PerSubj,Results_PerSubj,Param,Paths,kk,conditions) 
plotFlag=0;

%real result
[Results.maxScoreCluster,Results.clusters]=clusterBasedPermutationAnalysisOneIter(SaccRate,Param);
if plotFlag
    cd(Paths.ShadedStdPlot)
    figure
    lineOut1=stdshade(SaccRate{1}(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames), 0.3, 'r',Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames);
    hold on
    lineOut2=stdshade(SaccRate{2}(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames), 0.3, 'b',Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames);
    hold off
    ylim([0,0.8e-4]);
    cd(Paths.codePath)
end

%create saccade rate trace and calculate max score cluster for shuffled data
imsize=ceil([Fixations_PerSubj.subject(1).condition(1).trial(1).processed.rect(4),Fixations_PerSubj.subject(1).condition(1).trial(1).processed.rect(3)]);

for nn=1:Param.numReptitions
    SaccRatePerm=[];
    Results_SaccRateTrace=saccadeRateTraceObjects(Fixations_PerSubj.shuffled(nn).subject,Results_PerSubj.shuffled(nn).subject,Param,'shuffled');
    SaccRatePerm{1}=Results_SaccRateTrace.condition(kk).(['SaccRate_',conditions{1}]);
    SaccRatePerm{2}=Results_SaccRateTrace.condition(kk).(['SaccRate_',conditions{2}]);
    [Results.maxScoreClusterPermutation(nn),~]=clusterBasedPermutationAnalysisOneIter(SaccRatePerm,Param);
     
    if plotFlag
        cd(Paths.ShadedStdPlot)
        figure
        lineOut1=stdshade(Results_SaccRateTrace.condition(kk).(['SaccRate_',conditions{1}])(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames), 0.3, 'r',Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames);
        hold on
        lineOut2=stdshade(Results_SaccRateTrace.condition(kk).(['SaccRate_',conditions{2}])(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames), 0.3, 'b',Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames);
        hold off
        ylim([0,0.8e-4]);
        cd(Paths.codePath)
    end
end

%Calculate p-value per cluster
for cl=1:length(Results.clusters.ScoreCluster)
    Results.numExtremeObs(cl)=sum(Results.maxScoreClusterPermutation > Results.clusters.ScoreCluster(cl))+1;
    Results.numAllObs(cl)=length(Results.maxScoreClusterPermutation)+1;
    Results.pval(cl)=Results.numExtremeObs(cl)/Results.numAllObs(cl);
end
end