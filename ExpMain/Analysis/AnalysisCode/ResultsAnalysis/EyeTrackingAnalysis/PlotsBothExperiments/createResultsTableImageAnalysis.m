function tbl=createResultsTableImageAnalysis(ObjectsResults1,ObjectsResults2,RegionsResults1,RegionsResults2,AttributesResults1,AttributesResults2)
%find p-values in experiment 1 and 2
p_U_FPP_1=[ObjectsResults1.pvalFPPObj(1),ObjectsResults1.pvalFPPBg(1),AttributesResults1.pvalFPPAtt(1,3),RegionsResults1.condition(1).pvalFPP];
p_U_FDPP_1=[ObjectsResults1.pvalFDPPObj(1),ObjectsResults1.pvalFDPPBg(1),AttributesResults1.pvalFDPPAtt(1,3),RegionsResults1.condition(1).pvalFDPP];
p_U_1=round([p_U_FPP_1,p_U_FDPP_1],3);

p_C_FPP_1=[ObjectsResults1.pvalFPPObj(2),ObjectsResults1.pvalFPPBg(2),AttributesResults1.pvalFPPAtt(2,3),RegionsResults1.condition(2).pvalFPP];
p_C_FDPP_1=[ObjectsResults1.pvalFDPPObj(2),ObjectsResults1.pvalFDPPBg(2),AttributesResults1.pvalFDPPAtt(2,3),RegionsResults1.condition(2).pvalFDPP];
p_C_1=round([p_C_FPP_1,p_C_FDPP_1],3);

p_U_FPP_2=[ObjectsResults2.pvalFPPObj(1),ObjectsResults2.pvalFPPBg(1),AttributesResults2.pvalFPPAtt(1,3),RegionsResults2.condition(1).pvalFPP];
p_U_FDPP_2=[ObjectsResults2.pvalFDPPObj(1),ObjectsResults2.pvalFDPPBg(1),AttributesResults2.pvalFDPPAtt(1,3),RegionsResults2.condition(1).pvalFDPP];
p_U_2=round([p_U_FPP_2,p_U_FDPP_2],3);

p_C_FPP_2=[ObjectsResults2.pvalFPPObj(2),ObjectsResults2.pvalFPPBg(2),AttributesResults2.pvalFPPAtt(2,3),RegionsResults2.condition(2).pvalFPP];
p_C_FDPP_2=[ObjectsResults2.pvalFDPPObj(2),ObjectsResults2.pvalFDPPBg(2),AttributesResults2.pvalFDPPAtt(2,3),RegionsResults2.condition(2).pvalFDPP];
p_C_2=round([p_C_FPP_2,p_C_FDPP_2],3);

%find effect sizes in experiment 1 and 2
ES_U_FPP_1=[ObjectsResults1.effectSizeFPPObj(1),ObjectsResults1.effectSizeFPPBg(1),AttributesResults1.effectSizeFPPAtt(1,3),RegionsResults1.condition(1).effectSizeFPP];
ES_U_FDPP_1=[ObjectsResults1.effectSizeFDPPObj(1),ObjectsResults1.effectSizeFDPPBg(1),AttributesResults1.effectSizeFDPPAtt(1,3),RegionsResults1.condition(1).effectSizeFDPP];
ES_U_1=round([ES_U_FPP_1,ES_U_FDPP_1],2);

ES_C_FPP_1=[ObjectsResults1.effectSizeFPPObj(2),ObjectsResults1.effectSizeFPPBg(2),AttributesResults1.effectSizeFPPAtt(2,3),RegionsResults1.condition(2).effectSizeFPP];
ES_C_FDPP_1=[ObjectsResults1.effectSizeFDPPObj(2),ObjectsResults1.effectSizeFDPPBg(2),AttributesResults1.effectSizeFDPPAtt(2,3),RegionsResults1.condition(2).effectSizeFDPP];
ES_C_1=round([ES_C_FPP_1,ES_C_FDPP_1],2);

ES_U_FPP_2=[ObjectsResults2.effectSizeFPPObj(1),ObjectsResults2.effectSizeFPPBg(1),AttributesResults2.effectSizeFPPAtt(1,3),RegionsResults2.condition(1).effectSizeFPP];
ES_U_FDPP_2=[ObjectsResults2.effectSizeFDPPObj(1),ObjectsResults2.effectSizeFDPPBg(1),AttributesResults2.effectSizeFDPPAtt(1,3),RegionsResults2.condition(1).effectSizeFDPP];
ES_U_2=round([ES_U_FPP_2,ES_U_FDPP_2],2);

ES_C_FPP_2=[ObjectsResults2.effectSizeFPPObj(2),ObjectsResults2.effectSizeFPPBg(2),AttributesResults2.effectSizeFPPAtt(2,3),RegionsResults2.condition(2).effectSizeFPP];
ES_C_FDPP_2=[ObjectsResults2.effectSizeFDPPObj(2),ObjectsResults2.effectSizeFDPPBg(2),AttributesResults2.effectSizeFDPPAtt(2,3),RegionsResults2.condition(2).effectSizeFDPP];
ES_C_2=round([ES_C_FPP_2,ES_C_FDPP_2],2);

%create table
tbl = table(p_U_1',ES_U_1',p_C_1',ES_C_1',p_U_2',ES_U_2',p_C_2',ES_C_2','VariableNames',{'Upval1','UeffectSize1','Cpval1','CeffectSize1','Upval2','UeffectSize2','Cpval2','CeffectSize2'});
end