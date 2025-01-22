function EXPDATA=removeSpecificTrials(EXPDATA,TRIALS_REMOVE)
indRemove=[];
TrialNumberOverall=[EXPDATA.TrialsAnalysis.TrialNumberOverall];
for ii=1:length(TRIALS_REMOVE) %trials to remove
    if ~isempty(find(TrialNumberOverall==TRIALS_REMOVE(ii)))
        ind=find(TrialNumberOverall==TRIALS_REMOVE(ii));
        indRemove=[indRemove,ind];
    end
end
if ~isempty(indRemove)
    EXPDATA.TrialsAnalysis(indRemove)=[];
end
EXPDATA.TrialsRemoved.SpecificTrials=length(indRemove);
end