function [pval,numExtremeObs,numAllObs,DataRand]=permutationTest(Results,FixMaps,Activations,Param)
% check significance by comparing Rhos' with a null distribution
% obtained by randomly permuting the image labels in the fixation maps and
% then calculating dissimilarity relationships 1000 times.
% Use FDR to fix multiple comparisons

for nn=1:Param.numReptitions
    clear FixMapsRand
    %randomize labels in fixation maps without replacment
    indRand=randperm(length(FixMaps.ImName));
    FixMapsRand.FM=FixMaps.FM(indRand);
    FixMapsRand.ImName=FixMaps.ImName(indRand);

    %create RDM for shuffled fixation maps
    numCond=length(FixMapsRand.FM{1});
    for kk=1:numCond %conditions
        FixMapsRand.condition(kk).RDM=FixMaps.condition(kk).RDM(indRand,indRand);
    end

    %calcualte correlations between layer RDMs and shuffled fixation maps RDMs
    [DataRand(:,:,nn),~]=calculateCorrBetweenRDMs(FixMapsRand,Activations);
end

%% Calcualte P-values
%P-values for each visibility condition seperataly
for cc=1:size(FixMaps.condition,2) %conditions
    for ll=1:size(Activations.layer,2) %layer
        numExtremeObs(cc,ll)=sum(DataRand(cc,ll,:)<=Results.Rho(cc,ll))+1;
        numAllObs(cc,ll)=length(DataRand(cc,ll,:))+1;
        pval(cc,ll)=numExtremeObs(cc,ll)/numAllObs(cc,ll);
    end
end
end