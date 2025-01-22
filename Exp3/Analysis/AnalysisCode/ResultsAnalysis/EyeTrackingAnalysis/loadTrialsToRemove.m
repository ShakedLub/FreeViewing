function Param=loadTrialsToRemove(EXPDATA_ALL,subjNumber,Paths,Param)
%load trials to remove
load([Paths.BehavioralResults,'\Specific_Trials_Exclude_Pilot',Param.PILOT_NUM,'Final.mat']);

%exclude extra trials from trials to remove
indDelSub=[];
for ii=1:length(Specific_Trials_Exclude.SUBJ_NUM_REMOVE)
    Sub=Specific_Trials_Exclude.SUBJ_NUM_REMOVE(ii);
    Cond=Specific_Trials_Exclude.EXP_COND_REMOVE{ii};
    Trials_remove=Specific_Trials_Exclude.TRIALS_REMOVE{ii};
    
    switch Cond
        case 'U'
            indCond=1;
        case 'C'
            indCond=2;
    end
    
    if indCond==1
        indSub=find(subjNumber==Sub);
        numTrialsU=size(EXPDATA_ALL{indSub,indCond}.Trials_Experiment,2);
        if any(Trials_remove > numTrialsU)
            indDelTrials=find(Trials_remove > numTrialsU);
        else
            indDelTrials=[];
        end
        if ~isempty(indDelTrials)
            if length(indDelTrials)<length(Trials_remove)
                Trials_remove(indDelTrials)=[];
                Specific_Trials_Exclude.TRIALS_REMOVE{ii}=Trials_remove;
            else
                indDelSub=[indDelSub,ii];
            end
        end
    end
end
if ~isempty(indDelSub)
    Specific_Trials_Exclude.SUBJ_NUM_REMOVE(indDelSub)=[];
    Specific_Trials_Exclude.EXP_COND_REMOVE(indDelSub)=[];
    Specific_Trials_Exclude.TRIALS_REMOVE(indDelSub)=[];
end
Param.SUBJ_NUM_REMOVE=Specific_Trials_Exclude.SUBJ_NUM_REMOVE;
Param.EXP_COND_REMOVE=Specific_Trials_Exclude.EXP_COND_REMOVE;
Param.TRIALS_REMOVE=Specific_Trials_Exclude.TRIALS_REMOVE;
end