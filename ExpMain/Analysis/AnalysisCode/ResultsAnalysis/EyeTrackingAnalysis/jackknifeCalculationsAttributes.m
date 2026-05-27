function Results=jackknifeCalculationsAttributes(Results,AttributesSummary)
%coulumns in this analysis are different attributes, and rows are
%visibility conditions

%original estimate
Results.FixPerPixAtt=AttributesSummary.FixPerPixAtt;
Results.FixDurPerPixAtt=AttributesSummary.FixDurPerPixAtt;

Results.pvalFPPAtt=AttributesSummary.pvalFPPAtt;
Results.pvalFDPPAtt=AttributesSummary.pvalFDPPAtt;

Results.effectSizeFPPAtt=AttributesSummary.effectSizeFPPAtt;
Results.effectSizeFDPPAtt=AttributesSummary.effectSizeFDPPAtt;

%Add NaNs to attributes not included in the analysis
Results.FixPerPixAtt(isnan(Results.pvalFPPAtt))=NaN;
Results.FixDurPerPixAtt(isnan(Results.pvalFDPPAtt))=NaN;

Results.FixPerPix_jackknifeRepAttU(isnan(Results.FixPerPix_jackknifePvalAttU))=NaN;
Results.FixPerPix_jackknifeRepAttC(isnan(Results.FixPerPix_jackknifePvalAttC))=NaN;
Results.FixDurPerPix_jackknifeRepAttU(isnan(Results.FixDurPerPix_jackknifePvalAttU))=NaN;
Results.FixDurPerPix_jackknifeRepAttC(isnan(Results.FixDurPerPix_jackknifePvalAttC))=NaN;

%jackknife estimate
Results.FixPerPix_jackknifeEstimateAttU=mean(Results.FixPerPix_jackknifeRepAttU);
Results.FixPerPix_jackknifeEstimateAttC=mean(Results.FixPerPix_jackknifeRepAttC);
Results.FixDurPerPix_jackknifeEstimateAttU=mean(Results.FixDurPerPix_jackknifeRepAttU);
Results.FixDurPerPix_jackknifeEstimateAttC=mean(Results.FixDurPerPix_jackknifeRepAttC);

%bias estimate
numSubj=size(Results.FixPerPix_jackknifeRepAttU,1);
Results.FixPerPix_jackknifeBiasEstimateAttU=(numSubj-1)*(Results.FixPerPix_jackknifeEstimateAttU-Results.FixPerPixAtt(1,:));
Results.FixPerPix_jackknifeBiasEstimateAttC=(numSubj-1)*(Results.FixPerPix_jackknifeEstimateAttC-Results.FixPerPixAtt(2,:));
Results.FixDurPerPix_jackknifeBiasEstimateAttU=(numSubj-1)*(Results.FixDurPerPix_jackknifeEstimateAttU-Results.FixDurPerPixAtt(1,:));
Results.FixDurPerPix_jackknifeBiasEstimateAttC=(numSubj-1)*(Results.FixDurPerPix_jackknifeEstimateAttC-Results.FixDurPerPixAtt(2,:));

%bias corrected estimate
Results.FixPerPix_EstCorrAttU=Results.FixPerPixAtt(1,:)-Results.FixPerPix_jackknifeBiasEstimateAttU;
Results.FixPerPix_EstCorrAttC=Results.FixPerPixAtt(2,:)-Results.FixPerPix_jackknifeBiasEstimateAttC;
Results.FixDurPerPix_EstCorrAttU=Results.FixDurPerPixAtt(1,:)-Results.FixDurPerPix_jackknifeBiasEstimateAttU;
Results.FixDurPerPix_EstCorrAttC=Results.FixDurPerPixAtt(2,:)-Results.FixDurPerPix_jackknifeBiasEstimateAttC;

%jackknife variance
Results.FixPerPix_jackknifeVarAttU=sum((Results.FixPerPix_jackknifeRepAttU-repmat(Results.FixPerPix_jackknifeEstimateAttU,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixPerPix_jackknifeVarAttC=sum((Results.FixPerPix_jackknifeRepAttC-repmat(Results.FixPerPix_jackknifeEstimateAttC,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixDurPerPix_jackknifeVarAttU=sum((Results.FixDurPerPix_jackknifeRepAttU-repmat(Results.FixDurPerPix_jackknifeEstimateAttU,numSubj,1)).^2)*((numSubj-1)/numSubj);
Results.FixDurPerPix_jackknifeVarAttC=sum((Results.FixDurPerPix_jackknifeRepAttC-repmat(Results.FixDurPerPix_jackknifeEstimateAttC,numSubj,1)).^2)*((numSubj-1)/numSubj);

%jackknife standard error, used to quantify the uncertainty of your estimate.
%This is the stability estimate
Results.FixPerPix_jackknifeSTEAttU=sqrt(Results.FixPerPix_jackknifeVarAttU);
Results.FixPerPix_jackknifeSTEAttC=sqrt(Results.FixPerPix_jackknifeVarAttC);
Results.FixDurPerPix_jackknifeSTEAttU=sqrt(Results.FixDurPerPix_jackknifeVarAttU);
Results.FixDurPerPix_jackknifeSTEAttC=sqrt(Results.FixDurPerPix_jackknifeVarAttC);

%Range of effect sizes, this shows stability
Results.FixPerPix_minEffSAttU=min(Results.FixPerPix_jackknifeEffectSizeAttU);
Results.FixPerPix_minEffSAttC=min(Results.FixPerPix_jackknifeEffectSizeAttC);
Results.FixDurPerPix_minEffSAttU=min(Results.FixDurPerPix_jackknifeEffectSizeAttU);
Results.FixDurPerPix_minEffSAttC=min(Results.FixDurPerPix_jackknifeEffectSizeAttC);

Results.FixPerPix_maxEffSAttU=max(Results.FixPerPix_jackknifeEffectSizeAttU);
Results.FixPerPix_maxEffSAttC=max(Results.FixPerPix_jackknifeEffectSizeAttC);
Results.FixDurPerPix_maxEffSAttU=max(Results.FixDurPerPix_jackknifeEffectSizeAttU);
Results.FixDurPerPix_maxEffSAttC=max(Results.FixDurPerPix_jackknifeEffectSizeAttC);

%Proportion of significant iterations: this tells you if a result depends
%on a single participant
Results.FixPerPix_proportionSignificantAttU=sum(Results.FixPerPix_jackknifePvalAttU<0.05)./size(Results.FixPerPix_jackknifePvalAttU,1);
Results.FixPerPix_proportionSignificantAttC=sum(Results.FixPerPix_jackknifePvalAttC<0.05)./size(Results.FixPerPix_jackknifePvalAttC,1);
Results.FixDurPerPix_proportionSignificantAttU=sum(Results.FixDurPerPix_jackknifePvalAttU<0.05)./size(Results.FixDurPerPix_jackknifePvalAttU,1);
Results.FixDurPerPix_proportionSignificantAttC=sum(Results.FixDurPerPix_jackknifePvalAttC<0.05)./size(Results.FixDurPerPix_jackknifePvalAttC,1);

%maximal influence: shows if any participant strongly shifts the result
Results.FixPerPix_maxInfAttU=max(abs(Results.FixPerPix_jackknifeRepAttU-repmat(Results.FixPerPixAtt(1,:),numSubj,1)));
Results.FixPerPix_maxInfAttC=max(abs(Results.FixPerPix_jackknifeRepAttC-repmat(Results.FixPerPixAtt(2,:),numSubj,1)));
Results.FixDurPerPix_maxInfAttU=max(abs(Results.FixDurPerPix_jackknifeRepAttU-repmat(Results.FixDurPerPixAtt(1,:),numSubj,1)));
Results.FixDurPerPix_maxInfAttC=max(abs(Results.FixDurPerPix_jackknifeRepAttC-repmat(Results.FixDurPerPixAtt(2,:),numSubj,1)));
end