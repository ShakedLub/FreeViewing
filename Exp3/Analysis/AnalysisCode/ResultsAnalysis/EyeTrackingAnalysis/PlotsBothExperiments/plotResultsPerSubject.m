function ax=plotResultsPerSubject(data,axAll,groupNames,titleText,xlabelText,ylabelText,rows,columns,plotNum,cl,linecl,flagDoNotDeleteXaxis)
ax=subplot(rows,columns,plotNum);
ymat=data;
y=ymat(:);
numSubj=size(ymat,1);
xmat=repmat(1:length(groupNames),numSubj,1);
x=xmat(:);
color=[];
for ii=1:length(groupNames)
    color=[color;repmat(cl(ii,:),numSubj,1)];
end
scatter(x,y,50,color,'filled')
hold on
for ii=1:numSubj %subjects
    line(1:length(groupNames), ymat(ii,:),'Color',linecl,'Linewidth',0.1)
end
bx=boxplot(y,x,'symbol',''); %remove oulier markers
set(bx,'LineWidth',2)
set(bx,'Color',[.5 .5 .5])
hold off

%change y-axis to be the same in all plots in the same row
if columns~=1 && mod(plotNum,columns) == 0 %last plot in each row
    linkaxes([axAll{plotNum-3},axAll{plotNum-2},axAll{plotNum-1},ax],'y')
end


if flagDoNotDeleteXaxis
    set(gca,'XTick',1:length(groupNames))
    set(gca,'XTickLabel',groupNames)
    xlabel(xlabelText)
else
    LastRowVec=(columns*(rows-1)+1):(rows*columns);
    if ismember(plotNum,LastRowVec)
        set(gca,'XTick',1:length(groupNames))
        set(gca,'XTickLabel',groupNames)
        xlabel(xlabelText)
    else
        set(gca,'XTick',[])
    end
end
%xtickangle(45)

beginingOfRowVec=1:columns:(rows*columns);
if ismember(plotNum,beginingOfRowVec)   
    ylabel(ylabelText)
end

FirstRowVec=1:columns;
if ismember(plotNum,FirstRowVec)   
    title(titleText)
end

set(gca,'FontSize',22)
end