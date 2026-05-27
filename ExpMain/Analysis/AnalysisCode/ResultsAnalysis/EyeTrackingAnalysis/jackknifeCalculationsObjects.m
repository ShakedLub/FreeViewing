function Results=jackknifeCalculationsObjects(Results,ObjectsSummary)
%coulumns in this analysis are visibility conditions

%original estimate
Results.FixPerPixObj=ObjectsSummary.FixPerPixObj;
Results.FixPerPixBg=ObjectsSummary.FixPerPixBg;
Results.FixDurPerPixObj=ObjectsSummary.FixDurPerPixObj;
Results.FixDurPerPixBg=ObjectsSummary.FixDurPerPixBg;

Results.pvalFPPObj=ObjectsSummary.pvalFPPObj;
Results.pvalFPPBg=ObjectsSummary.pvalFPPBg;
Results.pvalFDPPObj=ObjectsSummary.pvalFDPPObj;
Results.pvalFDPPBg=ObjectsSummary.pvalFDPPBg;

Results.effectSizeFPPObj=ObjectsSummary.effectSizeFPPObj;
Results.effectSizeFPPBg=ObjectsSummary.effectSizeFPPBg;
Results.effectSizeFDPPObj=ObjectsSummary.effectSizeFDPPObj;
Results.effectSizeFDPPBg=ObjectsSummary.effectSizeFDPPBg;

%jackknife estimate
Results.FixPerPix_jackknifeEstimateObj=mean(Results.FixPerPix_jackknifeRepObj);
Results.FixPerPix_jackknifeEstimateBg=mean(Results.FixPerPix_jackknifeRepBg);
Results.FixDurPerPix_jackknifeEstimateObj=mean(Results.FixDurPerPix_jackknifeRepObj);
Results.FixDurPerPix_jackknifeEstimateBg=mean(Results.FixDurPerPix_jackknifeRepBg);

%bias estimate
numSubj=size(Results.FixPerPix_jackknifeRepObj,1);
Results.FixPerPix_jackknifeBiasEstimateObj=(numSubj-1)*(Results.FixPerPix_jackknifeEstimateObj-Results.FixPerPixObj);
Results.FixPerPix_jackknifeBiasEstimateBg=(numSubj-1)*(Results.FixPerPix_jackknifeEstimateBg-Results.FixPerPixBg);
Results.FixDurPerPix_jackknifeBiasEstimateObj=(numSubj-1)*(Results.FixDurPerPix_jackknifeEstimateObj-Results.FixDurPerPixObj);
Results.FixDurPerPix_jackknifeBiasEstimateBg=(numSubj-1)*(Results.FixDurPerPix_jackknifeEstimateBg-Results.FixDurPerPixBg);

%bias corrected estimate
Results.FixPerPix_EstCorrObj=Results.FixPerPixObj-Results.FixPerPix_jackknifeBiasEstimateObj;
Results.FixPerPix_EstCorrBg=Results.FixPerPixBg-Results.FixPerPix_jackknifeBiasEstimateBg;
Results.FixDurPerPix_EstCorrObj=Results.FixDurPerPixObj-Results.FixDurPerPix_jackknifeBiasEstimateObj;
Results.FixDurPerPix_EstCorrBg=Results.FixDurPerPixBg-Results.FixDurPerPix_jackknifeBiasEstimateBg;

%jackknife variance
Results.FixPerPix_jackknifeVarObj=sum((Results.FixPerPix_jackknifeRepObj-repmat(Results.FixPerPix_jackknifeEstimateObj,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixPerPix_jackknifeVarBg=sum((Results.FixPerPix_jackknifeRepBg-repmat(Results.FixPerPix_jackknifeEstimateBg,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixDurPerPix_jackknifeVarObj=sum((Results.FixDurPerPix_jackknifeRepObj-repmat(Results.FixDurPerPix_jackknifeEstimateObj,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixDurPerPix_jackknifeVarBg=sum((Results.FixDurPerPix_jackknifeRepBg-repmat(Results.FixDurPerPix_jackknifeEstimateBg,numSubj,1)).^2)*((numSubj-1)/numSubj);

%jackknife standard error, used to quantify the uncertainty of your estimate. This is the stability estimate
Results.FixPerPix_jackknifeSTEObj=sqrt(Results.FixPerPix_jackknifeVarObj);
Results.FixPerPix_jackknifeSTEBg=sqrt(Results.FixPerPix_jackknifeVarBg);
Results.FixDurPerPix_jackknifeSTEObj=sqrt(Results.FixDurPerPix_jackknifeVarObj);
Results.FixDurPerPix_jackknifeSTEBg=sqrt(Results.FixDurPerPix_jackknifeVarBg);

%Range of effect sizes, this shows stability
Results.FixPerPix_minEffSObj=min(Results.FixPerPix_jackknifeEffectSizeObj);
Results.FixPerPix_minEffSBg=min(Results.FixPerPix_jackknifeEffectSizeBg);
Results.FixDurPerPix_minEffSObj=min(Results.FixDurPerPix_jackknifeEffectSizeObj);
Results.FixDurPerPix_minEffSBg=min(Results.FixDurPerPix_jackknifeEffectSizeBg);

Results.FixPerPix_maxEffSObj=max(Results.FixPerPix_jackknifeEffectSizeObj);
Results.FixPerPix_maxEffSBg=max(Results.FixPerPix_jackknifeEffectSizeBg);
Results.FixDurPerPix_maxEffSObj=max(Results.FixDurPerPix_jackknifeEffectSizeObj);
Results.FixDurPerPix_maxEffSBg=max(Results.FixDurPerPix_jackknifeEffectSizeBg);

%Proportion of significant iterations: this tells you if a result depends
%on a single participant
Results.FixPerPix_proportionSignificantObj=sum(Results.FixPerPix_jackknifePvalObj<0.05)./size(Results.FixPerPix_jackknifePvalObj,1);
Results.FixPerPix_proportionSignificantBg=sum(Results.FixPerPix_jackknifePvalBg<0.05)./size(Results.FixPerPix_jackknifePvalBg,1);
Results.FixDurPerPix_proportionSignificantObj=sum(Results.FixDurPerPix_jackknifePvalObj<0.05)./size(Results.FixDurPerPix_jackknifePvalObj,1);
Results.FixDurPerPix_proportionSignificantBg=sum(Results.FixDurPerPix_jackknifePvalBg<0.05)./size(Results.FixDurPerPix_jackknifePvalBg,1);

%maximal influence: shows if any participant strongly shifts the result
Results.FixPerPix_maxInfObj=max(abs(Results.FixPerPix_jackknifeRepObj-repmat(Results.FixPerPixObj,numSubj,1)));
Results.FixPerPix_maxInfBg=max(abs(Results.FixPerPix_jackknifeRepBg-repmat(Results.FixPerPixBg,numSubj,1)));
Results.FixDurPerPix_maxInfObj=max(abs(Results.FixDurPerPix_jackknifeRepObj-repmat(Results.FixDurPerPixObj,numSubj,1)));
Results.FixDurPerPix_maxInfBg=max(abs(Results.FixDurPerPix_jackknifeRepBg-repmat(Results.FixDurPerPixBg,numSubj,1)));
end