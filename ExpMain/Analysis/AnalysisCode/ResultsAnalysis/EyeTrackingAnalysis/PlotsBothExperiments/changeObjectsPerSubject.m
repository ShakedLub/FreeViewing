function Results_PerSubject=changeObjectsPerSubject(Results,fixations,subjNumber,Param)
conditions=size(Results.image(1).condition,2);
%Initialize Results_PerSubject
for ii=1:length(subjNumber) %subjects
    Results_PerSubject.subject(ii).subjNum=subjNumber(ii);
    for kk=1:conditions %conditions
        Results_PerSubject.subject(ii).condition(kk).trial=[];
    end
end
for nn=1:size(Results.shuffled,2)%repetitions
    for ii=1:length(subjNumber) %subjects
        Results_PerSubject.shuffled(nn).subject(ii).subjNum=subjNumber(ii);
        for kk=1:conditions %conditions
            Results_PerSubject.shuffled(nn).subject(ii).condition(kk).trial=[];
        end
    end
end

%Fill Results_PerSubject
for ii=1:size(Results.image,2) %images
    for kk=1:size(Results.image(ii).condition,2) %conditions
        for jj=1:size(Results.image(ii).condition(kk).subject,2)%subjects
            imageName=Results.image(ii).imageName;
            imageInd=find(strcmp(imageName,{fixations.img}));
            %subj Id
            subjN=fixations(imageInd).condition(kk).subject(jj).subjNum;
            ind=find(subjNumber==subjN);
            
            %add data to trials
            Results.image(ii).condition(kk).subject(jj).img=fixations(imageInd).img;
            if ~Param.IncludeObjNoAttInObj
                Results.image(ii).condition(kk).subject(jj).numPixObj=Results.image(ii).numPixObj;
            else
                Results.image(ii).condition(kk).subject(jj).numPixObj=Results.image(ii).numPixAllObj;
            end
            Results.image(ii).condition(kk).subject(jj).numPixBg=Results.image(ii).numPixBg;
            
            %trial number in Results_PerSubject
            tt=size(Results_PerSubject.subject(ind).condition(kk).trial,2)+1;
            if tt==1
                Results_PerSubject.subject(ind).condition(kk).trial=Results.image(ii).condition(kk).subject(jj);
            else
                Results_PerSubject.subject(ind).condition(kk).trial(tt)=Results.image(ii).condition(kk).subject(jj);
            end
        end
    end
end

for nn=1:size(Results.shuffled,2)%repetitions
    for ii=1:size(Results.shuffled(nn).image,2) %images
        for kk=1:size(Results.shuffled(nn).image(ii).condition,2) %conditions
            for jj=1:size(Results.shuffled(nn).image(ii).condition(kk).subject,2)%subjects
                imageName=Results.shuffled(nn).image(ii).imageName;
                imageInd=find(strcmp(imageName,{fixations.img}));
                %subj Id
                subjN=fixations(imageInd).shuffled(nn).condition(kk).subject(jj).subjNum;
                ind=find(subjNumber==subjN);
                
                %add data to trials
                Results.shuffled(nn).image(ii).condition(kk).subject(jj).img=fixations(imageInd).img;
                if ~Param.IncludeObjNoAttInObj
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).numPixObj=Results.image(ii).numPixObj;
                else
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj).numPixObj=Results.image(ii).numPixAllObj;
                end
                Results.shuffled(nn).image(ii).condition(kk).subject(jj).numPixBg=Results.image(ii).numPixBg;
                
                %trial number in Results_PerSubject
                tt=size(Results_PerSubject.shuffled(nn).subject(ind).condition(kk).trial,2)+1;
                if tt==1
                    Results_PerSubject.shuffled(nn).subject(ind).condition(kk).trial=Results.shuffled(nn).image(ii).condition(kk).subject(jj);
                else
                    Results_PerSubject.shuffled(nn).subject(ind).condition(kk).trial(tt)=Results.shuffled(nn).image(ii).condition(kk).subject(jj);
                end
            end
        end
    end
end
end