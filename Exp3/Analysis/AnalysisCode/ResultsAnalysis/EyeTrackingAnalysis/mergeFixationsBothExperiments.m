function [fixations,subjNumber]=mergeFixationsBothExperiments(fixations1,fixations2,fixations_persubj1,fixations_persubj2)
imageNamesF1={fixations1.img};
imageNamesF2={fixations2.img};

%make sure the same images have data from both experiments
if ~isequal(imageNamesF1,imageNamesF2)
    error('Not the same images have data from both experiments')
end

%initialize fixations
for ii=1:size(imageNamesF1,2) %images
    fixations(ii).img=[];
    for kk=1:2 %condition
        fixations(ii).condition(kk).subject=[];
    end
end

%fill fixations
for ii=1:length(imageNamesF1) %images
    imName=imageNamesF1{ii};
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

%create subjNumber vec
subjNumber=[[fixations_persubj1.subjNum],[fixations_persubj2.subjNum]];
end
