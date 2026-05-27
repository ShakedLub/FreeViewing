function EXPDATA=removeControlTrials(EXPDATA)
indRemove=find([EXPDATA.Trials_Analysis.IsControlTrial]);
if ~isempty(indRemove)
    EXPDATA.Trials_Analysis(indRemove)=[];
end
EXPDATA.TrialsRemoved.ControlTrials=length(indRemove);
end