function plotCorrelationsRDM(Results,ResultsTreeBH,rows,columns,numPlot,titleText)
if isfield(Results,'stdErr')
    bh=ErrorBarOnGroupedBars(Results.Rho',Results.stdErr');
else
    bh=bar(Results.Rho');
end
bh(1).FaceColor = [0 0.4470 0.7410]; %blue
bh(2).FaceColor = [0.4940 0.1840 0.5560]; %purple
bh(1).FaceAlpha = 0.6;
bh(2).FaceAlpha = 0.6;
ylabel('1 - Spearman Rho')
Ax = gca;
Ax.Box = 'off';
set(gca,'FontSize',22)
ylim([0.8,1.15])

%astricks
if ~isempty(ResultsTreeBH)
    hold on
    numLayers=size(Results.Rho,2);
    switch titleText
        case 'Exp 1'
            num='1';
        case 'Exp 2'
            num='2';
        case 'Exp 1&2'
            num='3';
    end
    ind=find(strcmp(['UL1E',num],ResultsTreeBH.Nodes.name));
    lim=axis;
    height=((lim(4)-lim(3))/12);
    xticks(1:size(Results.Rho,2))
    xt = xticks;
    nodeNames=ResultsTreeBH.Nodes.name;
    for ii=1:numLayers
        %check if U or C condition in each layer is significant
        %ind is U unconscious condition of the layer, and ind+1 is conscious condition
        if ResultsTreeBH.Nodes{ind,'reject'}==1
            %add astricks
             plot(xt(ii),lim(4)-(2*height),'*','MarkerSize',10,'Color',[0 0.4470 0.7410]);
        end
        if ResultsTreeBH.Nodes{ind+1,'reject'}==1
            %add astricks
            plot(xt(ii),lim(4)-height,'*','MarkerSize',10,'Color',[0.4940 0.1840 0.5560]);
        end
        %check if subtraction analysis is significant
        indsub=find(strcmp(nodeNames,['U-CL',num2str(ii),'E',num]));
        if ~isempty(indsub)
            if ResultsTreeBH.Nodes{indsub,'reject'}==1
                %add astricks
                plot(xt(ii),lim(4),'*','MarkerSize',10,'Color',[0 0 0]);
            end
        end
        ind=ind+2;
    end
    hold off
end

if numPlot == rows*columns
    xticks(1:size(Results.Rho,2))
    for ii=1:size(Results.Rho,2)
        layerLabels{ii}=['L',num2str(ii)];
    end
    xticklabels(layerLabels)
    xlabel('CNN Layers')
else
    xticks([])
end
title(titleText)
if numPlot==1
    legend({'U','C'})
end
end