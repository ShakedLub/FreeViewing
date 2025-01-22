function [PixelsInAtt,PixelsNoAtt]=findAttributePixels(objs,Param,imsize)
%create center bias mask
if Param.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,imsize);
end

%initialize AttMap
AttMap=cell(1,length(objs{1}.features));
for ii=1:length(AttMap)
    AttMap{ii}=zeros(imsize);
end
NoAttMap=zeros(imsize);

for o = 1:size(objs,1) %objects
    objs{o}.bw=imresize(objs{o}.map, imsize);
    if Param.RemoveCenterBias
        objs{o}.bw= CenterBiasMask & objs{o}.bw;
    end
    
    ObjAttributes=find(logical(objs{o}.features));
    if ~isempty(ObjAttributes)
        for aa=1:length(ObjAttributes)
            AttMap{ObjAttributes(aa)}=AttMap{ObjAttributes(aa)}+objs{o}.bw;
        end
    else
        NoAttMap=NoAttMap+objs{o}.bw;
    end
end

for ii=1:length(AttMap)
    PixelsInAtt(ii)=sum(sum(logical(AttMap{ii})));
end
PixelsNoAtt=sum(sum(logical(NoAttMap)));
end