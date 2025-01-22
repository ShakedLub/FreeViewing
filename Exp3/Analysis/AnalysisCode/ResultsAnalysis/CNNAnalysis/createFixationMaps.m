function [FixMaps,imagesToInclude]=createFixationMaps(fixations,Param,Paths)
%the fixation maps are calculated according to:
%Le Meur, O., & Baccino, T. (2013). Methods for comparing scanpaths and saliency maps: strengths and weaknesses. Behavior research methods, 45(1), 251-266.?
%chapter: from a discrete fixation map to a continous saliency map

%Parameters
plotFlag=0;
sigma=Param.pixels_per_vdegree/2;

if Param.RemoveCenterBias
    %create center bias mask
    CenterBiasMask=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,Param.ImSize);
end

imagesToInclude=1:size(Param.ImageNames,2);
for ii=1:size(Param.ImageNames,2) %images
    indInFix=find(strcmp(Param.ImageNames{ii},{fixations.img}));
    if ~isempty(indInFix)
        FixMaps.ImName{ii}=fixations(indInFix).img;
        for kk=1:size(fixations(indInFix).condition,2) %conditions
            clear mapPerIm fixMapPerIm
            if ~isempty(fixations(indInFix).condition(kk).subject)
                for jj=1:size(fixations(indInFix).condition(kk).subject,2) %subjects
                    ImSize=ceil([fixations(indInFix).condition(kk).subject(jj).processed.rect(4),fixations(indInFix).condition(kk).subject(jj).processed.rect(3)]);
                    %initialize map
                    mapPerImAndSubj=zeros(ImSize);

                    fix_h=fixations(indInFix).condition(kk).subject(jj).processed.fix_h_final;
                    fix_w=fixations(indInFix).condition(kk).subject(jj).processed.fix_w_final;

                    for aa=1:length(fix_h) %fixations
                        height=fix_h(aa);
                        width=fix_w(aa);

                        temp_map=zeros(ImSize);
                        temp_map(height,width)=1;
                        mapPerImAndSubj=mapPerImAndSubj+temp_map; %if a pixel was fixated more than once its value will be bigger than 1 therefore this is not a binary map.
                    end

                    %create fixation map for each image across all observers
                    if jj==1
                        mapPerIm=mapPerImAndSubj;
                    else
                        mapPerIm=mapPerIm+mapPerImAndSubj;
                    end
                end

                mapPerIm=mapPerIm./size(fixations(indInFix).condition(kk).subject,2);
                fixMapPerIm = imgaussfilt(mapPerIm,sigma,'Padding','symmetric');

                %remove center from fixation mask
                if Param.RemoveCenterBias
                    fixMapPerIm(~CenterBiasMask)=0;
                end

                %save maps
                FixMaps.FM{ii}{kk}=fixMapPerIm;
            else
                FixMaps.FM{ii}{kk}=[];
            end
        end

        if plotFlag
            %create figure
            figure
            if ~isempty(fixations(indInFix).condition(1).subject)
                subplot(2,2,1)
                imagesc(FixMaps.FM{ii}{1})
                title(['U fixation map, N= ',num2str(size(fixations(indInFix).condition(1).subject,2))])

                subplot(2,2,3)
                I=imread([Paths.ImagesFolder,'\',fixations(indInFix).img]);
                I=imresize(I,ImSize);
                imagesc(I)
                title('Original image')
            end

            if ~isempty(fixations(indInFix).condition(2).subject)
                subplot(2,2,2)
                imagesc(FixMaps.FM{ii}{2})
                title(['C fixation map, N= ',num2str(size(fixations(indInFix).condition(2).subject,2))])

                subplot(2,2,4)
                I=imread([Paths.ImagesFolder,'\',fixations(indInFix).img]);
                I=imresize(I,ImSize);
                imagesc(I)
                title('Original image')
            end
        end
    else
        FixMaps.ImName{ii}=Param.ImageNames{ii};
        FixMaps.FM{ii}{1}=[];
        FixMaps.FM{ii}{2}=[];
    end
end

%find images that don't have data from both visibilty conditions
inddel=[];
for ii=1:size(FixMaps.FM,2)
    if size(FixMaps.FM{ii},2)~=2 || isempty(FixMaps.FM{ii}{1}) || isempty(FixMaps.FM{ii}{2})
        inddel=[inddel,ii];
    end
end
if ~isempty(inddel)
    FixMaps.FM(inddel)=[];
    FixMaps.ImName(inddel)=[];
    imagesToInclude(inddel)=[];
end
end