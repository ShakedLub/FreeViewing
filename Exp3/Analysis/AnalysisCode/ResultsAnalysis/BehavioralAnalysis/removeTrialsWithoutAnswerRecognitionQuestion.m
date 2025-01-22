function EXPDATA=removeTrialsWithoutAnswerRecognitionQuestion(EXPDATA)
indRemove=find(~[EXPDATA.TrialsAnalysis.did_answer_recognition_Q]);
if ~isempty(indRemove)
    EXPDATA.TrialsAnalysis(indRemove)=[];
end
EXPDATA.TrialsRemoved.TrialsWithoutAnswerRecognitionQuestion=length(indRemove);
end