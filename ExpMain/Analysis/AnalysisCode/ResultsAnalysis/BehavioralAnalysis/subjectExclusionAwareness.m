function [Results,Summary]=subjectExclusionAwareness(Results,Paths,Param,subjNumber)
%check if subjects should be excluded due to visibility issues and
%calculate group level awareness

for ii=1:size(Results,1) %subjects
    ind1=[];
    ind34=[];
    for aa=1:size(Results{ii,Param.UC},2) %PAS answers
        if isequal(Results{ii,Param.UC}(aa).PASAnswer,1)
            ind1=aa;
        elseif isequal(Results{ii,Param.UC}(aa).PASAnswer,[3,4])
            ind34=aa;
        end
    end
    
    Data(ii).subjNumber=subjNumber(ii);
    
    %% Unconcsious condition
    pout=binomtest(Results,Paths,Param,ind1,ii);
    if ~isnan(pout) && pout>Param.alpha
        Data(ii).isExcludedUC=0;
    else
        Data(ii).isExcludedUC=1;
    end
    Results{ii,Param.UC}(ind1).pAccuracy=pout;
    Data(ii).numTrialsUC=Results{ii,Param.UC}(ind1).countPAS;
    Data(ii).numTrialsCorrectUC=Results{ii,Param.UC}(ind1).countCorrectRecognitionTest;
    Data(ii).AccuracyUC=Results{ii,Param.UC}(ind1).accuracyRecognitionTest;
    Data(ii).pAccuracyUC=pout;
    Data(ii).dPrimeUC=Results{ii,Param.UC}(ind1).dPrimePerSub;

    %% Conscious condition (conT-conS)
    if Results{ii,Param.C}(ind34).accuracyRecognitionTest<Param.th_accuracy
        Data(ii).isExcludedC=1;
    else
        Data(ii).isExcludedC=0;
    end
    Data(ii).numTrialsC=Results{ii,Param.C}(ind34).countPAS;
    Data(ii).numTrialsCorrectC=Results{ii,Param.C}(ind34).countCorrectRecognitionTest;
    Data(ii).AccuracyC=Results{ii,Param.C}(ind34).accuracyRecognitionTest;
    Data(ii).dPrimeC=Results{ii,Param.C}(ind34).dPrimePerSub;
    
    %% Conscious condition (conT-unS)
    Data(ii).numTrialsC2=Results{ii,Param.UC}(ind34).countPAS;
    Data(ii).numTrialsCorrectC2=Results{ii,Param.UC}(ind34).countCorrectRecognitionTest;
    Data(ii).AccuracyC2=Results{ii,Param.UC}(ind34).accuracyRecognitionTest;
    Data(ii).dPrimeC2=Results{ii,Param.UC}(ind34).dPrimePerSub;
    
    %% Exclude subjects with small number of trials in UC condition
    if Data(ii).numTrialsUC<Param.minimal_num_Trials
        Data(ii).isExcludedNumTU=1;
    else
        Data(ii).isExcludedNumTU=0;
    end
    
    %% Exclude subjects with small number of trials in C condition (conT-conS)
    if Data(ii).numTrialsC<Param.minimal_num_Trials
        Data(ii).isExcludedNumTC=1;
    else
        Data(ii).isExcludedNumTC=0;
    end
    
    %% Should the subject be excluded according to the three conditions
    if Data(ii).isExcludedUC || Data(ii).isExcludedC || Data(ii).isExcludedNumTU || Data(ii).isExcludedNumTC
        Data(ii).isExcluded=1;
    else
        Data(ii).isExcluded=0;
    end
end

%% Save data
Summary.Data=Data;
Summary.NExcluded=sum([Data.isExcluded]);

%% check group level awareness (without objective aware subjects)
%% ttest
ExcludedSubj=find([Data.isExcluded] == 1 & [Data.AccuracyUC] > 0.5);
SR_U=[Data.AccuracyUC];
SR_U(ExcludedSubj)=[];
d_U=[Data.dPrimeUC];
d_U(ExcludedSubj)=[];
R_U=[Data.numTrialsCorrectUC];
R_U(ExcludedSubj)=[];
numT_U=[Data.numTrialsUC];
numT_U(ExcludedSubj)=[];
[Summary.h_AccuracyUC_ttest,Summary.p_AccuracyUC_ttest,~,Summary.stat_accuracyUC_ttest] = ttest(SR_U,0.5,'Tail','right'); 
[Summary.h_dPrimeUC_ttest,Summary.p_dPrimeUC_ttest,~,Summary.stat_dPrimeUC_ttest] = ttest(d_U,0,'Tail','right');

SR_C=[Data.AccuracyC];
SR_C(ExcludedSubj)=[];
d_C=[Data.dPrimeC];
d_C(ExcludedSubj)=[];
R_C=[Data.numTrialsCorrectC];
R_C(ExcludedSubj)=[];
numT_C=[Data.numTrialsC];
numT_C(ExcludedSubj)=[];
[Summary.h_AccuracyC_ttest,Summary.p_AccuracyC_ttest,~,Summary.stat_accuracyC_ttest] = ttest(SR_C,0.5,'Tail','right'); 
[Summary.h_dPrimeC_ttest,Summary.p_dPrimeC_ttest,~,Summary.stat_dPrimeC_ttest] = ttest(d_C,0,'Tail','right');

SR_C2=[Data.AccuracyC2];
SR_C2(ExcludedSubj)=[];
d_C2=[Data.dPrimeC2];
d_C2(ExcludedSubj)=[];
R_C2=[Data.numTrialsCorrectC2];
R_C2(ExcludedSubj)=[];
numT_C2=[Data.numTrialsC2];
numT_C2(ExcludedSubj)=[];
%Exclude participants with 0 trials in C2 condition
ExcSubj0trials=find(numT_C2==0);
SR_C2(ExcSubj0trials)=[];
d_C2(ExcSubj0trials)=[];
R_C2(ExcSubj0trials)=[];
numT_C2(ExcSubj0trials)=[];
[Summary.h_AccuracyC2_ttest,Summary.p_AccuracyC2_ttest,~,Summary.stat_accuracyC2_ttest] = ttest(SR_C2,0.5,'Tail','right'); 
[Summary.h_dPrimeC2_ttest,Summary.p_dPrimeC2_ttest,~,Summary.stat_dPrimeC2_ttest] = ttest(d_C2,0,'Tail','right');

%% GBC test
[Summary.h_AccuracyUC_GBC,Summary.pval_AccuracyUC_GBC]=GBC(R_U,numT_U,Param.pBinomialTest,Param.alpha,'right');
[Summary.h_AccuracyC_GBC,Summary.pval_AccuracyC_GBC]=GBC(R_C,numT_C,Param.pBinomialTest,Param.alpha,'right');
[Summary.h_AccuracyC2_GBC,Summary.pval_AccuracyC2_GBC]=GBC(R_C2,numT_C2,Param.pBinomialTest,Param.alpha,'right');

end