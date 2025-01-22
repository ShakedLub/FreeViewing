function [EXPDATA_ALL,subjNumber,numSubjRemoved]=removeSubjectsLowNumTrials(EXPDATA_ALL,subjNumber,MinTrials)
subjRemove=[];
for ii=1:length(EXPDATA_ALL)
    if size(EXPDATA_ALL{ii}.Trials_Analysis,2)<MinTrials
        subjRemove=[subjRemove,ii];
    end
end
if ~isempty(subjRemove)
    EXPDATA_ALL(subjRemove)=[];
    subjNumber(subjRemove)=[];
end
numSubjRemoved=length(subjRemove);
end