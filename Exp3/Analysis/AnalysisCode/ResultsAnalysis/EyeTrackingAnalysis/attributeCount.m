function AttributesResults=attributeCount(ObjectsResults,attrs,ImgNamesAttr,attrNames)
%initialize attributes
for kk=1:size(ObjectsResults.image(1).condition,2) %conditions
    AttributesResults.summary(kk).countObjFix_Att=zeros(1,length(attrNames));
    
    AttributesResults.summary(kk).countObjFix_NoAtt=0;
    AttributesResults.summary(kk).countObjFix_OneAtt=0;
    AttributesResults.summary(kk).countObjFix_MoreOneAtt=0;
    AttributesResults.summary(kk).countBackgroundFix=0;
    
    AttributesResults.summary(kk).countAllFix=0; %=countObjFix_NoAtt+countObjFix_OneAtt+countObjFix_MoreOneAtt+countBackgroundFix;
    AttributesResults.summary(kk).countAllFixDuplications=0; %=sum(countObjFix_Att)+countObjFix_NoAtt+countBackgroundFix;
end

for ii=1:size(ObjectsResults.image,2) %images
    indImAttr=find(strcmp(ObjectsResults.image(ii).imageName,ImgNamesAttr));
    objs = attrs{indImAttr}.objs;
    
    for kk=1:size(ObjectsResults.image(ii).condition,2) %conditions
        %data per image
        AttributesResults.image(ii).condition(kk).countObjFix=ObjectsResults.image(ii).condition(kk).countObjFix;
        countObjFix= ObjectsResults.image(ii).condition(kk).countObjFix;
        
        %sum data
        %background fixations, also add the background fixations to all
        %fixations count
        AttributesResults.summary(kk).countBackgroundFix=AttributesResults.summary(kk).countBackgroundFix+ObjectsResults.countBackgroundFix(ii,kk);
        AttributesResults.summary(kk).countAllFix=AttributesResults.summary(kk).countAllFix+ObjectsResults.countBackgroundFix(ii,kk);
        AttributesResults.summary(kk).countAllFixDuplications=AttributesResults.summary(kk).countAllFixDuplications+ObjectsResults.countBackgroundFix(ii,kk);
        
        %object fixations
        for oo=1:size(objs,1) %objects
            countFixOnObj=countObjFix(oo);
            ObjAttributes=find(objs{oo}.features);
            if countFixOnObj~=0
                vec=logical(objs{oo}.features);
                AttributesResults.summary(kk).countObjFix_Att=AttributesResults.summary(kk).countObjFix_Att+(vec.*countFixOnObj);
                
                if isempty(ObjAttributes) %object without attributes
                    AttributesResults.summary(kk).countObjFix_NoAtt=AttributesResults.summary(kk).countObjFix_NoAtt+countFixOnObj;
                    numadd=countFixOnObj;
                elseif length(ObjAttributes)==1 %object with 1 attribute
                    AttributesResults.summary(kk).countObjFix_OneAtt=AttributesResults.summary(kk).countObjFix_OneAtt+countFixOnObj;
                    numadd=countFixOnObj;
                elseif length(ObjAttributes)>1 %object with more than 1 attribute
                    AttributesResults.summary(kk).countObjFix_MoreOneAtt=AttributesResults.summary(kk).countObjFix_MoreOneAtt+countFixOnObj;
                    numadd=countFixOnObj*length(ObjAttributes);
                end
                AttributesResults.summary(kk).countAllFix=AttributesResults.summary(kk).countAllFix+countFixOnObj;
                AttributesResults.summary(kk).countAllFixDuplications=AttributesResults.summary(kk).countAllFixDuplications+numadd;
            end
        end
    end
end

for kk=1:size(AttributesResults.summary,2) %conditions
    %check
    if AttributesResults.summary(kk).countAllFix ~= AttributesResults.summary(kk).countObjFix_NoAtt+AttributesResults.summary(kk).countObjFix_OneAtt+AttributesResults.summary(kk).countObjFix_MoreOneAtt+AttributesResults.summary(kk).countBackgroundFix
        error('Problem with fixations count')
    end
    if AttributesResults.summary(kk).countAllFixDuplications ~= sum(AttributesResults.summary(kk).countObjFix_Att)+AttributesResults.summary(kk).countObjFix_NoAtt+AttributesResults.summary(kk).countBackgroundFix
        error('Problem with fixations count')
    end
    
    % calculate percent attributes
    AttributesResults.summary(kk).percentObjFix_Att=AttributesResults.summary(kk).countObjFix_Att./AttributesResults.summary(kk).countAllFixDuplications;
    AttributesResults.summary(kk).percentObjFix_NoAtt=AttributesResults.summary(kk).countObjFix_NoAtt/AttributesResults.summary(kk).countAllFixDuplications;
    AttributesResults.summary(kk).percentBackgroundFix=AttributesResults.summary(kk).countBackgroundFix/AttributesResults.summary(kk).countAllFixDuplications;
end
end