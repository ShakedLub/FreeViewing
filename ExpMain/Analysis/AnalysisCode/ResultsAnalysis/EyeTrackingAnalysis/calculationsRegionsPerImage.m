function Results=calculationsRegionsPerImage(Results,fixations,im,typeFix,nn)
switch typeFix
    case 'Real'
        for kk=1:size(Results.image(im).condition,2)
            Results.image(im).condition(kk).numLow=sum([Results.image(im).condition(kk).subject.numLow]);
            Results.image(im).condition(kk).numHigh=sum([Results.image(im).condition(kk).subject.numHigh]);
            Results.image(im).condition(kk).numLowandHigh=sum([Results.image(im).condition(kk).subject.numLowandHigh]);
            Results.image(im).condition(kk).numBackground=sum([Results.image(im).condition(kk).subject.numBackground]);
            Results.image(im).condition(kk).numFix=sum([Results.image(im).condition(kk).subject.numFix]);
            
            %calculations for fix per pix
            Results.image(im).condition(kk).meanLow=mean([Results.image(im).condition(kk).subject.numLow]);
            Results.image(im).condition(kk).meanHigh=mean([Results.image(im).condition(kk).subject.numHigh]);
            Results.image(im).condition(kk).meanLowandHigh=mean([Results.image(im).condition(kk).subject.numLowandHigh]);
            Results.image(im).condition(kk).meanBackground=mean([Results.image(im).condition(kk).subject.numBackground]);
            
            %calculations for fix dur per pix
            for jj=1:size(Results.image(im).condition(kk).subject,2)
                fix_duration=fixations(im).condition(kk).subject(jj).processed.fix_duration_final;
                fix_classification=Results.image(im).condition(kk).subject(jj).fixClassifications;
                
                Results.image(im).condition(kk).subject(jj).fix_duration=fix_duration;
                
                %sum fixation duration per subj
                Results.image(im).condition(kk).subject(jj).sumfixdurLow=sum(fix_duration(fix_classification==1));
                if Results.image(im).condition(kk).subject(jj).sumfixdurLow==0
                    Results.image(im).condition(kk).subject(jj).sumfixdurLow=NaN;
                end
                Results.image(im).condition(kk).subject(jj).sumfixdurHigh=sum(fix_duration(fix_classification==2));
                if Results.image(im).condition(kk).subject(jj).sumfixdurHigh==0
                    Results.image(im).condition(kk).subject(jj).sumfixdurHigh=NaN;
                end
                Results.image(im).condition(kk).subject(jj).sumfixdurLowandHigh=sum(fix_duration(fix_classification==3));
                if Results.image(im).condition(kk).subject(jj).sumfixdurLowandHigh==0
                    Results.image(im).condition(kk).subject(jj).sumfixdurLowandHigh=NaN;
                end
                Results.image(im).condition(kk).subject(jj).sumfixdurBackground=sum(fix_duration(fix_classification==4));
                if Results.image(im).condition(kk).subject(jj).sumfixdurBackground==0
                    Results.image(im).condition(kk).subject(jj).sumfixdurBackground=NaN;
                end
            end
            
            %sum fixation duration per image
            Results.image(im).condition(kk).meansumfixdurLow=nanmean([Results.image(im).condition(kk).subject.sumfixdurLow]);
            Results.image(im).condition(kk).meansumfixdurHigh=nanmean([Results.image(im).condition(kk).subject.sumfixdurHigh]);
            Results.image(im).condition(kk).meansumfixdurLowandHigh=nanmean([Results.image(im).condition(kk).subject.sumfixdurLowandHigh]);
            Results.image(im).condition(kk).meansumfixdurBackground=nanmean([Results.image(im).condition(kk).subject.sumfixdurBackground]);
        end
    case 'Shuffled'
        for kk=1:size(Results.shuffled(nn).image(im).condition,2)
            Results.shuffled(nn).image(im).condition(kk).numLow=sum([Results.shuffled(nn).image(im).condition(kk).subject.numLow]);
            Results.shuffled(nn).image(im).condition(kk).numHigh=sum([Results.shuffled(nn).image(im).condition(kk).subject.numHigh]);
            Results.shuffled(nn).image(im).condition(kk).numLowandHigh=sum([Results.shuffled(nn).image(im).condition(kk).subject.numLowandHigh]);
            Results.shuffled(nn).image(im).condition(kk).numBackground=sum([Results.shuffled(nn).image(im).condition(kk).subject.numBackground]);
            Results.shuffled(nn).image(im).condition(kk).numFix=sum([Results.shuffled(nn).image(im).condition(kk).subject.numFix]);
            
            %calculations for fix per pix
            Results.shuffled(nn).image(im).condition(kk).meanLow=mean([Results.shuffled(nn).image(im).condition(kk).subject.numLow]);
            Results.shuffled(nn).image(im).condition(kk).meanHigh=mean([Results.shuffled(nn).image(im).condition(kk).subject.numHigh]);
            Results.shuffled(nn).image(im).condition(kk).meanLowandHigh=mean([Results.shuffled(nn).image(im).condition(kk).subject.numLowandHigh]);
            Results.shuffled(nn).image(im).condition(kk).meanBackground=mean([Results.shuffled(nn).image(im).condition(kk).subject.numBackground]);
            
            %calculations for fix dur per pix
            for jj=1:size(Results.shuffled(nn).image(im).condition(kk).subject,2) %subjects
                fix_duration=fixations(im).shuffled(nn).condition(kk).subject(jj).fix_duration_final;
                fix_classification=Results.shuffled(nn).image(im).condition(kk).subject(jj).fixClassifications;
                
                Results.shuffled(nn).image(im).condition(kk).subject(jj).fix_duration=fix_duration;
                
                %fixation sum duration per subj
                Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurLow=sum(fix_duration(fix_classification==1));
                if Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurLow == 0
                    Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurLow=NaN;
                end
                Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurHigh=sum(fix_duration(fix_classification==2));
                if Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurHigh == 0
                    Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurHigh=NaN;
                end
                Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurLowandHigh=sum(fix_duration(fix_classification==3));
                if Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurLowandHigh == 0
                    Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurLowandHigh=NaN;
                end
                Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurBackground=sum(fix_duration(fix_classification==4));
                if Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurBackground == 0
                    Results.shuffled(nn).image(im).condition(kk).subject(jj).sumfixdurBackground=NaN;
                end
            end
            %sum fixation duration per image
            Results.shuffled(nn).image(im).condition(kk).meansumfixdurLow=nanmean([Results.shuffled(nn).image(im).condition(kk).subject.sumfixdurLow]);
            Results.shuffled(nn).image(im).condition(kk).meansumfixdurHigh=nanmean([Results.shuffled(nn).image(im).condition(kk).subject.sumfixdurHigh]);
            Results.shuffled(nn).image(im).condition(kk).meansumfixdurLowandHigh=nanmean([Results.shuffled(nn).image(im).condition(kk).subject.sumfixdurLowandHigh]);
            Results.shuffled(nn).image(im).condition(kk).meansumfixdurBackground=nanmean([Results.shuffled(nn).image(im).condition(kk).subject.sumfixdurBackground]);
        end
end
end