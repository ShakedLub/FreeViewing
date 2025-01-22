function [EXPDATA_ALL,subjNumber]=excludeSubjectsObjectiveAware(EXPDATA_ALL,subjNumber)
%find subjects to exclude
subjDel=[];
inddel=[];
for ii=1:length(subjNumber)
    if EXPDATA_ALL{ii,1}.info.subject_info.objective_aware
        subjDel=[subjDel,subjNumber(ii)];
        inddel=[inddel,ii]; %ind to delete in EXPDATA_ALL and subjNumber
    end
end
%exclude subejcts
EXPDATA_ALL(inddel,:)=[];
subjNumber(inddel)=[];
end