function FixationsPerSubject=arrangeFixationsPerSubject(fixations,subjNumber)
%re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)

VisibilityConditions=size(fixations(1).condition,2);

%Initialize FixationsPerSubject
for ii=1:length(subjNumber) %subjects
    FixationsPerSubject(ii).subjNum=subjNumber(ii);
    for kk=1:VisibilityConditions %conditions
        FixationsPerSubject(ii).condition(kk).trial=[];
    end
end

%Fill FixationsPerSubject
for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %conditions
        for jj=1:size(fixations(ii).condition(kk).subject,2)%subjects
            %subj Id
            subjN=fixations(ii).condition(kk).subject(jj).subjNum;
            ind=find(subjNumber==subjN);
            
            %add image number to trials
            fixations(ii).condition(kk).subject(jj).img=fixations(ii).img;
            
            %trial number in FixationPerSubejct
            tt=size(FixationsPerSubject(ind).condition(kk).trial,2)+1;
            if tt==1
                FixationsPerSubject(ind).condition(kk).trial=fixations(ii).condition(kk).subject(jj);
            else
                FixationsPerSubject(ind).condition(kk).trial(tt)=fixations(ii).condition(kk).subject(jj);
            end
        end
    end
end
end