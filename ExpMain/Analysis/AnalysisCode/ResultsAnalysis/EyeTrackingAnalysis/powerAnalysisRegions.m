function RegionsResultsNew=powerAnalysisRegions(RegionsResults,fixations,subjNumber,Param)
RegionsResultsNew=RegionsResults;

%% Create results struct with NumPartSample participants
%chose participants randomaly
subjSubSample=subjNumber(randperm(length(subjNumber),Param.NumPartSample));
subjExclude=setdiff(subjNumber,subjSubSample);

%exclude participants that are not in the subsample
for ii=1:size(RegionsResultsNew.image,2) %images
    for kk=1:size(RegionsResultsNew.image(ii).condition,2) %condition        
        subjs=[fixations(ii).condition(kk).subject.subjNum];
        if any(ismember(subjs,subjExclude))
            %delete trials of participants from main data
            RegionsResultsNew.image(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
            fixations(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];

            %delete trials of participants from shuffled data
            for nn=1:size(RegionsResultsNew.shuffled,2) %num repetitions
                %delete trials of participants
                RegionsResultsNew.shuffled(nn).image(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
                fixations(ii).shuffled(nn).condition(kk).subject(ismember(subjs,subjExclude))=[];
            end
        end
    end
end

%% delete from fixations and RegionsResultsNew images that don't have data from both visibility
%conditions, if no subj were left in one of the visibility conditions, after deleting subjects. 
indDel=[];
for ii=1:size(fixations,2) %images
    if isempty(fixations(ii).condition(1).subject) || isempty(fixations(ii).condition(2).subject)
        indDel=[indDel,ii];
    end
end
if ~isempty(indDel)
    fixations(indDel)=[];
    RegionsResultsNew.image(indDel)=[]; 
    for nn=1:size(RegionsResultsNew.shuffled,2) %num repetitions
        RegionsResultsNew.shuffled(nn).image(indDel)=[];
    end
end

%% calculations
for ii=1:size(fixations,2) %images
    %calculations per image
    RegionsResultsNew=calculationsRegionsPerImage(RegionsResultsNew,fixations,ii,'Real',[]);
    
    % calculations shuffled data
    for nn=1:size(RegionsResultsNew.shuffled,2) %num repetitions
        %calculations per image
        RegionsResultsNew=calculationsRegionsPerImage(RegionsResultsNew,fixations,ii,'Shuffled',nn);
    end
end
end