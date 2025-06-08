clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save
imageNum=[122 214 108];

%% paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
path1=[dataPath,'\Pilot1_Final'];
path2=[dataPath,'\Pilot2_Final'];

analysisCodePath=[pwd,'\AnalysisCode'];
eyeTrackingAnalysisPath=[analysisCodePath,'\ResultsAnalysis\EyeTrackingAnalysis'];

Paths.FixationMap1=[foldersPath,'\ResultsImages\FixationMapsRemoveCenterBias\pilot1'];
Paths.FixationMap2=[foldersPath,'\ResultsImages\FixationMapsRemoveCenterBias\pilot2'];
cd(codePath)

cd ..\..\..\..\..\
Paths.ImagesFolder=[cd,'\Experiment\RUN_ME\Stimuli\ImageTrials_Experiment'];
cd(codePath)

%% load data
load([path1,'\','FixationsPerImageProcessed_RemoveCenterBias.mat']);
fixations1=FixationsPerImageProcessed;
clear FixationsPerImageProcessed

load([path2,'\','FixationsPerImageProcessed_RemoveCenterBias.mat']);
fixations2=FixationsPerImageProcessed;
clear FixationsPerImageProcessed

load([path1,'\','ObjectsResults_NoShuffling_RemoveCenterBias.mat']);
ObjectsResults1=ObjectsResults;
clear ObjectsResults

load([path2,'\','ObjectsResults_NoShuffling_RemoveCenterBias.mat']);
ObjectsResults2=ObjectsResults;
clear ObjectsResults

cd(eyeTrackingAnalysisPath);
load('AttrsCombined.mat')
cd(codePath)

load([path1,'\','Param_RemoveCenterBias.mat']);
Param1=Param;
clear Param

load([path2,'\','Param_RemoveCenterBias.mat']);
Param2=Param;
clear Param

%% check data
if ~isequal({fixations1.img},{ObjectsResults1.image.imageName})
    error('fixations data and object classification data for experiment 1 are not on the same images')
end
if ~isequal({fixations2.img},{ObjectsResults2.image.imageName})
    error('fixations data and object classification data for experiment 2 are not on the same images')
end
if ~isequal({fixations1.img},{fixations2.img})
    error('fixations data for experiment 1 and 2 are not on the same images')
end
if ~isequal({ObjectsResults1.image.imageName},{ObjectsResults2.image.imageName})
    error('object classification data for experiment 1 and 2 are not on the same images')
end

%% Plots
%% Fixations classification
conditions=1:4; 
%1: U exp 1
%2: U exp 2
%3: C exp 1
%4: C exp 2

rows=length(imageNum);
columns=length(conditions);

figure('units','normalized','outerposition',[0 0 1 1])
for ii=1:length(imageNum) %images
    clear eyeData classification
    numPlots=((ii-1)*columns+1):((ii-1)*columns+4);
    
    %Plot fixation classification
    imageName=fixations1(imageNum(ii)).img;
    %check this is also the same image in exp 2
    if ~isequal(imageName,fixations2(imageNum(ii)).img)
        error('Problem with image numbers in two experiments')
    end
    
    %U exp 1
    eyeData{1}=fixations1(imageNum(ii)).condition(1).subject;
    classification{1}=ObjectsResults1.image(imageNum(ii)).condition(1).subject;
    %U exp 2
    eyeData{2}=fixations2(imageNum(ii)).condition(1).subject;
    classification{2}=ObjectsResults2.image(imageNum(ii)).condition(1).subject;
    %C exp 1
    eyeData{3}=fixations1(imageNum(ii)).condition(2).subject;
    classification{3}=ObjectsResults1.image(imageNum(ii)).condition(2).subject;
    %C exp 2
    eyeData{4}=fixations2(imageNum(ii)).condition(2).subject;
    classification{4}=ObjectsResults2.image(imageNum(ii)).condition(2).subject;

    plotFixationObjectClassification(imageName,numPlots,rows,columns,eyeData,classification,Param1,Param2,attrs,Paths);   
end

if saveFlag
    saveas(gcf,'FixationClassificationObjects.jpg', 'jpg')
end

%% Fixations maps
% %Plot fixation maps
% figure('units','normalized','outerposition',[0 0 1 1])
% for ii=1:length(imageNum) %images
%     clear eyeData
%     numPlots=((ii-1)*columns+1):((ii-1)*columns+4);
%     
%     %Plot fixation classification
%     imageName=fixations1(imageNum(ii)).img;
%     %check this is also the same image in exp 2
%     if ~isequal(imageName,fixations2(imageNum(ii)).img)
%         error('Problem with image numbers in two experiments')
%     end
%     
%     eyeData{1}=fixations1(imageNum(ii)).condition(1).subject; %Only for image size
% 
%     plotObjectsFixationMaps(imageName,Param1,Param2,eyeData,attrs,numPlots,rows,columns,Paths);
% end
% 
% if saveFlag
%     saveas(gcf,'FixationMapsObjects.jpg', 'jpg')
% end