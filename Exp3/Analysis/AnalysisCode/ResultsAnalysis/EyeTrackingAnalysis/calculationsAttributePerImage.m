function Results=calculationsAttributePerImage(Results,im,cond,typeFix,nn)
switch typeFix
    case 'Real'
        for jj=1:size(Results.image(im).condition(cond).subject,2)
            % fix per pix
            countFixAttMat(jj,:)=Results.image(im).condition(cond).subject(jj).countFixAtt;
            
            % fix dur per pix 
            sumFixDurAttMat(jj,:)=cellfun(@sum,Results.image(im).condition(cond).subject(jj).fixDurAtt);
            sumFixDurAttMat(jj,sumFixDurAttMat(jj,:)==0)=NaN;
            
            Results.image(im).condition(cond).subject(jj).sumFixDurNoAtt=sum(Results.image(im).condition(cond).subject(jj).fixDurNoAtt);
            if Results.image(im).condition(cond).subject(jj).sumFixDurNoAtt==0
                Results.image(im).condition(cond).subject(jj).sumFixDurNoAtt=NaN;
            end
        end
        %fix per pix 
        Results.image(im).condition(cond).meanCountFixAtt=mean(countFixAttMat,1);
        Results.image(im).condition(cond).meanCountFixNoAtt=mean([Results.image(im).condition(cond).subject.countFixNoAtt]);
        
        % fix dur per pix
        Results.image(im).condition(cond).meanSumFixDurAtt=nanmean(sumFixDurAttMat,1);
        Results.image(im).condition(cond).meanSumFixDurNoAtt=nanmean([Results.image(im).condition(cond).subject.sumFixDurNoAtt]);
    
    case 'Shuffled'
        for jj=1:size(Results.shuffled(nn).image(im).condition(cond).subject,2)
            % fix per pix 
            countFixAttMat(jj,:)=Results.shuffled(nn).image(im).condition(cond).subject(jj).countFixAtt;

            % fix dur per pix
            sumFixDurAttMat(jj,:)=cellfun(@sum,Results.shuffled(nn).image(im).condition(cond).subject(jj).fixDurAtt);
            sumFixDurAttMat(jj,sumFixDurAttMat(jj,:)==0)=NaN;
            
            Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurNoAtt=sum(Results.shuffled(nn).image(im).condition(cond).subject(jj).fixDurNoAtt);
            if Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurNoAtt==0
                Results.shuffled(nn).image(im).condition(cond).subject(jj).sumFixDurNoAtt=NaN;
            end   
        end
        % fix per pix
        Results.shuffled(nn).image(im).condition(cond).meanCountFixAtt=mean(countFixAttMat,1);
        Results.shuffled(nn).image(im).condition(cond).meanCountFixNoAtt=mean([Results.shuffled(nn).image(im).condition(cond).subject.countFixNoAtt]);
        
        % fix dur per pix 
        Results.shuffled(nn).image(im).condition(cond).meanSumFixDurAtt=nanmean(sumFixDurAttMat,1);
        Results.shuffled(nn).image(im).condition(cond).meanSumFixDurNoAtt=nanmean([Results.shuffled(nn).image(im).condition(cond).subject.sumFixDurNoAtt]);
end
end