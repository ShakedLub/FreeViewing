function EXPDATA=removeTrialBeforeCalibration(EXPDATA)
TrialNumberOverall=[EXPDATA.Trials_Analysis.TrialNumberOverall];
TrialNumberOverall_ALLTRIALS=[EXPDATA.Trials_Experiment.TrialNumberOverall];

if ~isempty(EXPDATA.info.general_info.calibration_data_Experiment)
    calibrationsDuringBlock=~logical(EXPDATA.info.general_info.calibration_data_Experiment.calibration_beginning_block);
    calibrationBeforeTrial=EXPDATA.info.general_info.calibration_data_Experiment.calibration_done_before_trial(calibrationsDuringBlock);
else
    indFixFail=find([EXPDATA.Trials_Experiment.NumRepetitionFixationFail]);
    calibrationBeforeTrial=[EXPDATA.Trials_Experiment(indFixFail).TrialNumberOverall];
end

if ~isempty(calibrationBeforeTrial)
    %Take out trials from calibrationBeforeTrial that are the first trial in a
    %block in order not to remove a trial from one block before.
    FirstTrialsinBlokcs=TrialNumberOverall_ALLTRIALS([EXPDATA.Trials_Experiment.TrialNum]==1);
    calibrationBeforeTrial=setdiff(calibrationBeforeTrial,FirstTrialsinBlokcs);
end

indRemove_trialBeforeCalib=[];
if ~isempty(calibrationBeforeTrial)
    trialsRemove=calibrationBeforeTrial-1;
    trialsRemove=unique(trialsRemove);
    for ii=1:length(trialsRemove)
        if ~isempty(find(TrialNumberOverall==trialsRemove(ii)))
            ind=find(TrialNumberOverall==trialsRemove(ii));
            indRemove_trialBeforeCalib=[indRemove_trialBeforeCalib,ind];
        end
    end
    if ~isempty(indRemove_trialBeforeCalib)
        EXPDATA.Trials_Analysis(indRemove_trialBeforeCalib)=[];
    end
end
EXPDATA.TrialsRemoved.OneTrialBeforeCalibration=length(indRemove_trialBeforeCalib);
end