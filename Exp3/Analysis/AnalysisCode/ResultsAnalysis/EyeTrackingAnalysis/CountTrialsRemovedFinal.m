function TrialsRemoved=CountTrialsRemovedFinal(fixations_perSubj,TrialsRemoved)
for ii=1:size(fixations_perSubj,2) %subjects
    indSubjnumTrialsSummary=find([TrialsRemoved.numTrialsSummary.SubjNum]==fixations_perSubj(ii).subjNum);
    
    TrialsRemoved.numTrialsSummaryFinal(ii).SubjNum=fixations_perSubj(ii).subjNum;    
    TrialsRemoved.numTrialsSummaryFinal(ii).ImageTrialsU=size(fixations_perSubj(ii).condition(1).trial,2);
    TrialsRemoved.numTrialsSummaryFinal(ii).ImageTrialsC=size(fixations_perSubj(ii).condition(2).trial,2);
    
    matOld(ii,1)=TrialsRemoved.numTrialsSummary(indSubjnumTrialsSummary).ImageTrialsU;
    matOld(ii,2)=TrialsRemoved.numTrialsSummary(indSubjnumTrialsSummary).ImageTrialsC;

    matNew(ii,1)=TrialsRemoved.numTrialsSummaryFinal(ii).ImageTrialsU;
    matNew(ii,2)=TrialsRemoved.numTrialsSummaryFinal(ii).ImageTrialsC;

    indSubjdataU=find([TrialsRemoved.data.SubjectNumber]==fixations_perSubj(ii).subjNum & [TrialsRemoved.data.ExpCond]==1);
    indSubjdataC=find([TrialsRemoved.data.SubjectNumber]==fixations_perSubj(ii).subjNum & [TrialsRemoved.data.ExpCond]==2);
    
    TrialsRemoved.data(indSubjdataU).AllFixations=matOld(ii,1)-matNew(ii,1);
    TrialsRemoved.data(indSubjdataC).AllFixations=matOld(ii,2)-matNew(ii,2);
    TrialsRemoved.data(indSubjdataU).PercentRemovedFixations=TrialsRemoved.data(indSubjdataU).AllFixations/TrialsRemoved.data(indSubjdataU).AllImageTrials;
    TrialsRemoved.data(indSubjdataC).PercentRemovedFixations=TrialsRemoved.data(indSubjdataC).AllFixations/TrialsRemoved.data(indSubjdataC).AllImageTrials;
    
    TrialsRemoved.data(indSubjdataU).TrialsAfterRemoval=matNew(ii,1);
    TrialsRemoved.data(indSubjdataC).TrialsAfterRemoval=matNew(ii,2);
    TrialsRemoved.data(indSubjdataU).PercentRemovedFinal=1-(TrialsRemoved.data(indSubjdataU).TrialsAfterRemoval/TrialsRemoved.data(indSubjdataU).AllImageTrials);
    TrialsRemoved.data(indSubjdataC).PercentRemovedFinal=1-(TrialsRemoved.data(indSubjdataC).TrialsAfterRemoval/TrialsRemoved.data(indSubjdataC).AllImageTrials);
end

%average percent number of trials, across all participants
for kk=1:2
    TrialsRemoved.meanPercentTrialsRemoved_Fixations(kk)=mean([TrialsRemoved.data([TrialsRemoved.data.ExpCond]==kk).PercentRemovedFixations]);
    TrialsRemoved.meanPercentRemovedFinal(kk)=mean([TrialsRemoved.data([TrialsRemoved.data.ExpCond]==kk).PercentRemovedFinal]);
end
end
