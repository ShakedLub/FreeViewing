function plotCorrelation(xvec,yvec,titlex,titley,row,col,aa,r,pval,regionNames)
subplot(row,col,aa)
x=xvec;
y=yvec;
if any(isnan(x))
    ind=isnan(x);
    x(ind)=[];
    y(ind)=[];
end
if any(isnan(y))
    ind=isnan(y);
    x(ind)=[];
    y(ind)=[];
end
scatter(x,y)
P=polyfit(x,y,1);
yfit=polyval(P,x);
hold on
plot(x,yfit,'r-.')
title(sprintf('%s, r= %0.2f, pval= %0.4f',regionNames{aa},r,pval))
xlabel(titlex)
ylabel(titley)
hold off
end