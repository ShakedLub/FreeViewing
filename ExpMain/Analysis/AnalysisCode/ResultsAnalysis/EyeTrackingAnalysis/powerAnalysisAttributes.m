function AttributesResultsNew=powerAnalysisAttributes(AttributesResults,subjNumber,Param)
AttributesResultsNew=AttributesResults;

%% Create results struct with NumPartSample participants
%chose participants randomaly
subjSubSample=subjNumber(randperm(length(subjNumber),Param.NumPartSample));
subjExclude=setdiff(subjNumber,subjSubSample);

%exclude participants that are not in the subsample
for ii=1:size(AttributesResultsNew.image,2) %images
    for kk=1:size(AttributesResultsNew.image(ii).condition,2) %condition
        subjs=[AttributesResultsNew.image(ii).condition(kk).subject.subjNum];
        if any(ismember(subjs,subjExclude))
            %delete trials of participants from main data
            AttributesResultsNew.image(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
            
            %delete trials of participants from shuffled data
            for nn=1:size(AttributesResultsNew.shuffled,2) %num repetitions
                %delete trials of participants
                AttributesResultsNew.shuffled(nn).image(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
            end
        end
    end
end

%% delete from AttributesResultsNew images that don't have data from both visibility
%conditions, if no subj were left in one of the visibility conditions,
%after deleting subjects
indDel=[];
for ii=1:size(AttributesResultsNew.image,2) %images
    if isempty(AttributesResultsNew.image(ii).condition(1).subject) || isempty(AttributesResultsNew.image(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    AttributesResultsNew.image(indDel)=[];
    for nn=1:size(AttributesResultsNew.shuffled,2) %num repetitions
        AttributesResultsNew.shuffled(nn).image(indDel)=[];
    end
end

%% calcualtions
for ii=1:size(AttributesResultsNew.image,2) %images
    % real data
    for kk=1:size(AttributesResultsNew.image(ii).condition,2) %conditions
        %calcaultions per attribute
        AttributesResultsNew=calculationsAttributePerImage(AttributesResultsNew,ii,kk,'Real',[]);
    end
    
    % shuffled data
    for nn=1:size(AttributesResultsNew.shuffled,2) %iterations
        for kk=1:size(AttributesResultsNew.image(ii).condition,2) %conditions
            %calcaultions per attribute
            AttributesResultsNew=calculationsAttributePerImage(AttributesResultsNew,ii,kk,'Shuffled',nn);
        end
    end
end
end