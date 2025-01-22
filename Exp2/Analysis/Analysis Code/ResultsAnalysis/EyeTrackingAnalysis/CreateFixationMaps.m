function FixMaps=CreateFixationMaps(fixations,Paths,Param)
%the fixation maps are calculated according to:
%Le Meur, O., & Baccino, T. (2013). Methods for comparing scanpaths and saliency maps: strengths and weaknesses. Behavior research methods, 45(1), 251-266.?
%chapter: from a discrete fixation map to a continous saliency map

%subjects who viewed the image from 71 cm their fixations are created on
%maps the size they viewed the place holder on the screen and than this
%image is resized to the correct size and the fixation location is found

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
    clear mapPerIm fixMapPerIm
    if ~isempty(fixations(ii).subject)
        for jj=1:size(fixations(ii).subject,2) %subjects
            FixMaps(ii).subject(jj).subjNum=fixations(ii).subject(jj).subjNum;
            FixMaps(ii).subject(jj).TrialNumberOverall=fixations(ii).subject(jj).TrialNumberOverall;
                
            OrigImSize=ceil([fixations(ii).subject(jj).processed.rect(4),fixations(ii).subject(jj).processed.rect(3)]);
            %initialize map
            mapPerImAndSubj=zeros(Param.wantedImSize);
            
            if ~isequal(OrigImSize,Param.wantedImSize)
                mapPerImAndSubjOrig=zeros(OrigImSize); % for plot
                fix_h_new=[];
                fix_w_new=[];
            else
                mapPerImAndSubjOrig=[]; % for plot
                fix_h_new=[];
                fix_w_new=[];
            end
            
            fix_h=fixations(ii).subject(jj).processed.fix_h_final;
            fix_w=fixations(ii).subject(jj).processed.fix_w_final;
            
            for aa=1:length(fix_h) %fixations
                height=fix_h(aa);
                width=fix_w(aa);
                
                temp_map=zeros(OrigImSize);
                temp_map(height,width)=1;
                
                %Fix all maps to the same size as a stimulus that was seen from 70 cm away
                if ~isequal(OrigImSize,Param.wantedImSize)
                    mapPerImAndSubjOrig=mapPerImAndSubjOrig+temp_map; %for plot
                    
                    map = imresize(temp_map,Param.wantedImSize);
                    Allfix=find(map);
                    ColorIntensityfix=map(Allfix);
                    [~,indMaxIntensityFix]=max(ColorIntensityfix);
                    fix=Allfix(indMaxIntensityFix(1));
                    [y,x]=ind2sub(Param.wantedImSize,fix);
                    
                    temp_map=zeros(Param.wantedImSize);
                    temp_map(y,x)=1;
                    fix_h_new=[fix_h_new,y];
                    fix_w_new=[fix_w_new,x];
                end
                
                mapPerImAndSubj=mapPerImAndSubj+temp_map; %if a pixel was fixated more than once its value will be bigger than 1 therefore this is not a binary map.
            end
            
            %add to FixMaps fixation map for each image and observer (not binary map)
            FixMaps(ii).subject(jj).mapPerImAndSubj=mapPerImAndSubj;
            %add more data to FixMaps
            FixMaps(ii).subject(jj).OrigImSize=OrigImSize; 
            if ~isequal(OrigImSize,Param.wantedImSize)
                FixMaps(ii).subject(jj).fix_h=fix_h_new;
                FixMaps(ii).subject(jj).fix_w=fix_w_new;
            else
                FixMaps(ii).subject(jj).fix_h=fix_h;
                FixMaps(ii).subject(jj).fix_w=fix_w;
            end
            
            %create fixation map for each image across all observers
            if jj==1
                mapPerIm=mapPerImAndSubj;
            else
                mapPerIm=mapPerIm+mapPerImAndSubj;
            end
            
            if plotFlag
                %show fix
                I=imread([Paths.ImagesFolder,'\',fixations(ii).img]);
                INotFixed=imresize(I,OrigImSize);
                
                figure
                if ~isequal(OrigImSize,Param.wantedImSize)
                    IFixed=imresize(I,Param.wantedImSize);
                    
                    subplot(2,2,1)
                    imshowpair(INotFixed,imgaussfilt(mapPerImAndSubjOrig,sigma,'Padding','symmetric'))
                    title('Original image one subject')
                    
                    subplot(2,2,2)
                    imshowpair(IFixed,imgaussfilt(mapPerImAndSubj,sigma,'Padding','symmetric'))
                    title('Fixed image one subject')
                    
                    subplot(2,2,3)
                    imshow(mapPerImAndSubjOrig,[])

                    subplot(2,2,4)
                    imshow(mapPerImAndSubj,[])
                else
                    subplot(2,1,1)
                    imshowpair(INotFixed,imgaussfilt(mapPerImAndSubj,sigma,'Padding','symmetric'))
                    title('Original image one subject')
                    
                    subplot(2,1,2)
                    imshow(mapPerImAndSubj,[])
                end
            end
        end

        mapPerIm=mapPerIm./size(fixations(ii).subject,2);
        fixMapPerIm = imgaussfilt(mapPerIm,sigma,'Padding','symmetric');
        
        %save maps
        FixMaps(ii).fixMapPerIm=fixMapPerIm;
        if saveImages
            ind=find('.'==fixations(ii).img);
            savename=[fixations(ii).img(1:(ind-1)),'.mat'];
            save([Paths.FixationMapsPath,'\',savename],'fixMapPerIm')
        end
    else
        FixMaps(ii).subject=[];
        FixMaps(ii).fixMapPerIm=[];
    end
    
    if plotFlag
        %create figure
        figure;
        if ~isempty(fixations(ii).subject)
            I=imread([Paths.ImagesFolder,'\',fixations(ii).img]);
            I=imresize(I,Param.wantedImSize);
            imshowpair(I,FixMaps(ii).fixMapPerIm)
            title(['Fixation map, N= ',num2str(size(FixMaps(ii).subject,2))])
        end
    end
end
end