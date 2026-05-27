function Results=calculationsPerImageAttributes(AttributesResults,ObjectsResults)
%initizalize vectors
%count vectors
numFixAtt=zeros(2,length(AttributesResults.image(1).PixelsInAtt));
numFixNoAtt=zeros(1,2);
numFixBg=zeros(1,2);
numFix=zeros(1,2);

numObjWithAtt=zeros(1,length(AttributesResults.image(1).PixelsInAtt));
numObjWithNoAtt=0;
numObj=0;


%count fixations on attributes
for ii=1:size(AttributesResults.image,2) %images
    for kk=1:size(AttributesResults.image(ii).condition,2) %condition
        clear meanfixDurAttMat
        for jj=1:size(AttributesResults.image(ii).condition(kk).subject,2) %subjects
            %count fixations
            numFixAtt(kk,:)=numFixAtt(kk,:)+AttributesResults.image(ii).condition(kk).subject(jj).countFixAtt;
            numFixNoAtt(kk)=numFixNoAtt(kk)+AttributesResults.image(ii).condition(kk).subject(jj).countFixNoAtt;
            numFixBg(kk)=numFixBg(kk)+ObjectsResults.image(ii).condition(kk).subject(jj).countFixBg;
            numFix(kk)=numFix(kk)+ObjectsResults.image(ii).condition(kk).subject(jj).countFix;
            
            %average duration fixations
            AttributesResults.image(ii).condition(kk).subject(jj).meanfixDurAtt=cellfun(@mean,AttributesResults.image(ii).condition(kk).subject(jj).fixDurAtt);
            meanfixDurAttMat(jj,:)=AttributesResults.image(ii).condition(kk).subject(jj).meanfixDurAtt;
            AttributesResults.image(ii).condition(kk).subject(jj).meanfixDurNoAtt=mean(AttributesResults.image(ii).condition(kk).subject(jj).fixDurNoAtt);
            AttributesResults.image(ii).condition(kk).subject(jj).meanfixDurBg=mean(ObjectsResults.image(ii).condition(kk).subject(jj).fixDurBg);
        end
        AttributesResults.image(ii).condition(kk).meanfixDurAtt=nanmean(meanfixDurAttMat,1);
        AttributesResults.image(ii).condition(kk).meanfixDurNoAtt=nanmean([AttributesResults.image(ii).condition(kk).subject.meanfixDurNoAtt]);
        AttributesResults.image(ii).condition(kk).meanfixDurBg=nanmean([AttributesResults.image(ii).condition(kk).subject.meanfixDurBg]);
    end
end

%count fixations
Results.countFixAtt=numFixAtt;
for kk=1:2
    Results.PercentAttFixCount(kk,:)=numFixAtt(kk,:)./numFix(kk);
    Results.PercentNoAttFixCount(kk)=numFixNoAtt(kk)/numFix(kk);
    Results.PercentBgFixCount(kk)=numFixBg(kk)/numFix(kk);
end

%count objects that include an attribute
for ii=1:size(ObjectsResults.image,2) %images
    numObjWithAtt=numObjWithAtt+ObjectsResults.image(ii).numAttIm;
    numObjWithNoAtt=numObjWithNoAtt+sum(ObjectsResults.image(ii).objNoAtt);
    numObj=numObj+length(ObjectsResults.image(ii).objNoAtt);  
end
Results.numObjWithAtt=numObjWithAtt;
Results.numObjWithNoAtt=numObjWithNoAtt;
Results.PercentAttObjCount=numObjWithAtt./numObj;
Results.PercentNoAttObjCount=numObjWithNoAtt/numObj;

%average fixation duration
for ii=1:size(AttributesResults.image,2) %images
    meanfixDurAttMatU(ii,:)=AttributesResults.image(ii).condition(1).meanfixDurAtt;
    meanfixDurAttMatC(ii,:)=AttributesResults.image(ii).condition(2).meanfixDurAtt;
    meanfixDurNoAttU(ii)=AttributesResults.image(ii).condition(1).meanfixDurNoAtt;
    meanfixDurNoAttC(ii)=AttributesResults.image(ii).condition(2).meanfixDurNoAtt;
    meanfixDurBgU(ii)=AttributesResults.image(ii).condition(1).meanfixDurBg;
    meanfixDurBgC(ii)=AttributesResults.image(ii).condition(2).meanfixDurBg;
end
Results.numImagesWithFixOnAtt(1,:)=sum(~isnan(meanfixDurAttMatU));
Results.numImagesWithFixOnAtt(2,:)=sum(~isnan(meanfixDurAttMatC));
Results.meanfixDurAtt(1,:)=nanmean(meanfixDurAttMatU,1);
Results.meanfixDurAtt(2,:)=nanmean(meanfixDurAttMatC,1);
Results.meanfixDurNoAtt(1)=nanmean(meanfixDurNoAttU);
Results.meanfixDurNoAtt(2)=nanmean(meanfixDurNoAttC);
Results.meanfixDurBg(1)=nanmean(meanfixDurBgU);
Results.meanfixDurBg(2)=nanmean(meanfixDurBgC);
end