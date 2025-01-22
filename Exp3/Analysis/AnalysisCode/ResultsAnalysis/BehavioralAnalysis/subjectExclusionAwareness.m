function [Results,Summary]=subjectExclusionAwareness(Results,Paths,Param,subjNumber)
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
    Data(ii).AccuracyUC=Results{ii,Param.UC}(ind1).accuracyRecognitionTest;
    Data(ii).pAccuracyUC=pout;
    Data(ii).dPrimeUC=Results{ii,Param.UC}(ind1).dPrimePerSub;

    %% Conscious condition
    if Results{ii,Param.C}(ind34).accuracyRecognitionTest<Param.th_accuracy
        Data(ii).isExcludedC=1;
    else
        Data(ii).isExcludedC=0;
    end
    Data(ii).numTrialsC=Results{ii,Param.C}(ind34).countPAS;
    Data(ii).AccuracyC=Results{ii,Param.C}(ind34).accuracyRecognitionTest;
    Data(ii).dPrimeC=Results{ii,Param.C}(ind34).dPrimePerSub;
    
    %% Exclude subjects with small number of trials in UC condition
    if Data(ii).numTrialsUC<Param.minimal_num_Trials
        Data(ii).isExcludedNumTU=1;
    else
        Data(ii).isExcludedNumTU=0;
    end
    
    %% Exclude subjects with small number of trials in C condition
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
ExcludedSubj=find([Data.isExcluded] == 1 & [Data.AccuracyUC] > 0.5);
SR_U=[Data.AccuracyUC];
SR_U(ExcludedSubj)=[];
d_U=[Data.dPrimeUC];
d_U(ExcludedSubj)=[];
[Summary.h_AccuracyUC_ttest,Summary.p_AccuracyUC_ttest,~,Summary.stat_accuracyUC_ttest] = ttest(SR_U,0.5,'Tail','right'); 
[Summary.h_dPrimeUC_ttest,Summary.p_dPrimeUC_ttest,~,Summary.stat_dPrimeUC_ttest] = ttest(d_U,0,'Tail','right');

SR_C=[Data.AccuracyC];
SR_C(ExcludedSubj)=[];
d_C=[Data.dPrimeC];
d_C(ExcludedSubj)=[];
[Summary.h_AccuracyC_ttest,Summary.p_AccuracyC_ttest,~,Summary.stat_accuracyC_ttest] = ttest(SR_C,0.5,'Tail','right'); 
[Summary.h_dPrimeC_ttest,Summary.p_dPrimeC_ttest,~,Summary.stat_dPrimeC_ttest] = ttest(d_C,0,'Tail','right');
end