function Results=jackknifeCalculationsRegions(Results,RegionsSummary)
%coulumns in this analysis are different regions

%original estimate
Results.FixPerPixU=RegionsSummary.condition(1).FixPerPix;
Results.FixPerPixC=RegionsSummary.condition(2).FixPerPix;
Results.FixDurPerPixU=RegionsSummary.condition(1).FixDurPerPix;
Results.FixDurPerPixC=RegionsSummary.condition(2).FixDurPerPix;

Results.pvalFPPU=RegionsSummary.condition(1).pvalFPP;
Results.pvalFPPC=RegionsSummary.condition(2).pvalFPP;
Results.pvalFDPPU=RegionsSummary.condition(1).pvalFDPP;
Results.pvalFDPPC=RegionsSummary.condition(2).pvalFDPP;

Results.effectSizeFPPU=RegionsSummary.condition(1).effectSizeFPP;
Results.effectSizeFPPC=RegionsSummary.condition(2).effectSizeFPP;
Results.effectSizeFDPPU=RegionsSummary.condition(1).effectSizeFDPP;
Results.effectSizeFDPPC=RegionsSummary.condition(2).effectSizeFDPP;

%jackknife estimate
Results.FixPerPix_jackknifeEstimateU=mean(Results.FixPerPix_jackknifeRepU);
Results.FixPerPix_jackknifeEstimateC=mean(Results.FixPerPix_jackknifeRepC);
Results.FixDurPerPix_jackknifeEstimateU=mean(Results.FixDurPerPix_jackknifeRepU);
Results.FixDurPerPix_jackknifeEstimateC=mean(Results.FixDurPerPix_jackknifeRepC);

%bias estimate
numSubj=size(Results.FixPerPix_jackknifeRepU,1);
Results.FixPerPix_jackknifeBiasEstimateU=(numSubj-1)*(Results.FixPerPix_jackknifeEstimateU-Results.FixPerPixU);
Results.FixPerPix_jackknifeBiasEstimateC=(numSubj-1)*(Results.FixPerPix_jackknifeEstimateC-Results.FixPerPixC);
Results.FixDurPerPix_jackknifeBiasEstimateU=(numSubj-1)*(Results.FixDurPerPix_jackknifeEstimateU-Results.FixDurPerPixU);
Results.FixDurPerPix_jackknifeBiasEstimateC=(numSubj-1)*(Results.FixDurPerPix_jackknifeEstimateC-Results.FixDurPerPixC);

%bias corrected estimate
Results.FixPerPix_EstCorrU=Results.FixPerPixU-Results.FixPerPix_jackknifeBiasEstimateU;
Results.FixPerPix_EstCorrC=Results.FixPerPixC-Results.FixPerPix_jackknifeBiasEstimateC;
Results.FixDurPerPix_EstCorrU=Results.FixDurPerPixU-Results.FixDurPerPix_jackknifeBiasEstimateU;
Results.FixDurPerPix_EstCorrC=Results.FixDurPerPixC-Results.FixDurPerPix_jackknifeBiasEstimateC;

%jackknife variance
Results.FixPerPix_jackknifeVarU=sum((Results.FixPerPix_jackknifeRepU-repmat(Results.FixPerPix_jackknifeEstimateU,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixPerPix_jackknifeVarC=sum((Results.FixPerPix_jackknifeRepC-repmat(Results.FixPerPix_jackknifeEstimateC,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixDurPerPix_jackknifeVarU=sum((Results.FixDurPerPix_jackknifeRepU-repmat(Results.FixDurPerPix_jackknifeEstimateU,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixDurPerPix_jackknifeVarC=sum((Results.FixDurPerPix_jackknifeRepC-repmat(Results.FixDurPerPix_jackknifeEstimateC,numSubj,1)).^2)*((numSubj-1)/numSubj);

%jackknife standard error, used to quantify the uncertainty of your
%estimate. This is the stability estimate
Results.FixPerPix_jackknifeSTEU=sqrt(Results.FixPerPix_jackknifeVarU);
Results.FixPerPix_jackknifeSTEC=sqrt(Results.FixPerPix_jackknifeVarC);
Results.FixDurPerPix_jackknifeSTEU=sqrt(Results.FixDurPerPix_jackknifeVarU);
Results.FixDurPerPix_jackknifeSTEC=sqrt(Results.FixDurPerPix_jackknifeVarC);

%Range of effect sizes, this shows stability
Results.FixPerPix_minEffSU=min(Results.FixPerPix_jackknifeEffectSizeU);
Results.FixPerPix_minEffSC=min(Results.FixPerPix_jackknifeEffectSizeC);
Results.FixDurPerPix_minEffSU=min(Results.FixDurPerPix_jackknifeEffectSizeU);
Results.FixDurPerPix_minEffSC=min(Results.FixDurPerPix_jackknifeEffectSizeC);

Results.FixPerPix_maxEffSU=max(Results.FixPerPix_jackknifeEffectSizeU);
Results.FixPerPix_maxEffSC=max(Results.FixPerPix_jackknifeEffectSizeC);
Results.FixDurPerPix_maxEffSU=max(Results.FixDurPerPix_jackknifeEffectSizeU);
Results.FixDurPerPix_maxEffSC=max(Results.FixDurPerPix_jackknifeEffectSizeC);

%Proportion of significant iterations: this tells you if a result depends
%on a single participant
Results.FixPerPix_proportionSignificantU=sum(Results.FixPerPix_jackknifePvalU<0.05)./size(Results.FixPerPix_jackknifePvalU,1);
Results.FixPerPix_proportionSignificantC=sum(Results.FixPerPix_jackknifePvalC<0.05)./size(Results.FixPerPix_jackknifePvalC,1);
Results.FixDurPerPix_proportionSignificantU=sum(Results.FixDurPerPix_jackknifePvalU<0.05)./size(Results.FixDurPerPix_jackknifePvalU,1);
Results.FixDurPerPix_proportionSignificantC=sum(Results.FixDurPerPix_jackknifePvalC<0.05)./size(Results.FixDurPerPix_jackknifePvalC,1);

%maximal influence: shows if any participant strongly shifts the result
Results.FixPerPix_maxInfU=max(abs(Results.FixPerPix_jackknifeRepU-repmat(Results.FixPerPixU,numSubj,1)));
Results.FixPerPix_maxInfC=max(abs(Results.FixPerPix_jackknifeRepC-repmat(Results.FixPerPixC,numSubj,1)));
Results.FixDurPerPix_maxInfU=max(abs(Results.FixDurPerPix_jackknifeRepU-repmat(Results.FixDurPerPixU,numSubj,1)));
Results.FixDurPerPix_maxInfC=max(abs(Results.FixDurPerPix_jackknifeRepC-repmat(Results.FixDurPerPixC,numSubj,1)));
end