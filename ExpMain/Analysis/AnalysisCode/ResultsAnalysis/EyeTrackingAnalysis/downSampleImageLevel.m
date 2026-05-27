function [fixations,fixations_perSubj]=downSampleImageLevel(fixations,fixations_perSubj,Param)
%downsample number of trials according to the smaller visibility
%condition for each image.

for ii=1:size(fixations,2) %images
    imName=fixations(ii).img;
    
    if size(fixations(ii).condition(1).subject,2) > size(fixations(ii).condition(2).subject,2)
        visCondCheck=2;
        visCondDelete=1;
    elseif size(fixations(ii).condition(1).subject,2) < size(fixations(ii).condition(2).subject,2)
        visCondCheck=1;
        visCondDelete=2;
    elseif size(fixations(ii).condition(1).subject,2) == size(fixations(ii).condition(2).subject,2)
        continue
    end
    
    %choose randomaly which trial to delete
    numTrialsDelete=size(fixations(ii).condition(visCondDelete).subject,2)-size(fixations(ii).condition(visCondCheck).subject,2);
    indD = randperm(size(fixations(ii).condition(visCondDelete).subject,2),numTrialsDelete);

    %delete trials in fixations_perSubj
    subjNum=[fixations(ii).condition(visCondDelete).subject(indD).subjNum];
    TrialNumberOverall=[fixations(ii).condition(visCondDelete).subject(indD).TrialNumberOverall];
    for aa=1:length(subjNum)
        subjInd=find([fixations_perSubj.subjNum] == subjNum(aa));
        trialInd=find([fixations_perSubj(subjInd).condition(visCondDelete).trial.TrialNumberOverall] == TrialNumberOverall(aa));
        fixations_perSubj(subjInd).condition(visCondDelete).trial(trialInd)=[];
    end

    %delete trials in fixations
    fixations(ii).condition(visCondDelete).subject(indD)=[];
end

%check if some subjects are left with less than 10 images after trial
%exclusion
for ii=1:size(fixations_perSubj,2)
    if size(fixations_perSubj(ii).condition(1).trial,2) < Param.MinTrials || size(fixations_perSubj(ii).condition(1).trial,2) < Param.MinTrials
        disp('Some subjects have less than 10 image unconscious or conscious trials')     
        disp(fixations_perSubj(ii).subjNum)
    end
end
end