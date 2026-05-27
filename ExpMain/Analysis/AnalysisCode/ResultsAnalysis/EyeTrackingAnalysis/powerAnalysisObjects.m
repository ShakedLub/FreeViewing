function ObjectsResultsNew=powerAnalysisObjects(ObjectsResults,Param,subjNumber)
ObjectsResultsNew=ObjectsResults;

%% Create results struct with NumPartSample participants
%chose participants randomaly
subjSubSample=subjNumber(randperm(length(subjNumber),Param.NumPartSample));
subjExclude=setdiff(subjNumber,subjSubSample);

%exclude participants that are not in the subsample
for ii=1:size(ObjectsResultsNew.image,2) %images
    for kk=1:size(ObjectsResultsNew.image(ii).condition,2) %condition        
        subjs=[ObjectsResultsNew.image(ii).condition(kk).subject.subjNum];
        if any(ismember(subjs,subjExclude))
            %delete trials of participants from main data
            ObjectsResultsNew.image(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];

            %delete trials of participants from shuffled data
            for nn=1:size(ObjectsResultsNew.shuffled,2) %num repetitions
                %delete trials of participants
                ObjectsResultsNew.shuffled(nn).image(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
            end
        end
    end
end

%% delete from ObjectsResultsNew images that don't have data from both visibility
%conditions, if no subj were left in one of the visibility conditions,
%after deleting subjects
indDel=[];
for ii=1:size(ObjectsResultsNew.image,2) %images
    if isempty(ObjectsResultsNew.image(ii).condition(1).subject) || isempty(ObjectsResultsNew.image(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    ObjectsResultsNew.image(indDel)=[]; 
    for nn=1:size(ObjectsResultsNew.shuffled,2) %num repetitions
        ObjectsResultsNew.shuffled(nn).image(indDel)=[];
    end
end

%% calcualtions
for ii=1:size(ObjectsResultsNew.image,2) %images
    % real data
    for kk=1:size(ObjectsResultsNew.image(ii).condition,2) %conditions
        %calculations per image
        ObjectsResultsNew=calculationsObjectsPerImage(ObjectsResultsNew,ii,kk,'Real',[],Param);
    end
    
    % shuffled data
    for nn=1:Param.Nrepetitions %num repetitions
        for kk=1:size(ObjectsResultsNew.shuffled(nn).image(ii).condition,2)
            %calculations per image
            ObjectsResultsNew=calculationsObjectsPerImage(ObjectsResultsNew,ii,kk,'Shuffled',nn,Param);
        end
    end
end
end