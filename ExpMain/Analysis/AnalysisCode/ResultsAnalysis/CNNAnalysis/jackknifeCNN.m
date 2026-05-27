function [Results,ResultsTreeBH]=jackknifeCNN(fixations,Param,Paths,subjExclude)
%% delete one participant from fixations
for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %conditions
        subjs=[fixations(ii).condition(kk).subject.subjNum];
        if any(ismember(subjs,subjExclude))
            %delete trial of participant from main data
            fixations(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
        end
    end
end

%% delete from fixations images that don't have data from both visibility conditions,
% if no subj were left in one of the visibility conditions, after deleting the one subject.
indDel=[];
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    fixations(indDel)=[];
end

%% calcualtions
%create fixation maps
[FixMaps,imagesToInclude]=createFixationMaps(fixations,Param,Paths);

%calculate RDM for fixation maps
FixMaps=calculateRDMFixationMaps(FixMaps);

%% Run CNN and create layers RDM
%run nearal network on images to get layer activations
Activations=CNNOnImages(Param,Paths,imagesToInclude);

%create RDM for each of googlenet layers
Activations=calculateRDMActivations(Activations);

%% correlation between RDMs
%calcualte correlations between layers and fixation maps
[Results.Rho,Results.subRho]=calculateCorrBetweenRDMs(FixMaps,Activations);

%% Check the significance of the RDM correlations in each visibility condition seperataly
% check significance by comparing Rhos' with a null distribution
% obtained by randomly permuting the image labels in the fixation maps and
% then calculating dissimilarity relationships 1000 times.
[Results.pval,Results.numExtremeObs,Results.numAllObs,Results.effectSize,DataRand]=permutationTest(Results,FixMaps,Activations,Param);

%% Tree BH
[LayersSubtractionAnalysis,Results.pvalCorrected,treeInput]=calcTreeBHPvalues(Results,Paths);

%% Check the significance of the RDM correlations when comparing visibility conditions
% check significance by saving the visibility conditions patterns of
% viewing, but ignores the content. So we ask if the layers differ in the
% content for C and U conditions.
[Results.pvalSub,Results.numExtremeObsSub,Results.numAllObsSub,Results.effectSizeSub]=permutationTestSubtraction(Results,LayersSubtractionAnalysis,DataRand,Param);

%% Tree BH Final
ResultsTreeBH=calcTreeBHPvaluesFinal(Results,LayersSubtractionAnalysis,treeInput,Paths);
end