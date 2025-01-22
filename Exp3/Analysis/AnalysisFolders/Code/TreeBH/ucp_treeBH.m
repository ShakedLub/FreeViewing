%% manuscript FDR using tree-BH
% this is a demo code for the treeBH package
% it demonstrates how to define trees, merge subtrees and running the BH
% process.

clear;clc

recalc_p = 0;
interactive_plot = 0;
plot_tree = 1;

%% Import p-values of experiments
% hard-coded for clarity, obviously this is not recommened :)

% eeg
ucp1 = [0.0889,0.0062,0.1123,0.4314];      %con, conXreg (GG corrected), conXlat, conXregXlat
ucp1_post_hoc = [0.81,0.0581,0.0082];      %con (F), con (C), con (PO) - uncorrected
ucp_con = [0.0015,0.057,0.6616,0.8432];    %con, conXreg (GG corrected), conXlat, conXregXlat
ucp2 = [0.778,0.164,0.1468,0.5793];        %con, conXreg, conXlat, conXregXlat

% priming
pr1 = [2.2e-16,0.004315];       %rep, repXrel
pr1_ph = [1.73e-7,0.002892];    %rep (related), rep (unrelated) - uncorrected
pr2a = [0.008522,0.024820];     %rep, repXrel
pr2a_ph = [0.01047,0.3431];     %rep (related), rep (unrelated) - uncorrected
pr2b = [0.9989,0.3373];         %rep, repXrel


%% Define sub-trees
% conscious
node_parents = [1 1 2 2 3 3 3 3 5 5];
node_names = [{'Conscious'},...
    compose('Exp. %s',["1","4a"]),...
    {'rep','repXrelation','con','conXreg','conXlat','conXregXlat'},...
    compose('post-hoc %s',["rel","unrel"])];

node_p_values = [nan(1,3) pr1,ucp_con,pr1_ph];

G_con = createtree(node_parents,node_names,node_p_values);

% unconscious
node_parents = [1 1 1 1,repelem(2:5,[2 2 4 4]),7,7,11,11,11];
node_names = [{'Unconscious'},...
    compose('Exp. %s',["2a","2b","3","4b"]),...
    repmat({'rep','repXrelation'},1,2),...
    repmat({'con','conXreg','conXlat','conXregXlat'},1,2),...
    compose('post-hoc %s',["rel","unrel"]),...
    compose('post-hoc %s',["F","C","PO"])];

node_p_values = [nan(1,5),pr2a,pr2b,ucp1,ucp2,pr2a_ph,ucp1_post_hoc];

G_uncon = createtree(node_parents,node_names,node_p_values);


%% combine trees
G_manuscript = mergetrees(G_con,G_uncon,'Manuscript');
figure;plot(G_manuscript,'NodeLabel',G_manuscript.Nodes.name)

%% run TreeBH
[GG_manuscript,GP] = treeBH(G_manuscript,plot_tree,interactive_plot,recalc_p);
