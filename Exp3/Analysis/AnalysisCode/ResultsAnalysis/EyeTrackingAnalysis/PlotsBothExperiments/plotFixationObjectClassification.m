function plotFixationObjectClassification(imageName,numPlots,rows,columns,eyeData,classification,Param1,Param2,attrs,Paths)
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
        
        fixClassifications=classification{kk}(jj).objectClass;
        
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

%change objects order according to size, biggest will be first
[~,indO]=sort(objSize,'descend');
objs=objs(indO);
for kk=1:length(fix_class_all)
    fc=fix_class_all{kk};
    fc_new=fc;
    for o=1:length(indO)
        fc_new(fc==indO(o))=o;
    end
    fix_class_all_sort{kk}=fc_new;
end

%crate overlayed image
for o = 1:size(objs,1) %objects
    if o==1
        L=double(objs{o}.bw);
    else
        L(objs{o}.bw)=o;
    end
end
%Colors=[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330];[0.6350 0.0780 0.1840];[0 0.7 0.7];[1 1 0];[0 1 0];[1 0.75 0.79297];[0.67578 0.84375 0.89844]];
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
            classFix=fix_class_all_sort{kk}(ff);
            if isnan(classFix)
                imcontour(FixCirclesMap{kk}{ff},'LineColor','k')
                scatter(fix_w_all{kk}(ff),fix_h_all{kk}(ff),50,'k','filled')
            else
                imcontour(FixCirclesMap{kk}{ff},'LineColor',colorNames{classFix})
                scatter(fix_w_all{kk}(ff),fix_h_all{kk}(ff),50,allColors(classFix,:),'filled')
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