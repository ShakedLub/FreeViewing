function fixations=shuffleFixationsPermutationAnalysis(fixations,subjNumber,NRepetition)
%baseline procedure is based on Abeles,Amit & Yuval-Greenberg, 2018 the
%biased observer
%The shuffling is done without return

%create all fixations matrix for each observer
for ii=1:length(subjNumber) %subjects
    FixationsBank(ii).subjNum=subjNumber(ii);
    for kk=1:size(fixations(1).condition,2) %conditions
        FixationsBank(ii).condition(kk).fix_w_final=[];
        FixationsBank(ii).condition(kk).fix_h_final=[];
        FixationsBank(ii).condition(kk).fix_duration_final=[];
    end
end

for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %condition
        for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
            subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
            indSubj=find(subjNumber==subjNum);
            FixationsBank(indSubj).condition(kk).fix_w_final=[FixationsBank(indSubj).condition(kk).fix_w_final;fixations(ii).condition(kk).subject(jj).processed.fix_w_final];
            FixationsBank(indSubj).condition(kk).fix_h_final=[FixationsBank(indSubj).condition(kk).fix_h_final;fixations(ii).condition(kk).subject(jj).processed.fix_h_final];
            FixationsBank(indSubj).condition(kk).fix_duration_final=[FixationsBank(indSubj).condition(kk).fix_duration_final;fixations(ii).condition(kk).subject(jj).processed.fix_duration_final'];
        end
    end
end

%add randomized fixations to fixation struct
for nn=1:NRepetition %repetitions
    %Restart the bank for each repetition
    FixationsBankTemp=FixationsBank;
    for ii=1:size(fixations,2) %images
        for kk=1:size(fixations(ii).condition,2) %condition
            for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
                clear subjNum indSubj numFix indFix
                
                subjNum=fixations(ii).condition(kk).subject(jj).subjNum;
                indSubj=find(subjNumber==subjNum);
                numFix=length(fixations(ii).condition(kk).subject(jj).processed.fix_w_final);
                indFix=randperm(length(FixationsBankTemp(indSubj).condition(kk).fix_w_final),numFix);
                
                fixations(ii).shuffled(nn).condition(kk).subject(jj).subjNum=subjNum;
                fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_w_final=FixationsBankTemp(indSubj).condition(kk).fix_w_final(indFix);
                fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_h_final=FixationsBankTemp(indSubj).condition(kk).fix_h_final(indFix);
                fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_duration_final=FixationsBankTemp(indSubj).condition(kk).fix_duration_final(indFix);
                
                %delete chosen indices from temporary bank
                FixationsBankTemp(indSubj).condition(kk).fix_w_final(indFix)=[];
                FixationsBankTemp(indSubj).condition(kk).fix_h_final(indFix)=[];
                FixationsBankTemp(indSubj).condition(kk).fix_duration_final(indFix)=[];
            end
        end
    end
end
end