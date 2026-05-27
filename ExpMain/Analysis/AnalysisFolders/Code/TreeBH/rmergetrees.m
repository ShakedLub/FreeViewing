function G = rmergetrees(C,root_name)
%recursively merge multiple tree graphs:
%inputs:
%   C:          a cell array containing tree objects (created with createtree)
%   root_name:  a label for the root node
%output:
%   G:          a tree object, to use in treeBH
%
% rmergetrees treat the root nodes of all input trees as sister nodes in
% the output tree

% check that all input Trees are equivalent
node_props = cellfun(@(x) x.Nodes.Properties.VariableNames,C,'un',0);
if ~all(cellfun(@(x) isequal(node_props{1},x),node_props))
    error('Tree graphs should have the same node properties')
end

if isscalar(C)
    G = C{1};
    return
end

% call mergetrees recursively
G = C{1};
for ii=2:length(C)
    if ii==2
        G = mergetrees(G,C{ii},root_name,0);
    else
        G = mergetrees(G,C{ii},[],1);
    end
end
