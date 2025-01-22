function [EXPDATA_ALL,subjNumber]=excludeSubjectsAwarenessScore(EXPDATA_ALL,subjNumber,Paths,Param)
%caluclte precentile for exclusion
for ii=1:length(subjNumber)
    numTrialsUC(ii)=EXPDATA_ALL{ii,1}.info.subject_info.numTrialsUC;
    SR(ii)=EXPDATA_ALL{ii,1}.info.subject_info.AccuracyUC;
end
mxTrials=max(numTrialsUC);
%confidence interval calculation according to the number of trials of the subject with 
%the highest number of trials, equation is based on the normal approximation
%of binomial distribution
ci = Param.chance + 1.645 * sqrt((Param.chance*(1-Param.chance))/mxTrials);

%find subjects to exclude
subjDel=[];
inddel=[];
for ii=1:length(subjNumber)
    if SR(ii)>=ci
        subjDel=[subjDel,subjNumber(ii)];
        inddel=[inddel,ii]; %ind to delete in EXPDATA_ALL and subjNumber
    end
end

%exclude subejcts
EXPDATA_ALL(inddel,:)=[];
subjNumber(inddel)=[];
end