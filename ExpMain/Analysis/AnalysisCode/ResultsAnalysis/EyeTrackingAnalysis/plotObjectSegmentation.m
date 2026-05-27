function plotObjectSegmentation(imageName,numPlots,rows,columns,eyeData,Param1,Param2,attrs,Paths)
%% check parameters in both experiments
if ~isequal(Param1.RemoveCenterBias,Param2.RemoveCenterBias)
    error('remove center bias parameter is not the same in two experiments')
end
if ~isequal(Param1.pixels_per_vdegree,Param2.pixels_per_vdegree)
    error('pixels_per_vdegree parameter is not the same in two experiments')
end
if ~isequal(Param1.CenterBiasRadius,Param2.CenterBiasRadius)
    error('CenterBiasRadius is not the same in two experiments')
end

%% load or create all maps
ImSize=ceil([eyeData{1}(1).processed.rect(4),eyeData{1}(1).processed.rect(3)]);

%center bias mask
if Param1.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Param1.pixels_per_vdegree,Param1.CenterBiasRadius,ImSize);
end

%Object maps
%OSIE object names
for aa=1:size(attrs,1) %images
    ImgNamesAttr{aa}=attrs{aa}.img;
end
indImAttr=find(strcmp(imageName,ImgNamesAttr));
objs = attrs{indImAttr}.objs;
%change the binarized image to the correct size and remove center
for o = 1:size(objs,1) %objects
    objs{o}.bw=imresize(objs{o}.map,ImSize);
    if Param1.RemoveCenterBias
        objs{o}.bw= CenterBiasMask & objs{o}.bw;
    end
    objSize(o)= sum(sum(objs{o}.bw));
end

%Some more parameters
radius=Param1.pixels_per_vdegree/2; %Pixels in 0.5 deg
imageSizeW = ImSize(2);
imageSizeH = ImSize(1);

%original image
I=imread([Paths.ImagesFolder,'\',imageName]);
I=imresize(I,ImSize);

%% create figure
%make the central area of the image black and white
% create grey scale image
Igray = rgb2gray(I);
I1=I(:,:,1);
I2=I(:,:,2);
I3=I(:,:,3);
% add grey scale image to the central area of all colors
I1(~CenterBiasMask)=Igray(~CenterBiasMask);
I2(~CenterBiasMask)=Igray(~CenterBiasMask);
I3(~CenterBiasMask)=Igray(~CenterBiasMask);
%create image to present
Ifig(:,:,1)=I1;
Ifig(:,:,2)=I2;
Ifig(:,:,3)=I3;

%change objects order according to size, biggest will be first
[~,indO]=sort(objSize,'descend');
objs=objs(indO);

%crate overlayed image
for o = 1:size(objs,1) %objects
    if o==1
        L=double(objs{o}.bw);
    else
        L(objs{o}.bw)=o;
    end
end

Colors=[[1 0 0];[0 1 0];[0 0 1];[0 1 1];[1 0 1];[1 1 0];[1 1 1]];
colorNames={'r','g','b','c','m','y','w'};
if o>size(Colors,1)
    num=ceil(o/size(Colors,1));
    allColors=repmat(Colors,num,1);
    colorNames=repmat(colorNames,1,num);
    allColors=allColors(1:o,:);
    colorNames=colorNames(1:o);
else
    allColors=Colors;
    allColors=allColors(1:o,:);
    colorNames=colorNames(1:o);
end
B=labeloverlay(Ifig,L,'ColorMap',allColors);

subplot(rows,columns,numPlots)
imagesc(B)
xticks([1,100,200,300,400])
yticks([1,100,200,300,400])

beginingOfRowVec=1:columns:(rows*columns);
if any(ismember(numPlots, beginingOfRowVec))
    ylabel('Y (pixels)')
end

LastRowVec=(columns*(rows-1)+1):(columns*rows);
if any(ismember(numPlots,LastRowVec))
    xlabel('X (pixels)')
end

set(gca,'FontSize',18)
end