function [fixations_PerSubject,subjNumber,fixations]=excludeSubjectsLowNumTrials(fixations_PerSubject,subjNumber,fixations,Param)
flag=1;
while flag
    %find subjects to exclude
    subjDel=[];
    indSubjdel=[];
    for ii=1:length(subjNumber)
        if size(fixations_PerSubject(ii).condition(1).trial,2) < Param.MinTrials || size(fixations_PerSubject(ii).condition(2).trial,2) < Param.MinTrials
            subjDel=[subjDel,subjNumber(ii)];
            indSubjdel=[indSubjdel,ii]; %ind to delete in fixations_PerSubject and subjNumber
        end
    end
    
    %exclude subejcts
    if ~isempty(indSubjdel)
        disp('Some subjects have less than 10 image unconscious or conscious trials')
        
        %exclude subejcts from fixations_PerSubject subjNumber
        fixations_PerSubject(indSubjdel)=[];
        subjNumber(indSubjdel)=[];
        
        %exclude subejcts from fixations
        for ii=1:size(fixations,2) %images
            for kk=1:size(fixations(ii).condition,2) %condition
                trialDel=[];
                subjNum=[fixations(ii).condition(kk).subject.subjNum];
                trialDel=ismember(subjNum,subjDel);
                if any(trialDel)
                    fixations(ii).condition(kk).subject(trialDel)=[];
                end
            end
        end
        
        %delete from fixations and fixations_PerSubject images that don't have data from both visibility
        %conditions, if all subj were deleted
        indDel=[];
        for ii=1:size(fixations,2) %images
            if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
                indDel=[indDel,ii];
            end
        end
        if ~isempty(indDel)
            fixations(indDel)=[];
            fixations_PerSubject=arrangeFixationsPerSubject(fixations,subjNumber);
        else
            flag = 0;
        end
    else
        flag=0;
    end
end
end