close all
clear 
clc

%Parameters
imsize=[339,452];
condition=2; %1 main analysis, takes objects from combined dataset
%2 preregistration check, takes objects only from OSIE dataset

%Paths
Paths.ImageAnalysisFolder=cd;
cd ..\..\..\
Paths.ImagesPath=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.ImageAnalysisFolder)

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\Analysis\AnalysisFolders'];
if condition == 1
    Paths.HighLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\HighLevelMaps'];
elseif condition == 2
    Paths.HighLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\HighLevelMapsPreregControl'];
end
Paths.OSIEObjects=[pwd,'\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis'];
cd(Paths.ImageAnalysisFolder)

%more paths
cd ..\..\..\..\
if condition == 1
    Paths.FixationMapsPathNoMondrians=[pwd,'\Exp2\Analysis\AnalysisFolders\ResultsImages\FixationMaps'];
elseif condition == 2
    Paths.FixationMapsPathNoMondrians=[pwd,'\Exp2\Analysis\AnalysisFolders\ResultsImages\FixationMapsNoBlinks'];
end
cd(Paths.ImageAnalysisFolder)

%create high level maps
createHighLevelMaps(Paths,imsize,condition)