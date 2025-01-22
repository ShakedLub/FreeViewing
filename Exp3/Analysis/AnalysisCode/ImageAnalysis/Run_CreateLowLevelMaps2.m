close all
clear 
clc

%Param
Param.SmilerModels = {'IKN'}; %{'GBVS', 'DVA','IKN'}; % a cell array of the SMILER model codes which we wish to execute
Param.imsize=[339,452];

%Paths
Paths.ImageAnalysisFolder=cd;
cd ..\..\..\
Paths.ImagesPath=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.ImageAnalysisFolder)

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\Analysis\AnalysisFolders'];
Paths.LowLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\LowLevelMaps'];
Paths.SaliencyMapsPath=[Paths.FoldersPath,'\ResultsImages\SaliencyMaps'];
Paths.HighLevelMapsPath=[Paths.FoldersPath,'\ResultsImages\HighLevelMaps'];
cd(Paths.ImageAnalysisFolder)

cd ..\..\..\..\
Paths.FixationMapsPathNoMondrians=[pwd,'\Exp2\Analysis\AnalysisFolders\ResultsImages\FixationMaps'];
Paths.SmilerPath=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\Smiler\SMILER-master\smiler_matlab_tools'];
cd(Paths.ImageAnalysisFolder)

%create smiler saliency maps
createSmilerSalMaps(Param.SmilerModels,Paths)

%create low level maps that are the IKN maps with histogrm matching to the
%none mondrian fixation maps
createLowLevelMaps(Paths,Param.imsize)