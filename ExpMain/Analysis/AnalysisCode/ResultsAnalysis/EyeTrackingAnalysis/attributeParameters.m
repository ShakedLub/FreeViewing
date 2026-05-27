function AttributesResults=attributeParameters(ObjectsResults,AttributesResults,fixationsControlBank,attrs,ImgNamesAttr,attrNames,nn,Flag)
%baseline procedure is based on Abeles,Amit & Yuval-Greenberg, 2018 the
%biased observer.
%The fixatons are drawn with return because we want to
%create in each shuffle the same structure of images as the real data and
%the control trials include less trials than the image trials.
%draw the data randomaly for each region

for ii=1:size(ObjectsResults.image,2) %images
    switch Flag
        case 'Real'
            indImAttr=find(strcmp(ObjectsResults.image(ii).imageName,ImgNamesAttr));
            objs = attrs{indImAttr}.objs;
    end
    
    %arrange objects according to attributes
    for kk=1:size(ObjectsResults.image(ii).condition,2) %conditions
        for jj=1:size(ObjectsResults.image(ii).condition(kk).subject,2) %subjects
            %initialize attribute cell
            AttFixDur=cell(1,length(attrNames));
            NoAttFixDur=[];
            AttFixVel=cell(1,length(attrNames));
            NoAttFixVel=[];
            
            switch Flag
                case 'Real'
                    ObjFixDur=ObjectsResults.image(ii).condition(kk).subject(jj).ObjFixDur;
                    ObjFixVel=ObjectsResults.image(ii).condition(kk).subject(jj).ObjFixVel;
                    
                    %fixations on objects with attributes
                    for oo=1:length(ObjFixDur) %objects
                        if ~isempty(ObjFixDur{oo})
                            Dur=ObjFixDur{oo};
                            Vel=ObjFixVel{oo};
                            ObjAttributes=find(objs{oo}.features);
                            if ~isempty(ObjAttributes)
                                for aa=1:length(ObjAttributes)
                                    AttFixDur{ObjAttributes(aa)}=[AttFixDur{ObjAttributes(aa)},Dur];
                                    AttFixVel{ObjAttributes(aa)}=[AttFixVel{ObjAttributes(aa)},Vel];
                                end
                            else
                                NoAttFixDur=[NoAttFixDur,Dur];
                                NoAttFixVel=[NoAttFixVel,Vel];
                            end
                        end
                    end
                case 'Shuffled'
                    BackgroundFixDur=[];
                    BackgroundFixVel=[];
                    
                    subjNum=ObjectsResults.image(ii).condition(kk).subject(jj).subjNum;
                    indSubj=find([fixationsControlBank.subjNum]==subjNum);
                    
                    %draw the data randomaly for each attribute for object with no attribute and for background fixations
                    nAtt=length([AttributesResults.image(ii).condition(kk).subject(jj).AttFixDur{:}]);
                    nNoAtt=length(AttributesResults.image(ii).condition(kk).subject(jj).NoAttFixDur);
                    nBackground=length(ObjectsResults.image(ii).condition(kk).subject(jj).BackgroundFixDur);
                    n=nAtt+nNoAtt+nBackground;
                    if length(fixationsControlBank(indSubj).condition(kk).fix_w_final) >= n
                        indFix=randperm(length(fixationsControlBank(indSubj).condition(kk).fix_w_final),n);
                    else
                        div=floor(n/length(fixationsControlBank(indSubj).condition(kk).fix_w_final));
                        indFix=[];
                        for dd=1:(div+1)
                            if dd~=(div+1)
                                indFix=[indFix,randperm(length(fixationsControlBank(indSubj).condition(kk).fix_w_final))];
                            else
                                nrem=rem(n,length(fixationsControlBank(indSubj).condition(kk).fix_w_final));
                                indFix=[indFix,randperm(length(fixationsControlBank(indSubj).condition(kk).fix_w_final),nrem)];
                            end
                        end
                        indFix=indFix(randperm(length(indFix)));
                    end
                    
                    %data for attribute
                    for aa=1:length(AttributesResults.image(ii).condition(kk).subject(jj).AttFixDur)
                        indFixAtt=indFix(1:length(AttributesResults.image(ii).condition(kk).subject(jj).AttFixDur{aa}));
                        
                        AttFixDur{aa}=fixationsControlBank(indSubj).condition(kk).fix_duration_final(indFixAtt);
                        AttFixVel{aa}=fixationsControlBank(indSubj).condition(kk).fix_vel_final(indFixAtt);
                        
                        indFix(1:length(AttributesResults.image(ii).condition(kk).subject(jj).AttFixDur{aa}))=[];
                    end
                    %data for objects with no attribute
                    indFixNoAtt=indFix(1:nNoAtt);
                    NoAttFixDur=fixationsControlBank(indSubj).condition(kk).fix_duration_final(indFixNoAtt);
                    NoAttFixVel=fixationsControlBank(indSubj).condition(kk).fix_vel_final(indFixNoAtt);
                    indFix(1:nNoAtt)=[];
                    
                    %data for background fixations
                    BackgroundFixDur=fixationsControlBank(indSubj).condition(kk).fix_duration_final(indFix);
                    BackgroundFixVel=fixationsControlBank(indSubj).condition(kk).fix_vel_final(indFix);
            end
            switch Flag
                case 'Real'
                    %save data objects with attributes and without
                    %duration
                    AttributesResults.image(ii).condition(kk).subject(jj).AttFixDur=AttFixDur;
                    AttributesResults.image(ii).condition(kk).subject(jj).NoAttFixDur=NoAttFixDur;
                    %velocity
                    AttributesResults.image(ii).condition(kk).subject(jj).AttFixVel=AttFixVel;
                    AttributesResults.image(ii).condition(kk).subject(jj).NoAttFixVel=NoAttFixVel;
                    
                    %caluclate parameters objects with attributes and without
                    %duration
                    AttributesResults.image(ii).condition(kk).subject(jj).meanAttFixDurPerSubj=cellfun(@mean,AttFixDur); %average on all fixations on attributes per subj
                    AttributesResults.image(ii).condition(kk).matMeanAttFixDurPerSubj(jj,:)=cellfun(@mean,AttFixDur);
                    AttributesResults.image(ii).condition(kk).subject(jj).meanNoAttFixDurPerSubj=mean(NoAttFixDur); %average on all fixations on objects with no attributes per subj
                    
                    %velocity
                    AttributesResults.image(ii).condition(kk).subject(jj).meanAttFixVelPerSubj=cellfun(@mean,AttFixVel); %average on all fixations on attributes per subj
                    AttributesResults.image(ii).condition(kk).matMeanAttFixVelPerSubj(jj,:)=cellfun(@mean,AttFixVel);
                    AttributesResults.image(ii).condition(kk).subject(jj).meanNoAttFixVelPerSubj=mean(NoAttFixVel); %average on all fixations on objects with no attributes per subj
                    
                    %save calculated data from ObjectsResults for fixations on background
                    %duration
                    AttributesResults.image(ii).condition(kk).subject(jj).meanBackgroundFixDurPerSubj=ObjectsResults.image(ii).condition(kk).subject(jj).meanBackgroundFixDurPerSubj; %average on all background fixations per subj
                    %velocity
                    AttributesResults.image(ii).condition(kk).subject(jj).meanBackgroundFixVelPerSubj=ObjectsResults.image(ii).condition(kk).subject(jj).meanBackgroundFixVelPerSubj; %average on all background fixations per subj                    
                case 'Shuffled'
                    %save data 
                    %duration
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).AttFixDur=AttFixDur;
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).NoAttFixDur=NoAttFixDur;
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).BackgroundFixDur=BackgroundFixDur;

                    %velocity
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).AttFixVel=AttFixVel;
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).NoAttFixVel=NoAttFixVel;
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).BackgroundFixVel=BackgroundFixVel;

                    %caluclate parameters 
                    %duration
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).meanAttFixDurPerSubj=cellfun(@mean,AttFixDur); %average on all fixations on attributes per subj
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).matMeanAttFixDurPerSubj(jj,:)=cellfun(@mean,AttFixDur);
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).meanNoAttFixDurPerSubj=mean(NoAttFixDur); %average on all fixations on objects with no attributes per subj
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).meanBackgroundFixDurPerSubj=mean(BackgroundFixDur); %average on all fixations on the background per subj
                    
                    %velocity
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).meanAttFixVelPerSubj=cellfun(@mean,AttFixVel); %average on all fixations on attributes per subj
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).matMeanAttFixVelPerSubj(jj,:)=cellfun(@mean,AttFixVel);
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).meanNoAttFixVelPerSubj=mean(NoAttFixVel); %average on all fixations on objects with no attributes per subj
                    AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject(jj).meanBackgroundFixVelPerSubj=mean(BackgroundFixVel); %average on all fixations on the background per subj
            end
        end
        switch Flag
            case 'Real'
                %duration
                AttributesResults.summary(kk).matMeanAttFixDurPerImage(ii,:)=nanmean(AttributesResults.image(ii).condition(kk).matMeanAttFixDurPerSubj); %average on all subjects with fixations on attribute
                AttributesResults.summary(kk).meanNoAttFixDurPerImage(ii)=nanmean([AttributesResults.image(ii).condition(kk).subject.meanNoAttFixDurPerSubj]); %average on all subjects with fixations on objects with no attribute
                AttributesResults.summary(kk).meanBackgroundFixDurPerImage(ii)=nanmean([AttributesResults.image(ii).condition(kk).subject.meanBackgroundFixDurPerSubj]); %average on all subjects with fixations on background
                %velocity
                AttributesResults.summary(kk).matMeanAttFixVelPerImage(ii,:)=nanmean(AttributesResults.image(ii).condition(kk).matMeanAttFixVelPerSubj); %average on all subjects with fixations on attribute
                AttributesResults.summary(kk).meanNoAttFixVelPerImage(ii)=nanmean([AttributesResults.image(ii).condition(kk).subject.meanNoAttFixVelPerSubj]); %average on all subjects with fixations on objects with no attribute
                AttributesResults.summary(kk).meanBackgroundFixVelPerImage(ii)=nanmean([AttributesResults.image(ii).condition(kk).subject.meanBackgroundFixVelPerSubj]); %average on all subjects with fixations on background
            case 'Shuffled'
                %duration
                AttributesResults.shuffledControl(nn).summary(kk).matMeanAttFixDurPerImage(ii,:)=nanmean(AttributesResults.shuffledControl(nn).image(ii).condition(kk).matMeanAttFixDurPerSubj); %average on all subjects with fixations on attribute
                AttributesResults.shuffledControl(nn).summary(kk).meanNoAttFixDurPerImage(ii)=nanmean([AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject.meanNoAttFixDurPerSubj]); %average on all subjects with fixations on objects with no attribute
                AttributesResults.shuffledControl(nn).summary(kk).meanBackgroundFixDurPerImage(ii)=nanmean([AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject.meanBackgroundFixDurPerSubj]); %average on all subjects with fixations on background
                %velocity
                AttributesResults.shuffledControl(nn).summary(kk).matMeanAttFixVelPerImage(ii,:)=nanmean(AttributesResults.shuffledControl(nn).image(ii).condition(kk).matMeanAttFixVelPerSubj); %average on all subjects with fixations on attribute
                AttributesResults.shuffledControl(nn).summary(kk).meanNoAttFixVelPerImage(ii)=nanmean([AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject.meanNoAttFixVelPerSubj]); %average on all subjects with fixations on objects with no attribute
                AttributesResults.shuffledControl(nn).summary(kk).meanBackgroundFixVelPerImage(ii)=nanmean([AttributesResults.shuffledControl(nn).image(ii).condition(kk).subject.meanBackgroundFixVelPerSubj]); %average on all subjects with fixations on background               
        end
    end
end
for kk=1:size(AttributesResults.summary,2) %conditions
    switch Flag
        case 'Real'
            %duration
            AttributesResults.summary(kk).meanAttFixDur=nanmean(AttributesResults.summary(kk).matMeanAttFixDurPerImage); %average on all images with fixations on attributes
            AttributesResults.summary(kk).meanNoAttFixDur=nanmean(AttributesResults.summary(kk).meanNoAttFixDurPerImage); %average on all images with fixations on objects with no attributes
            AttributesResults.summary(kk).meanBackgroundFixDur=nanmean(AttributesResults.summary(kk).meanBackgroundFixDurPerImage); %average on all images with fixations on background
            %velocity
            AttributesResults.summary(kk).meanAttFixVel=nanmean(AttributesResults.summary(kk).matMeanAttFixVelPerImage); %average on all images with fixations on attributes
            AttributesResults.summary(kk).meanNoAttFixVel=nanmean(AttributesResults.summary(kk).meanNoAttFixVelPerImage); %average on all images with fixations on objects with no attributes
            AttributesResults.summary(kk).meanBackgroundFixVel=nanmean(AttributesResults.summary(kk).meanBackgroundFixVelPerImage); %average on all images with fixations on background
        case 'Shuffled'
            %duration
            AttributesResults.shuffledControl(nn).summary(kk).meanAttFixDur=nanmean(AttributesResults.shuffledControl(nn).summary(kk).matMeanAttFixDurPerImage); %average on all images with fixations on attributes
            AttributesResults.shuffledControl(nn).summary(kk).meanNoAttFixDur=nanmean(AttributesResults.shuffledControl(nn).summary(kk).meanNoAttFixDurPerImage); %average on all images with fixations on objects with no attributes
            AttributesResults.shuffledControl(nn).summary(kk).meanBackgroundFixDur=nanmean(AttributesResults.shuffledControl(nn).summary(kk).meanBackgroundFixDurPerImage); %average on all images with fixations on background
            %velocity
            AttributesResults.shuffledControl(nn).summary(kk).meanAttFixVel=nanmean(AttributesResults.shuffledControl(nn).summary(kk).matMeanAttFixVelPerImage); %average on all images with fixations on attributes
            AttributesResults.shuffledControl(nn).summary(kk).meanNoAttFixVel=nanmean(AttributesResults.shuffledControl(nn).summary(kk).meanNoAttFixVelPerImage); %average on all images with fixations on objects with no attributes
            AttributesResults.shuffledControl(nn).summary(kk).meanBackgroundFixVel=nanmean(AttributesResults.shuffledControl(nn).summary(kk).meanBackgroundFixVelPerImage); %average on all images with fixations on background
    end
end
end