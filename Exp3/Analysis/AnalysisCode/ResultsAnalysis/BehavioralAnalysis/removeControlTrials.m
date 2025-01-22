function EXPDATA=removeControlTrials(EXPDATA)
indRemove=find([EXPDATA.TrialsAnalysis.IsControlTrial]);
if ~isempty(indRemove)
    EXPDATA.TrialsAnalysis(indRemove)=[];
end
EXPDATA.TrialsRemoved.ControlTrials=length(indRemove);
end