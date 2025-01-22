function EXPDATA=arrangeEyeTrackingData(EXPDATA,fixations,saccades,raw_data)
ImageTrialsTrigger='C01_401';
ControlTrialsTrigger='C02_402';

%parameters from expdata
DOM_EYE=EXPDATA.info.subject_info.dominant_eye;
switch DOM_EYE
    case 'R'
        CORRD_USE='coordinates_right';
        EYE_USE='right_eye';
    case 'L'
        CORRD_USE='coordinates_left';
        EYE_USE='left_eye';
end

%% delete from eye tracking data the first trials that belong to the practice and last trials that belong to extra blocks
%find how many image and control trials are in practice
NumImageTrialsP=sum([EXPDATA.Trials_Practice.IsImageTrial]);  
NumControlTrialsP=sum([EXPDATA.Trials_Practice.IsControlTrial]);  

%find how many image and control trials are in extra block
NumImageTrialsExtra=sum([EXPDATA.Trials_Extra.IsImageTrial]);  
NumControlTrialsExtra=sum([EXPDATA.Trials_Extra.IsControlTrial]);  

%delete practice and extra trials from fixation data
fix_coordinates_im=fixations.(ImageTrialsTrigger).(CORRD_USE);
fix_coordinates_c=fixations.(ControlTrialsTrigger).(CORRD_USE);
[fix_coordinates_im,fix_coordinates_c]=deletePracticeAndExtraTrials(fix_coordinates_im,fix_coordinates_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

fix_durations_im=fixations.(ImageTrialsTrigger).durations;  
fix_durations_c=fixations.(ControlTrialsTrigger).durations;  
[fix_durations_im,fix_durations_c]=deletePracticeAndExtraTrials(fix_durations_im,fix_durations_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

fix_onsets_im=fixations.(ImageTrialsTrigger).onsets;
fix_onsets_c=fixations.(ControlTrialsTrigger).onsets;
[fix_onsets_im,fix_onsets_c]=deletePracticeAndExtraTrials(fix_onsets_im,fix_onsets_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

%delete practice and extra trials from saccade data
sacc_number_im=saccades.(ImageTrialsTrigger).number_of_saccades;
sacc_number_c=saccades.(ControlTrialsTrigger).number_of_saccades;
[sacc_number_im,sacc_number_c]=deletePracticeAndExtraTrials(sacc_number_im,sacc_number_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

sacc_duration_im=saccades.(ImageTrialsTrigger).durations;
sacc_duration_c=saccades.(ControlTrialsTrigger).durations;
[sacc_duration_im,sacc_duration_c]=deletePracticeAndExtraTrials(sacc_duration_im,sacc_duration_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

sacc_amp_im=saccades.(ImageTrialsTrigger).amplitudes;
sacc_amp_c=saccades.(ControlTrialsTrigger).amplitudes;
[sacc_amp_im,sacc_amp_c]=deletePracticeAndExtraTrials(sacc_amp_im,sacc_amp_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

sacc_onset_im=saccades.(ImageTrialsTrigger).onsets;
sacc_onset_c=saccades.(ControlTrialsTrigger).onsets;
[sacc_onset_im,sacc_onset_c]=deletePracticeAndExtraTrials(sacc_onset_im,sacc_onset_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

sacc_vel_im=saccades.(ImageTrialsTrigger).velocities;
sacc_vel_c=saccades.(ControlTrialsTrigger).velocities;
[sacc_vel_im,sacc_vel_c]=deletePracticeAndExtraTrials(sacc_vel_im,sacc_vel_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

%delete practice and extra trials from gaze data
x_im=raw_data.(ImageTrialsTrigger).(EYE_USE).x;
x_c=raw_data.(ControlTrialsTrigger).(EYE_USE).x;
[x_im,x_c]=deletePracticeAndExtraTrials(x_im,x_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

y_im=raw_data.(ImageTrialsTrigger).(EYE_USE).y;
y_c=raw_data.(ControlTrialsTrigger).(EYE_USE).y;
[y_im,y_c]=deletePracticeAndExtraTrials(y_im,y_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

%delete practice and extra  trials from non nan times (blinks and missing data times)
non_nan_times_im=raw_data.(ImageTrialsTrigger).non_nan_times;
non_nan_times_c=raw_data.(ControlTrialsTrigger).non_nan_times;
[non_nan_times_im,non_nan_times_c]=deletePracticeAndExtraTrials(non_nan_times_im,non_nan_times_c,NumImageTrialsP,NumControlTrialsP,NumImageTrialsExtra,NumControlTrialsExtra);

%% check
if length(fix_coordinates_im)~=sum([EXPDATA.Trials_Analysis.IsImageTrial])
    error('Problem with number of image trials')
end
if length(fix_coordinates_c)~=sum([EXPDATA.Trials_Analysis.IsControlTrial])
    error('Problem with number of control trials')
end

%% add fixation data to expdata
indImageTrials=find([EXPDATA.Trials_Analysis.IsImageTrial]);  
indControlTrials=find([EXPDATA.Trials_Analysis.IsControlTrial]);  

%add image trials data
for ii=1:length(indImageTrials) 
    EXPDATA.Trials_Analysis(indImageTrials(ii)).fixations=fix_coordinates_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).fixationsDurations=fix_durations_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).fixationsOnsets=fix_onsets_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).saccadeNumber=sacc_number_im(ii);
    EXPDATA.Trials_Analysis(indImageTrials(ii)).saccadeDurations=sacc_duration_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).saccadeAmplitudes=sacc_amp_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).saccadeOnsets=sacc_onset_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).saccadeVelocities=sacc_vel_im{ii};
    EXPDATA.Trials_Analysis(indImageTrials(ii)).gazeX=x_im(ii,:);
    EXPDATA.Trials_Analysis(indImageTrials(ii)).gazeY=y_im(ii,:);
    EXPDATA.Trials_Analysis(indImageTrials(ii)).non_nan_times=non_nan_times_im(ii,:);
end

%add control trials data
for ii=1:length(indControlTrials) 
    EXPDATA.Trials_Analysis(indControlTrials(ii)).fixations=fix_coordinates_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).fixationsDurations=fix_durations_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).fixationsOnsets=fix_onsets_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).saccadeNumber=sacc_number_c(ii);
    EXPDATA.Trials_Analysis(indControlTrials(ii)).saccadeDurations=sacc_duration_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).saccadeAmplitudes=sacc_amp_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).saccadeOnsets=sacc_onset_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).saccadeVelocities=sacc_vel_c{ii};
    EXPDATA.Trials_Analysis(indControlTrials(ii)).gazeX=x_c(ii,:);
    EXPDATA.Trials_Analysis(indControlTrials(ii)).gazeY=y_c(ii,:);
    EXPDATA.Trials_Analysis(indControlTrials(ii)).non_nan_times=non_nan_times_c(ii,:);
end
end