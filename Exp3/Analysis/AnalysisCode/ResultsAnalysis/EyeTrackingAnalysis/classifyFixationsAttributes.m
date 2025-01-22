function AttributesResults=classifyFixationsAttributes(ObjectsResults,fixations,Param,attrs)
%comment: sometimes in objs{}.features some of the features are not 1 they
%can be 2 and 3. This is not used and the features vector is changed to logical 
%when counting attributes

%load OSIE objects
for aa=1:size(attrs,1) %images
    ImgNamesAttr{aa}=attrs{aa}.img;
end

imsize=ceil([fixations(1).condition(1).subject(1).processed.rect(4),fixations(1).condition(1).subject(1).processed.rect(3)]);

for ii=1:size(ObjectsResults.image,2) %images
    AttributesResults.image(ii).imageName=ObjectsResults.image(ii).imageName;
    indImAttr=find(strcmp(ObjectsResults.image(ii).imageName,ImgNamesAttr));
    objs = attrs{indImAttr}.objs;
    
    %calculate number of pixels per attribute
    [AttributesResults.image(ii).PixelsInAtt,AttributesResults.image(ii).PixelsNoAtt]=findAttributePixels(objs,Param,imsize);
    
    %% real data
    for kk=1:size(ObjectsResults.image(ii).condition,2) %conditions
        for jj=1:size(ObjectsResults.image(ii).condition(kk).subject,2) %subjects
            AttributesResults.image(ii).condition(kk).subject(jj).subjNum=ObjectsResults.image(ii).condition(kk).subject(jj).subjNum;

            % arrange fixation object data according to attributes
            countFixObj=ObjectsResults.image(ii).condition(kk).subject(jj).countFixObj;
            fixDurObj=ObjectsResults.image(ii).condition(kk).subject(jj).fixDurObj;
            
            %fixations on objects with attributes
            [countFixAtt,fixDurAtt,countFixNoAtt,fixDurNoAtt]=arrangeObjDataToAtt(countFixObj,fixDurObj,objs);
            
            %save results
            AttributesResults.image(ii).condition(kk).subject(jj).countFixAtt=countFixAtt;
            AttributesResults.image(ii).condition(kk).subject(jj).fixDurAtt=fixDurAtt;
            AttributesResults.image(ii).condition(kk).subject(jj).countFixNoAtt=countFixNoAtt;
            AttributesResults.image(ii).condition(kk).subject(jj).fixDurNoAtt=fixDurNoAtt;
        end
        
        %calcaultions per attribute
        AttributesResults=calculationsAttributePerImage(AttributesResults,ii,kk,'Real',[]);
    end
    
    %% shuffled data
    if Param.shuffledDataFlag
        for nn=1:size(ObjectsResults.shuffled,2) %iterations
            AttributesResults.shuffled(nn).image(ii).imageName=ObjectsResults.shuffled(nn).image(ii).imageName;
            
            for kk=1:size(ObjectsResults.image(ii).condition,2) %conditions
                for jj=1:size(ObjectsResults.image(ii).condition(kk).subject,2) %subjects
                    AttributesResults.shuffled(nn).image(ii).condition(kk).subject(jj).subjNum=ObjectsResults.shuffled(nn).image(ii).condition(kk).subject(jj).subjNum;
                    
                    % arrange fixation object data according to attributes
                    countFixObj=ObjectsResults.shuffled(nn).image(ii).condition(kk).subject(jj).countFixObj;
                    fixDurObj=ObjectsResults.shuffled(nn).image(ii).condition(kk).subject(jj).fixDurObj;
                    
                    %fixations on objects with attributes
                    [countFixAtt,fixDurAtt,countFixNoAtt,fixDurNoAtt]=arrangeObjDataToAtt(countFixObj,fixDurObj,objs);
                    
                    %save results
                    AttributesResults.shuffled(nn).image(ii).condition(kk).subject(jj).countFixAtt=countFixAtt;
                    AttributesResults.shuffled(nn).image(ii).condition(kk).subject(jj).fixDurAtt=fixDurAtt;
                    AttributesResults.shuffled(nn).image(ii).condition(kk).subject(jj).countFixNoAtt=countFixNoAtt;
                    AttributesResults.shuffled(nn).image(ii).condition(kk).subject(jj).fixDurNoAtt=fixDurNoAtt;
                end
                
                %calcaultions per attribute
                AttributesResults=calculationsAttributePerImage(AttributesResults,ii,kk,'Shuffled',nn);
            end
        end
    end
end