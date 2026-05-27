function [EXPDATA_ALL,subjNumber,Results_Awareness,Summary_Awareness]=removeObjectiveAwareSubjects(EXPDATA_ALL,subjNumber,Results_Awareness,Summary_Awareness)
%find subjects to exclude
subjDel=[];
inddel=[];
for ii=1:length(subjNumber)
    indsubj=find([Summary_Awareness.Data.subjNumber]==subjNumber(ii));
    SR=Summary_Awareness.Data(indsubj).AccuracyUC;
    IsExcluded=Summary_Awareness.Data(indsubj).isExcluded;
    if IsExcluded && SR>0.5
        subjDel=[subjDel,subjNumber(ii)];
        inddel=[inddel,ii]; %ind to delete in EXPDATA_ALL and subjNumber
    end
end
%exclude subejcts
EXPDATA_ALL(inddel,:)=[];
Results_Awareness(inddel,:)=[];
Summary_Awareness.Data(inddel)=[];  
subjNumber(inddel)=[];
end