function plotBootstrap(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText)
subplot(rows,columns,plotNum)
histogram(vecReptitions)
hold on
alpha=prctile(vecReptitions,prc);
lim=axis;
line([realVal,realVal],[lim(3),lim(4)],'Color','b','LineWidth',2)
line([alpha,alpha],[lim(3),lim(4)],'Color','b','LineStyle','--','LineWidth',2)
hold off
%title([titleText,' Pval= ',num2str(Pval)],'FontSize',20)
if Pval<0.05
    title(titleText,'FontSize',18,'Color','red')
else
    title(titleText,'FontSize',18)
end
xlabel(xlabelText,'FontSize',18)
set(gca,'FontSize',18)
end