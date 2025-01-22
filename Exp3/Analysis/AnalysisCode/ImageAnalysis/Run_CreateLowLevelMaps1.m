%%%%% Create Itti and Koch's salliency maps based on saliencytoolbox
close all
clear 
clc

%Paths
Paths.ImageAnalysisFolder=cd;
cd ..\..\..\
Paths.ImagesPath=[pwd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(Paths.ImageAnalysisFolder)

cd ..\..\..\..\
Paths.IttiKochModelPath=[pwd,'\Exp3\Analysis\AnalysisFolders\Code\Itti&Koch_WalthersSaliencyToolbox_L\SaliencyToolbox'];
cd(Paths.ImageAnalysisFolder)

%results paths
cd ..\..\..\
Paths.FoldersPath=[pwd,'\Analysis\AnalysisFolders'];
Paths.SaliencyMapsPath=[Paths.FoldersPath,'\ResultsImages\SaliencyMaps'];
cd(Paths.ImageAnalysisFolder)

%create Itti and Koch saliency maps
createIttiAndKochSalMaps(Paths)