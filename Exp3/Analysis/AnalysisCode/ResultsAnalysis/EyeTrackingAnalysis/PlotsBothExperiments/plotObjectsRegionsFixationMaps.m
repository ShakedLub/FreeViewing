function plotObjectsRegionsFixationMaps(imageName,Param1,Param2,eyeData,attrs,numPlots,rows,columns,Paths)
%% load fixation maps
%load fixation maps
ind=find('.'==imageName);
%exp1 U
load([Paths.FixationMap1,'\',imageName(1:(ind-1)),'U.mat']);
U1=fixMapPerIm;
clear fixMapPerIm
%exp1 C
load([Paths.FixationMap1,'\',imageName(1:(ind-1)),'C.mat']);
C1=fixMapPerIm;
clear fixMapPerIm
%exp2 U
load([Paths.FixationMap2,'\',imageName(1:(ind-1)),'U.mat']);
U2=fixMapPerIm;
clear fixMapPerIm
%exp2 C
load([Paths.FixationMap2,'\',imageName(1:(ind-1)),'C.mat']);
C2=fixMapPerIm;
clear fixMapPerIm

%% original image
%original image
I=imread([Paths.ImagesFolder,'\',imageName]);
I=imresize(I,size(U1));

%% load region maps
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

%% center bias mask
if Param1.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Param1.pixels_per_vdegree,Param1.CenterBiasRadius,ImSize);
end
ind=find('.'==imageName);

%% high level fixation map
savenameHighMap=[imageName(1:(ind-1)),'.mat'];
load([Paths.HighLevelMapsPath,'\',savenameHighMap]);

%check correct size
if ~isequal(ImSize, size(HighLevelMap))
    error('Problem with high level map size')
end

%% low level fixation map
savenameSM=[imageName(1:(ind-1)),'.mat'];
load([Paths.LowLevelMapsPath,'\',savenameSM]);

LowLevelMap=LowLevelSalMap_B;
clear LowLevelSalMap_B

%check correct size
if ~isequal(ImSize, size(LowLevelMap))
    error('Problem with low level map size')
end

%remove center bias from low and high level areas
if Param1.RemoveCenterBias
    HighLevelMap = CenterBiasMask & HighLevelMap;
    LowLevelMap = CenterBiasMask & LowLevelMap;
end

%% High and low map
HighAndLowMap= LowLevelMap & HighLevelMap;

%% Object maps
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

for kk=1:columns % 4 conditions + 2 images
    subplot(rows,columns,numPlots(kk))
    FirstRowVec=1:columns;
    imagesc(Ifig)
    xticks([1,100,200,300,400])
    yticks([1,100,200,300,400])
        
    hold on
    if kk==1
        overlay=imagesc(U1);
        overlay.CData(~CenterBiasMask)=NaN;
        set(overlay,'AlphaData',0.6);
        if any(ismember(numPlots(kk),FirstRowVec))
            if rows==1
                title('Unconscious exp 1')
            else
                title('Exp 1')
            end
        end
    elseif kk==2
        overlay=imagesc(U2);
        overlay.CData(~CenterBiasMask)=NaN;
        set(overlay,'AlphaData',0.6);
        if any(ismember(numPlots(kk),FirstRowVec))
            if rows==1
                title('Unconscious exp 2')
            else
                title('Exp 2')
            end
        end
    elseif kk==3
        overlay=imagesc(C1);
        overlay.CData(~CenterBiasMask)=NaN;
        set(overlay,'AlphaData',0.6);
        if any(ismember(numPlots(kk),FirstRowVec))
            if rows==1
                title('Conscious exp 1')
            else
                title('Exp 1')
            end
        end
    elseif kk==4
        overlay=imagesc(C2);
        overlay.CData(~CenterBiasMask)=NaN;
        set(overlay,'AlphaData',0.6);
        if any(ismember(numPlots(kk),FirstRowVec))
            if rows==1
                title('Conscious exp 2')
            else
                title('Exp 2')
            end
        end
    end
        
    for o = 1:size(objs,1) %objects
        Iedge = edge(objs{o}.bw,'Roberts');
        [X,Y]=find(Iedge==1);
        plot(Y,X,'w.') % note Y and X swapped
    end
    
    Iedge = edge(LowLevelMap,'Roberts');
    [X,Y]=find(Iedge==1);
    plot(Y,X,'r.') % note Y and X swapped
    
    Iedge = edge(HighLevelMap,'Roberts');
    [X,Y]=find(Iedge==1);
    plot(Y,X,'b.') % note Y and X swapped
    
    Iedge = edge(HighAndLowMap,'Roberts');
    [X,Y]=find(Iedge==1);
    plot(Y,X,'g.') % note Y and X swapped
    hold off
    
    beginingOfRowVec=1:columns:(rows*columns);
    if any(ismember(numPlots(kk), beginingOfRowVec))
        ylabel('Y (pixels)')
    else
        yticks([]);
    end
    LastRowVec=(columns*(rows-1)+1):(columns*rows);
    if any(ismember(numPlots(kk),LastRowVec))
        xlabel('X (pixels)')
    else
        xticks([]);
    end
    
    set(gca,'FontSize',20)
end
end