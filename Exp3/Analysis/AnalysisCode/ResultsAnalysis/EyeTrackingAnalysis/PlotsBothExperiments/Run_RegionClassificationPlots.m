clear
clc
close all

%% Paramaters
saveFlag=0; %1 save, 0 do not save
imageNum=[122 214 108];

%% paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
path1=[dataPath,'\Pilot1_Final'];
path2=[dataPath,'\Pilot2_Final'];

Paths.HighLevelMapsPath=[foldersPath,'\ResultsImages\HighLevelMaps']; %high level regions
Paths.LowLevelMapsPath=[foldersPath,'\ResultsImages\LowLevelMaps']; %low level regions method 2
Paths.FixationMap1=[foldersPath,'\ResultsImages\FixationMapsRemoveCenterBias\pilot1'];
Paths.FixationMap2=[foldersPath,'\ResultsImages\FixationMapsRemoveCenterBias\pilot2'];
%result paths
Paths.ResultsRegions=[foldersPath,'\ResultsImages\RegionsFixationMapsBothExperiments'];
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

load([path1,'\','RegionsResults_NoShuffling_RemoveCenterBias.mat']);
RegionsResults1=RegionsResults;
clear RegionsResults

load([path2,'\','RegionsResults_NoShuffling_RemoveCenterBias.mat']);
RegionsResults2=RegionsResults;
clear RegionsResults

load([path1,'\','Param_RemoveCenterBias.mat']);
Param1=Param;
clear Param

load([path2,'\','Param_RemoveCenterBias.mat']);
Param2=Param;
clear Param

%% check data
if ~isequal({fixations1.img},{RegionsResults1.image.imageName})
    error('fixations data and region classification data for experiment 1 are not on the same images')
end
if ~isequal({fixations2.img},{RegionsResults2.image.imageName})
    error('fixations data and region classification data for experiment 2 are not on the same images')
end
if ~isequal({fixations1.img},{fixations2.img})
    error('fixations data for experiment 1 and 2 are not on the same images')
end
if ~isequal({RegionsResults1.image.imageName},{RegionsResults2.image.imageName})
    error('Region classification data for experiment 1 and 2 are not on the same images')
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
    numPlots=((ii-1)*columns+1):((ii-1)*columns+columns);
    
    %Plot fixation classification
    imageName=fixations1(imageNum(ii)).img;
    %check this is also the same image in exp 2
    if ~isequal(imageName,fixations2(imageNum(ii)).img)
        error('Problem with image numbers in two experiments')
    end
    
    %U exp 1
    eyeData{1}=fixations1(imageNum(ii)).condition(1).subject;
    classification{1}=RegionsResults1.image(imageNum(ii)).condition(1).subject;
    %U exp 2
    eyeData{2}=fixations2(imageNum(ii)).condition(1).subject;
    classification{2}=RegionsResults2.image(imageNum(ii)).condition(1).subject;
    %C exp 1
    eyeData{3}=fixations1(imageNum(ii)).condition(2).subject;
    classification{3}=RegionsResults1.image(imageNum(ii)).condition(2).subject;
    %C exp 2
    eyeData{4}=fixations2(imageNum(ii)).condition(2).subject;
    classification{4}=RegionsResults2.image(imageNum(ii)).condition(2).subject;
    
    plotFixationClassification(imageName,numPlots,rows,columns,eyeData,classification,Param1,Param2,Paths);
end

if saveFlag
    saveas(gcf,'FixationClassificationRegions.jpg', 'jpg')
end

%% Fixations maps
%Plot fixation maps
figure('units','normalized','outerposition',[0 0 1 1])
for ii=1:length(imageNum) %images
    clear eyeData
    numPlots=((ii-1)*columns+1):((ii-1)*columns+columns);
    
    %Plot fixation classification
    imageName=fixations1(imageNum(ii)).img;
    %check this is also the same image in exp 2
    if ~isequal(imageName,fixations2(imageNum(ii)).img)
        error('Problem with image numbers in two experiments')
    end
    
    eyeData{1}=fixations1(imageNum(ii)).condition(1).subject; %used only to find image size
    
    plotFixationMaps(imageName,Param1,Param2,eyeData,numPlots,rows,columns,Paths);
end

if saveFlag
    saveas(gcf,'FixationMapsRegions.jpg', 'jpg')
end

%% Save fixation map and region classification for all images
if saveFlag
    checkDirExistAndEmpty(Paths.ResultsRegions)
end

%Plot fixation maps
rows=1;
columns=4;
for ii=1:size(RegionsResults1.image,2)
    close all
    figure('units','normalized','outerposition',[0 0.25 1 0.5])
    clear eyeData
    numPlots=1:4;
    
    %Plot fixation classification
    imageName=fixations1(ii).img;
    %check this is also the same image in exp 2
    if ~isequal(imageName,fixations2(ii).img)
        error('Problem with image numbers in two experiments')
    end
    
    eyeData{1}=fixations1(ii).condition(1).subject; %used only to find image size
    
    plotFixationMaps(imageName,Param1,Param2,eyeData,numPlots,rows,columns,Paths);
    
    if saveFlag
        saveas(gcf,[Paths.ResultsRegions,'\',imageName], 'jpg')
    end
end