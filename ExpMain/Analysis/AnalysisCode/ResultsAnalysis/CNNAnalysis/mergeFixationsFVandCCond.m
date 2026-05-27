function fixations=mergeFixationsFVandCCond(fixations1,fixationsFV,Param)
imageNamesF1={fixations1.img};
imageNamesFV={fixationsFV.img};

%initialize fixations
for ii=1:size(Param.ImageNames,2) %images
    fixations(ii).img=[];
    for kk=1:2 %condition
        fixations(ii).condition(kk).subject=[];
    end
end

for ii=1:size(Param.ImageNames,2) %images
    imName=Param.ImageNames{ii};
    fixations(ii).img=imName;
    indIm1=find(strcmp(imName,imageNamesF1));
    indIm2=find(strcmp(imName,imageNamesFV));
    if ~isempty(indIm1)
        fixations(ii).condition(2).subject=fixations1(indIm1).condition(2).subject;
    end
    if ~isempty(indIm2)
        fixations(ii).condition(1).subject=fixationsFV(indIm2).condition(1).subject;
    end
end
end
