close all
clear
clc

%% Conditions
saveFlag=1; %1 save, 0 do not save
experiment_number='2'; %'1' or '2'
condition=3; %condition 1 main analysis
%condition 2 preregistration analysis
%condition 3 rttm check
%condition 4 permutation saving trial structure
%condition 5 permutation saving trial structure on both experiments together

%% Parameters
%General parameters
if condition == 5
    Param.PILOT_NUM=NaN;
else
    Param.PILOT_NUM=experiment_number;
end
Param.RemoveCenterBias=1;
Param.AnalysisTimeLimitFlag=1;

%region analysis
if condition == 2
    Param.LowLevelType=1; %Type 1: itti and koch model from salinecy toolbox
else
    Param.LowLevelType=2; %Type 2: itti and koch model from smiler that is histogram matched to the non mondrian fixation map and matched in size.
end

%exclude trials with blinks
if condition == 2
    Param.RemoveTrialsWithBlinks=1;
else
    Param.RemoveTrialsWithBlinks=0;
end

%Objects and attributes analysis
Param.IncludeObjNoAttInObj=1; %object analysis 1=yes, 0=No

%Participant choices
if condition == 3
    Param.RemoveSubjectsAwarenessScore=1; %RttM check
else
    Param.RemoveSubjectsAwarenessScore=0; %RttM check
end

%Conduct permutation analysis
Param.shuffledDataFlag=1; %1 yes, 0 no

%More parameters
Param.pixels_per_vdegree=46.1388; %calculated based on screen width 53.2 cm;
Param.window_size_cm=[53.2,29.8];

Param.seed=1;
Param.Nrepetitions=1000;
Param.PlotEyeMovements=0;
Param.EyeTrackerFrameRate=1000;
Param.MinTrials=10; %min trials after fixation exclusion
Param.CenterBiasRadius=1.5; %visual degree for center bias
Param.minSubjPerImageNSSSimilarity=3;
%time parameters
Param.DeltaAroundBlink=10; %msec
Param.DeltaAroundBlinkFrames=Param.DeltaAroundBlink/((1/Param.EyeTrackerFrameRate)*1000);
Param.AnalysisMinTimeLimit=500; %msec
Param.AnalysisMinTimeLimitFrames=Param.AnalysisMinTimeLimit/((1/Param.EyeTrackerFrameRate)*1000);
Param.AnalysisMaxTimeLimit=3500; %msec
Param.AnalysisMaxTimeLimitFrames=Param.AnalysisMaxTimeLimit/((1/Param.EyeTrackerFrameRate)*1000);
Param.minFixDuration=50; %msec
Param.minFixDurationFrames=Param.minFixDuration/((1/Param.EyeTrackerFrameRate)*1000);
Param.chance=0.5; %chance for objective awaraness score
Param.EFAtt=3;

%% Paths
%data paths
Paths.EyeTrackingAnalysisFolder=cd;
cd ..\..\..\..\
Paths.DataFolder=[pwd,'\Raw Data'];
Paths.ExpMatrixFolder=[Paths.DataFolder,'\Behavioral\Pilot',Param.PILOT_NUM];
Paths.EyeTrackingFolder=[Paths.DataFolder,'\EyeTracker\Extracted files\Pilot',Param.PILOT_NUM];
Paths.AnalyzerResultsFolderDomLeft=[Paths.EyeTrackingFolder,'\DomLeft'];
Paths.AnalyzerResultsFolderDomRight=[Paths.EyeTrackingFolder,'\DomRight'];
Paths.PileupFolder=[Paths.DataFolder,'\DataPileups\Pilot',Param.PILOT_NUM];
Paths.ImagesFolder=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.EyeTrackingAnalysisFolder)

%more paths
cd ..\..\..\..\..\
Paths.RainCloudPlot=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.BehavioralResults=[pwd,'\Exp3\Analysis\AnalysisCode\ResultsAnalysis\BehavioralAnalysis'];
cd(Paths.EyeTrackingAnalysisFolder)

cd ..\..\..\
%region segmentation paths
Paths.FoldersPath=[pwd,'\AnalysisFolders'];
Paths.SaliencyMapsPath=[Paths.FoldersPath,'\ResultsImages\SaliencyMaps']; %low level method 1
if condition == 2
    Paths.HighLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\HighLevelMapsPreregControl']; %high level maps
else
    Paths.HighLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\HighLevelMaps']; %high level maps
end
Paths.LowLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\LowLevelMaps']; %low level method 2

%save results paths
if condition == 1
    if Param.RemoveCenterBias==1
        Paths.FixationMapsPath=[Paths.FoldersPath,'\ResultsImages\FixationMapsRemoveCenterBias\Pilot',Param.PILOT_NUM];
    else
        Paths.FixationMapsPath=[Paths.FoldersPath,'\ResultsImages\FixationMaps\Pilot',Param.PILOT_NUM];
    end
end

if condition == 1
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot',Param.PILOT_NUM,'_Final'];
elseif condition == 2
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot',Param.PILOT_NUM,'_PreregistrationCheck'];
elseif condition == 3
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot',Param.PILOT_NUM,'_RttMCheck'];
elseif condition == 4
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot',Param.PILOT_NUM,'_PermutationCheck'];
elseif condition == 5
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Pilot1&2_PermutationSaveTrialStruct'];
    %Paths of ResultsStructs for loading data
    Paths.ResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Pilot1_PermutationSaveTrialStruct'];
    Paths.ResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Pilot2_PermutationSaveTrialStruct'];
end

cd(Paths.EyeTrackingAnalysisFolder)

%% check the saving folder exist and is empty
if saveFlag
    checkDirExistAndEmpty(Paths.ResultsStructsPath)
end

%% Random number generator
sprev=rng(Param.seed);

if condition ~= 5
    %% Load data
    %Participant 427, was ran as 407exAA, so his number in EXPDATA is changed.
    %This participant was added after adding trials with blinks (because he has enough trials
    %to be included)
    %Also participants with objective awareness result above chance are added
    %with different numbers than the ones ran in the randomization
    [EXPDATA_ALL,EYETRACKING_ALL,subjNumber]=loadData(Paths,Param);
    summaryAgeGender=summarizeAgeAndGender(EXPDATA_ALL);
    
    %% save results
    if saveFlag
        save([Paths.ResultsStructsPath,'\','summaryAgeGender.mat'],'summaryAgeGender')
    end
    
    %% Param trials to remeove
    %load specific trials to remove
    Param=loadTrialsToRemove(EXPDATA_ALL,subjNumber,Paths,Param);
    
    %% add fixations to EXPDATA and remove trials and subjects
    %load the analyzer results
    if exist([Paths.AnalyzerResultsFolderDomLeft])
        load([Paths.AnalyzerResultsFolderDomLeft,'\analysis_struct.mat'])
        analysis_struct_left=analysis_struct;
        clear analysis_struct
    end
    if exist([Paths.AnalyzerResultsFolderDomRight])
        load([Paths.AnalyzerResultsFolderDomRight,'\analysis_struct.mat'])
        analysis_struct_right=analysis_struct;
        clear analysis_struct
    end
    
    %add eye tracking data to EXPDATA and remove trials
    for ii=1:size(EXPDATA_ALL,1) %subjects
        for jj=1:size(EXPDATA_ALL,2) %conditions
            clear EXP_COND SUBJ_NUM DOM_EYE fixations saccades raw_data
            %subj parameters
            if jj==1
                EXP_COND='U';
            elseif jj==2
                EXP_COND='C';
            end
            SUBJ_NUM=EXPDATA_ALL{ii,jj}.info.subject_info.subject_number_and_experiment;
            DOM_EYE=EXPDATA_ALL{ii,jj}.info.subject_info.dominant_eye;
            
            switch DOM_EYE
                case 'R'
                    fixations=analysis_struct_right.eye_movements_data.(['s_',EXP_COND,'_',num2str(SUBJ_NUM)]).fixations;
                    saccades=analysis_struct_right.eye_movements_data.(['s_',EXP_COND,'_',num2str(SUBJ_NUM)]).saccades;
                    raw_data=analysis_struct_right.eye_movements_data.(['s_',EXP_COND,'_',num2str(SUBJ_NUM)]).raw_data;
                case 'L'
                    fixations=analysis_struct_left.eye_movements_data.(['s_',EXP_COND,'_',num2str(SUBJ_NUM)]).fixations;
                    saccades=analysis_struct_left.eye_movements_data.(['s_',EXP_COND,'_',num2str(SUBJ_NUM)]).saccades;
                    raw_data=analysis_struct_left.eye_movements_data.(['s_',EXP_COND,'_',num2str(SUBJ_NUM)]).raw_data;
            end
            
            %create for each subject and condition Trials_Analysis a struct
            %with only included trials
            EXPDATA_ALL{ii,jj}.Trials_Analysis=EXPDATA_ALL{ii,jj}.Trials_Experiment;
            
            %add fixation and saacade data to expdata
            EXPDATA_ALL{ii,jj}=arrangeEyeTrackingData(EXPDATA_ALL{ii,jj},fixations,saccades,raw_data);
            
            %present saccades and fixations segmentation
            if Param.PlotEyeMovements
                plotEyeMovements(EXPDATA_ALL{ii,jj},EYETRACKING_ALL{ii,jj},Param.EyeTrackerFrameRate)
            end
            
            %remove control trials
            EXPDATA_ALL{ii,jj}=removeControlTrials(EXPDATA_ALL{ii,jj});
            
            %delete 2 images that were not supposed to be included:
            %image 1131.jpg with federer
            %image 1546.jpg image with strong stripes
            if condition ~= 2
                EXPDATA_ALL{ii,jj}=removeSpecificImages(EXPDATA_ALL{ii,jj});
            else
                EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificImages=0;
            end
            
            %Images: include only PAS 1 trials in U condition, and  PAS 3,4 in C condition
            %Also remove trials with no answer in recognition question
            EXPDATA_ALL{ii,jj}=removeTrialsAwarenessMeasures(EXPDATA_ALL{ii,jj});
            
            %remove trials with blinks
            if Param.RemoveTrialsWithBlinks
                EXPDATA_ALL{ii,jj}=removeTrialsWithBlinksSegmented(EXPDATA_ALL{ii,jj},Param.AnalysisTimeLimitFlag,Param.AnalysisMinTimeLimitFrames,Param.AnalysisMaxTimeLimitFrames);
            else
                EXPDATA_ALL{ii,jj}.TrialsRemoved.TrialsWithBlinks=0;
            end
            
            %remove for specific subejcts specific trials that have problems
            FlagSpecificTrials=0;
            for cc=1:length(Param.SUBJ_NUM_REMOVE)
                if  SUBJ_NUM==Param.SUBJ_NUM_REMOVE(cc) && strcmp(EXP_COND,Param.EXP_COND_REMOVE{cc})
                    EXPDATA_ALL{ii,jj}=removeSpecificTrials(EXPDATA_ALL{ii,jj},Param.TRIALS_REMOVE{cc});
                    FlagSpecificTrials=1;
                    break
                end
            end
            if FlagSpecificTrials==0
                EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificTrials=0;
            end
            
            %remove 1 trial before calibration and validation that happened in
            %the middle of a block
            EXPDATA_ALL{ii,jj}=removeTrialBeforeCalibration(EXPDATA_ALL{ii,jj});
        end
    end
    
    clear analysis_struct_left analysis_struct_right fixations raw_data saccades
    
    Param.window_size_pixels=[EXPDATA_ALL{1,1}.info.lab_setup.screen_width_in_pixels,EXPDATA_ALL{1,1}.info.lab_setup.screen_height_in_pixels];
    Param.subject_distance_from_screen_in_cm=EXPDATA_ALL{1,1}.info.lab_setup.subject_distance_from_screen_in_cm;
    
    %% Remove objective aware subjects
    [EXPDATA_ALL,subjNumber]=excludeSubjectsObjectiveAware(EXPDATA_ALL,subjNumber);
    
    %% delete specific participants due to awareness results (RttM check)
    if Param.RemoveSubjectsAwarenessScore
        [EXPDATA_ALL,subjNumber]=excludeSubjectsAwarenessScore(EXPDATA_ALL,subjNumber,Paths,Param);
    end
    
    %% Suumarize trials removed
    %count how many trials were removed in each condition and
    %summarize the number of trials included in analysis
    TrialsRemoved=CountTrialsRemoved(EXPDATA_ALL);
    
    %% save results
    if saveFlag
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','TrialsRemoved_RemoveCenterBias.mat'],'TrialsRemoved')
            save([Paths.ResultsStructsPath,'\','Param_RemoveCenterBias.mat'],'Param')
        else
            save([Paths.ResultsStructsPath,'\','TrialsRemoved.mat'],'TrialsRemoved')
            save([Paths.ResultsStructsPath,'\','Param.mat'],'Param')
        end
    end
    
    %% Plot the main sequence of saccades
    plotMainSequence(EXPDATA_ALL,subjNumber)
    
    %% Organize the fixation matrix
    %create fixation struct: with fixations of all subejcts divided according to images
    FixationsPerImage=arrangeFixationsPerImage(EXPDATA_ALL,Paths);
    
    %preprocess fixations
    %delete images that do not have data from both visibility conditions
    FixationsPerImageProcessed=PreprocessingFixations(FixationsPerImage,subjNumber,Paths,Param);
    
    % summarize number of subejcts per image
    SummarySubjPerImage=calcSubjPerImage(FixationsPerImageProcessed);
    
    %% save results
    if saveFlag
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','SummarySubjPerImage_RemoveCenterBias.mat'],'SummarySubjPerImage')
            save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed_RemoveCenterBias.mat'],'FixationsPerImageProcessed','-v7.3')
        else
            save([Paths.ResultsStructsPath,'\','SummarySubjPerImage.mat'],'SummarySubjPerImage')
            save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed.mat'],'FixationsPerImageProcessed','-v7.3')
        end
    end
else
    load([Paths.ResultsStructsPath1,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations1=FixationsPerImageProcessed;
    load([Paths.ResultsStructsPath1,'\Fixations_PerSubject_RemoveCenterBias.mat'])
    fixations_persubj1=Fixations_PerSubject;
    clear FixationsPerImageProcessed Fixations_PerSubject
    
    load([Paths.ResultsStructsPath2,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations2=FixationsPerImageProcessed;
    load([Paths.ResultsStructsPath2,'\Fixations_PerSubject_RemoveCenterBias.mat'])
    fixations_persubj2=Fixations_PerSubject;
    clear FixationsPerImageProcessed Fixations_PerSubject
    
    [FixationsPerImageProcessed,subjNumber]=mergeFixationsBothExperiments(fixations1,fixations2,fixations_persubj1,fixations_persubj2);
    clear fixations1 fixations2 fixations_persubj1 fixations_persubj2
    
    Param1=load([Paths.ResultsStructsPath2,'\Param_RemoveCenterBias.mat']);
    Param.pixels_per_vdegree=Param1.Param.pixels_per_vdegree;
    Param.window_size_pixels=Param1.Param.window_size_pixels;
    Param.window_size_cm=Param1.Param.window_size_cm;
    Param.subject_distance_from_screen_in_cm=Param1.Param.subject_distance_from_screen_in_cm;
end

%% exclude subjects if have too small number of trials, and arrange fixations per subject
if condition ~= 5
    %check all subjects have more trials than MinTrials
    [EXPDATA_ALL,subjNumber,FixationsPerImageProcessed]=excludeSubjectsLowNumTrials(EXPDATA_ALL,subjNumber,FixationsPerImageProcessed,Param);
    
    %re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)
    Fixations_PerSubject=arrangeFixationsPerSubject(FixationsPerImageProcessed,subjNumber);
    
    TrialsRemoved=CountTrialsRemovedFinal(Fixations_PerSubject,TrialsRemoved);
    TrialsWithBlinks=CountTrialsWithBlinks(Fixations_PerSubject,TrialsRemoved,Param);
else
    %re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)
    Fixations_PerSubject=arrangeFixationsPerSubject(FixationsPerImageProcessed,subjNumber);
end

%% save results
if condition ~= 5
    if saveFlag
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','Fixations_PerSubject_RemoveCenterBias.mat'],'Fixations_PerSubject')
            save([Paths.ResultsStructsPath,'\','TrialsRemoved_RemoveCenterBias.mat'],'TrialsRemoved')
            save([Paths.ResultsStructsPath,'\','TrialsWithBlinks_RemoveCenterBias.mat'],'TrialsWithBlinks')
        else
            save([Paths.ResultsStructsPath,'\','Fixations_PerSubject.mat'],'Fixations_PerSubject')
            save([Paths.ResultsStructsPath,'\','TrialsRemoved.mat'],'TrialsRemoved')
            save([Paths.ResultsStructsPath,'\','TrialsWithBlinks.mat'],'TrialsWithBlinks')
        end
    end
else
    if saveFlag
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed_RemoveCenterBias.mat'],'FixationsPerImageProcessed','-v7.3')
            save([Paths.ResultsStructsPath,'\','Fixations_PerSubject_RemoveCenterBias.mat'],'Fixations_PerSubject')
        else
            save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed.mat'],'FixationsPerImageProcessed','-v7.3')
            save([Paths.ResultsStructsPath,'\','Fixations_PerSubject.mat'],'Fixations_PerSubject')
        end
    end
end

%% Base line: add shuffled fixations for each image
if Param.shuffledDataFlag
    if condition == 4 || condition == 5
        FixationsPerImageProcessed=shuffleFixationsSaveTrialPermutationAnalysis(FixationsPerImageProcessed,Fixations_PerSubject,subjNumber,Param.Nrepetitions);
    else
        FixationsPerImageProcessed=shuffleFixationsPermutationAnalysis(FixationsPerImageProcessed,subjNumber,Param.Nrepetitions);
    end
end

%% Region classification
%classify fixations to regions and calculate measures (fixperpix, fixdurperpix)
%in each of the regions. For real data and base line data.
RegionsResults=classifyFixationsRegions(FixationsPerImageProcessed,Paths,Param);
if Param.shuffledDataFlag
    RegionsSummary=calculationsRegions(RegionsResults);
    plotRegionsResults(RegionsSummary);
end

% Region classification per subject
%caclculate for each subject fixperpix and fixdurperpix for each region
[RegionsSummary_PerSubj,RegionsResults_PerSubj]=calculationsRegionsPerSubject(RegionsResults,FixationsPerImageProcessed,subjNumber);

%% save results
if saveFlag
    if Param.RemoveCenterBias
        if Param.shuffledDataFlag
            save([Paths.ResultsStructsPath,'\','RegionsSummary_RemoveCenterBias.mat'],'RegionsSummary')
        end
        %save([Paths.ResultsStructsPath,'\','RegionsResults_RemoveCenterBias.mat'],'RegionsResults','-v7.3')
        save([Paths.ResultsStructsPath,'\','RegionsSummary_PerSubj_RemoveCenterBias.mat'],'RegionsSummary_PerSubj')
        save([Paths.ResultsStructsPath,'\','RegionsResults_PerSubj_RemoveCenterBias.mat'],'RegionsResults_PerSubj')
    else
        if Param.shuffledDataFlag
            save([Paths.ResultsStructsPath,'\','RegionsSummary.mat'],'RegionsSummary')
        end
        %save([Paths.ResultsStructsPath,'\','RegionsResults.mat'],'RegionsResults','-v7.3')
        save([Paths.ResultsStructsPath,'\','RegionsSummary_PerSubj.mat'],'RegionsSummary_PerSubj')
        save([Paths.ResultsStructsPath,'\','RegionsResults_PerSubj.mat'],'RegionsResults_PerSubj')
    end
end


%% Classify fixations to objects and attributes
%load attrs
if condition == 2
    load('AttrsOSIE.mat')
else
    load('AttrsCombined.mat')
end

% classify fixations to objects
ObjectsResults=classifyFixationsObjects(FixationsPerImageProcessed,Paths,Param,attrs,attrNames);
if Param.shuffledDataFlag
    [ObjectsResults,ObjectsSummary]=calculationsObjects(ObjectsResults,Param);
end

% classify fixations to atributes
AttributesResults=classifyFixationsAttributes(ObjectsResults,FixationsPerImageProcessed,Param,attrs,attrNames);
if Param.shuffledDataFlag
    [AttributesResults,AttributesSummary]=calculationsAttributes(AttributesResults,Param,attrNames);
end

% Object classification per subject
[ObjectsSummary_PerSubj,ObjectsResults_PerSubj]=calculationsObjectsPerSubject(ObjectsResults,FixationsPerImageProcessed,subjNumber,Param);

%% Save results
if saveFlag
    if Param.RemoveCenterBias
        %save([Paths.ResultsStructsPath,'\','ObjectsResults_RemoveCenterBias.mat'],'ObjectsResults','-v7.3')
        %save([Paths.ResultsStructsPath,'\','AttributesResults_RemoveCenterBias.mat'],'AttributesResults','-v7.3')
        if Param.shuffledDataFlag
            save([Paths.ResultsStructsPath,'\','ObjectsSummary_RemoveCenterBias.mat'],'ObjectsSummary')
            save([Paths.ResultsStructsPath,'\','AttributesSummary_RemoveCenterBias.mat'],'AttributesSummary')
        end
        save([Paths.ResultsStructsPath,'\','ObjectsSummary_PerSubj_RemoveCenterBias.mat'],'ObjectsSummary_PerSubj')
        save([Paths.ResultsStructsPath,'\','ObjectsResults_PerSubj_RemoveCenterBias.mat'],'ObjectsResults_PerSubj')
    else
        %save([Paths.ResultsStructsPath,'\','ObjectsResults.mat'],'ObjectsResults','-v7.3')
        %save([Paths.ResultsStructsPath,'\','AttributesResults.mat'],'AttributesResults','-v7.3')
        if Param.shuffledDataFlag
            save([Paths.ResultsStructsPath,'\','ObjectsSummary.mat'],'ObjectsSummary')
            save([Paths.ResultsStructsPath,'\','AttributesSummary.mat'],'AttributesSummary')
        end
        save([Paths.ResultsStructsPath,'\','ObjectsSummary_PerSubj.mat'],'ObjectsSummary_PerSubj')
        save([Paths.ResultsStructsPath,'\','ObjectsResults_PerSubj.mat'],'ObjectsResults_PerSubj')
    end
end

if condition == 1 %create fixation maps only for the main analysis
    %% create fixation maps
    FixMaps=CreateFixationMaps(FixationsPerImageProcessed,Paths,Param);
    
    %% calculate inter observer congruence and dispersion for the C and UC conditions
    %NSS similarity per image
    NSSSimilarity=calculateNSSSimilarity(FixationsPerImageProcessed,FixMaps,Paths,Param);
    %NSS similarity per subject
    NSSSimilarity_PerSubj=calculateNSSSimilarityPerSubject(NSSSimilarity,EXPDATA_ALL,subjNumber);
    
    %% save results
    if saveFlag
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','NSSSimilarity_RemoveCenterBias.mat'],'NSSSimilarity')
            save([Paths.ResultsStructsPath,'\','NSSSimilarity_PerSubj_RemoveCenterBias.mat'],'NSSSimilarity_PerSubj')
        else
            save([Paths.ResultsStructsPath,'\','NSSSimilarity.mat'],'NSSSimilarity')
            save([Paths.ResultsStructsPath,'\','NSSSimilarity_PerSubj.mat'],'NSSSimilarity_PerSubj')
        end
    end
end

if condition == 1 && saveFlag  %save classification of real data without shuffled data, for figures
    Param.shuffledDataFlag=0;
    
    RegionsResults=classifyFixationsRegions(FixationsPerImageProcessed,Paths,Param);
    ObjectsResults=classifyFixationsObjects(FixationsPerImageProcessed,Paths,Param,attrs,attrNames);
    AttributesResults=classifyFixationsAttributes(ObjectsResults,FixationsPerImageProcessed,Param,attrs,attrNames);
    
    if Param.RemoveCenterBias
        save([Paths.ResultsStructsPath,'\','RegionsResults_NoShuffling_RemoveCenterBias.mat'],'RegionsResults')
        save([Paths.ResultsStructsPath,'\','ObjectsResults_NoShuffling_RemoveCenterBias.mat'],'ObjectsResults')
        save([Paths.ResultsStructsPath,'\','AttributesResults_NoShuffling_RemoveCenterBias.mat'],'AttributesResults')
    else
        save([Paths.ResultsStructsPath,'\','RegionsResults_NoShuffling.mat'],'RegionsResults')
        save([Paths.ResultsStructsPath,'\','ObjectsResults_NoShuffling.mat'],'ObjectsResults')
        save([Paths.ResultsStructsPath,'\','AttributesResults_NoShuffling.mat'],'AttributesResults') 
    end
end

%% return random number generator to default
rng(sprev);