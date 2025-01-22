function EXPDATA=removeTrialsAwarenessMeasures(EXPDATA)
%Images: include only PAS 1 trials in U condition, and  PAS 3,4 in C condition
%Also remove trials with no answer in recognition question

%include trials according to PAS answer
cond=EXPDATA.info.subject_info.experiment_condition;
N=size(EXPDATA.Trials_Analysis,2);

%image trials 
imT=find([EXPDATA.Trials_Analysis.IsImageTrial]);
if cond==1 %U condition  
    ImPAS=find([EXPDATA.Trials_Analysis.response_PAS_Q]==1);
elseif cond==2 %C condition
    ImPAS=find([EXPDATA.Trials_Analysis.response_PAS_Q]==3 | [EXPDATA.Trials_Analysis.response_PAS_Q]==4);
end
indinclude=intersect(imT,ImPAS);
EXPDATA.Trials_Analysis=EXPDATA.Trials_Analysis(indinclude);

%exclude trials with no answer in recognition question
inddel=find([EXPDATA.Trials_Analysis.did_answer_recognition_Q]==0);
EXPDATA.Trials_Analysis(inddel)=[];

EXPDATA.TrialsRemoved.SubjectiveAwarenessExclusion=N-length(indinclude);
EXPDATA.TrialsRemoved.ObjectiveAwarenessNoAnswer=length(inddel);
end