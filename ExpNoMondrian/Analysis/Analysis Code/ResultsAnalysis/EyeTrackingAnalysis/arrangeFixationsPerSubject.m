function FixationsPerSubject=arrangeFixationsPerSubject(fixations,subjNumber)
%re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)

%Initialize FixationsSubjects
for ii=1:length(subjNumber) %subjects
    FixationsPerSubject(ii).subjNum=subjNumber(ii);
    FixationsPerSubject(ii).trial=[];
end

%Fill FixationsSubjects
for ii=1:size(fixations,2) %images
    for jj=1:size(fixations(ii).subject,2)%subjects
        subjN=fixations(ii).subject(jj).subjNum;
        ind=find(subjNumber==subjN);
        tt=size(FixationsPerSubject(ind).trial,2)+1;
        if tt==1
            FixationsPerSubject(ind).trial=fixations(ii).subject(jj);
        else
            FixationsPerSubject(ind).trial(tt)=fixations(ii).subject(jj);
        end
    end
end

%check all subjects have image fixations
for ii=1:size(FixationsPerSubject,2) %subjects   
    if size(FixationsPerSubject(ii).trial,2)==0
        error('One of the subejcts does not have image trials left')
    end   
end
end