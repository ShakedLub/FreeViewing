function [Results,imagesToInclude]=loadFixationMaps(Param,Paths)
%get fixation map names
cd(Paths.FixationMapsPath)
d=dir('*.mat');
cd(Paths.dnnAnalysisFolder)

imagesToInclude=zeros(1,length(Param.ImageNames));
Results.ImName=cell(1,length(Param.ImageNames));

%load fixation maps
for ii=1:size(d,1) %images C and U
    numbers = extract(d(ii).name, digitsPattern);
    ImName=[numbers{:},'.jpg'];
    indIm=find(strcmp(ImName,Param.ImageNames));
    
    % load fixation map
    FM=load([Paths.FixationMapsPath,'\',d(ii).name]);
    if contains(d(ii).name,'U')
        Results.FM{indIm}{1}=FM;
    elseif contains(d(ii).name,'C')
        Results.FM{indIm}{2}=FM;
    end
    if isempty(Results.ImName{indIm})
        Results.ImName{indIm}=ImName;
        imagesToInclude(indIm)=indIm;
    end
end

%find images that don't have data from both visibilty conditions
inddel=[];
for ii=1:size(Results.FM,2)
    if size(Results.FM{ii},2)~=2 || isempty(Results.FM{ii}{1}) || isempty(Results.FM{ii}{2})
        inddel=[inddel,ii];
    end
end
if ~isempty(inddel)
    Results.FM(inddel)=[];
    Results.ImName(inddel)=[];
    imagesToInclude(inddel)=[];
end
end