function [Summary_PerSubject,Results_PerSubject]=calculationsObjectsPerSubject(Results,fixations,subjNumber,Param)
conditions=size(Results.image(1).condition,2);
%Initialize Results_PerSubject
for ii=1:length(subjNumber) %subjects
    Results_PerSubject(ii).subjNum=subjNumber(ii);
    for kk=1:conditions %conditions
        Results_PerSubject(ii).condition(kk).trial=[];
    end
end

%Fill Results_PerSubject
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
            if ~Param.IncludeObjNoAttInObj
                Results.image(ii).condition(kk).subject(jj).numPixObj=Results.image(ii).numPixObj;
            else
                Results.image(ii).condition(kk).subject(jj).numPixObj=Results.image(ii).numPixAllObj;
            end
            Results.image(ii).condition(kk).subject(jj).numPixBg=Results.image(ii).numPixBg;
            
            %trial number in Results_PerSubject
            tt=size(Results_PerSubject(ind).condition(kk).trial,2)+1;
            if tt==1
                Results_PerSubject(ind).condition(kk).trial=Results.image(ii).condition(kk).subject(jj);
            else
                Results_PerSubject(ind).condition(kk).trial(tt)=Results.image(ii).condition(kk).subject(jj);
            end
        end
    end
end

%check all subjects have image fixations
for ii=1:size(Results_PerSubject,2) %subjects
    for kk=1:size(Results_PerSubject(ii).condition,2) %conditions
        if size(Results_PerSubject(ii).condition(kk).trial,2)==0
            error('One of the subejcts does not have image trials left in C or U condition')
        end
    end
end

% calculate measures for each subect
for ii=1:size(Results_PerSubject,2) %subjects
    for kk=1:size(Results_PerSubject(ii).condition,2) %conditions
        %fix per pix
        Summary_PerSubject.condition(kk).FixPerPixObj(ii)=sum([Results_PerSubject(ii).condition(kk).trial.sumCountFixObj])/sum([Results_PerSubject(ii).condition(kk).trial.numPixObj]);
        Summary_PerSubject.condition(kk).FixPerPixBg(ii)=sum([Results_PerSubject(ii).condition(kk).trial.countFixBg])/sum([Results_PerSubject(ii).condition(kk).trial.numPixBg]);
        
        %fix dur per pix
        sumFixDurationObj=[Results_PerSubject(ii).condition(kk).trial.sumFixDurationObj];
        sumFixDurationBg=[Results_PerSubject(ii).condition(kk).trial.sumFixDurationBg];
        numPixObj=[Results_PerSubject(ii).condition(kk).trial.numPixObj];
        numPixBg=[Results_PerSubject(ii).condition(kk).trial.numPixBg];
        
        Summary_PerSubject.condition(kk).FixDurPerPixObj(ii)=sum(sumFixDurationObj(~isnan(sumFixDurationObj)))/sum(numPixObj(~isnan(sumFixDurationObj)));
        Summary_PerSubject.condition(kk).FixDurPerPixBg(ii)=sum(sumFixDurationBg(~isnan(sumFixDurationBg)))/sum(numPixBg(~isnan(sumFixDurationBg)));
    end
end

%% Plot
groupNames={'Object','Bg'};

%% FixPerPix
figure
for kk=1:conditions %conditions
    data=[Summary_PerSubject.condition(kk).FixPerPixObj',Summary_PerSubject.condition(kk).FixPerPixBg'];
    ytext='FixPerPix';
    if kk==1
        titletext='Unconscious condition';
    else
        titletext='Conscious condition';
    end
    plotDataPerSubj(data,kk,ytext,titletext,groupNames)
end

%% FixDurPerPix
figure
for kk=1:conditions %conditions
    data=[Summary_PerSubject.condition(kk).FixDurPerPixObj',Summary_PerSubject.condition(kk).FixDurPerPixBg'];
    ytext='FixDurPerPix';
    if kk==1
        titletext='Unconscious condition';
    else
        titletext='Conscious condition';
    end
    plotDataPerSubj(data,kk,ytext,titletext,groupNames)
end

  function plotDataPerSubj(data,kk,ytext,titletext,groupNames)
        subplot(1,2,kk)
        ymat=data;
        y=ymat(:);
        numSubj=size(ymat,1);
        xmat=repmat(1:length(groupNames),numSubj,1);
        x=xmat(:);
        scatter(x,y,50,'o','filled',...
            'MarkerEdgeColor',[0 .5 .5],...
            'MarkerFaceColor',[0 .7 .7])
        hold on
        for ll=1:numSubj %subjects
            line(1:length(groupNames), ymat(ll,:) ,'LineStyle','--')
        end
        boxplot(y,x)
        hold off
        set(gca,'XTick',1:length(groupNames))
        set(gca,'XTickLabel',groupNames)
        ylabel(ytext)
        xlabel('')
        title(titletext)
        set(gca,'FontSize',20)
    end
end