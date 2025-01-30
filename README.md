# FreeViewing

############################ Exp 3: Main experiment, pilot 1 is experiment 1, pilot 2 is experiment 2

############# Before running, download the following Exp3 folders from OSF (https://osf.io/b5ntv/):
a. Locate the Raw Data folder inside FreeViewing\Exp3\
b. Locate the ResultsStructs folder inside FreeViewing\Exp3\Analysis\AnalysisFolders\

############# Running the code: 
All analyses were run on Matlab 2018B, except for the CNN analysis which was conducted on Matlab 2023A.

1. Experimental code:
The experimental code can be found in:
FreeViewing\Exp3\Experiment\RUN_ME\Code
a. Run Run_BuildImageOrder() in the command window, in order to create ExpDesignAllSubjects.mat that has
trial randomization for all participants in advance.
b. In Run_FV_CFS.m change parameters:
DEBUG_CODE=0; (1 run with debugging, 0 run without debugging)
WANTED_FPS=100; %Hz (change according to your screens refresh rate)
c. Run the code by running the function: Run_FV_CFS(1) in the command window.
Comments:
-Psychtoolbox should be installed to run the code
-To run the code without the eye tracker do not change anything in the GUI
-To run the code with an eye tracker change in the GUI: Eye tracking method: eye tracker,
Choose "restart trials on fixation break". 

2. Analysis code:
#Eye tracking analysis
This analysis arranges the eye tracking data, and then calculates the object analysis, region analysis and 
emotional face attribute analysis. 
The analysis code is in:
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis
Run the code by running the script: Run_analysis_images.m in the command window
Conditions for running the code:
a. saveFlag: 0 do not save, 1 save
b. experiment_number: '1' for experiment 1, '2' for experiment 2 (this number should be given as a char) 
c. condition: 1 - main analysis 
              2 - low level type 1: this control analysis is done because the low level regions in the main 
              analysis are different from what is written in the pre-registration (see manuscript). In the main analysis,  
              low level type 2 regions are used (created using smiler package), in this analysis low level type 1 regions are used 
              (created using the saliencytoolbox). 
              3 - RttM check: in this control analysis, participants with high objective awareness scores are excluded 
              to check if the results stem from RttM (see manuscript).


#CNN analysis
This analysis calculates the RSA analysis, comparing fixation maps in both visibility conditions to the activations of the CNN.
The analysis code is in:
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\CNNAnalysis
Run the code by running the script: Run.m in the command window

Change the following parameters to adjust the code as you like:
a. saveFlag: 0 do not save, 1 save
b. experiment_number: '1' for experiment 1, '2' for experiment 2, '1&2' for combined data from 
                      experiment 1 and 2 (this number should be given as a char) 
c. condition: 1 - main analysis  
              3 - RttM check: control analysis see explanation above.

#Creating plots or calculating tree BH for both experiments
The analysis code is in:
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis\PlotsBothExperiments

A.Run_AwarenessResultsExperiments.m - creates the awareness results figure.
Possible parameters: 
saveFlag- 1 save, 0 do not save

B.Run_CNNResults.m - create the cnn results figures.
Possible parameters: 
AnalysisType- 1 main analysis, 3 RttM check analysis
saveFlag- 1 save, 0 do not save

C.Run_EyeMovementResultsExperiments.m - create the object analysis, region analysis and emotional face attribute analysis results figures.
Possible parameters: 
AnalysisType- 1 main analysis, 2 low level type 1 analysis, 3 RttM check analysis
saveFlag- 1 save, 0 do not save

D. Run_ObjectClassificationPlots.m - creates the object segmenation demonstration figures.
Possible parameters: 
saveFlag- 1 save, 0 do not save

E.Run_RegionClassificationPlots.m - creates the region segmenation demonstration figures.
Possible parameters: 
saveFlag- 1 save, 0 do not save

F.Run_TreeBHAllExperimentsWithCNN.m - calculate tree BH for all analyses in the manuscript.
Possible parameters: 
AnalysisType- 1 main analysis, 2 low level type 1 analysis, 3 RttM check analysis
saveFlag- 1 save, 0 do not save

#Behavioral analysis 
This analysis checks awareness scores of all participants, and calculates group level awareness.
The analysis code is in:
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\BehavioralAnalysis
Run the code by running the script: Run_AnalyzeBehavior.m in the command window
Parameters for running the code:
a. saveFlag: 0 do not save, 1 save
b. experiment_number: '1' for experiment 1, '2' for experiment 2 (this number should be given as a char)
* Inside the folder BayesianAnalysis there are calculations in JASP of the Bayesian analysis 

#Image analysis
This code creates the high level region and low level region maps for the region analysis for all images.
The analysis code is in:
FreeViewing\Exp3\Analysis\AnalysisCode\ImageAnalysis

A. Run_CreateHighLevelMaps.m - creates high level maps that define the semantically salient regions 
                               (high level regions) in the region analysis.

C. Run_CreateLowLevelMaps2.m - creates low level maps type 2 that define the visually salient regions 
                               (low level regions) in the region analysis. The maps are created based on
                               Itti & Koch's saliency model from Smiler. These maps are used in the main
                               analysis.

B. Run_CreateLowLevelMaps1.m - creates low level maps type 1 that define the visually salient regions 
                               (low level regions) in the region analysis. The maps are created based on
                               Itti & Koch's saliency model from saliencytoolbox.These maps are used in
                               low level type 1 analysis.

############# Data about packages and codes downloaded from the internet: 
All these codes are located in: FreeViewing\Exp3\Analysis\AnalysisFolders\Code 

#breakxaxis
code for creating a break in the x axis in a plot for better visualization.
Peter, Break X Axis . MATLAB Central File Exchange (2024). 
https://www.mathworks.com/matlabcentral/fileexchange/42905-break-x-axis.

#Itti&Koch_WalthersSaliencyToolbox_L
Sailencytoolbox used to create low level regions for the region analysis in low level type 1 control analysis, based on Itti&Koch's saliency model. 
Version 2.3 is used.
D. Walther, C. Koch, Modeling attention to salient proto-objects. Neural Networks 19,  1395–1407 (2006).

#myBinomTest
code for calculating a binomial test, used to test the accuracy in the objective awareness test with a binomial distribution.
Matthew Nelson, myBinomTest(s,n,p,Sided) . MATLAB Central File Exchange (2022). https://www.mathworks.com/matlabcentral/fileexchange/24813-mybinomtest-s-n-p-sided.

#RainCloudPlot
code for creating rain cloud plots
M. Allen, D. Poggiali, K. Whitaker, T. R. Marshall, J. van Langen, R. A. Kievit, Raincloud plots: a multi-platform tool for robust data visualization. Wellcome Open Res 4 (2021).

In addition to downloading the rain cloud plots code, the following codes were also downloaded, and located in tutorial_matlab folder: 
a. cbrewer: colorbrewer schemes for matlab
from: https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab
b. Robust_Statistical_Toolbox
from: https://github.com/CPernet/Robust_Statistical_Toolbox

Inside the folder tutorial_matlab I added the following codes: (based on existing codes)
1) raincloud_plot_big_circles.m
2) rm_raincloud_dots_different_sizes.m

#Smiler
toolbox used to create low level regions for the region analysis in the main analysis, based on Itti&Koch's saliency model. 
C. Wloka, T. Kunić, I. Kotseruba, R. Fahimi, N. Frosst, N. D. B. Bruce, J. K. Tsotsos, SMILER: Saliency Model Implementation Library for Experimental Research. arXiv Prepr, doi: https://doi.org/10.48550/arXiv.1812.08848 (2018).

#TreeBH
tree BH method for correcting for multiple comparisons in all the manuscript.
This code is an in-house code used in Mudrik's lab.

############# Folders content:
## code folders
FreeViewing\Exp3\Analysis\AnalysisCode\ImageAnalysis- creates the high level region and low level region maps for the region analysis
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis - calculates the object analysis, region analysis and emotional face attribute analysis
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis\PlotsBothExperiments- creates the plots or tree BH calculations for both experiments
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\EyeTrackingAnalysis\PlotsBothExperiments\Figures- final figures used in manuscript
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\CNNAnalysis - calculates the CNN analysis
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\BehavioralAnalysis- calculates the awareness analysis
FreeViewing\Exp3\Analysis\AnalysisCode\ResultsAnalysis\BehavioralAnalysis\BayesianAnalysis- calculation in JASP of the Bayesian analysis 

FreeViewing\Exp3\Analysis\AnalysisFolders\Code\breakxaxis - code for creating a break in x axis in a plot for better visualization
FreeViewing\Exp3\Analysis\AnalysisFolders\Code\Itti&Koch_WalthersSaliencyToolbox_L- Sailencytoolbox used to create low level regions for the region analysis in low level type 1 control analysis, based on Itti&Koch's saliency model. 
FreeViewing\Exp3\Analysis\AnalysisFolders\Code\myBinomTest- code for calculating a binomial test, used to test the accuracy in the objective awareness test with a binomial distribution.
FreeViewing\Exp3\Analysis\AnalysisFolders\Code\RainCloudPlot- code for creating rain cloud plots
FreeViewing\Exp3\Analysis\AnalysisFolders\Code\Smiler- toolbox used to create low level regions for the region analysis in the main analysis, based on Itti&Koch's saliency model. 
FreeViewing\Exp3\Analysis\AnalysisFolders\Code\TreeBH- tree BH method for correcting for multiple comparisons in all the manuscript.

# experimental code folders:
FreeViewing\Exp3\Experiment\RUN_ME\Code - Experimental code to run the experiment
FreeViewing\Exp3\Experiment\RUN_ME\Stimuli - Stimuli used in the experiment

# results images
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsImages\FixationMapsRemoveCenterBias\Pilot1- Fixation maps in each visibility condition (U in the name for unconscious condition, and C for conscious), for each image, from all participants who viewed this image, in experiment 1
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsImages\FixationMapsRemoveCenterBias\Pilot2- Fixation maps in each visibility condition (U in the name for unconscious condition, and C for conscious), for each image, from all participants who viewed this image, in experiment 2
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsImages\HighLevelMaps - High level maps defining high level regions in region analysis
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsImages\LowLevelMaps - Low level maps defining low level regions in region analysis (main analysis)
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsImages\SaliencyMaps - Low level maps defining low level regions in region analysis (low level type 1, control analysis)
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsImages\RegionsFixationMapsBothExperiments - Fixation maps for each image in each visibility conditions in each experiment (in one figure) overlaid on region classification

# results folders
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs- tree BH data for each analysis condition: main, low level type 1 and RttM check.
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\Pilot1_Final- experiment 1 main analysis results
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\Pilot2_Final- experiment 2 main analysis results 
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\Pilot1_RttMCheck- experiment 1 RttM check analysis results 
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\Pilot2_RttMCheck- experiment 2 RttM check analysis results 
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\Pilot1_LowLevelType1- experiment 1 low level type 1, control analysis results 
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\Pilot2_LowLevelType1- experiment 2 low level type 1, control analysis results
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\RSA\Pilot1_Final- CNN analysis results, main analysis, experiment 1
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\RSA\Pilot2_Final- CNN analysis results, main analysis, experiment 2
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\RSA\Pilot1&2_Final- CNN analysis results, main analysis, experiment 1&2
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\RSA\Pilot1_RttMCheck- CNN analysis results, RttM check analysis, experiment 1
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\RSA\Pilot2_RttMCheck- CNN analysis results, RttM check analysis, experiment 2
FreeViewing\Exp3\Analysis\AnalysisFolders\ResultsStructs\RSA\Pilot1&2_RttMCheck- CNN analysis results, RttM check analysis, experiment 1&2

# data folders
FreeViewing\Exp3\Raw Data\Behavioral\Pilot1 - experimental data struct for each participant in experiment 1
FreeViewing\Exp3\Raw Data\Behavioral\Pilot2 - experimental data struct for each participant in experiment 2
FreeViewing\Exp3\Raw Data\DataPileups\Pilot1 - all variables in the workspace during the experiment, saved in the end of the experiment, for each participant in experiment 1
FreeViewing\Exp3\Raw Data\DataPileups\Pilot2 - all variables in the workspace during the experiment, saved in the end of the experiment, for each participant in experiment 2
FreeViewing\Exp3\Raw Data\EyeTracker\Original EDF files\Pilot1 - edf file for each participant with eye tracking data created by the eye tracker (experiment 1)
FreeViewing\Exp3\Raw Data\EyeTracker\Extracted files\Pilot1 - mat file for each participant with eye tracking data, eta file for each participant used by the analyzer that parsed the data to fixations and saccades (experiment 1) 
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot1\DomRight - parsed data to fixations and saccades for participants with right dominant eye (experiment 1) 
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot1\DomLeft - parsed data to fixations and saccades for participants with left dominant eye (experiment 1)  
FreeViewing\Exp3\Raw Data\EyeTracker\Original EDF files\Pilot2 - edf file for each participant with eye tracking data created by the eye tracker (experiment 2)
FreeViewing\Exp3\Raw Data\EyeTracker\Extracted files\Pilot2 - mat file for each participant with eye tracking data, eta file for each participant used by the analyzer that parsed the data to fixations and saccades (experiment 2) 
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot2\DomRight - parsed data to fixations and saccades for participants with right dominant eye (experiment 2) 
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot2\DomLeft - parsed data to fixations and saccades for participants with left dominant eye (experiment 2)  

############################ Exp 2: The non-Mondrian experiment:

############# Before running download the following Exp2 folders from OSF (https://osf.io/b5ntv/):
a. Locate the Raw Data folder inside FreeViewing\Exp2\
b. Locate the ResultsStructs folder inside FreeViewing\Exp2\Analysis\AnalysisFolders\

############# Running the code:
1. Experimental code:
The experimental code is in:
FreeViewing\Exp2\Experiment\RUN_ME\Code
a. In Run_FV_CFS_NM.m change parameters:
DEBUG_CODE=0; (1 run with debugging, 0 run without debugging)
b. Run the code by running the function: Run_FV_CFS_NM(1) in the command window
Comments:
-Psychtoolbox should be installed to run the code
-To run the code without the eye tracker do not change anything in the Gui
-To run the code with an eye tracker change in the gui: Eye tracking method: eye tracker,
Chose "restart trials on fixation break". 

2. Analysis code:
This code arranges the eye tracking data, and then creates fixation maps for each image, that are used to define 
high-level and High & low regions in the region analysis.
The analysis code is in:
FreeViewing\Exp2\Analysis\Analysis Code\ResultsAnalysis\EyeTrackingAnalysis
- Run the code by running the script: Run.m in the command window
Choose whether to save the results by changing the saveFlag (1 save, 0 do not save).
- Create plot by running the script: Run_Plot.m in the command window

############# Folders content:
# code folders:
FreeViewing\Exp2\Analysis\Analysis Code\ResultsAnalysis\EyeTrackingAnalysis - All analysis code; eye tracking and memory test performance

# experimental code folders:
FreeViewing\Exp2\Experiment\RUN_ME\Code - Experimental code to run the experiment
FreeViewing\Exp2\Experiment\RUN_ME\Stimuli - Stimuli used in the experiment

# fixation maps folder:
FreeViewing\Exp2\Analysis\AnalysisFolders\ResultsImages\FixationMaps- Fixation map for each image from all participants who viewed this image

# results folder:
FreeViewing\Exp2\Analysis\AnalysisFolders\ResultsStructs- Results structs saved from the analysis

# data folders:
FreeViewing\Exp2\Raw Data\Behavioral\Pilot3 - experimental data struct for each participant
FreeViewing\Exp2\Raw Data\DataPileups\Pilot3 - all variables in the workspace during the experiment, saved in the end of the experiment, for each participant
FreeViewing\Exp2\Raw Data\EyeTracker\Original EDF files\Pilot3 - edf file for each participant with eye tracking data created by the eye tracker
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot3 - mat file for each participant with eye tracking data, eta file for each participant used by the analyzer that parsed the data to fixations and saccades. 
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot3\DomRight - parsed data to fixations and saccades for participants with right dominant eye
FreeViewing\Exp2\Raw Data\EyeTracker\Extracted files\Pilot3\DomLeft - parsed data to fixations and saccades for participants with left dominant eye 



