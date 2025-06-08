function FixMaps=CreateFixationMaps(fixations,Paths,Param)
%the fixation maps are calculated according to:
%Le Meur, O., & Baccino, T. (2013). Methods for comparing scanpaths and saliency maps: strengths and weaknesses. Behavior research methods, 45(1), 251-266.?
%chapter: from a discrete fixation map to a continous saliency map

%Parameters
saveImages=1;
plotFlag=0;
sigma=Param.pixels_per_vdegree/2;

%check the save fixation maps folder exists and empty
if saveImages
    checkDirExistAndEmpty(Paths.FixationMapsPath);
end

for ii=1:size(fixations,2) %images
    FixMaps(ii).img=fixations(ii).img;
    for kk=1:size(fixations(ii).condition,2) %conditions
        clear mapPerIm fixMapPerIm
        if kk==1
            COND='U';
        elseif kk==2
            COND='C';
        end
        if ~isempty(fixations(ii).condition(kk).subject)
            for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
                FixMaps(ii).condition(kk).subject(jj).subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
                FixMaps(ii).condition(kk).subject(jj).TrialNumberOverall=fixations(ii).condition(kk).subject(jj).TrialNumberOverall;
                
                ImSize=ceil([fixations(ii).condition(kk).subject(jj).processed.rect(4),fixations(ii).condition(kk).subject(jj).processed.rect(3)]);
                %initialize map
                mapPerImAndSubj=zeros(ImSize);
                
                fix_h=fixations(ii).condition(kk).subject(jj).processed.fix_h_final;
                fix_w=fixations(ii).condition(kk).subject(jj).processed.fix_w_final;

                for aa=1:length(fix_h) %fixations
                    height=fix_h(aa);
                    width=fix_w(aa);
                    
                    temp_map=zeros(ImSize);
                    temp_map(height,width)=1;
                    mapPerImAndSubj=mapPerImAndSubj+temp_map; %if a pixel was fixated more than once its value will be bigger than 1 therefore this is not a binary map.
                end
                %add to FixMaps fixation map for each image and observer (not binary map)
                FixMaps(ii).condition(kk).subject(jj).mapPerImAndSubj=mapPerImAndSubj;
                
                %create fixation map for each image across all observers
                if jj==1
                    mapPerIm=mapPerImAndSubj;
                else
                    mapPerIm=mapPerIm+mapPerImAndSubj;
                end
            end
            
            mapPerIm=mapPerIm./size(fixations(ii).condition(kk).subject,2);
            fixMapPerIm = imgaussfilt(mapPerIm,sigma,'Padding','symmetric');
            
            %save maps
            FixMaps(ii).condition(kk).fixMapPerIm=fixMapPerIm;
            if saveImages
                ind=find('.'==fixations(ii).img);
                savename=[fixations(ii).img(1:(ind-1)),COND,'.mat'];
                save([Paths.FixationMapsPath,'\',savename],'fixMapPerIm')
            end
        else
            FixMaps(ii).condition(kk).subject=[];
            FixMaps(ii).condition(kk).fixMapPerIm=[];
        end
    end
    
    if plotFlag
        %create figure
        figure
        if ~isempty(fixations(ii).condition(1).subject)
            subplot(2,2,1)
            imagesc(FixMaps(ii).condition(1).fixMapPerIm)
            title(['U fixation map, N= ',num2str(size(FixMaps(ii).condition(1).subject,2))])
            
            subplot(2,2,3)
            I=imread([Paths.ImagesFolder,'\',fixations(ii).img]);
            I=imresize(I,ImSize);
            imagesc(I)
            title('Original image')
        end
        
        if ~isempty(fixations(ii).condition(2).subject)
            subplot(2,2,2)
            imagesc(FixMaps(ii).condition(2).fixMapPerIm)
            title(['C fixation map, N= ',num2str(size(FixMaps(ii).condition(2).subject,2))])
            
            subplot(2,2,4)
            I=imread([Paths.ImagesFolder,'\',fixations(ii).img]);
            I=imresize(I,ImSize);
            imagesc(I)
            title('Original image')
        end
    end
end
end