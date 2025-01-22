function [pvalSub,numExtremeObsSub,numAllObsSub]=permutationTestSubtraction(Results,LayersSubtractionAnalysis,DataRand,Param)
%% calculate subtractions
for ii=1:size(DataRand,3) %iterations
    DataRandSub(ii,:)=DataRand(1,:,ii)-DataRand(2,:,ii);
end

%% Calcualte P-values only for the relevant layers
for ll=1:size(DataRandSub,2) %layer
    if ismember(ll,LayersSubtractionAnalysis)
        if ll<=Param.LayerSubAnalysis
            numExtremeObsSub(ll)=sum(DataRandSub(:,ll)<=Results.subRho(ll))+1;
            numAllObsSub(ll)=length(DataRandSub(:,ll))+1;
            pvalSub(ll)=numExtremeObsSub(ll)/numAllObsSub(ll);
        else
            numExtremeObsSub(ll)=sum(DataRandSub(:,ll)>=Results.subRho(ll))+1;
            numAllObsSub(ll)=length(DataRandSub(:,ll))+1;
            pvalSub(ll)=numExtremeObsSub(ll)/numAllObsSub(ll);
        end
    else
        numExtremeObsSub(ll)=NaN;
        numAllObsSub(ll)=NaN;
        pvalSub(ll)=NaN;
    end
end
end
