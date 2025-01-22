function addPersonsToAttributesManuallyFix(Paths,imgName)
%Combine person dataset and OSIE dataset, with the user manually looking on
%each match
close all

%Parameters
indPerson=10;
minimalOverlapPercent=15;
plotFlag=0;

%load from pile up design parameters
pileupfileName=['pileup_U_401.mat'];
load([Paths.PileupFolder,'\',pileupfileName],'DESIGN_PARAM')
ImNames=DESIGN_PARAM.Image_Names_Experiment;

%loadAttrsCombined
load('AttrsCombinedFinal.mat')
attrsFinal=attrs;
attrNamesFinal=attrNames;
clear attrs attrNames

%load OSIE People objects
load([Paths.OSIEPeople,'\attrsPerson_600_by_800.mat']);
for aa=1:size(attrs,1) %images
    ImgNamesAttrP{aa}=attrs{aa}.img;
end
attrsP=attrs;
attrNamesP=attrNames;
clear attrs attrNames

%load OSIE objects
load([Paths.OSIEObjects,'\attrs.mat']);
for aa=1:size(attrs,1) %images
    ImgNamesAttr{aa}=attrs{aa}.img;
end

%Add person attribute to names
newPersonAtt=length(attrNames)+1;
attrNames=attrNamesFinal;

%make sure the image order is the same in both attrs datasets
if ~isequal(ImgNamesAttrP,ImgNamesAttr)
    error('Problem with attribute datasets the images are not the same')
end

numPersonObj=0;
numPersonObjFound=0;
numPersonObjAdded=0;
found_person_objects_ind_person=[];
found_person_objects_ind_OSIE=[];

indImAttr=find(strcmp(imgName,ImgNamesAttr));

%add 0 in person attribute for all objects
for oo=1:size(attrs{indImAttr}.objs) %objects in attrs
    attrs{indImAttr}.objs{oo}.features(newPersonAtt)=0;
end

if isfield(attrsP{indImAttr},'objs') %Image with people
    for op=1:size(attrsP{indImAttr}.objs) %objects in attrs people
        PersonObjectFound=0;
        if (attrsP{indImAttr}.objs{op}.features(indPerson)==1) %if this is a person object
            numPersonObj=numPersonObj+1;
            
            %check if there are objects overlapping this object in attrs
            %arrange overlapping objects according to overlap size
            OverlapSize=[];
            for oo=1:size(attrs{indImAttr}.objs) %objects in attrs
                OverlapSize(oo)=sum(sum(logical(attrs{indImAttr}.objs{oo}.map) & logical(attrsP{indImAttr}.objs{op}.map)));
            end
            [~,OrderOfOverlappingObj]=sort(OverlapSize,'descend');
            
            for aa=1:length(OrderOfOverlappingObj) %objects in attrs
                oo=OrderOfOverlappingObj(aa);
                OverlapSize=sum(sum(logical(attrs{indImAttr}.objs{oo}.map) & logical(attrsP{indImAttr}.objs{op}.map)));
                PersonSize=sum(sum(attrsP{indImAttr}.objs{op}.map));
                if (OverlapSize/PersonSize)*100 >= minimalOverlapPercent
                    figure
                    set(gcf, 'Position', get(0, 'Screensize'));
                    
                    subplot(2,3,4)
                    I=imread([Paths.ImagesFolder,'\',imgName]);
                    imshow(I)
                    title(imgName)
                    
                    subplot(2,3,5)
                    imagesc(I,'AlphaData',0.4)
                    hold on
                    imagesc(logical(attrsP{indImAttr}.objs{op}.map),'AlphaData',0.4)
                    title(['Person Object: number ',num2str(op)])
                    hold off
                    
                    subplot(2,3,6)
                    imagesc(I,'AlphaData',0.4)
                    hold on
                    imagesc(logical(attrs{indImAttr}.objs{oo}.map),'AlphaData',0.4)
                    title(['OSIE Object: number ',num2str(oo)])
                    hold off
                    
                    %open dialog box
                    user_response = questdlg('Is this the same object?','Question','Yes','No','Exit','Yes');
                    
                    close all
                    if strcmp(user_response,'Yes')
                        %change person attribute to 1 in the selected object
                        attrs{indImAttr}.objs{oo}.features(newPersonAtt)=1;
                        %change map to be overlapping area between the
                        %two classification, except for:
                        %image 1433.jpg which is wrong in OSIE and correct in Persons
                        %image 1357.jpg which marks the two arms together in Persons and sperattly in OSIE which makes more sense for analysis
                        switch imgName
                            case '1433.jpg'
                                attrs{indImAttr}.objs{oo}.map=logical(attrsP{indImAttr}.objs{op}.map);
                            otherwise
                                attrs{indImAttr}.objs{oo}.map=logical(attrs{indImAttr}.objs{oo}.map) | logical(attrsP{indImAttr}.objs{op}.map);
                        end
                        PersonObjectFound=1;
                        numPersonObjFound=numPersonObjFound+1;
                        found_person_objects_ind_person(numPersonObjFound)=op;
                        found_person_objects_ind_OSIE(numPersonObjFound)=oo;
                        break
                    elseif strcmp(user_response,'No')
                        switch imgName
                            case '1357.jpg'
                                %change person attribute to 1 in the
                                %selected objects
                                attrs{indImAttr}.objs{1}.features(newPersonAtt)=1;
                                attrs{indImAttr}.objs{2}.features(newPersonAtt)=1;
                                PersonObjectFound=1;
                                numPersonObjFound=1;
                                found_person_objects_ind_person=3;
                                found_person_objects_ind_OSIE=[1 2];
                                break
                        end
                    elseif strcmp(user_response,'Exit')
                        error('Process has stopped')
                    end
                end
            end
            if  PersonObjectFound==0
                %add object with person to OSIE as a new object
                attrs{indImAttr}.objs{end+1}.map=logical(attrsP{indImAttr}.objs{op}.map);
                attrs{indImAttr}.objs{end}.features=zeros(1,newPersonAtt);
                attrs{indImAttr}.objs{end}.features(newPersonAtt)=1;
                numPersonObjAdded=numPersonObjAdded+1;
            end
        end
    end
end
indCombiningData=strcmp(imgName,{combiningData.ImName});
combiningData(indCombiningData).numPersonObj=numPersonObj;
combiningData(indCombiningData).numPersonObjFound=numPersonObjFound;
combiningData(indCombiningData).numPersonObjAdded=numPersonObjAdded;
combiningData(indCombiningData).found_person_objects_ind_person_dataset=found_person_objects_ind_person;
combiningData(indCombiningData).found_person_objects_ind_OSIE_dataset=found_person_objects_ind_OSIE;

if plotFlag
    figure
    for kk = 1 : size(attrs{indImAttr}.objs,1) %objects
        subplot(ceil(sqrt(size(attrs{indImAttr}.objs,1)+1)),ceil(sqrt(size(attrs{indImAttr}.objs,1)+1)),kk)
        imshow(attrs{indImAttr}.objs{kk}.map)
        title(['Obj OSIE number ',num2str(kk)])
    end
    
    subplot(ceil(sqrt(size(attrs{indImAttr}.objs,1)+1)),ceil(sqrt(size(attrs{indImAttr}.objs,1)+1)),kk+1)
    I=imread([Paths.ImagesFolder,'\',imgName]);
    imshow(I)
    title('Original image')
    
    figure
    for kk = 1 : size(attrsP{indImAttr}.objs,1) %objects
        subplot(ceil(sqrt(size(attrsP{indImAttr}.objs,1)+1)),ceil(sqrt(size(attrsP{indImAttr}.objs,1)+1)),kk)
        imshow(attrsP{indImAttr}.objs{kk}.map)
        title(['Obj Person number ',num2str(kk)])
    end
    
    subplot(ceil(sqrt(size(attrsP{indImAttr}.objs,1)+1)),ceil(sqrt(size(attrsP{indImAttr}.objs,1)+1)),kk+1)
    I=imread([Paths.ImagesFolder,'\',imgName]);
    imshow(I)
    title('Original image')
end

attrsFinal{indImAttr}=attrs{indImAttr};
attrs=attrsFinal;

%save attrs
save('AttrsCombined.mat','attrs','attrNames','combiningData','-v7.3')
end