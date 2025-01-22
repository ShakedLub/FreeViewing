function BadDivision=CheckImageDivision(RandTrialsOrder,Param,ExpStep,Num_Images,ImageType)
%Initialize Images_AllSubj
for cond=1:Param.NumConditions
    Images_AllSubj{cond}=[];
end

%Concatenate all images from all subjects in each condition seperatly
for cond=1:Param.NumConditions %conditions
    for subj=1:Param.NumSubjects %subjects
        Images_AllSubj{cond}=[Images_AllSubj{cond},RandTrialsOrder(subj).Condition(cond).ImageBank_equal];
    end
end

%calculate for each image the number of times it was presented in each
%condition across all subjects
for imageNumber=1:Num_Images
    for cond=1:Param.NumConditions
        SumImageAllSubj(imageNumber,cond)=sum(Images_AllSubj{cond}==imageNumber);
    end
end

%Check
if  ~all(SumImageAllSubj(:,1)+SumImageAllSubj(:,2)==Param.NumSubjects)
    error('Not all images are shown for all subjects')
end

limit=(Param.NumSubjects/2)*Param.PercentFromSubjectsBadDivision;
AllBadDivision=sum(abs(SumImageAllSubj(:,1)-SumImageAllSubj(:,2))>=(2*limit));
if (AllBadDivision/Num_Images)>=Param.PercentFromImagesBadDivsion
    BadDivision=1;
else
    BadDivision=0;
end

if BadDivision==0
    figure
    diffUC_C=(SumImageAllSubj(:,1)-SumImageAllSubj(:,2))/2;
    h=histogram(diffUC_C);
    hold on
    line([limit,limit],[0,max(h.Values)],'Color','r');
    line([-limit,-limit],[0,max(h.Values)],'Color','r');
    hold off
    xlabel('(PresentedUC- PresentedC)/2')
    ylabel('Count')
    title('Difference images presented in C and UC conditions, across all subejcts')
    
    saveas(gcf,['ImageDivisionToConditions_',ExpStep,'_',ImageType])
end
end