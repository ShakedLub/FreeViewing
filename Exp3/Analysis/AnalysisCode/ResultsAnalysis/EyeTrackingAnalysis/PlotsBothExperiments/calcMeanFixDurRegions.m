function RegionsResults_PerSubj=calcMeanFixDurRegions(RegionsResults_PerSubj)
for ii=1:size(RegionsResults_PerSubj,2)%subjects
    for kk=1:size(RegionsResults_PerSubj(ii).condition,2) %condition
        for jj=1:size(RegionsResults_PerSubj(ii).condition(kk).trial,2) %trials
            RegionsResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurLow=mean(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fix_duration(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fixClassifications==1));
            RegionsResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurHigh=mean(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fix_duration(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fixClassifications==2));
            RegionsResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurLowandHigh=mean(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fix_duration(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fixClassifications==3));
            RegionsResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurBackground=mean(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fix_duration(RegionsResults_PerSubj(ii).condition(kk).trial(jj).fixClassifications==4));
        end
        RegionsResults_PerSubj(ii).condition(kk).meanFixDurLow=nanmean([RegionsResults_PerSubj(ii).condition(kk).trial.meanFixDurLow]);
        RegionsResults_PerSubj(ii).condition(kk).meanFixDurHigh=nanmean([RegionsResults_PerSubj(ii).condition(kk).trial.meanFixDurHigh]);
        RegionsResults_PerSubj(ii).condition(kk).meanFixDurLowandHigh=nanmean([RegionsResults_PerSubj(ii).condition(kk).trial.meanFixDurLowandHigh]);
        RegionsResults_PerSubj(ii).condition(kk).meanFixDurBackground=nanmean([RegionsResults_PerSubj(ii).condition(kk).trial.meanFixDurBackground]);
    end
end
end
