function createHighLevelMaps(Paths,imsize)
plotFlag=0;

%check the save folders exists and empty
checkDirExistAndEmpty(Paths.HighLevelMapsPath);

%load OSIE objects
load([Paths.OSIEObjects,'\AttrsCombined.mat']);
for aa=1:size(attrs,1) %images
    ImgNamesAttr{aa}=attrs{aa}.img;
end

%get images names
cd(Paths.ImagesPath);
d=dir('*.jpg');
cd(Paths.ImageAnalysisFolder)

for ii=1:size(d,1) %Images
    clear fixMapPerIm
    ImName=d(ii).name;
    ind=find('.'==ImName);
    
    %% load fixation maps from non-mondrian experiment
    fixMap_NM_Name=[ImName(1:(ind-1)),'.mat'];
    load([Paths.FixationMapsPathNoMondrians,'\',fixMap_NM_Name]);
    fixMap_NM=fixMapPerIm;
    
    if ~isequal(imsize,size(fixMap_NM))
        error('Problem with non mondrian fixation map size')
    end
    
    %change fixation map values to Z scores 
    meanfixMap_NM=mean(fixMap_NM(:));
    stdfixMap_NM=std(fixMap_NM(:),1); %std normalized by N
    fixMap_NM_Z=(fixMap_NM-meanfixMap_NM)./stdfixMap_NM;
    
    %change fixation map to binary
    T = graythresh(fixMap_NM_Z);
    fixMap_NM_B=imbinarize(fixMap_NM_Z,T);
    
    %% create object map
    indAttr=find(strcmp(ImName,ImgNamesAttr));
    ObjMap=[];
    for aa=1:size(attrs{indAttr}.objs,1) %objects
        Obj=attrs{indAttr}.objs{aa}.map;
        Obj=imresize(Obj,imsize);
        Obj=logical(Obj);
        if isempty(ObjMap)
            ObjMap=Obj;
        else
            ObjMap=ObjMap+Obj;
        end
    end
    
    %make Obj map binary (if there are overlapping objects)
    ObjMap(ObjMap~=0)=1;
    ObjMap=logical(ObjMap);
    
    HighLevelMap = fixMap_NM_B & ObjMap;
    
    if plotFlag
        figure
        subplot(2,2,1)
        imagesc(fixMap_NM_B)
        title('Fixation map non mondrains')
        
        subplot(2,2,2)
        imagesc(ObjMap)
        title('Objects map')
        
        subplot(2,2,3)
        imagesc(HighLevelMap)
        title('High level map')
        
        subplot(2,2,4)
        I=imread([Paths.ImagesPath,'\',ImName]);
        I=imresize(I,imsize);
        imagesc(I)
        title('Original image')
    end
    
    %save high level map
    savename=[ImName(1:(ind-1)),'.mat'];
    save([Paths.HighLevelMapsPath,'\',savename],'HighLevelMap') 
end
end