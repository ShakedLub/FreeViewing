close all
clear 
clc

%Parameters
imsize=[339,452];

%Paths
Paths.ImageAnalysisFolder=cd;
cd ..\..\..\
Paths.ImagesPath=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.ImageAnalysisFolder)

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\Analysis\AnalysisFolders'];
Paths.HighLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\HighLevelMaps'];
Paths.OSIEObjects=[pwd,'\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis'];
cd(Paths.ImageAnalysisFolder)

%more paths
cd ..\..\..\..\
Paths.FixationMapsPathNoMondrians=[pwd,'\Exp2\Analysis\AnalysisFolders\ResultsImages\FixationMaps'];
cd(Paths.ImageAnalysisFolder)

%create high level maps
createHighLevelMaps(Paths,imsize)