function fixations=shuffleFixationsSaveTrialPermutationAnalysis(fixations,Fixations_PerSubject,subjNumber,NRepetition)
%Shuffle trials between images for each subject in each condition

%create trials bank
for ii=1:size(Fixations_PerSubject,2) %subjects
    subjNum=Fixations_PerSubject(ii).subjNum;
    indSubj=find(subjNumber==subjNum);
    for kk=1:size(Fixations_PerSubject(ii).condition,2) %condition
        TrialBank{indSubj,kk}=1:size(Fixations_PerSubject(indSubj).condition(kk).trial,2);
    end
end

%add shuffled fixations to fixations
for nn=1:NRepetition %repetitions
    %Restart the bank for each repetition
    TrialBankTemp=TrialBank;
    
    for ii=1:size(fixations,2) %images
        for kk=1:size(fixations(ii).condition,2) %condition
            for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
                clear subjNum indSubj numFix indFix
                
                subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
                indSubj=find(subjNumber==subjNum);
                
                indRandomTrialNum=randperm(length(TrialBankTemp{indSubj,kk}),1);
                RandomTrialNum=TrialBankTemp{indSubj,kk}(indRandomTrialNum);
                
                fixations(ii).shuffled(nn).condition(kk).subject(jj).subjNum=subjNum;
                fixations(ii).shuffled(nn).condition(kk).subject(jj).img=Fixations_PerSubject(indSubj).condition(kk).trial(RandomTrialNum).img;
                fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_w_final=Fixations_PerSubject(indSubj).condition(kk).trial(RandomTrialNum).processed.fix_w_final;
                fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_h_final=Fixations_PerSubject(indSubj).condition(kk).trial(RandomTrialNum).processed.fix_h_final;
                fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_duration_final=Fixations_PerSubject(indSubj).condition(kk).trial(RandomTrialNum).processed.fix_duration_final;
                
                %delete chosen indices from temporary bank
                TrialBankTemp{indSubj,kk}(indRandomTrialNum)=[];
            end
        end
    end
end
end