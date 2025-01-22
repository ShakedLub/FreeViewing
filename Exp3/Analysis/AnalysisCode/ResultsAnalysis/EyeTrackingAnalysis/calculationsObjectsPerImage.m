function Results=calculationsObjectsPerImage(Results,im,cond,typeFix,nn,Param)
switch typeFix
    case 'Real'
        for jj=1:size(Results.image(im).condition(cond).subject,2) %subjects
            if ~Param.IncludeObjNoAttInObj
                % fix per pix
                Results.image(im).condition(cond).subject(jj).sumCountFixObj=sum(Results.image(im).condition(cond).subject(jj).fixID==1);
                
                % fix dur per pix 
                Results.image(im).condition(cond).subject(jj).sumFixDurationObj=sum(Results.image(im).condition(cond).subject(jj).fixDurations(Results.image(im).condition(cond).subject(jj).fixID==1));
                Results.image(im).condition(cond).subject(jj).sumFixDurationBg=sum(Results.image(im).condition(cond).subject(jj).fixDurBg);
            else
                %fix per pix 
                Results.image(im).condition(cond).subject(jj).sumCountFixObj=sum(Results.image(im).condition(cond).subject(jj).fixID==1 | Results.image(im).condition(cond).subject(jj).fixID==2);
                
                % fix dur per pix
                Results.image(im).condition(cond).subject(jj).sumFixDurationObj=sum(Results.image(im).condition(cond).subject(jj).fixDurations(Results.image(im).condition(cond).subject(jj).fixID==1 | Results.image(im).condition(cond).subject(jj).fixID==2));
                Results.image(im).condition(cond).subject(jj).sumFixDurationBg=sum(Results.image(im).condition(cond).subject(jj).fixDurBg);
            end
            if Results.image(im).condition(cond).subject(jj).sumFixDurationObj==0
                Results.image(im).condition(cond).subject(jj).sumFixDurationObj=NaN;
            end
            if Results.image(im).condition(cond).subject(jj).sumFixDurationBg==0
                Results.image(im).condition(cond).subject(jj).sumFixDurationBg=NaN;
            end
        end
        %fix per pix 
        Results.image(im).condition(cond).meanCountObj=mean([Results.image(im).condition(cond).subject.sumCountFixObj]);
        Results.image(im).condition(cond).meanCountBg=mean([Results.image(im).condition(cond).subject.countFixBg]);
        
        %fix dur per pix 
        Results.image(im).condition(cond).meanSumFixDurationObj=nanmean([Results.image(im).condition(cond).subject.sumFixDurationObj]);
        Results.image(im).condition(cond).meanSumFixDurationBg=nanmean([Results.image(im).condition(cond).subject.sumFixDurationBg]);
    case 'Shuffled'
        for jj=1:size(Results.shuffled(nn).image(im).condition(cond).subject,2) %subjects
            if ~Param.IncludeObjNoAttInObj
               % fix per pix
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumCountFixObj=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixID==1);
                
                % fix dur per pix
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationObj=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixDurations(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixID==1));
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationBg=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixDurBg);
            else
                % caculations fix per pix for each subj
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumCountFixObj=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixID==1 | Results.shuffled(nn).image(im).condition(cond).subject(jj).fixID==2);
                
                % caculations fix duration per pix for each subj
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationObj=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixDurations(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixID==1 | Results.shuffled(nn).image(im).condition(cond).subject(jj).fixID==2));
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationBg=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixDurBg);               
            end
            if Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationObj == 0
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationObj=NaN;
            end
            if Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationBg == 0
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurationBg=NaN;
            end
        end
        
        % fix per pix
        Results.shuffled(nn).image(im).condition(cond).meanCountObj=mean([Results.shuffled(nn).image(im).condition(cond).subject.sumCountFixObj]);
        Results.shuffled(nn).image(im).condition(cond).meanCountBg=mean([Results.shuffled(nn).image(im).condition(cond).subject.countFixBg]);
        
        % fix dur per pix
        Results.shuffled(nn).image(im).condition(cond).meanSumFixDurationObj=nanmean([Results.shuffled(nn).image(im).condition(cond).subject.sumFixDurationObj]);
        Results.shuffled(nn).image(im).condition(cond).meanSumFixDurationBg=nanmean([Results.shuffled(nn).image(im).condition(cond).subject.sumFixDurationBg]);        
end
end