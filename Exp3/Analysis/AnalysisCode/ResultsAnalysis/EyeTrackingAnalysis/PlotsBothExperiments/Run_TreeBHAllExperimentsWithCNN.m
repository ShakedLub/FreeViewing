clear
clc
close all

%% Paramaters
AnalysisType=1; %1 main, 2 low level type 1, 3 RttM check
saveFlag=0; %1 save, 0 do not save

ParamTree.plot_tree=1;
ParamTree.interactive_plot=0;
ParamTree.recalculate_p=0;
ParamTree.alpha_level=0.05;

EFAtt=3; %emotional face attribute number

%% paths
codePath=cd;
cd ..\..\..\..\
foldersPath=[pwd,'\AnalysisFolders'];
dataPath=[foldersPath,'\ResultsStructs'];
pathTree=[foldersPath,'\Code\TreeBH'];
cd(codePath)

if AnalysisType == 2
    path1=[dataPath,'\Pilot1_LowLevelType1'];
    path2=[dataPath,'\Pilot2_LowLevelType1'];
elseif AnalysisType == 1
    path1=[dataPath,'\Pilot1_Final'];
    path2=[dataPath,'\Pilot2_Final'];
elseif AnalysisType == 3
    path1=[dataPath,'\Pilot1_RttMCheck'];
    path2=[dataPath,'\Pilot2_RttMCheck'];
end
pathSaveResults=dataPath;

%% load data
load([path1,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsResults1=RegionsSummary;
clear RegionsSummary
load([path2,'\','RegionsSummary_RemoveCenterBias.mat']);
RegionsResults2=RegionsSummary;
clear RegionsSummary

if AnalysisType == 2
    path1=[dataPath,'\Pilot1_Final'];
    path2=[dataPath,'\Pilot2_Final'];
end

load([path1,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsResults1=ObjectsSummary;
load([path1,'\','AttributesSummary_RemoveCenterBias.mat']);
AttributesResults1=AttributesSummary;
clear AttributesSummary ObjectsSummary

load([path2,'\','ObjectsSummary_RemoveCenterBias.mat']);
ObjectsResults2=ObjectsSummary;
load([path2,'\','AttributesSummary_RemoveCenterBias.mat']);
AttributesResults2=AttributesSummary;
clear AttributesSummary ObjectsSummary

if AnalysisType == 1 || AnalysisType == 2
    path1=[dataPath,'\RSA\Pilot1_Final'];
    path2=[dataPath,'\RSA\Pilot2_Final'];
    path12=[dataPath,'\RSA\Pilot1&2_Final'];
elseif AnalysisType == 3
    path1=[dataPath,'\RSA\Pilot1_RttMCheck'];
    path2=[dataPath,'\RSA\Pilot2_RttMCheck'];
    path12=[dataPath,'\RSA\Pilot1&2_RttMCheck'];
end
load([path1,'\','Results_RemoveCenterBias.mat']);
CNNResults1=Results;
clear Results

load([path2,'\','Results_RemoveCenterBias.mat']);
CNNResults2=Results;
clear Results

load([path12,'\','Results_RemoveCenterBias.mat']);
CNNResults12=Results;
clear Results

%% Main analysis trees
%Create pvalues data
%Create pvalues data
nodes_vec =   [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46];
parents_vec	= [1 1 1 2 2 3 3 4  4  5  5  6  6  7  7  8  8  9  9 10 10 11 11 11 11 12 12 12 12 13 13 13 13 14 14 14 14 15 15 16 16 17 17 18 18];

node_names = [{'PreviousOSF','Regions','Objects','Emotinal Face'},...
    {'FPP R','FDPP R','FPP O','FDPP O','FPP E','FDPP E'},...
    {'U FPP R','C FPP R','U FDPP R','C FDPP R','U FPP O','C FPP O','U FDPP O','C FDPP O','U FPP E','C FPP E','U FDPP E','C FDPP E'},...
    {'L U FPP R','H U FPP R','L&H U FPP R','Bg U FPP R','L C FPP R','H C FPP R','L&H C FPP R','Bg C FPP R','L U FDPP R','H U FDPP R','L&H U FDPP R','Bg U FDPP R','L C FDPP R','H C FDPP R','L&H C FDPP R','Bg C FDPP R'},...
    {'Obj U FPP O','Bg U FPP O','Obj C FPP O','Bg C FPP O','Obj U FDPP O','Bg U FDPP O','Obj C FDPP O','Bg C FDPP O'}];

node_p_values_1=createPvalueVec(RegionsResults1,ObjectsResults1,AttributesResults1,EFAtt);
node_p_values_2=createPvalueVec(RegionsResults2,ObjectsResults2,AttributesResults2,EFAtt);

%create tree
w=cd(pathTree);
G1 = createtree(parents_vec,node_names,node_p_values_1);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G1,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Tree structure of main analysis of experiment 1')

G2 = createtree(parents_vec,node_names,node_p_values_2);
%create tree only for visualization that the structure is correct
[G_output,G_plot_handle] = treeBH(G2,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
title('Tree structure of main analysis of experiment 2')
cd(w);

%% CNN analysis trees
G1CNN=createCNNTree(CNNResults1,pathTree,1,ParamTree);
G2CNN=createCNNTree(CNNResults2,pathTree,2,ParamTree);
G12CNN=createCNNTree(CNNResults12,pathTree,3,ParamTree);

%% merge trees
w=cd(pathTree);
G1_big_tree = mergetrees(G1,G1CNN,'Experiment 1');
G2_big_tree = mergetrees(G2,G2CNN,'Experiment 2');

%% run Tree BH alogorithems both analysis
G_big_tree = mergetrees(G1_big_tree,G2_big_tree,'Preregistered');
G_final_tree = mergetrees(G_big_tree,G12CNN,'Manuscript');
[G_output,G_plot_handle] = treeBH(G_final_tree,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
cd(w)

%% create results table
TableCNN=createResultsTable(G_output,CNNResults1);

%% save
if saveFlag
    if AnalysisType==1
        save([pathSaveResults,'\BigTreeBH.mat'],'G_output','G_plot_handle')
        writetable(TableCNN,'CNNPvalues.csv')
    elseif AnalysisType==2
        save([pathSaveResults,'\BigTreeBH_LowLevelType1.mat'],'G_output','G_plot_handle')
        writetable(TableCNN,'CNNPvalues_LowLevelType1.csv')
    elseif AnalysisType==3
        save([pathSaveResults,'\BigTreeBH_RttMCheck.mat'],'G_output','G_plot_handle')
        writetable(TableCNN,'CNNPvalues_RttMCheck.csv')
    end
end

function node_p_values=createPvalueVec(Regions,Objects,Attributes,EFAtt)
%Nodes 23-38
RegionsPval = [Regions.condition(1).pvalFPP,Regions.condition(2).pvalFPP,Regions.condition(1).pvalFDPP,Regions.condition(2).pvalFDPP];
%Nodes 39-46
ObjectsPval = [Objects.pvalFPPObj(1),Objects.pvalFPPBg(1),Objects.pvalFPPObj(2),Objects.pvalFPPBg(2),Objects.pvalFDPPObj(1),Objects.pvalFDPPBg(1),Objects.pvalFDPPObj(2),Objects.pvalFDPPBg(2)];
%Nodes 19 20 21 22
EmFaPval=[Attributes.pvalFPPAtt(1,EFAtt),Attributes.pvalFPPAtt(2,EFAtt),Attributes.pvalFDPPAtt(1,EFAtt),Attributes.pvalFDPPAtt(2,EFAtt)]; %19 20 21 22
node_p_values = [nan(1,18), EmFaPval, RegionsPval, ObjectsPval];
end

function G=createCNNTree(Results,pathTree,expNum,ParamTree)
numLayers=size(Results.Rho,2);
nodes_vec =   [2:(2+numLayers-1),(2+numLayers):((2+numLayers)+numLayers*2-1)];
%create parents vector
parents_vec	= ones(1,numLayers);
vec=2:(2+numLayers-1);
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
node_names={'CNN Analysis',Layer_names{:},Conditions{:}};

%create node p-value vector
node_p_values = [nan(1,numLayers+2-1), Results.pval(:)'];

%% run Tree BH alogorithem
w=cd(pathTree);
G = createtree(parents_vec,node_names,node_p_values);
[G_output,G_plot_handle] = treeBH(G,ParamTree.plot_tree,ParamTree.interactive_plot,ParamTree.recalculate_p,ParamTree.alpha_level);
ResultsTreeBH=G_output;
cd(w)

%% add post hoc tests and run tree again
ind=(2+numLayers); %node in which experimental resutls start
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
title('Tree structure of CNN analysis of one experiment')
cd(w)
end

function Table=createResultsTable(G_output,Results)
numLayers=size(Results.Rho,2);

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

%create table
Table = table(pU1',pC1',pSub1',pU2',pC2',pSub2',pU3',pC3',pSub3','VariableNames',{'U1','C1','Sub1','U2','C2','Sub2','U3','C3','Sub3'});
end