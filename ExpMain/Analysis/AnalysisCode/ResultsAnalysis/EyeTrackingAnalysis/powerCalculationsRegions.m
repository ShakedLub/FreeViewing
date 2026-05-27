function Results=powerCalculationsRegions(Results)
%coulumns in this analysis are different regions

%Range of effect sizes, this shows stability
Results.FixPerPix_minEffSU=min(Results.FixPerPix_EffectSizeU);
Results.FixPerPix_minEffSC=min(Results.FixPerPix_EffectSizeC);
Results.FixDurPerPix_minEffSU=min(Results.FixDurPerPix_EffectSizeU);
Results.FixDurPerPix_minEffSC=min(Results.FixDurPerPix_EffectSizeC);

Results.FixPerPix_maxEffSU=max(Results.FixPerPix_EffectSizeU);
Results.FixPerPix_maxEffSC=max(Results.FixPerPix_EffectSizeC);
Results.FixDurPerPix_maxEffSU=max(Results.FixDurPerPix_EffectSizeU);
Results.FixDurPerPix_maxEffSC=max(Results.FixDurPerPix_EffectSizeC);

%Proportion of significant iterations
Results.FixPerPix_proportionSignificantU=sum(Results.FixPerPix_PvalU<0.05)./size(Results.FixPerPix_PvalU,1);
Results.FixPerPix_proportionSignificantC=sum(Results.FixPerPix_PvalC<0.05)./size(Results.FixPerPix_PvalC,1);
Results.FixDurPerPix_proportionSignificantU=sum(Results.FixDurPerPix_PvalU<0.05)./size(Results.FixDurPerPix_PvalU,1);
Results.FixDurPerPix_proportionSignificantC=sum(Results.FixDurPerPix_PvalC<0.05)./size(Results.FixDurPerPix_PvalC,1);
end