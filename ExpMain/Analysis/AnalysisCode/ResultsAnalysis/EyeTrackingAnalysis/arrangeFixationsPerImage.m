function FixationsPerImage=arrangeFixationsPerImage(EXPDATA_ALL,Paths)
%load from pile up design parameters
pileupfileName=['pileup_U_',num2str(EXPDATA_ALL{1,1}.info.subject_info.subject_number_and_experiment),'.mat'];
load([Paths.PileupFolder,'\',pileupfileName],'DESIGN_PARAM')

ImageNames=DESIGN_PARAM.Image_Names_Experiment;

%initialize FixationsPerImage
for ii=1:length(ImageNames) %images
    FixationsPerImage(ii).img=[];
    for kk=1:size(EXPDATA_ALL,2) %condition
        FixationsPerImage(ii).condition(kk).subject=[];
    end
end

%Find trials of each image for each subject and condition and add it to
%fixatoins data only if it is an image trial
for ii=1:length(ImageNames) %images
    FixationsPerImage(ii).img=ImageNames{ii};
    for jj=1:size(EXPDATA_ALL,1) %subjects
        for kk=1:size(EXPDATA_ALL,2) %condition
            SubjImNames={EXPDATA_ALL{jj,kk}.Trials_Analysis.ImageName};
            indControl=find([EXPDATA_ALL{jj,kk}.Trials_Analysis.IsControlTrial]);
            ind=find(strcmp(ImageNames{ii},SubjImNames));
            ind=setdiff(ind,indControl);
            if ~isempty(ind)
                indsubj=size(FixationsPerImage(ii).condition(kk).subject,2)+1;
                %general data
                FixationsPerImage(ii).condition(kk).subject(indsubj).subjNum=EXPDATA_ALL{jj,kk}.info.subject_info.subject_number_and_experiment;
                FixationsPerImage(ii).condition(kk).subject(indsubj).TrialNumberOverall=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).TrialNumberOverall;
                FixationsPerImage(ii).condition(kk).subject(indsubj).gazeX=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).gazeX;
                FixationsPerImage(ii).condition(kk).subject(indsubj).gazeY=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).gazeY;
                FixationsPerImage(ii).condition(kk).subject(indsubj).non_nan_times=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).non_nan_times;
                %fixation data
                FixationsPerImage(ii).condition(kk).subject(indsubj).fix_x=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).fixations(:,1);
                FixationsPerImage(ii).condition(kk).subject(indsubj).fix_y=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).fixations(:,2);
                FixationsPerImage(ii).condition(kk).subject(indsubj).fix_duration=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).fixationsDurations;
                FixationsPerImage(ii).condition(kk).subject(indsubj).fix_onsets=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).fixationsOnsets;
                %saccade data
                FixationsPerImage(ii).condition(kk).subject(indsubj).sacc_duration=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).saccadeDurations;
                FixationsPerImage(ii).condition(kk).subject(indsubj).sacc_amp=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).saccadeAmplitudes;
                FixationsPerImage(ii).condition(kk).subject(indsubj).sacc_vel=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).saccadeVelocities;
                FixationsPerImage(ii).condition(kk).subject(indsubj).sacc_onsets=EXPDATA_ALL{jj,kk}.Trials_Analysis(ind).saccadeOnsets;
            end
        end
    end
end
end