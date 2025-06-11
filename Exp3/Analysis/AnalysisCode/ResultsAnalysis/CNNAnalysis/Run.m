close all
clc
clear

%% Conditions
saveFlag=1; %1 save, 0 do not save
experiment_number='1'; %'1', '2' or '12'
condition=1; %condition 1 main analysis
             %condition 3 rttm check
             
%% parameters
Param.PILOT_NUM=experiment_number; %'1', '2', '12'
Param.RemoveCenterBias=1; % 1 yes, 0 no

if condition == 3
    Param.RemoveSubjectsAwarenessScore=1; %RttM check
else
    Param.RemoveSubjectsAwarenessScore=0; %RttM check
end

Param.seed=1;

Param.pixels_per_vdegree=46.1388; %calculated based on screen width 53.2 cm;

% Take pooling (only from main branch) and convoultion layers, without conv
% 1x1. So from inception module take: conv 3x3 and conv 5x5
% in each convolution take final innerlayer for each layer (ReLU)
Param.LayerNum=[3,4,9,11,17,21,31,35,40,46,50,60,64,74,78,88,92,102,106,111,117,121,131,135,140];

Param.numReptitions=1000;
Param.numReptitionsSTDERR=100;
Param.numImagesSTDERR=200;
Param.LayerSubAnalysis=11; %Until this layer we hypothesis that U condition 1-corr is smaller than in the C condition 
Param.CenterBiasRadius=1.5; %visual degree
Param.wantedImSize=[339,452];
ResultsTreeBH=[];

%% paths
Paths.cnnAnalysisFolder=cd;
cd ..\..\..\..\
Paths.DataFolder=[pwd,'\Raw Data'];
if ~isequal(Param.PILOT_NUM,'12')
    Paths.PileupFolder=[Paths.DataFolder,'\DataPileups\Pilot',Param.PILOT_NUM];
else
    Paths.PileupFolder=[Paths.DataFolder,'\DataPileups\Pilot1'];
end
Paths.ImagesFolder=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.cnnAnalysisFolder)

%more paths
cd ..\..\..\..\..\
Paths.RainCloudPlot=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.TreeBH=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\TreeBH'];
cd(Paths.cnnAnalysisFolder)

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\AnalysisFolders'];
if ~isequal(Param.PILOT_NUM,'12')
    if Param.RemoveSubjectsAwarenessScore
        Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot',Param.PILOT_NUM,'_RttMCheck'];
    else
        Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot',Param.PILOT_NUM,'_Final'];
    end
else
    if Param.RemoveSubjectsAwarenessScore
        Paths.ResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Pilot1_RttMCheck'];
        Paths.ResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Pilot2_RttMCheck'];
    else
        Paths.ResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Pilot1_Final'];
        Paths.ResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Pilot2_Final'];
    end
end
if Param.RemoveSubjectsAwarenessScore
    Paths.ResultsStructsRSAPath=[Paths.FoldersPath,'\ResultsStructs\RSA\Pilot',Param.PILOT_NUM,'_RttMCheck'];
else
    Paths.ResultsStructsRSAPath=[Paths.FoldersPath,'\ResultsStructs\RSA\Pilot',Param.PILOT_NUM,'_Final'];
end
cd(Paths.cnnAnalysisFolder)

%% check the saving folder exist and is empty
if saveFlag
    checkDirExistAndEmpty(Paths.ResultsStructsRSAPath)
end

%% load parameters
%load image names
cd(Paths.PileupFolder)
d=dir('*.mat');
ind=contains({d.name},'pileup');
d=d(ind);
cd(Paths.cnnAnalysisFolder)
load([Paths.PileupFolder,'\',d(1).name],'DESIGN_PARAM','resources')
Param.ImageNames=DESIGN_PARAM.Image_Names_Experiment;

%delete two images that were excluded 
%image 1131.jpg with federer
%image 1546.jpg image with strong stripes
indel=find(strcmp('1131.jpg',Param.ImageNames));
Param.ImageNames(indel)=[];
indel=find(strcmp('1546.jpg',Param.ImageNames));
Param.ImageNames(indel)=[];

%load more parameters
RECT=resources.Images.dstRectDom;
rect=[RECT(1),RECT(2),RECT(3)-RECT(1),RECT(4)-RECT(2)];%rect=[widthmin heightmin width height]
Param.ImSize=[rect(4),rect(3)];
if ~isequal(Param.wantedImSize,Param.ImSize)
    error('Wrong image size')
end

clear DESIGN_PARAM d ind resources RECT rect EXPDATA ImNamesHighNSSSimilarity indel

%% random number generator
sprev=rng(Param.seed);

%% Fixation map in C and U conditions- load and create RDMs
%load fixations processed
%This is data with no fixations in the middle in addition the center is deleted later, after creating the fixation maps
if ~isequal(Param.PILOT_NUM,'12')
    load([Paths.ResultsStructsPath,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed
    
    %check image order is the same
    if ~isequal(Param.ImageNames,{fixations.img})
        disp('Not all images have fixations from participants in both visibility conditions')
    end
else
    load([Paths.ResultsStructsPath1,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations1=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed
    
    load([Paths.ResultsStructsPath2,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations2=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed

    fixations=mergeFixationsBothExperiments(fixations1,fixations2,Param);
end

%create fixation maps
[FixMaps,imagesToInclude]=createFixationMaps(fixations,Param,Paths);

%calculate RDM for fixation maps
FixMaps=calculateRDMFixationMaps(FixMaps);

%% Run CNN and create layers RDM
%run nearal network on images to get layer activations
Activations=CNNOnImages(Param,Paths,imagesToInclude);

%create RDM for each of googlenet layers
Activations=calculateRDMActivations(Activations);

%% Plot RDMs
%plot RDMs
plotRDM(FixMaps,Activations)
if saveFlag
    saveas(gcf,[Paths.ResultsStructsRSAPath,'\RDMs.jpg'], 'jpg')
end

%% correlation between RDMs
%calcualte correlations between layers and fixation maps
[Results.Rho,Results.subRho]=calculateCorrBetweenRDMs(FixMaps,Activations);

%Std err for the CNN analysis, based on bootstraping the image set
Param.numImagesSTDERR=min(Param.numImagesSTDERR,length(imagesToInclude));
Results.stdErr=estimateSTDERRBootstrap(FixMaps,Activations,Param);

%Plot correlations between RDMs
plotCorrelationsRDM(Results,Activations,ResultsTreeBH)

%% Save results
if saveFlag
    if Param.RemoveCenterBias
        save([Paths.ResultsStructsRSAPath,'\Param_RemoveCenterBias.mat'],'Param')
        save([Paths.ResultsStructsRSAPath,'\Paths_RemoveCenterBias.mat'],'Paths')
        save([Paths.ResultsStructsRSAPath,'\Results_RemoveCenterBias.mat'],'Results')
    else
        save([Paths.ResultsStructsRSAPath,'\Param.mat'],'Param')
        save([Paths.ResultsStructsRSAPath,'\Paths.mat'],'Paths')
        save([Paths.ResultsStructsRSAPath,'\Results.mat'],'Results')
    end
end

%% Check the significance of the RDM correlations in each visibility condition seperataly
% check significance by comparing Rhos' with a null distribution
% obtained by randomly permuting the image labels in the fixation maps and
% then calculating dissimilarity relationships 1000 times.
[Results.pval,Results.numExtremeObs,Results.numAllObs,DataRand]=permutationTest(Results,FixMaps,Activations,Param);

%% Save results
if saveFlag
    if Param.RemoveCenterBias
        save([Paths.ResultsStructsRSAPath,'\Results_RemoveCenterBias.mat'],'Results')
        save([Paths.ResultsStructsRSAPath,'\DataRand_RemoveCenterBias.mat'],'DataRand')
    else
        save([Paths.ResultsStructsRSAPath,'\Results.mat'],'Results')
        save([Paths.ResultsStructsRSAPath,'\DataRand.mat'],'DataRand')
    end
end

%% Tree BH
[LayersSubtractionAnalysis,Results.pvalCorrected,treeInput]=calcTreeBHPvalues(Results,Paths);

%% Check the significance of the RDM correlations when comparing visibility conditions
% check significance by saving the visibility conditions patterns of
% viewing, but ignores the content. So we ask if the layers differ in the
% content for C and U conditions.
[Results.pvalSub,Results.numExtremeObsSub,Results.numAllObsSub]=permutationTestSubtraction(Results,LayersSubtractionAnalysis,DataRand,Param);

%% Save results
if saveFlag
    if Param.RemoveCenterBias
        save([Paths.ResultsStructsRSAPath,'\Results_RemoveCenterBias.mat'],'Results')
    else
        save([Paths.ResultsStructsRSAPath,'\Results.mat'],'Results')
    end
end

%% Tree BH Final
ResultsTreeBH=calcTreeBHPvaluesFinal(Results,LayersSubtractionAnalysis,treeInput,Paths);

%% save results
if saveFlag
    save([Paths.ResultsStructsRSAPath,'\ResultsTreeBH.mat'],'ResultsTreeBH')
    saveas(gcf,[Paths.ResultsStructsRSAPath,'\TreeBH.jpg'], 'jpg')
end

%% plot correlations with astricks
plotCorrelationsRDM(Results,Activations,ResultsTreeBH)
if saveFlag
    saveas(gcf,[Paths.ResultsStructsRSAPath,'\RDMCorrelations.jpg'], 'jpg')
end