function Results=powerCalculationsObjects(Results)
%coulumns in this analysis are visibility conditions

%Range of effect sizes, this shows stability
Results.FixPerPix_minEffSObj=min(Results.FixPerPix_EffectSizeObj);
Results.FixPerPix_minEffSBg=min(Results.FixPerPix_EffectSizeBg);
Results.FixDurPerPix_minEffSObj=min(Results.FixDurPerPix_EffectSizeObj);
Results.FixDurPerPix_minEffSBg=min(Results.FixDurPerPix_EffectSizeBg);

Results.FixPerPix_maxEffSObj=max(Results.FixPerPix_EffectSizeObj);
Results.FixPerPix_maxEffSBg=max(Results.FixPerPix_EffectSizeBg);
Results.FixDurPerPix_maxEffSObj=max(Results.FixDurPerPix_EffectSizeObj);
Results.FixDurPerPix_maxEffSBg=max(Results.FixDurPerPix_EffectSizeBg);

%Proportion of significant iterations
Results.FixPerPix_proportionSignificantObj=sum(Results.FixPerPix_PvalObj<0.05)./size(Results.FixPerPix_PvalObj,1);
Results.FixPerPix_proportionSignificantBg=sum(Results.FixPerPix_PvalBg<0.05)./size(Results.FixPerPix_PvalBg,1);
Results.FixDurPerPix_proportionSignificantObj=sum(Results.FixDurPerPix_PvalObj<0.05)./size(Results.FixDurPerPix_PvalObj,1);
Results.FixDurPerPix_proportionSignificantBg=sum(Results.FixDurPerPix_PvalBg<0.05)./size(Results.FixDurPerPix_PvalBg,1);
end