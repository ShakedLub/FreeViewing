function FixationsPerImageProcessed=PreprocessingFixations(fixations,Paths,Param)
%delete from fixations images that don't have data from any subject
indDel=[];
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    fixations(indDel)=[];
end

for ii=1:size(fixations,2) %images
    numFixExcludeImage=0;
    excludeTrial=[];
    for jj=1:size(fixations(ii).subject,2) %subjects
        SUBJ_NUM=fixations(ii).subject(jj).subjNum;
        fixations(ii).subject(jj).processed=excludeFixSacc(fixations(ii).subject(jj),Paths,SUBJ_NUM,Param);
        numFixExcludeImage=numFixExcludeImage+fixations(ii).subject(jj).processed.numFixExclude;
        if fixations(ii).subject(jj).processed.includeSubj==0
            excludeTrial=[excludeTrial,jj];
        end
    end
    if ~isempty(excludeTrial)
        fixations(ii).subject(excludeTrial)=[];
    end
    
    fixations(ii).numFixExcludeImage=numFixExcludeImage;
end

%delete from fixations images that don't have data from any subject
%if all subj were deleted beucase all fixations were excluded
indDel=[];
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    fixations(indDel)=[];
end

FixationsPerImageProcessed=fixations;
end