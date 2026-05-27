function Results=powerCalculationsAttributes(Results)
%coulumns in this analysis are different attributes, and rows are
%visibility conditions

%Add NaNs to attributes not included in the analysis
Results.FixPerPix_RepAttU(isnan(Results.FixPerPix_PvalAttU))=NaN;
Results.FixPerPix_RepAttC(isnan(Results.FixPerPix_PvalAttC))=NaN;
Results.FixDurPerPix_RepAttU(isnan(Results.FixDurPerPix_PvalAttU))=NaN;
Results.FixDurPerPix_RepAttC(isnan(Results.FixDurPerPix_PvalAttC))=NaN;

%Range of effect sizes, this shows stability
Results.FixPerPix_minEffSAttU=min(Results.FixPerPix_EffectSizeAttU);
Results.FixPerPix_minEffSAttC=min(Results.FixPerPix_EffectSizeAttC);
Results.FixDurPerPix_minEffSAttU=min(Results.FixDurPerPix_EffectSizeAttU);
Results.FixDurPerPix_minEffSAttC=min(Results.FixDurPerPix_EffectSizeAttC);

Results.FixPerPix_maxEffSAttU=max(Results.FixPerPix_EffectSizeAttU);
Results.FixPerPix_maxEffSAttC=max(Results.FixPerPix_EffectSizeAttC);
Results.FixDurPerPix_maxEffSAttU=max(Results.FixDurPerPix_EffectSizeAttU);
Results.FixDurPerPix_maxEffSAttC=max(Results.FixDurPerPix_EffectSizeAttC);

%Proportion of significant iterations
Results.FixPerPix_proportionSignificantAttU=sum(Results.FixPerPix_PvalAttU<0.05)./size(Results.FixPerPix_PvalAttU,1);
Results.FixPerPix_proportionSignificantAttC=sum(Results.FixPerPix_PvalAttC<0.05)./size(Results.FixPerPix_PvalAttC,1);
Results.FixDurPerPix_proportionSignificantAttU=sum(Results.FixDurPerPix_PvalAttU<0.05)./size(Results.FixDurPerPix_PvalAttU,1);
Results.FixDurPerPix_proportionSignificantAttC=sum(Results.FixDurPerPix_PvalAttC<0.05)./size(Results.FixDurPerPix_PvalAttC,1);
end