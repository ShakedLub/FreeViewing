function createLowLevelMaps(Paths,imsize)
plotFlag=0;

%check the save folders exists and empty
checkDirExistAndEmpty(Paths.LowLevelMapsPath);

%get images names
cd(Paths.ImagesPath);
d=dir('*.jpg');
cd(Paths.ImageAnalysisFolder)

for ii=1:size(d,1) %Images
    clear fixMapPerIm IKNmap HighLevelMap
    ImName=d(ii).name;
    ind=find('.'==ImName);
    
    %% load fixation maps from non-mondrian experiment
    fixMap_NM_Name=[ImName(1:(ind-1)),'.mat'];
    load([Paths.FixationMapsPathNoMondrians,'\',fixMap_NM_Name]);
    fixMap_NM=fixMapPerIm;
    
    if ~isequal(imsize,size(fixMap_NM))
        error('Problem with non mondrian fixation map size')
    end
    
    fixMap_NM=mat2gray(fixMap_NM);
    
    %% load IKN saliency map
    IKNmap=double(imread([Paths.SaliencyMapsPath,'\IKN\',ImName]));
    IKNmap=imresize(IKNmap,imsize);
    IKNmap=mat2gray(IKNmap);
    
    %% Histogram matching
    %histogram matching non mondrian fixation map is the reference
    LowLevelSalMap=imhistmatch(IKNmap,fixMap_NM);
    
    %% load High level maps (binarized map created from non mondrian fixation maps and objects maps)
    HName=[ImName(1:(ind-1)),'.mat'];
    load([Paths.HighLevelMapsPath,'\',HName]);
    HMap=HighLevelMap;
    
    %% Size equalization
    %convert low level map to Z score
    meanLowLevelSalMap=mean(LowLevelSalMap(:));
    stdLowLevelSalMap=std(LowLevelSalMap(:),1); %std normalized by N
    LowLevelSalMap_Z=(LowLevelSalMap-meanLowLevelSalMap)./stdLowLevelSalMap;
    
    %change low level area to be the same size as high level area after
    %taking into account objects
    wantedArea=sum(sum(HMap)); %high level areas size
    VEC=sort(LowLevelSalMap_Z(:),'descend');
    VECunique=unique(VEC);
    val=VEC(wantedArea); %possible threshold 
    valbelow=VECunique(find(VECunique==val)-1); %lower threshold that will create a bigger region

    %size with lower threshold (supposed to be bigger than wantedArea)
    sizeA=min(find(VEC==valbelow))-1;
    %size with threshold (supposed to be smaller or equal wantedArea)
    sizeB=min(find(VEC==val))-1;
    %check which size is closer to the wanted area
    if abs(sizeA-wantedArea)<abs(sizeB-wantedArea)
        T=valbelow;
    else
        T=val;
    end
    
    %In order not to extend the low level areas more than what is
    %appropriate based on saliency algorithem,
    %chose the maximal threshold between a threshold that is based on the
    %high level areas and the threshold that minimize the intraclass variance 
    %of the black and white pixels 
    TgreyTh=graythresh(LowLevelSalMap_Z);
    T = max(T,TgreyTh);
    
    %% Binarize the low level map
    LowLevelSalMap_B=imbinarize(LowLevelSalMap_Z,T);
    
    %% plot 
    if plotFlag
        figure
        subplot(2,3,1)
        imagesc(fixMap_NM)
        title('Fixation map non mondrains')
        
        subplot(2,3,2)
        imagesc(IKNmap)
        title('IKN map original')
                
        subplot(2,3,3)
        imagesc(HMap)
        title('high level map')
        
        subplot(2,3,4)
        imagesc(LowLevelSalMap)
        title('IKN with histogram matching')
        
        subplot(2,3,5)
        imagesc(LowLevelSalMap_B)
        title('Low level map binarized with size fitting to high map')
        
        subplot(2,3,6)
        I=imread([Paths.ImagesPath,'\',ImName]);
        I=imresize(I,imsize);
        imagesc(I)
        title('Original image')
    end
    
    %% save low level map
    savename=[ImName(1:(ind-1)),'.mat'];
    save([Paths.LowLevelMapsPath,'\',savename],'LowLevelSalMap_B')
end
end