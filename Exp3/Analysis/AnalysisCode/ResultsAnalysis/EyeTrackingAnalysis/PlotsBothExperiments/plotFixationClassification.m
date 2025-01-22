function plotFixationClassification(imageName,numPlots,rows,columns,eyeData,classification,Param1,Param2,Paths)
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

%%  high level fixation map
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

%%  High and low map
HighAndLowMap= LowLevelMap & HighLevelMap;

%Some more parameters
radius=Param1.pixels_per_vdegree/2; %Pixels in 0.5 deg
imageSizeW = ImSize(2);
imageSizeH = ImSize(1);

%% original image
I=imread([Paths.ImagesFolder,'\',imageName]);
I=imresize(I,size(HighLevelMap));

%% arrange fixations
%initialize cell arrays
for kk=1:size(eyeData,2) % 4 conditions
    fix_w_all{kk}=[];
    fix_h_all{kk}=[];
    fix_class_all{kk}=[];
    subj_all{kk}=[];
end

%organize data
for kk=1:size(eyeData,2) % 4 conditions
    for jj=1:size(eyeData{kk},2) %subjects
        fix_w=eyeData{kk}(jj).processed.fix_w_final;
        fix_h=eyeData{kk}(jj).processed.fix_h_final;
        
        fixClassifications=classification{kk}(jj).fixClassifications;
        
        subj=ones(1,length(fix_w))*jj;
        
        fix_w_all{kk}=[fix_w_all{kk};fix_w];
        fix_h_all{kk}=[fix_h_all{kk};fix_h];
        fix_class_all{kk}=[fix_class_all{kk},fixClassifications];
        subj_all{kk}=[subj_all{kk},subj];
    end
    %create circle mask
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeW, 1:imageSizeH);
    
    for ff=1:length(fix_w_all{kk}) %fixations
        centerW = fix_w_all{kk}(ff);
        centerH = fix_h_all{kk}(ff);
        map = (rowsInImage - centerH).^2 + (columnsInImage - centerW).^2 <= radius.^2; 
        FixCirclesMap{kk}{ff}= map;
    end
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

%create overlayed image
L=LowLevelMap+(HighLevelMap*2); %Indices values: 1 low , 2 high , 3 L&H
B=labeloverlay(Ifig,L,'ColorMap',[1 0 0;0 0 1;0 1 0]);

if ~isempty(fix_w_all{1}) || ~isempty(fix_w_all{2}) || ~isempty(fix_w_all{3}) || ~isempty(fix_w_all{4})
    for kk=1:size(eyeData,2) % 4 conditions
        clear indsubj
        
        subplot(rows,columns,numPlots(kk))
        
        imagesc(B)    
        xticks([1,100,200,300,400])
        yticks([1,100,200,300,400])
        hold on
        
        %add circle around fixation and dot in fixation location, with the color of fixation classification
        for ff=1:length(fix_w_all{kk}) %fixations
            classFix=fix_class_all{kk}(ff);
            if classFix == 1
                imcontour(FixCirclesMap{kk}{ff},'LineColor','r')
                scatter(fix_w_all{kk}(ff),fix_h_all{kk}(ff),50,'r','filled')
            elseif classFix == 2
                imcontour(FixCirclesMap{kk}{ff},'LineColor','b')
                scatter(fix_w_all{kk}(ff),fix_h_all{kk}(ff),50,'b','filled')
            elseif classFix == 3
                imcontour(FixCirclesMap{kk}{ff},'LineColor','g')
                scatter(fix_w_all{kk}(ff),fix_h_all{kk}(ff),50,'g','filled')
            elseif classFix == 4
                imcontour(FixCirclesMap{kk}{ff},'LineColor','k')
                scatter(fix_w_all{kk}(ff),fix_h_all{kk}(ff),50,'k','filled')
            end
        end
        hold off
        
        FirstRowVec=1:columns;
        if any(ismember(numPlots(kk),FirstRowVec))
            if kk==1
                title('Exp 1');
            elseif kk==2
                title('Exp 2')
            elseif kk==3
                title('Exp 1')
            elseif kk==4
                title('Exp 2')
            end
        end
        beginingOfRowVec=1:columns:(rows*columns);
        if any(ismember(numPlots(kk), beginingOfRowVec))
            ylabel('Y (pixels)')
        end
        LastRowVec=(columns*(rows-1)+1):(columns*rows);
        if any(ismember(numPlots(kk),LastRowVec))
            xlabel('X (pixels)')            
        end
       
        set(gca,'FontSize',22)
    end
end
end