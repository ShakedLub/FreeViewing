function stdErr=estimateSTDERRBootstrap(FixMaps,Activations,Param)
% calcaulte standard error of the deviation estimate (the correlation between RDMs).
% By calcaulting the standard deviation of 100 estimates obtained from
% bootstrap resampling the image set.

for nn=1:Param.numReptitionsSTDERR
    clear FixMapsRand ActivationsRand
    %subsample images in fixation maps with replacment
    indRand=randi(length(FixMaps.ImName),1,Param.numImagesSTDERR);
    FixMapsRand.FM=FixMaps.FM(indRand);
    FixMapsRand.ImName=FixMaps.ImName(indRand);

    %create RDM for shuffled fixation maps
    numCond=length(FixMapsRand.FM{1});
    for kk=1:numCond %conditions
        FixMapsRand.condition(kk).RDM=FixMaps.condition(kk).RDM(indRand,indRand);
    end

    %re-organize activations based on subsampled images
    ActivationsRand.act=Activations.imageActivations(indRand);
    ActivationsRand.ImageNames=Activations.ImageNames(indRand);
    ActivationsRand.LayerNamesShort=Activations.LayerNamesShort;

    %create RDM for each of googlenet layers based on the shuffled data
    numLayers=length(Activations.LayerNames);
    for ll=1:numLayers %layers
        ActivationsRand.layer(ll).RDM=Activations.layer(ll).RDM(indRand,indRand);  
    end

    %calcualte correlations between layers RDMs or NM RDM and shuffled
    %fixation maps RDMs
    [CorrRandCNN(:,:,nn),~]=calculateCorrBetweenRDMs(FixMapsRand,ActivationsRand);
end
stdErr=std(CorrRandCNN,0,3);
end