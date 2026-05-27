function [RhoPval,subRhoPval]=extractPvalFromTree(ResultsTreeBH,Results)
numLayers=size(Results.Rho,2);

% create mat of corrected rho pvalues
ind=(2+numLayers); %node in which experimental resutls start
for ii=1:numLayers
    RhoPval(1,ii)=ResultsTreeBH.Nodes{ind,'corr_p'};
    RhoPval(2,ii)=ResultsTreeBH.Nodes{ind+1,'corr_p'};
    
    ind=ind+2;
end

% create mat of corrected subtraction rho pvalues
subRhoPval=nan(1,numLayers);
for ii=ind:size(ResultsTreeBH.Nodes,1)
    name=ResultsTreeBH.Nodes{ii,'name'};
    name=name{:};
    if length(name) == 5
        num=str2num(name(5));
    elseif length(name) == 6
        num=str2num(name(5:6));
    else
        error('Wrong row name')
    end
    subRhoPval(num)=ResultsTreeBH.Nodes{ii,'corr_p'};
end
end