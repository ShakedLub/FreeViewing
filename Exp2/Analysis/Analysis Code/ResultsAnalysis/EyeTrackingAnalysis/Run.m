close all
clear
clc

%% condition
condition=2; %condition 1: main analysis
%condition 2: peregistration control
saveFlag=1;

%% Parameters
%General parameters
Param.RemoveCenterBias=0;
Param.PILOT_NUM='3';

%exclude trials with blinks
if condition == 2
    Param.RemoveTrialsWithBlinks=1;
else
    Param.RemoveTrialsWithBlinks=0;
end

%More parameters
Param.pixels_per_vdegree=46.1388; %calculated based on screen width 53.2 cm
Param.EyeTrackerFrameRate=1000;
Param.MinTrials=10;
Param.minSubjPerImageNSSSimilarity=3;
Param.wantedImSize=[339,452];
Param.CenterBiasRadius=1.5; %visual degree
Param.PlotEyeMovements=0;
%Time parameters
Param.DeltaAroundBlink=10; %msec
Param.DeltaAroundBlinkFrames=Param.DeltaAroundBlink/((1/Param.EyeTrackerFrameRate)*1000);
Param.minFixDuration=50; %msec
Param.minFixDurationFrames=Param.minFixDuration/((1/Param.EyeTrackerFrameRate)*1000);

% Remove problematic trials for specific subjects
Param.SUBJ_NUM_REMOVE=[304,309,320,337,650,351,354];
Param.TRIALS_REMOVE={[1:80],[1:80],[161:162],[36:45,136:180,181:199],[91:95],[1:45],[46:90]}; %trial number overall

%% Paths
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

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\AnalysisFolders'];
if condition == 1
    Paths.FixationMapsPath=[Paths.FoldersPath,'\ResultsImages\FixationMaps'];
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\MainAnalysis'];
elseif condition == 2
    Paths.FixationMapsPath=[Paths.FoldersPath,'\ResultsImages\FixationMapsNoBlinks'];
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\PreregistrationControlNoBlinks'];
end
cd(Paths.EyeTrackingAnalysisFolder)

%more paths
cd ..\..\..\..\..\
Paths.RainCloudPlot=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
cd(Paths.EyeTrackingAnalysisFolder)

%% check the saving folder exist and is empty
if saveFlag
    checkDirExistAndEmpty(Paths.ResultsStructsPath)
    checkDirExistAndEmpty(Paths.FixationMapsPath)
end

%% Load data
[EXPDATA_ALL,EYETRACKING_ALL,subjNumber]=loadData(Paths);
summaryAgeGender=summarizeAgeAndGender(EXPDATA_ALL);

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
for ii=1:length(EXPDATA_ALL) %subjects
    clear SUBJ_NUM DOM_EYE fixations saccades raw_data
    %subj parameters
    SUBJ_NUM=EXPDATA_ALL{ii}.info.subject_info.subject_number_and_experiment;
    DOM_EYE=EXPDATA_ALL{ii}.info.subject_info.dominant_eye;
    
    switch DOM_EYE
        case 'R'
            fixations=analysis_struct_right.eye_movements_data.(['s',num2str(SUBJ_NUM)]).fixations;
            saccades=analysis_struct_right.eye_movements_data.(['s',num2str(SUBJ_NUM)]).saccades;
            raw_data=analysis_struct_right.eye_movements_data.(['s',num2str(SUBJ_NUM)]).raw_data;
        case 'L'
            fixations=analysis_struct_left.eye_movements_data.(['s',num2str(SUBJ_NUM)]).fixations;
            saccades=analysis_struct_left.eye_movements_data.(['s',num2str(SUBJ_NUM)]).saccades;
            raw_data=analysis_struct_left.eye_movements_data.(['s',num2str(SUBJ_NUM)]).raw_data;
    end
    
    EXPDATA_ALL{ii}.Trials_Analysis=EXPDATA_ALL{ii}.Trials_Experiment;
    
    %add fixation data to expdata
    EXPDATA_ALL{ii}=arrangeEyeTrackingData(EXPDATA_ALL{ii},fixations,saccades,raw_data);
    
    %check eye movements segmentation and present saccades and
    %fixations
    if Param.PlotEyeMovements
        plotEyeMovements(EXPDATA_ALL{ii},EYETRACKING_ALL{ii},Param.EyeTrackerFrameRate)
    end
    
    %remove trials with images not from OSIE dataset as these images are not included
    %in exp 3
    EXPDATA_ALL{ii}=removeTrialsWithoutOSIEImages(EXPDATA_ALL{ii},Paths);

    %remove trials with blinks
    if Param.RemoveTrialsWithBlinks
        EXPDATA_ALL{ii}=removeTrialsWithBlinksSegmented(EXPDATA_ALL{ii});
    else
        EXPDATA_ALL{ii}.TrialsRemoved.TrialsWithBlinks=0;
    end
        
    %remove  for specific subejcts specific trials that were problematic in
    %recording from various reasons 
    FlagSpecificTrials=0;
    for cc=1:length(Param.SUBJ_NUM_REMOVE)
        if  SUBJ_NUM==Param.SUBJ_NUM_REMOVE(cc) 
            EXPDATA_ALL{ii}=removeTrialsSpecific(EXPDATA_ALL{ii},Param.TRIALS_REMOVE{cc});
            FlagSpecificTrials=1;
            break
        end
    end
    if FlagSpecificTrials==0
        EXPDATA_ALL{ii}.TrialsRemoved.SpecificTrials=0;
    end
    
    %remove 1 trial before calibration and validation that happened in
    %the middle of a block
    EXPDATA_ALL{ii}=removeTrialBeforeCalibration(EXPDATA_ALL{ii});
end

%count how many trials were removed in each condition
TrialsRemoved_withoutSubjectExclusion=CountTrialsRemoved(EXPDATA_ALL);

%remove subjects with less trials than MinTrials
[EXPDATA_ALL,subjNumber,numSubjRemoved]=removeSubjectsLowNumTrials(EXPDATA_ALL,subjNumber,Param.MinTrials);

%count how many trials were removed in each condition and 
%summarize the number of trials included in analysis
TrialsRemoved=CountTrialsRemoved(EXPDATA_ALL);

clear analysis_struct_left analysis_struct_right fixations raw_data saccades

%% plot main sequence of saccades
plotMainSequence(EXPDATA_ALL,subjNumber);

%% behavioral analysis: memory task
Results_Memory=checkMemoryPerformance(EXPDATA_ALL,Paths);

%% Organize the fixation matrix
%create fixation struct: with fixations of all subejcts divided according to
%images
FixationsPerImage=arrangeFixationsPerImage(EXPDATA_ALL,Paths);

%preprocess fixations
FixationsPerImageProcessed=PreprocessingFixations(FixationsPerImage,subjNumber,Paths,Param);

% summarize number of subejcts per image
SummarySubjPerImage=calcSubjPerImage(FixationsPerImageProcessed,Paths);

%% images fixations arrange per subject
%re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)
Fixations_PerSubject=arrangeFixationsPerSubject(FixationsPerImageProcessed,subjNumber);

TrialsRemoved=CountTrialsRemovedFinal(Fixations_PerSubject,TrialsRemoved);

%check all subjects have more trials than MinTrials
for ii=1:size(Fixations_PerSubject,2) %suebjcts
    if size(Fixations_PerSubject(ii).trial,2)<Param.MinTrials
        error('Some subjects have less than 10 trials')
    end
end

%% create fixation maps
%For subjects who viewed the image with distance defined as 71 cm, their fixations are created on
%maps the size they viewed the place holder on the screen and then this
%image is resized to the correct size and the fixation location is found
FixMaps=CreateFixationMaps(FixationsPerImageProcessed,Paths,Param);

%% calculate inter observer congruence
%NSS similarity per image
NSSSimilarity=calculateNSSSimilarity(FixMaps,Paths,Param);
%NSS similarity per subject
NSSSimilarity_PerSubj=calculateNSSSimilarityPerSubject(NSSSimilarity,EXPDATA_ALL,subjNumber,Paths);

%% save results
if saveFlag
    if Param.RemoveCenterBias
        save([Paths.ResultsStructsPath,'\','Param_RemoveCenterBias.mat'],'Param')
        save([Paths.ResultsStructsPath,'\','TrialsRemoved_RemoveCenterBias.mat'],'TrialsRemoved')
        save([Paths.ResultsStructsPath,'\','subjNumber_RemoveCenterBias.mat'],'subjNumber')
        save([Paths.ResultsStructsPath,'\','SummarySubjPerImage_RemoveCenterBias.mat'],'SummarySubjPerImage')
        save([Paths.ResultsStructsPath,'\','Results_Memory_RemoveCenterBias.mat'],'Results_Memory')
        save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed_RemoveCenterBias.mat'],'FixationsPerImageProcessed')
        save([Paths.ResultsStructsPath,'\','NSSSimilarity_RemoveCenterBias.mat'],'NSSSimilarity')
        save([Paths.ResultsStructsPath,'\','NSSSimilarity_PerSubj_RemoveCenterBias.mat'],'NSSSimilarity_PerSubj')
    else
        save([Paths.ResultsStructsPath,'\','Param.mat'],'Param')
        save([Paths.ResultsStructsPath,'\','TrialsRemoved.mat'],'TrialsRemoved')
        save([Paths.ResultsStructsPath,'\','subjNumber.mat'],'subjNumber')
        save([Paths.ResultsStructsPath,'\','SummarySubjPerImage.mat'],'SummarySubjPerImage')
        save([Paths.ResultsStructsPath,'\','Results_Memory.mat'],'Results_Memory')
        save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed.mat'],'FixationsPerImageProcessed')
        save([Paths.ResultsStructsPath,'\','NSSSimilarity.mat'],'NSSSimilarity')
        save([Paths.ResultsStructsPath,'\','NSSSimilarity_PerSubj.mat'],'NSSSimilarity_PerSubj')
    end
end