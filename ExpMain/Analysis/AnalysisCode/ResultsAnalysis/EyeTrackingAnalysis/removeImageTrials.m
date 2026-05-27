function EXPDATA=removeImageTrials(EXPDATA)
indRemove=find([EXPDATA.Trials_Analysis.IsImageTrial]);
if ~isempty(indRemove)
    EXPDATA.Trials_Analysis(indRemove)=[];
end
EXPDATA.TrialsRemoved.ControlTrials=length(indRemove);
end