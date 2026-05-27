function pout=binomtest(Results,Paths,Param,PASAnswerInd,subj)
cd(Paths.myBinomTest)
s=Results{subj,Param.UC}(PASAnswerInd).countCorrectRecognitionTest;
n=Results{subj,Param.UC}(PASAnswerInd).countPAS;
if n~=0
    pout=myBinomTest(s,n,Param.pBinomialTest,'one');
else
    pout=NaN;
end
cd(Paths.BehavioralAnalysisFolder)
end