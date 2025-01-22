function EXPDATA=arrangeEyeTrackingData(EXPDATA,fixations,saccades,raw_data)
ImageStartTrigger='C01_400';

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

%% delete from eye tracking data the first trials that belong to the practice
NumImageTrialsP=size(EXPDATA.Trials_Practice,2);

%delete practice trials from fixation data
fix_coordinates=fixations.(ImageStartTrigger).(CORRD_USE);
fix_coordinates(1:NumImageTrialsP)=[];

fix_durations=fixations.(ImageStartTrigger).durations;  
fix_durations(1:NumImageTrialsP)=[];

fix_onsets=fixations.(ImageStartTrigger).onsets;
fix_onsets(1:NumImageTrialsP)=[];

%delete practice trials from saccade data
sacc_number=saccades.(ImageStartTrigger).number_of_saccades;
sacc_number(1:NumImageTrialsP)=[];

sacc_duration=saccades.(ImageStartTrigger).durations;
sacc_duration(1:NumImageTrialsP)=[];

sacc_amp=saccades.(ImageStartTrigger).amplitudes;
sacc_amp(1:NumImageTrialsP)=[];

sacc_onset=saccades.(ImageStartTrigger).onsets;
sacc_onset(1:NumImageTrialsP)=[];

sacc_vel=saccades.(ImageStartTrigger).velocities;
sacc_vel(1:NumImageTrialsP)=[];

%delete practice trials from gaze data
x=raw_data.(ImageStartTrigger).(EYE_USE).x;
x(1:NumImageTrialsP,:)=[];

y=raw_data.(ImageStartTrigger).(EYE_USE).y;
y(1:NumImageTrialsP,:)=[];

%delete practice trials from non nan times (blinks and missing data times)
non_nan_times=raw_data.(ImageStartTrigger).non_nan_times;
non_nan_times(1:NumImageTrialsP,:)=[];

%% check
if length(fix_coordinates)~=size(EXPDATA.Trials_Analysis,2)
    error('Problem with number of trials')
end

%% add fixation data to expdata
%add image trials data
for ii=1:size(EXPDATA.Trials_Analysis,2)
    EXPDATA.Trials_Analysis(ii).fixations=fix_coordinates{ii};
    EXPDATA.Trials_Analysis(ii).fixationsDurations=fix_durations{ii};
    EXPDATA.Trials_Analysis(ii).fixationsOnsets=fix_onsets{ii};
    EXPDATA.Trials_Analysis(ii).saccadeNumber=sacc_number(ii);
    EXPDATA.Trials_Analysis(ii).saccadeDurations=sacc_duration{ii};
    EXPDATA.Trials_Analysis(ii).saccadeAmplitudes=sacc_amp{ii};
    EXPDATA.Trials_Analysis(ii).saccadeOnsets=sacc_onset{ii};
    EXPDATA.Trials_Analysis(ii).saccadeVelocities=sacc_vel{ii};
    EXPDATA.Trials_Analysis(ii).gazeX=x(ii,:);
    EXPDATA.Trials_Analysis(ii).gazeY=y(ii,:);
    EXPDATA.Trials_Analysis(ii).non_nan_times=non_nan_times(ii,:);
end
end