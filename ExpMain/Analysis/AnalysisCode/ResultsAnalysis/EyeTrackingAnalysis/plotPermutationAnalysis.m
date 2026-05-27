function plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)
subplot(rows,columns,plotNum)
h1=histogram(vecReptitions1);
hold on
histogram(vecReptitions2,'BinWidth',h1.BinWidth)
lim=axis;

alpha1=prctile(vecReptitions1,prc);
line([realVal1,realVal1],[lim(3),lim(4)],'Color','b','LineWidth',2)
line([alpha1,alpha1],[lim(3),lim(4)],'Color','b','LineStyle','--','LineWidth',2)

alpha2=prctile(vecReptitions2,prc);
line([realVal2,realVal2],[lim(3),lim(4)],'Color','r','LineWidth',2)
line([alpha2,alpha2],[lim(3),lim(4)],'Color','r','LineStyle','--','LineWidth',2)
hold off

title(titleText,'FontSize',22)
xlabel(xlabelText,'FontSize',22)
ylabel('Count','FontSize',22)
set(gca,'FontSize',22)
end