% This script run tree BH and create tables summarizing effect sizes and
% p-values.

clear
clc
close all

%% Paramaters
saveFlag=1; %1 save, 0 do not save

ParamTree.plot_tree=1;
ParamTree.interactive_plot=0;
ParamTree.recalculate_p=0;
ParamTree.alpha_level=0.05;

EFAtt=3; %emotional face attribute number

%% paths
ending='_Final';

codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
pathTree=[foldersPath,'\Code\TreeBH'];
cd(codePath)

path1=[dataPath,'\Experiment1',ending];
path2=[dataPath,'\Experiment2',ending];
pathControl1=[dataPath,'\Experiment1_ControlTrials'];
pathSaveResults=dataPath;

%% load data
%load regions
load([path1,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsResults1=RegionsSummary;
clear RegionsSummary
load([path2,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsResults2=RegionsSummary;
clear RegionsSummary

%load objects
load([path1,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsResults1=ObjectsSummary;
load([path1,'\','AttributesSummary_RemoveCenterBias.mat']);
AttributesResults1=AttributesSummary;
clear AttributesSummary ObjectsSummary

%load attributes
load([path2,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsResults2=ObjectsSummary;
load([path2,'\','AttributesSummary_RemoveCenterBias.mat']);
AttributesResults2=AttributesSummary;
clear AttributesSummary ObjectsSummary

%load more analysis for experiment 1
load([pathControl1,'\','ResultsControlVsImageTrials_RemoveCenterBias.mat']);

load([path1,'\','NSSSimilarity_RemoveCenterBias.mat']);

load([path1,'\','DispersionResults_RemoveCenterBias.mat']);

%load saccadic rate results
load([path1,'\','ResultsPermShuffledTrails_Objects1.mat']);
load([path2,'\','ResultsPermShuffledTrails_Objects2.mat']);

%load CNN
path1=[dataPath,'\RSA\Experiment1_Final'];
path2=[dataPath,'\RSA\Experiment2_Final'];
path12=[dataPath,'\RSA\Experiment12_Final'];

load([path1,'\','Results_RemoveCenterBias.mat']);
CNNResults1=Results;
clear Results

load([path2,'\','Results_RemoveCenterBias.mat']);
CNNResults2=Results;
clear Results

load([path12,'\','Results_RemoveCenterBias.mat']);
CNNResults12=Results;
clear Results

%% Experiment 2 preregistered image analysis tree
%Create pvalues data
nodes_vec =   [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46];
parents_vec	= [1 1 1 2 2 3 3 4  4  5  5  6  6  7  7  8  8  9  9 10 10 11 11 11 11 12 12 12 12 13 13 13 13 14 14 14 14 15 15 16 16 17 17 18 18];

node_names = [{'Image analysis','Regions','Objects','Emotinal Face'},...
    {'FPP R','FDPP R','FPP O','FDPP O','FPP E','FDPP E'},...
    {'U FPP R','C FPP R','U FDPP R','C FDPP R','U FPP O','C FPP O','U FDPP O','C FDPP O','U FPP E','C FPP E','U FDPP E','C FDPP E'},...
    {'L U FPP R','H U FPP R','L&H U FPP R','Bg U FPP R','L C FPP R','H C FPP R','L&H C FPP R','Bg C FPP R','L U FDPP R','H U FDPP R','L&H U FDPP R','Bg U FDPP R','L C FDPP R','H C FDPP R','L&H C FDPP R','Bg C FDPP R'},...
    {'Obj U FPP O','Bg U FPP O','Obj C FPP O','Bg C FPP O','Obj U FDPP O','Bg U FDPP O','Obj C FDPP O','Bg C FDPP O'}];

node_p_values_2=createPvalueVecExp2(RegionsResults2,ObjectsResults2,AttributesResults2,EFAtt);

w=cd(pathTree);
G2ImageAnalysis = createtree(parents_vec,node_names,node_p_values_2);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G2ImageAnalysis,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Experiment 2 preregistered image analysis tree')
cd(w);

%% CNN analysis trees
G1CNN=createCNNTree(CNNResults1,pathTree,1,ParamTree,'oneExp');
G2CNN=createCNNTree(CNNResults2,pathTree,2,ParamTree,'oneExp');
G12CNN=createCNNTree(CNNResults12,pathTree,3,ParamTree,'mergedExp');

%% Experiment 1 preregistered analysis
%Create pvalues data
nodes_vec =   [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55];
parents_vec	= [1 1 1 2 5 5 6 6  7  7  3  3  3  3  3  3  4  4 12 12 12 13 13 13 14 14 14 15 15 15 16 16 16 17 17 17 18 18 8  8  8  8  9  9  9  9  10 10 10 10 11 11 11 11];

node_names = [{'Preregistered','Image analysis','Image vs control','Gaze patterns','Regions'},...
    {'FPP R','FDPP R','U FPP R','C FPP R','U FDPP R','C FDPP R'},...
    {'numFix','durationFix','stddurationFix','numSacc','ampSacc','stdampSacc','Dispersion','NSS Similarity'},...
    {'numFix P1','numFix P2','numFix P12','durationFix P1','durationFix P2','durationFix P12','stddurationFix P1','stddurationFix P2','stddurationFix P12','numSacc P1','numSacc P2','numSacc P12','ampSacc P1','ampSacc P2','ampSacc P12','stdampSacc P1','stdampSacc P2','stdampSacc P12'},...
    {'vertical dispersion','horizontal dispersion'},...
    {'L U FPP R','H U FPP R','L&H U FPP R','Bg U FPP R','L C FPP R','H C FPP R','L&H C FPP R','Bg C FPP R','L U FDPP R','H U FDPP R','L&H U FDPP R','Bg U FDPP R','L C FDPP R','H C FDPP R','L&H C FDPP R','Bg C FDPP R'}];

node_p_values_1=createPvalueVecExp1Pre(RegionsResults1,ResultsControlVsImageTrials,NSSSimilarity,DispersionResults);

w=cd(pathTree);
G1Preregistered = createtree(parents_vec,node_names,node_p_values_1);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G1Preregistered,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Experiment 1 preregistered tree')
cd(w);

%% Experiment 1 exploratory analysis
%Create pvalues data
nodes_vec =   [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23];
parents_vec	= [1 1 2 2 3 3 4 4  5  5  6  6  7  7  8  8  9  9 10 10 11 11];

node_names = [{'Image analysis','Objects','Emotinal Face'},...
    {'FPP O','FDPP O','FPP E','FDPP E'},...
    {'U FPP O','C FPP O','U FDPP O','C FDPP O','U FPP E','C FPP E','U FDPP E','C FDPP E'},...
    {'Obj U FPP O','Bg U FPP O','Obj C FPP O','Bg C FPP O','Obj U FDPP O','Bg U FDPP O','Obj C FDPP O','Bg C FDPP O'}];

node_p_values_1=createPvalueVecExp1Explo(ObjectsResults1,AttributesResults1,EFAtt);

w=cd(pathTree);
G1ImageAnalysis = createtree(parents_vec,node_names,node_p_values_1);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G1ImageAnalysis,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Experiment 1 exploratory image analysis tree')
cd(w);

%% saccadic rate tree Experiment 1 
%different structure than exp2 becuase doesn't start from exploratory node

%Create pvalues data
nodes_vec =   [2 3 4]; 
parents_vec	= [1 2 2];
numClustersUObj=length(ResultsPermShuffledTrails_Objects1{1}.pval);
numClustersCObj=length(ResultsPermShuffledTrails_Objects1{2}.pval);
nodes_vec((end+1):(end+numClustersUObj))=(nodes_vec(end)+1):(nodes_vec(end)+numClustersUObj);
parents_vec((end+1):(end+numClustersUObj))=3;
nodes_vec((end+1):(end+numClustersCObj))=(nodes_vec(end)+1):(nodes_vec(end)+numClustersCObj);
parents_vec((end+1):(end+numClustersCObj))=4;

node_names = [{'Saccadic rate','Objects'},...
    {'U O','C O'}];
ind=length(node_names);
num=0;
for cc=1:numClustersUObj
    ind=ind+1;
    num=num+1;
    node_names{ind}=['cl',num2str(num),' U O'];
end

ind=length(node_names);
num=0;
for cc=1:numClustersCObj
    ind=ind+1;
    num=num+1;
    node_names{ind}=['cl',num2str(num),' C O'];
end

endnan=4;
node_p_values_1=createPvalueVecSR(ResultsPermShuffledTrails_Objects1,endnan);

w=cd(pathTree);
G1SR = createtree(parents_vec,node_names,node_p_values_1);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G1SR,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Experiment 1 exploratory saccadic rate tree')
cd(w);

%% saccadic rate tree Experiment 2
%different structure than exp1 becuase starts from exploratory node

%Create pvalues data
nodes_vec =   [2 3 4 5]; 
parents_vec	= [1 2 3 3];
numClustersUObj=length(ResultsPermShuffledTrails_Objects2{1}.pval);
numClustersCObj=length(ResultsPermShuffledTrails_Objects2{2}.pval);
nodes_vec((end+1):(end+numClustersUObj))=(nodes_vec(end)+1):(nodes_vec(end)+numClustersUObj);
parents_vec((end+1):(end+numClustersUObj))=4;
nodes_vec((end+1):(end+numClustersCObj))=(nodes_vec(end)+1):(nodes_vec(end)+numClustersCObj);
parents_vec((end+1):(end+numClustersCObj))=5;

node_names = [{'Exploratory','Saccadic rate','Objects'},...
    {'U O','C O'}];
ind=length(node_names);
num=0;
for cc=1:numClustersUObj
    ind=ind+1;
    num=num+1;
    node_names{ind}=['cl',num2str(num),' U O'];
end

ind=length(node_names);
num=0;
for cc=1:numClustersCObj
    ind=ind+1;
    num=num+1;
    node_names{ind}=['cl',num2str(num),' C O'];
end

endnan=5;
node_p_values_2=createPvalueVecSR(ResultsPermShuffledTrails_Objects2,endnan);

w=cd(pathTree);
G2SR = createtree(parents_vec,node_names,node_p_values_2);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G2SR,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Experiment 2 exploratory saccadic rate tree')
cd(w);

%% merge trees
w=cd(pathTree);
% Experiment 1 exploratory
G1_explo_tree = rmergetrees({G1ImageAnalysis,G1CNN,G1SR},'Exploratory');
% Experiment 1 all
G1_big_tree = mergetrees(G1Preregistered,G1_explo_tree,'Experiment 1');

%Experiment 2 preregistered
G2_prereg_tree = mergetrees(G2ImageAnalysis,G2CNN,'Preregistered');

%Experiment 2 all
G2_big_tree = mergetrees(G2_prereg_tree,G2SR,'Experiment 2');

%% run Tree BH alogorithems both analysis
G_final_tree = rmergetrees({G1_big_tree,G2_big_tree,G12CNN},'Manuscript');
[G_output,G_plot_handle] = treeBH(G_final_tree,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
cd(w)

%% create results table
[TableCNNPVal,TableCNNES]=createResultsTableCNN(G_output,CNNResults1,CNNResults2,CNNResults12);
TablePermAnalysis=createResultsTablePermAnalysis(G_output,ObjectsResults1,ObjectsResults2,RegionsResults1,RegionsResults2,AttributesResults1,AttributesResults2);

%% save
if saveFlag
    save([pathSaveResults,'\BigTreeBH',ending,'.mat'],'G_output','G_plot_handle')
    writetable(TableCNNPVal,['CNNPval',ending,'.csv'])
    writetable(TableCNNES,['CNNEffSize',ending,'.csv'])
    writetable(TablePermAnalysis,['PermAnalysisPvalEffSize',ending,'.csv']) 
end

function node_p_values=createPvalueVecExp2(Regions,Objects,Attributes,EFAtt)
%Nodes 23-38
RegionsPval = [Regions.condition(1).pvalFPP,Regions.condition(2).pvalFPP,Regions.condition(1).pvalFDPP,Regions.condition(2).pvalFDPP];
%Nodes 39-46
ObjectsPval = [Objects.pvalFPPObj(1),Objects.pvalFPPBg(1),Objects.pvalFPPObj(2),Objects.pvalFPPBg(2),Objects.pvalFDPPObj(1),Objects.pvalFDPPBg(1),Objects.pvalFDPPObj(2),Objects.pvalFDPPBg(2)];
%Nodes 19 20 21 22
EmFaPval=[Attributes.pvalFPPAtt(1,EFAtt),Attributes.pvalFPPAtt(2,EFAtt),Attributes.pvalFDPPAtt(1,EFAtt),Attributes.pvalFDPPAtt(2,EFAtt)]; %19 20 21 22
node_p_values = [nan(1,18), EmFaPval, RegionsPval, ObjectsPval];
end

function node_p_values=createPvalueVecExp1Pre(Regions,ResultsControlVsImageTrials,NSSSimilarity,DispersionResults)
%Node 19 NSS similarity
NSSSimilarityPval = NSSSimilarity.p;
%Nodes 20-37 image vs control trials analysis
ImvsConPval = [ResultsControlVsImageTrials.Pvalue(1:18).value];
%Nodes 38-39 dispersion
dipersionPval = [DispersionResults.p_vertical, DispersionResults.p_horizontal];
%Nodes 40-55 Region analysis
RegionsPval = [Regions.condition(1).pvalFPP,Regions.condition(2).pvalFPP,Regions.condition(1).pvalFDPP,Regions.condition(2).pvalFDPP];

node_p_values = [nan(1,18),NSSSimilarityPval,ImvsConPval,dipersionPval,RegionsPval];
end

function node_p_values=createPvalueVecExp1Explo(Objects,Attributes,EFAtt)
%Nodes 12-15
EmFaPval=[Attributes.pvalFPPAtt(1,EFAtt),Attributes.pvalFPPAtt(2,EFAtt),Attributes.pvalFDPPAtt(1,EFAtt),Attributes.pvalFDPPAtt(2,EFAtt)]; 
%Nodes 16-23
ObjectsPval = [Objects.pvalFPPObj(1),Objects.pvalFPPBg(1),Objects.pvalFPPObj(2),Objects.pvalFPPBg(2),Objects.pvalFDPPObj(1),Objects.pvalFDPPBg(1),Objects.pvalFDPPObj(2),Objects.pvalFDPPBg(2)];

node_p_values = [nan(1,11), EmFaPval, ObjectsPval];
end

function node_p_values=createPvalueVecSR(ResultsPerm_Objects1,endnan)
node_p_values = [nan(1,endnan), ResultsPerm_Objects1{1}.pval, ResultsPerm_Objects1{2}.pval];
end
function G=createCNNTree(Results,pathTree,expNum,ParamTree,type)
numLayers=size(Results.Rho,2);
switch type
    case 'oneExp'
        nodes_vec = [2:(2+numLayers-1),(2+numLayers):((2+numLayers)+numLayers*2-1)];
    case 'mergedExp'
        nodes_vec = [2:(4+numLayers-1),(4+numLayers):((4+numLayers)+numLayers*2-1)];
end
%create parents vector
switch type
    case 'oneExp'
        parents_vec	= ones(1,numLayers);
        vec=2:(2+numLayers-1);
        
    case 'mergedExp'
        parents_vec	= [1,2,ones(1,numLayers)*3];
        vec=4:(4+numLayers-1);
end
vec=[vec;vec];
vec=vec(:);
parents_vec	=[parents_vec,vec'];
%create node names vector
tt=0;
for ii=1:numLayers
    Layer_names{ii}=['L',num2str(ii),'E',num2str(expNum)];
    tt=tt+1;
    Conditions{tt}=['U',Layer_names{ii}];
    tt=tt+1;
    Conditions{tt}=['C',Layer_names{ii}];
end
switch type
    case 'oneExp'        
        node_names={'CNN Analysis',Layer_names{:},Conditions{:}};
    case 'mergedExp'
        node_names={'Experiment 1&2','Exploratory','CNN Analysis',Layer_names{:},Conditions{:}};
end

%create node p-value vector
switch type
    case 'oneExp'
        node_p_values = [nan(1,numLayers+2-1), Results.pval(:)'];
    case 'mergedExp'
        node_p_values = [nan(1,numLayers+4-1), Results.pval(:)'];
end

%% run Tree BH alogorithem
w=cd(pathTree);
G = createtree(parents_vec,node_names,node_p_values);
[G_output,G_plot_handle] = treeBH(G,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
ResultsTreeBH=G_output;
cd(w)

%% add post hoc tests and run tree again
switch type
    case 'oneExp'
        ind=(2+numLayers); %node in which experimental resutls start
    case 'mergedExp'
        ind=(4+numLayers); %node in which experimental resutls start
end
for ii=1:numLayers
    %check if U or C condition in each layer is significant
    %ind is U unconscious condition of the layer, and ind+1 is conscious condition
    if ResultsTreeBH.Nodes{ind,'reject'}==1 || ResultsTreeBH.Nodes{ind+1,'reject'}==1
        %add node
        parents_vec(end+1)=ind; %add the new result as a chiled of unconscious condition of this layer
        node_names{end+1}=['U-C',Layer_names{ii}];
        node_p_values(end+1)=Results.pvalSub(ii);
    end
    ind=ind+2;
end

%run the tree again
w=cd(pathTree);
G = createtree(parents_vec,node_names,node_p_values);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
switch type
    case 'oneExp'
        title('Tree structure of CNN analysis of one experiment')
    case 'mergedExp'
        title('Tree structure of CNN analysis of both experiments')
end
cd(w)
end

function [TablePVal,TableES]=createResultsTableCNN(G_output,Results1,Results2,Results12)
numLayers=size(Results1.Rho,2);

NodeNames={G_output.Nodes.name};
NodeNames=NodeNames{:};

%experiment 1
for ii=1:numLayers
    indU=find(strcmp(NodeNames,['UL',num2str(ii),'E1']));
    indC=find(strcmp(NodeNames,['CL',num2str(ii),'E1']));
    indSub=find(strcmp(NodeNames,['U-CL',num2str(ii),'E1']));
    pU1(ii)=G_output.Nodes{indU,'corr_p'};
    pC1(ii)=G_output.Nodes{indC,'corr_p'};
    if ~isempty(indSub)
        pSub1(ii)=G_output.Nodes{indSub,'corr_p'};
    else
        pSub1(ii)=NaN;
    end
end
%experiment 2
for ii=1:numLayers
    indU=find(strcmp(NodeNames,['UL',num2str(ii),'E2']));
    indC=find(strcmp(NodeNames,['CL',num2str(ii),'E2']));
    indSub=find(strcmp(NodeNames,['U-CL',num2str(ii),'E2']));
    pU2(ii)=G_output.Nodes{indU,'corr_p'};
    pC2(ii)=G_output.Nodes{indC,'corr_p'};
    if ~isempty(indSub)
        pSub2(ii)=G_output.Nodes{indSub,'corr_p'};
    else
        pSub2(ii)=NaN;
    end
end

%experiment 1&2
for ii=1:numLayers
    indU=find(strcmp(NodeNames,['UL',num2str(ii),'E3']));
    indC=find(strcmp(NodeNames,['CL',num2str(ii),'E3']));
    indSub=find(strcmp(NodeNames,['U-CL',num2str(ii),'E3']));
    pU3(ii)=G_output.Nodes{indU,'corr_p'};
    pC3(ii)=G_output.Nodes{indC,'corr_p'};
    if ~isempty(indSub)
        pSub3(ii)=G_output.Nodes{indSub,'corr_p'};
    else
        pSub3(ii)=NaN;
    end
end

%find effect sizes in experiment 1, 2 and 1&2
ESU1=Results1.effectSize(1,:);
ESC1=Results1.effectSize(2,:);
ESSub1=Results1.effectSizeSub;

ESU2=Results2.effectSize(1,:);
ESC2=Results2.effectSize(2,:);
ESSub2=Results2.effectSizeSub;

ESU12=Results12.effectSize(1,:);
ESC12=Results12.effectSize(2,:);
ESSub12=Results12.effectSizeSub;

%create table
TablePVal = table(pU1',pC1',pSub1',pU2',pC2',pSub2',pU3',pC3',pSub3','VariableNames',{'U1','C1','Sub1','U2','C2','Sub2','U3','C3','Sub3'});
TableES = table(ESU1',ESC1',ESSub1',ESU2',ESC2',ESSub2',ESU12',ESC12',ESSub12','VariableNames',{'U1','C1','Sub1','U2','C2','Sub2','U12','C12','Sub12'});
end

function tbl=createResultsTablePermAnalysis(G_output,ObjectsResults1,ObjectsResults2,RegionsResults1,RegionsResults2,AttributesResults1,AttributesResults2)

NodeNames={G_output.Nodes.name};
NodeNames=NodeNames{:};

wantedNodes_U_FPP={'Obj U FPP O','Bg U FPP O','U FPP E','L U FPP R','H U FPP R','L&H U FPP R','Bg U FPP R'};
wantedNodes_C_FPP={'Obj C FPP O','Bg C FPP O','C FPP E','L C FPP R','H C FPP R','L&H C FPP R','Bg C FPP R'};
wantedNodes_U_FDPP={'Obj U FDPP O','Bg U FDPP O','U FDPP E','L U FDPP R','H U FDPP R','L&H U FDPP R','Bg U FDPP R'};
wantedNodes_C_FDPP={'Obj C FDPP O','Bg C FDPP O','C FDPP E','L C FDPP R','H C FDPP R','L&H C FDPP R','Bg C FDPP R'};

%find p-values in experiment 1 and 2
for ii=1:length(wantedNodes_U_FPP)
    %The first ind is p-val in experiment 1, and the second in experiment 2
    ind_U_FPP=find(strcmp(NodeNames,wantedNodes_U_FPP{ii}));
    ind_C_FPP=find(strcmp(NodeNames,wantedNodes_C_FPP{ii}));
    ind_U_FDPP=find(strcmp(NodeNames,wantedNodes_U_FDPP{ii}));
    ind_C_FDPP=find(strcmp(NodeNames,wantedNodes_C_FDPP{ii}));
    
    if length(ind_U_FPP)~=2
        error('result in one of the experiments is missing for unconscious FPP')
    end
    if length(ind_C_FPP)~=2
        error('result in one of the experiments is missing for conscious FPP')
    end
    if length(ind_U_FDPP)~=2
        error('result in one of the experiments is missing for unconscious FDPP')
    end
    if length(ind_C_FDPP)~=2
        error('result in one of the experiments is missing for conscious FDPP')
    end
    
    p_U_FPP_1(ii)=G_output.Nodes{ind_U_FPP(1),'corr_p'};
    p_U_FPP_2(ii)=G_output.Nodes{ind_U_FPP(2),'corr_p'};
    p_C_FPP_1(ii)=G_output.Nodes{ind_C_FPP(1),'corr_p'};
    p_C_FPP_2(ii)=G_output.Nodes{ind_C_FPP(2),'corr_p'};
    p_U_FDPP_1(ii)=G_output.Nodes{ind_U_FDPP(1),'corr_p'};
    p_U_FDPP_2(ii)=G_output.Nodes{ind_U_FDPP(2),'corr_p'};
    p_C_FDPP_1(ii)=G_output.Nodes{ind_C_FDPP(1),'corr_p'};
    p_C_FDPP_2(ii)=G_output.Nodes{ind_C_FDPP(2),'corr_p'};
end
p_U_1=round([p_U_FPP_1,p_U_FDPP_1],3);
p_C_1=round([p_C_FPP_1,p_C_FDPP_1],3);
p_U_2=round([p_U_FPP_2,p_U_FDPP_2],3);
p_C_2=round([p_C_FPP_2,p_C_FDPP_2],3);

%find effect sizes in experiment 1 and 2
ES_U_FPP_1=[ObjectsResults1.effectSizeFPPObj(1),ObjectsResults1.effectSizeFPPBg(1),AttributesResults1.effectSizeFPPAtt(1,3),RegionsResults1.condition(1).effectSizeFPP];
ES_U_FDPP_1=[ObjectsResults1.effectSizeFDPPObj(1),ObjectsResults1.effectSizeFDPPBg(1),AttributesResults1.effectSizeFDPPAtt(1,3),RegionsResults1.condition(1).effectSizeFDPP];
ES_U_1=round([ES_U_FPP_1,ES_U_FDPP_1],2);

ES_C_FPP_1=[ObjectsResults1.effectSizeFPPObj(2),ObjectsResults1.effectSizeFPPBg(2),AttributesResults1.effectSizeFPPAtt(2,3),RegionsResults1.condition(2).effectSizeFPP];
ES_C_FDPP_1=[ObjectsResults1.effectSizeFDPPObj(2),ObjectsResults1.effectSizeFDPPBg(2),AttributesResults1.effectSizeFDPPAtt(2,3),RegionsResults1.condition(2).effectSizeFDPP];
ES_C_1=round([ES_C_FPP_1,ES_C_FDPP_1],2);

ES_U_FPP_2=[ObjectsResults2.effectSizeFPPObj(1),ObjectsResults2.effectSizeFPPBg(1),AttributesResults2.effectSizeFPPAtt(1,3),RegionsResults2.condition(1).effectSizeFPP];
ES_U_FDPP_2=[ObjectsResults2.effectSizeFDPPObj(1),ObjectsResults2.effectSizeFDPPBg(1),AttributesResults2.effectSizeFDPPAtt(1,3),RegionsResults2.condition(1).effectSizeFDPP];
ES_U_2=round([ES_U_FPP_2,ES_U_FDPP_2],2);

ES_C_FPP_2=[ObjectsResults2.effectSizeFPPObj(2),ObjectsResults2.effectSizeFPPBg(2),AttributesResults2.effectSizeFPPAtt(2,3),RegionsResults2.condition(2).effectSizeFPP];
ES_C_FDPP_2=[ObjectsResults2.effectSizeFDPPObj(2),ObjectsResults2.effectSizeFDPPBg(2),AttributesResults2.effectSizeFDPPAtt(2,3),RegionsResults2.condition(2).effectSizeFDPP];
ES_C_2=round([ES_C_FPP_2,ES_C_FDPP_2],2);

%create table
tbl = table(p_U_1',ES_U_1',p_C_1',ES_C_1',p_U_2',ES_U_2',p_C_2',ES_C_2','VariableNames',{'Upval1','UeffectSize1','Cpval1','CeffectSize1','Upval2','UeffectSize2','Cpval2','CeffectSize2'});
end