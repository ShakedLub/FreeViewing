function FixationsAllSubjProcessed=PreprocessingFixations(fixations,subjNumber,Paths,Param)
%delete from fixations images that don't have data from any subject
indDel=[];
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).condition(1).subject) && isempty(fixations(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    fixations(indDel)=[];
end

%create RectCell for all participants
for ii=1:length(subjNumber)
    for kk=1:2 %visibility conditions
        SUBJ_NUM=subjNumber(ii);
         if kk==1
            EXP_COND='U';
        elseif kk==2
            EXP_COND='C';
        end
        pileupfileName=['pileup_',EXP_COND,'_',num2str(SUBJ_NUM),'.mat'];
        load([Paths.PileupFolder,'\',pileupfileName],'resources')
        RectCell{ii,kk}=resources.Images.dstRectDom;
        clear resources
    end
end

for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %conditions
        numFixExcludeImage=0;
        excludeTrial=[];
        for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
            SUBJ_NUM=fixations(ii).condition(kk).subject(jj).subjNum;
            ind_sub=find(subjNumber==SUBJ_NUM);
            RECT=RectCell{ind_sub,kk};
            fixations(ii).condition(kk).subject(jj).processed=excludeFixSacc(fixations(ii).condition(kk).subject(jj),RECT,Param);
            numFixExcludeImage=numFixExcludeImage+fixations(ii).condition(kk).subject(jj).processed.numFixExclude;
            if fixations(ii).condition(kk).subject(jj).processed.includeSubj==0
                excludeTrial=[excludeTrial,jj];
            end
        end
        if ~isempty(excludeTrial)
            fixations(ii).condition(kk).subject(excludeTrial)=[];
        end
        fixations(ii).condition(kk).numFixExcludeImage=numFixExcludeImage;
        fixations(ii).condition(kk).numTrialsExcludeNoFixLeft=length(excludeTrial);
    end 
end

%delete from fixations images that don't have data from both visibility
%conditions, if all subj were deleted beucase all fixations were excluded
indDel=[];
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    fixations(indDel)=[];
end

FixationsAllSubjProcessed=fixations;
end