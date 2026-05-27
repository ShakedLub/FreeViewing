function EXPDATA=removeTrialsAwarenessMeasuresControlTrials(EXPDATA)
%Include all PASs for control trials
%Also remove trials with no answer in recognition question

%exclude trials with no answer in recognition question
inddel=find([EXPDATA.Trials_Analysis.did_answer_recognition_Q]==0);
EXPDATA.Trials_Analysis(inddel)=[];

EXPDATA.TrialsRemoved.SubjectiveAwarenessExclusion=0;
EXPDATA.TrialsRemoved.ObjectiveAwarenessNoAnswer=length(inddel);
end