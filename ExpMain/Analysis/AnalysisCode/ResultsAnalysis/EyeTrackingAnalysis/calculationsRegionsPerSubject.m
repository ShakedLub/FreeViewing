function [Summary_PerSubj,Results_PerSubj]=calculationsRegionsPerSubject(Results,fixations,subjNumber)
%num pix in each region on each image
numPixLow=[Results.image.numPixLow];
numPixHigh=[Results.image.numPixHigh];
numPixLowandHigh=[Results.image.numPixLowandHigh];
numPixBackground=[Results.image.numPixBackground];

conditions=size(Results.image(1).condition,2);

%Initialize Results_PerSubj
for ii=1:length(subjNumber) %subjects
    Results_PerSubj(ii).subjNum=subjNumber(ii);
    for kk=1:conditions %conditions
        Results_PerSubj(ii).condition(kk).trial=[];
    end
end

%Fill Results_PerSubj
for ii=1:size(Results.image,2) %images
    for kk=1:size(Results.image(ii).condition,2) %conditions
        for jj=1:size(Results.image(ii).condition(kk).subject,2)%subjects
            imageName=Results.image(ii).imageName;
            imageInd=find(strcmp(imageName,{fixations.img}));
            %subj Id
            subjN=fixations(imageInd).condition(kk).subject(jj).subjNum;
            ind=find(subjNumber==subjN);
            
            %add data to trials
            Results.image(ii).condition(kk).subject(jj).img=fixations(imageInd).img;
            Results.image(ii).condition(kk).subject(jj).numPixLow=numPixLow(ii);
            Results.image(ii).condition(kk).subject(jj).numPixHigh=numPixHigh(ii);
            Results.image(ii).condition(kk).subject(jj).numPixLowandHigh=numPixLowandHigh(ii);
            Results.image(ii).condition(kk).subject(jj).numPixBackground=numPixBackground(ii);
            
            %trial number in Results_PerSubject
            tt=size(Results_PerSubj(ind).condition(kk).trial,2)+1;
            if tt==1
                Results_PerSubj(ind).condition(kk).trial=Results.image(ii).condition(kk).subject(jj);
            else
                Results_PerSubj(ind).condition(kk).trial(tt)=Results.image(ii).condition(kk).subject(jj);
            end
        end
    end
end

%check all subjects have image fixations
for ii=1:size(Results_PerSubj,2) %subjects
    for kk=1:size(Results_PerSubj(ii).condition,2) %conditions
        if size(Results_PerSubj(ii).condition(kk).trial,2)==0
            error('One of the subejcts does not have image trials left in C or U condition')
        end
    end
end

% calculate measures for each subect
for ii=1:size(Results_PerSubj,2) %subjects
    for kk=1:size(Results_PerSubj(ii).condition,2) %conditions
        %fix per pix
        Summary_PerSubj.condition(kk).FixPerPix(ii,1)=sum([Results_PerSubj(ii).condition(kk).trial.numLow])/sum([Results_PerSubj(ii).condition(kk).trial.numPixLow]);
        Summary_PerSubj.condition(kk).FixPerPix(ii,2)=sum([Results_PerSubj(ii).condition(kk).trial.numHigh])/sum([Results_PerSubj(ii).condition(kk).trial.numPixHigh]);
        Summary_PerSubj.condition(kk).FixPerPix(ii,3)=sum([Results_PerSubj(ii).condition(kk).trial.numLowandHigh])/sum([Results_PerSubj(ii).condition(kk).trial.numPixLowandHigh]);
        Summary_PerSubj.condition(kk).FixPerPix(ii,4)=sum([Results_PerSubj(ii).condition(kk).trial.numBackground])/sum([Results_PerSubj(ii).condition(kk).trial.numPixBackground]);
        
        %fix dur per pix
        sumfixdurLow=[Results_PerSubj(ii).condition(kk).trial.sumfixdurLow];
        sumfixdurHigh=[Results_PerSubj(ii).condition(kk).trial.sumfixdurHigh];
        sumfixdurLowandHigh=[Results_PerSubj(ii).condition(kk).trial.sumfixdurLowandHigh];
        sumfixdurBackground=[Results_PerSubj(ii).condition(kk).trial.sumfixdurBackground];
        numPixLow=[Results_PerSubj(ii).condition(kk).trial.numPixLow];
        numPixHigh=[Results_PerSubj(ii).condition(kk).trial.numPixHigh];
        numPixLowandHigh=[Results_PerSubj(ii).condition(kk).trial.numPixLowandHigh];
        numPixBackground=[Results_PerSubj(ii).condition(kk).trial.numPixBackground];
        
        Summary_PerSubj.condition(kk).FixDurPerPix(ii,1)=sum(sumfixdurLow(~isnan(sumfixdurLow)))/sum(numPixLow(~isnan(sumfixdurLow)));
        Summary_PerSubj.condition(kk).FixDurPerPix(ii,2)=sum(sumfixdurHigh(~isnan(sumfixdurHigh)))/sum(numPixHigh(~isnan(sumfixdurHigh)));
        Summary_PerSubj.condition(kk).FixDurPerPix(ii,3)=sum(sumfixdurLowandHigh(~isnan(sumfixdurLowandHigh)))/sum(numPixLowandHigh(~isnan(sumfixdurLowandHigh)));
        Summary_PerSubj.condition(kk).FixDurPerPix(ii,4)=sum(sumfixdurBackground(~isnan(sumfixdurBackground)))/sum(numPixBackground(~isnan(sumfixdurBackground)));
    end
end

%% Plot
regionNames={'Low','High','H&L','Background'};

%% FixPerPix
figure
for kk=1:conditions %conditions
    data=Summary_PerSubj.condition(kk).FixPerPix;
    ytext='FixPerPix';
    if kk==1
        titletext='Unconscious condition';
    else
        titletext='Conscious condition';
    end
    plotDataPerSubj(data,kk,ytext,titletext,regionNames)
end

%% FixDurPerPix
figure
for kk=1:conditions %conditions
    data=Summary_PerSubj.condition(kk).FixDurPerPix;
    ytext='FixDurPerPix';
    if kk==1
        titletext='Unconscious condition';
    else
        titletext='Conscious condition';
    end
    plotDataPerSubj(data,kk,ytext,titletext,regionNames)
end

    function plotDataPerSubj(data,kk,ytext,titletext,regionNames)
        subplot(1,2,kk)
        ymat=data;
        y=ymat(:);
        numSubj=size(ymat,1);
        xmat=repmat(1:length(regionNames),numSubj,1);
        x=xmat(:);
        scatter(x,y,50,'o','filled',...
            'MarkerEdgeColor',[0 .5 .5],...
            'MarkerFaceColor',[0 .7 .7])
        hold on
        for ll=1:numSubj %subjects
            line(1:length(regionNames), ymat(ll,:) ,'LineStyle','--')
        end
        boxplot(y,x)
        hold off
        set(gca,'XTick',1:length(regionNames))
        set(gca,'XTickLabel',regionNames)
        ylabel(ytext)
        xlabel('Regions')
        title(titletext)
        set(gca,'FontSize',20)
    end
end