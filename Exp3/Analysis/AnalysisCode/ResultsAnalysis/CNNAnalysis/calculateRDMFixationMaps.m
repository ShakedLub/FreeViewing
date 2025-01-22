function FixMaps=calculateRDMFixationMaps(FixMaps)
%calcualte RDM 
numCond=length(FixMaps.FM{1});
for cc=1:numCond %conditions
    for ii=1:length(FixMaps.ImName) %image1
        for jj=1:length(FixMaps.ImName) %image2
            FixMaps.condition(cc).RDM(ii,jj)=1-corr(FixMaps.FM{ii}{cc}(:),FixMaps.FM{jj}{cc}(:));
        end
    end
end
end