function EXPDATA=removeEmptyTrials(EXPDATA,field)
FirstindEmpty=[];
for ii=1:size(EXPDATA.(field),2) %trials
    if isempty(EXPDATA.(field)(ii).BlockNum)
        FirstindEmpty=ii;
        break
    end
end
if ~isempty(FirstindEmpty)
    EXPDATA.(field)=EXPDATA.(field)(1:(FirstindEmpty-1));
end
end