function Results=AwarenessAnalysis(EXPDATA,Param)
for jj=1:length(Param.possible_response_PAS_Q) %PAS answers
    clear indTrials
    Results(jj).PASAnswer=Param.possible_response_PAS_Q{jj};
    if any(isnan(Param.possible_response_PAS_Q{jj})) %No answer PAS question trials
        indTrials=find(~[EXPDATA.TrialsAnalysis.did_answer_PAS_Q]);
    elseif length(Param.possible_response_PAS_Q{jj})==2 %Two possible answers in PAS included
        indTrials=sort([find([EXPDATA.TrialsAnalysis.response_PAS_Q]==Param.possible_response_PAS_Q{jj}(1)),find([EXPDATA.TrialsAnalysis.response_PAS_Q]==Param.possible_response_PAS_Q{jj}(2))]);
    else %One answer in PAS included
        indTrials=find([EXPDATA.TrialsAnalysis.response_PAS_Q]==Param.possible_response_PAS_Q{jj});
    end

    %PAS answer percents
    Results(jj).countPAS=length(indTrials);
    Results(jj).PercentPAS=Results(jj).countPAS/size(EXPDATA.TrialsAnalysis,2);
    
    if ~isempty(indTrials) && ~any(isnan(Param.possible_response_PAS_Q{jj}))
        %Recognition test results
        %accuracy
        Results(jj).countCorrectRecognitionTest=sum([EXPDATA.TrialsAnalysis(indTrials).isCorrect_recognition_Q]);
        Results(jj).accuracyRecognitionTest=Results(jj).countCorrectRecognitionTest/Results(jj).countPAS;
        
        %d'
        objective_column=[EXPDATA.TrialsAnalysis(indTrials).ImageTypeQLeft]; %0-right column correct, 1- left column correct
        response_column=strcmp({EXPDATA.TrialsAnalysis(indTrials).response_recognition_Q},'L'); %0- response R, 1- response L
        
        data=[ones(1,length(indTrials))',objective_column',response_column'];
        %columns order
        sub_column_num=1;
        objective_column_num=2;
        response_column_num=3;
        
        signal_response=1;
        noise_response=0;
        
        [Results(jj).dPrimePerSub, Results(jj).CriterionPerSub, Results(jj).HitsProportion, Results(jj).FAProportion ] = calculate_d_prime(data, sub_column_num, objective_column_num, response_column_num, signal_response, noise_response);
        
    else
        Results(jj).countCorrectRecognitionTest=NaN;
        Results(jj).accuracyRecognitionTest=NaN;
        Results(jj).dPrimePerSub=NaN;
        Results(jj).CriterionPerSub=NaN;
        Results(jj).HitsProportion=NaN;
        Results(jj).FAProportion=NaN;
    end
end
end