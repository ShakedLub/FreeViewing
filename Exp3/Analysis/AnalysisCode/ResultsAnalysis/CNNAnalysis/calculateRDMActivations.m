function Activations=calculateRDMActivations(Activations)
for ll=1:length(Activations.LayerNames)
    for ii=1:length(Activations.ImageNames) %image1
        for jj=1:length(Activations.ImageNames) %image2
            Activations.layer(ll).RDM(ii,jj)=1-corr(Activations.imageActivations{ii}{ll}(:),Activations.imageActivations{jj}{ll}(:));
        end
    end
end
end