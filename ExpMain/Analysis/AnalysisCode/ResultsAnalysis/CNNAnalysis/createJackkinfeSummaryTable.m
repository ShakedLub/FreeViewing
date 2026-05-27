function tbl=createJackkinfeSummaryTable(jackKnife)

numLayer=1:25;

pval_U=round(jackKnife.pvalRho(1,:),3);
d_U=round(jackKnife.effectSizeRho(1,:),2);
perSig_U=round(jackKnife.Rho_proportionSignificant(1,:)*100,2);
minEffSize_U=round(jackKnife.Rho_minEffS(1,:),2);
maxEffSize_U=round(jackKnife.Rho_maxEffS(1,:),2);
jackStdErr_U=round(jackKnife.Rho_jackknifeSTE(1,:),2);

pval_C=round(jackKnife.pvalRho(2,:),3);
d_C=round(jackKnife.effectSizeRho(2,:),2);
perSig_C=round(jackKnife.Rho_proportionSignificant(2,:)*100,2);
minEffSize_C=round(jackKnife.Rho_minEffS(2,:),2);
maxEffSize_C=round(jackKnife.Rho_maxEffS(2,:),2);
jackStdErr_C=round(jackKnife.Rho_jackknifeSTE(2,:),2);

pval_sub=round(jackKnife.pvalsubRho,3);
d_sub=round(jackKnife.effectSizesubRho,2);
perSig_sub=round(jackKnife.subRho_proportionSignificant*100,2);
minEffSize_sub=round(jackKnife.subRho_minEffS,2);
maxEffSize_sub=round(jackKnife.subRho_maxEffS,2);
jackStdErr_sub=round(jackKnife.subRho_jackknifeSTE,2);

%% Create table
tbl = table(numLayer',pval_U',d_U',perSig_U',minEffSize_U',maxEffSize_U',jackStdErr_U',pval_C',d_C',perSig_C',minEffSize_C',maxEffSize_C',jackStdErr_C',pval_sub',d_sub',perSig_sub',minEffSize_sub',maxEffSize_sub',jackStdErr_sub','VariableNames',{'numLayer','pval_U','d_U','perSig_U','minEffSize_U','maxEffSize_U','jackStdErr_U','pval_C','d_C','perSig_C','minEffSize_C','maxEffSize_C','jackStdErr_C','pval_sub','d_sub','perSig_sub','minEffSize_sub','maxEffSize_sub','jackStdErr_sub'});
end
