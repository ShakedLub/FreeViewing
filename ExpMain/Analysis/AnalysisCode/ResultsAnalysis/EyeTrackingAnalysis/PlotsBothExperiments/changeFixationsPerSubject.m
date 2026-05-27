function FixationsPerSubject=changeFixationsPerSubject(fixations,subjNumber)
%re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)

VisibilityConditions=size(fixations(1).condition,2);

%Initialize FixationsPerSubject
for ii=1:length(subjNumber) %subjects
    FixationsPerSubject.subject(ii).subjNum=subjNumber(ii);
    for kk=1:VisibilityConditions %conditions
        FixationsPerSubject.subject(ii).condition(kk).trial=[];
    end
end
for nn=1:size(fixations(1).shuffled,2)%repetitions
    for ii=1:length(subjNumber) %subjects
        FixationsPerSubject.shuffled(nn).subject(ii).subjNum=subjNumber(ii);
        for kk=1:VisibilityConditions %conditions
            FixationsPerSubject.shuffled(nn).subject(ii).condition(kk).trial=[];
        end
    end
end

%Fill FixationsPerSubject
for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %conditions
        for jj=1:size(fixations(ii).condition(kk).subject,2)%subjects
            %subj Id
            subjN=fixations(ii).condition(kk).subject(jj).subjNum;
            ind=find(subjNumber==subjN);
            
            %add image name to trials
            fixations(ii).condition(kk).subject(jj).img=fixations(ii).img;
            
            %trial number in FixationPerSubejct
            tt=size(FixationsPerSubject.subject(ind).condition(kk).trial,2)+1;
            if tt==1
                FixationsPerSubject.subject(ind).condition(kk).trial=fixations(ii).condition(kk).subject(jj);
            else
                FixationsPerSubject.subject(ind).condition(kk).trial(tt)=fixations(ii).condition(kk).subject(jj);
            end
        end
    end
end
for nn=1:size(fixations(1).shuffled,2)%repetitions
    for ii=1:size(fixations,2) %images
        for kk=1:size(fixations(ii).condition,2) %conditions
            for jj=1:size(fixations(ii).condition(kk).subject,2)%subjects
                %subj Id
                subjN=fixations(ii).shuffled(nn).condition(kk).subject(jj).subjNum;
                ind=find(subjNumber==subjN);
                
                %add image number to trials
                fixations(ii).shuffled(nn).condition(kk).subject(jj).img=fixations(ii).img;
                
                %trial number in FixationPerSubejct
                tt=size(FixationsPerSubject.shuffled(nn).subject(ind).condition(kk).trial,2)+1;
                if tt==1
                    FixationsPerSubject.shuffled(nn).subject(ind).condition(kk).trial=fixations(ii).shuffled(nn).condition(kk).subject(jj);
                else
                    FixationsPerSubject.shuffled(nn).subject(ind).condition(kk).trial(tt)=fixations(ii).shuffled(nn).condition(kk).subject(jj);
                end
            end
        end
    end
end
end