function TrialsRemoved=CountTrialsRemovedFinal(fixations_perSubj,TrialsRemoved)
for ii=1:size(fixations_perSubj,2) %subjects
    indSubjnumTrialsSummary=find([TrialsRemoved.numTrialsSummary.SubjNum]==fixations_perSubj(ii).subjNum);
    
    TrialsRemoved.numTrialsSummaryFinal(ii).SubjNum=fixations_perSubj(ii).subjNum;    
    TrialsRemoved.numTrialsSummaryFinal(ii).numTrials=size(fixations_perSubj(ii).trial,2);
    
    matOld(ii)=TrialsRemoved.numTrialsSummary(indSubjnumTrialsSummary).numTrials;
    matNew(ii)=TrialsRemoved.numTrialsSummaryFinal(ii).numTrials;

    indSubjdata=find([TrialsRemoved.data.SubjectNumber]==fixations_perSubj(ii).subjNum);
    
    TrialsRemoved.data(indSubjdata).AllFixations=matOld(ii)-matNew(ii);
    TrialsRemoved.data(indSubjdata).PercentRemovedFixations=TrialsRemoved.data(indSubjdata).AllFixations/TrialsRemoved.data(indSubjdata).AllTrials;
    
    TrialsRemoved.data(indSubjdata).TrialsAfterRemoval=matNew(ii);
    TrialsRemoved.data(indSubjdata).PercentRemovedFinal=1-(TrialsRemoved.data(indSubjdata).TrialsAfterRemoval/TrialsRemoved.data(indSubjdata).AllTrials);
end

%average percent number of trials, across all participants
TrialsRemoved.meanPercentTrialsRemoved_Fixations=mean([TrialsRemoved.data.PercentRemovedFixations]);
TrialsRemoved.meanPercentRemovedFinal=mean([TrialsRemoved.data.PercentRemovedFinal]);
end
