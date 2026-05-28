# FreeViewing

Preprint: https://doi.org/10.31234/osf.io/x8eaz



#### ExpMain: Main experiment, includes Experiment 1 and Experiment 2 (replication)

#### &#x20;

#### &#x20;Before running

&#x20;
If you are downloading the code from GitHub download the following ExpMain folders from OSF (https:/osf.io/b5ntv/)

&#x20; (if you are downloading everything from OSF skip this part):
a. Locate the Raw Data folder inside FreeViewing\\ExpMain  
b. Locate the ResultsStructs folder inside FreeViewing\\ExpMain\\Analysis\\AnalysisFolders\\

#### 

#### &#x20; Running the code:

&#x20; All analyses were run on Matlab 2018B, except for the CNN analysis which was conducted on Matlab 2023A.



#### &#x20; Experimental code:

&#x20; The experimental code can be found in:
FreeViewing\\ExpMain\\Experiment\\RUN\_ME\\Code
a. Run Run\_BuildImageOrder() in the command window, in order to create ExpDesignAllSubjects.mat that has
trial randomization for all participants in advance.
b. In Run\_FV\_CFS.m change parameters:
DEBUG\_CODE=0; (1 run with debugging, 0 run without debugging)
WANTED\_FPS=100; %Hz (change according to your screens refresh rate)
c. Run the code by running the function: Run\_FV\_CFS(1) in the command window.
Comments:
-Psychtoolbox should be installed to run the code
-To run the code without the eye tracker do not change anything in the GUI
-To run the code with an eye tracker change in the GUI: Eye tracking method: eye tracker,
Choose "restart trials on fixation break".

&#x20;

#### &#x20; Analysis code:

##### Eye tracking analysis

This analysis arranges the eye tracking data, and then calculates the object analysis, region analysis and
emotional face attribute analysis.
Location: FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\EyeTrackingAnalysis
Run the code by running the script: Run\_analysis\_images.m in the command window
Conditions:
(a) saveFlag: 0 do not save, 1 save
(b) experiment\_number: '1' for experiment 1, '2' for experiment 2 (this number should be given as a char)
(c) condition:
1 - main analysis
2 - preregistration check: this control analysis is done because we applied some deviations fron the preregistration.
This analysis is without these changes: (1) In the main analysis low level type 2 regions are used (created using smiler 	package), in this analysis low level type 1 regions are used(created using the saliencytoolbox). (2) In this analysis trials 	with blinks are excluded, in the main analysis they are included. (3) In this analysis objects are defined only based on the 	OSIE database. In the main analysis objects are defined based on a combination of OSIE and Broda and de Haas's database. (4) 	Two images that were excluded from the main analysis, are included here.
3 - RttM check: in this control analysis, participants with high objective awareness scores are excluded to check if the 	results stem from RttM (see manuscript).
4 - Permutation check: this permutation check maintains the trial's viewing sequence, and randomize fixations between images.
Therefore this analysis takes into account that participants fixations have a clustered viewing structure.
More analyses for revision:
5 - conscious trials from unconscious and conscious sessions
6 - only right dominant eye participants included
7 - only left dominant eye participants included
8 - only right dominant eye participants included, both experiments analyzed together
9 - only left dominant eye participants included, both experiments analyzed together
10 - jackknife analysis
11 - downsample number of trials according to the smaller visibility condition for each participant
12 - downsample number of trials according to the smaller visibility condition for each image
13 - free viewing data without a mask
14 - pixel based classification to objects
15 - first saccade analysis
16 - create table for control analysis with mixed effects model
17 - classification to objects based on 50% overlap and above
18 - calculate percent overlap between object classified and circle around fixation

19 - check power of 14 participants with right dominant eye, by sampling randomly 14 participants from this group from both experiments

20 - create data of control (shuffled) trials for analysis done only for Experiment 1



##### CNN analysis

This analysis calculates the RSA analysis, comparing fixation maps in both visibility conditions to the activations of the CNN.
Location: FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\CNNAnalysis
Run the code by running the script: Run.m in the command window
Conditions:
(a) saveFlag: 0 do not save, 1 save
(b) experiment\_number: '1' for experiment 1, '2' for experiment 2, '12' for combined data from
experiment 1 and 2 (this number should be given as a char)
(c) condition:
1 - main analysis  
3 - RttM check: control analysis see explanation above.
More analyses for revision (run on both experiments together):
5 - conscious trials from unconscious and conscious sessions
8 - only right dominant eye participants included
9 - only left dominant eye participants included
10 - jackknife analysis
11 - downsample number of trials according to the smaller visibility condition for each participant
12 - downsample number of trials according to the smaller visibility condition for each image
13 - compares conscious condition to free viewing data without a mask



##### Behavioral analysis

This analysis checks awareness scores of all participants, calculates group level awareness, and save tables of the data.
Location: FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\BehavioralAnalysis
Run the code by running the script: Run\_AnalyzeBehavior.m in the command window
Conditions:
(a) saveFlag: 0 do not save, 1 save
(b) experiment\_number: '1' for experiment 1, '2' for experiment 2 (this number should be given as a char)

* Inside the folder BayesianAnalysis there are calculations in JASP of the Bayesian analysis
* Inside the folder AnalysisR there is:
(1) Code for running GBC and GBBayes tests on the behavioral data.
Run: (a) GBC.R (b) then GBBayes.R (C) and finally GBCGBBayesScript.R
(2) Code for running Bayesian parameter estimation analysis BayesianParameterEstimationScript.R



##### Analyses on both experiments

Create plots, calculate tree BH, saccadic rate analysis and other analysis described below.
Location: FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\EyeTrackingAnalysis\\PlotsBothExperiments

(1) Run\_AwarenessResultsExperiments.m - creates the awareness results figure.
Conditions:
(a) saveFlag- 1 save, 0 do not save



(2) Run\_AwarenessResultsBPE.m - creates the Bayesian parameter estimation awareness results figure.
Conditions:
(a) saveFlag- 1 save, 0 do not save



(3) Run\_EyeMovementResultsExperiments.m - create the object analysis, region analysis and emotional face attribute analysis results figures, and
create tables summarizing effect sizes and p-values for all conditions except the main condition.
Conditions:
(a) AnalysisType- 1 main analysis, 2 low level type 1 analysis, 3 RttM check analysis, 4 permutation check
More analyses for revision:
5 - conscious trials from unconscious and conscious sessions
89 - analysis of exp 1\&2 8 right participants, 9 left participants (instead of experiment in the rows, it is dominant eye)
11 - downsample number of trials according to the smaller visibility condition for each participant
12 - downsample number of trials according to the smaller visibility condition for each image
13 - free viewing data without a mask and conscious condition
14 - pixel based classification to objects and regions
15 - first saccade analysis
17 - classification to objects and regions based on 50% overlap and above
(b) saveFlag- 1 save, 0 do not save



(4) Run\_CNNResults.m - create the CNN results figures, and create tables summarizing effect sizes and p-values for all conditions except the main condition.
Conditions:
(a) AnalysisType-
1 - main analysis
3 - RttM check analysis
More analyses for revision:
5 - conscious trials from unconscious and conscious sessions
89 - fig 1 only right dominant eye participants included from both experiments
fig 2 only left dominant eye participants included from both experiments
1112 - fig 1 downsample number of trials according to the smaller visibility condition for each participant from both 	experiments
fig 2: downsample number of trials according to the smaller visibility condition for each image from both experiments
13 - free viewing data without a mask and conscious condition from both experiments
(b)saveFlag- 1 save, 0 do not save



(5) Run\_SaccadeRateTraceAnalysis.m - calculate saccade trace and checks for significance for each experiment separately
Conditions:
(a) saveFlag- 1 save, 0 do not save



(6) Run\_SaccadeRateTracePlots.m - plot the saccade rate trace and creates data table for this analysis
Conditions:
(a) saveFlag- 1 save, 0 do not save

(b) permutationType- 1- shuffling two conditions that are compare, 2- shuffling fixations between images



(7) Run\_TreeBHAllExperimentsWithCNN.m - calculate tree BH for all analyses in the manuscript and create tables summarizing effect sizes and p-values for the main condition (1).
Conditions:
(b) saveFlag- 1 save, 0 do not save



(8) Run\_ObjectClassificationPlots.m - creates the object segmentation demonstration figures.
Conditions:
(a) saveFlag- 1 save, 0 do not save



(9) Run\_RegionClassificationPlots.m - creates the region segmentation demonstration figures.
Conditions:
(a) saveFlag- 1 save, 0 do not save



(10) Run\_ObjectRegionCombinedMap: creates object and region segmentation demonstration figures.

Conditions:
(a) saveFlag- 1 save, 0 do not save



(11) Run\_CompareImagevsControlTrialsExperiement1 - conducts an analysis comparing image trials to control trials (shuffled images) in both visibility conditions, this is done only on Experiment 1

Conditions:
(a) saveFlag- 1 save, 0 do not save



(12) Run\_CompareImagevsControlTrialsExperiement1\_CreatePlot - creates a figure for the analysis in (11).

Conditions:
(a) saveFlag- 1 save, 0 do not save



(13) Run\_DispersionNSSPlotsExperiment1 - creates a figure for dispersion and NSS similarity results in Experiment 1.

Conditions:
(a) saveFlag- 1 save, 0 do not save



(14) Run\_HistogramFixationCLassificationOverlap.m - plot a histogram of the overlap between the circle surrounding the fixations and the classified region for all fixations
Conditions:
(a) saveFlag- 1 save, 0 do not save



(15) Run\_BackgroundRegions: check if background regions are viewed below chance in the region analysis and objects analysis



##### Image analysis

This code creates the high level region and low level region maps for the region analysis for all images.
Location: FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ImageAnalysis

(A) Run\_CreateHighLevelMaps.m - creates high level maps that define the semantically salient regions
(high level regions) in the region analysis.
Conditions:
condition = 1 creates high level maps for the main analysis with the combined objects database.
condition = 2 creates high level maps for the preregistration control with OSIE objects only, and non Mondrian fixation maps 	without blinks.

(B) Run\_CreateLowLevelMaps2.m - creates low level maps type 2 that define the visually salient regions
(low level regions) in the region analysis. The maps are created based on
Itti \& Koch's saliency model from Smiler. These maps are used in the main
analysis.

(C) Run\_CreateLowLevelMaps1.m - creates low level maps type 1 that define the visually salient regions
(low level regions) in the region analysis. The maps are created based on
Itti \& Koch's saliency model from saliencytoolbox. These maps are used in
low level type 1 analysis.

#### 

##### Data about packages and codes downloaded from the internet:

Location: FreeViewing\\ExpMain\\Analysis\\AnalysisFolders\\Code

**#breakxaxis**
code for creating a break in the x axis in a plot for better visualization.
Peter, Break X Axis . MATLAB Central File Exchange (2024).
https://www.mathworks.com/matlabcentral/fileexchange/42905-break-x-axis.

**#Itti\&Koch\_WalthersSaliencyToolbox\_L**
Sailencytoolbox used to create low level regions for the region analysis in low level type 1 control analysis, based on Itti\&Koch's saliency 	model.
Version 2.3 is used.
D. Walther, C. Koch, Modeling attention to salient proto-objects. Neural Networks 19,  1395–1407 (2006).

**#myBinomTest**
code for calculating a binomial test, used to test the accuracy in the objective awareness test with a binomial distribution.
Matthew Nelson, myBinomTest(s,n,p,Sided) . MATLAB Central File Exchange (2022). 	https://www.mathworks.com/matlabcentral/fileexchange/24813-	mybinomtest-s-n-p-sided.

**#RainCloudPlot**
code for creating rain cloud plots
M. Allen, D. Poggiali, K. Whitaker, T. R. Marshall, J. van Langen, R. A. Kievit, Raincloud plots: a multi-platform tool for 	robust data 	visualization. Wellcome Open Res 4 (2021).

In addition to downloading the rain cloud plots code, the following codes were also downloaded, and located in tutorial\_matlab 	folder:
a. cbrewer: colorbrewer schemes for matlab
from: https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab
b. Robust\_Statistical\_Toolbox
from: https://github.com/CPernet/Robust\_Statistical\_Toolbox

Inside the folder tutorial\_matlab I added the following codes: (based on existing codes)

1. raincloud\_plot\_big\_circles.m
2. rm\_raincloud\_dots\_different\_sizes.m

**#Smiler**
toolbox used to create low level regions for the region analysis in the main analysis, based on Itti\&Koch's saliency model.
C. Wloka, T. Kunić, I. Kotseruba, R. Fahimi, N. Frosst, N. D. B. Bruce, J. K. Tsotsos, SMILER: Saliency Model Implementation 	Library for 	Experimental Research. arXiv Prepr, doi: https://doi.org/10.48550/arXiv.1812.08848 (2018).

**#TreeBH**
tree BH method for correcting for multiple comparisons in all the manuscript.
This code is an in-house code used in Mudrik's lab.

**#stdshade**
code for creating std shade in plots Simon Musall (2026). stdshade (https://www.mathworks.com/matlabcentral/fileexchange/29534-stdshade), MATLAB Central File Exchange. Retrieved April 5, 2026.



#### Non-Mondrian experiment



#### Before running

If you are downloading the code from GitHub download the following ExpNoMondrian folders from OSF (https://osf.io/b5ntv/):

(if you are downloading everything from OSF skip this part):
a. Locate the Raw Data folder inside FreeViewing\\ExpNoMondrian  
b. Locate the ResultsStructs folder inside FreeViewing\\ExpNoMondrian\\Analysis\\AnalysisFolders\\



#### Running the code:

All analyses were run on Matlab 2018B

##### &#x20;

#### &#x20;Experimental code:

&#x20; Location: FreeViewing\\ExpNoMondrian\\Experiment\\RUN\_ME\\Code
a. In Run\_FV\_CFS\_NM.m change parameters:
DEBUG\_CODE=0; (1 run with debugging, 0 run without debugging)
b. Run the code by running the function: Run\_FV\_CFS\_NM(1) in the command window Comments:
-Psychtoolbox should be installed to run the code
-To run the code without the eye tracker do not change anything in the Gui
-To run the code with an eye tracker change in the gui: Eye tracking method: eye tracker,
Chose "restart trials on fixation break".



#### &#x20;Analysis code:

&#x20; This code arranges the eye tracking data, and then creates fixation maps for each image, that are used to define
high-level and High \& low regions in the region analysis.
This code is also used to create fixation data for free viewing analysis.

Location: FreeViewing\\ExpNoMondrian\\Analysis\\Analysis Code\\ResultsAnalysis\\EyeTrackingAnalysis

a. Run the code by running the script: Run.m in the command window

Conditions:
(a) saveFlag (1 save, 0 do not save).
(b) condition (1 : main analysis, 2: preregistration control, 3: data for free viewing analysis, without fixations in center)

b. Create plot by running the script: Run\_Plot.m in the command window



#### Order of running all analyses (creating all results structs and fixation maps):

(1) Run Run\_AnalyzeBehavior.m in BehavioralAnalysis in ExpMain folder.
(2) Run Run.m in EyeTrackingAnalysis in ExpNoMondrian folder, one time for each condition (1 main analysis, 2 preregistration check, 3 free viewing analysis), to create fixation maps for each image from the data of the experiment without Mondrians. These fixation maps are used to define high-level and High \& low regions in the region analysis. Condition 3 is for the free viewing analysis.
(3) Create region maps in ImageAnalysis in ExpMain folder (the order of creating the regions is important):
create low level regions type 1: Run\_CreateLowLevelMaps1.m
create high level regions: Run\_CreateHighLevelMaps.m one time for each condition (1 main analysis, 2 preregistration check)
create low level regions type 2: Run\_CreateLowLevelMaps2.m
(4) Run Run\_analysis\_images.m in EyeTrackingAnalysis in ExpMain folder, with the wanted condition  (1 main analysis, 2 preregistration check, 3 RttM check,   4 permutation check and so on), to run the region and object analysis.
(5) Run Run.m in CNNAnalysis in ExpMain folder, with the wanted condition (1 main analysis, 3 RttM check and so on), to run the CNN analysis.
(6) Run Run\_TreeBHAllExperimentsWithCNN.m in PlotsBothExperiments in EyeTrackingAnalysis in ExpMain to create tree for pvalue correction.
(7) All other analyses in PlotsBothExperiments depend on all the data created above.
(8) Awareness analyses in R are based on tables created in step (1).

