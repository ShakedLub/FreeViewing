function Results=classifyFixationsObjects(fixations,Paths,Param,attrs,attrNames)
%calculation based on  "Predicting human gaze beyond pixels," Journal of Vision, 2014
% Juan Xu, Ming Jiang, Shuo Wang, Mohan Kankanhalli, Qi Zhao

%Parameters
indDel=[];
imsize=ceil([fixations(1).condition(1).subject(1).processed.rect(4),fixations(1).condition(1).subject(1).processed.rect(3)]);
plotFlag=0;

%create center bias mask
if Param.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,imsize);
end

%load OSIE objects
for aa=1:size(attrs,1) %images
    ImgNamesAttr{aa}=attrs{aa}.img;
end

for ii=1:size(fixations,2) %images
    Results.image(ii).imageName=fixations(ii).img;
    
    indImAttr=find(strcmp(Results.image(ii).imageName,ImgNamesAttr));
    
    %% calculations on objects in image ii
    objs = attrs{indImAttr}.objs;
    
    %initialize object variables
    mapObj=zeros(imsize); %map objects with attributes
    mapObjNoAtt=zeros(imsize); %map objects with no attributes
    mapAllObj=zeros(imsize); %map all objects
    numAttIm=zeros(1,length(attrNames)); %all attributes that appear in the image
    objNoAtt=zeros(1,size(objs,1)); %objects that don't have attributes
    
    %calcualte objs centers and change the binarized image to the correct size
    for o = 1:size(objs,1) %objects
        objs{o}.bw=imresize(objs{o}.map, imsize);
        label = im2double(objs{o}.bw);
        label(~objs{o}.bw) = 2; %change image to 1 and 2
        st = regionprops(label, {'Centroid'});
        objs{o}.ObjCenter = st.Centroid; %1 is width, 2 is height
        if Param.RemoveCenterBias
            objs{o}.bw= CenterBiasMask & objs{o}.bw;
        end
        objs{o}.numPixObj=sum(sum(objs{o}.bw));
        objNoAtt(o)=all(objs{o}.features==0);
        if objNoAtt(o)==1
            mapObjNoAtt=mapObjNoAtt+objs{o}.bw;
        else
            mapObj=mapObj+objs{o}.bw;
        end
        mapAllObj=mapAllObj+objs{o}.bw;
        numAttIm=numAttIm+logical(objs{o}.features);
    end
    mapObj=logical(mapObj);
    Results.image(ii).numPixObj=sum(sum(mapObj));
    
    mapObjNoAtt=logical(mapObjNoAtt);
    Results.image(ii).numPixObjNoAtt=sum(sum(mapObjNoAtt));
    
    mapAllObj=logical(mapAllObj);
    Results.image(ii).numPixAllObj=sum(sum(mapAllObj));
    
    if Param.RemoveCenterBias
        Results.image(ii).numPixBg=sum(sum(CenterBiasMask))-sum(sum(mapAllObj));
    else
        Results.image(ii).numPixBg=sum(sum(~mapAllObj));
    end
    Results.image(ii).numAttIm=numAttIm;
    Results.image(ii).AttInIm=logical(numAttIm);
    Results.image(ii).objNoAtt=logical(objNoAtt);
    
    %% real data
    for kk=1:size(fixations(ii).condition,2) %conditions
        for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
            Results.image(ii).condition(kk).subject(jj).subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
            
            %initiate fixation classification
            count.objectClass=[];
            %initiate counts variables
            count.countFixObj=zeros(1,size(objs,1));
            count.countFixBg=0;
            count.countFix=0;
            %initiate duration variables
            count.fixDurObj=cell(1,size(objs,1));
            count.fixDurBg=[];
            
            %fixations
            fix_h=fixations(ii).condition(kk).subject(jj).processed.fix_h_final;
            fix_w=fixations(ii).condition(kk).subject(jj).processed.fix_w_final;
            durations=fixations(ii).condition(kk).subject(jj).processed.fix_duration_final;
            
            for aa=1:length(fix_h) %fixations
                centerW = fix_w(aa);
                centerH = fix_h(aa);
                dur=durations(aa);
                
                count=classifyFixObj(count,centerH,centerW,dur,imsize,objs,Param);
            end
            
            %Save count
            %fixation classification
            Results.image(ii).condition(kk).subject(jj).objectClass=count.objectClass;
            %fixation ID (0-background, 1-object with att, 2-object no att)
            fixID=zeros(1,length(count.objectClass));
            fixID(~isnan(count.objectClass))=1;
            fixID(ismember(count.objectClass,find(Results.image(ii).objNoAtt)))=2;
            Results.image(ii).condition(kk).subject(jj).fixID=fixID;
            Results.image(ii).condition(kk).subject(jj).fixDurations=durations;
            %fixation count
            Results.image(ii).condition(kk).subject(jj).countFixObj=count.countFixObj;
            Results.image(ii).condition(kk).subject(jj).countFixBg=count.countFixBg;
            Results.image(ii).condition(kk).subject(jj).countFix=count.countFix;
            %fixation duration
            Results.image(ii).condition(kk).subject(jj).fixDurObj=count.fixDurObj;
            Results.image(ii).condition(kk).subject(jj).fixDurBg=count.fixDurBg;
        end
        
        Results=calculationsObjectsPerImage(Results,ii,kk,'Real',[],Param);
    end
    
    if plotFlag
        plotFixationsObjects(ii,fixations,Results,objs,Param,Paths)
    end
    
    %% shuffled data
    if Param.shuffledDataFlag
        for nn=1:Param.Nrepetitions %num repetitions
            Results.shuffled(nn).image(ii).imageName=fixations(ii).img;
            for kk=1:size(fixations(ii).shuffled(nn).condition,2)
                for jj=1:size(fixations(ii).shuffled(nn).condition(kk).subject,2) %subjects
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
                    
                    %initiate fixation classification
                    count.objectClass=[];
                    %initiate counts variables
                    count.countFixObj=zeros(1,size(objs,1));
                    count.countFixBg=0;
                    count.countFix=0;
                    %initiate duration variables
                    count.fixDurObj=cell(1,size(objs,1));
                    count.fixDurBg=[];
                    
                    %shuffled fixations
                    fix_w=fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_w_final;
                    fix_h=fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_h_final;
                    durations=fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_duration_final;
                    
                    for aa=1:length(fix_h) %fixations
                        centerW = fix_w(aa);
                        centerH = fix_h(aa);
                        dur=durations(aa);
                        
                        count=classifyFixObj(count,centerH,centerW,dur,imsize,objs,Param);
                    end
                    
                    %Save count
                    %fixation classification
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).objectClass=count.objectClass;
                    %fixation ID (0-background, 1-object with att, 2-object no att)
                    fixID=zeros(1,length(count.objectClass));
                    fixID(~isnan(count.objectClass))=1;
                    fixID(ismember(count.objectClass,find(Results.image(ii).objNoAtt)))=2;
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).fixID=fixID;
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).fixDurations=durations;
                    %fixation count
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).countFixObj=count.countFixObj;
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).countFixBg=count.countFixBg;
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).countFix=count.countFix;
                    %fixation duration
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).fixDurObj=count.fixDurObj;
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).fixDurBg=count.fixDurBg;
                end
                
                Results=calculationsObjectsPerImage(Results,ii,kk,'Shuffled',nn,Param);
            end
        end
    end
end
end