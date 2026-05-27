function createTableTrialLevelObjectiveData(EXPDATA_ALL,saveFlag,EXP_NUM)
%% Trial level
subject_id=[]; %subject number
condition=[]; %visibility condition 1 = U, 2 = C
trial_number_overall=[]; %Trial number overall
is_correct=[]; %is correct in obejctive measure

%% Create vectors of data for table
for ii=1:size(EXPDATA_ALL,1) %subejcts
    subjNum=EXPDATA_ALL{ii,1}.info.subject_info.subject_number_and_experiment;  
    for kk = 1:size(EXPDATA_ALL,2) %conditions 
        if kk == 1
            % include only PAS 1 trials in U condition
            trials=find([EXPDATA_ALL{ii,kk}.TrialsAnalysis.response_PAS_Q]==1);
        else
            %include only PAS 3 & 4 trials in C condition
            trials=find([EXPDATA_ALL{ii,kk}.TrialsAnalysis.response_PAS_Q]==3 | [EXPDATA_ALL{ii,kk}.TrialsAnalysis.response_PAS_Q]==4);
        end
        Data=[EXPDATA_ALL{ii,kk}.TrialsAnalysis(trials)];
        
        numTrials=size(Data,2);
        new_subject_id=ones(1,numTrials)*subjNum;
        new_condition=ones(1,numTrials)*kk;
        new_trial_number_overall=[Data.TrialNumberOverall];
        new_is_correct=[Data.isCorrect_recognition_Q];
        
        %Save data of this trial
        subject_id=[subject_id,new_subject_id];
        condition=[condition,new_condition];
        trial_number_overall=[trial_number_overall,new_trial_number_overall];
        is_correct=[is_correct,new_is_correct];
    end
end


%% Create table
tbl = table(subject_id',condition',trial_number_overall',is_correct','VariableNames',{'subject_id','condition','trial_number_overall','is_correct'});

%% Save table
if saveFlag
    writetable(tbl,['ObjectiveDataExp',EXP_NUM,'.csv'])
end
