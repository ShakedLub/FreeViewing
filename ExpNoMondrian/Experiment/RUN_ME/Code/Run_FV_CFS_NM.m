%TODO: fix bug in ExperimentGuiBuilder::readMultipleNums - if changing
%number of requested numbers, then crash.

function Run_FV_CFS_NM(number)
%% Overview/////////
% This function is a framework for building experiments for psychtoolbox.
% Three main sections:
%
% # Experiment Definitions
% # GUI
% # Experiment function - called via the gui's [run experiment] button.
%
% ---------------------------------- -------
%
% The experiment function is broken up to logical stages that make up the
% experiment's workflow: ( _EDIT_ marks stages needed to be edited by the programmer)
%
% # Turn on psychtoolbox view - _turnOnPTBView_ .
% # Initialize biosemi and the eyetracker and start recording - _initializeGear_ .
% # Load messages and stimuli .png (loads into the struct *resources*) - _scanMessages_ , _loadResources_ : _EDIT_ .
% # Initialize the data record object *EXPDATA* - _initializeDataRecord_ : _EDIT_ .
% # Build the randomized conditions matrix *conditions_mat* - _randomizeConditions_ : _EDIT_
% # Run the experiment - _runBlocks_: _EDIT_ . this function contains a recommended
%    preliminary code.
% # Save all the data and shut down the recording  - _terminateExp_ : in the
%    event of an error during the experiment, _terminateExp_ is called before
%    the experiment shuts down.
%
% ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%
% At the end of the template you will find miscellaneous utility functions:
%
% * _runCalibrationQuery_ - displays a screen to query the experimenter
%      whether to perform an eye tracker calibration.
% * _calibrateEyeTracker_ - calls the eyelink calibration routine.
% * _echo_ - sends a trigger if the biosemi is active or an eyelink
%   message if only the eyetracker is active.
% * _sendEyelinkMsg_ - sends an eyelink message to be recorded on the .edf
%   file.
% * _sendTrigger_ - sends a trigger to be recorded both on the .bdf file
%   and on the .edf file.
% * _pixels2vAngles_ - converts pixels units to visual degrees units.
% * _vAngles2pixels_ - converts visual degrees units to pixels units.
% * _defineTextFormat_ - defines psychtoolbox's text format and text size.
% * _drawImageInstructions_ - displays a .png image on full screen.
% * _pngFileToTex_ - load a   .png file from a file path and create a texture
%   out of it.
% * _displayTimedTextures_ - displays textures for a set amount of time.
% * _drawFixationCircleWithAnulous_ - calls psychtoolbox's _DrawTextures_
%   for two concentric filled circles in the middle of the screen (does
%   not flip).
% * _drawFixationCross_ - calls psychtoolbox's _DrawLines_
%   for a fixation cross in the middle of the screen (does not flip).
% * _drawFixationCrossAtPos_ - calls psychtoolbox's _DrawLines_ for a fixation
%   at a given location (does not flip).
% * _sampleGazeCoords_ - samples the gaze's x and y coordinates
% * _testFixationBreaking_ - tests whether the gaze's distance from the
%   center of the screen exceeds the distance specified in the GUI as
%   the maximum allowed.
% * _checkPauseReq_ - checks whether [esc] is pressed and pauses the
%       experiment if it is, while showing a menu screen.
%        can show a fixation cross during the display and can monitor [esc]
%       key press and fixation breaks.
% * _KbCheckRB_ - checks whether a response box key is pressed.
%% first and foremost:
if number==0
    return
end
clear all;
close all;
sca;

%% Experiment Definitions
DEBUG_CODE=1;
CHECK_TRIGGERS=[];

%experiment name
EXPERIMENT_NAME= 'exp';
EXPERIMENT_NUMBER=300;
EXPERIMENT_STEPS={'Practice','Experiment'};

%folder constants
CURRENT_FOLDER = cd;
GUI_XML_FILE= fullfile('guiXML.xml');
MSGS_FOLDER= fullfile('resources','instructions');

cd ..\
IMAGES_EXPERIMENT_FOLDER=[pwd,'\stimuli\ImageTrials_Experiment'];
IMAGES_PRACTICE_FOLDER=[pwd,'\stimuli\ImageTrials_Practice'];
IMAGES_MEMORY_TASK_FOLDER=[pwd,'\stimuli\MemoryTestImages_Experiment'];
IMAGES_MEMORY_TASK_PRACTICE_FOLDER=[pwd,'\stimuli\MemoryTestImages_Practice'];
cd(CURRENT_FOLDER)

EXPDATA_SAVE_FOLDER= fullfile('data files', 'behavioral data');
WORKSPACE_SAVE_FOLDER= fullfile('data files', 'data pileups');
EDF_SAVE_FOLDER= fullfile('data files', 'eye tracking data');
ONGOING_RESULTS_FOLDER=fullfile('data files', 'behavioral data','ongoing');
LETTERS_PNGS_FOLDER = fullfile('resources', 'stimuli', 'letters');
FAULT_WAV = fullfile('resources', 'fault.wav');
SQR_PNG = fullfile('resources', 'stimuli', 'square.png');
STEREOGRAM_SAVE_FOLDER=fullfile('resources', 'stimuli','stereograms');

%lab room setup parameters definitions
SUBJECT_DISTANCE_FROM_SCREEN= [];
SCREEN_WIDTH= [];
SCREEN_HEIGHT= [];
GAMMA_TABLE_FULL_PATH= [];

%experiment's parameters definitions - EDIT
LAB_ROOM= [];
BACKGROUND_COLOR= [];

%subject parameters
SUBJECT_NUMBER= [];
SUBJECT_AGE= [];
SUBJECT_GENDER= [];
DOMINANT_EYE = [];
DOMINANT_EYE_NUMBER= [];
NON_DOMINANT_EYE_NUMBER=[];
DOMINANT_EYE_RIGHT=[];
IS_CALIB_RIGHT = [];
DOMINANT_HAND=[];
SUBJECT_NUMBER_AND_EXPERIMENT=[];

BLOCKS_NR_MULTIPLIER= [];
TRIALS_NR_MULTIPLIER= [];
DUMMY_TO_REGULAR_TRIALS_WEIGHTS = [];
NUM_BLOCKS=6;

%fixation cross
FIXATION_CROSS_ARMS_LEN_IN_VANGLES= [];
FIXATION_CROSS_ARMS_WIDTH_IN_VANGLES= [];
FIXATION_CROSS_COLOR= [];

DISPLAY_AREA_SZ_IN_VANGLES = [];
DISPLAY_AREAS_DIST_FROM_CENTER_IN_VANGLES = [];

%checkboad frame
CHECKERBOARD_FRAME_WIDTH_IN_VANGLES = []; % the checkerboard frames the display area
CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE = [];
CHECKERBOARD_SQRS_NR_ON_VERT_SIDE = [];
CHECKERBOARD_BRIGHT_COLOR = [];

GABOR_DIA_IN_VANGLES = [];
GABOR_HORIZON_DIST_FROM_CENTER_IN_VANGLES = [];
GABOR_POSSIBLE_VERT_DIST_FROM_CENTER_IN_VANGLES = [];
GABOR_TILT_IN_DEGS = [];
GABOR_CONTRASTS= [];
GABOR_CYCLES_PER_DEGREE = [];

%mondrians
MONDRIAN_SHAPES_SZS = [];
MONDRIAN_CHANGE_FREQ = [];

FIRST_FIXATION_DURS = [];
GABOR_PHASE_DUR = [];
DOUBLE_MONDRIAN_PHASE_DUR = [];
BLANK_PHASE_DUR = [];

RESPONSE_KEY_LEFT = [];
RESPONSE_KEY_RIGHT = [];
BINOCULAR_SWITCH_FREQUENCY = [];
MONDRIAN_RESPONSE_TIME_ALLOWED_IN_MILLIS= [];
CERTAINTY_RESPONSE_TIME_ALLOWED_IN_MILLIS = [];
GABOR_TILT_RESPONSE_TIME_ALLOWED_IN_MILLIS = [];
POST_RESPONSE_DELAY= [];

FORCE_FIXATION= [];
POST_FIXATION_BREAK_DELAY= [];
MAX_GAZE_DIST_FROM_CENTER_IN_VANGLES= [];
GAZE_SAMPLES_FOR_FIXATION_MONITORING_VERDICT= [];

%experiment devices
EYE_TRACKING_METHOD= [];
EEG= [];

%whether to run the: run config screen
DEBUG= [];

%Eye link variables
EL_PARAMS= [];
FIXATION_MONITOR= [];
EL_DEFAULTS=[];

%data record object
EXPDATA= [];

%variable for saving calibration data
CALIBRATION_DATA=[];

%file names
EDF_TEMP_FILE_NAME=[];
EDF_FILE_NAME=[];
EXPDATA_SAVE_FILE_NAME=[];
WORKSPACE_SAVE_FILE_NAME=[];

%experiment's parameters definitions - not included in the gui
GUI_BACKGROUND_COLOR= [0.8 0.8 0.8];
EXPDATA_SAVE_FILE_NAME_PREFIX= 'expdata';
EXPDATA_SAVE_FILE_NAME_SUFFIX= [];
WORKSPACE_SAVE_FILE_NAME_PREFIX= 'pileup';
WORKSPACE_SAVE_FILE_NAME_SUFFIX= [];
EDF_FILE_NAME_PREFIX = 's';
EDF_FILE_NAME_SUFFIX= [];
EDF_TEMP_FILE_NAME_PREFIX= 's';

INEXP_TEXT_COLOR= [];
INEXP_FONT_SZ = 20;
KBOARD_FIRST_KEY_PRESS_COOLDOWN = 0.3;
KBOARD_REPEATED_KEY_PRESS_COOLDOWN = 0.05;
KBOARD_COOLDOWNS_VEC = zeros(1,256);
KBOARD_COOLDOWNS_REPS_VEC = zeros(1,256);
KEY_CODES_ON_COOLDOWN_LIST = [];
NORMAL_ADJUST_SZ = 1;
BIG_ADJUST_SZ = 10;
AUGMENTED_ADJUST_SZ_FACTOR = 2;
COOLDOWNS_REPS_FOR_DOUBLE_BIG_ADJUST_SZ = 10;
ABC_VEC = 'abcdefghijklmnopqrstuvwxyz';
GABOR_SD_TO_SIZE_RATIO= 0.16;
GABOR_TRIM_THRESHOLD= 0.005;

HOW_SURE_STR = ' ???? ???? ?? ??????';
HOW_SURE_STR = double(HOW_SURE_STR);
HOW_SURE_OPTIONS_STR = '1 - 4';
WHICH_MERIDIAN_STR = '(?? ?????? ?? ?????? ? (????/????';
WHICH_MERIDIAN_STR = double(WHICH_MERIDIAN_STR);
GABOR_TILT_STR = '(????? ????? ?????? ???? ? (????/????';
GABOR_TILT_STR = double(GABOR_TILT_STR);
GABOR_SZ_RATIO_OF_DISPLAY_AREA = 0.1;

%Experiment durations
FIXATION_DURATION=500; %msec
FIXATION_TIME_LIMIT_DURATION=10*1000;%msec
IMAGE_DURATION=3000; %msec
MEMORY_TASK_MAX_IMAGE_DURATION=6000; %msec

ALPHA_IMAGE=1;

%psychtoolbox keyboard constants
KBOARD_CODE_A = 65; KBOARD_CODE_B = 66; KBOARD_CODE_C = 67; KBOARD_CODE_D = 68; KBOARD_CODE_E = 69; KBOARD_CODE_F = 70;
KBOARD_CODE_G = 71; KBOARD_CODE_H = 72; KBOARD_CODE_I = 73; KBOARD_CODE_J = 74; KBOARD_CODE_K = 75; KBOARD_CODE_L = 76;
KBOARD_CODE_M = 77; KBOARD_CODE_N = 78; KBOARD_CODE_O = 79; KBOARD_CODE_P = 80; KBOARD_CODE_Q = 81; KBOARD_CODE_R = 82;
KBOARD_CODE_S = 83; KBOARD_CODE_T = 84; KBOARD_CODE_U = 85; KBOARD_CODE_V = 86; KBOARD_CODE_W = 87; KBOARD_CODE_X = 88;
KBOARD_CODE_Y = 89; KBOARD_CODE_Z = 90;
KBOARD_CODE_ESC = 27; KBOARD_CODE_SPACE = 32; KBOARD_CODE_FRONT_SLASH= 191; KBOARD_CODE_ENTER = 13;
KBOARD_CODE_LEFT=37; KBOARD_CODE_UP=38; KBOARD_CODE_RIGHT=39; KBOARD_CODE_DOWN=40; KBOARD_CODE_TILDE = 192;
KBOARD_CODE_0= 48; KBOARD_CODE_9= 57;
KBOARD_CODE_NUMPAD0= 96; KBOARD_CODE_NUMPAD9= 105;
KBOARD_CODE_SHIFT = 16;

CONFIG_KEY_DEC_DISPLAY_AREA_DIST_FROM_CENTER = KBOARD_CODE_A;
CONFIG_KEY_INC_DISPLAY_AREA_DIST_FROM_CENTER = KBOARD_CODE_Q;
CONFIG_KEY_ENLARGE_DISPLAY_AREA_WIDTH = KBOARD_CODE_W;
CONFIG_KEY_SHRINK_DISPLAY_AREA_WIDTH = KBOARD_CODE_S;
CONFIG_KEY_ENLARGE_DISPLAY_AREA_HEIGHT = KBOARD_CODE_E;
CONFIG_KEY_SHRINK_DISPLAY_AREA_HEIGHT = KBOARD_CODE_D;
CONFIG_KEY_ENLARGE_CHECKERBOARD_FRAME = KBOARD_CODE_R;
CONFIG_KEY_SHRINK_CHECKERBOARD_FRAME = KBOARD_CODE_F;
CONFIG_KEY_INC_FRAME_SQRS_ON_HORIZON_SIDE = KBOARD_CODE_T;
CONFIG_KEY_DEC_FRAME_SQRS_ON_HORIZON_SIDE = KBOARD_CODE_G;
CONFIG_KEY_INC_FRAME_SQRS_ON_VERT_SIDE = KBOARD_CODE_Y;
CONFIG_KEY_DEC_FRAME_SQRS_ON_VERT_SIDE = KBOARD_CODE_H;
CONFIG_KEY_ENLARGE_GABOR = KBOARD_CODE_U;
CONFIG_KEY_SHRINK_GABOR = KBOARD_CODE_J;
CONFIG_KEY_TOGGLE_MOD_FRAME_BRIGHT_COLOR = KBOARD_CODE_Z;
CONFIG_KEY_TOGGLE_MOD_BKG_COLOR = KBOARD_CODE_X;
CONFIG_KEY_DEC_RED = KBOARD_CODE_0 + 1;
CONFIG_KEY_INC_RED = KBOARD_CODE_0 + 2;
CONFIG_KEY_DEC_GREEN = KBOARD_CODE_0 + 3;
CONFIG_KEY_INC_GREEN = KBOARD_CODE_0 + 4;
CONFIG_KEY_DEC_BLUE = KBOARD_CODE_0 + 5;
CONFIG_KEY_INC_BLUE = KBOARD_CODE_0 + 6;
CONFIG_KEY_SAVE = KBOARD_CODE_SPACE;

ENABLED_KEYS=[KBOARD_CODE_ENTER,KBOARD_CODE_N,KBOARD_CODE_ESC,KBOARD_CODE_LEFT,KBOARD_CODE_RIGHT,KBOARD_CODE_Q,KBOARD_CODE_W,KBOARD_CODE_SPACE];

%experiment extra gear objects
IO_OBJ= [];
OUT_PORT= [];
OUT_FUNC= [];
IN_PORT= hex2dec('D011'); %on all labs computers
IN_FUNC= [];

%triggers constants
TRIGGER_FIXATION_START=203;
TRIGGER_FIXATION_END=204;
TRIGGER_FIXATION_FAIL=205;
TRIGGER_IMAGE_START=400;
TRIGGER_IMAGE_END=208;
TRIGGER_PRACTICE_BLOCK_START=209;
TRIGGER_PRACTICE_BLOCK_END=210;
TRIGGER_BLOCK_START=211;
TRIGGER_BLOCK_END=212;
TRIGGER_EXPERIMENT_END=213;
TRIGGER_PRACTICE_END=214;

TRIGGER_MEMORY_TASK_START=215;
TRIGGER_MEMORY_TASK_END=216;
TRIGGER_IMAGE_START_MEMORY_TASK=217;
TRIGGER_IMAGE_END_MEMORY_TASK=218;
TRIGGER_SUBJ_ANSWER=219;

TRIGGER_EXPERIMENT_STOPPED=220;
TRIGGER_PAUSE_REQ_START=221;
TRIGGER_PAUSE_REQ_ANSWERED=222;

PORT_SLEEP_CODE= 0;
BIOSEMI_CODE_START= 255;
BIOSEMI_CODE_END= 254;
TRIGGERS_RECORDING_STARTED= 66;
TRIGGERS_RECORDING_ENDED= 67;
TRIGGERS_START_BREAK= 68;
TRIGGERS_END_BREAK= 69;
TRIGGERS_EYE_TRACKER_CALIBRATION_STARTED= 98;
TRIGGERS_EYE_TRACKER_CALIBRATION_ENDED= 99;
TRIGGERS_FIXATION_BROKEN= 200;

TRIGGERS_FIRST_FIXATION_ONSET = 10;
TRIGGERS_GABOR_ONSET_BASE = 200;
TRIGGERS_GABOR_LOC_IDX_BASE = 10;
TRIGGERS_GABOR_TILT_LEFT = 1;
TRIGGERS_GABOR_TILT_RIGHT = 2;
TRIGGERS_DOUBLE_MONDRIAN_PHASE_ONSET = 30;
TRIGGERS_BLANK_PHASE_ONSET = 40;
TRIGGERS_MERIDIAN_RESPONSE_PHASE_ONSET = 50;
TRIGGERS_CERTAINTY_RESPONSE_PHASE_ONSET = 60;
TRIGGERS_GABOR_TILT_RESPONSE_PHASE_ONSET = 70;

%is the experiment supposed to be running? (this flag is assigned a false
%value when the experiment is aborted, for instance by pressing esc and the 'y' key)
IS_EXP_GO= true;

%enumerables
ENUM_EYE_TRACKING_NO_TRACKING= ExperimentGuiBuilder.ENUM_EYE_TRACKING_NO_TRACKING;
ENUM_EYE_TRACKING_DUMMY_MODE= ExperimentGuiBuilder.ENUM_EYE_TRACKING_DUMMY_MODE;
ENUM_EYE_TRACKING_EYE_TRACKER= ExperimentGuiBuilder.ENUM_EYE_TRACKING_EYE_TRACKER;

%% GUI
% construct a gui building class object
gui_builder= ExperimentGuiBuilder(EXPERIMENT_NAME, GUI_BACKGROUND_COLOR, @runExpFunc, GUI_XML_FILE, ~DEBUG);

%PLACE YOUR UICONTROLS DEFINITIONS HERE
%--------------------------------------
%fixation cross uicontrols
gui_builder.uicontrolReadNum(1, 'Fixation Cross Arms Length', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(2, 'Fixation Cross Arms Width', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadColor(3, 'Fixation Cross Color');
gui_builder.uicontrolReadMultipleNums(4, 'Display Area Size (x,y)', 2, ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(5, 'Gabor Diameter', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(6, 'Gabors Horizontal Distance From Center', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(7, 'Gabors Possible Vertical Distance From Center', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(8, 'Gabors Tilt', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNumsGroup(9, 'Mondrian Shapes Sizes [% of display area width]', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadMultipleNums(10, 'First Fixation Durations', 2, ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(11, 'Gabor Phase Duration', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(12, 'Double Mondrian Phase Duration', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(13, 'Mondrian Change Frequency [changes / sec]', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolRadios(14, 'Dominant Eye', {Sides.left, Sides.right}, {'left', 'right'}, 0);
gui_builder.uicontrolReadKey(15, 'Response Key - Left');
gui_builder.uicontrolReadKey(16, 'Response Key - Right');
gui_builder.uicontrolReadMultipleNums(17, 'Dummy to Regular Trials Weights (dummy | regular)', 2, ExperimentGuiBuilder.ENUM_VERIFY_NON_NEGATIVE_INTEGER);
gui_builder.uicontrolReadNumsGroup(18, 'Gabor Contrasts', ExperimentGuiBuilder.ENUM_VERIFY_NON_NEGATIVE_REAL);
gui_builder.uicontrolReadNum(19, 'Gabor Cycles Per Degree', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(20, 'Blank Phase Duration', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(21, 'Certainty Response Time Allowed', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(22, 'Gabor Tilt Response Time Allowed', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(23, 'Display Areas Distance From Center', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(24, 'Checkerboard Frame Width', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_REAL);
gui_builder.uicontrolReadNum(25, 'Checkerboard Squares Number On Width Of Frame', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadNum(26, 'Checkerboard Squares Number On Height Of Frame', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolReadColor(27, 'Checkerboard Bright Color');
gui_builder.uicontrolReadNum(28, 'Binocular Switch Frequency (times/sec)', ExperimentGuiBuilder.ENUM_VERIFY_POSITIVE_INTEGER);
gui_builder.uicontrolRadios(29, 'Calibration Side', {0, 1}, {'Left', 'Right'});
%--------------------------------------

% display the gui
gui_builder.show();

%the [run experiment] callback
    function runExpFunc(~, ~)
        %extract the experiment parameters values from the gui's uicontrols
        common_params_values= gui_builder.getCommonParamsValues();
        LAB_ROOM= common_params_values{1}{1};
        SUBJECT_DISTANCE_FROM_SCREEN= common_params_values{1}{2};
        SCREEN_WIDTH= common_params_values{1}{3};
        SCREEN_HEIGHT= common_params_values{1}{4};
        GAMMA_TABLE_FULL_PATH= common_params_values{1}{5};
        SUBJECT_NUMBER= common_params_values{2};
        SUBJECT_AGE= common_params_values{3};
        SUBJECT_GENDER= common_params_values{4};
        BLOCKS_NR_MULTIPLIER= common_params_values{5};
        TRIALS_NR_MULTIPLIER= common_params_values{6};
        MONDRIAN_RESPONSE_TIME_ALLOWED_IN_MILLIS= common_params_values{7};
        POST_RESPONSE_DELAY= common_params_values{8};
        FORCE_FIXATION= common_params_values{9};
        POST_FIXATION_BREAK_DELAY= common_params_values{10};
        MAX_GAZE_DIST_FROM_CENTER_IN_VANGLES= common_params_values{11};
        EYE_TRACKING_METHOD= common_params_values{12};
        EEG= common_params_values{13};
        BACKGROUND_COLOR= common_params_values{14};
        INEXP_TEXT_COLOR= 1 - round(BACKGROUND_COLOR);
        DEBUG= common_params_values{15};
        
        curr_exp_params_values= gui_builder.getCurrExpParamsValues();
        FIXATION_CROSS_ARMS_LEN_IN_VANGLES= curr_exp_params_values{1};
        FIXATION_CROSS_ARMS_WIDTH_IN_VANGLES= curr_exp_params_values{2};
        FIXATION_CROSS_COLOR= curr_exp_params_values{3};
        DISPLAY_AREA_SZ_IN_VANGLES= curr_exp_params_values{4}; %[x,y]=[width, height]
        GABOR_DIA_IN_VANGLES = curr_exp_params_values{5};
        GABOR_HORIZON_DIST_FROM_CENTER_IN_VANGLES = curr_exp_params_values{6};
        GABOR_POSSIBLE_VERT_DIST_FROM_CENTER_IN_VANGLES = curr_exp_params_values{7};
        GABOR_TILT_IN_DEGS = curr_exp_params_values{8};
        MONDRIAN_SHAPES_SZS = curr_exp_params_values{9};
        FIRST_FIXATION_DURS = curr_exp_params_values{10};
        GABOR_PHASE_DUR = curr_exp_params_values{11};
        DOUBLE_MONDRIAN_PHASE_DUR = curr_exp_params_values{12};
        MONDRIAN_CHANGE_FREQ = curr_exp_params_values{13};
        DOMINANT_EYE = curr_exp_params_values{14};
        RESPONSE_KEY_LEFT = curr_exp_params_values{15};
        RESPONSE_KEY_RIGHT = curr_exp_params_values{16};
        DUMMY_TO_REGULAR_TRIALS_WEIGHTS= curr_exp_params_values{17};
        GABOR_CONTRASTS= curr_exp_params_values{18};
        GABOR_CYCLES_PER_DEGREE = curr_exp_params_values{19};
        BLANK_PHASE_DUR = curr_exp_params_values{20};
        CERTAINTY_RESPONSE_TIME_ALLOWED_IN_MILLIS = curr_exp_params_values{21};
        GABOR_TILT_RESPONSE_TIME_ALLOWED_IN_MILLIS = curr_exp_params_values{22};
        DISPLAY_AREAS_DIST_FROM_CENTER_IN_VANGLES = curr_exp_params_values{23};
        CHECKERBOARD_FRAME_WIDTH_IN_VANGLES = curr_exp_params_values{24};
        CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE = curr_exp_params_values{25};
        CHECKERBOARD_SQRS_NR_ON_VERT_SIDE = curr_exp_params_values{26};
        CHECKERBOARD_BRIGHT_COLOR = curr_exp_params_values{27};
        BINOCULAR_SWITCH_FREQUENCY = curr_exp_params_values{28};
        IS_CALIB_RIGHT = curr_exp_params_values{29};
        
        if DEBUG~=1
            clear LETTERS_PNGS_FOLDER FAULT_WAV GAMMA_TABLE_FULL_PATH LAB_ROOM
            clear BLOCKS_NR_MULTIPLIER TRIALS_NR_MULTIPLIER DUMMY_TO_REGULAR_TRIALS_WEIGHTS
            clear GABOR_DIA_IN_VANGLES GABOR_HORIZON_DIST_FROM_CENTER_IN_VANGLES GABOR_POSSIBLE_VERT_DIST_FROM_CENTER_IN_VANGLES GABOR_TILT_IN_DEGS GABOR_CONTRASTS GABOR_CYCLES_PER_DEGREE
            clear MONDRIAN_SHAPES_SZS MONDRIAN_CHANGE_FREQ
            clear FIRST_FIXATION_DURS GABOR_PHASE_DUR DOUBLE_MONDRIAN_PHASE_DUR BLANK_PHASE_DUR
            clear RESPONSE_KEY_LEFT RESPONSE_KEY_RIGHT BINOCULAR_SWITCH_FREQUENCY MONDRIAN_RESPONSE_TIME_ALLOWED_IN_MILLIS CERTAINTY_RESPONSE_TIME_ALLOWED_IN_MILLIS GABOR_TILT_RESPONSE_TIME_ALLOWED_IN_MILLIS POST_RESPONSE_DELAY
            clear POST_FIXATION_BREAK_DELAY
            clear KBOARD_FIRST_KEY_PRESS_COOLDOWN KBOARD_REPEATED_KEY_PRESS_COOLDOWN KBOARD_COOLDOWNS_VEC KBOARD_COOLDOWNS_REPS_VEC KEY_CODES_ON_COOLDOWN_LIST NORMAL_ADJUST_SZ BIG_ADJUST_SZ AUGMENTED_ADJUST_SZ_FACTOR COOLDOWNS_REPS_FOR_DOUBLE_BIG_ADJUST_SZ ABC_VEC
            clear GABOR_SD_TO_SIZE_RATIO GABOR_TRIM_THRESHOLD HOW_SURE_STR HOW_SURE_OPTIONS_STR WHICH_MERIDIAN_STR GABOR_TILT_STR GABOR_SZ_RATIO_OF_DISPLAY_AREA
            clear CONFIG_KEY_DEC_DISPLAY_AREA_DIST_FROM_CENTER CONFIG_KEY_INC_DISPLAY_AREA_DIST_FROM_CENTER CONFIG_KEY_ENLARGE_DISPLAY_AREA_WIDTH CONFIG_KEY_SHRINK_DISPLAY_AREA_WIDTH CONFIG_KEY_ENLARGE_DISPLAY_AREA_HEIGHT CONFIG_KEY_SHRINK_DISPLAY_AREA_HEIGHT
            clear CONFIG_KEY_ENLARGE_CHECKERBOARD_FRAME CONFIG_KEY_SHRINK_CHECKERBOARD_FRAME CONFIG_KEY_INC_FRAME_SQRS_ON_HORIZON_SIDE CONFIG_KEY_DEC_FRAME_SQRS_ON_HORIZON_SIDE CONFIG_KEY_INC_FRAME_SQRS_ON_VERT_SIDE CONFIG_KEY_DEC_FRAME_SQRS_ON_VERT_SIDE CONFIG_KEY_ENLARGE_GABOR CONFIG_KEY_SHRINK_GABOR
            clear CONFIG_KEY_TOGGLE_MOD_FRAME_BRIGHT_COLOR CONFIG_KEY_TOGGLE_MOD_BKG_COLOR CONFIG_KEY_DEC_RED CONFIG_KEY_INC_RED CONFIG_KEY_DEC_GREEN CONFIG_KEY_INC_GREEN CONFIG_KEY_DEC_BLUE CONFIG_KEY_INC_BLUE CONFIG_KEY_SAVE
            clear IO_OBJ OUT_PORT OUT_FUNC IN_PORT IN_FUNC
            clear PORT_SLEEP_CODE BIOSEMI_CODE_START BIOSEMI_CODE_END TRIGGERS_RECORDING_STARTED TRIGGERS_RECORDING_ENDED TRIGGERS_START_BREAK TRIGGERS_END_BREAK TRIGGERS_FIXATION_BROKEN
            clear TRIGGERS_FIRST_FIXATION_ONSET TRIGGERS_GABOR_ONSET_BASE TRIGGERS_GABOR_LOC_IDX_BASE TRIGGERS_GABOR_TILT_LEFT TRIGGERS_GABOR_TILT_RIGHT TRIGGERS_DOUBLE_MONDRIAN_PHASE_ONSET TRIGGERS_BLANK_PHASE_ONSET TRIGGERS_MERIDIAN_RESPONSE_PHASE_ONSET TRIGGERS_CERTAINTY_RESPONSE_PHASE_ONSET TRIGGERS_GABOR_TILT_RESPONSE_PHASE_ONSET
        end
        
        %close the gui
        gui_builder.hide();
        
        %Subject Parameters
        if DEBUG_CODE==1 || DEBUG==1
            SUBJECT_NUMBER=99;
            SUBJECT_AGE=23;
            SUBJECT_GENDER='F';
            DOMINANT_HAND='R';
            DOMINANT_EYE='R';
        else
            [subInfo,IS_EXP_GO] = getSubjectInfo(IS_EXP_GO);
            if ~IS_EXP_GO
                return
            end
            SUBJECT_NUMBER=subInfo.subjNum;
            SUBJECT_AGE=subInfo.age;
            SUBJECT_GENDER= subInfo.gender;
            DOMINANT_HAND= subInfo.hand;
            DOMINANT_EYE= upper(subInfo.eye);
        end
        SUBJECT_NUMBER_AND_EXPERIMENT=SUBJECT_NUMBER+EXPERIMENT_NUMBER;
        
        switch DOMINANT_EYE
            case 'L'
                DOMINANT_EYE_NUMBER=1;
                NON_DOMINANT_EYE_NUMBER=2;
                IS_CALIB_RIGHT=0;
                DOMINANT_EYE_RIGHT=0;
            case 'R'
                DOMINANT_EYE_NUMBER=2;
                NON_DOMINANT_EYE_NUMBER=1;
                IS_CALIB_RIGHT=1;
                DOMINANT_EYE_RIGHT=1;
        end
        
        %check triggers
        if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
            CHECK_TRIGGERS=1;
        else
            CHECK_TRIGGERS=0;
        end
        
        %Check file uniqueness only for expdata mat file. According to answer do
        %the same thing for edf and workspace files
        [is_file_unique, user_response]= verifyFileUniqueness(fullfile(EXPDATA_SAVE_FOLDER, [EXPDATA_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EXPDATA_SAVE_FILE_NAME_SUFFIX, '.mat']));
        if ~is_file_unique && ~strcmp(user_response,'Overwrite')
            if strcmp(user_response,'Duplicate')
                EXPDATA_SAVE_FILE_NAME_SUFFIX= [EXPDATA_SAVE_FILE_NAME_SUFFIX, annotateFileDuplication(fullfile(EXPDATA_SAVE_FOLDER, [EXPDATA_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EXPDATA_SAVE_FILE_NAME_SUFFIX]), '.mat')];
            else %user_response=='Cancel'
                return;
            end
        end
        
        %[is_file_unique, user_response]= verifyFileUniqueness(fullfile(EDF_SAVE_FOLDER, [EDF_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EDF_FILE_NAME_SUFFIX, '.edf']));
        if ~is_file_unique && ~strcmp(user_response,'Overwrite')
            if strcmp(user_response,'Duplicate')
                EDF_FILE_NAME_SUFFIX= [EDF_FILE_NAME_SUFFIX, annotateFileDuplication(fullfile(EDF_SAVE_FOLDER, [EDF_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EDF_FILE_NAME_SUFFIX]), '.edf')];
            else %user_response=='Cancel'
                return;
            end
        end
        
        %[is_file_unique, user_response]= verifyFileUniqueness(fullfile(WORKSPACE_SAVE_FOLDER, [WORKSPACE_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENTR), WORKSPACE_SAVE_FILE_NAME_SUFFIX, '.mat']));
        if ~is_file_unique && ~strcmp(user_response,'Overwrite')
            if strcmp(user_response,'Duplicate')
                WORKSPACE_SAVE_FILE_NAME_SUFFIX= [WORKSPACE_SAVE_FILE_NAME_SUFFIX, annotateFileDuplication(fullfile(WORKSPACE_SAVE_FOLDER, [WORKSPACE_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), WORKSPACE_SAVE_FILE_NAME_SUFFIX]), '.mat')];
            else %user_response=='Cancel'
                return;
            end
        end
        
        %run the experiment
        runExp();
        
        function annotation= annotateFileDuplication(file_name_without_ext, file_ext)
            does_file_exist= exist([file_name_without_ext, file_ext], 'file');
            duplicates_nr= 0;
            annotation= [];
            while (does_file_exist)
                duplicates_nr= duplicates_nr + 1;
                annotation= ['_duplicate', num2str(duplicates_nr)];
                does_file_exist= exist([file_name_without_ext, annotation, file_ext],'file');
            end
        end
        
        function [is_file_unique, user_response]= verifyFileUniqueness(file_name)
            user_response= [];
            if exist(file_name,'file')
                is_file_unique= false;
                user_response = questdlg(['File "' file_name '" already exists. How to proceed?'],'Confirm save file name','Overwrite','Duplicate','Cancel','Cancel');
            else
                is_file_unique= true;
            end
        end
    end

%% The Experiment Code
    function runExp()
        try
            if DEBUG_CODE==1
                PsychDebugWindowConfiguration
            end
            
            %1. start psychtoolbox and save screen variables as globals
            [window, window_rect]= turnOnPTBView();
            
            oldPriority = Priority(MaxPriority(window));
            if DEBUG~=1
                oldenablekeys = RestrictKeysForKbCheck(ENABLED_KEYS);
            end
            
            [window_center_x, window_center_y]= RectCenter(window_rect);
            window_center= [window_center_x, window_center_y];
            fps = Screen('FrameRate', window);
            ifi = Screen('GetFlipInterval', window);
            waitframes= 1;
            
            %convert globals' units - EDIT
            FIXATION_CROSS_ARMS_LEN= vAngles2pixels(FIXATION_CROSS_ARMS_LEN_IN_VANGLES);
            FIXATION_CROSS_ARMS_WIDTH= vAngles2pixels(FIXATION_CROSS_ARMS_WIDTH_IN_VANGLES);
            MAX_GAZE_DIST_FROM_CENTER= round(vAngles2pixels(MAX_GAZE_DIST_FROM_CENTER_IN_VANGLES));
            
            DISPLAY_AREA_SZ= round(vAngles2pixels(DISPLAY_AREA_SZ_IN_VANGLES));
            DISPLAY_AREAS_DIST_FROM_CENTER = round(vAngles2pixels(DISPLAY_AREAS_DIST_FROM_CENTER_IN_VANGLES));
            
            CHECKERBOARD_FRAME_WIDTH = round(vAngles2pixels(CHECKERBOARD_FRAME_WIDTH_IN_VANGLES));
            
            if DEBUG==1
                GABOR_DIA = round(vAngles2pixels(GABOR_DIA_IN_VANGLES));
                GABOR_TILT = GABOR_TILT_IN_DEGS;
                GABOR_SD_IN_PIXELS= GABOR_SD_TO_SIZE_RATIO*GABOR_DIA;
                GABOR_PHASE_FRAMES_NR = ceil(GABOR_PHASE_DUR / 1000*fps);
                DOUBLE_MONDRIAN_PHASE_FRAMES_NR = ceil(DOUBLE_MONDRIAN_PHASE_DUR / 1000*fps);
                BLANK_PHASE_FRAMES_NR = ceil(BLANK_PHASE_DUR / 1000*fps);
                MONDRIAN_RESPONSE_TIME_ALLOWED = MONDRIAN_RESPONSE_TIME_ALLOWED_IN_MILLIS / 1000;
                CERTAINTY_RESPONSE_TIME_ALLOWED = CERTAINTY_RESPONSE_TIME_ALLOWED_IN_MILLIS / 1000;
                GABOR_TILT_RESPONSE_TIME_ALLOWED = GABOR_TILT_RESPONSE_TIME_ALLOWED_IN_MILLIS / 1000;
                GABORS_RECTS = nan(4,12);
            end
            
            DISPLAY_AREAS_RECTS = [];
            CHECKERBOARDS_RECTS = [];
            genStimuliRects();
            
            %Center of place holders
            [x_Dom,y_Dom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
            place_holder_center=[x_Dom,y_Dom];
            
            if DEBUG==1
                FRAMES_PER_BINOCULAR_SWITCH = ceil(fps / BINOCULAR_SWITCH_FREQUENCY);
                WHICH_MERIDIAN_STR_POS = calcCenterStrPosBySz(WHICH_MERIDIAN_STR);
                HOW_SURE_STR_POS = calcCenterStrPosBySz(HOW_SURE_STR);
                HOW_SURE_OPTIONS_STR_POS = calcCenterStrPosBySz(HOW_SURE_OPTIONS_STR);
                GABOR_TILT_STR_POS = calcCenterStrPosBySz(GABOR_TILT_STR);
            end
            
            NUM_FRAMES_DURING_IMAGE=round(IMAGE_DURATION/(1000*ifi));
            MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK=round(MEMORY_TASK_MAX_IMAGE_DURATION/(1000*ifi));
            
            NUM_FRAMES_DURING_FIXATION= ceil(FIXATION_DURATION/(1000*ifi));
            NUM_FRAMES_FIXATION_TIME_LIMIT=ceil(FIXATION_TIME_LIMIT_DURATION/(1000*ifi));
            
            GAZE_SAMPLES_FOR_FIXATION_MONITORING_VERDICT=NUM_FRAMES_DURING_FIXATION;
            
            %File saving names
            EDF_TEMP_FILE_NAME=[EDF_TEMP_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), '.edf'];
            EDF_FILE_NAME=[EDF_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EDF_FILE_NAME_SUFFIX, '.edf'];
            EXPDATA_SAVE_FILE_NAME=[EXPDATA_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EXPDATA_SAVE_FILE_NAME_SUFFIX];
            WORKSPACE_SAVE_FILE_NAME=[WORKSPACE_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), WORKSPACE_SAVE_FILE_NAME_SUFFIX];
            
            %2. initialize the biosemi and the eye tracker
            initializeGear();
            
            %3. load stuff from files - EDIT
            if IS_EXP_GO
                Instructions= scanMessages();
                resources= loadResources();
                
                %6. start running the experiment - EDIT
                if IS_EXP_GO
                    if DEBUG==1
                        runConfigScreen();
                    else
                        %4. randomize experiment's conditions - EDIT
                        TrialsRandomizedData = randomizeDataForTrials();
                        if IS_EXP_GO
                            %5. define experiment record variables - EDIT
                            initializeDataRecord();
                            %Run practice
                            runExpBlocks(EXPERIMENT_STEPS{1});
                            if IS_EXP_GO
                                %Run experiment
                                runExpBlocks(EXPERIMENT_STEPS{2});
                            end
                        end
                    end
                end
            end
            %7. close everything nicely...
            terminateExp();
            
        catch exception
            if DEBUG==1
                Screen('CloseAll');
                commandwindow;
                rethrow(exception);
            end
            
            terminateExp();
            disp(exception.message);
            for call_depth= 1:length(exception.stack)
                disp(exception.stack(call_depth));
            end
        end
        
        
        % FUNCTIONS IMPLEMENTATIONS
        % stage 1
        function [window, window_rect]= turnOnPTBView()
            PsychDefaultSetup(2);
            screens = Screen('Screens');
            screen_i = max(screens);
            
            Screen('Preference', 'SkipSyncTests', 0);
            
            %             if DEBUG
            %                 Screen('Preference', 'SkipSyncTests', 1);
            %                 Screen('Preference', 'TextRenderer', 0); % activates the old Windows-GDI text renderer that is less good
            %                 ShowCursor;
            %             else
            %                 Screen('Preference', 'SkipSyncTests', 0);
            %                 HideCursor;
            %             end
            
            [window, window_rect] = PsychImaging('OpenWindow', screen_i, BACKGROUND_COLOR);
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('Preference', 'VisualDebugLevel', 4); %sets graphic debugging to the highest level
            
            if DEBUG==1 || DEBUG_CODE==1
                ShowCursor;
            else
                HideCursor;
            end
            
            %Screen('Preference', 'TextEncodingLocale', 'Windows-1244');
            
            %if ~DEBUG && ~isempty(GAMMA_TABLE_FULL_PATH)
            %gamme_table= load(GAMMA_TABLE_FULL_PATH);
            %Screen('LoadNormalizedGammaTable', window, gamme_table.gammaTable*[1 1 1]);
            %end
            
        end
        
        % stage 2
        function initializeGear()
            if EYE_TRACKING_METHOD==ENUM_EYE_TRACKING_NO_TRACKING && ~EEG
                return;
            else
                %                if LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB1
                %                     [IO_OBJ, OUT_PORT]=init_bio;
                %                     IN_FUNC= @() io64(IO_OBJ,IN_PORT);
                %                     OUT_FUNC= @(out_code) io64(IO_OBJ,OUT_PORT,out_code);
                %                elseif LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB2
                %                     IO_OBJ= io64();
                %                     status= io64(IO_OBJ);
                %                     if status~=0
                %                         disp('io64 failed');
                %                     end
                %
                %                     IN_FUNC= @() io64(IO_OBJ,IN_PORT);
                %                end
                
                if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                    %Initalize eyetracker
                    disp('Initizlizing Eye Tracker...');
                    
                    % Provide Eyelink with details about the graphics environment
                    % and perform some initializations. The information is returned
                    % in a structure that also contains useful defaults
                    % and control codes (e.g. tracker state bit and Eyelink key values).
                    EL_PARAMS= EyelinkInitDefaults(window);  % line 406 dekel
                    
                    %Calibration validation background color
                    EL_PARAMS.backgroundcolour=BACKGROUND_COLOR(1);
                    %Must call this function to apply changes to EL_PARAMS
                    EyelinkUpdateDefaults(EL_PARAMS);
                    
                    if ~EyelinkInit(EYE_TRACKING_METHOD==ENUM_EYE_TRACKING_DUMMY_MODE, 1)
                        disp('Error in eyelink initiation')
                        IS_EXP_GO=0;
                        return
                    end
                    
                    %[~ ,vs]=Eyelink('GetTrackerVersion');
                    %fprintf('Running experiment on a ''%s'' tracker.\n', vs );
                    
                    % make sure that we get gaze data from the Eyelink
                    %Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
                    
                    %Get and save el defaults (to return in the end of the
                    %experiment)
                    EL_DEFAULTS=getEyeLinkDefaults(EL_DEFAULTS);
                    
                    % open file to record data to
                    status = Eyelink('openfile', EDF_TEMP_FILE_NAME);
                    if status ~= 0
                        disp(['Error opening eyelink file: error code ' num2str(status) '.']);
                        IS_EXP_GO=0;
                        return
                    end
                    
                    %assign preferences values
                    elSetup(window_rect(3),window_rect(4),SCREEN_WIDTH,SCREEN_HEIGHT,IS_CALIB_RIGHT,DOMINANT_EYE);
                    
                    %start recording eyetracker data
                    %Eyelink('Command','set_idle_mode');
                    %WaitSecs(0.05);
                    %Eyelink('StartRecording');
                    
                    %not relevant becuase Eyelink('EyeAvailable') returns
                    %-1 I think it is becuase the recording doesn't start
                    %yet
%                     if EYE_TRACKING_METHOD==ENUM_EYE_TRACKING_EYE_TRACKER
%                         eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
%                         %returns 0 (LEFT EYE), 1 (RIGHT EYE), 2 (BINOCULAR)
%                         %depending on what data
%                         if eye_used == EL_PARAMS.BINOCULAR % if both eyes are tracked
%                             eye_used = EL_PARAMS.RIGHT_EYE; % use right eye
%                         end
%                         disp(['Eye used: ' num2str(eye_used)]);
%                     end
                    
                    %construct a fixation monitor class object
                    FIXATION_MONITOR= FixationMonitor(EL_PARAMS, MAX_GAZE_DIST_FROM_CENTER, GAZE_SAMPLES_FOR_FIXATION_MONITORING_VERDICT);
                end
                
                %                 if LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB1 && EEG
                %                     sendTrigger(PORT_SLEEP_CODE);
                %
                %                     %start recording eeg data and send a synchronization trigger
                %                     sendTrigger(BIOSEMI_CODE_START);
                %                     WaitSecs(0.2);
                %                     sendTrigger(TRIGGERS_RECORDING_STARTED);
                %                     WaitSecs(0.2);
                %                     sendTrigger(TRIGGERS_RECORDING_STARTED);
                %                     WaitSecs(0.2);
                %                     sendTrigger(TRIGGERS_RECORDING_STARTED);
                %                     WaitSecs(0.2);
                %                 end
            end
        end
        
        % stage 3
        function Instructions= scanMessages()
            %load instructions
            msgs= loadImagesFromFolder(MSGS_FOLDER,'png');
            msgs= [msgs, loadImagesFromFolder(MSGS_FOLDER,'jpg')];
            %create text from instructions
            for ii=1:length(msgs)
                msgsTex(ii) = Screen('MakeTexture', window, msgs{ii});
            end
            Instructions.msgsIm=msgs;
            Instructions.msgsTex=msgsTex;
        end
        
        function resources= loadResources()
            %InitializePsychSound;
            %resources.fault_snd_ppa_handle = buildPsychPortAudioHandle(FAULT_WAV);
            
            resources.sqr_tex = pngFileToTex(SQR_PNG);
            
            if DEBUG==1
                contrasts_nr = numel(GABOR_CONTRASTS);
                resources.gabor_texes = NaN(1, contrasts_nr);
                for contrast_idx = 1:contrasts_nr
                    resources.gabor_texes(contrast_idx) = createGaborTex(window, BACKGROUND_COLOR(1), GABOR_DIA, vAngles2pixels(1/GABOR_CYCLES_PER_DEGREE), 0, GABOR_SD_IN_PIXELS, 0, GABOR_TRIM_THRESHOLD, GABOR_CONTRASTS(contrast_idx));
                end
            end
            
            %create stimuli images for experiment
            cd(IMAGES_EXPERIMENT_FOLDER);
            Images = dir('*.jpg');
            I=imread(Images(1).name);
            Image_Size=size(I);
            cd(CURRENT_FOLDER)
            IS_EXP_GO=checkImSize(IMAGES_EXPERIMENT_FOLDER,Image_Size,IS_EXP_GO);
            resources.Images=TexFromImages(Images,IMAGES_EXPERIMENT_FOLDER,Image_Size); %This code assumes all images are in the same size
            clear I Images
            
            %create stimuli images for practice
            cd(IMAGES_PRACTICE_FOLDER);
            Images = dir('*.jpg');
            cd(CURRENT_FOLDER)
            IS_EXP_GO=checkImSize(IMAGES_PRACTICE_FOLDER,Image_Size,IS_EXP_GO);
            resources.ImagesPractice=TexFromImages(Images,IMAGES_PRACTICE_FOLDER,Image_Size); %This code assumes all images are in the same size
            clear Images
            
            %create stimuli images for memory task
            cd(IMAGES_MEMORY_TASK_FOLDER);
            Images = dir('*.jpg');
            cd(CURRENT_FOLDER)
            IS_EXP_GO=checkImSize(IMAGES_MEMORY_TASK_FOLDER,Image_Size,IS_EXP_GO);
            resources.ImagesMemoryTask=TexFromImages(Images,IMAGES_MEMORY_TASK_FOLDER,Image_Size); %This code assumes all images are in the same size
            clear Images
            
            %create stimuli images for memory task practice
            cd(IMAGES_MEMORY_TASK_PRACTICE_FOLDER);
            Images = dir('*.jpg');
            cd(CURRENT_FOLDER)
            IS_EXP_GO=checkImSize(IMAGES_MEMORY_TASK_PRACTICE_FOLDER,Image_Size,IS_EXP_GO);
            resources.ImagesMemoryTaskPractice=TexFromImages(Images,IMAGES_MEMORY_TASK_PRACTICE_FOLDER,Image_Size); %This code assumes all images are in the same size
            clear Images
            
            %create checkboard texture
            resources.checkerboard_tex = createCheckerboardTex();
            
            %create stereogram
            createStereograms(DISPLAY_AREA_SZ,STEREOGRAM_SAVE_FOLDER)
            cd(STEREOGRAM_SAVE_FOLDER);
            Images = dir('*.bmp');
            resources.Stereograms=TexFromImageStereogram(Images);
            cd(CURRENT_FOLDER)
            clear Images
        end
        
        function runConfigScreen()
            xml_handler = XMLHandler(GUI_XML_FILE, 'CURR_EXP_UICONTROLS', 'COMMON_UICONTROLS');
            
            drawBinocularScreen(GetSecs(), {resources.Mondrians.mondriansTexture{1}, resources.gabor_texes(1)}, {DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER), GABORS_RECTS(:,2)}, {0, 45});
            frame_bright_color_mod_on = false;
            bkg_color_mod_on = false;
            while (1)
                [is_key_down, ~, pressed_key_codes_vec, time_delta] = KbCheck();
                
                if pressed_key_codes_vec(KBOARD_CODE_ESC) == 1
                    break;
                end
                
                % resume key codes for which button was released
                resumed_key_codes_on_cooldown_logical_vec = pressed_key_codes_vec(KEY_CODES_ON_COOLDOWN_LIST) == 0;
                resumed_key_codes_on_cooldown = KEY_CODES_ON_COOLDOWN_LIST(resumed_key_codes_on_cooldown_logical_vec);
                KBOARD_COOLDOWNS_VEC(resumed_key_codes_on_cooldown) = 0;
                KBOARD_COOLDOWNS_REPS_VEC(resumed_key_codes_on_cooldown) = 0;
                KEY_CODES_ON_COOLDOWN_LIST(resumed_key_codes_on_cooldown_logical_vec) = [];
                if is_key_down
                    if ~isempty(KEY_CODES_ON_COOLDOWN_LIST)
                        % decrement cooldowns and clear slots in pressed_key_codes_vec whose corresopnding key codes
                        % are still on cooldown
                        KBOARD_COOLDOWNS_VEC(KEY_CODES_ON_COOLDOWN_LIST) = max(KBOARD_COOLDOWNS_VEC(KEY_CODES_ON_COOLDOWN_LIST) - time_delta, 0);
                        finished_cooldowns_logical_vec = KBOARD_COOLDOWNS_VEC(KEY_CODES_ON_COOLDOWN_LIST) == 0;
                        pressed_key_codes_vec(KEY_CODES_ON_COOLDOWN_LIST(~finished_cooldowns_logical_vec)) = 0;
                        
                        % update vectors
                        key_codes_with_finished_cooldowns = KEY_CODES_ON_COOLDOWN_LIST(finished_cooldowns_logical_vec);
                        newly_pressed_key_codes = setdiff(find(pressed_key_codes_vec), key_codes_with_finished_cooldowns);
                        KEY_CODES_ON_COOLDOWN_LIST = [KEY_CODES_ON_COOLDOWN_LIST, newly_pressed_key_codes]; %#ok<AGROW>
                        KBOARD_COOLDOWNS_REPS_VEC(KEY_CODES_ON_COOLDOWN_LIST) = KBOARD_COOLDOWNS_REPS_VEC(KEY_CODES_ON_COOLDOWN_LIST) + 1;
                        KBOARD_COOLDOWNS_VEC(newly_pressed_key_codes) = KBOARD_FIRST_KEY_PRESS_COOLDOWN;
                        KBOARD_COOLDOWNS_VEC(key_codes_with_finished_cooldowns) = KBOARD_REPEATED_KEY_PRESS_COOLDOWN;
                    else
                        newly_pressed_key_codes = find(pressed_key_codes_vec);
                        KEY_CODES_ON_COOLDOWN_LIST = newly_pressed_key_codes;
                        KBOARD_COOLDOWNS_REPS_VEC(newly_pressed_key_codes) = 1;
                        KBOARD_COOLDOWNS_VEC(newly_pressed_key_codes) = KBOARD_FIRST_KEY_PRESS_COOLDOWN;
                    end
                    
                    if pressed_key_codes_vec(CONFIG_KEY_SAVE) == 1
                        xml_handler.saveXML();
                        continue;
                    end
                    
                    if pressed_key_codes_vec(KBOARD_CODE_SHIFT) == 1
                        % TODO : bug here - cant have shift on cooldown
                        is_big_adjust_on = true;
                    else
                        is_big_adjust_on = false;
                    end
                    
                    if frame_bright_color_mod_on
                        if pressed_key_codes_vec(CONFIG_KEY_TOGGLE_MOD_FRAME_BRIGHT_COLOR) == 1
                            frame_bright_color_mod_on = false;
                            clearKeysCooldowns();
                            KBOARD_COOLDOWNS_VEC(CONFIG_KEY_TOGGLE_MOD_FRAME_BRIGHT_COLOR) = KBOARD_FIRST_KEY_PRESS_COOLDOWN;
                            continue;
                        end
                        adjust_val = getColorAdjustVal(is_big_adjust_on, CHECKERBOARD_BRIGHT_COLOR);
                        CHECKERBOARD_BRIGHT_COLOR = CHECKERBOARD_BRIGHT_COLOR + adjust_val;
                        
                        xml_handler.saveExpValueByNodeName('c15', CHECKERBOARD_BRIGHT_COLOR);
                    elseif bkg_color_mod_on
                        if pressed_key_codes_vec(CONFIG_KEY_TOGGLE_MOD_BKG_COLOR) == 1
                            bkg_color_mod_on = false;
                            clearKeysCooldowns();
                            KBOARD_COOLDOWNS_VEC(CONFIG_KEY_TOGGLE_MOD_BKG_COLOR) = KBOARD_FIRST_KEY_PRESS_COOLDOWN;
                            continue;
                        end
                        adjust_val = getColorAdjustVal(is_big_adjust_on, BACKGROUND_COLOR);
                        BACKGROUND_COLOR = BACKGROUND_COLOR + adjust_val;
                        
                        xml_handler.saveCommonValueByNodeName('c14', BACKGROUND_COLOR);
                    else
                        if pressed_key_codes_vec(CONFIG_KEY_TOGGLE_MOD_FRAME_BRIGHT_COLOR) == 1
                            frame_bright_color_mod_on = true;
                            clearKeysCooldowns();
                            KBOARD_COOLDOWNS_VEC(CONFIG_KEY_TOGGLE_MOD_FRAME_BRIGHT_COLOR) = KBOARD_FIRST_KEY_PRESS_COOLDOWN;
                            continue;
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_TOGGLE_MOD_BKG_COLOR) == 1
                            bkg_color_mod_on = true;
                            clearKeysCooldowns();
                            KBOARD_COOLDOWNS_VEC(CONFIG_KEY_TOGGLE_MOD_BKG_COLOR) = KBOARD_FIRST_KEY_PRESS_COOLDOWN;
                            continue;
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_INC_DISPLAY_AREA_DIST_FROM_CENTER) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_INC_DISPLAY_AREA_DIST_FROM_CENTER);
                            if DISPLAY_AREAS_DIST_FROM_CENTER + DISPLAY_AREA_SZ(1)/2 + CHECKERBOARD_FRAME_WIDTH + adjust_sz < window_rect(3)/2
                                DISPLAY_AREAS_DIST_FROM_CENTER = DISPLAY_AREAS_DIST_FROM_CENTER + adjust_sz;
                                xml_handler.saveExpValueByNodeName('c23',pixels2vAngles(DISPLAY_AREAS_DIST_FROM_CENTER));
                            end
                        elseif pressed_key_codes_vec(CONFIG_KEY_DEC_DISPLAY_AREA_DIST_FROM_CENTER) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_DEC_DISPLAY_AREA_DIST_FROM_CENTER);
                            if DISPLAY_AREAS_DIST_FROM_CENTER - adjust_sz > DISPLAY_AREA_SZ(1)/2 + CHECKERBOARD_FRAME_WIDTH
                                DISPLAY_AREAS_DIST_FROM_CENTER = DISPLAY_AREAS_DIST_FROM_CENTER - adjust_sz;
                                xml_handler.saveExpValueByNodeName('c23',pixels2vAngles(DISPLAY_AREAS_DIST_FROM_CENTER));
                            end
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_ENLARGE_DISPLAY_AREA_WIDTH) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_ENLARGE_DISPLAY_AREA_WIDTH);
                            if DISPLAY_AREAS_DIST_FROM_CENTER + DISPLAY_AREA_SZ(1)/2 + CHECKERBOARD_FRAME_WIDTH + adjust_sz < window_rect(3)/2
                                DISPLAY_AREA_SZ(1) = DISPLAY_AREA_SZ(1) + adjust_sz;
                                GABOR_DIA = sqrt(4*DISPLAY_AREA_SZ(1)*DISPLAY_AREA_SZ(2)*GABOR_SZ_RATIO_OF_DISPLAY_AREA/pi); %HARD-CODED GABOR DIA
                                xml_handler.saveExpValueByNodeName('c4',pixels2vAngles(DISPLAY_AREA_SZ));
                                xml_handler.saveExpValueByNodeName('c5', pixels2vAngles(GABOR_DIA));
                            end
                        elseif pressed_key_codes_vec(CONFIG_KEY_SHRINK_DISPLAY_AREA_WIDTH) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_SHRINK_DISPLAY_AREA_WIDTH);
                            if DISPLAY_AREA_SZ(1) - adjust_sz > 0
                                DISPLAY_AREA_SZ(1) = DISPLAY_AREA_SZ(1) - adjust_sz;
                                GABOR_DIA = sqrt(4*DISPLAY_AREA_SZ(1)*DISPLAY_AREA_SZ(2)*GABOR_SZ_RATIO_OF_DISPLAY_AREA/pi);  %HARD-CODED GABOR DIA
                                xml_handler.saveExpValueByNodeName('c4',pixels2vAngles(DISPLAY_AREA_SZ));
                                xml_handler.saveExpValueByNodeName('c5', pixels2vAngles(GABOR_DIA));
                            end
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_ENLARGE_DISPLAY_AREA_HEIGHT) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_ENLARGE_DISPLAY_AREA_HEIGHT);
                            if DISPLAY_AREA_SZ(2)/2 + CHECKERBOARD_FRAME_WIDTH + adjust_sz < window_rect(4)/2
                                DISPLAY_AREA_SZ(2) = DISPLAY_AREA_SZ(2) + adjust_sz;
                                GABOR_DIA = sqrt(4*DISPLAY_AREA_SZ(1)*DISPLAY_AREA_SZ(2)*GABOR_SZ_RATIO_OF_DISPLAY_AREA/pi);  %HARD-CODED GABOR DIA
                                xml_handler.saveExpValueByNodeName('c4', pixels2vAngles(DISPLAY_AREA_SZ));
                                xml_handler.saveExpValueByNodeName('c5', pixels2vAngles(GABOR_DIA));
                            end
                        elseif pressed_key_codes_vec(CONFIG_KEY_SHRINK_DISPLAY_AREA_HEIGHT) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_SHRINK_DISPLAY_AREA_HEIGHT);
                            if DISPLAY_AREA_SZ(2) - adjust_sz > 0
                                DISPLAY_AREA_SZ(2) = DISPLAY_AREA_SZ(2) - adjust_sz;
                                GABOR_DIA = sqrt(4*DISPLAY_AREA_SZ(1)*DISPLAY_AREA_SZ(2)*GABOR_SZ_RATIO_OF_DISPLAY_AREA/pi);  %HARD-CODED GABOR DIA
                                xml_handler.saveExpValueByNodeName('c4', pixels2vAngles(DISPLAY_AREA_SZ));
                                xml_handler.saveExpValueByNodeName('c5', pixels2vAngles(GABOR_DIA));
                            end
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_ENLARGE_CHECKERBOARD_FRAME) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_ENLARGE_CHECKERBOARD_FRAME);
                            if DISPLAY_AREAS_DIST_FROM_CENTER + DISPLAY_AREA_SZ(1)/2 + CHECKERBOARD_FRAME_WIDTH + adjust_sz < window_rect(3) / 2 && ...
                                    DISPLAY_AREA_SZ(2)/2 + CHECKERBOARD_FRAME_WIDTH + adjust_sz < window_rect(4) / 2
                                CHECKERBOARD_FRAME_WIDTH = CHECKERBOARD_FRAME_WIDTH + adjust_sz;
                                Screen('Close', resources.checkerboard_tex);
                                resources.checkerboard_tex = createCheckerboardTex();
                                xml_handler.saveExpValueByNodeName('c24', pixels2vAngles(CHECKERBOARD_FRAME_WIDTH));
                            end
                        elseif pressed_key_codes_vec(CONFIG_KEY_SHRINK_CHECKERBOARD_FRAME) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_SHRINK_CHECKERBOARD_FRAME);
                            if CHECKERBOARD_FRAME_WIDTH - adjust_sz > 0
                                CHECKERBOARD_FRAME_WIDTH = CHECKERBOARD_FRAME_WIDTH - adjust_sz;
                                Screen('Close', resources.checkerboard_tex);
                                resources.checkerboard_tex = createCheckerboardTex();
                                xml_handler.saveExpValueByNodeName('c24', pixels2vAngles(CHECKERBOARD_FRAME_WIDTH));
                            end
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_INC_FRAME_SQRS_ON_HORIZON_SIDE) == 1
                            CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE= CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE + 1;
                            Screen('Close', resources.checkerboard_tex);
                            resources.checkerboard_tex = createCheckerboardTex();
                            xml_handler.saveExpValueByNodeName('c25', CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE);
                        elseif pressed_key_codes_vec(CONFIG_KEY_DEC_FRAME_SQRS_ON_HORIZON_SIDE) == 1 && CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE > 1
                            CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE = CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE - 1;
                            Screen('Close', resources.checkerboard_tex);
                            resources.checkerboard_tex = createCheckerboardTex();
                            xml_handler.saveExpValueByNodeName('c25', CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE);
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_INC_FRAME_SQRS_ON_VERT_SIDE) == 1
                            CHECKERBOARD_SQRS_NR_ON_VERT_SIDE = CHECKERBOARD_SQRS_NR_ON_VERT_SIDE + 1;
                            Screen('Close', resources.checkerboard_tex);
                            resources.checkerboard_tex = createCheckerboardTex();
                            xml_handler.saveExpValueByNodeName('c26', CHECKERBOARD_SQRS_NR_ON_VERT_SIDE);
                        elseif pressed_key_codes_vec(CONFIG_KEY_DEC_FRAME_SQRS_ON_VERT_SIDE) == 1 && CHECKERBOARD_SQRS_NR_ON_VERT_SIDE > 1
                            CHECKERBOARD_SQRS_NR_ON_VERT_SIDE = CHECKERBOARD_SQRS_NR_ON_VERT_SIDE - 1;
                            Screen('Close', resources.checkerboard_tex);
                            resources.checkerboard_tex = createCheckerboardTex();
                            xml_handler.saveExpValueByNodeName('c26', CHECKERBOARD_SQRS_NR_ON_VERT_SIDE);
                        end
                        
                        if pressed_key_codes_vec(CONFIG_KEY_ENLARGE_GABOR) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_ENLARGE_GABOR);
                            GABOR_DIA = GABOR_DIA + adjust_sz;
                            xml_handler.saveExpValueByNodeName('c5', pixels2vAngles(GABOR_DIA));
                        elseif pressed_key_codes_vec(CONFIG_KEY_SHRINK_GABOR) == 1
                            adjust_sz = getAdjustSz(is_big_adjust_on, CONFIG_KEY_ENLARGE_GABOR);
                            if GABOR_DIA - adjust_sz > 0
                                GABOR_DIA = GABOR_DIA - adjust_sz;
                                xml_handler.saveExpValueByNodeName('c5', pixels2vAngles(GABOR_DIA));
                            end
                        end
                    end
                    
                    genStimuliRects();
                    drawBinocularScreen(GetSecs(), {resources.Mondrians.mondriansTexture{1}, resources.gabor_texes(1)}, {DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER), GABORS_RECTS(:,2)}, {0, 45});
                    %drawBinocularScreen(GetSecs(), {resources.gabor_texes(1), resources.gabor_texes(1)}, {GABORS_RECTS(:,3), GABORS_RECTS(:,2)}, {45, 45});
                end
            end
            
            function adjust_sz = getAdjustSz(is_big_adjust_on, key_code)
                if KBOARD_COOLDOWNS_REPS_VEC(key_code) >= COOLDOWNS_REPS_FOR_DOUBLE_BIG_ADJUST_SZ
                    adjust_sz_factor = AUGMENTED_ADJUST_SZ_FACTOR;
                else
                    adjust_sz_factor = 1;
                end
                
                if is_big_adjust_on
                    adjust_sz = BIG_ADJUST_SZ * adjust_sz_factor;
                else
                    adjust_sz = NORMAL_ADJUST_SZ * adjust_sz_factor;
                end
            end
            
            function color_adjust_val = getColorAdjustVal(is_big_adjust_on, curr_color_val)
                color_adjust_val = zeros(1,3);
                if pressed_key_codes_vec(CONFIG_KEY_INC_RED) == 1
                    color_adjust_val(1) = getAdjustSz(is_big_adjust_on, CONFIG_KEY_INC_RED);
                elseif pressed_key_codes_vec(CONFIG_KEY_DEC_RED) == 1
                    color_adjust_val(1) = -getAdjustSz(is_big_adjust_on, CONFIG_KEY_DEC_RED);
                end
                
                if pressed_key_codes_vec(CONFIG_KEY_INC_GREEN) == 1
                    color_adjust_val(2) = getAdjustSz(is_big_adjust_on, CONFIG_KEY_INC_GREEN);
                elseif pressed_key_codes_vec(CONFIG_KEY_DEC_GREEN) == 1
                    color_adjust_val(2) = -getAdjustSz(is_big_adjust_on, CONFIG_KEY_DEC_GREEN);
                end
                
                if pressed_key_codes_vec(CONFIG_KEY_INC_BLUE) == 1
                    color_adjust_val(3) = getAdjustSz(is_big_adjust_on, CONFIG_KEY_INC_BLUE);
                elseif pressed_key_codes_vec(CONFIG_KEY_DEC_BLUE) == 1
                    color_adjust_val(3) = -getAdjustSz(is_big_adjust_on, CONFIG_KEY_DEC_BLUE);
                end
                
                color_adjust_val(curr_color_val + color_adjust_val < 0.0 | curr_color_val + color_adjust_val > 1.0) = 0.0;
            end
            
            function clearKeysCooldowns()
                KBOARD_COOLDOWNS_VEC(KEY_CODES_ON_COOLDOWN_LIST) = 0;
                KBOARD_COOLDOWNS_REPS_VEC(KEY_CODES_ON_COOLDOWN_LIST) = 0;
                KEY_CODES_ON_COOLDOWN_LIST = [];
            end
        end
        
        % stage 4
        function initializeDataRecord()
            EXPDATA.info.general_info.session_time = datestr(now);
            EXPDATA.info.general_info.experiment_duration= [];
            EXPDATA.info.general_info.practice_duration= [];
            EXPDATA.info.general_info.experiment_start= [];
            EXPDATA.info.general_info.experiment_end= [];
            EXPDATA.info.general_info.practice_start= [];
            EXPDATA.info.general_info.practice_end= [];
            EXPDATA.info.general_info.calibration_data_Experiment=[];
            EXPDATA.info.general_info.calibration_data_Practice=[];
            
            EXPDATA.info.subject_info.subject_number = SUBJECT_NUMBER;
            EXPDATA.info.subject_info.subject_number_and_experiment = SUBJECT_NUMBER_AND_EXPERIMENT;
            EXPDATA.info.subject_info.experiment_number = EXPERIMENT_NUMBER;
            EXPDATA.info.subject_info.subject_gender = SUBJECT_GENDER;
            EXPDATA.info.subject_info.subject_age = SUBJECT_AGE;
            EXPDATA.info.subject_info.dominant_hand = DOMINANT_HAND;
            EXPDATA.info.subject_info.dominant_eye = DOMINANT_EYE;
            EXPDATA.info.subject_info.dominant_eye_number = DOMINANT_EYE_NUMBER;
            
            EXPDATA.info.lab_setup.subject_distance_from_screen_in_cm= SUBJECT_DISTANCE_FROM_SCREEN;
            EXPDATA.info.lab_setup.screen_width_in_cm= SCREEN_WIDTH;
            EXPDATA.info.lab_setup.screen_width_in_pixels= window_rect(3);
            EXPDATA.info.lab_setup.screen_width_in_visual_degrees= pixels2vAngles(window_rect(3));
            EXPDATA.info.lab_setup.screen_height_in_cm= SCREEN_HEIGHT;
            EXPDATA.info.lab_setup.screen_height_in_pixels= window_rect(4);
            EXPDATA.info.lab_setup.screen_height_in_visual_degrees= pixels2vAngles(window_rect(4));
            EXPDATA.info.lab_setup.pixels_per_vdegree= EXPDATA.info.lab_setup.screen_width_in_pixels/EXPDATA.info.lab_setup.screen_width_in_visual_degrees;
            EXPDATA.info.lab_setup.FPS= fps;
            EXPDATA.info.lab_setup.IFI= ifi;
            
            EXPDATA.info.experiment_parameters.image_duration=IMAGE_DURATION;
            EXPDATA.info.experiment_parameters.fixation_duration=FIXATION_DURATION;
            EXPDATA.info.experiment_parameters.memory_task_max_image_duration=MEMORY_TASK_MAX_IMAGE_DURATION;
            
            EXPDATA.info.experiment_parameters.fixation_cross_arms_length= FIXATION_CROSS_ARMS_LEN_IN_VANGLES;
            EXPDATA.info.experiment_parameters.fixation_cross_arms_width= FIXATION_CROSS_ARMS_WIDTH_IN_VANGLES;
            EXPDATA.info.experiment_parameters.fixation_cross_color= FIXATION_CROSS_COLOR;
            EXPDATA.info.experiment_parameters.display_area_size= DISPLAY_AREA_SZ_IN_VANGLES;
            
            EXPDATA.info.experiment_parameters.display_areas_distance_from_center = DISPLAY_AREAS_DIST_FROM_CENTER_IN_VANGLES;
            EXPDATA.info.experiment_parameters.checkerboard_frame_width = CHECKERBOARD_FRAME_WIDTH_IN_VANGLES;
            EXPDATA.info.experiment_parameters.checkerboard_sqrs_nr_on_horizontal_side = CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE;
            EXPDATA.info.experiment_parameters.checkerboard_sqrs_nr_on_vertical_side = CHECKERBOARD_SQRS_NR_ON_VERT_SIDE;
            EXPDATA.info.experiment_parameters.checkerboard_bright_color = CHECKERBOARD_BRIGHT_COLOR;
            if CHECK_TRIGGERS
                EXPDATA.check_Triggers.block_start.TrackerTime=[];
                EXPDATA.check_Triggers.block_start.TriggerNumber=[];
                EXPDATA.check_Triggers.block_end.TrackerTime=[];
                EXPDATA.check_Triggers.block_end.TriggerNumber=[];
                EXPDATA.check_Triggers.memory_task_start.TrackerTime=[];
                EXPDATA.check_Triggers.memory_task_start.TriggerNumber=[];
                EXPDATA.check_Triggers.memory_task_end.TrackerTime=[];
                EXPDATA.check_Triggers.memory_task_end.TriggerNumber=[];
                EXPDATA.check_Triggers.experiment_end.TrackerTime=[];
                EXPDATA.check_Triggers.experiment_end.TriggerNumber=[];
                
                EXPDATA.check_Triggers.practice_block_start.TrackerTime=[];
                EXPDATA.check_Triggers.practice_block_start.TriggerNumber=[];
                EXPDATA.check_Triggers.practice_block_end.TrackerTime=[];
                EXPDATA.check_Triggers.practice_block_end.TriggerNumber=[];
                EXPDATA.check_Triggers.practice_memory_task_start.TrackerTime=[];
                EXPDATA.check_Triggers.practice_memory_task_start.TriggerNumber=[];
                EXPDATA.check_Triggers.practice_memory_task_end.TrackerTime=[];
                EXPDATA.check_Triggers.practice_memory_task_end.TriggerNumber=[];
                EXPDATA.check_Triggers.practice_end.TrackerTime=[];
                EXPDATA.check_Triggers.practice_end.TriggerNumber=[];
            end
            
            for step_i=1:length(EXPERIMENT_STEPS)
                %Experiment trials
                clear Trials
                switch EXPERIMENT_STEPS{step_i}
                    case 'Experiment'
                        NumTrials=length(TrialsRandomizedData.image_order_random);
                    case 'Practice'
                        NumTrials=length(TrialsRandomizedData.image_order_random_practice);
                end
                for trial_i= 1:NumTrials
                    Trials(trial_i).BlockNum=[];
                    Trials(trial_i).TrialNum=[];
                    Trials(trial_i).NumRepetitionFixationFail=[];
                    Trials(trial_i).TrialDuration=[];
                    Trials(trial_i).ImageID=[];
                    Trials(trial_i).ImageName=[];
                    
                    Trials(trial_i).Tex=[];
                    Trials(trial_i).Alpha=[];
                    Trials(trial_i).RectNonDom=[];
                    Trials(trial_i).RectDom=[];
                    
                    Trials(trial_i).Init_Trial_screen_vbl=[];
                    Trials(trial_i).PressInitSecs=[];
                    Trials(trial_i).PressInitdeltaSecs=[];
                    Trials(trial_i).fixation_vbls=[];
                    Trials(trial_i).image_vbls=[];
                    Trials(trial_i).Image_End=[];
                    
                    Trials(trial_i).ImagePresentationTime=[];
                    Trials(trial_i).ImageWantedPresentationTime=[];
                    Trials(trial_i).trial_end_vbl=[];
                    
                    if CHECK_TRIGGERS
                        Trials(trial_i).check_Triggers.fixation_start.TrackerTime=[];
                        Trials(trial_i).check_Triggers.fixation_start.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.fixation_end.TrackerTime=[];
                        Trials(trial_i).check_Triggers.fixation_end.TriggerNumber=[];
                        
                        Trials(trial_i).check_Triggers.image_start.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_start.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.image_end.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_end.TriggerNumber=[];
                    end
                end
                EXPDATA.(['Trials','_',EXPERIMENT_STEPS{step_i}])=Trials;
                
                %Memory Task trials
                clear Trials
                switch EXPERIMENT_STEPS{step_i}
                    case 'Experiment'
                        NumTrials=TrialsRandomizedData.num_trials_memory_task_experiment;
                    case 'Practice'
                        NumTrials=length(TrialsRandomizedData.memoryTaskPractice.imageId_random);
                end
                for trial_i= 1:NumTrials
                    Trials(trial_i).BlockNum=[];
                    Trials(trial_i).TrialNum=[];
                    Trials(trial_i).TrialDuration=[];
                    Trials(trial_i).ImageID=[];
                    Trials(trial_i).ImageType=[];
                    Trials(trial_i).ImageName=[];
                    
                    Trials(trial_i).DidAnswer=[];
                    Trials(trial_i).Response=[];
                    Trials(trial_i).IsCorrect= [];
                    Trials(trial_i).RT=[];
                    
                    Trials(trial_i).Tex=[];
                    Trials(trial_i).Alpha=[];
                    Trials(trial_i).RectNonDom=[];
                    Trials(trial_i).RectDom=[];
                    
                    Trials(trial_i).image_vbls=[];
                    Trials(trial_i).PressAnswerSecs=[];
                    Trials(trial_i).PressAnswerdeltaSecs=[];
                    Trials(trial_i).Image_End=[];
                    
                    Trials(trial_i).ImagePresentationTime=[];
                    Trials(trial_i).ImageWantedPresentationTime=[];
                    Trials(trial_i).trial_end_vbl=[];
                    
                    if CHECK_TRIGGERS
                        Trials(trial_i).check_Triggers.image_start_memory_task.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_start_memory_task.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.subj_answer.TrackerTime=[];
                        Trials(trial_i).check_Triggers.subj_answer.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.image_end_memory_task.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_end_memory_task.TriggerNumber=[];
                    end
                end
                EXPDATA.(['Memory_Task_Trials','_',EXPERIMENT_STEPS{step_i}])=Trials;
            end
        end
        
        % stage 5
        % reminder -> loop through the trials if the randomizing functions dont
        % fit (dont use matlab vector indexing crap)
        function TrialsRandomizedData = randomizeDataForTrials()
            rng('default');
            rng('shuffle');
            
            %randomize data for experiment
            num_images=length(resources.Images.ImageName);
            TrialsRandomizedData.num_images_block=ceil(num_images/NUM_BLOCKS);
            TrialsRandomizedData.num_images_last_block=num_images-((NUM_BLOCKS-1)*TrialsRandomizedData.num_images_block);
            TrialsRandomizedData.image_order_random=randperm(num_images);
            
            %randomize data for practice
            num_images_practice=length(resources.ImagesPractice.ImageName);
            TrialsRandomizedData.image_order_random_practice=randperm(num_images_practice);
            
            %randomize data for memory task
            num_new_images_MT=length(resources.ImagesMemoryTask.ImageName);
            num_new_images_block_MT=floor(num_new_images_MT/NUM_BLOCKS);
            rand_order_new=randperm(num_new_images_MT);
            rand_order_block=TrialsRandomizedData.image_order_random;
            for ii=1:NUM_BLOCKS
                new_images=rand_order_new(1:num_new_images_block_MT);
                rand_order_new(1:num_new_images_block_MT)=[];
                
                if ii==NUM_BLOCKS
                    all_block_images=rand_order_block;
                else
                    all_block_images=rand_order_block(1:TrialsRandomizedData.num_images_block);
                    rand_order_block(1:TrialsRandomizedData.num_images_block)=[];
                end
                block_images=all_block_images(randperm(length(all_block_images),length(new_images)));
                
                imageId=[new_images,block_images];
                imageType=[zeros(1,length(new_images)),ones(1,length(block_images))]; %0-new image 1-block image
                
                ind=randperm(length(imageId));
                TrialsRandomizedData.memoryTask(ii).imageId_random=imageId(ind);
                TrialsRandomizedData.memoryTask(ii).imageType_random=imageType(ind); %0-new image 1-block image
            end
            TrialsRandomizedData.num_trials_memory_task_experiment=num_new_images_MT*2;
            
            %randomize data for memory task practice
            num_new_images_MT_practice=length(resources.ImagesMemoryTaskPractice.ImageName);
            
            new_images=randperm(num_new_images_MT_practice);
            
            all_practice_images=TrialsRandomizedData.image_order_random_practice;
            practice_images=all_practice_images(randperm(length(all_practice_images),length(new_images)));
            
            imageId=[new_images,practice_images];
            imageType=[zeros(1,length(new_images)),ones(1,length(practice_images))]; %0-new image 1-practice image
            
            ind=randperm(length(imageId));
            TrialsRandomizedData.memoryTaskPractice.imageId_random=imageId(ind);
            TrialsRandomizedData.memoryTaskPractice.imageType_random=imageType(ind); %0-new image 1-practice image
        end
        
        % stage 6
        function runExpBlocks(ExpStep)
            %Initialize variables
            exp_start_vbl=GetSecs();
            trial_i_overall=0;
            trial_i_overall_MT=0;
            CALIBRATION_DATA.calibration_msg_str=[];
            CALIBRATION_DATA.calibration_done_before_trial=[];
            CALIBRATION_DATA.calibration_beginning_block=[];
            memory_task_start.TrackerTime=[];
            memory_task_start.TriggerNumber=[];
            memory_task_end.TrackerTime=[];
            memory_task_end.TriggerNumber=[];
                    
            switch ExpStep
                case 'Experiment'
                    %Initialize variables
                    RandTrialsOrder=TrialsRandomizedData.image_order_random;
                    Images=resources.Images;
                    num_blocks_in_step=NUM_BLOCKS;
                case 'Practice'
                    %Initialize variables
                    RandTrialsOrder=TrialsRandomizedData.image_order_random_practice;
                    Images=resources.ImagesPractice;
                    num_blocks_in_step=1;
                    
                    %Check fusion
                    PresentStereograms();
                    if ~IS_EXP_GO
                        return
                    end
                    
                    %Present instructions 1
                    drawImageInstructions(Instructions.msgsTex(6));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press 
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 2
                    drawImageInstructions(Instructions.msgsTex(7));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 3
                    drawImageInstructions(Instructions.msgsTex(8));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaqSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 4
                    drawImageInstructions(Instructions.msgsTex(9));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 5
                    drawImageInstructions(Instructions.msgsTex(10));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
            end
            
            %Blocks loop
            for block_i=1:num_blocks_in_step
                switch ExpStep
                    case 'Experiment'
                        %Present block
                        drawImageInstructions(Instructions.msgsTex(1));
                        WaitSecs(0.3);
                        
                        sendEyelinkMsg(num2str(TRIGGER_BLOCK_START));
                        if CHECK_TRIGGERS
                            block_start.TrackerTime(block_i)=Eyelink('TrackerTime');
                            block_start.TriggerNumber{block_i}=num2str(TRIGGER_BLOCK_START);
                        end
                        
                        if block_i==num_blocks_in_step
                            NumTrialsInBlock=TrialsRandomizedData.num_images_last_block;
                        else
                            NumTrialsInBlock=TrialsRandomizedData.num_images_block;
                        end
                    case 'Practice'
                        %Present Practice block
                        drawImageInstructions(Instructions.msgsTex(2));
                        WaitSecs(0.3);
                        
                        sendEyelinkMsg(num2str(TRIGGER_PRACTICE_BLOCK_START));
                        if CHECK_TRIGGERS
                            practice_block_start.TrackerTime(block_i)=Eyelink('TrackerTime');
                            practice_block_start.TriggerNumber{block_i}=num2str(TRIGGER_PRACTICE_BLOCK_START);
                        end
                        
                        NumTrialsInBlock=length(RandTrialsOrder);
                end
                
                %Wait for subject to press
                respMade=false;
                while ~respMade
                    [~, Secs, keyCode,deltaSecs] = KbCheck;
                    if keyCode(KBOARD_CODE_SPACE)
                        respMade=true;
                    end
                end
                
                %Trials loop
                for trial_i=1:NumTrialsInBlock
                    trial_i_overall=trial_i_overall+1;
                    
                    if trial_i==1 %if first trial in block
                        %Calibration in the first trial in a block
                        %Present eye setup page
                        drawImageInstructions(Instructions.msgsTex(11));
                        WaitSecs(0.3);
                        
                        %Wait for subject to press
                        respMade=false;
                        while ~respMade
                            [~, Secs, keyCode,deltaSecs] = KbCheck;
                            if keyCode(KBOARD_CODE_SPACE)
                                respMade=true;
                            end
                        end
                        
                        RestrictKeysForKbCheck(oldenablekeys);
                        msg_str=runCalibrationQuery();
                        if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                            CALIBRATION_DATA.calibration_msg_str{end+1}=msg_str;
                            CALIBRATION_DATA.calibration_done_before_trial(end+1)=trial_i_overall;
                            CALIBRATION_DATA.calibration_beginning_block(end+1)=1;
                        end
                        RestrictKeysForKbCheck(ENABLED_KEYS);
                        
                        last_trial_end_vbl=GetSecs();
                    end
                    
                    %Organize variables before trial
                    ImageID=RandTrialsOrder(trial_i_overall);
                    fixation_fail=1;
                    NumRepetitionFixationFail=0;
                    
                    while fixation_fail
                        trial_end_vbl= runTrial(trial_i_overall,block_i,trial_i,last_trial_end_vbl,ImageID,NumRepetitionFixationFail);
                        if ~IS_EXP_GO
                            return
                        end
                        if fixation_fail
                            NumRepetitionFixationFail=NumRepetitionFixationFail+1;
                        end
                    end
                    last_trial_end_vbl= trial_end_vbl;
                end
                
                %save the behavioral data for the block
                switch ExpStep
                    case 'Experiment'
                        ongoingFileName = createOutputFile(SUBJECT_NUMBER_AND_EXPERIMENT,ONGOING_RESULTS_FOLDER,['_b',num2str(block_i)]);
                        save (ongoingFileName,'EXPDATA');
                    case 'Practice'
                        ongoingFileName = createOutputFile(SUBJECT_NUMBER_AND_EXPERIMENT,ONGOING_RESULTS_FOLDER,'_Practice');
                        save (ongoingFileName,'EXPDATA');
                end
                
                %display the screen for the end of the block
                switch ExpStep
                    case 'Experiment'
                        drawImageInstructions(Instructions.msgsTex(3));
                        sendEyelinkMsg(num2str(TRIGGER_BLOCK_END));
                        if CHECK_TRIGGERS
                            block_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                            block_end.TriggerNumber{block_i}=num2str(TRIGGER_BLOCK_END);
                        end
                    case 'Practice'
                        drawImageInstructions(Instructions.msgsTex(3));
                        sendEyelinkMsg(num2str(TRIGGER_PRACTICE_BLOCK_END));
                        if CHECK_TRIGGERS
                            practice_block_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                            practice_block_end.TriggerNumber{block_i}=num2str(TRIGGER_PRACTICE_BLOCK_END);
                        end
                end

                %Wait for subject to press
                respMade=false;
                while ~respMade
                    [~, Secs, keyCode,deltaSecs] = KbCheck;
                    if keyCode(KBOARD_CODE_SPACE)
                        respMade=true;
                    elseif keyCode(KBOARD_CODE_ESC)
                        checkPauseReq(Secs);
                        if ~IS_EXP_GO
                            sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED)); %this trigger cant be checked as it's data isn't saved in EXPDATA code finishes in return
                            respMade=true;
                            return
                        else
                            drawImageInstructions(Instructions.msgsTex(3));
                        end
                    end
                end
                               
                %display the screen for the memory task
                drawImageInstructions(Instructions.msgsTex(12));
                sendEyelinkMsg(num2str(TRIGGER_MEMORY_TASK_START));
                if CHECK_TRIGGERS
                    memory_task_start.TrackerTime(block_i)=Eyelink('TrackerTime');
                    memory_task_start.TriggerNumber{block_i}=num2str(TRIGGER_MEMORY_TASK_START);
                end
                
                %Wait for subject to press
                WaitSecs(0.3);
                respMade=false;
                while ~respMade
                    [~, Secs, keyCode,deltaSecs] = KbCheck;
                    if keyCode(KBOARD_CODE_SPACE)
                        respMade=true;
                    elseif keyCode(KBOARD_CODE_ESC)
                        checkPauseReq(Secs);
                        if ~IS_EXP_GO
                            sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED)); %this trigger cant be checked as it's data isn't saved in EXPDATA code finishes in return
                            respMade=true;
                            return
                        else
                            drawImageInstructions(Instructions.msgsTex(12));
                        end
                    end
                end
                
                %memory task
                %parameters for memory task
                switch ExpStep
                    case 'Experiment'
                        imageId_random_MT=TrialsRandomizedData.memoryTask(block_i).imageId_random;
                        imageType_random_MT=TrialsRandomizedData.memoryTask(block_i).imageType_random;
                        Images_MT=resources.ImagesMemoryTask;
                    case 'Practice'
                        imageId_random_MT=TrialsRandomizedData.memoryTaskPractice.imageId_random;
                        imageType_random_MT=TrialsRandomizedData.memoryTaskPractice.imageType_random;
                        Images_MT=resources.ImagesMemoryTaskPractice;
                end
                
                NumTrialsInBlockMT=length(imageId_random_MT);
                
                %trials loop memory task
                for trial_i_MT=1:NumTrialsInBlockMT
                    if trial_i_MT==1
                        last_trial_end_vbl=GetSecs();
                    end
                    
                    trial_i_overall_MT=trial_i_overall_MT+1;
                    
                    %parameters for trial
                    imageId_MT=imageId_random_MT(trial_i_MT);
                    imageType_MT=imageType_random_MT(trial_i_MT);
                    
                    trial_end_vbl_MT=runMemoryTrial(trial_i_overall_MT,block_i,trial_i_MT,last_trial_end_vbl,imageId_MT,imageType_MT);
                    last_trial_end_vbl=trial_end_vbl_MT;
                end
                
                if (block_i~=num_blocks_in_step && strcmp(ExpStep,'Experiment')) || strcmp(ExpStep,'Practice')
                    %display the screen for the end of the memory task
                    drawImageInstructions(Instructions.msgsTex(13));
                    sendEyelinkMsg(num2str(TRIGGER_MEMORY_TASK_END));
                    if CHECK_TRIGGERS
                        memory_task_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                        memory_task_end.TriggerNumber{block_i}=num2str(TRIGGER_MEMORY_TASK_END);
                    end
                    
                    %Wait for subject to press
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        elseif keyCode(KBOARD_CODE_ESC)
                            checkPauseReq(Secs);
                            if ~IS_EXP_GO
                                sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED)); %this trigger cant be checked as it's data isn't saved in EXPDATA code finishes in return
                                respMade=true;
                                return
                            else
                                drawImageInstructions(Instructions.msgsTex(13));
                            end
                        end
                    end
                end
            end
            
            switch ExpStep
                case 'Experiment'
                    %display the screen for the end of the experiment
                    exp_end_vbl= drawImageInstructions(Instructions.msgsTex(4));
                    sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_END));
                    if CHECK_TRIGGERS
                        experiment_end.TrackerTime=Eyelink('TrackerTime');
                        experiment_end.TriggerNumber=num2str(TRIGGER_EXPERIMENT_END);
                    end
                    
                    %save data
                    EXPDATA.info.general_info.experiment_duration= exp_end_vbl - exp_start_vbl;
                    EXPDATA.info.general_info.experiment_start= exp_start_vbl;
                    EXPDATA.info.general_info.experiment_end= exp_end_vbl;
                    if CHECK_TRIGGERS
                        EXPDATA.check_Triggers.block_start=block_start;
                        EXPDATA.check_Triggers.block_end=block_end;
                        EXPDATA.check_Triggers.memory_task_start=memory_task_start;
                        EXPDATA.check_Triggers.memory_task_end=memory_task_end;
                        EXPDATA.check_Triggers.experiment_end=experiment_end;
                    end
                    EXPDATA.info.general_info.calibration_data_Experiment=CALIBRATION_DATA;
                case 'Practice'
                    %display the screen for the end of the practice block
                    practice_end_vbl=drawImageInstructions(Instructions.msgsTex(5));
                    sendEyelinkMsg(num2str(TRIGGER_PRACTICE_END));
                    if CHECK_TRIGGERS
                        practice_end.TrackerTime=Eyelink('TrackerTime');
                        practice_end.TriggerNumber=num2str(TRIGGER_PRACTICE_END);
                    end
                    
                    %save data
                    EXPDATA.info.general_info.practice_duration= practice_end_vbl - exp_start_vbl;
                    EXPDATA.info.general_info.practice_start= exp_start_vbl;
                    EXPDATA.info.general_info.practice_end= practice_end_vbl;
                    if CHECK_TRIGGERS
                        EXPDATA.check_Triggers.practice_block_start=practice_block_start;
                        EXPDATA.check_Triggers.practice_block_end=practice_block_end;
                        EXPDATA.check_Triggers.practice_memory_task_start=memory_task_start;
                        EXPDATA.check_Triggers.practice_memory_task_end=memory_task_end;
                        EXPDATA.check_Triggers.practice_end=practice_end;
                    end
                    EXPDATA.info.general_info.calibration_data_Practice=CALIBRATION_DATA;
                    
                    %Wait for subject to press
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        elseif keyCode(KBOARD_CODE_ESC)
                            checkPauseReq(Secs);
                            if ~IS_EXP_GO
                                sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED));
                                respMade=true;
                                return
                            else
                                %display the screen for the end of the practice block
                                drawImageInstructions(Instructions.msgsTex(3));
                            end
                        end
                    end
            end
            
            % function runTrial - run a single trial sequence
            % ---------------------------------------------------------------------------------------------------
            function trial_end_vbl= runTrial(TrialNumOverall,BlockNum,TrialNum,last_trial_end_vbl,ImageID,NumRepetitionFixationFail)
                if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                    Eyelink('message',['TrialId_Overall ',ExpStep,': ',num2str(TrialNumOverall)]);
                    Eyelink('message',['ImageNumber: ',num2str(ImageID)]);
                end
                
                %Initialize variables
                fixation_fail=0;
                trial_end_vbl=NaN;
                image_vbls=nan(1,NUM_FRAMES_DURING_IMAGE);
                Tex=nan(1,NUM_FRAMES_DURING_IMAGE);
                Alpha=nan(1,NUM_FRAMES_DURING_IMAGE);
                RectNonDom=nan(4,NUM_FRAMES_DURING_IMAGE);
                RectDom=nan(4,NUM_FRAMES_DURING_IMAGE);
                
                % trial sequence
                drawPlaceHolders()
                Init_Trial_screen_vbl = Screen('Flip', window, last_trial_end_vbl + (waitframes - 0.5) * ifi);
                
                %wait for the subject to press enter
                respMade=false;
                while ~respMade
                    [~, PressInitSecs, keyCode,PressInitdeltaSecs] = KbCheck;
                    if keyCode(KBOARD_CODE_ENTER)
                        respMade=true;
                    elseif keyCode(KBOARD_CODE_ESC)
                        answerSecs=checkPauseReq(PressInitSecs);
                        if ~IS_EXP_GO
                            sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED));
                            respMade=true;
                            return
                        else
                            drawPlaceHolders()
                            Screen('Flip', window, answerSecs);
                        end
                    end
                end
                
                %Fixation cross
                if FORCE_FIXATION && EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                    %Initialize variables
                    fixation_flag=1;
                    frame_idx_fix=0;
                    
                    while fixation_flag
                        frame_idx_fix= frame_idx_fix+1;
                        
                        %draw fixation cross
                        drawPlaceHolders()
                        drawFixationCrossAtPos([window_center_x - DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y], FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
                        drawFixationCrossAtPos([window_center_x + DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y], FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
                        if frame_idx_fix==1
                            fixation_vbls(1) = Screen('Flip', window, PressInitSecs);
                            sendEyelinkMsg(num2str(TRIGGER_FIXATION_START));
                            if CHECK_TRIGGERS
                                fixation_start.TrackerTime=Eyelink('TrackerTime');
                                fixation_start.TriggerNumber=num2str(TRIGGER_FIXATION_START);
                            end
                        else
                            fixation_vbls(frame_idx_fix) = Screen('Flip', window, fixation_vbls(frame_idx_fix-1)+ (waitframes - 0.5) * ifi);
                        end
                        
                        %Test if fixation is on target
                        [FIXATION_MONITOR, test_result]= FIXATION_MONITOR.testFixationResponse(place_holder_center);
                        if test_result==FIXATION_MONITOR.FIXATION_MONITOR_RESULT_IS_ON_TARGET
                            fixation_flag=0;
                        end
                        
                        if fixation_flag==1 && frame_idx_fix==NUM_FRAMES_FIXATION_TIME_LIMIT
                            fixation_fail=1;
                            sendEyelinkMsg(num2str(TRIGGER_FIXATION_FAIL)); %this trigger cant be checked as it's data isn't saved in EXPDATA code finishes in return
                            RestrictKeysForKbCheck(oldenablekeys);
                            CALIBRATION_DATA.calibration_msg_str{end+1}=runCalibrationQuery();
                            CALIBRATION_DATA.calibration_done_before_trial(end+1)=TrialNumOverall;
                            CALIBRATION_DATA.calibration_beginning_block(end+1)=0;
                            RestrictKeysForKbCheck(ENABLED_KEYS);
                            trial_end_vbl = GetSecs();
                            return
                        end
                        
                        [~, Secs, keyCode,~] = KbCheck;
                        if keyCode(KBOARD_CODE_ESC)
                            answerSecs=checkPauseReq(Secs);
                            if ~IS_EXP_GO
                                sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED)); %this trigger cant be checked as it's data isn't saved in EXPDATA code finishes in return
                                return
                            else
                                drawPlaceHolders()
                                drawFixationCrossAtPos([window_center_x - DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y], FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
                                drawFixationCrossAtPos([window_center_x + DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y], FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
                                Screen('Flip', window, answerSecs);
                            end
                        end
                    end
                else
                    drawPlaceHolders()
                    drawFixationCrossAtPos([window_center_x - DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y], FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
                    drawFixationCrossAtPos([window_center_x + DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y], FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
                    fixation_vbls = Screen('Flip', window, PressInitSecs);
                    sendEyelinkMsg(num2str(TRIGGER_FIXATION_START));
                    if CHECK_TRIGGERS
                        fixation_start.TrackerTime=Eyelink('TrackerTime');
                        fixation_start.TriggerNumber=num2str(TRIGGER_FIXATION_START);
                    end
                end
                
                %Present stimulus
                for frame_idx=1:NUM_FRAMES_DURING_IMAGE
                    drawPlaceHolders()
                    %Image
                    Tex(frame_idx)=Images.ImageTexture(ImageID);
                    Alpha(frame_idx)=ALPHA_IMAGE;
                    RectNonDom(:,frame_idx)=Images.dstRectsNonDom(:,ImageID);
                    RectDom(:,frame_idx)=Images.dstRectsDom(:,ImageID);
                    
                    Screen('DrawTextures', window, Tex(frame_idx), [], [RectNonDom(:,frame_idx),RectDom(:,frame_idx)],[],[],Alpha(frame_idx));

                    if frame_idx==1
                        if FORCE_FIXATION && EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                            image_vbls(1) = Screen('Flip', window, fixation_vbls(end) + (waitframes - 0.5) * ifi);
                        else
                            image_vbls(1) = Screen('Flip', window, fixation_vbls(end) + (NUM_FRAMES_DURING_FIXATION- 0.5) * ifi);
                        end
                        sendEyelinkMsg(num2str(TRIGGER_FIXATION_END));
                        if CHECK_TRIGGERS
                            fixation_end.TrackerTime=Eyelink('TrackerTime');
                            fixation_end.TriggerNumber=num2str(TRIGGER_FIXATION_END);
                        end
                        sendEyelinkMsg(num2str(TRIGGER_IMAGE_START));
                        if CHECK_TRIGGERS
                            image_start.TrackerTime=Eyelink('TrackerTime');
                            image_start.TriggerNumber=num2str(TRIGGER_IMAGE_START);
                        end
                    else
                        image_vbls(frame_idx) = Screen('Flip', window, image_vbls(frame_idx-1)+ (waitframes - 0.5) * ifi);
                    end
                end
                
                %Finish Trial
                drawPlaceHolders()
                Image_End = Screen('Flip', window, image_vbls(end) + (waitframes - 0.5) * ifi);
                sendEyelinkMsg(num2str(TRIGGER_IMAGE_END));
                if CHECK_TRIGGERS
                    image_end.TrackerTime=Eyelink('TrackerTime');
                    image_end.TriggerNumber=num2str(TRIGGER_IMAGE_END);
                end
                
                %Save data
                fieldName=['Trials','_',ExpStep];
                EXPDATA.(fieldName)(TrialNumOverall).BlockNum=BlockNum;
                EXPDATA.(fieldName)(TrialNumOverall).TrialNum=TrialNum;
                EXPDATA.(fieldName)(TrialNumOverall).NumRepetitionFixationFail=NumRepetitionFixationFail;
                EXPDATA.(fieldName)(TrialNumOverall).ImageID=ImageID;
                EXPDATA.(fieldName)(TrialNumOverall).ImageName=Images.ImageName{ImageID};
                
                EXPDATA.(fieldName)(TrialNumOverall).Tex=Tex;
                EXPDATA.(fieldName)(TrialNumOverall).Alpha=Alpha;
                EXPDATA.(fieldName)(TrialNumOverall).RectNonDom=RectNonDom;
                EXPDATA.(fieldName)(TrialNumOverall).RectDom=RectDom;
                
                EXPDATA.(fieldName)(TrialNumOverall).Init_Trial_screen_vbl=Init_Trial_screen_vbl;
                EXPDATA.(fieldName)(TrialNumOverall).PressInitSecs=PressInitSecs;
                EXPDATA.(fieldName)(TrialNumOverall).PressInitdeltaSecs=PressInitdeltaSecs;
                EXPDATA.(fieldName)(TrialNumOverall).fixation_vbls=fixation_vbls;
                EXPDATA.(fieldName)(TrialNumOverall).image_vbls=image_vbls;
                EXPDATA.(fieldName)(TrialNumOverall).Image_End=Image_End;
                
                EXPDATA.(fieldName)(TrialNumOverall).ImagePresentationTime=Image_End-image_vbls(1);
                EXPDATA.(fieldName)(TrialNumOverall).ImageWantedPresentationTime=IMAGE_DURATION/1000; %sec
                
                if CHECK_TRIGGERS
                    EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.fixation_start=fixation_start;
                    EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.fixation_end=fixation_end;
                    EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_start=image_start;
                    EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_end=image_end;
                end
                
                %End trial time
                trial_end_vbl = GetSecs();
                EXPDATA.(fieldName)(TrialNumOverall).trial_end_vbl=trial_end_vbl;
                EXPDATA.(fieldName)(TrialNumOverall).TrialDuration= trial_end_vbl-Init_Trial_screen_vbl;
            end
            
            function trial_end_vbl_MT=runMemoryTrial(trial_i_overall_MT,block_i,trial_i_MT,last_trial_end_vbl,imageId_MT,imageType_MT)
                if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                    Eyelink('message',['Memory Task TrialId_Overall ',ExpStep,': ',num2str(trial_i_overall_MT)]);
                end
                
                %Initialize variables
                trial_end_vbl_MT=NaN;
                DidAnswer=0;
                Response=NaN;
                subj_answer.TrackerTime=[];
                subj_answer.TriggerNumber=[];
                
                image_vbls=nan(1,MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK);
                Tex=nan(1,MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK);
                Alpha=nan(1,MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK);
                RectNonDom=nan(4,MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK);
                RectDom=nan(4,MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK);
                
                %trial sequence
                %Present stimulus
                for frame_idx=1:MAX_NUM_FRAMES_DURING_IMAGE_MEMORY_TASK
                    drawPlaceHolders()
                    %if ~mod(frame_idx,2) %even frame
                    %Image
                    if imageType_MT==0 %new image
                        Tex(frame_idx)=Images_MT.ImageTexture(imageId_MT);
                        Alpha(frame_idx)=ALPHA_IMAGE;
                        RectNonDom(:,frame_idx)=Images_MT.dstRectsNonDom(:,imageId_MT);
                        RectDom(:,frame_idx)=Images_MT.dstRectsDom(:,imageId_MT);
                    elseif imageType_MT==1 %image from block
                        Tex(frame_idx)=Images.ImageTexture(imageId_MT);
                        Alpha(frame_idx)=ALPHA_IMAGE;
                        RectNonDom(:,frame_idx)=Images.dstRectsNonDom(:,imageId_MT);
                        RectDom(:,frame_idx)=Images.dstRectsDom(:,imageId_MT);
                    end
                    Screen('DrawTextures', window, Tex(frame_idx), [], [RectNonDom(:,frame_idx),RectDom(:,frame_idx)],[],[],Alpha(frame_idx));
                    %end
                    
                    if frame_idx==1
                        image_vbls(1) = Screen('Flip', window, last_trial_end_vbl + (waitframes - 0.5) * ifi);
                        
                        sendEyelinkMsg(num2str(TRIGGER_IMAGE_START_MEMORY_TASK));
                        if CHECK_TRIGGERS
                            image_start_memory_task.TrackerTime=Eyelink('TrackerTime');
                            image_start_memory_task.TriggerNumber=num2str(TRIGGER_IMAGE_START_MEMORY_TASK);
                        end
                    else
                        image_vbls(frame_idx) = Screen('Flip', window, image_vbls(frame_idx-1)+ (waitframes - 0.5) * ifi);
                    end
                    
                    %Check if the subject answered question
                    [~, PressAnswerSecs, keyCode, PressAnswerdeltaSecs] = KbCheck;
                    if keyCode(KBOARD_CODE_RIGHT)
                        sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER));
                        if CHECK_TRIGGERS
                            subj_answer.TrackerTime=Eyelink('TrackerTime');
                            subj_answer.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER);
                        end
                        DidAnswer=1;
                        Response=1;
                        break
                    elseif keyCode(KBOARD_CODE_LEFT)
                        sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER));
                        if CHECK_TRIGGERS
                            subj_answer.TrackerTime=Eyelink('TrackerTime');
                            subj_answer.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER);
                        end
                        DidAnswer=1;
                        Response=0;
                        break
                    end
                end
                
                %Finish Trial
                drawPlaceHolders()
                if DidAnswer==0
                    Image_End = Screen('Flip', window, image_vbls(end) + (waitframes - 0.5) * ifi);
                elseif DidAnswer==1
                    Image_End = Screen('Flip', window, PressAnswerSecs);
                end
                sendEyelinkMsg(num2str(TRIGGER_IMAGE_END_MEMORY_TASK));
                if CHECK_TRIGGERS
                    image_end_memory_task.TrackerTime=Eyelink('TrackerTime');
                    image_end_memory_task.TriggerNumber=num2str(TRIGGER_IMAGE_END_MEMORY_TASK);
                end
                
                %Save data
                fieldName=['Memory_Task_Trials','_',ExpStep];
                EXPDATA.(fieldName)(trial_i_overall_MT).BlockNum=block_i;
                EXPDATA.(fieldName)(trial_i_overall_MT).TrialNum=trial_i_MT;
                EXPDATA.(fieldName)(trial_i_overall_MT).ImageID=imageId_MT;
                EXPDATA.(fieldName)(trial_i_overall_MT).ImageType=imageType_MT;
                if imageType_MT==0 %new image
                    EXPDATA.(fieldName)(trial_i_overall_MT).ImageName=Images_MT.ImageName{imageId_MT};
                elseif imageType_MT==1 %image from block
                    EXPDATA.(fieldName)(trial_i_overall_MT).ImageName=Images.ImageName{imageId_MT};
                end
                
                EXPDATA.(fieldName)(trial_i_overall_MT).DidAnswer=DidAnswer;
                EXPDATA.(fieldName)(trial_i_overall_MT).Response=Response;
                EXPDATA.(fieldName)(trial_i_overall_MT).IsCorrect= (Response==imageType_MT);
                EXPDATA.(fieldName)(trial_i_overall_MT).RT=PressAnswerSecs-image_vbls(1);
                
                if DidAnswer==1
                    image_vbls((frame_idx+1):end)=[];
                    Tex((frame_idx+1):end)=[];
                    Alpha((frame_idx+1):end)=[];
                    RectNonDom(:,(frame_idx+1):end)=[];
                    RectDom(:,(frame_idx+1):end)=[];
                end
                EXPDATA.(fieldName)(trial_i_overall_MT).Tex=Tex;
                EXPDATA.(fieldName)(trial_i_overall_MT).Alpha=Alpha;
                EXPDATA.(fieldName)(trial_i_overall_MT).RectNonDom=RectNonDom;
                EXPDATA.(fieldName)(trial_i_overall_MT).RectDom=RectDom;
                
                EXPDATA.(fieldName)(trial_i_overall_MT).image_vbls=image_vbls;
                if DidAnswer==1
                    EXPDATA.(fieldName)(trial_i_overall_MT).PressAnswerSecs=PressAnswerSecs;
                    EXPDATA.(fieldName)(trial_i_overall_MT).PressAnswerdeltaSecs=PressAnswerdeltaSecs;
                    EXPDATA.(fieldName)(trial_i_overall_MT).ImageWantedPresentationTime=PressAnswerSecs-image_vbls(1);
                elseif DidAnswer==0
                    EXPDATA.(fieldName)(trial_i_overall_MT).PressAnswerSecs=NaN;
                    EXPDATA.(fieldName)(trial_i_overall_MT).PressAnswerdeltaSecs=NaN;
                    EXPDATA.(fieldName)(trial_i_overall_MT).ImageWantedPresentationTime=MEMORY_TASK_MAX_IMAGE_DURATION/1000; %sec
                end
                EXPDATA.(fieldName)(trial_i_overall_MT).Image_End=Image_End;
                EXPDATA.(fieldName)(trial_i_overall_MT).ImagePresentationTime=Image_End-image_vbls(1);
                
                if CHECK_TRIGGERS
                    EXPDATA.(fieldName)(trial_i_overall_MT).check_Triggers.image_start_memory_task=image_start_memory_task;
                    EXPDATA.(fieldName)(trial_i_overall_MT).check_Triggers.image_end_memory_task=image_end_memory_task;
                    EXPDATA.(fieldName)(trial_i_overall_MT).check_Triggers.subj_answer=subj_answer;
                end
                
                %End trial time
                trial_end_vbl_MT = GetSecs();
                EXPDATA.(fieldName)(trial_i_overall_MT).trial_end_vbl=trial_end_vbl_MT;
                EXPDATA.(fieldName)(trial_i_overall_MT).TrialDuration= trial_end_vbl_MT-image_vbls(1);
                
                %Time between trials (so that the key that was pressed
                %to answer does not effect the next trial)
                WaitSecs(0.3);
            end
        end
        
        % stage 7
        function terminateExp()
            cd(CURRENT_FOLDER)
            if DEBUG~=1
                saveData();
            end
            %send a synchronization trigger
            %             if LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB1 && EEG
            %                 sendTrigger(TRIGGERS_RECORDING_ENDED);
            %                 WaitSecs(0.2);
            %                 sendTrigger(TRIGGERS_RECORDING_ENDED);
            %                 WaitSecs(0.2);
            %                 sendTrigger(TRIGGERS_RECORDING_ENDED);
            %                 WaitSecs(3);
            %             end
            
            %stop the eyetracker
            if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                %adds 100 msec of data to catch final events
                WaitSecs(0.1);
                Eyelink('StopRecording');
            end
            
            %stop the biosemi recording
            %             if EEG
            %                 sendTrigger(BIOSEMI_CODE_END);
            %             end
            
            %save the eyetracker recording data
            if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                % Retrieve Eyelink EDF file
                disp('Retrieving EDF file from eye-tracker.');
                Eyelink('Command','set_idle_mode');
                WaitSecs(0.05);
                Eyelink('CloseFile');
                stat = Eyelink('ReceiveFile',EDF_TEMP_FILE_NAME);
                if stat <= 0
                    disp( ['Error in retrieving EDF file: ' ,fullfile(EDF_SAVE_FOLDER, EDF_FILE_NAME)] );
                end
                
                movefile(EDF_TEMP_FILE_NAME, fullfile(EDF_SAVE_FOLDER, EDF_FILE_NAME));
                
                %change to eye link defaults
                if isempty(EL_DEFAULTS)
                    load('EL_DEFAULTS_ORIGINAL.mat')
                end
                
                changeBackToEyeLinkDefaults(EL_DEFAULTS);
                
                Eyelink('Shutdown');
            end
            
            ShowCursor;
            Screen('CloseAll');
            Priority(oldPriority);
            rng('default');
            if DEBUG~=1
                RestrictKeysForKbCheck(oldenablekeys);
            end
            
            % Give focus back to Matlab
            commandwindow;
            
            function saveData()
                %save data record
                save(fullfile(EXPDATA_SAVE_FOLDER, EXPDATA_SAVE_FILE_NAME), 'EXPDATA');
                
                %save pileup;
                save(fullfile(WORKSPACE_SAVE_FOLDER, WORKSPACE_SAVE_FILE_NAME));
            end
        end
        
        %% Miscelenious Utility Functions
        function msg_str=runCalibrationQuery()
            msg_str=[];
            if (EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING)
                txt = 'Perform an eye-tracker calibration? Press enter for yes,n for no';
                Screen('FillRect', window, BACKGROUND_COLOR);
                prev_font_sz = Screen('TextSize', window, INEXP_FONT_SZ);
                DrawFormattedText(window,txt,'center','center',INEXP_TEXT_COLOR,[],[],[],2);
                Screen('Flip', window);
                Screen('TextSize', window, prev_font_sz);
                while (1)
                    [~,keyCodes] = KbWait;
                    if find(keyCodes, 1) == KBOARD_CODE_ENTER
                        run_calibrate = true;
                        break;
                    elseif find(keyCodes, 1) == KBOARD_CODE_N
                        run_calibrate = false;
                        break;
                    end
                end
                
                if (run_calibrate)
                    msg_str=calibrateEyeTracker();
                end
            end
        end
        
        function msg_str=calibrateEyeTracker()
            if (EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING)
                sendEyelinkMsg(num2str(TRIGGERS_EYE_TRACKER_CALIBRATION_STARTED));
                
                EyelinkDoTrackerSetup(EL_PARAMS);
                [~, msg_str]= Eyelink('CalMessage');
                disp(' ');
                disp('calibration statistics:');
                disp('----------------------');
                disp(msg_str);
                %                 if IS_CALIB_RIGHT
                %                     %EyelinkDoDriftCorrection(EL_PARAMS,round( 3/12*window_rect(3) ),round( 5/10*window_rect(4) )); %, [window_center_x + DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y]
                %                     %right
                %                     EyelinkDoDriftCorrection(EL_PARAMS,round( 9/12*window_rect(3) ),round( 5/10*window_rect(4) )); %, [window_center_x + DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y]
                %                 else
                %                     EyelinkDoDriftCorrection(EL_PARAMS,round( 3/12*window_rect(3) ),round( 5/10*window_rect(4) )); %, [window_center_x + DISPLAY_AREAS_DIST_FROM_CENTER, window_center_y]
                %                 end
                %                 [~, msg_str]= Eyelink('CalMessage');
                %                 disp(' ');
                %                 disp('drift correction statistics:');
                %                 disp('----------------------');
                %                 disp(msg_str);
                
                sendEyelinkMsg(num2str(TRIGGERS_EYE_TRACKER_CALIBRATION_ENDED));
                Screen('FillRect', window, BACKGROUND_COLOR);
                %start recording eye position preceded by a short pause so
                %that the tracker can finish the mode transition
                Eyelink('Command','set_idle_mode');
                WaitSecs(0.05);
                Eyelink('StartRecording');
                %Record a few samples before actually start displaying
                %otherwise you may lose a few msec of data
                WaitSecs(0.1);
            end
        end
        
        %         function echo(trigger, eyelink_msg, varargin)
        %             if LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB1 && EEG
        %                 sendTrigger(trigger);
        %             elseif (LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB1 || LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB2 || LAB_ROOM==ExperimentGuiBuilder.ENUM_LAB3) && EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
        %                 sendEyelinkMsg(eyelink_msg, varargin);
        %             end
        %         end
        
        function sendEyelinkMsg(msg, varargin)
            if EYE_TRACKING_METHOD==ENUM_EYE_TRACKING_NO_TRACKING
                return;
            end
            
            Eyelink('message', msg, varargin);
        end
        
        %         function sendTrigger(code, wait_secs)
        %             if LAB_ROOM~=ExperimentGuiBuilder.ENUM_LAB1 || ~EEG
        %                 return;
        %             end
        %
        %             OUT_FUNC(code);
        %             if nargin==1
        %                 WaitSecs(.005);
        %             else
        %                 WaitSecs(wait_secs);
        %             end
        %
        %             OUT_FUNC(PORT_SLEEP_CODE);
        %         end
        
        function v_angles= pixels2vAngles(pixels)
            v_angles= [];
            window_size= Screen('WindowSize', window);
            cm_per_pixels= SCREEN_WIDTH/window_size(1);
            for pixel_i= 1:numel(pixels)
                v_angles= [v_angles, rad2deg(2*atan(((pixels(pixel_i)/2)*cm_per_pixels)/SUBJECT_DISTANCE_FROM_SCREEN))];
            end
        end
        
        function pixels= vAngles2pixels(v_angles)
            pixels= [];
            window_size= Screen('WindowSize', window);
            pixels_per_cm= window_size(1)/SCREEN_WIDTH;
            for v_angle_i= 1:numel(v_angles)
                pixels= [pixels, 2*SUBJECT_DISTANCE_FROM_SCREEN*tan(deg2rad(v_angles(v_angle_i)/2))*pixels_per_cm];
            end
        end
        
        function genStimuliRects()
            DISPLAY_AREAS_RECTS = [genRect(window_center - [DISPLAY_AREAS_DIST_FROM_CENTER, 0], DISPLAY_AREA_SZ), genRect(window_center + [DISPLAY_AREAS_DIST_FROM_CENTER, 0], DISPLAY_AREA_SZ)];
            CHECKERBOARDS_RECTS = [genRect(window_center - [DISPLAY_AREAS_DIST_FROM_CENTER, 0], DISPLAY_AREA_SZ + 2*CHECKERBOARD_FRAME_WIDTH*ones(1,2)), genRect(window_center + [DISPLAY_AREAS_DIST_FROM_CENTER, 0], DISPLAY_AREA_SZ + 2*CHECKERBOARD_FRAME_WIDTH*ones(1,2))];
            if DEBUG==1
                gabors_rects_base = nan(4,6);
                gabors_rects_base(:,1) = genRect(0.5*[DISPLAY_AREA_SZ(1) - 2*(vAngles2pixels(1/6) + 0.5*GABOR_DIA), -DISPLAY_AREA_SZ(2) + 2*(vAngles2pixels(0.5) + 0.5*GABOR_DIA)], [GABOR_DIA, GABOR_DIA]);
                gabors_rects_base(:,2) = genRect(0.5*[DISPLAY_AREA_SZ(1) - 2*(vAngles2pixels(1/6) + 0.5*GABOR_DIA), 0], [GABOR_DIA, GABOR_DIA]);
                gabors_rects_base(:,3) = genRect(0.5*[DISPLAY_AREA_SZ(1) - 2*(vAngles2pixels(1/6) + 0.5*GABOR_DIA), DISPLAY_AREA_SZ(2) - 2*(vAngles2pixels(0.5) + 0.5*GABOR_DIA)], [GABOR_DIA, GABOR_DIA]);
                gabors_rects_base(:,4) = genRect(0.5*[-DISPLAY_AREA_SZ(1) + 2*(vAngles2pixels(1/6) + 0.5*GABOR_DIA), DISPLAY_AREA_SZ(2) - 2*(vAngles2pixels(0.5) + 0.5*GABOR_DIA)], [GABOR_DIA, GABOR_DIA]);
                gabors_rects_base(:,5) = genRect(0.5*[-DISPLAY_AREA_SZ(1) + 2*(vAngles2pixels(1/6) + 0.5*GABOR_DIA), 0], [GABOR_DIA, GABOR_DIA]);
                gabors_rects_base(:,6) = genRect(0.5*[-DISPLAY_AREA_SZ(1) + 2*(vAngles2pixels(1/6) + 0.5*GABOR_DIA), -DISPLAY_AREA_SZ(2) + 2*(vAngles2pixels(0.5) + 0.5*GABOR_DIA)], [GABOR_DIA, GABOR_DIA]);
                GABORS_RECTS(:,1:6) = gabors_rects_base + repmat((window_center + [DISPLAY_AREAS_DIST_FROM_CENTER, 0])', 2, 6);
                GABORS_RECTS(:,7:12) = gabors_rects_base + repmat((window_center - [DISPLAY_AREAS_DIST_FROM_CENTER, 0])', 2, 6);
            end
        end
        
        function screen_onset_vbl = drawBinocularScreen(last_refresh_vbl, texes, rects, rots_angs)
            Screen('DrawTextures', window, resources.checkerboard_tex, [],  CHECKERBOARDS_RECTS);
            Screen('DrawTextures', window, resources.sqr_tex, [], DISPLAY_AREAS_RECTS, [], [], [], [BACKGROUND_COLOR; BACKGROUND_COLOR]');
            Screen('DrawTextures', window, [texes{:}], [], [rects{:}], [rots_angs{:}]); %, [], [], [0,1,0]);
            screen_onset_vbl = Screen('Flip', window, last_refresh_vbl + (waitframes - 0.5) * ifi);
        end
        
        function checkerboard_tex = createCheckerboardTex()
            checkerboard_horizon_sqrs_nr = round(CHECKERBOARD_SQRS_NR_ON_HORIZON_SIDE*(CHECKERBOARD_FRAME_WIDTH + DISPLAY_AREA_SZ(1))/CHECKERBOARD_FRAME_WIDTH);
            checkerboard_vert_sqrs_nr = round(CHECKERBOARD_SQRS_NR_ON_VERT_SIDE*(CHECKERBOARD_FRAME_WIDTH + DISPLAY_AREA_SZ(2))/CHECKERBOARD_FRAME_WIDTH);
            checkerboard_tex = genCheckerboardTex(window, checkerboard_horizon_sqrs_nr, ceil((CHECKERBOARD_FRAME_WIDTH + DISPLAY_AREA_SZ(1))/checkerboard_horizon_sqrs_nr), checkerboard_vert_sqrs_nr, ceil((CHECKERBOARD_FRAME_WIDTH + DISPLAY_AREA_SZ(2))/checkerboard_vert_sqrs_nr), CHECKERBOARD_BRIGHT_COLOR(1));
        end
        
        function pos= calcCenterStrPosBySz(str)
            if isempty(str)
                pos= window_center;
            else
                [str_bounds,~]= Screen('TextBounds', window, str, window_center_x, window_center_y);
                %str_height= str_bounds(4);
                %str_len= Screen('TextSize',window)*96/72*numel(str);
                pos= round([window_center_x, window_center_y] - str_bounds([3,4])*0.5);
            end
        end
        
        %         function defineTextFormat(text_size, text_font)
        %             Screen('TextSize', window, text_size);
        %             Screen('TextFont', window, text_font);
        %         end
        
        %load lines from a txt file. the file has to be encoded as Unicode.
        %         function words= loadUnicodeWordsFromFile(file)
        %             fid = fopen(file);
        %             words= strsplit(native2unicode(fread(fid)', 'Unicode'), sprintf('\n'));
        %             words= cellfun(@strtrim, words, 'UniformOutput', false);
        %             fclose(fid);
        %         end
        
        %         function [charset_letters_texes, letters_texes_dims] = loadCharsetTexesFromPngsFolder(charset)
        %             [all_letters_texes, all_letters_texes_dims] = loadTexesFromPngsFolder(LETTERS_PNGS_FOLDER, window);
        %             charset_letters_texes = cell(1, numel(charset));
        %             letters_texes_dims = NaN(numel(charset), 2);
        %             for char_i = 1:numel(charset)
        %                 letter_tex_idx = find(ABC_VEC == lower(charset(char_i)));
        %                 charset_letters_texes{char_i} = all_letters_texes{letter_tex_idx};
        %                 letters_texes_dims(char_i, :) = all_letters_texes_dims(letter_tex_idx, :);
        %             end
        %         end
        
        %         function ppa_handle = buildPsychPortAudioHandle(audio_file)
        %             [snd_data, snd_freq] = audioread(audio_file);
        %             snd_data= snd_data';
        %             chans_nr = size(snd_data,1);
        %             if chans_nr < 2
        %                 snd_data = [snd_data ; snd_data];
        %                 chans_nr = 2;
        %             end
        %
        %             try
        %                 % Try with the 'freq'uency we wanted:
        %                 ppa_handle = PsychPortAudio('Open',[], [], [], [], [], 50);
        %                 %ppa_handle = PsychPortAudio('Open', [], [], 0, snd_freq, chans_nr);
        %             catch
        %                 % Failed. Retry with default frequency as suggested by device:
        %                 fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', snd_freq);
        %                 fprintf('Sound may sound a bit out of tune, ...\n\n');
        %
        %                 psychlasterror('reset');
        %                 ppa_handle = PsychPortAudio('Open', [], [], 0, [], chans_nr);
        %             end
        %
        %             PsychPortAudio('FillBuffer', ppa_handle, snd_data);
        %         end
        
        function instructions_laid_down_vbl= drawImageInstructions(tex)
            drawPlaceHolders()
            Screen('DrawTextures', window, tex, [], DISPLAY_AREAS_RECTS(:,1));
            Screen('DrawTextures', window, tex, [], DISPLAY_AREAS_RECTS(:,2));
            %Screen('DrawTextures', window, tex, [], [0; 0; window_center_x; window_rect(4)]);
            %Screen('DrawTextures', window, tex, [], [window_center_x; 0; window_rect(3); window_rect(4)]);
            instructions_laid_down_vbl= Screen('Flip', window);
        end
        
        function tex = pngFileToTex(file_path)
            [im(:,:,1:3),~,im(:,:,4)]= imread(file_path,'png');
            tex= Screen('MakeTexture', window, im);
        end
        
        %         function [textures_onset_vbl, pause_end_vbl, pause_duration_during_display, was_fixation_broken, vbl_of_last_retrace]= displayTimedTextures(show_fixation_cross, display_frames_nr, verify_fixation, vbl_of_last_retrace, textures, texture_rects, texture_angs, texture_opacities, texture_colors, trigger, eyelink_msg)
        %             pause_duration_during_display= 0;
        %             was_fixation_broken= false;
        %             is_curr_iteration_the_first= true;
        %             pause_end_vbl= -1;
        %             textures_onset_vbl= -1;
        %             ifi_end_vbl= -1;
        %             if display_frames_nr<=0
        %                 return;
        %             end
        %             elapsed_frames_nr= 0;
        %             ifi_start_vbl= vbl_of_last_retrace;
        %             %why (display_frames_nr-1): last frame is displayed during the first flip of
        %             %the next stimulus
        %             while (elapsed_frames_nr<display_frames_nr-1 && IS_EXP_GO)
        %                 if show_fixation_cross
        %                     drawFixationCross(FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
        %                 end
        %
        %                 if (nargin>=7)
        %                     for tex_i=1:numel(textures)
        %                         Screen('DrawTextures', window, textures{tex_i}, [], texture_rects{tex_i}, texture_angs{tex_i}, [], texture_opacities{tex_i}, texture_colors{tex_i});
        %                     end
        %                 end
        %
        %                 ifi_end_vbl= Screen('Flip', window, ifi_start_vbl + (waitframes - 0.5) * ifi);
        %                 if (is_curr_iteration_the_first)
        %                     textures_onset_vbl= ifi_end_vbl;
        %                     if (nargin>=4 && numel(trigger)==1)
        %                         echo(trigger, eyelink_msg);
        %                     end
        %                     is_curr_iteration_the_first= false;
        %                 else
        %                     elapsed_frames_nr= elapsed_frames_nr + 1;
        %                 end
        %
        %                 if (verify_fixation)
        %                     was_fixation_broken= testFixationBreaking(window_center, true);
        %                     if (was_fixation_broken)
        %                         echo(TRIGGERS_FIXATION_BROKEN, num2str(TRIGGERS_FIXATION_BROKEN));
        %                         break;
        %                     end
        %                 end
        %
        %                 [pause_duration, pause_end_vbl]= checkPauseReq();
        %                 if (pause_duration>0)
        %                     pause_duration_during_display= pause_duration_during_display + pause_duration;
        %                     ifi_start_vbl= pause_end_vbl;
        %                 else
        %                     ifi_start_vbl= ifi_end_vbl;
        %                 end
        %             end
        %
        %             vbl_of_last_retrace= ifi_end_vbl;
        %         end
        
        
        
        %     function [textures_onset_vbl, pause_end_vbl, pause_duration_during_display, was_fixation_broken, was_key_pressed, vbl_of_last_retrace]= displayTimedTexturesBetter(show_fixation_cross, display_dur, verify_fixation, verify_key_press, vbl_of_last_retrace, textures, texture_rects, texture_angs, texture_opacities, texture_colors, trigger, eyelink_msg)
        %         pause_duration_during_display= 0;
        %         was_fixation_broken= false;
        %         was_key_pressed= false;
        %         is_curr_iteration_the_first= true;
        %         pause_end_vbl= -1;
        %         textures_onset_vbl= -1;
        %         if display_dur<=0
        %             return;
        %         end
        %
        %         ifi_end_vbl= drawStimuli(vbl_of_last_retrace);
        %         display_frames_nr= floor(display_dur*fps);
        %         elapsed_frames_nr= 0;
        %         %why (display_frames_nr-1): last frame is displayed during the first flip of
        %         %the next stimulus
        %         while (elapsed_frames_nr<=display_frames_nr-1 && IS_EXP_GO)
        %             if (is_curr_iteration_the_first)
        %                 textures_onset_vbl= ifi_end_vbl;
        %                 if (nargin>=4 && numel(trigger)==1)
        %                     echo(trigger, eyelink_msg);
        %                 end
        %                 is_curr_iteration_the_first= false;
        %             end
        %
        %             [pause_duration, pause_end_vbl]= checkPauseReq();
        %             if (pause_duration>0)
        %                 pause_duration_during_display= pause_duration_during_display + pause_duration;
        %                 %stimuli were displayed during the flip for the pause screen
        %                 elapsed_frames_nr= elapsed_frames_nr + 1;
        %                 ifi_start_vbl= drawStimuli(pause_end_vbl);
        %             else
        %                 ifi_start_vbl= ifi_end_vbl;
        %             end
        %
        %             if (verify_key_press)
        %                 [was_key_pressed , ~, ~]= KbCheckRB();
        %                 if (was_key_pressed)
        %                     echo(TRIGGERS_SUBJECT_RESPONDED_TOO_EARLY, num2str(TRIGGERS_SUBJECT_RESPONDED_TOO_EARLY));
        %                     break;
        %                 end
        %             end
        %
        %             if (verify_fixation)
        %                 was_fixation_broken= testFixationBreaking();
        %                 if (was_fixation_broken)
        %                     echo(TRIGGERS_FIXATION_BROKEN, num2str(TRIGGERS_FIXATION_BROKEN));
        %                     break;
        %                 end
        %             end
        %
        %             ifi_end_vbl= Screen('Flip', window, ifi_start_vbl + (waitframes - 0.5) * ifi, 1);
        %             elapsed_frames_nr= elapsed_frames_nr + 1;
        %         end
        %
        %         vbl_of_last_retrace= ifi_end_vbl;
        %
        %         function flip_end_vbl= drawStimuli(ifi_start_vbl)
        %             if show_fixation_cross
        %                 drawFixationCross(FIXATION_CROSS_ARMS_LEN, FIXATION_CROSS_ARMS_WIDTH, FIXATION_CROSS_COLOR);
        %             end
        %
        %             if (nargin>=7)
        %                 for tex_i=1:numel(textures)
        %                     Screen('DrawTextures', window, textures{tex_i}, [], texture_rects{tex_i}, texture_angs{tex_i}, [], texture_opacities{tex_i}, texture_colors{tex_i});
        %                 end
        %             end
        %
        %             flip_end_vbl= Screen('Flip', window, ifi_start_vbl + (waitframes - 0.5) * ifi);
        %         end
        %     end
        
        %         function drawFixationDot(diameter, color)
        %             drawFixationDotAtPos(window_center, diameter, color);
        %         end
        
        %         function drawFixationDotAtPos(pos, diameter, color)
        %             rect= genRect(pos, [diameter, diameter]);
        %             Screen('FillOval', window, color, rect, 2*diameter);
        %         end
        
        %         function drawFixationCircleWithAnulous(circle_tex, inner_radius, inner_color, outer_radius, outer_color)
        %             inner_rect= genRect(window_center, 2*[inner_radius, inner_radius]);
        %             outer_rect= genRect(window_center, 2*[outer_radius, outer_radius]);
        %             rects= [outer_rect; inner_rect]';
        %             colors= [outer_color; inner_color]';
        %             Screen('DrawTextures', window, circle_tex, [], rects, [], [], [], colors);
        %         end
        
        %         function drawFixationCross(arms_len, arms_width, color)
        %             drawFixationCrossAtPos(window_center, arms_len, arms_width, color);
        %         end
        
        function drawFixationCrossAtPos(pos, arms_len, arms_width, color)
            cross_cords_x= [arms_len,-arms_len, 0, 0];
            cross_cords_y= [0, 0, arms_len, -arms_len];
            cross_cords= [cross_cords_x ; cross_cords_y];
            Screen('DrawLines', window, cross_cords, arms_width, color, pos, 2);
        end
        
        %         function drawPlaceHolder(loc, overall_side, lines_width, lines_gap_ratio, color)
        %             lines_coords= genPlaceHolderLinesMat(overall_side, lines_width, lines_gap_ratio);
        %             Screen('DrawLines', window, lines_coords', lines_width, color, loc-0.5*overall_side, 2);
        %         end
        
        %         function lines_coords = genPlaceHolderLinesMat(overall_side, lines_width, lines_gap_ratio)
        %             lines_lens= 0.5*overall_side*(1-lines_gap_ratio);
        %             lines_coords= [-0.5*lines_width, 0; lines_lens, 0;
        %                 overall_side-lines_lens, 0; overall_side+0.5*lines_width, 0;
        %                 overall_side, -0.5*lines_width; overall_side, lines_lens;
        %                 overall_side, overall_side-lines_lens; overall_side, overall_side+0.5*lines_width;
        %                 overall_side+0.5*lines_width, overall_side; overall_side-lines_lens, overall_side;
        %                 lines_lens, overall_side; -0.5*lines_width, overall_side;
        %                 0, overall_side+0.5*lines_width; 0, overall_side-lines_lens;
        %                 0, lines_lens; 0, -0.5*lines_width]';
        %         end
        
        %         function drawOrientedHet(loc, overall_side, lines_width, color, rot)
        %             lines_coords = genOrientedHetLinesMat(overall_side, lines_width, rot);
        %             Screen('DrawLines', window, lines_coords, lines_width, color, loc-0.5*overall_side, 2);
        %         end
        
        %         function lines_coords = genOrientedHetLinesMat(overall_side, lines_width, rot)
        %             corner_coord = 0.5*(overall_side + lines_width);
        %             lines_coords= [-corner_coord, -corner_coord;
        %                 -corner_coord, corner_coord;
        %                 corner_coord, corner_coord;
        %                 corner_coord, -corner_coord]';
        %             rot_mat = [cos(rot) -sin(rot); sin(rot) cos(rot)];
        %             lines_coords = rot_mat*lines_coords;
        %         end
        
        % gaze_coords -> 2 X 2 Matrix:
        % gaze_coords(1,:) -> left eye
        % gaze_coords(2,:) -> right eye
        % gaze_coords(:,1) -> x coordinates
        % gaze_coords(:,2) -> y coordinates
        % gaze_coords(?,:) == NaN if the corresponding eye is not available or if
        % there is missing data
        %         function [gaze_coords, sample_vbl]= sampleGazeCoords()
        %             gaze_coords= NaN(2,2);
        %             sample_vbl= [];
        %             if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
        %                 eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
        %                 if eye_used ~= -1 && Eyelink('NewFloatSampleAvailable') > 0
        %                     evt= Eyelink('NewestFloatSample');   % get the sample in the form of an event structure
        %                     sample_vbl= GetSecs();
        %                     if (eye_used == EL_PARAMS.BINOCULAR || eye_used == EL_PARAMS.LEFT_EYE) && evt.gx(EL_PARAMS.LEFT_EYE+1)~=EL_PARAMS.MISSING_DATA && evt.gy(EL_PARAMS.LEFT_EYE+1)~=EL_PARAMS.MISSING_DATA
        %                         gaze_coords(1,:)= ceil([evt.gx(EL_PARAMS.LEFT_EYE+1), evt.gy(EL_PARAMS.LEFT_EYE+1)]);
        %                     end
        %
        %                     if (eye_used == EL_PARAMS.BINOCULAR || eye_used == EL_PARAMS.RIGHT_EYE) && evt.gx(EL_PARAMS.RIGHT_EYE+1)~=EL_PARAMS.MISSING_DATA && evt.gy(EL_PARAMS.RIGHT_EYE+1)~=EL_PARAMS.MISSING_DATA
        %                         gaze_coords(2,:)= ceil([evt.gx(EL_PARAMS.RIGHT_EYE+1), evt.gy(EL_PARAMS.RIGHT_EYE+1)]);
        %                     end
        %                 end
        %             end
        %         end
        
        function [was_fixation_broken,is_eyemissing]= testFixationBreaking(fixation_loc, is_blinking_allowed)
            was_fixation_broken= true;
            if (EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING)
                [FIXATION_MONITOR, res,is_eyemissing]= FIXATION_MONITOR.testFixationBreaking(fixation_loc, is_blinking_allowed);
                if res~=FIXATION_MONITOR.FIXATION_MONITOR_RESULT_IS_OFF_TARGET
                    was_fixation_broken= false;
                end
            end
        end
        
        function answerSecs=checkPauseReq(lastVBL)
            sendEyelinkMsg(num2str(TRIGGER_PAUSE_REQ_START));
            prev_font_sz = Screen('TextSize', window, INEXP_FONT_SZ);
            %DrawFormattedText(window,'escape pressed... ',window_center_x-100, window_center_y, INEXP_TEXT_COLOR);
            DrawFormattedText(window, 'Escape pressed: w -> proceed, q -> quit experiment',window_center_x-400, window_center_y+40,INEXP_TEXT_COLOR);
            Screen('Flip', window, lastVBL + (waitframes - 0.5) * ifi);
            Screen('TextSize', window, prev_font_sz);
            while (1)
                [answerSecs, key_codes, ~]= KbWait([],2);
                key_code= find(key_codes, 1);
                sendEyelinkMsg(num2str(TRIGGER_PAUSE_REQ_ANSWERED));
                if key_code == KBOARD_CODE_W
                    break;
                elseif key_code == KBOARD_CODE_Q
                    IS_EXP_GO= false;
                    break;
                end
            end
        end
        
        % check if a key on the response box was pressed
        % output:
        %   * is_key_down: true if a key is down and false otherwise
        %   * key_pressed_vbl: the call time of kbCheckRB
        %   * key_codes: a 1x4 vector whose cells correspond to the buttons on the response key from left to right.
        %                1 in a specific cell means its corresponding button on the response box is down, whereis 0 means
        %                the button is up.
        %         function [is_key_down, key_pressed_vbl, key_codes]= KbCheckRB()
        %             [is_key_down, key_pressed_vbl, key_codes]= KbCheckResponseBox(IN_FUNC);
        %         end
        
        function rads = deg2rad(degs)
            rads = degs*pi/180;
        end
        
        function degs = rad2deg(rads)
            degs = rads*180/pi;
        end
        
        function Imagesdata=TexFromImages(Images,IMAGES_FOLDER,Image_Size)
            %This code assumes all images are in the same size
            cd(IMAGES_FOLDER);
            numImages=size(Images,1);
            Imagesdata.ImageName=cell(1,numImages);
            Imagesdata.ImageTexture=NaN(1,numImages);
            Imagesdata.imageHeights=NaN(1,numImages);
            Imagesdata.imageWidths=NaN(1,numImages);
            Imagesdata.dstRectsNonDom=NaN(4,numImages);
            Imagesdata.dstRectsDom=NaN(4,numImages);
            
            % Get the size of the images
            Imagesdata.ImageSize=Image_Size;
            % Get the aspect ratio of the image
            Imagesdata.ImageaspectRatio= Imagesdata.ImageSize(2)./Imagesdata.ImageSize(1); %w/h
            
            for ii=1:size(Images,1)
                clear Image theRect x y
                Image=imread(Images(ii).name);
                Imagesdata.ImageName{ii} = Images(ii).name;
                Imagesdata.ImageTexture(ii) = Screen('MakeTexture', window, Image);
                
                % Rescale the image according to the display area
                if Imagesdata.ImageSize(2)>=Imagesdata.ImageSize(1) %width bigger than height
                    Imagesdata.imageWidths(ii)=DISPLAY_AREA_SZ(1);
                    Imagesdata.imageHeights(ii)=Imagesdata.imageWidths(ii)*(1/Imagesdata.ImageaspectRatio);
                elseif Imagesdata.ImageSize(2)<Imagesdata.ImageSize(1) %width smaller than height
                    Imagesdata.imageHeights(ii)= DISPLAY_AREA_SZ(2);
                    Imagesdata.imageWidths(ii)=Imagesdata.imageHeights(ii).*Imagesdata.ImageaspectRatio;
                end
                theRect = [0 0 Imagesdata.imageWidths(ii) Imagesdata.imageHeights(ii)];
                [xNonDom,yNonDom]=RectCenter(DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER));
                Imagesdata.dstRectsNonDom(:,ii) = CenterRectOnPointd(theRect,xNonDom,yNonDom);
                [xDom,yDom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
                Imagesdata.dstRectsDom(:,ii) = CenterRectOnPointd(theRect,xDom,yDom);
            end
            Imagesdata.imageHeight=nanmean(Imagesdata.imageHeights);
            Imagesdata.imageWidth=nanmean(Imagesdata.imageWidths);
            Imagesdata.dstRectNonDom=nanmean(Imagesdata.dstRectsNonDom,2);
            Imagesdata.dstRectDom=nanmean(Imagesdata.dstRectsDom,2);
            cd(CURRENT_FOLDER)
        end
        
        function drawPlaceHolders()
            Screen('DrawTextures', window, resources.checkerboard_tex, [],CHECKERBOARDS_RECTS);
            Screen('DrawTextures', window, resources.sqr_tex, [],DISPLAY_AREAS_RECTS, [], [], [], [BACKGROUND_COLOR;BACKGROUND_COLOR]');
        end
        
        function Stereograms=TexFromImageStereogram(Images)
            for aa=1:length(Images)
                Image=imread(Images(aa).name);
                if strcmp(Images(aa).name,'rightStereogramSquare.bmp')
                    if DOMINANT_EYE_RIGHT==1
                        Stereograms.dstRect{aa}=DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER);
                    else
                        Stereograms.dstRect{aa}=DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER);
                    end
                elseif strcmp(Images(aa).name,'leftStereogramSquare.bmp')
                    if DOMINANT_EYE_RIGHT==1
                        Stereograms.dstRect{aa}=DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER);
                    else
                        Stereograms.dstRect{aa}=DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER);
                    end
                end
                Stereograms.stereogramsTexture{aa}= Screen('MakeTexture', window,Image);
            end
        end
        
        function PresentStereograms()
            drawPlaceHolders()
            Screen('DrawTextures', window, [resources.Stereograms.stereogramsTexture{1},resources.Stereograms.stereogramsTexture{2}], [],[resources.Stereograms.dstRect{1},resources.Stereograms.dstRect{2}]);
            Screen('Flip', window);
            
            %Wait for subject to press
            respMade=false;
            while ~respMade
                [~, Secs, keyCode,deltaSecs] = KbCheck;
                if keyCode(KBOARD_CODE_SPACE)
                    respMade=true;
                elseif keyCode(KBOARD_CODE_ESC)
                    answerSecs=checkPauseReq(Secs);
                    if ~IS_EXP_GO
                        sendEyelinkMsg(num2str(TRIGGER_EXPERIMENT_STOPPED));
                        respMade=true;
                    else
                        drawPlaceHolders()
                        Screen('DrawTextures', window, [resources.Stereograms.stereogramsTexture{1},resources.Stereograms.stereogramsTexture{2}], [],[resources.Stereograms.dstRect{1},resources.Stereograms.dstRect{2}]);
                        Screen('Flip', window,answerSecs);
                    end
                end
            end
        end
    end
end

%         function startRecording()
%             if EEG
%                 sendTrigger(BIOSEMI_CODE_START);
%             end
%
%             if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
%                 runCalibrationQuery();
%             end
%
%             if EEG || EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
%                 sendTrigger(66,0.5);
%                 sendTrigger(66,0.5);
%                 sendTrigger(66,0.5);
%                 WaitSecs(3);
%             end
%         end