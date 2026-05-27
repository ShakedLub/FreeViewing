function FixationsAllSubjProcessed=includeOnlyFirstFixation(fixations,Param)
for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %conditions
        excludeTrial=[];
        for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
            
            sacc_onsets=fixations(ii).condition(kk).subject(jj).sacc_onsets;
            sacc_duration=fixations(ii).condition(kk).subject(jj).sacc_duration;
            wantedSaccInd=min(find(sacc_onsets>(Param.AnalysisMinTimeLimitFrames+Param.FirstSaccadeLatencyFrames)));
            %saccade onset + saccade duration = fixation onset + 1
            wantedSaccEnd=sacc_onsets(wantedSaccInd)+sacc_duration(wantedSaccInd)-1;
            
            if ~isempty(wantedSaccEnd)
                fix_onsets=fixations(ii).condition(kk).subject(jj).fix_onsets;
                wantedFixInd=find(fix_onsets==wantedSaccEnd);
            else
                wantedFixInd=[];
            end
            
            if ~isempty(wantedFixInd)
                if ismember(fix_onsets(wantedFixInd),fixations(ii).condition(kk).subject(jj).processed.fix_onsets_final)
                    indFix=find(fixations(ii).condition(kk).subject(jj).processed.fix_onsets_final==fix_onsets(wantedFixInd));
                    fixations(ii).condition(kk).subject(jj).processed.fix_w_final=fixations(ii).condition(kk).subject(jj).processed.fix_w_final(indFix);
                    fixations(ii).condition(kk).subject(jj).processed.fix_h_final=fixations(ii).condition(kk).subject(jj).processed.fix_h_final(indFix);
                    fixations(ii).condition(kk).subject(jj).processed.fix_duration_final=fixations(ii).condition(kk).subject(jj).processed.fix_duration_final(indFix);
                    fixations(ii).condition(kk).subject(jj).processed.fix_onsets_final=fixations(ii).condition(kk).subject(jj).processed.fix_onsets_final(indFix);
                    fixations(ii).condition(kk).subject(jj).processed.indFixExclude=NaN;
                    fixations(ii).condition(kk).subject(jj).processed.numFixExclude=NaN;
                else
                    excludeTrial=[excludeTrial,jj];
                end
            else
                excludeTrial=[excludeTrial,jj];
            end
        end
        if ~isempty(excludeTrial)
            fixations(ii).condition(kk).subject(excludeTrial)=[];
        end
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