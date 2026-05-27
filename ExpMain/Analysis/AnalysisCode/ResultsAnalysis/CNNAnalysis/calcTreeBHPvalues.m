function [LayersSubtractionAnalysis,pvalCorrected,treeInput]=calcTreeBHPvalues(Results,Paths)
%% Param
plot_tree=1;
interactive_plot=0;
recalculate_p=0;
alpha_level=0.05;

%% Create pvalues data
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
    Layer_names{ii}=['L',num2str(ii)];
    tt=tt+1;
    Conditions{tt}=['U',Layer_names{ii}];
    tt=tt+1;
    Conditions{tt}=['C',Layer_names{ii}];
end
node_names={'CNN Analysis',Layer_names{:},Conditions{:}};

%create node p-value vector
node_p_values = [nan(1,numLayers+2-1), Results.pval(:)'];

%% run Tree BH alogorithem
wd=cd(Paths.TreeBH);
G = createtree(parents_vec,node_names,node_p_values);
[G_output,G_plot_handle] = treeBH(G,plot_tree,interactive_plot,recalculate_p,alpha_level);
ResultsTreeBH=G_output;
cd(wd)

%% save tree input
treeInput.parents_vec=parents_vec;
treeInput.node_names=node_names;
treeInput.node_p_values=node_p_values;

%% add post hoc tests that should be run to treeInput and
%% find layers that should be checked in permutation subtraction analysis
LayersSubtractionAnalysis=[];
ind=(2+numLayers); %node in which experimental resutls start
for ii=1:numLayers
    %check if U or C condition in each layer is significant
    %ind is U unconscious condition of the layer, and ind+1 is conscious condition
    if ResultsTreeBH.Nodes{ind,'reject'}==1 || ResultsTreeBH.Nodes{ind+1,'reject'}==1
        %add node
        treeInput.parents_vec(end+1)=ind; %add the new result as a chiled of unconscious condition of this layer
        treeInput.node_names{end+1}=['U-C',Layer_names{ii}];
        
        %layers for subtraction analysis
        LayersSubtractionAnalysis=[LayersSubtractionAnalysis,ii];
    end
    % create mat of corrected pvalues
    pvalCorrected(1,ii)=ResultsTreeBH.Nodes{ind,'corr_p'};
    pvalCorrected(2,ii)=ResultsTreeBH.Nodes{ind+1,'corr_p'};

    ind=ind+2;
end
end