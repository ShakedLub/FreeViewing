function TrialsWithBlinks=CountTrialsWithBlinks(fixations_PerSubj,TrialsRemoved,Param)
subjNumTrialsRemoved=[TrialsRemoved.numTrialsSummaryFinal.SubjNum];  

for ii=1:size(fixations_PerSubj,2) %subjects
    TrialsWithBlinks.data(ii).SubjNum=fixations_PerSubj(ii).subjNum;
    indTrialsRemoved=find(subjNumTrialsRemoved==TrialsWithBlinks.data(ii).SubjNum);
    for kk=1:size(fixations_PerSubj(ii).condition,2) %conditions
        NumTrialsBlink=0;
        for jj=1:size(fixations_PerSubj(ii).condition(kk).trial,2)%trials
            %check if the trial includes a blink
            non_nan_times_vec=fixations_PerSubj(ii).condition(kk).trial(jj).non_nan_times;
            if any(non_nan_times_vec(Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames)==0)
                NumTrialsBlink=NumTrialsBlink+1;
            end
        end
        
        if kk==1
            TrialsWithBlinks.data(ii).NumTrialsBlinkU=NumTrialsBlink;
            TrialsWithBlinks.data(ii).PercentTrialsBlinkU=TrialsWithBlinks.data(ii).NumTrialsBlinkU/TrialsRemoved.numTrialsSummaryFinal(indTrialsRemoved).ImageTrialsU;
        elseif kk==2
            TrialsWithBlinks.data(ii).NumTrialsBlinkC=NumTrialsBlink;
            TrialsWithBlinks.data(ii).PercentTrialsBlinkC=TrialsWithBlinks.data(ii).NumTrialsBlinkC/TrialsRemoved.numTrialsSummaryFinal(indTrialsRemoved).ImageTrialsC;
        end
    end
end
%summarize results
TrialsWithBlinks.meanPercentTrialsWithBlinks(1)=mean([TrialsWithBlinks.data.PercentTrialsBlinkU]);
TrialsWithBlinks.stdPercentTrialsWithBlinks(1)=std([TrialsWithBlinks.data.PercentTrialsBlinkU]);

TrialsWithBlinks.meanPercentTrialsWithBlinks(2)=mean([TrialsWithBlinks.data.PercentTrialsBlinkC]);
TrialsWithBlinks.stdPercentTrialsWithBlinks(2)=std([TrialsWithBlinks.data.PercentTrialsBlinkC]);

TrialsWithBlinks.meanPercentTrialsWithBlinksBothCond=mean([[TrialsWithBlinks.data.PercentTrialsBlinkU],[TrialsWithBlinks.data.PercentTrialsBlinkC]]);
TrialsWithBlinks.stdPercentTrialsWithBlinksBothCond=std([[TrialsWithBlinks.data.PercentTrialsBlinkU],[TrialsWithBlinks.data.PercentTrialsBlinkC]]);
end