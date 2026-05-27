function [EXPDATA_ALL,subjNumber]=excludeSubjectsDominantEye(EXPDATA_ALL,subjNumber,Param)
%find subjects to exclude
subjDel=[];
inddel=[];
for ii=1:length(subjNumber)
    if ~strcmp(EXPDATA_ALL{ii,1}.info.subject_info.dominant_eye,Param.DominantEye)    
        subjDel=[subjDel,subjNumber(ii)];
        inddel=[inddel,ii]; %ind to delete in EXPDATA_ALL and subjNumber
    end
end

%exclude subejcts
EXPDATA_ALL(inddel,:)=[];
subjNumber(inddel)=[];
end