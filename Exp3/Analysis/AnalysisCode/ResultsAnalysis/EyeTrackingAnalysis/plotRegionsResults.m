function plotRegionsResults(Summary)
figure
rows=2;
columns=4;
plotNumbers=1:4;

%% FixPerPix
for ii=1:length(Summary.GroupNames) %region type
    plotNum=plotNumbers(ii);
    %U
    realVal1=Summary.condition(1).FixPerPix(ii);
    vecReptitions1=Summary.condition(1).FixPerPixShuffled(:,ii);
    
    %C
    realVal2=Summary.condition(2).FixPerPix(ii);
    vecReptitions2=Summary.condition(2).FixPerPixShuffled(:,ii);
    
    if ii==4 %background areas
        prc=5;
    else
        prc=95;
    end
    xlabelText='fixation/pixel';
    titleText=[Summary.GroupNames{ii},' regions'];
    plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)
end

%% FixDurPerPix
plotNumbers=5:8;
for ii=1:length(Summary.GroupNames) %region type
    plotNum=plotNumbers(ii);
    %U
    realVal1=Summary.condition(1).FixDurPerPix(ii);
    vecReptitions1=Summary.condition(1).FixDurPerPixShuffled(:,ii);
    
    %C
    realVal2=Summary.condition(2).FixDurPerPix(ii);
    vecReptitions2=Summary.condition(2).FixDurPerPixShuffled(:,ii);
    
    if ii==4 %background areas
        prc=5;
    else
        prc=95;
    end
    xlabelText='msec/pixel';
    titleText=[];
    plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)
end
end