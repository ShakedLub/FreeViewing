function createTableSubectLevelObjectiveData(Summary_Awareness_withoutAware,saveFlag,EXP_NUM)

subject_id=[Summary_Awareness_withoutAware.Data.subjNumber];
N_U=[Summary_Awareness_withoutAware.Data.numTrialsUC];
R_U=[Summary_Awareness_withoutAware.Data.numTrialsCorrectUC];
N_C1=[Summary_Awareness_withoutAware.Data.numTrialsC];
R_C1=[Summary_Awareness_withoutAware.Data.numTrialsCorrectC];
N_C2=[Summary_Awareness_withoutAware.Data.numTrialsC2];
R_C2=[Summary_Awareness_withoutAware.Data.numTrialsCorrectC2];

%% Create table
tbl = table(subject_id',N_U',R_U',N_C1',R_C1',N_C2',R_C2','VariableNames',{'subject_id','N_U','R_U','N_C1','R_C1','N_C2','R_C2'});

%% save table
if saveFlag
    writetable(tbl,['ObjectiveDataPerSubjExp',EXP_NUM,'.csv'])
end
end