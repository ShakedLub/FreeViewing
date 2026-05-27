function fixations=mergeFixationsBothExperiments(fixations1,fixations2)
imageNamesF1={fixations1.img};
imageNamesF2={fixations2.img};

AllImageNames=unique({imageNamesF1{:},imageNamesF2{:}});

%initialize fixations
for ii=1:length(AllImageNames) %images
    fixations(ii).img=[];
    for kk=1:2 %condition
        fixations(ii).condition(kk).subject=[];
    end
end

for ii=1:length(AllImageNames) %images
    imName=AllImageNames{ii};
    fixations(ii).img=imName;
    indIm1=find(strcmp(imName,imageNamesF1));
    indIm2=find(strcmp(imName,imageNamesF2));
    if ~isempty(indIm1)
        fixations(ii).condition(1).subject=[fixations(ii).condition(1).subject,fixations1(indIm1).condition(1).subject];
        fixations(ii).condition(2).subject=[fixations(ii).condition(2).subject,fixations1(indIm1).condition(2).subject];
    end
    if ~isempty(indIm2)
        fixations(ii).condition(1).subject=[fixations(ii).condition(1).subject,fixations2(indIm2).condition(1).subject];
        fixations(ii).condition(2).subject=[fixations(ii).condition(2).subject,fixations2(indIm2).condition(2).subject];
    end
end
end
