function [Results_Awareness,Summary_Awareness]=removeObjectiveAwareSubjects(Results_Awareness,Summary_Awareness)
%make sure there are the same number of subjects in Results_Awareness and Summary_Awareness
if size(Results_Awareness,1) ~= size(Summary_Awareness.Data,2)
    error('Problem with structs, there are not the same number of trials in results and summary structs')
end

%find subjects to exclude
subjDel=[];
inddel=[];
for ii=1:size(Summary_Awareness.Data,2)
    SR=Summary_Awareness.Data(ii).AccuracyUC;
    IsExcluded=Summary_Awareness.Data(ii).isExcluded;
    if IsExcluded && SR>0.5
        subjDel=[subjDel,Summary_Awareness.Data(ii).subjNumber];
        inddel=[inddel,ii];
    end
end
%exclude subejcts
Results_Awareness(inddel,:)=[];
Summary_Awareness.Data(inddel)=[];  
end