function plotPAS(dataPAS)
figure
labels = {'1','2','3','4','NaN'};
indlabels=[1,3,4,6,7];
subplot(1,2,1)
pie([dataPAS(indlabels(1)).meanCount(1),dataPAS(indlabels(2)).meanCount(1),dataPAS(indlabels(3)).meanCount(1),dataPAS(indlabels(4)).meanCount(1),dataPAS(indlabels(5)).meanCount(1)],labels);
set(gca,'FontSize',20);
title('Unconscious')
subplot(1,2,2)
pie([dataPAS(indlabels(1)).meanCount(2),dataPAS(indlabels(2)).meanCount(2),dataPAS(indlabels(3)).meanCount(2),dataPAS(indlabels(4)).meanCount(2),dataPAS(indlabels(5)).meanCount(2)],labels);
set(gca,'FontSize',20);
title('Conscious')
end