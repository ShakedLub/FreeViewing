function jackKnife=jackknifeCalculationsCNN(jackKnife,Paths)
%coulumns in this analysis are different layers, rows are different
%visibility condition (1 U, 2 C)

%Load original results of all participants
load([Paths.ResultsStructsRSAOriginal,'\Results_RemoveCenterBias.mat'])
load([Paths.ResultsStructsRSAOriginal,'\ResultsTreeBH.mat'])

%original estimate
jackKnife.Rho=Results.Rho;
jackKnife.subRho=Results.subRho;

[jackKnife.pvalRho,jackKnife.pvalsubRho]=extractPvalFromTree(ResultsTreeBH,Results);

jackKnife.effectSizeRho=Results.effectSize;
jackKnife.effectSizesubRho=Results.effectSizeSub;

%Update subRho to include only values that are significant in
%the conscious or unconscious condition in the real data
jackKnife.subRho(isnan(jackKnife.pvalsubRho))=NaN;  

%Update subRho_jackknifeRep to include only values that are significant in
%the conscious or unconscious condition in the missing n-1 data
jackKnife.subRho_jackknifeRep(isnan(jackKnife.subRho_jackknifePval))=NaN;  

%jackknife estimate
jackKnife.Rho_jackknifeEstimate=mean(jackKnife.Rho_jackknifeRep,3);
jackKnife.subRho_jackknifeEstimate=mean(jackKnife.subRho_jackknifeRep,"omitnan");

%bias estimate
numSubj=size(jackKnife.subRho_jackknifeRep,1);
jackKnife.Rho_jackknifeBiasEstimate=(numSubj-1)*(jackKnife.Rho_jackknifeEstimate-jackKnife.Rho);
numSubjPerLayer=sum(~isnan(jackKnife.subRho_jackknifeRep));
jackKnife.subRho_jackknifeBiasEstimate=(numSubjPerLayer-1).*(jackKnife.subRho_jackknifeEstimate-jackKnife.subRho);

jackKnife.subRho_numSubjPerLayer=numSubjPerLayer;

%bias corrected estimate
jackKnife.Rho_EstCorr=jackKnife.Rho-jackKnife.Rho_jackknifeBiasEstimate;
jackKnife.subRho_EstCorr=jackKnife.subRho-jackKnife.subRho_jackknifeBiasEstimate;

%jackknife variance
jackKnife.Rho_jackknifeVar=sum((jackKnife.Rho_jackknifeRep-repmat(jackKnife.Rho_jackknifeEstimate,1,1,numSubj)).^2,3)*((numSubj-1)/numSubj);
jackKnife.subRho_jackknifeVar=sum((jackKnife.subRho_jackknifeRep-repmat(jackKnife.subRho_jackknifeEstimate,numSubj,1)).^2,"omitnan").*((numSubjPerLayer-1)./numSubjPerLayer);

%jackknife standard error, used to quantify the uncertainty of your
%estimate. This is the stability estimate
jackKnife.Rho_jackknifeSTE=sqrt(jackKnife.Rho_jackknifeVar);
jackKnife.subRho_jackknifeSTE=sqrt(jackKnife.subRho_jackknifeVar);

%Range of effect sizes, this shows stability
jackKnife.Rho_minEffS=min(jackKnife.Rho_jackknifeEffectSize,[],3);
jackKnife.subRho_minEffS=min(jackKnife.subRho_jackknifeEffectSize,[],"omitnan");

jackKnife.Rho_maxEffS=max(jackKnife.Rho_jackknifeEffectSize,[],3);
jackKnife.subRho_maxEffS=max(jackKnife.subRho_jackknifeEffectSize,[],"omitnan");

%Proportion of significant iterations: this tells you if a result depends
%on a single participant
jackKnife.Rho_proportionSignificant=sum(jackKnife.Rho_jackknifePval<0.05,3)./numSubj;
jackKnife.subRho_proportionSignificant=sum(jackKnife.subRho_jackknifePval<0.05,"omitnan")./numSubjPerLayer;

%maximal influence: shows if any participant strongly shifts the result
jackKnife.Rho_maxInf=max(abs(jackKnife.Rho_jackknifeRep-repmat(jackKnife.Rho,1,1,numSubj)),[],3);
jackKnife.subRho_maxInf=max(abs(jackKnife.subRho_jackknifeRep-repmat(jackKnife.subRho,numSubj,1)),[],"omitnan");
end