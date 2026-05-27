function [FixationsRand_Control,FixationsRand_Image]=shuffleData(Fixations_Control,Fixations_Image,parameterNames)
%shuffle data
for ii=1:size(Fixations_Control,2) %subjects
    clear Temp
    numTrials_Co_U=size(Fixations_Control(ii).condition(1).trial,2);
    numTrials_Co_C=size(Fixations_Control(ii).condition(2).trial,2);
    numTrials_Im_U=size(Fixations_Image(ii).condition(1).trial,2);
    numTrials_Im_C=size(Fixations_Image(ii).condition(2).trial,2);
    
    numTrialsSubj=numTrials_Co_U+numTrials_Co_C+numTrials_Im_U+numTrials_Im_C;
    
    for qq=1:length(parameterNames)
        Temp.(parameterNames{qq})=[[Fixations_Control(ii).condition(1).trial.(parameterNames{qq})],[Fixations_Control(ii).condition(2).trial.(parameterNames{qq})],[Fixations_Image(ii).condition(1).trial.(parameterNames{qq})],[Fixations_Image(ii).condition(2).trial.(parameterNames{qq})]];
    end
    
    ind=randperm(numTrialsSubj);
    ind_Co_U=ind(1:numTrials_Co_U);
    ind(1:numTrials_Co_U)=[];
    ind_Co_C=ind(1:numTrials_Co_C);
    ind(1:numTrials_Co_C)=[];
    ind_Im_U=ind(1:numTrials_Im_U);
    ind(1:numTrials_Im_U)=[];
    ind_Im_C=ind;
    
    %create shuffled structs
    for aa=1:numTrials_Co_U
        for qq=1:length(parameterNames)
            FixationsRand_Control(ii).condition(1).trial(aa).(parameterNames{qq})=Temp.(parameterNames{qq})(ind_Co_U(aa));
        end
    end
    for aa=1:numTrials_Co_C
        for qq=1:length(parameterNames)
            FixationsRand_Control(ii).condition(2).trial(aa).(parameterNames{qq})=Temp.(parameterNames{qq})(ind_Co_C(aa));
        end
    end
    for aa=1:numTrials_Im_U
        for qq=1:length(parameterNames)
            FixationsRand_Image(ii).condition(1).trial(aa).(parameterNames{qq})=Temp.(parameterNames{qq})(ind_Im_U(aa));
        end
    end
    for aa=1:numTrials_Im_C
        for qq=1:length(parameterNames)
            FixationsRand_Image(ii).condition(2).trial(aa).(parameterNames{qq})=Temp.(parameterNames{qq})(ind_Im_C(aa));
        end
    end
end
end