function Results=clusterBasedPermutationAnalysis(SaccRate,dataPerSubjPerCond,Param)
%real result
[Results.maxScoreCluster,Results.clusters]=clusterBasedPermutationAnalysisOneIter(SaccRate,Param);

%permute data
for nn=1:Param.numReptitions
    for cc=1:size(dataPerSubjPerCond,2) %conditions
        meanSaccRate{cc}=nan(size(dataPerSubjPerCond{cc},2),size(dataPerSubjPerCond{cc}{1},2));
        SaccRatePerm{cc}=nan(size(dataPerSubjPerCond{cc},2),size(dataPerSubjPerCond{cc}{1},2));
    end
    for ii=1:size(dataPerSubjPerCond{1},2) %subjects
        AlltTrials=[];
        TrialLabels=[];
        TrialData=[];
        for cc=1:size(dataPerSubjPerCond,2) %conditions
            AlltTrials=[AlltTrials;dataPerSubjPerCond{cc}{ii}];
            TrialLabels=[TrialLabels,cc*ones(1,size(dataPerSubjPerCond{cc}{ii},1))];
        end
        indrand=randperm(length(TrialLabels));
        TrialLabels=TrialLabels(indrand);
        for cc=1:size(dataPerSubjPerCond,2) %conditions
            TrialData{cc}=AlltTrials(TrialLabels==cc,:);
            
            %average across trials and change to Hz
            meanSaccRate{cc}(ii,:)=mean(TrialData{cc},1).*Param.EyeTrackerFrameRate;
            
            %smooth
            for aa=1:length(meanSaccRate{cc}(ii,:))
                startWindow=max(1,aa-round(Param.smoothWindow/2)+1);
                endWindow=min(length(meanSaccRate{cc}(ii,:)),aa+round(Param.smoothWindow/2));
                SaccRatePerm{cc}(ii,aa)=mean(meanSaccRate{cc}(ii,startWindow:endWindow));
            end
        end
    end
    [Results.maxScoreClusterPermutation(nn),~]=clusterBasedPermutationAnalysisOneIter(SaccRatePerm,Param);
end

%Calculate p-value per cluster
for cl=1:length(Results.clusters.ScoreCluster)
    Results.numExtremeObs(cl)=sum(Results.maxScoreClusterPermutation > Results.clusters.ScoreCluster(cl))+1;
    Results.numAllObs(cl)=length(Results.maxScoreClusterPermutation)+1;
    Results.pval(cl)=Results.numExtremeObs(cl)/Results.numAllObs(cl);
end
end
