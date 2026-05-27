close all
clear
clc

%% Conditions
saveFlag=1; %1 save, 0 do not save
experiment_number='2'; %'1' or '2'
condition=1; %condition 1 main analysis
%condition 2 preregistration analysis
%condition 3 rttm check
%condition 4 permutation saving trial structure

%Analyses for revision:
%condition 5 conscious trials from unconscious and conscious sessions
%condition 6 right dominant eye participants included
%condition 7 left dominant eye participants included
%condition 8 right dominant eye participants included, both experiments analyzed together
%condition 9 left dominant eye participants included, both experiments analyzed together
%(In condition 8 and 9 trial exclusion is done for each experiment seperatly, meaning that if some image does not have data from both visibility conditions it is excluded,
%eventhough there could be data in the second experiment).
%condition 10 jackknife analysis
%condition 11 downsample number of trials according to the smaller visibility condition for each participant
%condition 12 downsample number of trials according to the smaller visibility condition for each image
%condition 13 free viewing data without a mask
%condition 14 pixel based classification to objects
%condition 15 first fixation analysis
%condition 16 create table for control analysis with mixed effects model
%condition 17 classification to objects based on 50% overlap and above
%condition 18 calculate percent overlap between object classified and circle around fixation
%condition 19 check power of 14 participants with right dominant eye, by sampling randomly 14 participants from this group from both experiments
%condition 20 create data of control (shuffled) trials for analysis done
%only for Experiment 1

%% Parameters
%General parameters
if condition == 8 || condition == 9 || condition == 19
    Param.EXP_NUM='12';
elseif condition == 13
    Param.EXP_NUM='';
else
    Param.EXP_NUM=experiment_number;
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

%classification method in regions and objects analysis
%0- do not use circle only pixel
%1- use circle
%2- use circle and classify to region only if 50% of circle is on region
%3- calculate percent overlap between region classified and circle
if condition == 14
    Param.UseCircleAroundFix=0;
elseif condition == 17
    Param.UseCircleAroundFix=2;
elseif condition == 18
    Param.UseCircleAroundFix=3;
else
    Param.UseCircleAroundFix=1;
end

%Participant choices
if condition == 3
    Param.RemoveSubjectsAwarenessScore=1; %RttM check
else
    Param.RemoveSubjectsAwarenessScore=0; %RttM check
end

if condition == 6 || condition == 8 || condition == 19
    Param.DominantEye='R';
elseif condition == 7 || condition == 9
    Param.DominantEye='L';
else
    Param.DominantEye='Both';
end

%Conduct permutation analysis
if condition == 16 || condition == 18
    Param.shuffledDataFlag=0; %1 yes, 0 no
else
    Param.shuffledDataFlag=1; %1 yes, 0 no
end

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
Param.numFixExcludeDispersion=1;
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
Param.FirstSaccadeLatency=50; %msec
Param.FirstSaccadeLatencyFrames=Param.FirstSaccadeLatency/((1/Param.EyeTrackerFrameRate)*1000);
%Parameters for condition 18
Param.OverlapRule=0.5;
%Parameters for condition 19
Param.NumPartSample=14;
Param.NrepetitionsPower=100;

%% Paths
%data paths
Paths.EyeTrackingAnalysisFolder=cd;
cd ..\..\..\..\
Paths.DataFolder=[pwd,'\Raw Data'];
if condition ~= 8 && condition ~= 9 && condition ~= 13 && condition ~= 19 %When creating the fixation structs
    Paths.ExpMatrixFolder=[Paths.DataFolder,'\Behavioral\Experiment',Param.EXP_NUM];
    Paths.EyeTrackingFolder=[Paths.DataFolder,'\EyeTracker\Extracted files\Experiment',Param.EXP_NUM];
    Paths.AnalyzerResultsFolderDomLeft=[Paths.EyeTrackingFolder,'\DomLeft'];
    Paths.AnalyzerResultsFolderDomRight=[Paths.EyeTrackingFolder,'\DomRight'];
    Paths.PileupFolder=[Paths.DataFolder,'\DataPileups\Experiment',Param.EXP_NUM];
end
Paths.ImagesFolder=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.EyeTrackingAnalysisFolder)

%more paths
cd ..\..\..\..\..\
Paths.RainCloudPlot=[pwd,'\ExpMain\Analysis\AnalysisFolders\Code\RainCloudPlot\RainCloudPlots-master\tutorial_matlab'];
Paths.BehavioralResults=[pwd,'\ExpMain\Analysis\AnalysisCode\ResultsAnalysis\BehavioralAnalysis'];
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
if condition == 1 %fixation maps are saved only for condition 1
    if Param.RemoveCenterBias==1
        Paths.FixationMapsPath=[Paths.FoldersPath,'\ResultsImages\FixationMapsRemoveCenterBias\Experiment',Param.EXP_NUM];
    else
        Paths.FixationMapsPath=[Paths.FoldersPath,'\ResultsImages\FixationMaps\Experiment',Param.EXP_NUM];
    end
end

if condition == 1
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_Final'];
elseif condition == 2
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_PreregistrationCheck'];
elseif condition == 3
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_RttMCheck'];
elseif condition == 4
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_PermutationCheck'];
elseif condition == 5
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_ConsciousTrialsBothSessions'];
elseif condition == 6 || condition == 8
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_RightDominantEye'];
elseif condition == 7 || condition == 9
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_LeftDominantEye'];
elseif condition == 10
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_JackKnife'];
elseif condition == 11
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_DownSampleTrialsParticipantLevel'];
elseif condition == 12
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_DownSampleTrialsImageLevel'];
elseif condition == 13
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\FreeViewingNoMondrians'];
elseif condition == 14
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_ClassificationPixel'];
elseif condition == 15
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_FirstFixation'];
elseif condition == 16
    Paths.ResultsStructsPath=[];
elseif condition == 17
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_StringentOverlapRule'];
elseif condition == 18
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_CountOverlaps'];
elseif condition == 19
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_RightDominantEyePowerCheck'];
elseif condition == 20
    Paths.ResultsStructsPath=[Paths.FoldersPath,'\ResultsStructs\Experiment',Param.EXP_NUM,'_ControlTrials'];
end

%load fixation struct paths
if condition == 8 || condition == 19
    Paths.LoadResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Experiment1_RightDominantEye'];
    Paths.LoadResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Experiment2_RightDominantEye'];
elseif condition == 9
    Paths.LoadResultsStructsPath1=[Paths.FoldersPath,'\ResultsStructs\Experiment1_LeftDominantEye'];
    Paths.LoadResultsStructsPath2=[Paths.FoldersPath,'\ResultsStructs\Experiment2_LeftDominantEye'];
elseif condition == 13
    cd(Paths.EyeTrackingAnalysisFolder)
    cd ..\..\..\..\..\
    Paths.LoadResultsStructsPath1=[pwd,'\ExpNoMondrian\Analysis\AnalysisFolders\ResultsStructs\FreeViewingRemoveCenterBias'];
end

cd(Paths.EyeTrackingAnalysisFolder)

%% check the saving folder exist and is empty
if saveFlag && (condition ~= 16)
    checkDirExistAndEmpty(Paths.ResultsStructsPath)
end

%% Random number generator
sprev=rng(Param.seed);

if condition ~= 8 && condition ~= 9 && condition ~= 13 && condition ~= 19 %create fixation structs
    %% Load data
    %Participant 427, was ran as 407exAA, so his number in EXPDATA is changed.
    %This participant was added after adding trials with blinks (because he has enough trials
    %to be included)
    %Also participants with objective awareness result above chance are added
    %with different numbers than the ones ran in the randomization
    [EXPDATA_ALL,EYETRACKING_ALL,subjNumber]=loadData(Paths,Param);
    summaryAgeGenderAllParticipants=summarizeAgeAndGender(EXPDATA_ALL);
    
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
            if condition == 20
                EXPDATA_ALL{ii,jj}=removeImageTrials(EXPDATA_ALL{ii,jj});
            else
                EXPDATA_ALL{ii,jj}=removeControlTrials(EXPDATA_ALL{ii,jj});
            end
            
            %delete 2 images that were not supposed to be included:
            %image 1131.jpg with federer
            %image 1546.jpg image with strong stripes
            if condition == 2
                EXPDATA_ALL{ii,jj}.TrialsRemoved.SpecificImages=0;
            else
                EXPDATA_ALL{ii,jj}=removeSpecificImages(EXPDATA_ALL{ii,jj});
            end
            
            if condition == 5
                %Image trials: include only PAS 3,4 trials in U condition, and  PAS 3,4 in C condition
                %Also remove trials with no answer in recognition question
                EXPDATA_ALL{ii,jj}=removeTrialsAwarenessMeasuresConsciousConditions(EXPDATA_ALL{ii,jj});
            elseif condition == 20
                %Include all PASs for control trials
                %Also remove trials with no answer in recognition question
                EXPDATA_ALL{ii,jj}=removeTrialsAwarenessMeasuresControlTrials(EXPDATA_ALL{ii,jj});
            else
                %Image trials: include only PAS 1 trials in U condition, and  PAS 3,4 in C condition
                %Also remove trials with no answer in recognition question
                EXPDATA_ALL{ii,jj}=removeTrialsAwarenessMeasures(EXPDATA_ALL{ii,jj});
            end
            
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
    
    %% delete participants due to awareness results (RttM check)
    if Param.RemoveSubjectsAwarenessScore
        [EXPDATA_ALL,subjNumber]=excludeSubjectsAwarenessScore(EXPDATA_ALL,subjNumber,Param);
    end
    
    %% delete participants due to dominant eye recorded
    if any(strcmp(Param.DominantEye,{'R','L'}))
        [EXPDATA_ALL,subjNumber]=excludeSubjectsDominantEye(EXPDATA_ALL,subjNumber,Param);
    end
    
    %% Summarize trials removed (part 1)
    %count how many trials were removed in each condition and
    %summarize the number of trials included in analysis
    TrialsRemoved=CountTrialsRemoved(EXPDATA_ALL);
    
    %% Summarize age and gender in participants included in the analysis
    summaryAgeGender=summarizeAgeAndGender(EXPDATA_ALL);
    
    %% save results
    if saveFlag && (condition ~= 16)
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','summaryAgeGender_RemoveCenterBias.mat'],'summaryAgeGender')
            save([Paths.ResultsStructsPath,'\','Param_RemoveCenterBias.mat'],'Param')
        else
            save([Paths.ResultsStructsPath,'\','summaryAgeGender.mat'],'summaryAgeGender')
            save([Paths.ResultsStructsPath,'\','Param.mat'],'Param')
        end
    end
    
    %% Plot the main sequence of saccades
    plotMainSequence(EXPDATA_ALL,subjNumber)
    
    if condition ~= 20
        %% Organize the fixation matrix
        %create fixation struct: with fixations of all subejcts divided according to images
        FixationsPerImage=arrangeFixationsPerImage(EXPDATA_ALL,Paths);
        
        %preprocess fixations
        %delete images that do not have data from both visibility conditions
        FixationsPerImageProcessed=PreprocessingFixations(FixationsPerImage,subjNumber,Paths,Param);
        
        if condition == 15
            %Include for each trial only the first fixation after 500 msec. If this
            %fixation is excluded this trial is excluded
            FixationsPerImageProcessed=includeOnlyFirstFixation(FixationsPerImageProcessed,Param);
        end
        
        % summarize number of subejcts per image
        SummarySubjPerImage=calcSubjPerImage(FixationsPerImageProcessed);
        
        %% exclude subjects if have too small number of trials, and arrange fixations per subject
        %re-arrange FixationsPerImageProcessed so that fixations are grouped accroding to subejcts (and not images)
        Fixations_PerSubject=arrangeFixationsPerSubject(FixationsPerImageProcessed,subjNumber);
        
        %check all subjects have more trials than MinTrials and exclude
        %subjects if they don't
        [Fixations_PerSubject,subjNumber,FixationsPerImageProcessed]=excludeSubjectsLowNumTrials(Fixations_PerSubject,subjNumber,FixationsPerImageProcessed,Param);
        
        %count number of trials removed (part 2)
        TrialsRemoved=CountTrialsRemovedFinal(Fixations_PerSubject,TrialsRemoved);
        
        %count number of trials with blnks included in the analysis
        TrialsWithBlinks=CountTrialsWithBlinks(Fixations_PerSubject,TrialsRemoved,Param);
        
        %% downsample number of trials
        if condition == 11
            %downsample number of trials according to the smaller visibility
            %condition for each participant (this creates sometimes an unequal
            %number of trials in both visibility conditions explanation in the
            %function)
            [FixationsPerImageProcessed,Fixations_PerSubject]=downSamplePariticpantLevel(FixationsPerImageProcessed,Fixations_PerSubject,Param);
        end
        
        if condition == 12
            %downsample number of trials according to the smaller visibility
            %condition for each image
            [FixationsPerImageProcessed,Fixations_PerSubject]=downSampleImageLevel(FixationsPerImageProcessed,Fixations_PerSubject,Param);
        end
    else
        Fixations_PerSubjectControl=arrangeControlFixationsPerSubject(EXPDATA_ALL,subjNumber,Paths,Param);
        
        %exclude subjects with low number of trials
        indSubjdel=[];
        for ii=1:size(Fixations_PerSubjectControl,2) %images
            if length(Fixations_PerSubjectControl(ii).condition(1).trial)<Param.MinTrials | length(Fixations_PerSubjectControl(ii).condition(2).trial)<Param.MinTrials
                indSubjdel=[indSubjdel,ii]; %ind to delete in fixations_PerSubject and subjNumber
            end
        end
        
        %exclude subejcts
        if ~isempty(indSubjdel)
            disp('Some subjects have less than 10 control unconscious trials or conscious trials')
            
            %exclude subejcts from fixations_PerSubject subjNumber
            Fixations_PerSubjectControl(indSubjdel)=[];
            subjNumber(indSubjdel)=[];
        end
        
        %% save results
        if saveFlag
            if Param.RemoveCenterBias
                save([Paths.ResultsStructsPath,'\','Fixations_PerSubjectControl_RemoveCenterBias.mat'],'Fixations_PerSubjectControl')
            else
                save([Paths.ResultsStructsPath,'\','Fixations_PerSubjectControl.mat'],'Fixations_PerSubjectControl')
            end
        end
        
        %% return random number generator to default
        rng(sprev);
        return
    end
    
    %% save results
    if saveFlag && (condition ~= 16) && (condition ~= 20)
        if Param.RemoveCenterBias
            save([Paths.ResultsStructsPath,'\','SummarySubjPerImage_RemoveCenterBias.mat'],'SummarySubjPerImage')
            save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed_RemoveCenterBias.mat'],'FixationsPerImageProcessed','-v7.3')
            save([Paths.ResultsStructsPath,'\','Fixations_PerSubject_RemoveCenterBias.mat'],'Fixations_PerSubject')
            save([Paths.ResultsStructsPath,'\','TrialsRemoved_RemoveCenterBias.mat'],'TrialsRemoved')
            save([Paths.ResultsStructsPath,'\','TrialsWithBlinks_RemoveCenterBias.mat'],'TrialsWithBlinks')
        else
            save([Paths.ResultsStructsPath,'\','SummarySubjPerImage.mat'],'SummarySubjPerImage')
            save([Paths.ResultsStructsPath,'\','FixationsPerImageProcessed.mat'],'FixationsPerImageProcessed','-v7.3')
            save([Paths.ResultsStructsPath,'\','Fixations_PerSubject.mat'],'Fixations_PerSubject')
            save([Paths.ResultsStructsPath,'\','TrialsRemoved.mat'],'TrialsRemoved')
            save([Paths.ResultsStructsPath,'\','TrialsWithBlinks.mat'],'TrialsWithBlinks')
        end
    end
elseif condition == 8 || condition == 9 || condition == 19 %load fixation structs of both experiments and merge them
    
    % load FixationsPerImageProcessed
    load([Paths.LoadResultsStructsPath1,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations1=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed
    
    load([Paths.LoadResultsStructsPath2,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])
    fixations2=FixationsPerImageProcessed;
    clear FixationsPerImageProcessed
    
    FixationsPerImageProcessed=mergeFixationsBothExperiments(fixations1,fixations2);
    clear fixations1 fixations2
    
    % load Fixations_PerSubject
    load([Paths.LoadResultsStructsPath1,'\Fixations_PerSubject_RemoveCenterBias.mat']);
    Fixations_PerSubject1=Fixations_PerSubject;
    clear Fixations_PerSubject
    
    load([Paths.LoadResultsStructsPath2,'\Fixations_PerSubject_RemoveCenterBias.mat']);
    Fixations_PerSubject2=Fixations_PerSubject;
    clear Fixations_PerSubject
    
    Fixations_PerSubject=[Fixations_PerSubject1,Fixations_PerSubject2];
    clear Fixations_PerSubject1 Fixations_PerSubject2
    
    %check fixations per subject
    for ii=1:size(Fixations_PerSubject,2) %images
        if length(Fixations_PerSubject(ii).condition(1).trial)<Param.MinTrials | length(Fixations_PerSubject(ii).condition(2).trial)<Param.MinTrials
            disp('Some subjects have less than 10 image unconscious trials or conscious trials')
        end
    end
    
    % create subjNumber
    subjNumber=[Fixations_PerSubject.subjNum];
    
    % add data to Param
    load([Paths.DataFolder,'\Behavioral\Experiment1\expdata_U_401.mat'])
    Param.window_size_pixels=[EXPDATA.info.lab_setup.screen_width_in_pixels,EXPDATA.info.lab_setup.screen_height_in_pixels];
    Param.subject_distance_from_screen_in_cm=EXPDATA.info.lab_setup.subject_distance_from_screen_in_cm;
    
elseif condition == 13
    [FixationsPerImageProcessed,Fixations_PerSubject,subjNumber]=loadDataFreeViewing(Paths,Param);
    
    % add data to Param
    load([Paths.DataFolder,'\Behavioral\Experiment1\expdata_U_401.mat'])
    Param.window_size_pixels=[EXPDATA.info.lab_setup.screen_width_in_pixels,EXPDATA.info.lab_setup.screen_height_in_pixels];
    Param.subject_distance_from_screen_in_cm=EXPDATA.info.lab_setup.subject_distance_from_screen_in_cm;
    
    % save results
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
    if condition == 4
        FixationsPerImageProcessed=shuffleFixationsSaveTrialPermutationAnalysis(FixationsPerImageProcessed,Fixations_PerSubject,subjNumber,Param.Nrepetitions);
    else
        FixationsPerImageProcessed=shuffleFixationsPermutationAnalysis(FixationsPerImageProcessed,subjNumber,Param.Nrepetitions);
    end
end

if condition ~= 14 && condition ~= 17 && condition ~= 18
    %% Region classification
    %classify fixations to regions and calculate measures (fixperpix, fixdurperpix)
    %in each of the regions. For real data and base line data.
    RegionsResults=classifyFixationsRegions(FixationsPerImageProcessed,Paths,Param);
    if Param.shuffledDataFlag
        RegionsSummary=calculationsRegions(RegionsResults);
        if condition ~= 13
            plotRegionsResults(RegionsSummary);
        end
    end
    
    %jackknife analysis regions
    if condition == 10
        for ii=1:length(subjNumber)
            RegionsjackknifeResults=jackknifeRegions(RegionsResults,FixationsPerImageProcessed,subjNumber(ii));
            RegionsjackknifeSummary=calculationsRegions(RegionsjackknifeResults);
            
            %Save data for jackknife analysis
            %jackknife replicates
            jackKnifeRegions.FixPerPix_jackknifeRepU(ii,:)=RegionsjackknifeSummary.condition(1).FixPerPix;
            jackKnifeRegions.FixPerPix_jackknifeRepC(ii,:)=RegionsjackknifeSummary.condition(2).FixPerPix;
            jackKnifeRegions.FixDurPerPix_jackknifeRepU(ii,:)=RegionsjackknifeSummary.condition(1).FixDurPerPix;
            jackKnifeRegions.FixDurPerPix_jackknifeRepC(ii,:)=RegionsjackknifeSummary.condition(2).FixDurPerPix;
            
            %Jacknife p-values
            jackKnifeRegions.FixPerPix_jackknifePvalU(ii,:)=RegionsjackknifeSummary.condition(1).pvalFPP;
            jackKnifeRegions.FixPerPix_jackknifePvalC(ii,:)=RegionsjackknifeSummary.condition(2).pvalFPP;
            jackKnifeRegions.FixDurPerPix_jackknifePvalU(ii,:)=RegionsjackknifeSummary.condition(1).pvalFDPP;
            jackKnifeRegions.FixDurPerPix_jackknifePvalC(ii,:)=RegionsjackknifeSummary.condition(2).pvalFDPP;
            
            %jacknife effect-sizes
            jackKnifeRegions.FixPerPix_jackknifeEffectSizeU(ii,:)=RegionsjackknifeSummary.condition(1).effectSizeFPP;
            jackKnifeRegions.FixPerPix_jackknifeEffectSizeC(ii,:)=RegionsjackknifeSummary.condition(2).effectSizeFPP;
            jackKnifeRegions.FixDurPerPix_jackknifeEffectSizeU(ii,:)=RegionsjackknifeSummary.condition(1).effectSizeFDPP;
            jackKnifeRegions.FixDurPerPix_jackknifeEffectSizeC(ii,:)=RegionsjackknifeSummary.condition(2).effectSizeFDPP;
            
            clear RegionsjackknifeResults RegionsjackknifeSummary
        end
        jackKnifeRegions=jackknifeCalculationsRegions(jackKnifeRegions,RegionsSummary);
    end
    
    %Power check for 14 participants with right dominant eye
    if condition == 19
        for nn=1:Param.NrepetitionsPower
            RegionsPowerResults=powerAnalysisRegions(RegionsResults,FixationsPerImageProcessed,subjNumber,Param);
            RegionsPowerSummary=calculationsRegions(RegionsPowerResults);
            
            %Save data for power analysis
            %replicates
            PowerRegions.FixPerPix_RepU(nn,:)=RegionsPowerSummary.condition(1).FixPerPix;
            PowerRegions.FixPerPix_RepC(nn,:)=RegionsPowerSummary.condition(2).FixPerPix;
            PowerRegions.FixDurPerPix_RepU(nn,:)=RegionsPowerSummary.condition(1).FixDurPerPix;
            PowerRegions.FixDurPerPix_RepC(nn,:)=RegionsPowerSummary.condition(2).FixDurPerPix;
            
            %p-values
            PowerRegions.FixPerPix_PvalU(nn,:)=RegionsPowerSummary.condition(1).pvalFPP;
            PowerRegions.FixPerPix_PvalC(nn,:)=RegionsPowerSummary.condition(2).pvalFPP;
            PowerRegions.FixDurPerPix_PvalU(nn,:)=RegionsPowerSummary.condition(1).pvalFDPP;
            PowerRegions.FixDurPerPix_PvalC(nn,:)=RegionsPowerSummary.condition(2).pvalFDPP;
            
            %effect-sizes
            PowerRegions.FixPerPix_EffectSizeU(nn,:)=RegionsPowerSummary.condition(1).effectSizeFPP;
            PowerRegions.FixPerPix_EffectSizeC(nn,:)=RegionsPowerSummary.condition(2).effectSizeFPP;
            PowerRegions.FixDurPerPix_EffectSizeU(nn,:)=RegionsPowerSummary.condition(1).effectSizeFDPP;
            PowerRegions.FixDurPerPix_EffectSizeC(nn,:)=RegionsPowerSummary.condition(2).effectSizeFDPP;
            
            clear RegionsPowerResults RegionsPowerSummary
        end
        PowerRegions=powerCalculationsRegions(PowerRegions);
    end
    
    % Region classification per subject
    %caclculate for each subject fixperpix and fixdurperpix for each region
    [RegionsSummary_PerSubj,RegionsResults_PerSubj]=calculationsRegionsPerSubject(RegionsResults,FixationsPerImageProcessed,subjNumber);
    
    %% save results
    if saveFlag && (condition ~= 16)
        if Param.RemoveCenterBias
            if Param.shuffledDataFlag
                save([Paths.ResultsStructsPath,'\','RegionsSummary_RemoveCenterBias.mat'],'RegionsSummary')
            end
            %save([Paths.ResultsStructsPath,'\','RegionsResults_RemoveCenterBias.mat'],'RegionsResults','-v7.3')
            save([Paths.ResultsStructsPath,'\','RegionsSummary_PerSubj_RemoveCenterBias.mat'],'RegionsSummary_PerSubj')
            save([Paths.ResultsStructsPath,'\','RegionsResults_PerSubj_RemoveCenterBias.mat'],'RegionsResults_PerSubj')
            if condition == 10
                save([Paths.ResultsStructsPath,'\','jackKnifeRegions_RemoveCenterBias.mat'],'jackKnifeRegions')
            end
            if condition == 19
                save([Paths.ResultsStructsPath,'\','PowerRegions_RemoveCenterBias.mat'],'PowerRegions')
            end
        else
            if Param.shuffledDataFlag
                save([Paths.ResultsStructsPath,'\','RegionsSummary.mat'],'RegionsSummary')
            end
            %save([Paths.ResultsStructsPath,'\','RegionsResults.mat'],'RegionsResults','-v7.3')
            save([Paths.ResultsStructsPath,'\','RegionsSummary_PerSubj.mat'],'RegionsSummary_PerSubj')
            save([Paths.ResultsStructsPath,'\','RegionsResults_PerSubj.mat'],'RegionsResults_PerSubj')
            if condition == 10
                save([Paths.ResultsStructsPath,'\','jackKnifeRegions.mat'],'jackKnifeRegions')
            end
            if condition == 19
                save([Paths.ResultsStructsPath,'\','powerRegions.mat'],'powerRegions')
            end
        end
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
    [ObjectsResults,ObjectsSummary]=calculationsObjects(ObjectsResults,Param,condition);
end

%jackknife analysis objects
if condition == 10
    for ii=1:length(subjNumber)
        ObjectsjackknifeResults=jackknifeObjects(ObjectsResults,Param,subjNumber(ii));
        ObjectsjackknifeSummary=calculationsObjects(ObjectsjackknifeResults,Param,condition);
        
        %Save data for jackknife analysis
        %jackknife replicates
        jackKnifeObjects.FixPerPix_jackknifeRepObj(ii,:)=ObjectsjackknifeSummary.FixPerPixObj;
        jackKnifeObjects.FixPerPix_jackknifeRepBg(ii,:)=ObjectsjackknifeSummary.FixPerPixBg;
        jackKnifeObjects.FixDurPerPix_jackknifeRepObj(ii,:)=ObjectsjackknifeSummary.FixDurPerPixObj;
        jackKnifeObjects.FixDurPerPix_jackknifeRepBg(ii,:)=ObjectsjackknifeSummary.FixDurPerPixBg;
        
        %Jacknife p-values
        jackKnifeObjects.FixPerPix_jackknifePvalObj(ii,:)=ObjectsjackknifeSummary.pvalFPPObj;
        jackKnifeObjects.FixPerPix_jackknifePvalBg(ii,:)=ObjectsjackknifeSummary.pvalFPPBg;
        jackKnifeObjects.FixDurPerPix_jackknifePvalObj(ii,:)=ObjectsjackknifeSummary.pvalFDPPObj;
        jackKnifeObjects.FixDurPerPix_jackknifePvalBg(ii,:)=ObjectsjackknifeSummary.pvalFDPPBg;
        
        %jacknife effect-sizes
        jackKnifeObjects.FixPerPix_jackknifeEffectSizeObj(ii,:)=ObjectsjackknifeSummary.effectSizeFPPObj;
        jackKnifeObjects.FixPerPix_jackknifeEffectSizeBg(ii,:)=ObjectsjackknifeSummary.effectSizeFPPBg;
        jackKnifeObjects.FixDurPerPix_jackknifeEffectSizeObj(ii,:)=ObjectsjackknifeSummary.effectSizeFDPPObj;
        jackKnifeObjects.FixDurPerPix_jackknifeEffectSizeBg(ii,:)=ObjectsjackknifeSummary.effectSizeFDPPBg;
        
        clear ObjectsjackknifeResults ObjectsjackknifeSummary
    end
    jackKnifeObjects=jackknifeCalculationsObjects(jackKnifeObjects,ObjectsSummary);
end

%Power check for 14 participants with right dominant eye
if condition == 19
    for nn=1:Param.NrepetitionsPower
        ObjectsPowerResults=powerAnalysisObjects(ObjectsResults,Param,subjNumber);
        ObjectsPowerSummary=calculationsObjects(ObjectsPowerResults,Param,condition);
        
        %Save data for jackknife analysis
        %jackknife replicates
        powerObjects.FixPerPix_RepObj(nn,:)=ObjectsPowerSummary.FixPerPixObj;
        powerObjects.FixPerPix_RepBg(nn,:)=ObjectsPowerSummary.FixPerPixBg;
        powerObjects.FixDurPerPix_RepObj(nn,:)=ObjectsPowerSummary.FixDurPerPixObj;
        powerObjects.FixDurPerPix_RepBg(nn,:)=ObjectsPowerSummary.FixDurPerPixBg;
        
        %Jacknife p-values
        powerObjects.FixPerPix_PvalObj(nn,:)=ObjectsPowerSummary.pvalFPPObj;
        powerObjects.FixPerPix_PvalBg(nn,:)=ObjectsPowerSummary.pvalFPPBg;
        powerObjects.FixDurPerPix_PvalObj(nn,:)=ObjectsPowerSummary.pvalFDPPObj;
        powerObjects.FixDurPerPix_PvalBg(nn,:)=ObjectsPowerSummary.pvalFDPPBg;
        
        %jacknife effect-sizes
        powerObjects.FixPerPix_EffectSizeObj(nn,:)=ObjectsPowerSummary.effectSizeFPPObj;
        powerObjects.FixPerPix_EffectSizeBg(nn,:)=ObjectsPowerSummary.effectSizeFPPBg;
        powerObjects.FixDurPerPix_EffectSizeObj(nn,:)=ObjectsPowerSummary.effectSizeFDPPObj;
        powerObjects.FixDurPerPix_EffectSizeBg(nn,:)=ObjectsPowerSummary.effectSizeFDPPBg;
        
        clear ObjectsPowerResults ObjectsPowerSummary
    end
    powerObjects=powerCalculationsObjects(powerObjects);
end

% classify fixations to atributes
AttributesResults=classifyFixationsAttributes(ObjectsResults,FixationsPerImageProcessed,Param,attrs,attrNames);
if Param.shuffledDataFlag
    [AttributesResults,AttributesSummary]=calculationsAttributes(AttributesResults,Param,attrNames,condition);
end

%jackknife analysis attributes
if condition == 10
    for ii=1:length(subjNumber)
        AttributesjackknifeResults=jackknifeAttributes(AttributesResults,subjNumber(ii));
        AttributesjackknifeSummary=calculationsAttributes(AttributesjackknifeResults,Param,attrNames,condition);
        
        %Save data for jackknife analysis
        %jackknife replicates
        jackKnifeAttributes.FixPerPix_jackknifeRepAttU(ii,:)=AttributesjackknifeSummary.FixPerPixAtt(1,:);
        jackKnifeAttributes.FixPerPix_jackknifeRepAttC(ii,:)=AttributesjackknifeSummary.FixPerPixAtt(2,:);
        jackKnifeAttributes.FixDurPerPix_jackknifeRepAttU(ii,:)=AttributesjackknifeSummary.FixDurPerPixAtt(1,:);
        jackKnifeAttributes.FixDurPerPix_jackknifeRepAttC(ii,:)=AttributesjackknifeSummary.FixDurPerPixAtt(2,:);
        
        %Jacknife p-values
        jackKnifeAttributes.FixPerPix_jackknifePvalAttU(ii,:)=AttributesjackknifeSummary.pvalFPPAtt(1,:);
        jackKnifeAttributes.FixPerPix_jackknifePvalAttC(ii,:)=AttributesjackknifeSummary.pvalFPPAtt(2,:);
        jackKnifeAttributes.FixDurPerPix_jackknifePvalAttU(ii,:)=AttributesjackknifeSummary.pvalFDPPAtt(1,:);
        jackKnifeAttributes.FixDurPerPix_jackknifePvalAttC(ii,:)=AttributesjackknifeSummary.pvalFDPPAtt(2,:);
        
        %jacknife effect-sizes
        jackKnifeAttributes.FixPerPix_jackknifeEffectSizeAttU(ii,:)=AttributesjackknifeSummary.effectSizeFPPAtt(1,:);
        jackKnifeAttributes.FixPerPix_jackknifeEffectSizeAttC(ii,:)=AttributesjackknifeSummary.effectSizeFPPAtt(2,:);
        jackKnifeAttributes.FixDurPerPix_jackknifeEffectSizeAttU(ii,:)=AttributesjackknifeSummary.effectSizeFDPPAtt(1,:);
        jackKnifeAttributes.FixDurPerPix_jackknifeEffectSizeAttC(ii,:)=AttributesjackknifeSummary.effectSizeFDPPAtt(2,:);
        
        clear AttributesjackknifeResults AttributesjackknifeSummary
    end
    jackKnifeAttributes=jackknifeCalculationsAttributes(jackKnifeAttributes,AttributesSummary);
end

%Power check for 14 participants with right dominant eye
if condition == 19
    for nn=1:Param.NrepetitionsPower
        AttributesPowerResults=powerAnalysisAttributes(AttributesResults,subjNumber,Param);
        AttributesPowerSummary=calculationsAttributes(AttributesPowerResults,Param,attrNames,condition);
        
        %Save data for jackknife analysis
        %jackknife replicates
        powerAttributes.FixPerPix_RepAttU(nn,:)=AttributesPowerSummary.FixPerPixAtt(1,:);
        powerAttributes.FixPerPix_RepAttC(nn,:)=AttributesPowerSummary.FixPerPixAtt(2,:);
        powerAttributes.FixDurPerPix_RepAttU(nn,:)=AttributesPowerSummary.FixDurPerPixAtt(1,:);
        powerAttributes.FixDurPerPix_RepAttC(nn,:)=AttributesPowerSummary.FixDurPerPixAtt(2,:);
        
        %Jacknife p-values
        powerAttributes.FixPerPix_PvalAttU(nn,:)=AttributesPowerSummary.pvalFPPAtt(1,:);
        powerAttributes.FixPerPix_PvalAttC(nn,:)=AttributesPowerSummary.pvalFPPAtt(2,:);
        powerAttributes.FixDurPerPix_PvalAttU(nn,:)=AttributesPowerSummary.pvalFDPPAtt(1,:);
        powerAttributes.FixDurPerPix_PvalAttC(nn,:)=AttributesPowerSummary.pvalFDPPAtt(2,:);
        
        %jacknife effect-sizes
        powerAttributes.FixPerPix_EffectSizeAttU(nn,:)=AttributesPowerSummary.effectSizeFPPAtt(1,:);
        powerAttributes.FixPerPix_EffectSizeAttC(nn,:)=AttributesPowerSummary.effectSizeFPPAtt(2,:);
        powerAttributes.FixDurPerPix_EffectSizeAttU(nn,:)=AttributesPowerSummary.effectSizeFDPPAtt(1,:);
        powerAttributes.FixDurPerPix_EffectSizeAttC(nn,:)=AttributesPowerSummary.effectSizeFDPPAtt(2,:);
        
        clear AttributesPowerResults AttributesPowerSummary
    end
    powerAttributes=powerCalculationsAttributes(powerAttributes);
end

% Object classification per subject
[ObjectsSummary_PerSubj,ObjectsResults_PerSubj]=calculationsObjectsPerSubject(ObjectsResults,FixationsPerImageProcessed,subjNumber,Param);

%% create tables for mixed models
if condition == 16
    createTableForMixedModel(Fixations_PerSubject,ObjectsResults_PerSubj,attrs,saveFlag,Param)
end

%% Save results
if saveFlag && (condition ~= 16)
    if Param.RemoveCenterBias
        %save([Paths.ResultsStructsPath,'\','ObjectsResults_RemoveCenterBias.mat'],'ObjectsResults','-v7.3')
        %save([Paths.ResultsStructsPath,'\','AttributesResults_RemoveCenterBias.mat'],'AttributesResults','-v7.3')
        if Param.shuffledDataFlag
            save([Paths.ResultsStructsPath,'\','ObjectsSummary_RemoveCenterBias.mat'],'ObjectsSummary')
            save([Paths.ResultsStructsPath,'\','AttributesSummary_RemoveCenterBias.mat'],'AttributesSummary')
        end
        save([Paths.ResultsStructsPath,'\','ObjectsSummary_PerSubj_RemoveCenterBias.mat'],'ObjectsSummary_PerSubj')
        save([Paths.ResultsStructsPath,'\','ObjectsResults_PerSubj_RemoveCenterBias.mat'],'ObjectsResults_PerSubj')
        if condition == 10
            save([Paths.ResultsStructsPath,'\','jackKnifeObjects_RemoveCenterBias.mat'],'jackKnifeObjects')
            save([Paths.ResultsStructsPath,'\','jackKnifeAttributes_RemoveCenterBias.mat'],'jackKnifeAttributes')
        end
        if condition == 19
            save([Paths.ResultsStructsPath,'\','powerObjects_RemoveCenterBias.mat'],'powerObjects')
            save([Paths.ResultsStructsPath,'\','powerAttributes_RemoveCenterBias.mat'],'powerAttributes')
        end
    else
        %save([Paths.ResultsStructsPath,'\','ObjectsResults.mat'],'ObjectsResults','-v7.3')
        %save([Paths.ResultsStructsPath,'\','AttributesResults.mat'],'AttributesResults','-v7.3')
        if Param.shuffledDataFlag
            save([Paths.ResultsStructsPath,'\','ObjectsSummary.mat'],'ObjectsSummary')
            save([Paths.ResultsStructsPath,'\','AttributesSummary.mat'],'AttributesSummary')
        end
        save([Paths.ResultsStructsPath,'\','ObjectsSummary_PerSubj.mat'],'ObjectsSummary_PerSubj')
        save([Paths.ResultsStructsPath,'\','ObjectsResults_PerSubj.mat'],'ObjectsResults_PerSubj')
        if condition == 10
            save([Paths.ResultsStructsPath,'\','jackKnifeObjects.mat'],'jackKnifeObjects')
            save([Paths.ResultsStructsPath,'\','jackKnifeAttributes.mat'],'jackKnifeAttributes')
        end
        if condition == 19
            save([Paths.ResultsStructsPath,'\','powerObjects.mat'],'powerObjects')
            save([Paths.ResultsStructsPath,'\','powerAttributes.mat'],'powerAttributes')
        end
    end
end

if condition == 1 %create fixation maps only for the main analysis
    %% create fixation maps
    FixMaps=CreateFixationMaps(FixationsPerImageProcessed,Paths,Param,saveFlag);
    
    switch Param.EXP_NUM
        case '1'
            %% calculate inter observer congruence and dispersion for the C and UC conditions
            %NSS similarity per image
            NSSSimilarity=calculateNSSSimilarity(FixationsPerImageProcessed,FixMaps,Paths,Param);
            %Dispersion per image
            DispersionResults=CalcFixationDispersion(FixationsPerImageProcessed,Paths,Param.numFixExcludeDispersion);
            
            %NSS similarity per subject
            NSSSimilarity_PerSubj=calculateNSSSimilarityPerSubject(NSSSimilarity,subjNumber);
            %Dispersion per subect
            DispersionResults_PerSubj=CalcFixationDispersionPerSubj(DispersionResults,FixationsPerImageProcessed,subjNumber);
            
            %% save results
            if saveFlag
                if Param.RemoveCenterBias
                    save([Paths.ResultsStructsPath,'\','NSSSimilarity_RemoveCenterBias.mat'],'NSSSimilarity')
                    save([Paths.ResultsStructsPath,'\','NSSSimilarity_PerSubj_RemoveCenterBias.mat'],'NSSSimilarity_PerSubj')
                    save([Paths.ResultsStructsPath,'\','DispersionResults_RemoveCenterBias.mat'],'DispersionResults')
                    save([Paths.ResultsStructsPath,'\','DispersionResults_PerSubj_RemoveCenterBias.mat'],'DispersionResults_PerSubj')
                else
                    save([Paths.ResultsStructsPath,'\','NSSSimilarity.mat'],'NSSSimilarity')
                    save([Paths.ResultsStructsPath,'\','NSSSimilarity_PerSubj.mat'],'NSSSimilarity_PerSubj')
                    save([Paths.ResultsStructsPath,'\','DispersionResults.mat'],'DispersionResults')
                    save([Paths.ResultsStructsPath,'\','DispersionResults_PerSubj.mat'],'DispersionResults_PerSubj')
                end
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