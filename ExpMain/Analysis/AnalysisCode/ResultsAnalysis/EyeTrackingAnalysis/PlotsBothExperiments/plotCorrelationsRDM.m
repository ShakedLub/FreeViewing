function plotCorrelationsRDM(Results,ResultsTreeBH,rows,columns,numPlot,titleText,colors)
%This plots presents the spearman correlation eventhough all the analysis
%is done on 1-spearman correlation.

if isfield(Results,'CI')
    %Calculate CI length
    Data=Results.DataRandForSTE;
    Data=1-Data;
    CI=quantile(Data,[0.025,0.975],3);
    meanErr=mean(Data,3);
    CIlength(:,:,1)=meanErr-CI(:,:,1);
    CIlength(:,:,2)=CI(:,:,2)-meanErr;
    %Arrange data for plot
    minErr=CIlength(:,:,1)';
    maxErr=CIlength(:,:,2)';
    
    bh=ErrorBarOfCIOnGroupedBars((1-Results.Rho)',meanErr',minErr,maxErr);
elseif isfield(Results,'stdErr')
    %Calculate standard error
    Data=Results.DataRandForSTE;
    Data=1-Data;
    stdErr=std(Data,0,3);
    
    bh=ErrorBarOnGroupedBars((1-Results.Rho)',stdErr');
else
    bh=bar((1-Results.Rho)');
end
bh(1).FaceColor = colors(1,:); 
bh(2).FaceColor = colors(2,:);
bh(1).FaceAlpha = 0.6;
bh(2).FaceAlpha = 0.6;
hold on
lim=axis;
if isfield(Results,'noise')
    line([lim(1),lim(2)],[1-Results.noise.noise(1),1-Results.noise.noise(1)],'Color',colors(1,:),'LineWidth',2) %U condition noise floor
    line([lim(1),lim(2)],[1-Results.noise.noise(2),1-Results.noise.noise(2)],'Color',colors(2,:),'LineWidth',2) %C condition noise floor
end
hold off
ylabel('Spearman Rho')
Ax = gca;
Ax.Box = 'off';
set(gca,'FontSize',22)
if isfield(Results,'noise')
    %ylim([0.35,1.15])
else
    %ylim([0.8,1.15])
end

%astricks
if ~isempty(ResultsTreeBH)
    nodeNames=ResultsTreeBH.Nodes.name;
    if any(strcmp('L1E3',nodeNames)) %This is a tree that includes all three experiments: 1, 2, 1&2
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
        for ii=1:numLayers
            %check if U or C condition in each layer is significant
            %ind is U unconscious condition of the layer, and ind+1 is conscious condition
            if ResultsTreeBH.Nodes{ind,'reject'}==1
                %add astricks
                plot(xt(ii),lim(4)-(3*height),'*','MarkerSize',10,'Color',colors(1,:));
            end
            if ResultsTreeBH.Nodes{ind+1,'reject'}==1
                %add astricks
                plot(xt(ii),lim(4)-(2*height),'*','MarkerSize',10,'Color',colors(2,:));
            end
            %check if subtraction analysis is significant
            indsub=find(strcmp(nodeNames,['U-CL',num2str(ii),'E',num]));
            if ~isempty(indsub)
                if ResultsTreeBH.Nodes{indsub,'reject'}==1
                    %add astricks
                    plot(xt(ii),lim(4)-(1*height),'*','MarkerSize',10,'Color',[0 0 0]);
                end
            end
            ind=ind+2;
        end
        hold off
    else %This is a tree that includes only one experiment: 1, 2 or 1&2
        hold on
        numLayers=size(Results.Rho,2);
        ind=find(strcmp('UL1',ResultsTreeBH.Nodes.name));
        lim=axis;
        height=((lim(4)-lim(3))/12);
        xticks(1:size(Results.Rho,2))
        xt = xticks;
        for ii=1:numLayers
            %check if U or C condition in each layer is significant
            %ind is U unconscious condition of the layer, and ind+1 is conscious condition
            if ResultsTreeBH.Nodes{ind,'reject'}==1
                %add astricks
                plot(xt(ii),lim(4)-(3*height),'*','MarkerSize',10,'Color',colors(1,:));
            end
            if ResultsTreeBH.Nodes{ind+1,'reject'}==1
                %add astricks
                plot(xt(ii),lim(4)-(2*height),'*','MarkerSize',10,'Color',colors(2,:));
            end
            %check if subtraction analysis is significant
            indsub=find(strcmp(nodeNames,['U-CL',num2str(ii)]));
            if ~isempty(indsub)
                if ResultsTreeBH.Nodes{indsub,'reject'}==1
                    %add astricks
                    plot(xt(ii),lim(4)-(1*height),'*','MarkerSize',10,'Color',[0 0 0]);
                end
            end
            ind=ind+2;
        end
        hold off
    end
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
title(titleText,'FontWeight','normal')
if numPlot==1
    legend({'U','C'})
end
end