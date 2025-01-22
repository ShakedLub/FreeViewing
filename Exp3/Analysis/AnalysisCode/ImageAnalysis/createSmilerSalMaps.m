function createSmilerSalMaps(SmilerModels,Paths)

%% install smiler and chose parameters
%Parametes
models = SmilerModels; %{'GBVS', 'DVA','IKN'}; % a cell array of the SMILER model codes which we wish to execute

%add smiler to matlab path
cd(Paths.SmilerPath)
iSMILER
cd(Paths.ImageAnalysisFolder)

%% Set up the default experiment
% The next few lines create a dynamically allocated array of function
% handles to invoke the models specified in the previous line
modfun = cell(length(models),1);
for i = 1:length(models)
    modfun{i} = str2func([models{i}, '_wrap']);
end

input_set = dir([Paths.ImagesPath,'\*.jpg']); % get the list of images located in the directory

% if the output directory does not yet exist, make it
if(~exist(Paths.SaliencyMapsPath, 'dir'))
    mkdir(Paths.SaliencyMapsPath);
end

% check to see if the output directories exist to save the output maps for
% each model. If the directories do not exist, make them
for j = 1:length(models)
    checkDirExistAndEmpty([Paths.SaliencyMapsPath,'\', models{j}]);
end

%% Calculate default output maps and save them
% loop through images in the outer loop to save on imread commands
disp('Now starting the experiment using default parameters');
for i = 1:length(input_set)
    img = imread([Paths.ImagesPath,'\', input_set(i).name]); % read in the image
    for j = 1:length(models)
        disp(['Executing model ', models{j}, ' on image ', num2str(i), ' of ', num2str(length(input_set))]);
        salmap = modfun{j}(img); % execute the jth model on the ith image
        imwrite(salmap, [Paths.SaliencyMapsPath,'\', models{j}, '\', input_set(i).name]); % save the saliency map
    end
end
end
