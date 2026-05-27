function ResultsTreeBH=calcTreeBHPvaluesFinal(Results,LayersSubtractionAnalysis,treeInput,Paths)
%% Param
plot_tree=1;
interactive_plot=0;
recalculate_p=0;
alpha_level=0.05;

%% add post hoc tests pvalues
for ii=1:length(LayersSubtractionAnalysis)
    indsub=find(strcmp(treeInput.node_names,['U-CL',num2str(LayersSubtractionAnalysis(ii))]));
    layer_num=LayersSubtractionAnalysis(ii);
    treeInput.node_p_values(indsub)=Results.pvalSub(layer_num);
end

%run the tree again
wd=cd(Paths.TreeBH);
G = createtree(treeInput.parents_vec,treeInput.node_names,treeInput.node_p_values);
[G_output,G_plot_handle] = treeBH(G,plot_tree,interactive_plot,recalculate_p,alpha_level);
ResultsTreeBH=G_output;
cd(wd)
end