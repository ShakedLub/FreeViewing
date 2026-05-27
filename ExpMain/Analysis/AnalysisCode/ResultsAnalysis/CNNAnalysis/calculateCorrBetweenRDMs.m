function [rho,subRho]=calculateCorrBetweenRDMs(FixMaps,Activations)
%initialize rhoCNN
rho=NaN(size(FixMaps.condition,2),size(Activations.layer,2));

for cc=1:size(FixMaps.condition,2) %conditions
     %compute spearman correlation
        RDM1=FixMaps.condition(cc).RDM;
        %zeros in diagonal
        RDM1(1:1+size(RDM1,1):end) = 0;
        %converts a square symmetric matrix with zeros along the diagonal,
        % into a vector containing the elements below the diagonal
        RDMvec1 = squareform(RDM1);
    for ll=1:size(Activations.layer,2) %layer
        RDM2=Activations.layer(ll).RDM;
        %zeros in diagonal
        RDM2(1:1+size(RDM2,1):end) = 0;
        %converts a square symmetric matrix with zeros along the diagonal,
        % into a vector containing the elements below the diagonal
        RDMvec2 = squareform(RDM2);

        rho(cc,ll)=1-corr(RDMvec1',RDMvec2','type','Spearman');
    end
end
subRho=rho(1,:)-rho(2,:);
end