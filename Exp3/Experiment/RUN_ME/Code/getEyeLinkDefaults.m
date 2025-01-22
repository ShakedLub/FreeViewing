function EL_DEFAULTS=getEyeLinkDefaults(EL_DEFAULTS)
%% screen_pixel_coords
[~, screen_pixel_coords_struct] = Eyelink('ReadFromTracker', 'screen_pixel_coords');
[~, screen_pixel_coords_struct] = Eyelink('ReadFromTracker', 'screen_pixel_coords');
out=regexp(screen_pixel_coords_struct,',','split');
for ii=1:length(out)
    EL_DEFAULTS.screen_pixel_coords(ii)=str2num(out{ii});
end

%% screen_phys_coords
[~, screen_phys_coords_struct] = Eyelink('ReadFromTracker', 'screen_phys_coords');
out=regexp(screen_phys_coords_struct,',','split');
for ii=1:length(out)
    EL_DEFAULTS.screen_phys_coords(ii)=str2num(out{ii});
end

%% eye tracked
%binocular_enabled
[~, binocular_enabled_struct]=Eyelink('ReadFromTracker','binocular_enabled');
number=str2num(binocular_enabled_struct);
if number==1
    EL_DEFAULTS.binocular_enabled='yes';
elseif number==0
    EL_DEFAULTS.binocular_enabled='no';
end

%active_eye
[~, EL_DEFAULTS.active_eye]=Eyelink('ReadFromTracker','active_eye');

%% calibration targets
%generate_default_targets
EL_DEFAULTS.generate_default_targets='YES';
%Variable read not supported

%calibration_type
[~, EL_DEFAULTS.calibration_type] = Eyelink('ReadFromTracker', 'calibration_type');

%calibration_targets
%Variable read not supported

%% validation targets
% validation_targets
%Variable read not supported

%% parser
%saccade_velocity_threshold
[~, EL_DEFAULTS.saccade_velocity_threshold] = Eyelink('ReadFromTracker', 'saccade_velocity_threshold');

%saccade_acceleration_threshold
[~, EL_DEFAULTS.saccade_acceleration_threshold] = Eyelink('ReadFromTracker', 'saccade_acceleration_threshold');

%% EDF file contents
%file_event_filter
[~, EL_DEFAULTS.file_event_filter] = Eyelink('ReadFromTracker', 'file_event_filter');

% file_sample_data
[~, EL_DEFAULTS.file_sample_data] = Eyelink('ReadFromTracker', 'file_sample_data');

%link_event_filter
[~, EL_DEFAULTS.link_event_filter] = Eyelink('ReadFromTracker', 'link_event_filter');

%link_sample_data
[~, EL_DEFAULTS.link_sample_data] = Eyelink('ReadFromTracker', 'link_sample_data');

%% pupil Tracking model in camera setup screen
%use_ellipse_fitter
[~, use_ellipse_fitter_struct] = Eyelink('ReadFromTracker', 'use_ellipse_fitter');
number=str2num(use_ellipse_fitter_struct);
if number==1
    EL_DEFAULTS.use_ellipse_fitter='yes';
elseif number==0
    EL_DEFAULTS.use_ellipse_fitter='no';
end
%This is a function I am not changing in elsetup at it doesn't work,
% doesn't change readFromTracker
%% sample_rate
[~, sample_rate_struct] = Eyelink('ReadFromTracker', 'sample_rate');
EL_DEFAULTS.sample_rate=str2num(sample_rate_struct);

%% calibration settings
%enable_automatic_calibration
[~, enable_automatic_calibration_struct]=Eyelink('ReadFromTracker','enable_automatic_calibration');
number=str2num(enable_automatic_calibration_struct);
if number==1
    EL_DEFAULTS.enable_automatic_calibration='yes';
elseif number==0
    EL_DEFAULTS.enable_automatic_calibration='no';
end

%% functions I am not using:
%Eyelink('command', 'elcl_tt_power = %d',2);
%Variable read not supported

%Eyelink('command', 'button_function 5 "accept_target_fixation"');
%Variable read not supported

%Eyelink('command','calibration_samples = 9');
%Variable read not supported

%Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8');
%Variable read not supported

%Eyelink('command', 'validation_type = HV9');
%Unknown Variable Name

%Eyelink('command','validation_samples = 9');
%Variable read not supported

%Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8');
%Variable read not supported

%% save EL_DEFAULTS
EL_DEFAULTS.save_time=datestr(now);
save('EL_DEFAULTS_LAST_RUN.mat','EL_DEFAULTS')
end