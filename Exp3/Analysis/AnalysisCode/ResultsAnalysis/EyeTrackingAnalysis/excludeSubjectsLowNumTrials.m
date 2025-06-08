function [EXPDATA_ALL,subjNumber,fixations]=excludeSubjectsLowNumTrials(EXPDATA_ALL,subjNumber,fixations,Param)
%find subjects to exclude
subjDel=[];
inddel=[];
for ii=1:length(subjNumber)
    if size(EXPDATA_ALL{ii,1}.Trials_Analysis,2) < Param.MinTrials || size(EXPDATA_ALL{ii,2}.Trials_Analysis,2) < Param.MinTrials
        subjDel=[subjDel,subjNumber(ii)];
        inddel=[inddel,ii]; %ind to delete in EXPDATA_ALL and subjNumber
    end
end

%exclude subejcts
if ~isempty(inddel)
    disp('Some subjects have less than 10 image unconscious or conscious trials')
    
    EXPDATA_ALL(inddel,:)=[];
    subjNumber(inddel)=[];
    
    for ii=1:size(fixations,2) %images
        for kk=1:size(fixations(ii).condition,2) %condition
            for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
                subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
                if ismember(subjNum,subjDel)
                    fixations(ii).condition(kk).subject(jj)=[];
                end
            end
        end
    end
    
    %delete from fixations images that don't have data from both visibility
    %conditions, if all subj were deleted
    indDel=[];
    for ii=1:size(fixations,2) %images
        if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
            indDel=[indDel,ii];
        end
    end
    if ~isempty(indDel)
        fixations(indDel)=[];
    end
end
end