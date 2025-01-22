function AttributesResults_PerSubj=calcMeanFixDurObjAndAtt(AttributesResults_PerSubj,ObjectsResults_PerSubj)
for ii=1:size(AttributesResults_PerSubj,2)%subjects
    for kk=1:size(AttributesResults_PerSubj(ii).condition,2) %condition
        for jj=1:size(AttributesResults_PerSubj(ii).condition(kk).trial,2) %trials
            %attributes
            AttributesResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurAtt=cellfun(@mean,AttributesResults_PerSubj(ii).condition(kk).trial(jj).fixDurAtt); 
            meanFixDurAttMat(jj,:)=AttributesResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurAtt;
            %objects with no attribute
            AttributesResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurNoAtt=mean(AttributesResults_PerSubj(ii).condition(kk).trial(jj).fixDurNoAtt);
            %background
            AttributesResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurBg=mean(ObjectsResults_PerSubj(ii).condition(kk).trial(jj).fixDurBg);
            %all objects
            AttributesResults_PerSubj(ii).condition(kk).trial(jj).meanFixDurObj=mean(ObjectsResults_PerSubj(ii).condition(kk).trial(jj).fixDurations(ObjectsResults_PerSubj(ii).condition(kk).trial(jj).fixID==1 | ObjectsResults_PerSubj(ii).condition(kk).trial(jj).fixID==2));
        end
        AttributesResults_PerSubj(ii).condition(kk).meanFixDurAtt=nanmean(meanFixDurAttMat,1);
        AttributesResults_PerSubj(ii).condition(kk).meanFixDurNoAtt=nanmean([AttributesResults_PerSubj(ii).condition(kk).trial.meanFixDurNoAtt]);
        AttributesResults_PerSubj(ii).condition(kk).meanFixDurBg=nanmean([AttributesResults_PerSubj(ii).condition(kk).trial.meanFixDurBg]);
        AttributesResults_PerSubj(ii).condition(kk).meanFixDurObj=nanmean([AttributesResults_PerSubj(ii).condition(kk).trial.meanFixDurObj]);
    end
end
end