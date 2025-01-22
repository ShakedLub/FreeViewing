%TODO: fix bug in ExperimentGuiBuilder::readMultipleNums - if changing
%number of requested numbers, then crash.

function Run_FV_CFS(number)
%% Overview/////////
% This function is a framework for building experiments for psychtoolbox.
% Three main sections:
%
% # Experiment Definitions
% # GUI   
% # Experiment function - called via the gui's [run experiment] button.
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
EXPERIMENT_NUMBER=400;

%folder constants
CURRENT_FOLDER = cd;
GUI_XML_FILE= fullfile('guiXML.xml');
MSGS_FOLDER= fullfile('resources','instructions');
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
EXP_CONDITION=[];
DOMINANT_HAND=[];
SUBJECT_NUMBER_AND_EXPERIMENT=[];

MAX_NUM_BLOCKS_THF=[];
NUM_START_IMAGES_THF=[];
NUM_IMAGES_BLOCK_THF=[];

GOAL_NUM_TRIALS_PAS12=[];

BLOCKS_NR_MULTIPLIER= [];
TRIALS_NR_MULTIPLIER= [];
DUMMY_TO_REGULAR_TRIALS_WEIGHTS = [];

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

%design variables
DESIGN_PARAM=[];
RAND_TRIALS_ORDER_PRACTICE=[];
RAND_TRIALS_ORDER=[];
RAND_TRIALS_ORDER_THF=[];
RAND_TRIALS_ORDER_EXTRA=[];

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
IMAGE_STEADY_DURATION=3000; %msec
IMAGE_FADEIN_DURATION=1000; %msec
IMAGE_DURATION=IMAGE_FADEIN_DURATION+IMAGE_STEADY_DURATION;%msec
PAS_QUESTION_MAX_DURATION=4000; %msec
RECOGNITION_QUESTION_MAX_DURATION=4000; %msec
WANTED_FPS=100;
WANTED_IFI=round(1/WANTED_FPS,4);

%Threshold fitting
ALPHA_DELTA_THF=0.05;
ALPHA_IMAGE=0.2;

%Mondrian Parameters
NUM_MONDRIAN_MASKS_BANK=100;
ALPHA_MONDRIAN=1;

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
KBOARD_CODE_1= KbName('1!'); KBOARD_CODE_2= KbName('2@'); KBOARD_CODE_3= KbName('3#'); KBOARD_CODE_4= KbName('4$');

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

ENABLED_KEYS=[KBOARD_CODE_SPACE,KBOARD_CODE_ENTER,KBOARD_CODE_N,KBOARD_CODE_ESC,KBOARD_CODE_LEFT,KBOARD_CODE_RIGHT,KBOARD_CODE_Q,KBOARD_CODE_W,KBOARD_CODE_1,KBOARD_CODE_2,KBOARD_CODE_3,KBOARD_CODE_4,KBOARD_CODE_UP,KBOARD_CODE_DOWN];

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
TRIGGER_IMAGE_START_IMAGETRIALS=401;
TRIGGER_IMAGE_START_CONTROLTRIALS=402;
TRIGGER_IMAGE_START_STEADY=400;
TRIGGER_IMAGE_END=206;
TRIGGER_PRACTICE_START=207;
TRIGGER_PRACTICE_END=208;
TRIGGER_BLOCK_START=209;
TRIGGER_BLOCK_END=210;

TRIGGER_PAS_Q_START=211;
TRIGGER_SUBJ_ANSWER_PAS_Q=212;
TRIGGER_PAS_Q_END=213;
TRIGGER_IMAGE_START_RECOGNITION_Q=214;
TRIGGER_SUBJ_ANSWER_RECOGNITION_Q=215;
TRIGGER_IMAGE_END_RECOGNITION_Q=216;

TRIGGER_EXPERIMENT_STOPPED=217;
TRIGGER_PAUSE_REQ_START=218;
TRIGGER_PAUSE_REQ_ANSWERED=219;

TRIGGER_EXTRA_BLOCK_START=220;
TRIGGER_EXTRA_BLOCK_END=221;

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

%subjects randomization
AllSubj=load('ExpDesignAllSubjects');

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
            SUBJECT_NUMBER=size(AllSubj.ExpDesignAllSubjects.RandTrialsOrder,2);
            EXP_CONDITION=1;
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
            EXP_CONDITION=subInfo.expCond;
            SUBJECT_AGE=subInfo.age;
            SUBJECT_GENDER= subInfo.gender;
            DOMINANT_HAND= subInfo.hand;
            DOMINANT_EYE= upper(subInfo.eye);
        end
        SUBJECT_NUMBER_AND_EXPERIMENT=SUBJECT_NUMBER+EXPERIMENT_NUMBER;
        
        % load subject randomization
        DESIGN_PARAM= AllSubj.ExpDesignAllSubjects.Param;
        RAND_TRIALS_ORDER_PRACTICE=AllSubj.ExpDesignAllSubjects.RandTrialsOrder_Practice(SUBJECT_NUMBER).Condition(EXP_CONDITION);
        RAND_TRIALS_ORDER=AllSubj.ExpDesignAllSubjects.RandTrialsOrder(SUBJECT_NUMBER).Condition(EXP_CONDITION);
        RAND_TRIALS_ORDER_THF=AllSubj.ExpDesignAllSubjects.RandTrialsOrder_ThrFitting(SUBJECT_NUMBER);
        RAND_TRIALS_ORDER_EXTRA=AllSubj.ExpDesignAllSubjects.RandTrialsOrder_Extra(SUBJECT_NUMBER);
        
        MAX_NUM_BLOCKS_THF=DESIGN_PARAM.MaxNumBlocksTHF;
        NUM_START_IMAGES_THF=DESIGN_PARAM.NumStartImagesTHF;
        NUM_IMAGES_BLOCK_THF=DESIGN_PARAM.NumImagesInBlockTHF;
        
        GOAL_NUM_TRIALS_PAS12=DESIGN_PARAM.GoalNumTrialsPAS12;
        
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
        
        %If in C condition take alpha image of U condition
        if EXP_CONDITION==2 %C condition
            %check there is only one expdata_U file for the subject
            cd(EXPDATA_SAVE_FOLDER)
            listing = dir(['*',EXPDATA_SAVE_FILE_NAME_PREFIX,'_',DESIGN_PARAM.ConditionLabels{1},'_',num2str(SUBJECT_NUMBER_AND_EXPERIMENT),'*.mat']);
            cd(CURRENT_FOLDER)
            if size(listing,1)>1
                disp('More than one U expdata for this subject. Fix the files')
                IS_EXP_GO=0;
                return
            end

            %check expdata_U file for the subject exist
            result = isfile([EXPDATA_SAVE_FOLDER,'\',EXPDATA_SAVE_FILE_NAME_PREFIX,'_',DESIGN_PARAM.ConditionLabels{1},'_',num2str(SUBJECT_NUMBER_AND_EXPERIMENT),'.mat']);
            if result==0
                disp('U expdata for this subject does not exist')
                IS_EXP_GO=0;
                return
            end
            
            %load file
            load([EXPDATA_SAVE_FOLDER,'\',EXPDATA_SAVE_FILE_NAME_PREFIX,'_',DESIGN_PARAM.ConditionLabels{1},'_',num2str(SUBJECT_NUMBER_AND_EXPERIMENT),'.mat']);
            ALPHA_IMAGE=EXPDATA.info.experiment_parameters.alpha_image;
            EXPDATA= [];
            clear listing result
            
            %check alpha image is not empty
            if isempty(ALPHA_IMAGE)
                disp('ALPHA_IMAGE is empty')
                IS_EXP_GO=0;
                return
            end
        end
        
        %check triggers will be done if eye tracking is on
        if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
            CHECK_TRIGGERS=1;
        else
            CHECK_TRIGGERS=0;
        end
        
        %Update saving file names
        EXPDATA_SAVE_FILE_NAME_PREFIX=[EXPDATA_SAVE_FILE_NAME_PREFIX,'_',DESIGN_PARAM.ConditionLabels{EXP_CONDITION},'_'];
        WORKSPACE_SAVE_FILE_NAME_PREFIX=[WORKSPACE_SAVE_FILE_NAME_PREFIX,'_',DESIGN_PARAM.ConditionLabels{EXP_CONDITION},'_'];
        EDF_FILE_NAME_PREFIX=[EDF_FILE_NAME_PREFIX,'_',DESIGN_PARAM.ConditionLabels{EXP_CONDITION},'_'];
        EDF_TEMP_FILE_NAME_PREFIX=[EDF_TEMP_FILE_NAME_PREFIX,DESIGN_PARAM.ConditionLabels{EXP_CONDITION}];
        
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
        
        [is_file_unique, user_response]= verifyFileUniqueness(fullfile(EDF_SAVE_FOLDER, [EDF_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EDF_FILE_NAME_SUFFIX, '.edf']));
        if ~is_file_unique && ~strcmp(user_response,'Overwrite')
            if strcmp(user_response,'Duplicate')
                EDF_FILE_NAME_SUFFIX= [EDF_FILE_NAME_SUFFIX, annotateFileDuplication(fullfile(EDF_SAVE_FOLDER, [EDF_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), EDF_FILE_NAME_SUFFIX]), '.edf')];
            else %user_response=='Cancel'
                return;
            end
        end
        
        [is_file_unique, user_response]= verifyFileUniqueness(fullfile(WORKSPACE_SAVE_FOLDER, [WORKSPACE_SAVE_FILE_NAME_PREFIX, num2str(SUBJECT_NUMBER_AND_EXPERIMENT), WORKSPACE_SAVE_FILE_NAME_SUFFIX, '.mat']));
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
            
            if (round(ifi,4) - WANTED_IFI) ~= 0
                disp('The experimental computer screen has the wrong frame rate')
                IS_EXP_GO=0;
            end
            
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
            dom_place_holder_center=[x_Dom,y_Dom];
            
            FRAMES_PER_MONDRIAN = ceil(fps / MONDRIAN_CHANGE_FREQ);
            if DEBUG==1
                FRAMES_PER_BINOCULAR_SWITCH = ceil(fps / BINOCULAR_SWITCH_FREQUENCY);
                WHICH_MERIDIAN_STR_POS = calcCenterStrPosBySz(WHICH_MERIDIAN_STR);
                HOW_SURE_STR_POS = calcCenterStrPosBySz(HOW_SURE_STR);
                HOW_SURE_OPTIONS_STR_POS = calcCenterStrPosBySz(HOW_SURE_OPTIONS_STR);
                GABOR_TILT_STR_POS = calcCenterStrPosBySz(GABOR_TILT_STR);
            end
            
            NUM_FRAMES_DURING_IMAGE_FADEIN=round(IMAGE_FADEIN_DURATION/(1000*ifi));
            NUM_FRAMES_STEADY_IMAGE=round(IMAGE_STEADY_DURATION/(1000*ifi));
            NUM_FRAMES_DURING_TOTAL_IMAGE=NUM_FRAMES_DURING_IMAGE_FADEIN+NUM_FRAMES_STEADY_IMAGE;
            
            NUM_MONDARIANS_DURING_TOTAL_IMAGE=ceil(NUM_FRAMES_DURING_TOTAL_IMAGE/FRAMES_PER_MONDRIAN);
            
            NUM_FRAMES_PAS_QUESTION_TIME_LIMIT=ceil(PAS_QUESTION_MAX_DURATION/(1000*ifi));
            NUM_FRAMES_RECOGNITION_QUESTION_TIME_LIMIT=ceil(RECOGNITION_QUESTION_MAX_DURATION/(1000*ifi));
            
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
                if DEBUG==1
                    runConfigScreen();
                else
                    %4. randomize experiment's conditions - EDIT
                    randomizeDataForTrials();
                    if IS_EXP_GO
                        %5. define experiment record variables - EDIT
                        initializeDataRecord();
                        
                        %Run threshold fitting
                        if EXP_CONDITION==1 %U condition
                            trial_i_overall=0;
                            field=['Blocks','_',DESIGN_PARAM.expSteps{3}];
                            for block_thF=1:MAX_NUM_BLOCKS_THF
                                trial_i_overall=runExpBlocks(DESIGN_PARAM.expSteps{3},trial_i_overall);
                                if ~IS_EXP_GO
                                    break
                                end
                                %Save data from the last block
                                EXPDATA.(field)(block_thF).alpha_image=ALPHA_IMAGE;
                                if block_thF==1
                                    EXPDATA.(field)(block_thF).num_trials=trial_i_overall;
                                    EXPDATA.(field)(block_thF).last_trial_overall_in_block=trial_i_overall;
                                else
                                    EXPDATA.(field)(block_thF).num_trials=trial_i_overall-EXPDATA.(field)(block_thF-1).last_trial_overall_in_block;
                                    EXPDATA.(field)(block_thF).last_trial_overall_in_block=trial_i_overall;
                                end
                                
                                %update image alpha or leave threshold fitting step
                                [ALPHA_IMAGE,resources,Thr_Flag]=updateImageAlpha(ALPHA_IMAGE,resources);
                                if Thr_Flag==0 %end thr fitting procedure
                                    EXPDATA.info.experiment_parameters.alpha_image=ALPHA_IMAGE;
                                    break
                                end
                            end
                        else
                            EXPDATA.info.experiment_parameters.alpha_image=ALPHA_IMAGE;
                        end
                        
                        if IS_EXP_GO
                            %Run practice
                            trial_i_overall=0;
                            runExpBlocks(DESIGN_PARAM.expSteps{1},trial_i_overall);
                            
                            if IS_EXP_GO
                                %Run experiment
                                trial_i_overall=0;
                                runExpBlocks(DESIGN_PARAM.expSteps{2},trial_i_overall);
                                
                                if IS_EXP_GO
                                    %Run Extra trials for objective awaraness test
                                    if EXP_CONDITION==1 %U condition
                                        trial_i_overall=0;
                                        runExpBlocks(DESIGN_PARAM.expSteps{4},trial_i_overall);
                                    end
                                end
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
            
            
            if DEBUG==1 || DEBUG_CODE==1
                ShowCursor;
            else
                HideCursor;
            end
            
            [window, window_rect] = PsychImaging('OpenWindow', screen_i, BACKGROUND_COLOR);
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('Preference', 'VisualDebugLevel', 4); %sets graphic debugging to the highest level
            
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
            
            progressBar = ProgressBarPTB(window, window_rect, 30, 400, 2, [1, 1, 1], [0, 1, 0]);
            
            if DEBUG==1
                contrasts_nr = numel(GABOR_CONTRASTS);
                resources.gabor_texes = NaN(1, contrasts_nr);
                for contrast_idx = 1:contrasts_nr
                    resources.gabor_texes(contrast_idx) = createGaborTex(window, BACKGROUND_COLOR(1), GABOR_DIA, vAngles2pixels(1/GABOR_CYCLES_PER_DEGREE), 0, GABOR_SD_IN_PIXELS, 0, GABOR_TRIM_THRESHOLD, GABOR_CONTRASTS(contrast_idx));
                end
            end
            
            %create images for experiment
            resources.Images=TexFromImages(DESIGN_PARAM.EXPERIMENT_IMAGES_FOLDER,RAND_TRIALS_ORDER); %This code assumes all images are in the same size
            
            %create images for practice
            resources.ImagesPractice=TexFromImages(DESIGN_PARAM.PRACTICE_IMAGES_FOLDER,RAND_TRIALS_ORDER_PRACTICE); %This code assumes all images are in the same size
            
            %create control images for experiment
            resources.ControlImages=TexFromControlImages(DESIGN_PARAM.EXPERIMENT_IMAGES_FOLDER,RAND_TRIALS_ORDER); %This code assumes all images are in the same size
            
            %create control images for practice
            resources.ControlImagesPractice=TexFromControlImages(DESIGN_PARAM.PRACTICE_IMAGES_FOLDER,RAND_TRIALS_ORDER_PRACTICE); %This code assumes all images are in the same size
            
            %create images for recognition question
            resources.QImages=TexFromQImages(DESIGN_PARAM.EXPERIMENT_IMAGES_FORQ_FOLDER,RAND_TRIALS_ORDER); %This code assumes all images are in the same size
            
            %create images for recognition question practice
            resources.QImagesPractice=TexFromQImages(DESIGN_PARAM.PRACTICE_IMAGES_FORQ_FOLDER,RAND_TRIALS_ORDER_PRACTICE); %This code assumes all images are in the same size
            
            %create images for threshold fitting
            resources.ImagesThrFitting=TexFromImagesThrFitting(DESIGN_PARAM.IMAGES_FOR_THRESHOLD_FITTING,RAND_TRIALS_ORDER_THF); %This code assumes images have the same aspect ratio as the rest of the images
            
            %create images for extra trials
            resources.ImagesExtra=TexFromImagesThrFitting(DESIGN_PARAM.IMAGES_FOR_THRESHOLD_FITTING,RAND_TRIALS_ORDER_EXTRA); %This code assumes images have the same aspect ratio as the rest of the images
            
            %create images for recognition question extra
            resources.QImagesExtra=TexFromQImagesExtra(DESIGN_PARAM.EXTRA_IMAGES_FORQ_FOLDER,RAND_TRIALS_ORDER_EXTRA); %This code assumes images have the same aspect ratio as the rest of the images
            
            %calculate image alphas in fade in
            alphas=linspace(0,ALPHA_IMAGE,NUM_FRAMES_DURING_IMAGE_FADEIN);
            resources.image_alphas=[alphas,ALPHA_IMAGE.*ones(1,NUM_FRAMES_STEADY_IMAGE)];
            
            %Create mondrian images and textures
            [resources.Mondrians,progressBar]=createMondrianImageAndTex(resources,progressBar);
            
            %create checkboard texture
            resources.checkerboard_tex = createCheckerboardTex();
            
            %create stereogram
            createStereograms(DISPLAY_AREA_SZ,STEREOGRAM_SAVE_FOLDER)
            resources.Stereograms=TexFromImageStereogram();
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
            EXPDATA.info.general_info.extra_experiment_duration= [];
            
            EXPDATA.info.general_info.experiment_start= [];
            EXPDATA.info.general_info.experiment_end= [];
            EXPDATA.info.general_info.practice_start= [];
            EXPDATA.info.general_info.practice_end= [];
            EXPDATA.info.general_info.extra_experiment_start= [];
            EXPDATA.info.general_info.extra_experiment_end= [];
            
            EXPDATA.info.general_info.calibration_data_Experiment=[];
            EXPDATA.info.general_info.calibration_data_Practice=[];
            EXPDATA.info.general_info.calibration_data_Extra=[];
            
            EXPDATA.info.subject_info.subject_number_for_randomization = SUBJECT_NUMBER;
            EXPDATA.info.subject_info.subject_number_and_experiment = SUBJECT_NUMBER_AND_EXPERIMENT;
            EXPDATA.info.subject_info.experiment_number = EXPERIMENT_NUMBER;
            EXPDATA.info.subject_info.experiment_condition = EXP_CONDITION;
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
            EXPDATA.info.lab_setup.number_frames_during_image_fadein=NUM_FRAMES_DURING_IMAGE_FADEIN;
            EXPDATA.info.lab_setup.FPS= fps;
            EXPDATA.info.lab_setup.IFI= ifi;
            
            EXPDATA.info.experiment_parameters.initial_alpha_image_thr_fitting=ALPHA_IMAGE;
            EXPDATA.info.experiment_parameters.alpha_image=[];
            EXPDATA.info.experiment_parameters.alpha_mondrian=ALPHA_MONDRIAN;
            EXPDATA.info.experiment_parameters.max_number_blocks_thr_fitting=MAX_NUM_BLOCKS_THF;
            EXPDATA.info.experiment_parameters.number_start_images_thr_fitting=NUM_START_IMAGES_THF;
            EXPDATA.info.experiment_parameters.number_images_block_thr_fitting=NUM_IMAGES_BLOCK_THF;
            EXPDATA.info.experiment_parameters.goal_number_trials_PAS12=GOAL_NUM_TRIALS_PAS12;
            
            EXPDATA.info.experiment_parameters.image_duration=IMAGE_DURATION;
            EXPDATA.info.experiment_parameters.image_steady_duration=IMAGE_STEADY_DURATION;
            EXPDATA.info.experiment_parameters.image_fadein_duration=IMAGE_FADEIN_DURATION;
            EXPDATA.info.experiment_parameters.fixation_duration=FIXATION_DURATION;
            EXPDATA.info.experiment_parameters.PAS_question_max_duration=PAS_QUESTION_MAX_DURATION;
            EXPDATA.info.experiment_parameters.recognition_question_max_duration=RECOGNITION_QUESTION_MAX_DURATION;
            
            EXPDATA.info.experiment_parameters.fixation_cross_arms_length= FIXATION_CROSS_ARMS_LEN_IN_VANGLES;
            EXPDATA.info.experiment_parameters.fixation_cross_arms_width= FIXATION_CROSS_ARMS_WIDTH_IN_VANGLES;
            EXPDATA.info.experiment_parameters.fixation_cross_color= FIXATION_CROSS_COLOR;
            EXPDATA.info.experiment_parameters.display_area_size= DISPLAY_AREA_SZ_IN_VANGLES;
            
            EXPDATA.info.experiment_parameters.mondrian_shapes_sizes = MONDRIAN_SHAPES_SZS;
            EXPDATA.info.experiment_parameters.mondrian_change_frequency = MONDRIAN_CHANGE_FREQ;
            
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
                
                EXPDATA.check_Triggers.practice_start.TrackerTime=[];
                EXPDATA.check_Triggers.practice_start.TriggerNumber=[];
                EXPDATA.check_Triggers.practice_end.TrackerTime=[];
                EXPDATA.check_Triggers.practice_end.TriggerNumber=[];
                
                EXPDATA.check_Triggers.extra_block_start.TrackerTime=[];
                EXPDATA.check_Triggers.extra_block_start.TriggerNumber=[];
                EXPDATA.check_Triggers.extra_block_end.TrackerTime=[];
                EXPDATA.check_Triggers.extra_block_end.TriggerNumber=[];
            end
            
            for step_i=1:length(DESIGN_PARAM.expSteps)
                clear Trials
                switch DESIGN_PARAM.expSteps{step_i}
                    case 'Experiment'
                        NumTrials= RAND_TRIALS_ORDER.NumTrialsInCondition;
                    case 'Practice'
                        NumTrials=RAND_TRIALS_ORDER_PRACTICE.NumTrialsInCondition;
                    case 'ThresholdFitting'
                        NumTrials=size(RAND_TRIALS_ORDER_THF.Trials,2);
                    case 'Extra'
                        NumTrials=size(RAND_TRIALS_ORDER_EXTRA.Trials,2);
                end
                for trial_i= 1:NumTrials
                    %general data
                    Trials(trial_i).BlockNum=[];
                    Trials(trial_i).TrialNum=[];
                    Trials(trial_i).NumRepetitionFixationFail=[];
                    Trials(trial_i).TrialDuration=[];
                    %image data
                    Trials(trial_i).ImageID=[];
                    Trials(trial_i).ImageIDControl=[];
                    Trials(trial_i).ImageName=[];
                    
                    Trials(trial_i).Tex=[];
                    Trials(trial_i).Alpha=[];
                    Trials(trial_i).Rect=[];
                    Trials(trial_i).TexEnd=[];
                    Trials(trial_i).AlphaEnd=[];
                    Trials(trial_i).RectEndDom=[];
                    Trials(trial_i).RectEndNonDom=[];
                    
                    Trials(trial_i).whichMond=[];
                    Trials(trial_i).IsImageTrial=[];
                    Trials(trial_i).IsControlTrial=[];
                    
                    if ~strcmp(DESIGN_PARAM.expSteps{step_i},'ThresholdFitting')
                        %recognition question data
                        Trials(trial_i).ImageIDQLeft=[];
                        Trials(trial_i).ImageNameQLeft=[];
                        Trials(trial_i).ImageTypeQLeft=[];
                        Trials(trial_i).ImageIDQRight=[];
                        Trials(trial_i).ImageNameQRight=[];
                        Trials(trial_i).ImageTypeQRight=[];
                        
                        Trials(trial_i).TexL=[];
                        Trials(trial_i).AlphaL=[];
                        Trials(trial_i).RectNonDomL=[];
                        Trials(trial_i).RectDomL=[];
                        Trials(trial_i).TexR=[];
                        Trials(trial_i).AlphaR=[];
                        Trials(trial_i).RectNonDomR=[];
                        Trials(trial_i).RectDomR=[];
                    end
                    
                    %timing in experiment
                    Trials(trial_i).Init_Trial_screen_vbl=[];
                    Trials(trial_i).PressInitSecs=[];
                    Trials(trial_i).PressInitdeltaSecs=[];
                    Trials(trial_i).fixation_vbls=[];
                    Trials(trial_i).image_vbls=[];
                    Trials(trial_i).Image_End=[];
                    if ~strcmp(DESIGN_PARAM.expSteps{step_i},'ThresholdFitting')
                        Trials(trial_i).recognitionQ_image_vbls=[];
                        Trials(trial_i).PressAnswerRecognitionQSecs=[];
                        Trials(trial_i).PressAnswerRecognitionQdeltaSecs=[];
                        Trials(trial_i).PASQ_image_vbls=[];
                        Trials(trial_i).PressAnswerPASQSecs=[];
                        Trials(trial_i).PressAnswerPASQdeltaSecs=[];
                        Trials(trial_i).PASQ_end=[];
                    else
                        Trials(trial_i).Place_holders_vbl=[];
                    end
                    Trials(trial_i).trial_end_vbl=[];
                    
                    Trials(trial_i).ImagePresentationTime=[];
                    Trials(trial_i).ImageWantedPresentationTime=[];
                    if ~strcmp(DESIGN_PARAM.expSteps{step_i},'ThresholdFitting')
                        Trials(trial_i).RecognitionQImagePresentationTime=[];
                        Trials(trial_i).RecognitionQImageWantedPresentationTime=[];
                        Trials(trial_i).PASQPresentationTime=[];
                        Trials(trial_i).PASQWantedPresentationTime=[];
                        
                        %recognition question answer
                        Trials(trial_i).did_answer_recognition_Q=[];
                        Trials(trial_i).response_recognition_Q=[];
                        Trials(trial_i).isCorrect_recognition_Q=[];
                        
                        %PAS question answer
                        Trials(trial_i).did_answer_PAS_Q=[];
                        Trials(trial_i).response_PAS_Q=[];
                    end
                    
                    %Triggers
                    if CHECK_TRIGGERS && ~strcmp(DESIGN_PARAM.expSteps{step_i},'ThresholdFitting')
                        Trials(trial_i).check_Triggers.fixation_start.TrackerTime=[];
                        Trials(trial_i).check_Triggers.fixation_start.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.fixation_end.TrackerTime=[];
                        Trials(trial_i).check_Triggers.fixation_end.TriggerNumber=[];
                        
                        Trials(trial_i).check_Triggers.image_start.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_start.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.image_start_steady.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_start_steady.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.image_end.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_end.TriggerNumber=[];
                        
                        Trials(trial_i).check_Triggers.image_start_recognition_Q.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_start_recognition_Q.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.subj_answer_recognition_Q.TrackerTime=[];
                        Trials(trial_i).check_Triggers.subj_answer_recognition_Q.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.image_end_recognition_Q.TrackerTime=[];
                        Trials(trial_i).check_Triggers.image_end_recognition_Q.TriggerNumber=[];
                        
                        Trials(trial_i).check_Triggers.start_PAS_Q.TrackerTime=[];
                        Trials(trial_i).check_Triggers.start_PAS_Q.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.subj_answer_PAS_Q.TrackerTime=[];
                        Trials(trial_i).check_Triggers.subj_answer_PAS_Q.TriggerNumber=[];
                        Trials(trial_i).check_Triggers.end_PAS_Q.TrackerTime=[];
                        Trials(trial_i).check_Triggers.end_PAS_Q.TriggerNumber=[];
                    end
                end
                EXPDATA.(['Trials','_',DESIGN_PARAM.expSteps{step_i}])=Trials;
                
                if strcmp(DESIGN_PARAM.expSteps{step_i},'ThresholdFitting')
                    for block= 1:MAX_NUM_BLOCKS_THF
                        Blocks(block).alpha_image=[];
                        Blocks(block).num_trials=[];
                        Blocks(block).last_trial_overall_in_block=[];
                    end
                    EXPDATA.(['Blocks','_',DESIGN_PARAM.expSteps{step_i}])=Blocks;
                end
            end
        end
        
        % stage 5
        % reminder -> loop through the trials if the randomizing functions dont
        % fit (dont use matlab vector indexing crap)
        function randomizeDataForTrials()
            rng('default');
            rng('shuffle');
            
            %randomize mondrains
            RAND_TRIALS_ORDER=RandomizeMondrains(RAND_TRIALS_ORDER);
            RAND_TRIALS_ORDER_PRACTICE=RandomizeMondrains(RAND_TRIALS_ORDER_PRACTICE);
            RAND_TRIALS_ORDER_THF=RandomizeMondrains(RAND_TRIALS_ORDER_THF);
            RAND_TRIALS_ORDER_EXTRA=RandomizeMondrains(RAND_TRIALS_ORDER_EXTRA);
        end
        
        % stage 6
        function trial_i_overall=runExpBlocks(ExpStep,trial_i_overall)
            %Initialize variables
            exp_start_vbl=GetSecs();
            CALIBRATION_DATA.calibration_msg_str=[];
            CALIBRATION_DATA.calibration_done_before_trial=[];
            CALIBRATION_DATA.calibration_beginning_block=[];
            
            switch ExpStep
                case 'ThresholdFitting'
                    %Initialize variables
                    RandTrialsOrder=RAND_TRIALS_ORDER_THF;
                    Images=resources.ImagesThrFitting;
                    NumBlocks=1;
                    if trial_i_overall==0
                        %Check fusion
                        PresentStereograms();
                        if ~IS_EXP_GO
                            return
                        end
                        
                        %Present instructions 1
                        drawImageInstructions(Instructions.msgsTex(18));
                        WaitSecs(0.3);
                        
                        %Wait for subject to press space
                        respMade=false;
                        while ~respMade
                            [~, Secs, keyCode,deltaSecs] = KbCheck;
                            if keyCode(KBOARD_CODE_SPACE)
                                respMade=true;
                            end
                        end
                        
                        %Present instructions 2
                        drawImageInstructions(Instructions.msgsTex(15));
                        WaitSecs(0.3);
                        
                        %Wait for subject to press space
                        respMade=false;
                        while ~respMade
                            [~, Secs, keyCode,deltaSecs] = KbCheck;
                            if keyCode(KBOARD_CODE_SPACE)
                                respMade=true;
                            end
                        end
                    end
                case 'Extra'
                    %Initialize variables
                    RandTrialsOrder=RAND_TRIALS_ORDER_EXTRA;
                    NumBlocks=RAND_TRIALS_ORDER_EXTRA.NumBlocks;
                    Images=resources.ImagesExtra;
                    ImagesQ=resources.QImagesExtra;
                case 'Experiment'
                    %Initialize variables
                    RandTrialsOrder=RAND_TRIALS_ORDER;
                    NumBlocks=size(RandTrialsOrder.Blocks,2);
                    Images=resources.Images;
                    ImagesControl=resources.ControlImages;
                    ImagesQ=resources.QImages;
                case 'Practice'
                    %Initialize variables
                    RandTrialsOrder=RAND_TRIALS_ORDER_PRACTICE;
                    NumBlocks=size(RandTrialsOrder.Blocks,2);
                    Images=resources.ImagesPractice;
                    ImagesControl=resources.ControlImagesPractice;
                    ImagesQ=resources.QImagesPractice;
                    
                    %Present instructions 1
                    if EXP_CONDITION==1 %UC
                        drawImageInstructions(Instructions.msgsTex(5));
                        WaitSecs(0.3);
                    elseif EXP_CONDITION==2 %C
                        %Check fusion
                        PresentStereograms();
                        if ~IS_EXP_GO
                            return
                        end
                        
                        drawImageInstructions(Instructions.msgsTex(14));
                        WaitSecs(0.3);
                    end
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 2
                    if EXP_CONDITION==1 %UC
                        drawImageInstructions(Instructions.msgsTex(6));
                        WaitSecs(0.3);
                    elseif EXP_CONDITION==2 %C
                        drawImageInstructions(Instructions.msgsTex(15));
                        WaitSecs(0.3);
                    end
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 3
                    drawImageInstructions(Instructions.msgsTex(7));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 4
                    drawImageInstructions(Instructions.msgsTex(8));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 5
                    drawImageInstructions(Instructions.msgsTex(9));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 6
                    drawImageInstructions(Instructions.msgsTex(10));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 7
                    if EXP_CONDITION==1 %UC
                        drawImageInstructions(Instructions.msgsTex(11));
                        WaitSecs(0.3);
                    elseif EXP_CONDITION==2 %C
                        drawImageInstructions(Instructions.msgsTex(16));
                        WaitSecs(0.3);
                    end
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    
                    %Present instructions 8
                    drawImageInstructions(Instructions.msgsTex(12));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
                    %Present instructions 9
                    drawImageInstructions(Instructions.msgsTex(13));
                    WaitSecs(0.3);
                    
                    %Wait for subject to press space
                    respMade=false;
                    while ~respMade
                        [~, Secs, keyCode,deltaSecs] = KbCheck;
                        if keyCode(KBOARD_CODE_SPACE)
                            respMade=true;
                        end
                    end
            end
            
            %Blocks loop
            for block_i=1:NumBlocks
                switch ExpStep
                    case 'ThresholdFitting'
                        %Present threshold fitting block
                        drawImageInstructions(Instructions.msgsTex(19));
                        WaitSecs(0.3);
                        if trial_i_overall==0
                            NumTrialsInBlock=NUM_START_IMAGES_THF+NUM_IMAGES_BLOCK_THF;
                        else
                            NumTrialsInBlock=NUM_IMAGES_BLOCK_THF;
                        end
                    case 'Extra'   
                        %Present block
                        drawImageInstructions(Instructions.msgsTex(1));
                        WaitSecs(0.3);
                        sendEyelinkMsg(num2str(TRIGGER_EXTRA_BLOCK_START));
                        if CHECK_TRIGGERS
                            extra_block_start.TrackerTime(block_i)=Eyelink('TrackerTime');
                            extra_block_start.TriggerNumber{block_i}=num2str(TRIGGER_EXTRA_BLOCK_START);
                        end
                        NumTrialsInBlock=sum([RandTrialsOrder.Trials.BlockNum]==block_i);
                    case 'Experiment'
                        %Present block
                        drawImageInstructions(Instructions.msgsTex(1));
                        WaitSecs(0.3);
                        sendEyelinkMsg(num2str(TRIGGER_BLOCK_START));
                        if CHECK_TRIGGERS
                            block_start.TrackerTime(block_i)=Eyelink('TrackerTime');
                            block_start.TriggerNumber{block_i}=num2str(TRIGGER_BLOCK_START);
                        end
                        NumTrialsInBlock=RandTrialsOrder.Blocks(block_i).NumTrials;
                    case 'Practice'
                        %Present Practice block
                        drawImageInstructions(Instructions.msgsTex(2));
                        WaitSecs(0.3);
                        sendEyelinkMsg(num2str(TRIGGER_PRACTICE_START));
                        if CHECK_TRIGGERS
                            practice_start.TrackerTime(block_i)=Eyelink('TrackerTime');
                            practice_start.TriggerNumber{block_i}=num2str(TRIGGER_PRACTICE_START);
                        end
                        NumTrialsInBlock=RandTrialsOrder.Blocks(block_i).NumTrials;
                end
                
                %Wait for subject to press space
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
                        if ~strcmp(ExpStep,'ThresholdFitting')
                            %Calibration in the first trial in a block
                            RestrictKeysForKbCheck(oldenablekeys);
                            msg_str=runCalibrationQuery();
                            if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING
                                CALIBRATION_DATA.calibration_msg_str{end+1}=msg_str;
                                CALIBRATION_DATA.calibration_done_before_trial(end+1)=trial_i_overall;
                                CALIBRATION_DATA.calibration_beginning_block(end+1)=1;
                            end
                            RestrictKeysForKbCheck(ENABLED_KEYS);
                        end
                        last_trial_end_vbl=GetSecs();
                    end
                    
                    if strcmp(ExpStep,'ThresholdFitting') && (trial_i_overall == (NUM_START_IMAGES_THF+1))
                        drawImageInstructions(Instructions.msgsTex(19));
                        WaitSecs(0.3);
                        
                        %Wait for subject to press space
                        respMade=false;
                        while ~respMade
                            [~, Secs, keyCode,deltaSecs] = KbCheck;
                            if keyCode(KBOARD_CODE_SPACE)
                                respMade=true;
                            end
                        end
                    end
                    
                    %Organize variables before trial
                    TrialData=RandTrialsOrder.Trials(trial_i_overall);
                    fixation_fail=1;
                    NumRepetitionFixationFail=0;
                    
                    while fixation_fail
                        trial_end_vbl= runTrial(trial_i_overall,block_i,trial_i,last_trial_end_vbl,TrialData,NumRepetitionFixationFail);
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
                        ongoingFileName = createOutputFile(SUBJECT_NUMBER_AND_EXPERIMENT,ONGOING_RESULTS_FOLDER,[DESIGN_PARAM.ConditionLabels{EXP_CONDITION},'_b',num2str(block_i)]);
                        save (ongoingFileName,'EXPDATA');
                    case 'Practice'
                        ongoingFileName = createOutputFile(SUBJECT_NUMBER_AND_EXPERIMENT,ONGOING_RESULTS_FOLDER,[DESIGN_PARAM.ConditionLabels{EXP_CONDITION},'_Practice']);
                        save (ongoingFileName,'EXPDATA');
                    case 'Extra'
                        ongoingFileName = createOutputFile(SUBJECT_NUMBER_AND_EXPERIMENT,ONGOING_RESULTS_FOLDER,[DESIGN_PARAM.ConditionLabels{EXP_CONDITION},'_e',num2str(block_i)]);
                        save (ongoingFileName,'EXPDATA');

                        %Check if the goal number of PAS12 trials was reached
                        if block_i>1
                            PAS_Answers=[EXPDATA.Trials_Experiment.response_PAS_Q];
                            GoodTrials_Experiment=sum(PAS_Answers==1);
                            PAS_Answers_Extra=[EXPDATA.Trials_Extra.response_PAS_Q];
                            GoodTrials_Extra=sum(PAS_Answers_Extra==1);
                            GoodTrials=GoodTrials_Experiment+GoodTrials_Extra;
                            if GoodTrials>=GOAL_NUM_TRIALS_PAS12
                                break
                            end
                        end  
                end
                
                %display the screen for the end of the block
                if block_i<NumBlocks
                    drawImageInstructions(Instructions.msgsTex(3));
                    switch ExpStep
                        case 'Experiment'
                            sendEyelinkMsg(num2str(TRIGGER_BLOCK_END));
                            if CHECK_TRIGGERS
                                block_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                                block_end.TriggerNumber{block_i}=num2str(TRIGGER_BLOCK_END);
                            end
                        case 'Extra'
                            sendEyelinkMsg(num2str(TRIGGER_EXTRA_BLOCK_END));
                            if CHECK_TRIGGERS
                                extra_block_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                                extra_block_end.TriggerNumber{block_i}=num2str(TRIGGER_EXTRA_BLOCK_END);
                            end
                    end
                    %Wait for subject to press space
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
                end
            end
            
            switch ExpStep
                case 'Extra'
                    %display the screen for the end of the experiment
                    exp_end_vbl= drawImageInstructions(Instructions.msgsTex(4));
                    sendEyelinkMsg(num2str(TRIGGER_EXTRA_BLOCK_END));
                    if CHECK_TRIGGERS
                        extra_block_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                        extra_block_end.TriggerNumber{block_i}=num2str(TRIGGER_EXTRA_BLOCK_END);
                    end
                    
                    %save data
                    EXPDATA.info.general_info.extra_experiment_duration= exp_end_vbl - exp_start_vbl;
                    EXPDATA.info.general_info.extra_experiment_start= exp_start_vbl;
                    EXPDATA.info.general_info.extra_experiment_end= exp_end_vbl;
                    if CHECK_TRIGGERS
                        EXPDATA.check_Triggers.extra_block_start=extra_block_start;
                        EXPDATA.check_Triggers.extra_block_end=extra_block_end;
                    end
                    EXPDATA.info.general_info.calibration_data_Extra=CALIBRATION_DATA;
                case 'Experiment'
                    if EXP_CONDITION==1 %UC
                        %display the screen for the end of the block
                        exp_end_vbl=drawImageInstructions(Instructions.msgsTex(3));                       
                    elseif EXP_CONDITION==2 %C
                        %display the screen for the end of the experiment
                        exp_end_vbl=drawImageInstructions(Instructions.msgsTex(4));  
                    end
                    sendEyelinkMsg(num2str(TRIGGER_BLOCK_END));
                    if CHECK_TRIGGERS
                        block_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                        block_end.TriggerNumber{block_i}=num2str(TRIGGER_BLOCK_END);
                    end
                    
                    %save data
                    EXPDATA.info.general_info.experiment_duration= exp_end_vbl - exp_start_vbl;
                    EXPDATA.info.general_info.experiment_start= exp_start_vbl;
                    EXPDATA.info.general_info.experiment_end= exp_end_vbl;
                    if CHECK_TRIGGERS
                        EXPDATA.check_Triggers.block_start=block_start;
                        EXPDATA.check_Triggers.block_end=block_end;
                    end
                    EXPDATA.info.general_info.calibration_data_Experiment=CALIBRATION_DATA;
                    if EXP_CONDITION==1 %UC
                        %Wait for subject to press space key
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
                                    %display the screen for the end of the experiment block
                                    drawImageInstructions(Instructions.msgsTex(3));
                                end
                            end
                        end
                    end
                case 'Practice'
                    %display the screen for the end of the practice block
                    practice_end_vbl=drawImageInstructions(Instructions.msgsTex(3));
                    sendEyelinkMsg(num2str(TRIGGER_PRACTICE_END));
                    if CHECK_TRIGGERS
                        practice_end.TrackerTime(block_i)=Eyelink('TrackerTime');
                        practice_end.TriggerNumber{block_i}=num2str(TRIGGER_PRACTICE_END);
                    end
                    
                    %save data
                    EXPDATA.info.general_info.practice_duration= practice_end_vbl - exp_start_vbl;
                    EXPDATA.info.general_info.practice_start= exp_start_vbl;
                    EXPDATA.info.general_info.practice_end= practice_end_vbl;
                    if CHECK_TRIGGERS
                        EXPDATA.check_Triggers.practice_start=practice_start;
                        EXPDATA.check_Triggers.practice_end=practice_end;
                    end
                    EXPDATA.info.general_info.calibration_data_Practice=CALIBRATION_DATA;
                    
                    %Wait for subject to press space key
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
            function trial_end_vbl= runTrial(TrialNumOverall,BlockNum,TrialNum,last_trial_end_vbl,TrialData,NumRepetitionFixationFail)
                if EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING && ~strcmp(ExpStep,'ThresholdFitting')
                    Eyelink('message',['TrialId_Overall ',ExpStep,': ',num2str(TrialNumOverall)]);
                    Eyelink('message',['ImageNumber: ',num2str(TrialData.ImageID)]);
                end
                
                %Initialize variables
                fixation_fail=0;
                trial_end_vbl=NaN;
                image_vbls=nan(1,NUM_FRAMES_DURING_TOTAL_IMAGE);
                Tex=nan(1,NUM_FRAMES_DURING_TOTAL_IMAGE);
                Alpha=nan(1,NUM_FRAMES_DURING_TOTAL_IMAGE);
                Rect=nan(4,NUM_FRAMES_DURING_TOTAL_IMAGE);
                
                if ~strcmp(ExpStep,'ThresholdFitting')
                    recognitionQ_image_vbls=nan(1,NUM_FRAMES_RECOGNITION_QUESTION_TIME_LIMIT);
                    PASQ_image_vbls=nan(1,NUM_FRAMES_PAS_QUESTION_TIME_LIMIT);
                    
                    subj_answer_recognition_Q.TrackerTime=[];
                    subj_answer_recognition_Q.TriggerNumber=[];
                    did_answer_recognition_Q=0;
                    response_recognition_Q=NaN;
                    
                    subj_answer_PAS_Q.TrackerTime=[];
                    subj_answer_PAS_Q.TriggerNumber=[];
                    did_answer_PAS_Q=0;
                    response_PAS_Q=NaN;
                end
                
                %Extract current trial's variables
                if ~strcmp(ExpStep,'ThresholdFitting')
                    if TrialData.ImageID==RandTrialsOrder.ControlTrialNum %Control Trial
                        IsControlTrial=1;
                        IsImageTrial=0;
                        ImageID=TrialData.ImageIDControl;
                        ImagesBank=ImagesControl;
                        TRIGGER_IMAGE_START=TRIGGER_IMAGE_START_CONTROLTRIALS;
                    else %Image Trial
                        IsControlTrial=0;
                        IsImageTrial=1;
                        ImageID=TrialData.ImageID;
                        ImagesBank=Images;
                        TRIGGER_IMAGE_START=TRIGGER_IMAGE_START_IMAGETRIALS;
                    end
                    whichMond=TrialData.mondriansOrder;
                    
                    ImageTypeQLeft=TrialData.ImageTypeQLeft;
                    ImageIDQLeft=TrialData.ImageIDQLeft;
                    ImageTypeQRight=TrialData.ImageTypeQRight;
                    ImageIDQRight=TrialData.ImageIDQRight;
                    %Left Image
                    if ImageTypeQLeft==0 %new image
                        TexL=ImagesQ.ImageTexture(ImageIDQLeft);
                    elseif ImageTypeQLeft==1 %image from block
                        TexL=Images.ImageTexture(ImageIDQLeft);
                    end
                    AlphaL=ALPHA_IMAGE;
                    RectNonDomL=ImagesQ.dstRectNonDomL;
                    RectDomL=ImagesQ.dstRectDomL;
                    %Right Image
                    if ImageTypeQRight==0 %new image
                        TexR=ImagesQ.ImageTexture(ImageIDQRight);
                    elseif ImageTypeQRight==1 %image from block
                        TexR=Images.ImageTexture(ImageIDQRight);
                    end
                    AlphaR=ALPHA_IMAGE;
                    RectNonDomR=ImagesQ.dstRectNonDomR;
                    RectDomR=ImagesQ.dstRectDomR;
                else
                    IsControlTrial=0;
                    IsImageTrial=1;
                    ImageID=TrialData.ImageID;
                    ImagesBank=Images;
                    whichMond=TrialData.mondriansOrder;
                end
                
                %trial sequence
                %% trial initiation
                drawPlaceHolders()
                Init_Trial_screen_vbl = Screen('Flip', window, last_trial_end_vbl + (waitframes - 0.5) * ifi);
                
                %wait for the subject to press enter
                respMade=false;
                while ~respMade
                    [keyIsDownInitSecs, PressInitSecs, keyCode,PressInitdeltaSecs] = KbCheck;
                    if keyIsDownInitSecs
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
                end
                
                %% Fixation cross
                if FORCE_FIXATION && EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING && ~strcmp(ExpStep,'ThresholdFitting')
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
                        [FIXATION_MONITOR, test_result]= FIXATION_MONITOR.testFixationResponse(dom_place_holder_center);
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
                    if ~strcmp(ExpStep,'ThresholdFitting')
                        sendEyelinkMsg(num2str(TRIGGER_FIXATION_START));
                        if CHECK_TRIGGERS
                            fixation_start.TrackerTime=Eyelink('TrackerTime');
                            fixation_start.TriggerNumber=num2str(TRIGGER_FIXATION_START);
                        end
                    end
                end
                
                %% Present stimulus
                for frame_idx=1:NUM_FRAMES_DURING_TOTAL_IMAGE
                    drawPlaceHolders()
                    if ~mod(frame_idx,2) %even frame
                        %Image
                        Tex(frame_idx)=ImagesBank.ImageTexture(ImageID);
                        Alpha(frame_idx)=resources.image_alphas(frame_idx);
                        if EXP_CONDITION ==1 %UC condition
                            if strcmp(ExpStep,'ThresholdFitting')
                                Rect(:,frame_idx)=ImagesBank.dstRectDom;
                            else
                                Rect(:,frame_idx)=ImagesBank.dstRectNonDom;
                            end
                        elseif EXP_CONDITION ==2 % C condition
                            Rect(:,frame_idx)=ImagesBank.dstRectDom;
                        end
                        Screen('DrawTexture', window, Tex(frame_idx), [], Rect(:,frame_idx),[],[],Alpha(frame_idx));
                    elseif mod(frame_idx,2) %odd frame
                        %Mondrian
                        Tex(frame_idx)=resources.Mondrians.mondriansTexture{whichMond(frame_idx)};
                        Alpha(frame_idx)=ALPHA_MONDRIAN;
                        Rect(:,frame_idx)=resources.Mondrians.mondriansDisplayRect;
                        Screen('DrawTexture', window, Tex(frame_idx), [], Rect(:,frame_idx),[],[],Alpha(frame_idx));
                    end
                    
                    if frame_idx==1
                        if FORCE_FIXATION && EYE_TRACKING_METHOD~=ENUM_EYE_TRACKING_NO_TRACKING && ~strcmp(ExpStep,'ThresholdFitting')
                            image_vbls(1) = Screen('Flip', window, fixation_vbls(end) + (waitframes - 0.5) * ifi);
                        else
                            image_vbls(1) = Screen('Flip', window, fixation_vbls(end) + (NUM_FRAMES_DURING_FIXATION- 0.5) * ifi);
                        end
                        if ~strcmp(ExpStep,'ThresholdFitting')
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
                        end
                    else
                        image_vbls(frame_idx) = Screen('Flip', window, image_vbls(frame_idx-1)+ (waitframes - 0.5) * ifi);
                        if frame_idx==NUM_FRAMES_DURING_IMAGE_FADEIN && ~strcmp(ExpStep,'ThresholdFitting')
                            sendEyelinkMsg(num2str(TRIGGER_IMAGE_START_STEADY));
                            if CHECK_TRIGGERS
                                image_start_steady.TrackerTime=Eyelink('TrackerTime');
                                image_start_steady.TriggerNumber=num2str(TRIGGER_IMAGE_START_STEADY);
                            end
                        end
                    end
                end
                
                %End image presentation
                drawPlaceHolders()
                %Mondrian to both eyes
                TexEnd=resources.Mondrians.mondriansTexture{whichMond(end)};
                AlphaEnd=ALPHA_MONDRIAN;
                RectEndDom=resources.Mondrians.mondriansDisplayRect;
                RectEndNonDom=resources.Mondrians.mondriansDisplayRectNonDom;
                Screen('DrawTextures', window, [TexEnd,TexEnd], [], [RectEndDom',RectEndNonDom'],[],[],[AlphaEnd,AlphaEnd]);
                Image_End = Screen('Flip', window, image_vbls(end) + (waitframes - 0.5) * ifi);
                
                if ~strcmp(ExpStep,'ThresholdFitting')
                    sendEyelinkMsg(num2str(TRIGGER_IMAGE_END));
                    if CHECK_TRIGGERS
                        image_end.TrackerTime=Eyelink('TrackerTime');
                        image_end.TriggerNumber=num2str(TRIGGER_IMAGE_END);
                    end
                    
                    %% Recognition question
                    %Recognition question present images
                    for frame_idx_recognition_Q=1:NUM_FRAMES_RECOGNITION_QUESTION_TIME_LIMIT
                        drawPlaceHolders()
                        Screen('DrawTextures', window, [TexL,TexL,TexR,TexR], [], [RectNonDomL',RectDomL',RectNonDomR',RectDomR'],[],[],[AlphaL,AlphaL,AlphaR,AlphaR]);
                        
                        if frame_idx_recognition_Q==1
                            recognitionQ_image_vbls(1) = Screen('Flip', window, Image_End + (waitframes - 0.5) * ifi);
                            
                            sendEyelinkMsg(num2str(TRIGGER_IMAGE_START_RECOGNITION_Q));
                            if CHECK_TRIGGERS
                                image_start_recognition_Q.TrackerTime=Eyelink('TrackerTime');
                                image_start_recognition_Q.TriggerNumber=num2str(TRIGGER_IMAGE_START_RECOGNITION_Q);
                            end
                        else
                            recognitionQ_image_vbls(frame_idx_recognition_Q) = Screen('Flip', window, recognitionQ_image_vbls(frame_idx_recognition_Q-1) + (waitframes - 0.5) * ifi);
                        end
                        
                        %Check if the subject answered question
                        [keyIsDownRecognitionQSecs, PressAnswerRecognitionQSecs, keyCode, PressAnswerRecognitionQdeltaSecs] = KbCheck;
                        if keyIsDownRecognitionQSecs
                            if keyCode(KBOARD_CODE_RIGHT)
                                sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER_RECOGNITION_Q));
                                if CHECK_TRIGGERS
                                    subj_answer_recognition_Q.TrackerTime=Eyelink('TrackerTime');
                                    subj_answer_recognition_Q.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER_RECOGNITION_Q);
                                end
                                did_answer_recognition_Q=1;
                                response_recognition_Q='R';
                                break
                            elseif keyCode(KBOARD_CODE_LEFT)
                                sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER_RECOGNITION_Q));
                                if CHECK_TRIGGERS
                                    subj_answer_recognition_Q.TrackerTime=Eyelink('TrackerTime');
                                    subj_answer_recognition_Q.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER_RECOGNITION_Q);
                                end
                                did_answer_recognition_Q=1;
                                response_recognition_Q='L';
                                break
                            end
                        end
                    end
                    
                    %% PAS question (end recognition question start PAS question)
                    for frame_idx_PAS_Q=1:NUM_FRAMES_PAS_QUESTION_TIME_LIMIT
                        drawPlaceHolders()
                        Screen('DrawTextures', window, Instructions.msgsTex(17), [], DISPLAY_AREAS_RECTS);
                        
                        if frame_idx_PAS_Q==1
                            if did_answer_recognition_Q==0
                                PASQ_image_vbls(1) = Screen('Flip', window, recognitionQ_image_vbls(end) + (waitframes - 0.5) * ifi);
                            elseif did_answer_recognition_Q==1
                                PASQ_image_vbls(1) = Screen('Flip', window, PressAnswerRecognitionQSecs);
                            end
                            sendEyelinkMsg(num2str(TRIGGER_IMAGE_END_RECOGNITION_Q));
                            if CHECK_TRIGGERS
                                image_end_recognition_Q.TrackerTime=Eyelink('TrackerTime');
                                image_end_recognition_Q.TriggerNumber=num2str(TRIGGER_IMAGE_END_RECOGNITION_Q);
                            end
                            sendEyelinkMsg(num2str(TRIGGER_PAS_Q_START));
                            if CHECK_TRIGGERS
                                start_PAS_Q.TrackerTime=Eyelink('TrackerTime');
                                start_PAS_Q.TriggerNumber=num2str(TRIGGER_PAS_Q_START);
                            end
                        else
                            PASQ_image_vbls(frame_idx_PAS_Q) = Screen('Flip', window, PASQ_image_vbls(frame_idx_PAS_Q-1) + (waitframes - 0.5) * ifi);
                        end
                        
                        %Check if the subject answered question
                        [keyIsDownPASQSecs, PressAnswerPASQSecs, keyCode, PressAnswerPASQdeltaSecs] = KbCheck;
                        if keyIsDownPASQSecs
                            if keyCode(KBOARD_CODE_1)
                                sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER_PAS_Q));
                                if CHECK_TRIGGERS
                                    subj_answer_PAS_Q.TrackerTime=Eyelink('TrackerTime');
                                    subj_answer_PAS_Q.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER_PAS_Q);
                                end
                                did_answer_PAS_Q=1;
                                response_PAS_Q=1;
                                break
                            elseif keyCode(KBOARD_CODE_2)
                                sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER_PAS_Q));
                                if CHECK_TRIGGERS
                                    subj_answer_PAS_Q.TrackerTime=Eyelink('TrackerTime');
                                    subj_answer_PAS_Q.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER_PAS_Q);
                                end
                                did_answer_PAS_Q=1;
                                response_PAS_Q=2;
                                break
                            elseif keyCode(KBOARD_CODE_3)
                                sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER_PAS_Q));
                                if CHECK_TRIGGERS
                                    subj_answer_PAS_Q.TrackerTime=Eyelink('TrackerTime');
                                    subj_answer_PAS_Q.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER_PAS_Q);
                                end
                                did_answer_PAS_Q=1;
                                response_PAS_Q=3;
                                break
                            elseif keyCode(KBOARD_CODE_4)
                                sendEyelinkMsg(num2str(TRIGGER_SUBJ_ANSWER_PAS_Q));
                                if CHECK_TRIGGERS
                                    subj_answer_PAS_Q.TrackerTime=Eyelink('TrackerTime');
                                    subj_answer_PAS_Q.TriggerNumber=num2str(TRIGGER_SUBJ_ANSWER_PAS_Q);
                                end
                                did_answer_PAS_Q=1;
                                response_PAS_Q=4;
                                break
                            end
                        end
                    end
                    
                    %end PAS question
                    drawPlaceHolders()
                    if did_answer_PAS_Q==0
                        PASQ_end = Screen('Flip', window, PASQ_image_vbls(end) + (waitframes - 0.5) * ifi);
                    elseif did_answer_PAS_Q==1
                        PASQ_end = Screen('Flip', window, PressAnswerPASQSecs);
                    end
                    sendEyelinkMsg(num2str(TRIGGER_PAS_Q_END));
                    if CHECK_TRIGGERS
                        end_PAS_Q.TrackerTime=Eyelink('TrackerTime');
                        end_PAS_Q.TriggerNumber=num2str(TRIGGER_PAS_Q_END);
                    end
                else
                    drawPlaceHolders()
                    Place_holders_vbl = Screen('Flip', window, Image_End + (waitframes - 0.5) * ifi);                   
                end
                
                %% Save data
                fieldName=['Trials','_',ExpStep];
                %general data
                if strcmp(ExpStep,'ThresholdFitting')
                    EXPDATA.(fieldName)(TrialNumOverall).BlockNum=NaN;
                else
                    EXPDATA.(fieldName)(TrialNumOverall).BlockNum=BlockNum;                    
                end
                EXPDATA.(fieldName)(TrialNumOverall).TrialNum=TrialNum;
                EXPDATA.(fieldName)(TrialNumOverall).NumRepetitionFixationFail=NumRepetitionFixationFail;
                %image data
                if IsControlTrial==0 %image trial
                    EXPDATA.(fieldName)(TrialNumOverall).ImageID=ImageID;
                    EXPDATA.(fieldName)(TrialNumOverall).ImageIDControl=NaN;
                else %control trial
                    EXPDATA.(fieldName)(TrialNumOverall).ImageID=RandTrialsOrder.ControlTrialNum;
                    EXPDATA.(fieldName)(TrialNumOverall).ImageIDControl=ImageID;
                end
                EXPDATA.(fieldName)(TrialNumOverall).ImageName=ImagesBank.ImageName{ImageID};
                
                EXPDATA.(fieldName)(TrialNumOverall).Tex=Tex;
                EXPDATA.(fieldName)(TrialNumOverall).Alpha=Alpha;
                EXPDATA.(fieldName)(TrialNumOverall).Rect=Rect;
                EXPDATA.(fieldName)(TrialNumOverall).TexEnd=TexEnd;
                EXPDATA.(fieldName)(TrialNumOverall).AlphaEnd=AlphaEnd;
                EXPDATA.(fieldName)(TrialNumOverall).RectEndDom=RectEndDom;
                EXPDATA.(fieldName)(TrialNumOverall).RectEndNonDom=RectEndNonDom;
                
                EXPDATA.(fieldName)(TrialNumOverall).whichMond=whichMond;
                EXPDATA.(fieldName)(TrialNumOverall).IsImageTrial=IsImageTrial;
                EXPDATA.(fieldName)(TrialNumOverall).IsControlTrial=IsControlTrial;
                
                if ~strcmp(ExpStep,'ThresholdFitting')
                    %recognition question data
                    EXPDATA.(fieldName)(TrialNumOverall).ImageIDQLeft=ImageIDQLeft;
                    if ImageTypeQLeft==0 %new image
                        EXPDATA.(fieldName)(TrialNumOverall).ImageNameQLeft=ImagesQ.ImageName{ImageIDQLeft};
                    elseif ImageTypeQLeft==1 %image from block
                        EXPDATA.(fieldName)(TrialNumOverall).ImageNameQLeft=ImagesBank.ImageName{ImageIDQLeft};
                    end
                    EXPDATA.(fieldName)(TrialNumOverall).ImageTypeQLeft=ImageTypeQLeft;
                    
                    EXPDATA.(fieldName)(TrialNumOverall).ImageIDQRight=ImageIDQRight;
                    if ImageTypeQRight==0 %new image
                        EXPDATA.(fieldName)(TrialNumOverall).ImageNameQRight=ImagesQ.ImageName{ImageIDQRight};
                    elseif ImageTypeQRight==1 %image from block
                        EXPDATA.(fieldName)(TrialNumOverall).ImageNameQRight=ImagesBank.ImageName{ImageIDQRight};
                    end
                    EXPDATA.(fieldName)(TrialNumOverall).ImageTypeQRight=ImageTypeQRight;
                    
                    EXPDATA.(fieldName)(TrialNumOverall).TexL=TexL;
                    EXPDATA.(fieldName)(TrialNumOverall).AlphaL=AlphaL;
                    EXPDATA.(fieldName)(TrialNumOverall).RectNonDomL=RectNonDomL;
                    EXPDATA.(fieldName)(TrialNumOverall).RectDomL=RectDomL;
                    EXPDATA.(fieldName)(TrialNumOverall).TexR=TexR;
                    EXPDATA.(fieldName)(TrialNumOverall).AlphaR=AlphaR;
                    EXPDATA.(fieldName)(TrialNumOverall).RectNonDomR=RectNonDomR;
                    EXPDATA.(fieldName)(TrialNumOverall).RectDomR=RectDomR;
                end
                
                %timing in experiment
                EXPDATA.(fieldName)(TrialNumOverall).Init_Trial_screen_vbl=Init_Trial_screen_vbl;
                EXPDATA.(fieldName)(TrialNumOverall).PressInitSecs=PressInitSecs;
                EXPDATA.(fieldName)(TrialNumOverall).PressInitdeltaSecs=PressInitdeltaSecs;
                EXPDATA.(fieldName)(TrialNumOverall).fixation_vbls=fixation_vbls;
                EXPDATA.(fieldName)(TrialNumOverall).image_vbls=image_vbls;
                EXPDATA.(fieldName)(TrialNumOverall).Image_End=Image_End;
                EXPDATA.(fieldName)(TrialNumOverall).ImagePresentationTime=Image_End-image_vbls(1);
                EXPDATA.(fieldName)(TrialNumOverall).ImageWantedPresentationTime=IMAGE_DURATION/1000; %sec
                
                if ~strcmp(ExpStep,'ThresholdFitting')
                    if did_answer_recognition_Q
                        recognitionQ_image_vbls((frame_idx_recognition_Q+1):end)=[];
                    end
                    EXPDATA.(fieldName)(TrialNumOverall).recognitionQ_image_vbls=recognitionQ_image_vbls;
                    
                    EXPDATA.(fieldName)(TrialNumOverall).RecognitionQImagePresentationTime=PASQ_image_vbls(1)-recognitionQ_image_vbls(1);
                    if did_answer_recognition_Q
                        EXPDATA.(fieldName)(TrialNumOverall).RecognitionQImageWantedPresentationTime=PressAnswerRecognitionQSecs-recognitionQ_image_vbls(1); %sec
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerRecognitionQSecs=PressAnswerRecognitionQSecs;
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerRecognitionQdeltaSecs=PressAnswerRecognitionQdeltaSecs;
                    else
                        EXPDATA.(fieldName)(TrialNumOverall).RecognitionQImageWantedPresentationTime=RECOGNITION_QUESTION_MAX_DURATION/1000; %sec
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerRecognitionQSecs=NaN;
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerRecognitionQdeltaSecs=NaN;
                    end
                    
                    if did_answer_PAS_Q
                        PASQ_image_vbls((frame_idx_PAS_Q+1):end)=[];
                    end
                    EXPDATA.(fieldName)(TrialNumOverall).PASQ_image_vbls=PASQ_image_vbls;
                    EXPDATA.(fieldName)(TrialNumOverall).PASQ_end=PASQ_end;
                    EXPDATA.(fieldName)(TrialNumOverall).PASQPresentationTime=PASQ_end-PASQ_image_vbls(1);
                    if did_answer_PAS_Q
                        EXPDATA.(fieldName)(TrialNumOverall).PASQWantedPresentationTime=PressAnswerPASQSecs-PASQ_image_vbls(1); %sec
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerPASQSecs=PressAnswerPASQSecs;
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerPASQdeltaSecs=PressAnswerPASQdeltaSecs;
                    else
                        EXPDATA.(fieldName)(TrialNumOverall).PASQWantedPresentationTime=PAS_QUESTION_MAX_DURATION/1000; %sec
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerPASQSecs=NaN;
                        EXPDATA.(fieldName)(TrialNumOverall).PressAnswerPASQdeltaSecs=NaN;
                    end
                    
                    %recognition question answer
                    EXPDATA.(fieldName)(TrialNumOverall).did_answer_recognition_Q=did_answer_recognition_Q;
                    EXPDATA.(fieldName)(TrialNumOverall).response_recognition_Q=response_recognition_Q;
                    if (ImageTypeQLeft==1 && strcmp(response_recognition_Q,'L')) || (ImageTypeQRight==1 && strcmp(response_recognition_Q,'R'))
                        EXPDATA.(fieldName)(TrialNumOverall).isCorrect_recognition_Q=1;
                    else
                        EXPDATA.(fieldName)(TrialNumOverall).isCorrect_recognition_Q=0;
                    end
                    
                    %PAS question answer
                    EXPDATA.(fieldName)(TrialNumOverall).did_answer_PAS_Q=did_answer_PAS_Q;
                    EXPDATA.(fieldName)(TrialNumOverall).response_PAS_Q=response_PAS_Q;
                    
                    %Triggers
                    if CHECK_TRIGGERS
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.fixation_start=fixation_start;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.fixation_end=fixation_end;
                        
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_start=image_start;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_start_steady=image_start_steady;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_end=image_end;
                        
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_start_recognition_Q=image_start_recognition_Q;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.subj_answer_recognition_Q=subj_answer_recognition_Q;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.image_end_recognition_Q=image_end_recognition_Q;
                        
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.start_PAS_Q=start_PAS_Q;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.subj_answer_PAS_Q=subj_answer_PAS_Q;
                        EXPDATA.(fieldName)(TrialNumOverall).check_Triggers.end_PAS_Q=end_PAS_Q;
                    end
                else
                    EXPDATA.(fieldName)(TrialNumOverall).Place_holders_vbl=Place_holders_vbl;
                end
                
                %End trial time
                trial_end_vbl = GetSecs();
                EXPDATA.(fieldName)(TrialNumOverall).trial_end_vbl=trial_end_vbl;
                EXPDATA.(fieldName)(TrialNumOverall).TrialDuration= trial_end_vbl-Init_Trial_screen_vbl;
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
                    load('EL_DEFAULTS_original.mat')
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
            Screen('DrawTextures', window, tex, [], DISPLAY_AREAS_RECTS);
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
        
        function Imagesdata=TexFromImages(IMAGES_FOLDER,trialsOrder)
            %This code assumes all images are in the same size
            ImagesIdInclude=[trialsOrder.Trials.ImageID];
            ImagesIdInclude(ImagesIdInclude==trialsOrder.ControlTrialNum)=[];
            
            cd(IMAGES_FOLDER);
            AllImages = dir('*.jpg');
            numImages=size(AllImages,1);
            Imagesdata.ImageName=cell(1,numImages);
            Imagesdata.ImageTexture=NaN(1,numImages);
            
            % Get the size of the images
            Imagesdata.ImageSize= DESIGN_PARAM.Image_Size;
            % Get the aspect ratio of the image
            Imagesdata.ImageaspectRatio= Imagesdata.ImageSize(2)./Imagesdata.ImageSize(1); %w/h
            
            for ii=1:length(ImagesIdInclude)
                clear indInTrials ImageId Image
                ImageId=ImagesIdInclude(ii);
                indInTrials=find([trialsOrder.Trials.ImageID]==ImageId);
                
                Image=imread(trialsOrder.Trials(indInTrials).ImageName);
                Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrials).ImageName;
                Imagesdata.ImageTexture(ImageId) = Screen('MakeTexture', window, Image);
            end
            
            % Rescale the image according to the display area
            Imagesdata.imageWidth=DISPLAY_AREA_SZ(1);
            Imagesdata.imageHeight=Imagesdata.imageWidth*(1/Imagesdata.ImageaspectRatio);
            
            theRect = [0 0 Imagesdata.imageWidth Imagesdata.imageHeight];
            [xNonDom,yNonDom]=RectCenter(DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectNonDom = CenterRectOnPointd(theRect,xNonDom,yNonDom);
            [xDom,yDom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectDom = CenterRectOnPointd(theRect,xDom,yDom);
            
            cd(CURRENT_FOLDER)
        end
        
        function Imagesdata=TexFromControlImages(IMAGES_FOLDER,trialsOrder)
            %This code assumes all images are in the same size
            controlImagesInTrials=find([trialsOrder.Trials.ImageID]==trialsOrder.ControlTrialNum);
            
            cd(IMAGES_FOLDER);
            AllImages = dir('*.jpg');
            numImages=size(AllImages,1);
            Imagesdata.ImageName=cell(1,numImages);
            Imagesdata.ImageScrambled=cell(1,numImages);
            Imagesdata.ImageTexture=NaN(1,numImages);
            
            % Get the size of the images
            Imagesdata.ImageSize= DESIGN_PARAM.Image_Size;
            % Get the aspect ratio of the image
            Imagesdata.ImageaspectRatio= Imagesdata.ImageSize(2)./Imagesdata.ImageSize(1); %w/h
            
            for ii=1:length(controlImagesInTrials)
                clear indInTrials ImageId Image
                indInTrials=controlImagesInTrials(ii);
                ImageId=trialsOrder.Trials(indInTrials).ImageIDControl;
                
                Image=imread(trialsOrder.Trials(indInTrials).ImageName);
                %phase scrambel image
                cd(CURRENT_FOLDER)
                Image_scrambled = imscramble(Image);
                cd(IMAGES_FOLDER)
                
                Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrials).ImageName;
                Imagesdata.ImageScrambled{ImageId}=Image_scrambled;
                Imagesdata.ImageTexture(ImageId) = Screen('MakeTexture', window, Image_scrambled);
            end
            % Rescale the image according to the display area
            Imagesdata.imageWidth=DISPLAY_AREA_SZ(1);
            Imagesdata.imageHeight=Imagesdata.imageWidth*(1/Imagesdata.ImageaspectRatio);
            
            theRect = [0 0 Imagesdata.imageWidth Imagesdata.imageHeight];
            [xNonDom,yNonDom]=RectCenter(DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectNonDom = CenterRectOnPointd(theRect,xNonDom,yNonDom);
            [xDom,yDom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectDom = CenterRectOnPointd(theRect,xDom,yDom);
            
            cd(CURRENT_FOLDER)
        end
        
        function Imagesdata=TexFromQImages(IMAGES_FOLDER,trialsOrder)
            %This code assumes all images are in the same size
            LTrials=find([trialsOrder.Trials.ImageTypeQLeft]==0);
            RTrials=find([trialsOrder.Trials.ImageTypeQRight]==0);
            ImagesIdInclude=[[trialsOrder.Trials(LTrials).ImageIDQLeft],[trialsOrder.Trials(RTrials).ImageIDQRight]];
            
            cd(IMAGES_FOLDER);
            AllImages = dir('*.jpg');
            numImages=size(AllImages,1);
            Imagesdata.ImageName=cell(1,numImages);
            Imagesdata.ImageTexture=NaN(1,numImages);
            
            % Get the size of the images
            Imagesdata.ImageSize= DESIGN_PARAM.Image_Size;
            % Get the aspect ratio of the image
            Imagesdata.ImageaspectRatio= Imagesdata.ImageSize(2)./Imagesdata.ImageSize(1); %w/h
            
            for ii=1:length(ImagesIdInclude)
                clear indInTrialsL indInTrialsR ImageId Image
                ImageId=ImagesIdInclude(ii);
                indInTrialsL=find([trialsOrder.Trials.ImageIDQLeft]==ImageId & [trialsOrder.Trials.ImageTypeQLeft]==0);
                indInTrialsR=find([trialsOrder.Trials.ImageIDQRight]==ImageId & [trialsOrder.Trials.ImageTypeQRight]==0);
                if ~isempty(indInTrialsL) && isempty(indInTrialsR) % left image
                    Image=imread(trialsOrder.Trials(indInTrialsL).ImageNameQLeft);
                    Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrialsL).ImageNameQLeft;
                elseif ~isempty(indInTrialsR) && isempty(indInTrialsL) % right image
                    Image=imread(trialsOrder.Trials(indInTrialsR).ImageNameQRight);
                    Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrialsR).ImageNameQRight;
                end
                Imagesdata.ImageTexture(ImageId) = Screen('MakeTexture', window, Image);
            end
            
            % Rescale the image according to the display area
            Imagesdata.imageWidth=DISPLAY_AREA_SZ(1)/2;
            Imagesdata.imageHeight=Imagesdata.imageWidth*(1/Imagesdata.ImageaspectRatio);
            
            theRect = [0 0 Imagesdata.imageWidth Imagesdata.imageHeight];
            
            [xNonDom,yNonDom]=RectCenter(DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectNonDomL = CenterRectOnPointd(theRect,xNonDom-(DISPLAY_AREA_SZ(1)/4),yNonDom);
            Imagesdata.dstRectNonDomR = CenterRectOnPointd(theRect,xNonDom+(DISPLAY_AREA_SZ(1)/4),yNonDom);
            [xDom,yDom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectDomL = CenterRectOnPointd(theRect,xDom-(DISPLAY_AREA_SZ(1)/4),yDom);
            Imagesdata.dstRectDomR = CenterRectOnPointd(theRect,xDom+(DISPLAY_AREA_SZ(1)/4),yDom);
            cd(CURRENT_FOLDER)
        end
        
        function Imagesdata=TexFromImagesThrFitting(IMAGES_FOLDER,trialsOrder)
            %This code assumes all images have the same aspect ratio as the
            %original images
            ImagesIdInclude=[trialsOrder.Trials.ImageID];
            
            cd(IMAGES_FOLDER);
            AllImages = dir('*.jpg');
            numImages=size(AllImages,1);
            Imagesdata.ImageName=cell(1,numImages);
            Imagesdata.ImageTexture=NaN(1,numImages);
            
            % Get the size of the images
            Imagesdata.ImageSize= DESIGN_PARAM.Image_Size_Thr_Fitting;
            % Get the aspect ratio of the image
            Imagesdata.ImageaspectRatio= Imagesdata.ImageSize(2)./Imagesdata.ImageSize(1); %w/h
            
            for ii=1:length(ImagesIdInclude)
                clear indInTrials ImageId Image
                ImageId=ImagesIdInclude(ii);
                indInTrials=find([trialsOrder.Trials.ImageID]==ImageId);
                
                Image=imread(trialsOrder.Trials(indInTrials).ImageName);
                Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrials).ImageName;
                Imagesdata.ImageTexture(ImageId) = Screen('MakeTexture', window, Image);
            end
            
            % Rescale the image according to the display area
            Imagesdata.imageWidth=DISPLAY_AREA_SZ(1);
            Imagesdata.imageHeight=Imagesdata.imageWidth*(1/Imagesdata.ImageaspectRatio);
            
            theRect = [0 0 Imagesdata.imageWidth Imagesdata.imageHeight];
            [xNonDom,yNonDom]=RectCenter(DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectNonDom = CenterRectOnPointd(theRect,xNonDom,yNonDom);
            [xDom,yDom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectDom = CenterRectOnPointd(theRect,xDom,yDom);
            
            cd(CURRENT_FOLDER)
        end
        
        function Imagesdata=TexFromQImagesExtra(IMAGES_FOLDER,trialsOrder)
            %This code assumes all images have the same aspect ratio as the
            %original images
            LTrials=find([trialsOrder.Trials.ImageTypeQLeft]==0);
            RTrials=find([trialsOrder.Trials.ImageTypeQRight]==0);
            ImagesIdInclude=[[trialsOrder.Trials(LTrials).ImageIDQLeft],[trialsOrder.Trials(RTrials).ImageIDQRight]];
            
            cd(IMAGES_FOLDER);
            AllImages = dir('*.jpg');
            numImages=size(AllImages,1);
            Imagesdata.ImageName=cell(1,numImages);
            Imagesdata.ImageTexture=NaN(1,numImages);
            
            % Get the size of the images
            Imagesdata.ImageSize= DESIGN_PARAM.Image_Size_Thr_Fitting;
            % Get the aspect ratio of the image
            Imagesdata.ImageaspectRatio= Imagesdata.ImageSize(2)./Imagesdata.ImageSize(1); %w/h
            
            for ii=1:length(ImagesIdInclude)
                clear indInTrialsL indInTrialsR ImageId Image
                ImageId=ImagesIdInclude(ii);
                indInTrialsL=find([trialsOrder.Trials.ImageIDQLeft]==ImageId & [trialsOrder.Trials.ImageTypeQLeft]==0);
                indInTrialsR=find([trialsOrder.Trials.ImageIDQRight]==ImageId & [trialsOrder.Trials.ImageTypeQRight]==0);
                if ~isempty(indInTrialsL) && isempty(indInTrialsR) % left image
                    Image=imread(trialsOrder.Trials(indInTrialsL).ImageNameQLeft);
                    Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrialsL).ImageNameQLeft;
                elseif ~isempty(indInTrialsR) && isempty(indInTrialsL) % right image
                    Image=imread(trialsOrder.Trials(indInTrialsR).ImageNameQRight);
                    Imagesdata.ImageName{ImageId} = trialsOrder.Trials(indInTrialsR).ImageNameQRight;
                end
                Imagesdata.ImageTexture(ImageId) = Screen('MakeTexture', window, Image);
            end
            
            % Rescale the image according to the display area
            Imagesdata.imageWidth=DISPLAY_AREA_SZ(1)/2;
            Imagesdata.imageHeight=Imagesdata.imageWidth*(1/Imagesdata.ImageaspectRatio);
            
            theRect = [0 0 Imagesdata.imageWidth Imagesdata.imageHeight];
            
            [xNonDom,yNonDom]=RectCenter(DISPLAY_AREAS_RECTS(:,NON_DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectNonDomL = CenterRectOnPointd(theRect,xNonDom-(DISPLAY_AREA_SZ(1)/4),yNonDom);
            Imagesdata.dstRectNonDomR = CenterRectOnPointd(theRect,xNonDom+(DISPLAY_AREA_SZ(1)/4),yNonDom);
            [xDom,yDom]=RectCenter(DISPLAY_AREAS_RECTS(:,DOMINANT_EYE_NUMBER));
            Imagesdata.dstRectDomL = CenterRectOnPointd(theRect,xDom-(DISPLAY_AREA_SZ(1)/4),yDom);
            Imagesdata.dstRectDomR = CenterRectOnPointd(theRect,xDom+(DISPLAY_AREA_SZ(1)/4),yDom);
            cd(CURRENT_FOLDER)
        end
        
        function TRIALS_ORDER=RandomizeMondrains(TRIALS_ORDER)
            NumMondCreate=NUM_MONDARIANS_DURING_TOTAL_IMAGE+1;
            for trial=1:size(TRIALS_ORDER.Trials,2)
                clear mondOptions whichMond whichMondLong
                mondOptions = repmat(1:resources.Mondrians.mondrians_nr,1,ceil(NumMondCreate/resources.Mondrians.mondrians_nr));
                whichMond = mondOptions(randperm(length(mondOptions)));
                whichMond = whichMond(1:NumMondCreate)';
                
                whichMondLong=repmat(whichMond',FRAMES_PER_MONDRIAN,1);
                whichMondLong=whichMondLong(:);
                TRIALS_ORDER.Trials(trial).mondriansOrder=whichMondLong;
            end
            
            if (length(whichMondLong)-1*FRAMES_PER_MONDRIAN)< NUM_FRAMES_DURING_TOTAL_IMAGE
                disp('Problem with mondrian randomization')
                IS_EXP_GO=0;
                return;
            end
        end
        
        function drawPlaceHolders()
            Screen('DrawTextures', window, resources.checkerboard_tex, [],CHECKERBOARDS_RECTS);
            Screen('DrawTextures', window, resources.sqr_tex, [],DISPLAY_AREAS_RECTS, [], [], [], [BACKGROUND_COLOR;BACKGROUND_COLOR]');
        end
        
        function [Mondrians,progressBar]=createMondrianImageAndTex(resources,progressBar)
            %create mondrian images
            mondrian_imgs= make_mondrian_masks(ceil(resources.Images.imageWidth),ceil(resources.Images.imageHeight),NUM_MONDRIAN_MASKS_BANK, 1, 3, 1, MONDRIAN_SHAPES_SZS, progressBar);
            
            %create mondrian textures
            mondrians_nr= numel(mondrian_imgs);
            Mondrians.mondriansTexture= cell(1,mondrians_nr);
            for mondrian_i= 1:mondrians_nr
                Mondrians.mondriansTexture{mondrian_i}= Screen('MakeTexture', window, mondrian_imgs{mondrian_i});
            end
            %mondrians display rect
            Mondrians.mondriansDisplayRect =resources.Images.dstRectDom;
            Mondrians.mondriansDisplayRectNonDom =resources.Images.dstRectNonDom;
            %save data about mondrians
            Mondrians.mondrians_nr=mondrians_nr;
            Mondrians.mondrian_imgs=mondrian_imgs;
        end
        
        function Stereograms=TexFromImageStereogram()
            cd(STEREOGRAM_SAVE_FOLDER);
            Images = dir('*.bmp');
            
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
                Stereograms.stereogramsImageName{aa}=Images(aa).name;
                Stereograms.stereogramsImage{aa}=Image;
                Stereograms.stereogramsTexture{aa}= Screen('MakeTexture', window,Image);
            end
            cd(CURRENT_FOLDER)
        end
        
        function PresentStereograms()
            drawPlaceHolders()
            Screen('DrawTextures', window, [resources.Stereograms.stereogramsTexture{1},resources.Stereograms.stereogramsTexture{2}], [],[resources.Stereograms.dstRect{1},resources.Stereograms.dstRect{2}]);
            Screen('Flip', window);
            
            %Wait for subject to press left key
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
        
        function [ALPHA_IMAGE,resources,Thr_Flag]=updateImageAlpha(LAST_ALPHA_IMAGE,resources)
            %ask experimenter for a new alpha
            drawPlaceHolders()
            Screen('DrawTextures', window, Instructions.msgsTex(20), [], [DISPLAY_AREAS_RECTS(:,1),DISPLAY_AREAS_RECTS(:,2)]);
            Screen('Flip', window);
            
            respMade=false;
            while ~respMade
                [~, ~, keyCode,~] = KbCheck;
                if keyCode(KBOARD_CODE_UP)
                    ALPHA_IMAGE=LAST_ALPHA_IMAGE+ALPHA_DELTA_THF;
                    Thr_Flag=1;
                    respMade=true;
                elseif keyCode(KBOARD_CODE_ESC)
                    ALPHA_IMAGE=LAST_ALPHA_IMAGE;
                    Thr_Flag=0;
                    respMade=true;
                end
            end
            
            %calculate image alphas in fade in
            alphas=linspace(0,ALPHA_IMAGE,NUM_FRAMES_DURING_IMAGE_FADEIN);
            resources.image_alphas=[alphas,ALPHA_IMAGE.*ones(1,NUM_FRAMES_STEADY_IMAGE)];
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