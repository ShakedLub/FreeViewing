# FreeViewing

Preprint: https://doi.org/10.31234/osf.io/x8eaz



# 1.ExpMain: Main experiment

Includes Experiment 1 and Experiment 2 (replication).

All analyses were run on Matlab 2018B, except for the CNN analysis which was conducted on Matlab 2023A.

#### &#x20;

### 1.1. Before running

###### **If you are downloading from OSF:**

a. Download all folders inside 'ExpMain'

b. Unzip the following folders:

1. 'Analysis.zip' 
2. 'Experiment.zip'

3\. 'Raw Data' folder: Inside it unzip 'Behavioral.zip' folder. Inside 'ExpMain\\Raw Data\\DataPileups' folder unzip 'Experiment 1.zip' and 'Experiment 2.zip' folders. Inside 'ExpMain\\Raw Data\\EyeTracker' unzip 'Original EDF files.zip' folder. Inside 'ExpMain\\Raw Data\\EyeTracker\\Extracted files' folder unzip 'Experiment 1.zip' and 'Experiment 2.zip' folders. Locate the 'Raw Data' folder inside 'FreeViewing\\ExpMain'.

4\. ResultsStructs folder: Inside it unzip 'Experiment1ResultsStructs.zip' folder, 'Experiment2ResultsStructs.zip' folder and 'MoreResultsStructs.zip' folder. All the data (files and folders) inside these 3 folders put together in 'ResultsStructs' folder (without the partition to 3 folders), and Locate the 'ResultsStructs' folder inside 'FreeViewing\\ExpMain\\Analysis\\AnalysisFolders'.

&#x20;



###### **If you are downloading from GitHub:**

a. Download the code from GitHub.

b. Download from OSF (https:/osf.io/b5ntv/) from 'ExpMain' folder:

1\. 'Raw Data' folder: Inside it unzip 'Behavioral.zip' folder. Inside 'ExpMain\\Raw Data\\DataPileups' folder unzip 'Experiment 1.zip' and 'Experiment 2.zip' folders. Inside 'ExpMain\\Raw Data\\EyeTracker' unzip 'Original EDF files.zip' folder. Inside 'ExpMain\\Raw Data\\EyeTracker\\Extracted files' folder unzip 'Experiment 1.zip' and 'Experiment 2.zip' folders. Locate the 'Raw Data' folder inside 'FreeViewing\\ExpMain'.

2\. ResultsStructs folder: Inside it unzip 'Experiment1ResultsStructs.zip' folder, 'Experiment2ResultsStructs.zip' folder and 'MoreResultsStructs.zip' folder. All the data (files and folders) inside these 3 folders put together in 'ResultsStructs' folder (without the partition to 3 folders), and Locate the 'ResultsStructs' folder inside 'FreeViewing\\ExpMain\\Analysis\\AnalysisFolders'.



### 1.2. Experimental code:

###### Location:

FreeViewing\\ExpMain\\Experiment\\RUN\_ME\\Code

###### Running the code:

a. Run Run\_BuildImageOrder() in the command window, in order to create ExpDesignAllSubjects.mat that has
trial randomization for all participants in advance.

b. In Run\_FV\_CFS.m change parameters:

DEBUG\_CODE=0; (1 run with debugging, 0 run without debugging)

WANTED\_FPS=100; %Hz (change according to your screens refresh rate)

c. Run the code by running the function: Run\_FV\_CFS(1) in the command window.

###### Comments:

\-Psychtoolbox should be installed to run the code

\-To run the code without the eye tracker do not change anything in the GUI

\-To run the code with an eye tracker change in the GUI: Eye tracking method: eye tracker, Choose "restart trials on fixation break".

&#x20;

### 1.3. Analysis code:

### 1.3.1. Eye tracking analysis

This analysis arranges the eye tracking data, and then calculates the object analysis, region analysis and emotional face attribute analysis.

###### Location:

FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\EyeTrackingAnalysis

###### Running the code:

Run\_analysis\_images.m in the command window

###### Conditions:

(a) saveFlag: 0 do not save, 1 save

(b) experiment\_number: '1' for experiment 1, '2' for experiment 2 (this number should be given as a char)

(c) condition:

1 - main analysis

2 - preregistration check: this control analysis is done because we applied some deviations from the preregistration. This analysis is without these changes: (1) In the main analysis low level type 2 regions are used (created using smiler package), in this analysis low level type 1 regions are used(created using the saliencytoolbox). (2) In this analysis trials 	with blinks are excluded, in the main analysis they are included. (3) In this analysis objects are defined only based on the 	OSIE database. In the main analysis objects are defined based on a combination of OSIE and Broda and de Haas's database. (4) Two images that were excluded from the main analysis, are included here.

3 - RttM check: in this control analysis, participants with high objective awareness scores are excluded to check if the results stem from RttM (see manuscript).

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



### 1.3.2. CNN analysis

This analysis calculates the RSA analysis, comparing fixation maps in both visibility conditions to the activations of the CNN.

###### Location:

FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\CNNAnalysis

###### Running the code:

Run.m in the command window

###### Conditions:

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



### 1.3.3. Behavioral analysis

This analysis checks awareness scores of all participants, calculates group level awareness, and save tables of the data.

###### Location:

FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\BehavioralAnalysis

###### Running the code:

Run\_AnalyzeBehavior.m in the command window

###### Conditions:

(a) saveFlag: 0 do not save, 1 save

(b) experiment\_number: '1' for experiment 1, '2' for experiment 2 (this number should be given as a char)

###### More analyses:

* Bayesian analysis:

Inside the folder BayesianAnalysis the Bayesian analysis calculations in JASP can be found.

* GBC, GB-Bayes and Bayesian parameter estimation analyses:

a. Open the R project AnalysisR.Rproj

b. GBC and GBBayes tests: Running the code: (a) Run GBC.R (b) then GBBayes.R (C) and finally GBCGBBayesScript.R

c. Bayesian parameter estimation analysis: Running the code: Run BayesianParameterEstimationScript.R



### 1.3.4. Analyses on both experiments

###### Location:

FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ResultsAnalysis\\EyeTrackingAnalysis\\PlotsBothExperiments

**1.3.4.1.** **Run\_AwarenessResultsExperiments.m** - creates the awareness results figure.

Conditions:
(a) saveFlag- 1 save, 0 do not save



**1.3.4.2.** **Run\_AwarenessResultsBPE.m** - creates the Bayesian parameter estimation awareness results figure.

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.3.** **Run\_EyeMovementResultsExperiments.m** - create the object analysis, region analysis and emotional face attribute analysis results figures, and create tables summarizing effect sizes and p-values for all conditions except for the main condition.

Conditions:(a) AnalysisType-

1 main analysis

2 low level type 1 analysis

3 RttM check analysis

4 permutation check

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



**1.3.4.4.** **Run\_CNNResults.m** - create the CNN results figures, and create tables summarizing effect sizes and p-values for all conditions except the main condition.

Conditions:

(a) AnalysisType-

1 - main analysis

3 - RttM check analysis

More analyses for revision:

5 - conscious trials from unconscious and conscious sessions

89 - fig 1 only right dominant eye participants included from both experiments. fig 2 only left dominant eye participants included from both experiments

1112 - fig 1 downsample number of trials according to the smaller visibility condition for each participant from both experiments. fig 2: downsample number of trials according to the smaller visibility condition for each image from both experiments

13 - free viewing data without a mask and conscious condition from both experiments

(b)saveFlag- 1 save, 0 do not save



**1.3.4.5.** **Run\_SaccadeRateTraceAnalysis.m** - calculate saccade trace and checks for significance for each experiment separately.

Conditions:
(a) saveFlag- 1 save, 0 do not save



**1.3.4.6.** **Run\_SaccadeRateTracePlots.m** - plot the saccade rate trace and creates data table for this analysis

Conditions:

(a) saveFlag- 1 save, 0 do not save

(b) permutationType- 1- shuffling two conditions that are compare, 2- shuffling fixations between images



**1.3.4.7.** **Run\_TreeBHAllExperimentsWithCNN.m** - calculate tree BH for all analyses in the manuscript and create tables summarizing effect sizes and p-values for the main condition.

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.8.** **Run\_ObjectClassificationPlots.m** - creates the object segmentation demonstration figures.

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.9.** **Run\_RegionClassificationPlots.m** - creates the region segmentation demonstration figures.

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.10.** **Run\_ObjectRegionCombinedMap**.m - creates object and region segmentation demonstration figures.

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.11.** **Run\_CompareImagevsControlTrialsExperiement1**.m - conducts an analysis comparing image trials to control trials (shuffled images) in both visibility conditions, this is done only on Experiment 1

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.12.** **Run\_CompareImagevsControlTrialsExperiement1\_CreatePlot.m** - creates a figure for the analysis in (11).

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.13.** **Run\_DispersionNSSPlotsExperiment1.m** - creates a figure for dispersion and NSS similarity results in Experiment 1.

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.14.** **Run\_HistogramFixationCLassificationOverlap.m** - plot a histogram of the overlap between the circle surrounding the fixations and the classified region for all fixations

Conditions:(a) saveFlag- 1 save, 0 do not save



**1.3.4.15. Run\_BackgroundRegions.m** - check if background regions are viewed below chance in the region analysis and objects analysis



### 1.3.5. Image analysis

This code creates the high level region and low level region maps for the region analysis for all images.

###### Location:

FreeViewing\\ExpMain\\Analysis\\AnalysisCode\\ImageAnalysis

**1.3.5.1.** **Run\_CreateHighLevelMaps.m** - creates high level maps that define the high level regions in the region analysis.

Conditions:

condition = 1 creates high level maps for the main analysis with the combined objects database.

condition = 2 creates high level maps for the preregistration control with OSIE objects only, and non Mondrian fixation maps 	without blinks.

**1.3.5.2.** **Run\_CreateLowLevelMaps2.m** - creates low level maps type 2 that define the low level regions in the region analysis. The maps are created based on Itti \& Koch's saliency model from Smiler. These maps are used in the main analysis.

**1.3.5.3.** **Run\_CreateLowLevelMaps1.m** - creates low level maps type 1 that define the low level regions in the region analysis. The maps are created based on Itti \& Koch's saliency model from saliencytoolbox. These maps are used in low level type 1 analysis.

#### 

### 1.4. Data about packages and codes downloaded from the internet:

###### Location:

FreeViewing\\ExpMain\\Analysis\\AnalysisFolders\\Code

**1.4.1. breakxaxis**
code for creating a break in the x axis in a plot for better visualization.

Peter, Break X Axis . MATLAB Central File Exchange (2024).
https://www.mathworks.com/matlabcentral/fileexchange/42905-break-x-axis.

**1.4.2.** **Itti\&Koch\_WalthersSaliencyToolbox\_L**
Sailencytoolbox used to create low level regions for the region analysis in low level type 1 control analysis, based on Itti\&Koch's saliency model. Version 2.3 is used.

D. Walther, C. Koch, Modeling attention to salient proto-objects. Neural Networks 19,  1395–1407 (2006).

**1.4.3. myBinomTest**
code for calculating a binomial test, used to test the accuracy in the objective awareness test with a binomial distribution.

Matthew Nelson, myBinomTest(s,n,p,Sided). MATLAB Central File Exchange (2022). https://www.mathworks.com/matlabcentral/fileexchange/24813-mybinomtest-s-n-p-sided.

**1.4.4. RainCloudPlot**
code for creating rain cloud plots.

M. Allen, D. Poggiali, K. Whitaker, T. R. Marshall, J. van Langen, R. A. Kievit, Raincloud plots: a multi-platform tool for robust data visualization. Wellcome Open Res 4 (2021).

In addition to downloading the rain cloud plots code, the following codes were also downloaded, and located in tutorial\_matlab folder:

a. cbrewer: colorbrewer schemes for matlab

from: https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer-colorbrewer-schemes-for-matlab

b. Robust\_Statistical\_Toolbox

from: https://github.com/CPernet/Robust\_Statistical\_Toolbox

Inside the folder tutorial\_matlab I added the following codes (based on existing codes): raincloud\_plot\_big\_circles.m, rm\_raincloud\_dots\_different\_sizes.m, rm\_raincloud\_dots\_different\_sizes\_two\_groups.m

**1.4.5. Smiler**

toolbox used to create low level regions for the region analysis in the main analysis, based on Itti\&Koch's saliency model.

C. Wloka, T. Kunić, I. Kotseruba, R. Fahimi, N. Frosst, N. D. B. Bruce, J. K. Tsotsos, SMILER: Saliency Model Implementation Library for Experimental Research. arXiv Prepr, doi: https://doi.org/10.48550/arXiv.1812.08848 (2018).

**1.4.6. TreeBH**

tree BH method for correcting for multiple comparisons in all the manuscript. This code is an in-house code used in Mudrik's lab.

**1.4.7.stdshade**

code for creating std shade in plots Simon Musall (2026). stdshade (https://www.mathworks.com/matlabcentral/fileexchange/29534-stdshade), MATLAB Central File Exchange. Retrieved April 5, 2026.



# 2\. Non-Mondrian experiment

All analyses were run on Matlab 2018B

### 2.1. Before running

###### **If you are downloading from OSF:**

a. Download all folders inside 'ExpNoMondrian' folder:

b. Unzip the following folders:

1. 'Analysis.zip'

2\. 'Experiment.zip'

3\. 'Raw Data' folder: Inside it unzip 'Behavioral.zip','DataPileups.zip' and 'EyeTracker.zip' folders. Locate the 'Raw Data' folder inside 'FreeViewing\\ExpNoMondrian'.

4\. Unzip 'ResultsStructs' folder. Locate it in 'FreeViewing\\ExpNoMondrian\\Analysis\\AnalysisFolders'.



###### **If you are downloading from GitHub:**

a. Download the code from GitHub.

b. Download from OSF (https:/osf.io/b5ntv/) from 'ExpNoMondrian' folder:

1. 'Raw Data' folder: Inside it unzip 'Behavioral.zip','DataPileups.zip' and 'EyeTracker.zip' folders. Locate the 'Raw Data' folder inside 'FreeViewing\\ExpNoMondrian'.

2\. Unzip 'ResultsStructs' folder. Locate it in 'FreeViewing\\ExpNoMondrian\\Analysis\\AnalysisFolders'.

&#x20;



### 2.2. Experimental code:

###### Location:

FreeViewing\\ExpNoMondrian\\Experiment\\RUN\_ME\\Code

###### Running the code:

a. In Run\_FV\_CFS\_NM.m change parameters:
DEBUG\_CODE=0; (1 run with debugging, 0 run without debugging)

b. Run the code by running the function: Run\_FV\_CFS\_NM(1) in the command window.

###### Comments:

\-Psychtoolbox should be installed to run the code
-To run the code without the eye tracker do not change anything in the Gui
-To run the code with an eye tracker change in the gui: Eye tracking method: eye tracker, Chose "restart trials on fixation break".



### 2.3. Analysis code:

This code arranges the eye tracking data, and then creates fixation maps for each image, that are used to define high-level and High \& low regions in the region analysis. This code is also used to create fixation data for free viewing analysis.

###### Location:

FreeViewing\\ExpNoMondrian\\Analysis\\Analysis Code\\ResultsAnalysis\\EyeTrackingAnalysis

###### Running the code:

a. Run the code by running the script: Run.m in the command window

Conditions:

(a) saveFlag (1 save, 0 do not save).

(b) condition (1 : main analysis, 2: preregistration control, 3: data for free viewing analysis, without fixations in center)

b. Create plot by running the script: Run\_Plot.m in the command window



### 3\. Order of running all analyses (creating all results structs and fixation maps):

(1) Run Run\_AnalyzeBehavior.m in BehavioralAnalysis in ExpMain folder.

(2) Run Run.m in EyeTrackingAnalysis in ExpNoMondrian folder, one time for each condition (1 main analysis, 2 preregistration check, 3 free viewing analysis), to create fixation maps for each image from the data of the experiment without Mondrians. These fixation maps are used to define high-level and High \& low regions in the region analysis. Condition 3 is for the free viewing analysis.

(3) Create region maps in ImageAnalysis in ExpMain folder (the order of creating the regions is important):

a. create low level regions type 1: Run\_CreateLowLevelMaps1.m

b. create high level regions: Run\_CreateHighLevelMaps.m one time for each condition (1 main analysis, 2 preregistration check)

c. create low level regions type 2: Run\_CreateLowLevelMaps2.m

(4) Run Run\_analysis\_images.m in EyeTrackingAnalysis in ExpMain folder, with the wanted condition  (1 main analysis, 2 preregistration check, 3 RttM check, 4 permutation check and so on), to run the region and object analysis.

(5) Run Run.m in CNNAnalysis in ExpMain folder, with the wanted condition (1 main analysis, 3 RttM check and so on), to run the CNN analysis.

(6) Run Run\_TreeBHAllExperimentsWithCNN.m in PlotsBothExperiments in EyeTrackingAnalysis in ExpMain to create tree for pvalue correction.

(7) All other analyses in PlotsBothExperiments depend on all the data created above.

(8) Awareness analyses in R are based on tables created in step (1).

