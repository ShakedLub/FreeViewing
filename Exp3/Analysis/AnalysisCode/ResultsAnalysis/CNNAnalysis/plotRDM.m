function plotRDM(FixMaps,Activations)
figure('units','normalized','outerposition',[0 0 1 1])
rows=ceil(sqrt(size(Activations.layer,2)+2));
columns=rows;
if rows*(columns-1)+1>size(Activations.layer,2)+2
    columns=rows-1;
end

%clims = [0 2]; %the resutls are not supposed to be above 2.

tcl=tiledlayout(rows,columns);

%Plot unconscious condition
nexttile()
imagesc(FixMaps.condition(1).RDM)%,clims)
title('Unconscious condition')
set(gca,'FontSize',14)

%Plot conscious condition
nexttile()
imagesc(FixMaps.condition(2).RDM)%,clims)
title('Conscious condition')
set(gca,'FontSize',14)

%Plot layers
for ii=1:size(Activations.layer,2) %layers
    nexttile()
    imagesc(Activations.layer(ii).RDM)%,clims)
    title(Activations.LayerNamesShort{ii})
    set(gca,'FontSize',14)
end
cb=colorbar();
cb.Layout.Tile='east';
end