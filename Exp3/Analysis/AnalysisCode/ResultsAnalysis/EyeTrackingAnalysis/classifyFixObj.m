function count=classifyFixObj(count,centerH,centerW,dur,imsize,objs,Param)
%create circle mask
plotFlag=0;
imageSizeH=imsize(1);
imageSizeW=imsize(2);
radius=Param.pixels_per_vdegree/2;

[columnsInImage rowsInImage] = meshgrid(1:imageSizeW, 1:imageSizeH);
circleMask = (rowsInImage - centerH).^2 + (columnsInImage - centerW).^2 <= radius.^2;

%check which objects the fixation overlap
OptionalObj=[];
for bb=1:size(objs,1) %objects
    if sum(objs{bb}.bw(circleMask))>=1
        OptionalObj=[OptionalObj,bb];
    end
end

%If there is more than one optional object calcautle distance to
%all objects and select the object with the smallest distance

if isempty(OptionalObj) %no object
    ObjClass=NaN;
elseif length(OptionalObj)==1 %1 object
    ObjClass=OptionalObj;
else %few optional objects
    clear distance
    for cc=1:length(OptionalObj) %optional objects
        distance(cc)= sqrt( (centerH-objs{OptionalObj(cc)}.ObjCenter(2))^2 + (centerW-objs{OptionalObj(cc)}.ObjCenter(1))^2 );
    end
    [~,indmin]=min(distance);
    ObjClass=OptionalObj(indmin);
    
    %figure of optional objects and their distance to fixation
    if plotFlag
        figure
        subplot(1,length(OptionalObj)+1,1)
        imshow(circleMask,[])
        title(['Fixation circle mask, classification:',num2str(ObjClass)])
        
        for cc=1:length(OptionalObj)
            subplot(1,length(OptionalObj)+1,1+cc)
            imshow(objs{OptionalObj(cc)}.bw)
            title(['Obj number ',num2str(OptionalObj(cc))])
            hold on
            line([centerW,objs{OptionalObj(cc)}.ObjCenter(1)],[centerH,objs{OptionalObj(cc)}.ObjCenter(2)],'Color','c','LineWidth',2)
        end
        hold off
    end
end

%figure of all objects
if plotFlag 
    figure
    subplot(ceil(sqrt(size(objs,1)+2)),ceil(sqrt(size(objs,1)+2)),1)
    I=imread([Paths.ImagesFolder,'\',ImName]);
    I=imresize(I,imsize);
    imshow(I,[])
    title('Original image')
    
    subplot(ceil(sqrt(size(objs,1)+2)),ceil(sqrt(size(objs,1)+2)),2)
    imshow(circleMask,[])
    title(['Fixation circle mask, classification:',num2str(ObjClass)])
    
    for kk = 1 : size(objs,1) %objects
        indplot=2+kk;
        subplot(ceil(sqrt(size(objs,1)+2)),ceil(sqrt(size(objs,1)+2)),indplot)
        imshow(objs{kk}.bw)
        title(['Obj number ',num2str(kk)])
    end
end

%count fixations for each image
if isempty(OptionalObj) %no object
    count.objectClass=[count.objectClass,NaN];
    count.countFixBg=count.countFixBg+1;
    count.fixDurBg=[count.fixDurBg,dur];
else %yes object
    count.objectClass=[count.objectClass,ObjClass];
    vec=zeros(1,size(objs,1));
    vec(ObjClass)=1;
    count.countFixObj=count.countFixObj+vec;
    count.fixDurObj{ObjClass}=[count.fixDurObj{ObjClass},dur];
end
count.countFix=count.countFix+1;
end