function [fixations,fixations_perSubj]=downSamplePariticpantLevel(fixations,fixations_perSubj,Param)
%downsample number of trials according to the smaller visibility
%condition for each participant. The number of trials left is not
%exactly the same because if an image stays without trials in one of 
%the visibility conditions this image with all it's trials will be excluded.

for ii=1:size(fixations_perSubj,2) %participants
    subjNum=fixations_perSubj(ii).subjNum;
    
    if size(fixations_perSubj(ii).condition(1).trial,2) > size(fixations_perSubj(ii).condition(2).trial,2)
        visCondCheck=2;
        visCondDelete=1;
    elseif size(fixations_perSubj(ii).condition(1).trial,2) < size(fixations_perSubj(ii).condition(2).trial,2)
        visCondCheck=1;
        visCondDelete=2;
    elseif size(fixations_perSubj(ii).condition(1).trial,2) == size(fixations_perSubj(ii).condition(2).trial,2)
        continue
    end
    
    %choose randomaly which trials to delete
    numTrialsDelete=size(fixations_perSubj(ii).condition(visCondDelete).trial,2)-size(fixations_perSubj(ii).condition(visCondCheck).trial,2);
    indD = randperm(size(fixations_perSubj(ii).condition(visCondDelete).trial,2),numTrialsDelete);
    
    %delete trials in fixations_perSubj
    trialNumOverllDelete=[fixations_perSubj(ii).condition(visCondDelete).trial(indD).TrialNumberOverall];
    fixations_perSubj(ii).condition(visCondDelete).trial(indD)=[];
    
    %delete trials in fixations
    for im=1:size(fixations,2) %images
        subjects=[fixations(im).condition(visCondDelete).subject.subjNum];
        if ismember(subjNum,subjects)
            indSubj=find(subjects==subjNum);
            if ismember(fixations(im).condition(visCondDelete).subject(indSubj).TrialNumberOverall,trialNumOverllDelete)
                fixations(im).condition(visCondDelete).subject(indSubj)=[];
            end
        end
    end
end

%% delete from fixations and fixations_perSubj images that don't have data from both visibility
%conditions, if no subj were left in one of the visibility conditions
indDel=[]; %ind to delete in fixations
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end

if ~isempty(indDel)
    %delete images in fixations_perSubj
    for ind=1:length(indDel)
        indIm=indDel(ind);
        if size(fixations(indIm).condition(1).subject,2) == 0
            cond=2;
        elseif size(fixations(indIm).condition(2).subject,2) == 0
            cond=1;
        end
        subjNum=[fixations(indIm).condition(cond).subject.subjNum];
        TrialNumberOverall=[fixations(indIm).condition(cond).subject.TrialNumberOverall];
        for aa=1:length(subjNum)
            subjInd=find([fixations_perSubj.subjNum] == subjNum(aa));
            trialInd=find([fixations_perSubj(subjInd).condition(cond).trial.TrialNumberOverall] == TrialNumberOverall(aa));
            fixations_perSubj(subjInd).condition(cond).trial(trialInd)=[];
        end
    end
    
    %delete images in fixations
    fixations(indDel)=[];
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