function tbl=createResultsTableImageAnalysisFreeViewing(ObjectsResults1,ObjectsResults2,ObjectsResults3,RegionsResults1,RegionsResults2,RegionsResults3,AttributesResults1,AttributesResults2,AttributesResults3)
%find p-values in experiment 1 and 2
p_FV_FPP_1=[ObjectsResults3.pvalFPPObj(1),ObjectsResults3.pvalFPPBg(1),AttributesResults3.pvalFPPAtt(1,3),RegionsResults3.condition(1).pvalFPP];
p_FV_FDPP_1=[ObjectsResults3.pvalFDPPObj(1),ObjectsResults3.pvalFDPPBg(1),AttributesResults3.pvalFDPPAtt(1,3),RegionsResults3.condition(1).pvalFDPP];
p_FV_1=round([p_FV_FPP_1,p_FV_FDPP_1],3);

p_C_FPP_1=[ObjectsResults1.pvalFPPObj(2),ObjectsResults1.pvalFPPBg(2),AttributesResults1.pvalFPPAtt(2,3),RegionsResults1.condition(2).pvalFPP];
p_C_FDPP_1=[ObjectsResults1.pvalFDPPObj(2),ObjectsResults1.pvalFDPPBg(2),AttributesResults1.pvalFDPPAtt(2,3),RegionsResults1.condition(2).pvalFDPP];
p_C_1=round([p_C_FPP_1,p_C_FDPP_1],3);

p_C_FPP_2=[ObjectsResults2.pvalFPPObj(2),ObjectsResults2.pvalFPPBg(2),AttributesResults2.pvalFPPAtt(2,3),RegionsResults2.condition(2).pvalFPP];
p_C_FDPP_2=[ObjectsResults2.pvalFDPPObj(2),ObjectsResults2.pvalFDPPBg(2),AttributesResults2.pvalFDPPAtt(2,3),RegionsResults2.condition(2).pvalFDPP];
p_C_2=round([p_C_FPP_2,p_C_FDPP_2],3);

%find effect sizes in experiment 1 and 2
ES_FV_FPP_1=[ObjectsResults3.effectSizeFPPObj(1),ObjectsResults3.effectSizeFPPBg(1),AttributesResults3.effectSizeFPPAtt(1,3),RegionsResults3.condition(1).effectSizeFPP];
ES_FV_FDPP_1=[ObjectsResults3.effectSizeFDPPObj(1),ObjectsResults3.effectSizeFDPPBg(1),AttributesResults3.effectSizeFDPPAtt(1,3),RegionsResults3.condition(1).effectSizeFDPP];
ES_FV_1=round([ES_FV_FPP_1,ES_FV_FDPP_1],2);

ES_C_FPP_1=[ObjectsResults1.effectSizeFPPObj(2),ObjectsResults1.effectSizeFPPBg(2),AttributesResults1.effectSizeFPPAtt(2,3),RegionsResults1.condition(2).effectSizeFPP];
ES_C_FDPP_1=[ObjectsResults1.effectSizeFDPPObj(2),ObjectsResults1.effectSizeFDPPBg(2),AttributesResults1.effectSizeFDPPAtt(2,3),RegionsResults1.condition(2).effectSizeFDPP];
ES_C_1=round([ES_C_FPP_1,ES_C_FDPP_1],2);

ES_C_FPP_2=[ObjectsResults2.effectSizeFPPObj(2),ObjectsResults2.effectSizeFPPBg(2),AttributesResults2.effectSizeFPPAtt(2,3),RegionsResults2.condition(2).effectSizeFPP];
ES_C_FDPP_2=[ObjectsResults2.effectSizeFDPPObj(2),ObjectsResults2.effectSizeFDPPBg(2),AttributesResults2.effectSizeFDPPAtt(2,3),RegionsResults2.condition(2).effectSizeFDPP];
ES_C_2=round([ES_C_FPP_2,ES_C_FDPP_2],2);

%create table
tbl = table(p_FV_1',ES_FV_1',p_C_1',ES_C_1',p_C_2',ES_C_2','VariableNames',{'FVpval','FVeffectSize','Cpval1','CeffectSize1','Cpval2','CeffectSize2'});
end