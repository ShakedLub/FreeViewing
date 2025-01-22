function EXPDATA=removeSpecificImages(EXPDATA)
%delete 2 images that were not supposed to be included:
%image 1131.jpg with federer
%image 1546.jpg image with strong stripes

ImageNames={EXPDATA.Trials_Analysis.ImageName};

ind1=find(strcmp('1131.jpg',ImageNames));
ind2=find(strcmp('1546.jpg',ImageNames));
indRemove=[ind1,ind2];

if ~isempty(indRemove)
    EXPDATA.Trials_Analysis(indRemove)=[];
end

EXPDATA.TrialsRemoved.SpecificImages=length(indRemove);
end