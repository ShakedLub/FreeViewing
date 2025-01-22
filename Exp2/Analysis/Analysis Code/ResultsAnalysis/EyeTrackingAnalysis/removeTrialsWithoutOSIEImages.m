function EXPDATA=removeTrialsWithoutOSIEImages(EXPDATA,Paths)
%load names of OSIE images used in experiment
cd(Paths.ImagesFolder)
d=dir('*.jpg');
cd(Paths.EyeTrackingAnalysisFolder)
ImNames={d.name};
clear d

indRemove=[];
for ii=1:size(EXPDATA.Trials_Analysis,2) %trials
    if isempty(find(strcmp(EXPDATA.Trials_Analysis(ii).ImageName,ImNames)))
        indRemove=[indRemove,ii];
    end
end
if ~isempty(indRemove)
    EXPDATA.Trials_Analysis(indRemove)=[];
end
EXPDATA.TrialsRemoved.NotOSIEImages=length(indRemove);
end