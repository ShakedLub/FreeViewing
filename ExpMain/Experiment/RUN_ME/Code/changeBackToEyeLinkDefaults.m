function changeBackToEyeLinkDefaults(EL_DEFAULTS)
%% screen_pixel_coords
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', EL_DEFAULTS.screen_pixel_coords(1), EL_DEFAULTS.screen_pixel_coords(2), EL_DEFAULTS.screen_pixel_coords(3), EL_DEFAULTS.screen_pixel_coords(4));

%% screen_phys_coords
Eyelink('command','screen_phys_coords = %ld %ld %ld %ld', EL_DEFAULTS.screen_phys_coords(1), EL_DEFAULTS.screen_phys_coords(2), EL_DEFAULTS.screen_phys_coords(3), EL_DEFAULTS.screen_phys_coords(4));

%% eye tracked
%active_eye
Eyelink('command', ['active_eye = ',EL_DEFAULTS.active_eye]);

%binocular_enabled
Eyelink('command', ['binocular_enabled = ',EL_DEFAULTS.binocular_enabled]);

%% calibration targets
%generate_default_targets
Eyelink('command', ['generate_default_targets = ',EL_DEFAULTS.generate_default_targets]);

%calibration_type
Eyelink('command', ['calibration_type = ',EL_DEFAULTS.calibration_type]);

%calibration_targets

%% validation targets
% validation_targets 

%% parser
%saccade_velocity_threshold
Eyelink('command', ['saccade_velocity_threshold = ',EL_DEFAULTS.saccade_velocity_threshold]);

%saccade_acceleration_threshold
Eyelink('command', ['saccade_acceleration_threshold = ',EL_DEFAULTS.saccade_acceleration_threshold]);

%% EDF file contents
%file_event_filter
Eyelink('command', ['file_event_filter = ',EL_DEFAULTS.file_event_filter]);

%file_sample_data
Eyelink('command', ['file_sample_data = ',EL_DEFAULTS.file_sample_data]);

%link_event_filter
Eyelink('command', ['link_event_filter = ',EL_DEFAULTS.link_event_filter]);

%link_sample_data
Eyelink('Command', ['link_sample_data = ',EL_DEFAULTS.link_sample_data]);

%% pupil Tracking model in camera setup screen
%use_ellipse_fitter
%Eyelink('Command', ['use_ellipse_fitter = ',EL_DEFAULTS.use_ellipse_fitter]);
%This is a function I am not changing in elsetup at it doesn't work,
% doesn't change readFromTracker
%% sample_rate
Eyelink('command', 'sample_rate = %d',EL_DEFAULTS.sample_rate);

%% calibration settings 
%enable_automatic_calibration
Eyelink('Command', ['enable_automatic_calibration = ',EL_DEFAULTS.enable_automatic_calibration]);
end