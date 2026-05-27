function EXPDATA=removeTrialsWithBlinksSegmented(EXPDATA,AnalysisTimeLimitFlag,AnalysisMinTimeLimitFrames,AnalysisMaxTimeLimitFrames)
trialsBlinks=[];
for ii=1:size(EXPDATA.Trials_Analysis,2) %trials
    clear non_nan_times_vec
    non_nan_times_vec=EXPDATA.Trials_Analysis(ii).non_nan_times;
    if AnalysisTimeLimitFlag==1
        non_nan_times_vec=non_nan_times_vec(AnalysisMinTimeLimitFrames:AnalysisMaxTimeLimitFrames);
    end
    if ~isempty(find(non_nan_times_vec==0))
        trialsBlinks=[trialsBlinks,ii];
    end
end
if ~isempty(trialsBlinks)
    EXPDATA.Trials_Analysis(trialsBlinks)=[];
end
EXPDATA.TrialsRemoved.TrialsWithBlinks=length(trialsBlinks);
end