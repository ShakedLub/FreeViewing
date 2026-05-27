function Summary=calcSubjPerImage(fixations)
for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %condition
        Summary.NumSubjPerImage(ii,kk)=size(fixations(ii).condition(kk).subject,2);
    end
end
Summary.meanSubj=mean(Summary.NumSubjPerImage);
Summary.stdSubj=std(Summary.NumSubjPerImage);
Summary.minSubj=min(Summary.NumSubjPerImage);
Summary.maxSubj=max(Summary.NumSubjPerImage);

%% plot
figure
yU=Summary.NumSubjPerImage(:,1);
yC=Summary.NumSubjPerImage(:,2);
y=[yU',yC'];
x=[ones(1,size(Summary.NumSubjPerImage,1)),ones(1,size(Summary.NumSubjPerImage,1))*2];
scatter(x,y,50,'o','filled',...
    'MarkerEdgeColor',[0 .5 .5],...
    'MarkerFaceColor',[0 .7 .7])
hold on
for ii=1:size(Summary.NumSubjPerImage,1) %subjects
    line([1 2],[yU(ii),yC(ii)],'LineStyle','--')
end
boxplot(y,x)
hold off
set(gca,'XTick',[1,2])
set(gca,'XTickLabel',{'Unconscious','Conscious'})
title('Number of subjects per image')
ylabel('Number of subjects')
xlabel('Visibilty Conditions')
set(gca,'FontSize',20)
end