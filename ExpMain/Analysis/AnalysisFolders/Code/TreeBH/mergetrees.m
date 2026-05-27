function G = mergetrees(G1,G2,root_name,merge_idx)
%merge two tree graphs:
%inputs:
%   G1,G2:      tree objects (created with createtree)
%   root_name:  a label for the root node
%   merge_idx:  Node index of G1, where G2 would be connected
%               If merge_idx==0, the root nodes of both input trees would be sister nodes in
%               the output tree, i.e. mergetrees will add a new root (this
%               is the legacy case)
%               If merge_trees>0, G2 would be pasted into G1 without adding
%               any new root. Note that merge_index cannot be larger than
%               the number of nodes in G1
%output:
%   G:             a tree object, to use in treeBH

if nargin<4 || isempty(merge_idx)
    merge_idx=0;
end

if ~all(ismember(G1.Nodes.Properties.VariableNames,G2.Nodes.Properties.VariableNames))
    error('Tree graphs should have the same node properties')
end
n1 = G1.numnodes;
n2 = G2.numnodes;
e2 = G2.Edges.EndNodes + n1;
G = addnode(G1,G2.Nodes); % add G2 nodes to G1 (floating)
G = addedge(G,e2(:,1),e2(:,2)); % add internal connections of G2
if merge_idx==0
    G = addedge(G,repmat(n1+n2+1,2,1),[1;n1+1]); % add root and connect it to the two subgraphs
    G = reordernodes(G,circshift(1:G.numnodes,1)); % make root the first node
    if ismember('p',G.Nodes.Properties.VariableNames)
        G.Nodes.p(1) = nan;
    end
    if nargin>2 && ~isempty(root_name) && ismember('name',G.Nodes.Properties.VariableNames)
        G.Nodes.name{1} = root_name;
    end
else
    if merge_idx>n1
        error('merge_idx cannot be larger than the number of nodes in G1')
    end
    G = addedge(G,merge_idx,n1+1); % connect the root of G2 to G1
end