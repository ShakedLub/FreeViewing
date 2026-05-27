close all
clc
clear

%% Conditions
saveFlag=1; %1 save, 0 do not save
experiment_number='1'; %'1', '2' or '12'
condition=1; %condition 1 main analysis
%condition 3 rttm check

%Analysis for revision, run them on both experiments together:
%condition 5 conscious trials from unconscious and conscious sessions
%condition 8 only right dominant eye participants included
%condition 9 only left dominant eye participants included
%condition 10 jackknife analysis
%condition 11 downsample number of trials according to the smaller visibility
%condition for each participant
%condition 12 downsample number of trials according to the smaller visibility
%condition for each image
%condition 13 compares conscious condition to free viewing data without a mask

%% parameters
Param.EXP_NUM=experiment_number; %'1', '2', '12'
Param.RemoveCenterBias=1; % 1 yes, 0 no

if condition == 3
    Param.RemoveSubjectsAwarenessScore=1; %RttM check
else
    Param.RemoveSubjectsAwarenessScore=0;
end

Param.seed=1;

Param.pixels_per_vdegree=46.1388; %calculated based on screen width 53.2 cm;

% Take pooling (only from main branch) and convoultion layers, without conv
% 1x1. So from inception module take: conv 3x3 and conv 5x5
% in each convolution take final innerlayer for each layer (ReLU)
Param.LayerNum=[3,4,9,11,17,21,31,35,40,46,50,60,64,74,78,88,92,102,106,111,117,121,131,135,140];

Param.MinTrials=10; %min trials after fixation exclusion
Param.numReptitions=1000;
Param.numReptitionsSTDERR=100;
Param.numImagesSTDERR=200;
Param.LayerSubAnalysis=11; %Until this layer we hypothesis that U condition 1-corr is smaller than in the C condition
Param.CenterBiasRadius=1.5; %visual degree
Param.wantedImSize=[339,452];
ResultsTreeBH=[];

%% paths
if condition == 1
    ending='_Final';
elseif condition == 3
    ending='_RttMCheck';
elseif condition == 5
    ending='_ConsciousTrialsBothSessions';
elseif condition == 8
    ending='_RightDominantEye';
elseif condition == 9
    ending='_LeftDominantEye';
elseif condition == 10
    ending='_JackKnife';
elseif condition == 11
    ending='_DownSampleTrialsParticipantLevel';
elseif condition == 12
    ending='_DownSampleTrialsImageLevel';
elseif condition == 13
    ending='_FreeViewingVsConscious';
end

Paths.cnnAnalysisFolder=cd;
cd ..\..\..\..\
Paths.DataFolder=[pwd,'\Raw Data'];
if isequal(Param.EXP_NUM,'12')
    Paths.PileupFolder=[Paths.DataFolder,'\DataPileups\Experiment1'];
else
    Paths.PileupFolder=[Paths.DataFolder,'\DataPileups\Experiment',Param.EXP_NUM];
end
Paths.ImagesFolder=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.cnnAnalysisFolder)

%more paths
cd ..\..\..\..\..\
Paths.RainCloudPlot=[pwd,'\ExpMain\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.TreeBH=[pwd,'\ExpMain\Analysis\AnalysisFolders\Code\TreeBH'];
cd(Paths.cnnAnalysisFolder)

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\AnalysisFolders'];
if isequal(Param.EXP_NUM,'12')
    if condition == 10
        Paths.ResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Experiment1_Final'];
        Paths.ResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Experiment2_Final'];
    elseif condition == 13
        Paths.ResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Experiment1_Final'];
        Paths.ResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Experiment2_Final'];
        Paths.ResultsStructsPathFV=[Paths.FoldersPath,'\ResultsStructs\FreeViewingNoMondrians'];
    else
        Paths.ResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Experiment1',ending];
        Paths.ResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Experiment2',ending];
    end
else
    if condition == 10
        Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_Final'];
    elseif condition == 13
        error('Free viewing condition can not be run for only one experiment')
    else
        Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,ending];
    end
end

if condition == 10
    Paths.ResultsStructsRSAOriginal=[Paths.FoldersPath,'\ResultsStructs\RSA\Experiment',Param.EXP_NUM,'_Final'];
end
%save data path
Paths.ResultsStructsRSAPath=[Paths.FoldersPath,'\ResultsStructs\RSA\Experiment',Param.EXP_NUM,ending];
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

%% Load data
%load fixations processed
%This is data with no fixations in the middle in addition the center is deleted later, after creating the fixation maps
if isequal(Param.EXP_NUM,'12')
    load([Paths.ResultsStructsPath1,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations1=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed

    load([Paths.ResultsStructsPath2,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations2=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed

    fixations=mergeFixationsBothExperiments(fixations1,fixations2,Param);

    % create subjNum vec
    load([Paths.ResultsStructsPath1,'\Fixations_PerSubject_RemoveCenterBias.mat'])
    subj1=[Fixations_PerSubject.subjNum];
    clear Fixations_PerSubject

    load([Paths.ResultsStructsPath2,'\Fixations_PerSubject_RemoveCenterBias.mat'])
    subj2=[Fixations_PerSubject.subjNum];
    clear Fixations_PerSubject

    subjNum=[subj1,subj2];

    if condition == 13
        load([Paths.ResultsStructsPathFV,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
        fixationsFV=FixationsPerImageProcessed;
        clear FixationsPerImageProcessed

        %create fixations with all images in Param.ImageNames some images may be empty for both visibility conditions
        %these images will be excluded when creating fixation maps
        fixations=mergeFixationsFVandCCond(fixations,fixationsFV,Param);

        % create subjNum vec
        load([Paths.ResultsStructsPathFV,'\Fixations_PerSubject_RemoveCenterBias.mat'])
        subj3=[Fixations_PerSubject.subjNum];
        clear Fixations_PerSubject

        subjNum=[subj1,subj2,subj3];
    end
else
    load([Paths.ResultsStructsPath,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed

    %check image order is the same, if not it is beucase images were
    %excluded as they don't have data in both visibility conditions
    if ~isequal(Param.ImageNames,{fixations.img})
        disp('Not all images are included in the analysis')
    end

    % create subjNum vec
    load([Paths.ResultsStructsPath,'\Fixations_PerSubject_RemoveCenterBias.mat'])
    subjNum=[Fixations_PerSubject.subjNum];
    clear Fixations_PerSubject
end

%% Check all images have fixations in both visibility conditions
%Fixations from one experiment have data from both visiblity codnitions for
%all images. Some images may not be included. 
%Fixations from two experiments created by the merge function, have all
%images in Param.ImageNames so some images may be empty in both visibility conditions.
%Then they will be excluded in create fixations maps. What won't happen is that an image will 
%have trials from only one visiblity condition, as this is not possible
%when creating data in Run_analysis_images
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
        disp('Not all images have fixations from both visibility conditions')
        break
    end
end

if condition ~= 10
    %% Create fixation maps and RDMs in C and U conditions
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

    %Std err and CI for the CNN analysis, based on bootstraping the image set
    Param.numImagesSTDERR=min(Param.numImagesSTDERR,length(imagesToInclude));
    [Results.stdErr,Results.CI,Results.meanErr,Results.CIlength,Results.DataRandForSTE]=estimateSTDERRBootstrap(FixMaps,Activations,Param);

    %Noise ceiling lower bound estimation, based on splitting the data to two groups of participants
    Results.noise=estimateNoiseFloor(fixations,subjNum,imagesToInclude,Param,Paths);

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
    [Results.pval,Results.numExtremeObs,Results.numAllObs,Results.effectSize,DataRand]=permutationTest(Results,FixMaps,Activations,Param);

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
    [Results.pvalSub,Results.numExtremeObsSub,Results.numAllObsSub,Results.effectSizeSub]=permutationTestSubtraction(Results,LayersSubtractionAnalysis,DataRand,Param);

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
else %Jackknife analysis
    for subj=1:length(subjNum)
        [CNNjackknifeResults,CNNjackknifeResultsTreeBH]=jackknifeCNN(fixations,Param,Paths,subjNum(subj));

        %Save data for jackknife analysis
        %jackknife replicates
        jackKnife.Rho_jackknifeRep(:,:,subj)=CNNjackknifeResults.Rho;
        jackKnife.subRho_jackknifeRep(subj,:)=CNNjackknifeResults.subRho;

        %Jacknife p-values
        [jackKnife.Rho_jackknifePval(:,:,subj),jackKnife.subRho_jackknifePval(subj,:)]=extractPvalFromTree(CNNjackknifeResultsTreeBH,CNNjackknifeResults);

        %jacknife effect-sizes
        jackKnife.Rho_jackknifeEffectSize(:,:,subj)=CNNjackknifeResults.effectSize;
        jackKnife.subRho_jackknifeEffectSize(subj,:)=CNNjackknifeResults.effectSizeSub;

        clear CNNjackknifeResults CNNjackknifeResultsTreeBH
        close all
    end
    jackKnife=jackknifeCalculationsCNN(jackKnife,Paths);
    tbl=createJackkinfeSummaryTable(jackKnife);
    
    if saveFlag
        save([Paths.ResultsStructsRSAPath,'\jackKnife_RemoveCenterBias.mat'],'jackKnife')
        writetable(tbl,[Paths.ResultsStructsRSAPath,'\jackKnifeTable_RemoveCenterBias.csv'])
    end
end