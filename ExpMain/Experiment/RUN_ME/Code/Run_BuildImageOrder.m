function Run_BuildImageOrder()
%%
%Create image order for the different subjects in advance
%The randomization will include: 
%1. Image Order (including Control trials)
%2. Conditions Order C vs UC 
close all
clear 
clc

rng('default');
rng('shuffle');

%check if ExpDesignAllSubjects exists if so do not overwrite it
fileName = 'ExpDesignAllSubjects';
Flag=0;
while exist([fileName,'.mat'])
    Flag = Flag+1;
    fileName = ['ExpDesignAllSubjects','(',num2str(Flag),')'];
end

%Paths
code_folder=cd('..\');
run_me_folder=pwd;
Param.EXPERIMENT_IMAGES_FOLDER=[run_me_folder,'\Stimuli\ImageTrials_Experiment'];
Param.PRACTICE_IMAGES_FOLDER=[run_me_folder,'\Stimuli\ImageTrials_Practice'];
Param.EXPERIMENT_IMAGES_FORQ_FOLDER=[run_me_folder,'\Stimuli\ImageForQ_Experiment'];
Param.PRACTICE_IMAGES_FORQ_FOLDER=[run_me_folder,'\Stimuli\ImageForQ_Practice'];
Param.IMAGES_FOR_THRESHOLD_FITTING=[run_me_folder,'\Stimuli\Image_ThresholdFitting'];
Param.EXTRA_IMAGES_FORQ_FOLDER=[run_me_folder,'\Stimuli\ImageForQ_ExtraTrials'];

cd(code_folder);

%Experiment design
Param.ConditionLabels={'U','C'}; %UC==1,C==2 (only 2 conditions possible)
Param.NumConditions=length(Param.ConditionLabels); %UC==1,C==2
Param.expSteps={'Practice','Experiment','ThresholdFitting','Extra'};
Param.NumSubjects=26;
Param.NumBlocks=8; %EvenNumber
Param.NumBlocksPerCondition=Param.NumBlocks/Param.NumConditions;

%Threshold fitting block
Param.MaxNumBlocksTHF=8;
Param.NumStartImagesTHF=20;
Param.NumImagesInBlockTHF=5;

%check 
if Param.NumStartImagesTHF<Param.NumImagesInBlockTHF
    error('The number of images presented in the begining of the threshold fitting block should be bigger than the block itself')
end
%Control trials
Param.Percent_Control_Trials=0.2; %This is percent from image trials in the whole experiment
Param.ControlTrialNum=Inf;

%Extra trials
Param.NumTrialsInBlock_Extra=40; 
Param.GoalNumTrialsPAS12=213;

Param.MinimalDistanceBetweenNonImageTrials=3; 

%Division parameters
Param.PercentFromSubjectsBadDivision=1/5;
Param.PercentFromImagesBadDivsion=0.05;
%%
%Add data about images in image folder to Param
cd(Param.EXPERIMENT_IMAGES_FOLDER);
Images = dir('*.jpg');
I=imread(Images(1).name);
Param.Image_Size=size(I);
cd(code_folder)
Param.Num_Images_Experiment=size(Images,1);
Param.Image_Names_Experiment={Images.name};
clear Images I

%%
%Check in all image folders: all images are in the same size as first image in
%image folder
checkImSize(Param.EXPERIMENT_IMAGES_FOLDER,Param.Image_Size);
checkImSize(Param.PRACTICE_IMAGES_FOLDER,Param.Image_Size);
checkImSize(Param.EXPERIMENT_IMAGES_FORQ_FOLDER,Param.Image_Size);
checkImSize(Param.PRACTICE_IMAGES_FORQ_FOLDER,Param.Image_Size);

%%
%Add data about images in practice image folder to Param
cd(Param.PRACTICE_IMAGES_FOLDER);
Images = dir('*.jpg');
cd(code_folder)
Param.Num_Images_Practice=size(Images,1);
Param.Image_Names_Practice={Images.name};
if mod(Param.Num_Images_Practice,2)
    error('The number of images for practice should be an even number')
end
clear Images

%%
%Add data about images in experiment Q image folder to Param
cd(Param.EXPERIMENT_IMAGES_FORQ_FOLDER);
Images = dir('*.jpg');
cd(code_folder)
Param.Num_Images_For_Q_Experiment=size(Images,1);
Param.Image_Names_For_Q_Experiment={Images.name};
clear Images

%%
%Add data about images in practice Q image folder to Param
cd(Param.PRACTICE_IMAGES_FORQ_FOLDER);
Images = dir('*.jpg');
cd(code_folder)
Param.Num_Images_For_Q_Practice=size(Images,1);
Param.Image_Names_For_Q_Practice={Images.name};
clear Images

%%
%check there are enough Q images
if Param.Num_Images_For_Q_Practice ~= Param.Num_Images_Practice + max(2,round(Param.Num_Images_Practice * Param.Percent_Control_Trials))*2
    error('Wrong number of distractor images for practice')
end
if Param.Num_Images_For_Q_Experiment ~= Param.Num_Images_Experiment + round(Param.Num_Images_Experiment * Param.Percent_Control_Trials)*2
    error('Wrong number of distractor images for experiment')
end

%%
%Add data about images in threshold fitting folder to Param
cd(Param.IMAGES_FOR_THRESHOLD_FITTING);
Images = dir('*.jpg');
I=imread(Images(1).name);
Param.Image_Size_Thr_Fitting=size(I);
cd(code_folder)
Param.Num_Images_Thr_Fitting=size(Images,1);
Param.Image_Names_Thr_Fitting={Images.name};
clear I Images

%Check: all images are in the same size as first image in
%thr fitting image folder
checkImSize(Param.IMAGES_FOR_THRESHOLD_FITTING,Param.Image_Size_Thr_Fitting);
%Check: all images have the same ratio as first image in
%image folder
checkImRatio(Param.IMAGES_FOR_THRESHOLD_FITTING,Param.Image_Size);

%check there are enough threshold fitting images
if Param.Num_Images_Thr_Fitting<(Param.MaxNumBlocksTHF*Param.NumImagesInBlockTHF+Param.NumStartImagesTHF)
   error('Not enough images for threshold fitting');
end

%%
%Add data about images for question in extra trials folder to Param
cd(Param.EXTRA_IMAGES_FORQ_FOLDER);
Images = dir('*.jpg');
cd(code_folder)
Param.Num_Images_For_Q_Extra=size(Images,1);
Param.Image_Names_For_Q_Extra={Images.name};
clear Images

%Check: all images are in the same size as first image in
%thr fitting image folder
checkImSize(Param.EXTRA_IMAGES_FORQ_FOLDER,Param.Image_Size_Thr_Fitting);
%Check: all images have the same ratio as first image in
%image folder
checkImRatio(Param.EXTRA_IMAGES_FORQ_FOLDER,Param.Image_Size);

%%
%Create randomized mat for experiment
ExpDesignAllSubjects.RandTrialsOrder=randomizeTrialsForBuild(Param,Param.expSteps{2},[]);
ExpDesignAllSubjects.RandTrialsOrder_Practice=randomizeTrialsForBuild(Param,Param.expSteps{1},[]);
ExpDesignAllSubjects.RandTrialsOrder_ThrFitting=randomizeTrialsForBuild(Param,Param.expSteps{3},[]);
ExpDesignAllSubjects.RandTrialsOrder_Extra=randomizeTrialsForBuild(Param,Param.expSteps{4},ExpDesignAllSubjects.RandTrialsOrder_ThrFitting);

%%
%Save data to struct
ExpDesignAllSubjects.Param=Param;

%Save struct
save(fileName,'ExpDesignAllSubjects')
rng('default');
end