function FixationsPerImage=arrangeFixationsPerImage(EXPDATA_ALL,Paths)
%image names
cd(Paths.ImagesFolder)
d=dir('*.jpg');
ImageNames={d.name};
cd(Paths.EyeTrackingAnalysisFolder)
clear d

%initialize FixationsAllSubj
for ii=1:length(ImageNames) %images
    FixationsPerImage(ii).img=[];
    FixationsPerImage(ii).imgNum=[];
    FixationsPerImage(ii).subject=[];
end

%fill FixationsPerImage
for ii=1:length(ImageNames) %images
    FixationsPerImage(ii).img=ImageNames{ii};
    FixationsPerImage(ii).imgNum=ii;
    for jj=1:length(EXPDATA_ALL) %subjects       
        SubjImNames={EXPDATA_ALL{jj}.Trials_Analysis.ImageName};
        ind=find(strcmp(ImageNames{ii},SubjImNames));
        if ~isempty(ind)
            indsubj=size(FixationsPerImage(ii).subject,2)+1;
            %general data
            FixationsPerImage(ii).subject(indsubj).subjNum=EXPDATA_ALL{jj}.info.subject_info.subject_number_and_experiment;
            FixationsPerImage(ii).subject(indsubj).TrialNumberOverall=EXPDATA_ALL{jj}.Trials_Analysis(ind).TrialNumberOverall;
            FixationsPerImage(ii).subject(indsubj).gazeX=EXPDATA_ALL{jj}.Trials_Analysis(ind).gazeX;
            FixationsPerImage(ii).subject(indsubj).gazeY=EXPDATA_ALL{jj}.Trials_Analysis(ind).gazeY;
            FixationsPerImage(ii).subject(indsubj).non_nan_times=EXPDATA_ALL{jj}.Trials_Analysis(ind).non_nan_times;
            %fixation data
            FixationsPerImage(ii).subject(indsubj).fix_x=EXPDATA_ALL{jj}.Trials_Analysis(ind).fixations(:,1);
            FixationsPerImage(ii).subject(indsubj).fix_y=EXPDATA_ALL{jj}.Trials_Analysis(ind).fixations(:,2);
            FixationsPerImage(ii).subject(indsubj).fix_duration=EXPDATA_ALL{jj}.Trials_Analysis(ind).fixationsDurations;
            FixationsPerImage(ii).subject(indsubj).fix_onsets=EXPDATA_ALL{jj}.Trials_Analysis(ind).fixationsOnsets;
            %saccade data
            FixationsPerImage(ii).subject(indsubj).sacc_duration=EXPDATA_ALL{jj}.Trials_Analysis(ind).saccadeDurations;
            FixationsPerImage(ii).subject(indsubj).sacc_amp=EXPDATA_ALL{jj}.Trials_Analysis(ind).saccadeAmplitudes;
            FixationsPerImage(ii).subject(indsubj).sacc_vel=EXPDATA_ALL{jj}.Trials_Analysis(ind).saccadeVelocities;
            FixationsPerImage(ii).subject(indsubj).sacc_onsets=EXPDATA_ALL{jj}.Trials_Analysis(ind).saccadeOnsets;
        end
    end
end
end